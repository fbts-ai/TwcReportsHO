report 50127 "Report - Delivery Challan"
{
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = '.vscode/Layouts/DeliveryChallanLayout.rdl';
    ApplicationArea = All;

    dataset
    {
        dataitem("Transfer Shipment Header"; "Transfer Shipment Header")
        {
            RequestFilterFields = "No.";
            CalcFields = "QR Code";
            //AJ_Alle_04102023  

            column(Transfer_Order_No_; "Transfer Order No.")
            {
            }
            //AJ_Alle_04102023
            column(ChallanTitle; ChallanTitle)
            { }
            column(InvDoc; InvDoc) //PT-fbts
            { }
            column(Company_Logo; CompanyInfo.Picture)
            { }
            column(Company_Name; CompanyInfo.Name)
            { }
            column(No_; "No.")
            { }
            column(Posting_Date; "Posting Date")
            { }
            column(From_fullName; From_fullName)
            { }
            column(From_fullAddr; From_fullAddr)
            { }
            column(From_GstRegNo; From_GstRegNo)
            { }
            column(From_State; From_State)
            { }
            column(From_Pan; From_Pan)
            { }
            column(To_fullName; To_fullName)
            { }
            column(To_fullAddr; To_fullAddr)
            { }
            column(To_GstRegNo; To_GstRegNo)
            { }
            column(To_State; To_State)
            { }
            column(To_Pan; To_Pan)
            { }
            column(E_Way_Bill_No_; "E-Way Bill No.")
            { }
            column(IRN_Hash; "IRN Hash")
            { }
            column(QR_Code; EinoiceEntry."Einvoice QR Code")
            { }
            column(AgentName; ShipAgent.Name)
            { }
            column(Mode_of_Transport; ModeOfTransport)
            { }
            column(Vehicle_No_; "Vehicle No.")
            { }
            column(Distance__Km_; "Distance (Km)")
            { }
            column(LR_RR_Date; "LR/RR Date")
            { }
            column(LR_RR_No_; "LR/RR No.")
            { }
            column(Agent_Addr; ShipAgent."Internet Address")
            { }

            dataitem("Transfer Shipment Line"; "Transfer Shipment Line")
            {
                DataItemLinkReference = "Transfer Shipment Header";
                DataItemLink = "Document No." = Field("No.");

                column(Sr_No; Sr_No)
                { }
                column(Material_Code; "Item No.")
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
                column(Taxable_Amount; Amount)
                { }
                column(SGST_Rate; SGST_Rate)
                { }
                column(FixedAssetNo; FixedAssetNo) //PT-FBTS -19-06-2024
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
                    CalculateGST("Transfer Shipment Line");

                    TotalAmount := Amount + ABS(SalesLineCGST) + ABS(SalesLineSGST) + ABS(SalesLineIGST);
                end;
            }

            trigger OnAfterGetRecord()
            begin
                From_fullName := "Transfer-from Name" + ' ' + "Transfer-from Name 2";
                To_fullName := "Transfer-to Name" + ' ' + "Transfer-to Name 2";

                From_fullAddr := "Transfer-from Address" + '; ' + "Transfer-from Address 2";
                To_fullAddr := "Transfer-to Address" + '; ' + "Transfer-to Address 2";

                IF Location.Get("Transfer-from Code") Then begin
                    From_GstRegNo := Location."GST Registration No.";
                    IF From_GstRegNo <> '' Then
                        From_Pan := Format(From_GstRegNo).Substring(3, 10);
                end;

                IF State.Get(Location."State Code") Then
                    From_State := State.Description;

                IF Location.Get("Transfer-to Code") Then begin
                    To_GstRegNo := Location."GST Registration No.";
                    IF To_GstRegNo <> '' Then
                        To_Pan := Format(To_GstRegNo).Substring(3, 10);
                end;

                IF State.Get(Location."State Code") Then
                    To_State := State.Description;

                IF "Shipping Agent Code" <> '' Then
                    IF ShipAgent.Get("Shipping Agent Code") Then;

                case "Mode of Transport" of
                    '1':
                        ModeOfTransport := ModeOfTransport::"On Road";
                    '2':
                        ModeOfTransport := ModeOfTransport::"On Train"
                end;

                // ChallanTitle := 'Delivery Challan';
                // IF From_State <> To_State then
                //     ChallanTitle := 'Tax Invoice';
                ChallanTitle := 'Delivery Challan';

                IF From_State <> To_State then //PT-FBTS
                    ChallanTitle := 'Tax Invoice';
                // InvDoc := 'Invoice No.';
                InvDoc := 'Document/Challan No.';
                IF From_State <> To_State then
                    InvDoc := 'Invoice No.';

                EinoiceEntry.Reset();
                EinoiceEntry.SetRange("Invoice No.", "Transfer Shipment Header"."No.");
                if EinoiceEntry.FindFirst() then
                    EinoiceEntry.CalcFields("Einvoice QR Code");
            end;
        }
    }

    trigger OnInitReport()
    begin
        CompanyInfo.Get();
        CompanyInfo.CalcFields(Picture);
    end;

    var
        CompanyInfo: Record "Company Information";
        Location: Record Location;
        EinoiceEntry: Record "E-Invoice Log Entry";
        State: Record State;
        ShipAgent: Record "Shipping Agent";
        ChallanTitle: Text;
        InvDoc: Text;//PT-FBTS
        From_fullName: Text;
        To_fullName: Text;
        From_fullAddr: Text;
        To_fullAddr: Text;
        From_GstRegNo: Code[20];
        To_GstRegNo: Code[20];
        From_State: Text;
        To_State: Text;
        From_Pan: Code[20];
        To_Pan: Code[20];
        Sr_No: Integer;
        SalesLineSGST: Decimal;
        SGST_Rate: Decimal;
        SalesLineCGST: Decimal;
        CGST_Rate: Decimal;
        SalesLineIGST: Decimal;
        IGST_Rate: Decimal;
        TotalAmount: Decimal;
        ModeOfTransport: Option "On Road","On Train";

    procedure CalculateGST(TSL: Record "Transfer Shipment Line")
    var
        TransferShipmentLine: Record "Transfer Shipment Line";
        TaxRecordID: RecordId;
        TaxTransactionValue: Record "Tax Transaction Value";
        TaxTypeObjHelper: Codeunit "Tax Type Object Helper";
        ComponentAmt: Decimal;
    begin
        Clear(CGST_Rate);
        Clear(SGST_Rate);
        Clear(IGST_Rate);
        Clear(SalesLineSGST);
        Clear(SalesLineCGST);
        Clear(SalesLineIGST);
        TaxTransactionValue.Reset();
        TaxTransactionValue.SetFilter("Tax Record ID", '%1', TSL.RecordId);
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

            until TaxTransactionValue.Next() = 0;
    end;
}