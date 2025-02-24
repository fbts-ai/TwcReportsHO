report 50130 "Report - Statement Diff"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultRenderingLayout = TWC_CustLayout;

    dataset
    {
        dataitem("LSC Trans. Sales Entry Status"; "LSC Trans. Sales Entry Status")
        {
            dataitem(TransSalesEntry; "LSC Trans. Sales Entry")
            {
                DataItemLinkReference = "LSC Trans. Sales Entry Status";
                DataItemLink = "Transaction No." = field("Transaction No."), "Store No." = field("Store No."), "POS Terminal No." = field("POS Terminal No."), "Line No." = field("Line No.");

                dataitem("BOM Component"; "BOM Component")
                {
                    DataItemLinkReference = TransSalesEntry;
                    DataItemLink = "Parent Item No." = field("Item No.");

                    column(Date; TransSalesEntry.Date)
                    { }
                    column(POS_Terminal_No_; TransSalesEntry."POS Terminal No.")
                    { }
                    column(Parent_Item_No_; "Parent Item No.")
                    { }
                    column(No_; "No.")
                    { }
                    column(Description; Description)
                    { }
                    column(Quantity; Quantity)
                    { }
                    column(InventoryQty; Item.Inventory)
                    { }
                    column(Unit_of_Measure_Code; "Unit of Measure Code")
                    { }

                    trigger OnAfterGetRecord()
                    var
                        ItemUOM: Record "Item Unit of Measure";
                        TextVal: Text;
                    begin
                        // "No." := 'RM000204';
                        Item.SetRange("No.", "No.");
                        Item.SetFilter("Location Filter", '=%1', TransSalesEntry."Store No.");
                        IF Item.FindFirst() Then
                            Item.CalcFields(Inventory);

                        ItemUOM.Reset();
                        ItemUOM.SetRange("Item No.", "No.");
                        ItemUOM.SetRange(Code, "Unit of Measure Code");
                        IF ItemUOM.FindFirst() Then;

                        Quantity := TSE_Qty * "Quantity per" * ItemUOM."Qty. per Unit of Measure";
                        TextVal := FORMAT(Quantity);

                        Evaluate(Quantity, TextVal);

                        "Unit of Measure Code" := Item."Base Unit of Measure";
                    end;
                }

                trigger OnAfterGetRecord()
                var
                    BomComponent: Record "BOM Component";
                    ItemUOM: Record "Item Unit of Measure";
                begin
                    If Item.Get("Item No.") then;

                    ItemUOM.Reset();
                    ItemUOM.SetRange("Item No.", "Item No.");
                    ItemUOM.SetRange(Code, "Unit of Measure");
                    IF ItemUOM.FindFirst() Then;

                    //Incase of modifier changing qty value
                    IF "Parent Line No." <> 0 Then
                        Quantity := "Infocode Selected Qty.";

                    //Inorder to convert Qty 2 Base UOM
                    TSE_Qty := Quantity * ItemUOM."Qty. per Unit of Measure";

                    BomComponent.SetRange("Parent Item No.", "Item No.");
                    IF NOT BomComponent.FindFirst() then begin

                        BomComponent.Init();
                        BomComponent."Parent Item No." := "Item No.";
                        BomComponent.Description := Item.Description;
                        BomComponent."No." := "Item No.";
                        BomComponent."Quantity per" := -TSE_Qty;
                        BomComponent."Unit of Measure Code" := "Unit of Measure";
                        BomComponent.Insert();
                    end;

                end;
            }
        }
    }

    rendering
    {
        layout(TWC_CustLayout)
        {
            Type = RDLC;
            LayoutFile = '.vscode/Layouts/StatementDiff.rdl';
        }
    }

    var
        Item: Record Item;
        Quantity: Decimal;
        TSE_Qty: Decimal;
}