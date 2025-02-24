report 50129 "Report - TaxInvoice B2B"
{
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = '.vscode/Layouts/TaxInvoiceB2bLayout.rdl';
    ApplicationArea = All;
    dataset
    {
        dataitem("Sales Invoice Header"; "Sales Invoice Header")
        {
            RequestFilterFields = "No.";
            PrintOnlyIfDetail = true;
            CalcFields = "QR Code";

            // column(CompanyAddr; CompanyAddr[1])
            // { }
            column(CompanyAddr; CompanyInfo.Name)
            { }
            column(Order_No_; "Order No.")
            {
            }
            // column(CompanyAddr_full; CompanyAddr_full)
            // { } //PT-FBTS- 
            column(CompanyAddr_full; Location_gRec.Address + ' ' + Location_gRec."Address 2" + ' ' +
              Location_gRec.City + ' ' + Location_gRec."Phone No." + ' ' + Location_gRec."Post Code")
            { }
            // column(Company_State; Company_State)
            // { }
            column(Company_State; State1.Description)
            { }
            // column(CompanyGstRegNo; CompanyInfo."GST Registration No.")
            // { }
            column(CompanyGstRegNo; Location_gRec."GST Registration No.")
            { }
            column(CompanyPan; CompanyPan)
            { }
            column(CompanyLogo; CompanyInfo.Picture)
            { }
            column(QRCode; EinoiceEntry."Einvoice QR Code")
            { }
            column(Bill_to_Name; "Bill-to Name")
            { }
            column(Billto_Addr_full; Billto_Addr_full)
            { }
            column(Billto_State; Billto_State)
            { }
            column(Customer_GST_Reg__No_; "Customer GST Reg. No.")
            { }
            column(Billto_Pan; Billto_Pan)
            { }

            column(Ship_to_Name; "Ship-to Name")
            { }
            column(Shipto_Addr_full; Shipto_Addr_full)
            { }
            column(Shipto_State; Shipto_State)
            { }
            column(Ship_to_GST_Reg__No_; "Ship-to GST Reg. No.")
            { }
            column(Shipto_Pan; Shipto_Pan)
            { }
            column(InvoiceNo; "No.")
            { }
            column(Posting_Date; "Posting Date")
            { }
            column(IRN_Hash; "Sales Invoice Header"."IRN Hash")
            { }
            column(User_ID; "User ID")
            { }
            column(Payment_Terms_Code; "Payment Terms Code")
            { }
            column(CompBankName; CompanyInfo."Bank Name")
            { }
            column(CompBankAccNo; CompanyInfo."Bank Account No.")
            { }
            column(CompIfsc; CompanyInfo."Payment Routing No.")
            { }
            dataitem("Sales Invoice Line";
            "Sales Invoice Line")
            {
                DataItemLinkReference = "Sales Invoice Header";
                DataItemLink = "Document No." = Field("No.");
                column(Sr_No; Sr_No)
                { }
                column(Material_Code; "No.")
                { }
                column(Description; Description)
                { }
                column(HSN_SAC_Code; "HSN/SAC Code")
                { }
                column(Unit_of_Measure; "Unit of Measure Code")
                { }
                column(Quantity; Quantity)
                { }
                column(Shipment_Date; "Shipment Date")
                { }
                column(Unit_Price; "Unit Price")
                { }
                column(Taxable_Amount; "Line Amount")
                { }
                column(SGST_Rate; SGST_Rate)
                { }
                column(SalesLineSGST; ABS(SalesLineSGST))
                { }
                column(CGST_Rate; CGST_Rate)
                { }
                column(SalesLineCGST; ABS(SalesLineCGST))
                { }
                column(IGST_Rate; IGST_Rate)
                { }
                column(SalesLineIGST; ABS(SalesLineIGST))
                { }
                column(Amount; TotalAmount)
                { }

                trigger OnAfterGetRecord()
                begin
                    Sr_No += 1;
                    CalculateGST("Sales Invoice Line");
                    TotalAmount := "Line Amount" + ABS(SalesLineCGST) + ABS(SalesLineSGST) + ABS(SalesLineIGST);
                end;
            }

            trigger OnAfterGetRecord()
            var
                TempText: Text;
                State: Record State;
            begin
                if "No." = '' then
                    Error('Please Select Invoice No.');

                Billto_Addr_full := "Bill-to Address" + '; ' + "Bill-to Address 2" + ' ' + "Bill-to Post Code";
                if State.Get("GST Bill-to State Code") then;
                Billto_State := State.Description;
                // Billto_Pan := Format("Customer GST Reg. No.").Substring(3, 10); //Commented As Giving Error
                Billto_Pan := CopyStr("Customer GST Reg. No.", 3, 10); //AJ_ALLE_11012024

                if "Ship-to Post Code" = "Bill-to Post Code" Then begin
                    Shipto_Addr_full := Billto_Addr_full;
                    Shipto_State := Billto_State;
                    "Ship-to GST Reg. No." := "Customer GST Reg. No.";
                    Shipto_Pan := Billto_Pan;
                end
                Else begin
                    if "Ship-to Address" <> '' then
                        Shipto_Addr_full := "Ship-to Address" + '; ' + "Ship-to Address 2";

                    if State.Get("GST Ship-to State Code") then;
                    Shipto_State := State.Description;

                    if "Ship-to GST Reg. No." <> '' then
                        //Shipto_Pan := Format("Ship-to GST Reg. No.").Substring(3, 10); //Commented As Giving Error
                        Shipto_Pan := CopyStr("Ship-to GST Reg. No.", 3, 10); //AJ_ALLE_11012024
                end;

                Location_gRec.Get("Sales Invoice Header"."Location Code");//PT-FBTS
                State1.Get(Location_gRec."State Code");
                EinoiceEntry.Reset();
                EinoiceEntry.SetRange("Invoice No.", "Sales Invoice Header"."No.");
                if EinoiceEntry.FindFirst() then
                    EinoiceEntry.CalcFields("Einvoice QR Code");

            end;
        }
    }

    trigger OnInitReport()
    var
        State: Record State;
    begin
        CompanyInfo.Get();
        CompanyInfo.CalcFields(Picture);
        FormatAddr.Company(CompanyAddr, CompanyInfo);
        //CompanyAddr_full := CompanyAddr[2] + '; ' + CompanyAddr[3] + '; ' + CompanyAddr[4];

        State.Reset();
        State.Get(CompanyInfo."State Code");
        Company_State := State.Description;
        //CompanyPan := Format(CompanyInfo."GST Registration No.").Substring(3, 10); //Commented As Giving Error
        CompanyPan := CopyStr(CompanyInfo."GST Registration No.", 3, 10);//AJ_ALLE_11012024
    end;

    var
        CompanyInfo: Record "Company Information";
        ShipAgent: Record "Shipping Agent";
        CompanyAddr: array[8] of Text[100];
        CompanyAddr_full: Text;
        Company_State: Text;
        CompanyPan: Code[20];
        State1: Record State;
        FormatAddr: Codeunit "Format Address";
        Billto_Addr_full: Text;
        Billto_State: Text;
        Billto_Pan: Code[20];
        Shipto_Addr_full: Text;
        Shipto_State: Text;
        Shipto_Pan: Code[20];
        Location_gRec: Record Location; //PT-FBTS
        EinoiceEntry: Record "E-Invoice Log Entry";
        //Loc
        Sr_No: Integer;
        SalesLineCGST: Decimal;
        CGST_Rate: Decimal;
        SalesLineSGST: Decimal;
        SGST_Rate: Decimal;
        SalesLineIGST: Decimal;
        IGST_Rate: Decimal;
        TotalAmount: Decimal;

    procedure CalculateGST(SL: Record "Sales Invoice Line")
    var
        SAlesInvLine: Record "Sales Invoice Line";
        TaxTransactionValue: Record "Tax Transaction Value";
        TaxTypeObjHelper: Codeunit "Tax Type Object Helper";
    begin
        //if PurchaseLine.Get(PL."Document Type", PL."Document No.", PL."Line No.") then
        //  TaxRecordID := PurchaseLine.RecordId();
        //ComponentAmt := 0;
        Clear(IGST_Rate);
        Clear(CGST_Rate);
        Clear(SGST_Rate);
        Clear(SalesLineCGST);
        Clear(SalesLineSGST);
        Clear(SalesLineIGST);
        TaxTransactionValue.Reset();
        TaxTransactionValue.SetFilter("Tax Record ID", '%1', SL.RecordId);
        TaxTransactionValue.SetFilter("Value Type", '%1', TaxTransactionValue."Value Type"::Component);
        TaxTransactionValue.SetRange("Visible on Interface", true);
        TaxTransactionValue.SetFilter("Tax Type", '%1|%2', 'GST', 'TCS');
        TaxTransactionValue.SetFilter("Value ID", '%1|%2|%3', 2, 3, 6);
        if TaxTransactionValue.FindSet() then
            repeat
                if TaxTransactionValue."Tax Type" = 'GST' then begin
                    if TaxTransactionValue."Value ID" = 2 then begin
                        CGST_Rate := TaxTransactionValue.Percent;
                        SalesLineCGST := TaxTypeObjHelper.GetComponentAmountFrmTransValue(TaxTransactionValue);
                    end;
                    if TaxTransactionValue."Value ID" = 3 then begin
                        IGST_Rate := TaxTransactionValue.Percent;
                        SalesLineIGST := TaxTypeObjHelper.GetComponentAmountFrmTransValue(TaxTransactionValue);
                    end;
                    if TaxTransactionValue."Value ID" = 6 then begin
                        SGST_Rate := TaxTransactionValue.Percent;
                        SalesLineSGST := TaxTypeObjHelper.GetComponentAmountFrmTransValue(TaxTransactionValue);
                    end;

                end;
            // if TaxTransactionValue."Tax Type" = 'TCS' then
            //     TotalTCS += TaxTypeObjHelper.GetComponentAmountFrmTransValue(TaxTransactionValue);

            until TaxTransactionValue.Next() = 0;
    end;
}