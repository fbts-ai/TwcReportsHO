//AJ_ALLE_25012024
report 50143 "Trasnfer Order Status"
{
    ApplicationArea = all;
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = Excel;
    ExcelLayout = '.vscode/Layouts/TransferOrderStatus.xlsx';
    dataset
    {
        dataitem("Transfer Header"; "Transfer Header")
        {
            DataItemTableView = where("Completely Shipped" = const(true), "In-Transit Code" = filter('INTRANSIT1'));
            column(No_; "No.")
            {

            }
            column(Status; Status)
            {

            }
            column(In_Transit_Code; "In-Transit Code")
            {

            }
            column(Transfer_from_Code; "Transfer-from Code")
            {

            }
            column(Transfer_to_Code; "Transfer-to Code")
            {

            }
            column(Posting_Date; "Posting Date")
            {

            }
            trigger OnAfterGetRecord()
            begin
            end;

            trigger OnPreDataItem()
            var
                myInt: Integer;
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


            }
        }
    }
    trigger OnPreReport()
    var
        myInt: Integer;
    begin

    end;

    var

}