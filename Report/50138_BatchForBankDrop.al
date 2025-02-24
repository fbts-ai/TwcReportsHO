//AJ_ALLE_092720233
report 50138 "DNT-BnkDrp"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    ProcessingOnly = true;
    dataset
    {
        dataitem("Bank Drop Main"; "Bank Drop Main")
        {
            trigger OnAfterGetRecord()
            begin
                "Bank Drop Main".Delete();
            end;

            trigger OnPreDataItem()
            var
                myInt: Integer;
            begin
                "Bank Drop Main".SetFilter(StoreCode, '%1', SelectStore);
            end;
        }
        dataitem("Bank Drop Denomination Main"; "Bank Drop Denomination Main")
        {
            trigger OnAfterGetRecord()
            var
                myInt: Integer;
            begin
                "Bank Drop Denomination Main".Delete();
            end;

            trigger OnPreDataItem()
            var
                myInt: Integer;
            begin
                "Bank Drop Denomination Main".SetFilter(Store_No, '%1', SelectStore);
            end;
        }
        dataitem("Bank Drop Denomination Temp"; "Bank Drop Denomination Temp")
        {

            trigger OnAfterGetRecord()
            var
                myInt: Integer;
            begin
                "Bank Drop Denomination Temp".Delete();
            end;

            trigger OnPreDataItem()
            var
                myInt: Integer;
            begin
                "Bank Drop Denomination Temp".SetFilter(Store_No, '%1', SelectStore);
            end;
        }
    }
    requestpage
    {
        layout
        {
            area(Content)
            {

                field(SelectStore; SelectStore)
                {
                    ApplicationArea = all;
                    TableRelation = "LSC Store"."No.";
                }
            }
        }
    }
    trigger OnPreReport()
    var
        myInt: Integer;
    begin
        if SelectStore = '' then Error('Please Select the Store');
    end;

    var

        Store: Record "LSC Store";
        SelectStore: Code[10];
}