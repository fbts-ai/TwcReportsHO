report 50156 "Inv_Stock_Report"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    Caption = 'Item Wise Inventory counting Report';
    DefaultLayout = RDLC;
    RDLCLayout = 'Report/Inv_Stock_Report.rdl';
    dataset
    {
        dataitem(StockAuditHeader; StockAuditHeader)
        {
            RequestFilterFields = "Location Code", "Posting date";
            column(No_; "No.")
            {
            }
            column(Created_Date; "Created Date")
            { }
            column(CreatedBy; CreatedBy)
            { }
            column(Location_Code; "Location Code")
            { }
            column(TotalStockValue; TotalStockValue)
            { }
            column(Status; Status)
            { }
            column(Sand_Date_Time; "Sand Date&Time")
            { }
            column("Inventory_Type"; "Inventory Type")
            { }
            dataitem(StockAuditLine; StockAuditLine)
            {
                DataItemLink = "DocumentNo." = field("No.");
                DataItemLinkReference = StockAuditHeader;
                column(system_value; UnitPrice)
                { }
                column(Item_Code; "Item Code")
                { }
                column(Description; Description)
                { }
                column(Unit_of_Measure_Code; "Unit of Measure Code")
                { }
                column(StockQty; StockQty)
                { }
                column(Phys__Inventory; "Phys. Inventory")
                { }
                column(Qty___Calculated_; "Qty. (Calculated)")
                { }
                column(Amount; Amount)
                { }
                column(Physical_Value; UnitPrice * "Qty. (Phys. Inventory)")
                { }

            }
            trigger OnPreDataItem()
            var
                myInt: Integer;
            begin
                // StockAuditHeader.SetRange("Location Code", store);
            end;
        }
    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                    field(store; store)
                    {
                        ApplicationArea = all;
                        Editable = false;
                    }
                }
            }
        }
        actions
        {
            area(processing)
            {
                action(LayoutName)
                {

                }
            }
        }
    }
    var
        myInt: Integer;
        RetailUser: Record "LSC Retail User";
        store: Code[20];

    trigger OnInitReport()
    var
        lFilterGroup: Integer;
    begin
        // lFilterGroup := StockAuditHeader.FilterGroup;//PT FBTS
        // StockAuditHeader.FilterGroup(10);
        // if RetailUser.Get(UserId) then
        //     if RetailUser."Store No." <> '' then
        //         store := RetailUser."Store No.";
    end;
}