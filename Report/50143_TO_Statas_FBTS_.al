// PT-FBTS 25-062024
report 50148 "Trasnfer Order Status1"
{
    ApplicationArea = all;
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = Excel;
    ExcelLayout = '.vscode/Layouts/TransferOrderStatus1.xlsx';
    dataset
    {
        dataitem("Transfer Header"; "Transfer Header")
        {
            DataItemTableView = where("Direct Transfer" = const(true),
              InStoreTransfer = const(true));
            column(No_; "No.")
            {

            }
            column(Status; Status)
            {

            }
            column(Transfer_from_Code; "Transfer-from Code")
            {

            }
            column(Direct_Transfer; "Direct Transfer")
            { }
            column(Transfer_to_Code; "Transfer-to Code")
            {

            }

            column(Posting_Date; "Posting Date")
            {

            }
            column(InStoreTransfer; InStoreTransfer)
            {

            }

            //column()
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