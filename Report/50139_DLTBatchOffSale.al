//AJ_ALLE_092720233
//DONOTSENDONPROD++++
report 50139 "DNT-DLTItemJounBatch"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    ProcessingOnly = true;
    Permissions = tabledata "Item Journal Line" = d;
    dataset
    {
        dataitem("Item Journal Line"; "Item Journal Line")
        {
            RequestFilterFields = "Journal Template Name", "Journal Batch Name";
            trigger OnAfterGetRecord()
            begin
                // if ("Item Journal Line"."Journal Template Name" = 'ITEM') and ("Item Journal Line"."Journal Batch Name" = 'OFFSALE') then
                "Item Journal Line".DeleteAll();

            end;

            trigger OnPreDataItem()
            var
                myInt: Integer;
            begin
                //  "Bank Drop Main".SetFilter(StoreCode, '%1', SelectStore);
            end;
        }

    }
    requestpage
    {
        layout
        {
            area(Content)
            {

                // field(SelectStore; SelectStore)
                // {
                //     ApplicationArea = all;
                //     TableRelation = "LSC Store"."No.";
                // }
            }
        }
    }
    trigger OnPreReport()
    var
        myInt: Integer;
    begin

    end;

    var

        Store: Record "LSC Store";
        SelectStore: Code[10];
}