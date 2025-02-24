report 50131 "Report - Label Print"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultRenderingLayout = TWC_CustLayout;

    dataset
    {
        dataitem("Production Order"; "Production Order")
        {
            column(CompanyName; CompanyInfo.Name)
            { }
            column(No_; "No.")
            { }

            dataitem("Prod. Order Line"; "Prod. Order Line")
            {
                DataItemLinkReference = "Production Order";
                DataItemLink = "Prod. Order No." = field("No.");

                column(Description; Description)
                { }
                column(BatchNo; BatchNo)
                { }
                column(BestBfr; BestBfr)
                { }
                column(Store; StoreDimension.Name)
                { }
                column(Quantity; Quantity)
                { }
                column(Storage; Storage)
                { }

                trigger OnAfterGetRecord()
                var
                    ItemLedgEntry: Record "Item Ledger Entry";
                begin
                    ItemLedgEntry.Reset();
                    ItemLedgEntry.SetRange("Entry Type", ItemLedgEntry."Entry Type"::Output);
                    ItemLedgEntry.SetRange("Document No.", "Prod. Order No.");
                    IF ItemLedgEntry.FindLast() Then;

                    BatchNo := ItemLedgEntry."Lot No.";
                    IF CustQty <> 0 Then
                        Quantity := CustQty;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                CompanyInfo.Get();

                StoreDimension.Reset();
                StoreDimension.SetRange(Code, "Shortcut Dimension 2 Code");
                IF StoreDimension.FindFirst() THEN;
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
                group(Input)
                {
                    field(BestBfr; BestBfr)
                    {
                        Caption = 'Best Before: ';
                        ApplicationArea = All;
                    }
                    field(CustQty; CustQty)
                    {
                        Caption = 'Quantity: ';
                        ApplicationArea = All;
                    }
                    field(Storage; Storage)
                    {
                        Caption = 'Storage in: ';
                        ApplicationArea = All;
                    }
                }
            }
        }
    }

    rendering
    {
        layout(TWC_CustLayout)
        {
            Type = RDLC;
            LayoutFile = '.vscode/Layouts/LabelPrint.rdl';
        }
    }

    trigger OnInitReport()
    begin
        Storage := '0-5 C';
    end;

    var
        CompanyInfo: Record "Company Information";
        StoreDimension: Record "Dimension Value";
        Item: Record Item;
        BatchNo: Code[20];
        BestBfr: Date;
        CustQty: Decimal;
        Storage: Text;
}