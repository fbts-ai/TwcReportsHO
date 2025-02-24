report 50151 "Bill wise sales Report"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    Caption = 'Bill Wise sales Report';
    ExecutionTimeout = '3';
    DefaultLayout = Excel;
    ExcelLayout = 'Report/Bill Wise Pos Report.xlsx';
    dataset
    {
        dataitem("LSC Transaction Header"; "LSC Transaction Header")
        {
            DataItemTableView = where("Transaction Type" = filter('Sales'),
             "Net Amount" = filter(<> 0));
            RequestFilterFields = Date, "Store No.";
            column(Transaction_No; "Receipt No.")
            { }
            column(Transaction; "Transaction No.")
            { }
            column(Date; FORMAT("LSC Transaction Header".Date, 0, '<Day,2>/<Month,2>/<Year4>'))
            {
            }
            column(Store_No_; "Store No.")//'SHOWROOM|ODRBOOKING|PREPAYMENT|DELIVERY|RESTAURANT'
            {
            }
            column(storename;
            LSCStore.Name)
            { }
            column(Sales_Type; "Sales Type")
            { }
            column(Channel_type; Channel_type)
            { }
            column(Time; "LSC Transaction Header".Time)
            {
            }
            column("Bill_Amount"; "Gross Amount" * -1)
            {
            }
            column(LSCIN_GST_Amount; "LSCIN GST Amount" * -1)
            {
            }
            column(Discount_Amount; "Discount Amount")
            {
            }
            column(Net_Amount; "Net Amount")  //("Gross Amount" - "LSCIN GST Amount" + "Discount Amount") * -1)
            {
            }
            // column(Net_Amount;"Net Amount")
            // column(Channel; "LSC Transaction Header".Channel)
            // { }
            column(Statement_No_; "Statement No.")
            { }
            column(Entry_Status; "Entry Status")
            { }

            trigger OnAfterGetRecord()
            var

            begin
                Clear(Channel_type);
                if "LSC Transaction Header"."Sales Type" = 'TAKEAWAY' then begin
                    if "LSC Transaction Header"."Customer No." = 'C00008' then
                        Channel_type := 'Swiggy';
                    "LSC Transaction Header".Modify()
                end;
                ///////////// Case1/2
                if "LSC Transaction Header"."Sales Type" = 'TAKEAWAY' then begin
                    if "LSC Transaction Header"."Customer No." = 'C00007' then
                        Channel_type := 'Zomato';
                    "LSC Transaction Header".Modify()
                end;
                Clear(LSCStore);
                LSCStore.Get("Store No.");

                Clear(CustName);
                CustomerRec.Reset();
                CustomerRec.SetRange("No.", "LSC Transaction Header"."Customer No.");
                if CustomerRec.FindFirst() then
                    CustName := CustomerRec.Name;
                Clear(BILLTYPE);//PRATHAM FBTS 
                Clear(SalesTypes);
                lscTransHeader.Reset();
                lscTransHeader.SetRange("POS Terminal No.", "LSC Transaction Header"."POS Terminal No.");//VS_220224
                lscTransHeader.SetRange("Store No.", "LSC Transaction Header"."Store No.");//VS_220224
                lscTransHeader.SetRange("Transaction No.", "LSC Transaction Header"."Transaction No.");//VS_220224
                //lscTransHeader.SetRange("Receipt No.", "LSC Transaction Header"."Receipt No.");//VS_220224
                if lscTransHeader.FindFirst() then begin
                    IF lscTransHeader."Sale Is Return Sale" = true then begin
                        BILLTYPE := lscTransHeader."Retrieved from Receipt No.";
                    end;
                    lscTransHeader1.Reset();
                    lscTransHeader1.SetRange("Receipt No.", BILLTYPE);
                    if lscTransHeader1.FindFirst() then begin
                        IF lscTransHeader1."Sale Is Return Sale" = false then begin
                            //SalesTypes := lscTransHeader1."Pos Receipt No.";
                        end;
                    end;
                END;//END PRATHAM FBTS
            end;
            // Clear(CGST_LSC);
            // Clear(IGST_LSC);
            // Clear(SGST_LSC);
            // Clear(CessAmt);
            // Clear(GSTAMOUNT);
            // Clear(GstgroupCodeRec);//PT FBTS Start(26/04/23 Start)
            // TransSalesEntry.Reset();
            // TransSalesEntry.SetCurrentKey("Line No.");
            // TransSalesEntry.SetRange("Receipt No.", "LSC Transaction Header"."Receipt No.");
            // if TransSalesEntry.Findset() then begin
            //     repeat
            //         GstgroupRec.Reset();
            //         GstgroupRec.SetRange(Code, TransSalesEntry."LSCIN GST Group Code");
            //         if GstgroupRec.FindFirst() then begin
            //             GstgroupCodeRec := GstgroupRec."GST Rate";
            //             CessAmt := GstgroupRec."Cess Tax Rate";
            //         end;
            //         if TransSalesEntry."LSCIN GST Amount" = 0 then begin

            //             GSTAMOUNT := TransSalesEntry."Net Amount" * GstgroupCodeRec / 100;
            //             CGST_LSC += -GSTAMOUNT / 2;
            //             SGST_LSC += -GSTAMOUNT / 2;
            //         end else
            //             if TransSalesEntry."LSCIN GST Jurisdiction Type" = TransSalesEntry."LSCIN GST Jurisdiction Type"::Interstate then
            //                 IGST_LSC := -"LSCIN GST Amount"
            //             else begin
            //                 CGST_LSC := -"LSCIN GST Amount" / 2;
            //                 SGST_LSC := -"LSCIN GST Amount" / 2;
            //             end;
            //     until TransSalesEntry.Next() = 0;
            //     //Message('%1..%2', CGST_LSC, SGST_LSC);\


            //end;
            ////PT FBTS Start(26/04/23 END)  
            //     Clear(ItemAmt);
            //     Clear(QtySales);
            //     Clear(Price);
            //     TransSalesEntry1.Reset();

            //     TransSalesEntry1.SetRange("Transaction No.", "LSC Transaction Header"."Transaction No.");
            //     TransSalesEntry1.SetRange("Store No.", "LSC Transaction Header"."Store No.");
            //     TransSalesEntry1.SetRange("POS Terminal No.", "LSC Transaction Header"."POS Terminal No.");
            //     if TransSalesEntry1.FindFirst() then begin
            //         repeat
            //             Price := TransSalesEntry1.Price;
            //             QtySales := TransSalesEntry1.Quantity
            //         until TransSalesEntry1.Next() = 0;

            //     end;


            // end;


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
                    // field(Name; SourceExpression)
                    // {
                    //     ApplicationArea = All;

                    // }
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
    }



    var
        myInt: Integer;
        CustomerRec: Record Customer;
        GSTAMOUNT: Decimal;
        Channel_type: Text[50];
        CustName: Text[100];
        TransSalesEntry: Record "LSC Trans. Sales Entry";
        TransSalesEntry1: Record "LSC Trans. Sales Entry";
        CessAmt: Decimal;
        Price: Decimal;
        ItemAmt: Decimal;
        QtySales: Decimal;
        LSCStore: Record "LSC Store";
        GstgroupRec: Record "GST Group";
        lscTransHeader: Record "LSC Transaction Header";
        lscTransHeader1: Record "LSC Transaction Header";
        SGST_LSC: Decimal;
        CGST_LSC: Decimal;

        IGST_LSC: Decimal;
        LSCTransPaymentEntry: Record "LSC Trans. Payment Entry";
        TenderTypeRec: Record "LSC Tender Type";
        TenderName: Text[20];
        TenderName1: Text[20];
        TenderName2: Text[20];
        TenderName3: Text[20];
        TenderAmt: Decimal;
        TenderAmt3: Decimal;
        TenderAmt4: Decimal;
        TenderAmt1: Decimal;
        TenderAmt2: Decimal;

        TenderType: Code[20];
        BILLTYPE: Code[20];
        SalesTypes: Code[20];
        GstgroupCodeRec: Decimal;



}