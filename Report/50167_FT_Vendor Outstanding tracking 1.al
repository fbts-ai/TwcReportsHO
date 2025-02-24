
report 50189 "Vendor Outstanding tracking"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    Caption = 'Vendor bill wise Payment Details';
    RDLCLayout = 'Report/Vendor ledger Entry 1.rdl';
    dataset
    {


        dataitem("Vendor Ledger Entry1"; "Detailed Vendor Ledg. Entry")
        {
            // DataItemLink = "Applied Vend. Ledger Entry No." = field("Entry No."), "Vendor Ledger Entry No." = field("Entry No.");
            DataItemTableView = where("Document Type" = const(Payment),
              "Entry Type" = const(Application), Unapplied = const(false));
            //CalcFields = Amount;
            column(Amount_; Amount)
            { }
            column(Posting_Date_; "Posting Date")
            { }
            column(Document_Type; "Document Type")
            { }
            column(DocumentNo_DetailedVendorLedgEntry; "Document No.")
            { }
            dataitem("Vendor Ledger Entry"; "Vendor Ledger Entry")
            {
                //RequestFilterFields = "Posting Date", "Vendor No.", "Document No.";
                DataItemTableView = where("Document Type" = filter('invoice'));
                DataItemLink = "Entry No." = field("Applied Vend. Ledger Entry No."),
                "Entry No." = field("Vendor Ledger Entry No.");
                CalcFields = Amount;
                column(Document_No_; "Document No.")
                {

                }
                column(Entry_No_; "Entry No.")
                { }
                column(Posting_Date; "Posting Date")
                {

                }
                column(Vendor_Name; "Vendor Name")
                {

                }

                column(External_Document_No_; "External Document No.")
                {

                }
                column(Vendor_Invoice_Date; "Document Date") { }
                column(Document_Date; "Document Date")
                {
                }
                column(DelaysDate; DelaysDate)
                { }
                column(Due_Date; "Due Date")
                {

                }
                column(Remaining_Amount; "Remaining Amount")
                { }
                column(Amount; Amount)
                { }
                column(PaymentTrams; VendorRec."Payment Terms Code")
                { }
                trigger OnAfterGetRecord()
                var
                    myInt: Integer;
                begin
                    DelaysDate := 0;
                    DelaysDate := "Vendor Ledger Entry"."Due Date" - "Vendor Ledger Entry1"."Posting Date";
                    if DelaysDate > 0 then
                        DelaysDate := 0
                    ELSE
                        DelaysDate := DelaysDate;

                    // if   "Vendor Ledger Entry"."Due Date" - "Vendor Ledger Entry1"."Posting Date" then
                    // if DelaysDate=
                end;

                trigger OnPreDataItem()
                var
                    myInt: Integer;
                begin
                    "Vendor Ledger Entry".SetFilter("Vendor Ledger Entry"."Posting Date", '%1..%2', dtFromDate, dtTillDate);
                end;
            }
            trigger OnAfterGetRecord()
            var
            begin
                VendorRec.Get("Vendor No.");
                Clear(PaymentAmount);
                Clear(PaymentDate);
                //  Message('%1', "Vendor Ledger Entry1".Amount);
                // Clear(DelaysDate);
                // // if "Vendor Ledger Entry1"."Posting Date" > "Vendor Ledger Entry"."Posting Date" then begin
                // Message('%1', DelaysDate);
                // DelaysDate := CalcDate("Vendor Ledger Entry"."Posting Date" - "Vendor Ledger Entry1"."Posting Date");
                // Message('%1', DelaysDate);
            end;
            // end;
            trigger OnPreDataItem()
            var
                myInt: Integer;
            begin
                if "cdVendorNo." <> '' then
                    "Vendor Ledger Entry1".SetRange("Vendor Ledger Entry1"."Vendor No.", "cdVendorNo.");

                // if (dtFromDate = 0D) or (dtTillDate = 0D) then
                //     Error('From Date or Till Date cannot be empty.');

                // if dtFromDate < 20180401D then
                //     Error('From Date should be greater than 31/03/18.');

            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                    field("Vendor No."; "cdVendorNo.")
                    {
                        ApplicationArea = all;
                        TableRelation = Vendor."No.";
                    }
                    field("From Date"; dtFromDate)
                    {
                        ApplicationArea = all;
                        Caption = 'satrt Date';
                    }
                    field("Till Date"; dtTillDate)
                    {
                        ApplicationArea = all;
                        Caption = 'End Date';
                    }
                }
            }
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

        // end;
    }



    var
        VendorRec: Record Vendor;
        DelaysDate: Integer;
        "cdVendorNo.": Code[20];
        vendoerLedgerEntry: Record "Vendor Ledger Entry";
        PaymentAmount: Decimal;
        PaymentDate: Date;
        dtFromDate: Date;
        dtTillDate: Date;
        detailVendoerLedgerEntry: Record 380;
        TempVendorLedEntry: Record "Vendor Ledger Entry";
        Day: Integer;

}