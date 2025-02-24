report 50190 "Pinelabs Offline Report"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    RDLCLayout = 'Report/PinelabsOfflineReport.rdl';
    DefaultLayout = RDLC;
    dataset
    {
        dataitem("LSC Transaction Header"; "LSC Transaction Header")
        {
            RequestFilterFields = Date, "Store No.";
            column(Receipt_No_; "Receipt No.") { }
            column(Store_No_; "Store No.") { }
            column(Payment; Payment) { }
            column(Date; Date) { }
            column(Information; Information) { }
            column(Infocode; Infocode) { }
            column(TransactionType; TransactionType) { }
            trigger OnAfterGetRecord()
            var
                myInt: Integer;
            begin
                // Clear(Infocode);
                // Clear(Information);
                // Clear(TransactionType);
                lscTransInfocodeEntry.Reset();
                lscTransInfocodeEntry.SetRange("Store No.", "LSC Transaction Header"."Store No.");
                lscTransInfocodeEntry.SetRange("POS Terminal No.", "LSC Transaction Header"."POS Terminal No.");
                lscTransInfocodeEntry.SetRange("Transaction No.", "LSC Transaction Header"."Transaction No.");
                lscTransInfocodeEntry.SetRange("Transaction Type", lscTransInfocodeEntry."Transaction Type"::"Sales Entry");
                if lscTransInfocodeEntry.FindSet() then
                    repeat
                        // if lscTransInfocodeEntry.Infocode <> 'TEXT' then
                        //     CurrReport.Skip();
                        Information := lscTransInfocodeEntry.Information;
                        infocode := lscTransInfocodeEntry.Infocode;
                        TransactionType := Format(lscTransInfocodeEntry."Transaction Type");
                    until lscTransInfocodeEntry.Next() = 0;
            end;
        }
    }
    requestpage
    {
        layout
        {
            area(Content)
            { }
        }
        actions
        {
            area(processing)
            {
                action(ActionName)
                {
                    ApplicationArea = All;
                }
            }
        }
    }
    var
        lscTransInfocodeEntry: Record "LSC Trans. Infocode Entry";
        lscTransInfocodeEntry1: Record "LSC Trans. Infocode Entry";
        Information: Text[100];
        Infocode: code[20];
        TransactionType: Text[100];
}