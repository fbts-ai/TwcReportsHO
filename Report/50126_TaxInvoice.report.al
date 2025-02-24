report 50126 "TaxInvoice - Pos"
{
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = '.vscode/Layouts/TaxInvPosLayout.rdl';
    ApplicationArea = All;
    EnableHyperlinks = true;

    dataset
    {
        dataitem("LSC Transaction Header"; "LSC Transaction Header")
        {
            PrintOnlyIfDetail = true;
            RequestFilterFields = "Store No.", "POS Terminal No.", "Transaction No.";

            column(CompanyLogo; CompanyInfo.Picture)
            { }
            column(CompanyName; CompanyInfo.Name)
            { }
            column(StoreAddr1; Store.Address)
            { }
            column(StoreAddr2; Store."Address 2")
            { }
            column(StoreCity; Store.City)
            { }
            column(StorePinCode; Store."Post Code")
            { }
            column(StorePhone; Store."Phone No.")
            { }
            column(GST_Num; Store."LSCIN GST Registration No")
            { }
            column(FSSI_License; Store."FSSAI Number")
            { }
            column(Table_No_; TableNo)
            { }
            column(Receipt_No_; "Cust Receipt No")
            { }
            column(Store_No_; "Store No.")
            { }
            column(StoreName; Store.Name)
            { }
            column(Trans__Date; Date)
            { }
            column(Trans_Time; "Time when Trans. Closed")
            { }
            column(Channel; UpHeader.order_details_channel)
            { }
            column(Base_Sales_Type; "Sales Type")
            { }
            column(Sales_Type; SalesType)
            { }
            column(Trans_OrdId; UpHeader.order_details_ext_platforms_id)
            { }
            column(Twc_OrderId; KotHeader."Order ID")
            { }
            column(Staff_ID; "Staff ID")
            { }
            column(Sale_Is_Return_Sale; "Sale Is Return Sale")
            { }
            column(Line_Total; -("Net Amount" - "Discount Amount"))
            { }
            column(Disc_Total; "Discount Amount")
            { }
            column(Grand_Total; -"Gross Amount")
            { }
            column(EncodeStr; EncodeStr)
            { }
            column(roundoff; Rounded)
            { }
            column(ReceiptNoString; ReceiptNoString)
            { }
            column(CreditNoteNoString; CreditNoteNoString)
            { }

            dataitem("LSC Trans. Sales Entry"; "LSC Trans. Sales Entry")
            {
                DataItemLinkReference = "LSC Transaction Header";
                DataItemLink = "Store No." = field("Store No."), "POS Terminal No." = field("POS Terminal No."), "Transaction No." = field("Transaction No.");

                column(Sr_No; Sr_No)
                { }
                column(Description; Item.Description)
                { }
                column(LSCIN_HSN_SAC_Code; "LSCIN HSN/SAC Code")
                { }
                column(Parent_Line_No_; "Parent Line No.")
                { }
                column(Quantity; -Quantity)
                { }
                column(Price; Price)
                { }
                column(GstCode; GstCode)
                { }
                column(GstValue; GstValue)
                { }
                column(SGST; -SGST)
                { }
                column(CGST; -CGST)
                { }
                column(InvoiceTxt; InvoiceTxt)
                { }
                column(copyText; copyText)
                { }
                column(Infocode_Selected_Qty_; "Infocode Selected Qty.")
                { }
                column(totdis; -"Discount Amount")
                { }
                column(Net_Amount; -"Net Amount")
                { }
                column(Wallet_Balance; WalletBal)
                { }

                trigger OnPreDataItem()
                begin
                    SetFilter("Division Code", '<>%1', 'PM');
                    IF FindSet() Then;
                end;

                trigger OnAfterGetRecord()
                var
                    GstcodeTemp: Decimal;
                    LSCTransHdr: Record "LSC Transaction Header";
                    Transsalesentry: Record "LSC Trans. Sales Entry";
                    TH: Record "LSC Transaction Header";

                begin
                    Clear(TotDis);
                    Clear(InvoiceTxt);
                    Clear(copyText);

                    // "Wallet Balance" := '11000';
                    GstCode := 0;
                    Item.Reset();
                    IF Item.Get("Item No.") THEN;

                    IF "LSC Transaction Header"."Sale Is Return Sale" then begin
                        InvoiceTxt := 'Return Tax Invoice';
                        TableNo := '';

                        LSCTransHdr.Reset();
                        LSCTransHdr.SetRange("Receipt No.", "LSC Transaction Header"."Retrieved from Receipt No.");
                        IF LSCTransHdr.FindFirst() then;

                        Transsalesentry.Reset();
                        Transsalesentry.SetRange("Receipt No.", LSCTransHdr."Receipt No.");
                        Transsalesentry.SetRange("Item No.", "Item No.");
                        IF Transsalesentry.FindFirst() then;
                        "Parent Line No." := Transsalesentry."Parent Line No.";
                        "Infocode Selected Qty." := -Transsalesentry."Infocode Selected Qty.";
                    end
                    Else
                        //Wallet Balance Criteria
                        IF Item."No." = '1' Then begin
                            IF "LSC Transaction Header"."Wallet Balance" <> '' Then
                                IF Evaluate(WalletBal, "LSC Transaction Header"."Wallet Balance") Then;
                            WalletBal += ABS("Net Amount" - "Discount Amount");
                            InvoiceTxt := 'Advance Receipt';
                            TableNo := '';
                            "LSC Transaction Header".Rounded := 0;
                            "LSC Transaction Header"."Gross Amount" := ("Net Amount" - "Discount Amount");
                        end
                        else
                            InvoiceTxt := 'Tax Invoice';

                    IF ("LSC Transaction Header".GetPrintedCounter(1) > 0) THEN
                        copyText := ' - Copy';

                    //Gst Area
                    IF ("LSCIN GST Group Code" <> '') AND (StrLen(Format("LSCIN GST Group Code")) <= 2) THEN begin
                        Evaluate(GstCode, "LSCIN GST Group Code");

                        GstCode /= 2;
                        GstValue := "LSCIN GST Amount";
                        SGST := GstValue / 2;
                        CGST := GstValue / 2;
                    end;

                    //Add Serial No to non - add on item only
                    IF "Parent Line No." = 0 Then
                        Sr_No += 1
                    Else
                        Price := ABS("Net Amount");

                    TH.Reset();
                    TH.SetRange("Receipt No.", "Receipt No.");
                    IF th.FindSet() then begin
                        TH.CalcSums("Discount Amount");
                        TH.CalcSums("Customer Discount");
                        TH.CalcSums("Total Discount");
                        TotDis := "Total Discount" + "Discount Amount" + "Customer Discount";
                    end;

                    IF "Sales Type" = 'TAKEAWAY' Then
                        InvoiceTxt := 'Order Information';
                end;
            }

            dataitem("LSC Trans. Payment Entry"; "LSC Trans. Payment Entry")
            {
                DataItemLinkReference = "LSC Transaction Header";
                DataItemLink = "Store No." = field("Store No."), "POS Terminal No." = field("POS Terminal No."), "Transaction No." = field("Transaction No.");

                column(Tender_Type; TenderType.Description)
                { }
                column(Amount_Tendered; "Amount Tendered")
                { }
                column(CreditNoteNo; CreditNoteNo)
                { }

                trigger OnAfterGetRecord()
                var
                    PosDataEntry: Record "LSC POS Data Entry";
                begin
                    TenderType.Reset();
                    TenderType.SetRange(Code, "Tender Type");
                    TenderType.SetFilter("Store No.", '=%1', "LSC Transaction Header"."Store No.");
                    IF TenderType.FindFirst() then;

                    IF (InvoiceTxt = 'Tax Invoice') Or (InvoiceTxt = 'Order Information') Then
                        IF "Amount Tendered" < 0 then
                            TenderType.Description := 'Change Due';

                    PosDataEntry.Reset();
                    PosDataEntry.SetRange("Created by Receipt No.", "LSC Transaction Header"."Receipt No.");
                    IF PosDataEntry.FindFirst() then
                        CreditNoteNo := PosDataEntry."Entry Code";

                    IF CreditNoteNo <> '' Then
                        CreditNoteNoString := getBarcode(CreditNoteNo);
                end;
            }

            trigger OnAfterGetRecord()
            var
                TIE: Record "LSC Trans. Infocode Entry";
            begin
                // getQR("Sales Type");
                ReceiptNoString := getBarcode("Receipt No.");

                CompanyInfo.Get();
                CompanyInfo.CalcFields(Picture);

                KotHeader.Reset();
                KotHeader.SetRange("Receipt No.", "Receipt No.");
                IF KotHeader.FindFirst() then
                    IF KOTHeader."Order ID" = '' then
                        KOTHeader."Order ID" := Format(KOTHeader.ID);

                Store.Reset();
                IF Store.Get("Store No.") THEN;

                UpHeader.Reset();
                UpHeader.SetRange(receiptNo, "Receipt No.");
                IF UpHeader.FindFirst() Then;

                IF UpHeader.order_details_ext_platforms_id = '' then
                    UpHeader.order_details_ext_platforms_id := Format(Upheader.order_details_id);

                IF "Sales Type" = 'POS' Then begin
                    TIE.Reset();
                    TIE.SetRange("Transaction No.", "Transaction No.");
                    TIE.SetRange("Store No.", "Store No.");
                    TIE.SetRange("POS Terminal No.", "POS Terminal No.");
                    TIE.SetRange(Infocode, 'SELECTTABLE');
                    IF TIE.FindFirst() then
                        TableNo := TIE.Information
                    Else begin
                        TIE.SetRange(Infocode, 'TABLE NO.');
                        IF TIE.FindFirst() then
                            TableNo := TIE.Information;
                    end;
                end
                Else
                    TableNo := Format(UpHeader.order_details_tableno);

                IF "Sales Type" = 'POS' Then begin
                    TIE.SetRange(Infocode, '#SALESTYPE');
                    IF TIE.FindSet() Then
                        SalesType := TIE.Information;
                end
                Else begin
                    IF UpHeader.order_details_order_type = 'delivery' then
                        UpHeader.order_details_order_type := 'Home Delivery';

                    SalesType := UpHeader.order_details_order_type;
                end;
            end;
        }
    }

    var
        CompanyInfo: Record "Company Information";
        KotHeader: Record "LSC KOT Header";
        UpHeader: Record "UP Header";
        HospType: Record "LSC Hospitality Type";
        Store: Record "LSC Store";
        SalesType: Text;
        Item: Record Item;
        TenderType: Record "LSC Tender Type";
        TableNo: Text;
        EncodeStr: Text;
        Sr_No: Integer;
        copyText: Text;
        TotDis: Decimal;

        InvoiceTxt: Text;
        Line_Total: Decimal;
        Disc_Total: Decimal;
        GstCode: Decimal;
        GstValue: Decimal;
        SGST: Decimal;
        CGST: Decimal;
        Grand_Total: Decimal;
        CreditNoteNo: Code[20];
        WalletBal: Decimal;
        ReceiptNoString: Text;
        CreditNoteNoString: Text;

    // local procedure getQR(SalesType: Code[20])
    // var
    //     Base64Convert: Codeunit "Base64 Convert";
    //     TempBlob: Codeunit "Temp Blob";
    //     Client: HttpClient;
    //     Response: HttpResponseMessage;
    //     Instr: InStream;

    //     URL: Text;
    //     TypeHelper: Codeunit "Type Helper";
    // begin
    //     IF SalesType = 'TAKEAWAY' then
    //         URL := 'https://third-wavecoffee.typeform.com/to/y9REVGOg#ordernumber=xxxxx&couponcode=xxxxx&storeid=xxxxx'
    //     Else
    //         URL := 'https://third-wavecoffee.typeform.com/to/mlRwbzeX#ordernumber=xxxxx&couponcode=xxxxx&storeid=xxxxx';

    //     Client.Get('https://barcode.tec-it.com/barcode.ashx?data=' + TypeHelper.UrlEncode(URL) + '&code=QRCode', Response);
    //     TempBlob.CreateInStream(Instr);
    //     Response.Content.ReadAs(Instr);

    //     EncodeStr := Base64Convert.ToBase64(Instr);
    // end;

    local procedure getBarcode("No.": Code[20]): Text
    var
        Base64Convert: Codeunit "Base64 Convert";
        TempBlob: Codeunit "Temp Blob";
        Client: HttpClient;
        Response: HttpResponseMessage;
        Instr: InStream;
        BarcodeString: Text;
    begin
        Clear(BarcodeString);
        IF Client.Get('https://barcode.tec-it.com/barcode.ashx?data=' + "No." + '&code=Code128', Response) Then Begin
            TempBlob.CreateInStream(Instr);
            Response.Content.ReadAs(Instr);

            BarcodeString := Base64Convert.ToBase64(Instr);

            exit(BarcodeString);
        End;
    end;
}