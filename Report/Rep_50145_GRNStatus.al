//Sundram_20_02_2024
report 50145 "GRN Status"
{
    ApplicationArea = all;
    ProcessingOnly = true;
    Caption = 'GRN Status Report';
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Purchase Header"; "Purchase Header")
        {
            DataItemTableView = where(Status = filter("Released"), "Completely Received" = const(false), "Document Type" = filter("Order"), ShortClosed = const(false));
            CalcFields = "Partially Invoiced", "Completely Received";
            RequestFilterFields = "Order Date", "Partially Invoiced", "Location Code";

            trigger OnAfterGetRecord()
            var
                PurchaseLine: Record "Purchase Line";
                Item: Record Item;
            begin
                PurchaseLine.SetRange("Document No.", "Purchase Header"."No.");
                PurchaseLine.SetRange(Type, LineType);
                if PurchaseLine.FindFirst() then begin
                    if PurchaseLine.Type = PurchaseLine.Type::Item then begin
                        Item.SetRange("No.", PurchaseLine."No.");
                        Item.SetRange(Type, InventoryType);
                        if Item.FindFirst() then
                            MakeExcelDataBody();
                    end else
                        MakeExcelDataBody();
                end;
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(Content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(Type; LineType)
                    {
                        Caption = 'Type';
                        ApplicationArea = Basic, Suite;
                        ToolTip = 'Specifies the Type of Purchase Line.';
                    }
                    field(InventoryType; InventoryType)
                    {
                        Caption = 'Inventory Type';
                        ApplicationArea = Basic, Suite;
                        ToolTip = 'Specifies the Inventory Type of Item, Applicable only when Type = Item.';
                    }
                }
            }
        }
    }

    trigger OnPreReport()
    begin
        MakeExcelDataHeader();
    end;

    trigger OnPostReport()
    begin
        CreateExcelBook();
    end;

    var
        ExcelBuf: Record "Excel Buffer" temporary;
        LineType: Enum "Purchase Line Type";
        InventoryType: Enum "Item Type";

    local procedure MakeExcelDataHeader()
    begin
        AddTextColumn('Document Type');
        AddTextColumn('No.');
        AddTextColumn('Vendor No');
        AddTextColumn('Vendor Name');
        AddTextColumn('Location Code');
        AddTextColumn('Order Date');
        AddTextColumn('Completely Received');
        AddTextColumn('Partially Invoiced');
        AddTextColumn('Status');
    end;

    procedure MakeExcelDataBody()
    begin
        ExcelBuf.NewRow();
        AddTextColumn("Purchase Header"."Document Type");
        AddTextColumn("Purchase Header"."No.");
        AddTextColumn("Purchase Header"."Buy-from Vendor No.");
        AddTextColumn("Purchase Header"."Buy-from Vendor Name");
        AddTextColumn("Purchase Header"."Location Code");
        ExcelBuf.AddColumn("Purchase Header"."Order Date", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Date);
        AddTextColumn("Purchase Header"."Completely Received");
        AddTextColumn("Purchase Header"."Partially Invoiced");
        AddTextColumn("Purchase Header".Status);
    end;

    local procedure AddTextColumn(Value: Variant)
    begin
        ExcelBuf.AddColumn(Value, false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
    end;

    procedure CreateExcelBook()
    var
        CurrDateTime: DateTime;
    begin
        CurrDateTime := CurrentDateTime;
        ExcelBuf.CreateNewBook('GRN Status Report');
        ExcelBuf.WriteSheet('GRN Status Report', COMPANYNAME, USERID);
        ExcelBuf.CloseBook();
        ExcelBuf.SetFriendlyFilename('GRN Status Report ' + Format(CurrDateTime));
        ExcelBuf.OpenExcel();
    end;
}