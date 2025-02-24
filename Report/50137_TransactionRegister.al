//AJ_Alle_09192023+
report 50137 "Pending Sale Post (Store Wise)"
{
    ApplicationArea = all;
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = '.vscode/Layouts/TransactionReport1 copy.rdl';

    dataset
    {
        dataitem("LSC Transaction Header"; "LSC Transaction Header")
        {
            DataItemTableView = SORTING(Date, "Store No.", "Staff ID") order(ascending) where("Entry Status" = filter(" " | "Posted"), "Posted Statement No." = filter(''), "Net Amount" = filter(<> 0));
            // DataItemTableView = where("Entry Status" = filter(= 'Posted'));SORTING("Store No.", Date) 
            RequestFilterFields = Date, "Statement No.";
            column(Skip; Skip)
            {
            }
            // column(TotalAmmountChange; TotalAmmountChange)
            // {

            // }
            column(Count1; Count1)
            {

            }
            column(Selectdate; Date)
            {

            }
            column(Store_No_; "Store No.")
            {

            }
            column(Staff_ID; "Staff ID")
            {

            }
            // column(NetAmmountChange; NetAmmountChange)
            // {

            // }
            column(NetAmmountChange; "Net Amount")
            {

            }
            column(StaffName; StaffName)
            {

            }
            column(StoreName; StoreName)
            {

            }
            // column(Document_No_; QueRec."Document No.")
            // {

            // }
            column(Document_No_; DocumentNo)
            {

            }
            column(ForChange; ForChange)
            {

            }
            // }
            //AJ_ALLE_23012023
            // dataitem("LSC Batch Posting Queue"; "LSC Batch Posting Queue")

            // {
            //     DataItemLink = "Document No." = field("Statement No.");
            //     DataItemTableView = where(Status = filter('<>Finished'));
            //     column(Document_No_; "Document No.")
            //     {

            //     }
            // }
            //AJ_ALLE_23012023
            trigger OnPreDataItem()
            var
                myInt: Integer;
                Lscstore: Record "LSC Retail User";
            begin
                //ALLE_NICK_111623_START
                //  "LSC Transaction Header".SetFilter("Posted Statement No.", '%1', '');
                //Clear(SelectStore);
                // "LSC Transaction Header".SetFilter(Date, '%1', Selectdate);
                Lscstore.Get(UserId);
                //SelectStore := Lscstore."Store No.";
                if not Lscstore."POS Super User" then begin
                    "LSC Transaction Header".SetFilter("Store No.", '%1', Lscstore."Store No.");
                end;
                //ALLE_NICK_111623_END
                Clear(ForChange);

                //CalcFields("LSC Transaction Header"."Statement No.");
            end;

            trigger OnAfterGetRecord()
            var
                myInt: Integer;
            begin
                Clear(DocumentNo);
                Clear(ForChange);
                Clear(StaffName);
                Clear(StoreName);

                CalcFields("LSC Transaction Header"."Statement No.");
                QueRec.SetFilter("Document No.", '<>%1', '');
                QueRec.SetRange("Document No.", "LSC Transaction Header"."Statement No.");//'S042000085'
                QueRec.SetFilter(Status, '<>%1', QueRec.Status::Finished);
                if QueRec.FindFirst() then begin
                    DocumentNo := QueRec."Document No.";
                    LSCStatement.SetCurrentKey("No.", "Store No.");
                    LSCStatement.SetRange("No.", QueRec."Document No.");
                    if LSCStatement.FindSet() then
                        repeat
                            LSCStatement.CalcFields("Sales Amount");
                            ForChange += LSCStatement."Sales Amount";
                        until LSCStatement.Next() = 0;
                end;


                if LscStaff.Get("LSC Transaction Header"."Staff ID") then
                    StaffName := LscStaff."Name on Receipt";

                if LscStore.Get("LSC Transaction Header"."Store No.") then
                    StoreName := LscStore.Name;
            end;
        }
    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                // field("Select Date"; Selectdate)
                // {
                //     ApplicationArea = all;

                // }
                field(SelectStore; SelectStore)
                {
                    ApplicationArea = all;
                    Visible = false;
                    TableRelation = "LSC Store";
                    Editable = false;


                }
                // field(ForAll; ForAll)
                // {
                //     ApplicationArea = all;
                //     Caption = 'Not Mandatory';

                // }
            }

        }
    }
    labels
    {
    }

    trigger OnPostReport()
    begin

    end;

    trigger OnPreReport()
    var
        Lscstore: Record "LSC Retail User";

    begin
        //ALLE_NICK_111623_START
        // NextStore := '';
        // StaffId := '';
        // CompanyInfo.GET;
        // if Selectdate = 0D then Selectdate := Today;

        // // if ForAll = true then begin
        // //     SelectStore := '';
        // // end else begin
        // if UserSetup.Get(UserId) then begin
        //     if UserSetup."Location Code" = '' then begin
        //         SelectStore := '';
        //     end else begin
        //         SelectStore := UserSetup."Location Code";
        //     end;
        // end;
        // Lscstore.Get(UserId);
        // SelectStore := Lscstore."Store No.";
        //ALLE_NICK_111623_END
    end;
    // end;

    var
        CompanyInfo: Record "Company Information";
        Selectdate: Date;
        NetAmmountChange: Decimal;
        LSCTranRegs: Record "LSC Transaction Header";
        LSCTranRegs1: Record "LSC Transaction Header";
        LSCTranRegs2: Record "LSC Transaction Header";
        SelectStore: Code[20];
        Skip: Boolean;
        LscStaff: Record "LSC Staff";
        StaffName: Text[200];
        LscStore: Record "LSC Store";
        StoreName: text[200];
        UserSetup: Record "User Setup";
        // ForAll: Boolean;
        Count1: Integer;
        // TotalAmmountChange: Decimal;

        NextStore: Code[10];
        StaffId: Code[20];
        DocumentNo: Code[20];
        QueRec: Record "LSC Batch Posting Queue";
        ForChange: Decimal;
        LSCStatement: Record "LSC Statement";

}

