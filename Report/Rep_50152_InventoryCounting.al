//SKS_ALLE_02-02-2024
report 50152 "Inventory Counting Report"
{
    Caption = 'Inventory Counting Report';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = all;
    DefaultLayout = Excel;
    ExcelLayout = '.vscode/Layouts/InventoryCountingReport.xlsx';

    dataset
    {
        dataitem(StockAuditHeader; StockAuditHeader)
        {
            RequestFilterFields = "Posting date", Status;

            column(No; "No.") { }
            column(Location_Code; "Location Code") { }
            column(Requested_Delivery_Date; "Posting date") { }
            column(Created_Date; "Created Date") { }
            column(Created_By; CreatedBy) { }
            column(Status; Status) { }


            trigger OnAfterGetRecord()
            begin
                // StockAuditHeader.SetRange("Posting date", Req_Delivery_Date);
            end;

            trigger OnPreDataItem()
            begin
            end;
        }

    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                // group(Option)
                // {
                //     field(Req_Delivery_Date; StockAuditHeader."Posting date")
                //     {
                //         ApplicationArea = all;

                //     }
                // }
            }
        }
    }

    var
        Req_Delivery_Date: date;
}