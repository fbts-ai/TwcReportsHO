report 50164 "Item Wise Purchase Register"
{
    DefaultLayout = RDLC;
    RDLCLayout = 'Report/Purchase Register.rdl';
    PreviewMode = Normal;
    ApplicationArea = all;
    UsageCategory = Lists;

    dataset
    {
        dataitem("Purch. Inv. Line"; "Purch. Inv. Line")
        {
            DataItemTableView = SORTING("Document No.", "Line No.") ORDER(Ascending) WHERE("No." = FILTER(<> ' '), Quantity = FILTER(<> 0));
            RequestFilterFields = "Buy-from Vendor No.", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code", "Gen. Prod. Posting Group", "Gen. Bus. Posting Group";

            column(Comp_Add; CompInfo.Address + '' + CompInfo."Address 2")
            {
            }
            column(Remarks; Remarks)
            { }

            column(Description_2; "Description 2")
            {

            }
            column(TDS_Section_Code; "TDS Section Code")
            { }
            column(DocumentNo_SalesInvoiceLine;
            "Purch. Inv. Line"."Document No.")
            {
            }
            column(Location_Code; "Location Code")
            {

            }
            column(Posting_Date; "Posting Date")
            {

            }
            column(Common_Credit; '')
            {

            }
            column(Gen__Bus__Posting_Group; "Gen. Bus. Posting Group")
            {

            }
            column(PODt; PODATE)
            {
            }
            column(Order_No_; "Order No.")
            {

            }
            column(Receipt_No_; "Receipt No.")
            {

            }
            column(GRNDATE; GRNDATE)
            {

            }
            column(GRNLOCTION; GRNLOCTION)
            {

            }
            column(VendorName; Vendor.Name)
            {
            }
            column(VednorCode; Vendor."No.")
            {

            }
            column(VendInvDate; SalesInvHeader."Document Date")
            { }
            column(TinNo; Vendor."GST Registration No.")
            {
            }

            column(ItemCode; "Purch. Inv. Line"."No.")
            {
            }
            column(ItemDesc; "Purch. Inv. Line".Description)
            {
            }
            column(Gen__Prod__Posting_Group; "Gen. Prod. Posting Group")
            {

            }
            column(Unit_of_Measure; "Unit of Measure Code")
            {
            }



            column(HSNSACCode_SalesInvoiceLine; "Purch. Inv. Line"."HSN/SAC Code")
            {
            }
            column(GST_Group_Code; "Purch. Inv. Line"."GST Group Code")
            {
            }
            column(Qty; "Purch. Inv. Line".Quantity)
            {
            }
            column(BasicValue; "Purch. Inv. Line"."Line Amount" / CurrFtr + "Purch. Inv. Line"."Line Discount Amount" / CurrFtr)
            {
            }

            column(GSTCredit; "Purch. Inv. Line"."GST Credit")
            {

            }
            column(Discount; "Purch. Inv. Line"."Line Discount Amount" / CurrFtr)
            {
            }
            column(BasicValue1; "Purch. Inv. Line"."Line Amount" / CurrFtr)
            {
            }
            column(Comp_Name; CompInfo.Name)
            {
            }
            column(vendinvNo; SalesInvHeader."Vendor Invoice No.")
            { }

            column(TDSAmount; Round((TDSAmount), 1))
            { }



            //chetan


            column(SalesInvOrder; SalesInvHeader."Order No.")
            {
            }
            column(OurPoNo; '')
            {
            }


            column(CESEPer; CESEPer)
            { }
            column(CESEAMT; CESEAMT)
            { }

            column(ShortcutDimension1Code_SalesInvoiceLine; "Purch. Inv. Line"."Shortcut Dimension 1 Code")
            {
            }

            column(Type; "Purch. Inv. Line".type)
            {

            }

            column(revcodt1; revcodt1)
            {
            }

            column(OrderNo; SalesInvHeader."Order No.")
            {
            }

            column(Original_Cost_LCY; ABS(CostLCY))
            {
            }
            column(Original_Profit_LCY; ProfitLCY)
            {
            }
            column(Cost; revcodt1)
            {
            }






            column(CentralGSTAmount; CentralGSTAmount)
            {
            }
            column(CentralGSTPer; CentralGSTPer)
            {

            }
            column(StateGSTPer; StateGSTPer)
            {
            }
            column(StateGSTAmount; StateGSTAmount)
            {
            }
            column(IntegratedGSTPer; IntegratedGSTPer)
            {
            }
            column(IntegratedGSTAmount; IntegratedGSTAmount)
            {
            }

            column(GSTVendorType; Vendor_gRec."GST Vendor Type")
            {

            }
            column(POQTY; POQTY)
            {

            }
            column(GRNDQTY; GRNDQTY)
            {

            }
            column(Direct_Unit_Cost; "Direct Unit Cost")
            {

            }
            trigger OnAfterGetRecord()
            var
                PIH: Record "Purch. Inv. Header";
                PurReciptHeader: Record "Purch. Rcpt. Header";
                PurorderLineRec: Record "Purchase Line";
                PurrecLine: Record "Purch. Rcpt. Line";
                PurchaseHeaderRec: Record "Purchase Header";

            begin
                Clear(GRNDATE);
                Clear(POQTY);
                Clear(GRNDQTY);
                Clear(PODATE);
                // PurReciptHeader.Reset();

                PurrecLine.Reset();
                PurrecLine.SetRange("Document No.", "Receipt No.");
                // PurrecLine.SetRange("No.", "No.");
                PurrecLine.SetRange("Line No.", "Receipt Line No.");
                // PurrecLine.SetRange("Line No.", "Line No.");
                if PurrecLine.FindSet() then begin
                    repeat
                        GRNDATE := PurrecLine."Posting Date";
                        GRNDQTY := PurrecLine.Quantity;
                        GRNLOCTION := PurrecLine."Location Code";
                    // PODATE := PurrecLine."Order Date";
                    until PurrecLine.Next() = 0;

                end;



                PurorderLineRec.Reset();
                PurorderLineRec.SetRange("Document No.", "Order No.");
                PurorderLineRec.SetRange("Line No.", "Order Line No.");

                if PurorderLineRec.FindSet() then begin
                    repeat
                        POQTY := PurorderLineRec.Quantity;
                    until PurorderLineRec.Next() = 0;
                end;

                PurchaseHeaderRec.reset();
                PurchaseHeaderRec.SetRange("No.", "Order No.");
                if PurchaseHeaderRec.FindFirst() then begin
                    PODATE := PurchaseHeaderRec."Order Date";
                end;


                //  end;




                Clear(PIH);
                PIH.GET("Purch. Inv. Line"."Document No.");
                Clear(Vendor_gRec);
                IF Vendor_gRec.GET(PIH."Buy-from Vendor No.") Then;
                SalesInvHeader.GET("Document No.");

                CurrFtr := 1;
                IF ShowAmtsInLCY THEN BEGIN
                    IF SalesInvHeader."Currency Factor" <> 0 THEN
                        CurrFtr := SalesInvHeader."Currency Factor"
                END;

                StateDesc := '';
                IF Vendor.GET("Buy-from Vendor No.") THEN
                    IF StateRec.GET(Vendor."State Code") THEN
                        StateDesc := StateRec.Description;

                // //  IF ExciseProdPosting.GET("Excise Prod. Posting Group") THEN;

                FreightCharges := 0;
                OtherTax := 0;


                CostLCY := 0;
                CustAmount := 0;
                AmountLCY := 0;
                ProfitLCY := 0;

                ValueEntry.RESET;
                ValueEntry.SETCURRENTKEY("Document No.");
                ValueEntry.SETRANGE("Document No.", "Purch. Inv. Line"."Document No.");
                ValueEntry.SETRANGE("Document Line No.", "Purch. Inv. Line"."Line No.");
                IF ValueEntry.FINDFIRST THEN
                    REPEAT
                        CostLCY += ValueEntry."Cost Amount (Actual)";
                    UNTIL ValueEntry.NEXT = 0;
                // //TRI A.V 09.10.15 DEL STOP

                CustAmount := CustAmount + "Purch. Inv. Line".Amount;

                IF SalesInvHeader."Currency Code" = '' THEN
                    AmountLCY := CustAmount
                ELSE
                    AmountLCY :=
                      CurrExchRate.ExchangeAmtFCYToLCY(
                        WORKDATE, SalesInvHeader."Currency Code", CustAmount, SalesInvHeader."Currency Factor");

                CustLedgEntry.RESET;
                CustLedgEntry.SETCURRENTKEY("Document No.", "Document Type", "Vendor No.");
                CustLedgEntry.SETRANGE("Document No.", "No.");
                CustLedgEntry.SETRANGE("Document Type", CustLedgEntry."Document Type"::Invoice);
                CustLedgEntry.SETRANGE("Vendor No.", "Buy-from Vendor No.");
                IF CustLedgEntry.FINDFIRST THEN
                    AmountLCY := CustLedgEntry."Purchase (LCY)";

                ProfitLCY := AmountLCY - ABS(CostLCY);
                SalesHeader.RESET;
                SalesHeader.SETRANGE(SalesHeader."Buy-from Vendor No.", SalesInvHeader."Buy-from Vendor No.");
                IF SalesHeader.FINDFIRST THEN BEGIN
                    SalesLine.RESET;
                    SalesLine.SETRANGE(SalesLine."Document No.", SalesHeader."No.");
                    IF SalesLine.FINDFIRST THEN BEGIN
                        SQty := SalesLine.Quantity;
                        InvQty := SalesLine."Qty. to Invoice";
                    END;
                END;
                // // PRITI 9Feb 2017


                CLEAR(CESEPer);
                CLEAR(CESEAMT);
                CLEAR(IntegratedGSTPer);
                CLEAR(IntegratedGSTAmount);
                CLEAR(CentralGSTPer);
                CLEAR(CentralGSTAmount);
                CLEAR(StateGSTPer);
                CLEAR(StateGSTAmount);
                DetailedGST.RESET;
                DetailedGST.SetCurrentKey("Document No.");
                DetailedGST.SetLoadFields("Document No.", "Document Line No.", "GST Amount");
                DetailedGST.SETRANGE(DetailedGST."Document No.", "Purch. Inv. Line"."Document No.");
                //DetailedGST.SetFilter(DetailedGST."GST Component Code", '%1', 'CGST');
                DetailedGST.SetRange("No.", "Purch. Inv. Line"."No.");
                DetailedGST.SetRange("Document line No.", "Purch. Inv. Line"."Line No.");
                DetailedGST.SetRange("Entry Type", DetailedGST."Entry Type"::"Initial Entry");
                IF DetailedGST.FINDSET THEN BEGIN
                    REPEAT
                        case DetailedGST."GST Component Code" of
                            'CGST':
                                begin

                                    CentralGSTPer += DetailedGST."GST %";
                                    //  CentralGSTPer := DetailedGST."GST %";
                                    CentralGSTAmount += DetailedGST."GST Amount";
                                end;
                            'SGST':
                                begin
                                    StateGSTPer += DetailedGST."GST %";
                                    StateGSTAmount += DetailedGST."GST Amount";
                                end;
                            'IGST':
                                begin
                                    IntegratedGSTPer += DetailedGST."GST %";
                                    IntegratedGSTAmount += DetailedGST."GST Amount";
                                end;
                            'CESS':
                                begin
                                    CESEPer += DetailedGST."GST %";
                                    CESEAMT += DetailedGST."GST Amount";
                                end;

                        end;
                    UNTIL DetailedGST.NEXT = 0;

                END;



                // DetailedGST.RESET;
                // DetailedGST.SetCurrentKey("Document No.");
                // DetailedGST.SetLoadFields("Document No.", "Document Line No.", "GST Amount");
                // DetailedGST.SETRANGE(DetailedGST."Document No.", "Purch. Inv. Line"."Document No.");
                // DetailedGST.SETRANGE(DetailedGST."GST Component Code", 'SGST');
                // DetailedGST.SetRange("No.", "Purch. Inv. Line"."No.");
                // DetailedGST.SetRange("Document line No.", "Purch. Inv. Line"."Line No.");
                // IF DetailedGST.FINDSET THEN BEGIN
                //     REPEAT
                //         StateGSTPer += DetailedGST."GST %";
                //         StateGSTAmount += DetailedGST."GST Amount";
                //     UNTIL DetailedGST.NEXT = 0;
                // END;


                // DetailedGST.RESET;
                // DetailedGST.SetCurrentKey("Document No.");
                // DetailedGST.SetLoadFields("Document No.", "Document Line No.", "GST Amount");
                // DetailedGST.SETRANGE(DetailedGST."Document No.", "Purch. Inv. Line"."Document No.");
                // DetailedGST.SETRANGE(DetailedGST."GST Component Code", 'IGST');
                // DetailedGST.SetRange("No.", "Purch. Inv. Line"."No.");
                // DetailedGST.SetRange("Document line No.", "Purch. Inv. Line"."Line No.");
                // IF DetailedGST.FINDSET THEN BEGIN
                //     REPEAT
                //         IntegratedGSTPer += DetailedGST."GST %";
                //         IntegratedGSTAmount += DetailedGST."GST Amount";
                //     UNTIL DetailedGST.NEXT = 0;
                // END;



                // DetailedGST.RESET;
                // DetailedGST.SetCurrentKey("Document No.");
                // DetailedGST.SetLoadFields("Document No.", "Document Line No.", "GST Amount");
                // DetailedGST.SETRANGE(DetailedGST."Document No.", "Purch. Inv. Line"."Document No.");
                // DetailedGST.SETRANGE(DetailedGST."GST Component Code", 'CESS');
                // DetailedGST.SetRange("No.", "Purch. Inv. Line"."No.");
                // DetailedGST.SetRange("Document line No.", "Purch. Inv. Line"."Line No.");
                // IF DetailedGST.FINDSET THEN BEGIN
                //     REPEAT
                //         CESEPer += DetailedGST."GST %";
                //         CESEAMT += DetailedGST."GST Amount";
                //     UNTIL DetailedGST.NEXT = 0;
                // END;
                Clear(TDSAmount);
                TaxTransValue.Reset();
                TaxTransValue.SetRange("Tax Type", 'TDS');
                TaxTransValue.SetRange("Tax Record ID", "Purch. Inv. Line".RecordId());
                TaxTransValue.SetRange("Value Type", TaxTransValue."Value Type"::COMPONENT);
                TaxTransValue.SetFilter(Percent, '<>%1', 0);
                if TaxTransValue.FindSet() then
                    repeat
                        TaxComponentName := TaxTransValue.GetAttributeColumName();
                        case TaxComponentName of
                            'TDS':
                                begin
                                    evaluate(TDSAmount, TaxTransValue."Column Value");
                                end;
                        end;
                    until TaxTransValue.Next() = 0;

            end;

            trigger OnPreDataItem()
            begin
                SETRANGE("Posting Date", StDate, EdDate);
                IF VendorNo <> '' then
                    SetFilter("Buy-from Vendor No.", VendorNo);
                CLEAR(revcodt1);


                // "Purch. Inv. Line".GetFilter("Document No.") 
            end;
        }


    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Filters)
                {
                    field(StDate; StDate)
                    {
                        Caption = 'Start Date';
                        ApplicationArea = all;
                    }
                    field(EdDate; EdDate)
                    {
                        Caption = 'End Date';
                        ApplicationArea = all;
                    }
                    field(ShowAmtsInLCY; ShowAmtsInLCY)
                    {
                        Caption = 'Show Amounts in LCY';
                        ApplicationArea = all;
                    }

                    field(VendorNo; VendorNo)
                    {
                        Caption = 'Vendor No.';
                        ApplicationArea = all;
                        TableRelation = Vendor;
                    }

                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        CompInfo.GET;

        IF (StDate = 0D) OR (EdDate = 0D) THEN
            ERROR(Text001);

        IF StDate > EdDate THEN
            ERROR(Text002);

        CompInfo.CALCFIELDS(Picture);
    end;

    var
        Vendor: Record "Vendor";
        StateDesc: Text[50];
        SQty: Decimal;
        POQTY: Decimal;
        InvQty: Decimal;
        //  ExciseProdPosting: Record "13710";
        SalesInvHeader: Record "Purch. Inv. Header";
        // PostStrOrdLineDet: Record "13798";
        FreightCharges: Decimal;
        PackingCharges: Decimal;
        HandlingCharges: Decimal;
        OtherTax: Decimal;
        CompInfo: Record "company information";
        StateRec: Record "state";
        SalesShipmentLine: Record "Sales Shipment Line";
        HssSale: Text[10];
        CurrExchRate: Record "Currency Exchange Rate";
        CustLedgEntry: Record "Vendor Ledger Entry";
        CostLCY: Decimal;
        CustAmount: Decimal;
        AmountLCY: Decimal;
        ProfitLCY: Decimal;
        SCrMemoHdr: Record "Sales Cr.Memo Header";
        SCrMemoline: Record "Sales Cr.Memo line";
        PInvHdr: Record "Purch. Inv. Header";
        VendorNo: Code[20];
        StDate: Date;
        EdDate: Date;
        Text001: Label 'You must Enter Start Date and End Date.';
        Text002: Label 'End Date must be Greater than Start Date.';
        ShowAmtsInLCY: Boolean;
        CurrFtr: Decimal;
        ValueEntry: Record "Value Entry";
        //  revcost: Record "50009";
        revcodt1: Decimal;
        SalesLine: Record "sales line";
        SalesHeader: Record "Purchase header";
        saleslineplancost: Record "Sales Line";
        RecSIH: Record "Sales Invoice Header";
        REVQTY: Decimal;
        DetailedGST: Record "Detailed GST Ledger Entry";
        CentralGSTPer: Decimal;
        CentralGSTAmount: Decimal;
        TaxTransValue: Record "Tax Transaction Value";
        TaxComponentName: Text;
        TDSAmount: Decimal;

        StateGSTPer: Decimal;
        StateGSTAmount: Decimal;
        IntegratedGSTPer: Decimal;
        CESEPer: Decimal;
        CESEAMT: Decimal;
        IntegratedGSTAmount: Decimal;
        Vendor_gRec: Record Vendor;
        GRNDATE: date;
        GRNDQTY: Decimal;
        PODATE: DATE;
        jsj: Record Item;
        GRNLOCTION: Code[10];

}

