report 50128 "Report - Purchase Order"
{
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = '.vscode/Layouts/PurchOrdLayout.rdl';
    ApplicationArea = All;

    dataset
    {
        dataitem("Purchase Header"; "Purchase Header")
        {
            DataItemTableView = sorting("Document Type", "No.");
            RequestFilterFields = "No.", "Buy-from Vendor No.";

            column(CompanyAddr1; CompanyAddr[1])
            { }
            column(CompanyAddr2; CompanyAddr[2])
            { }
            column(CompanyAddr3; CompanyAddr[3])
            { }
            column(CompanyAddr4; CompanyAddr[4])
            { }
            column(CompanyGstRegNo; "Location GST Reg. No.")
            { }
            column(CompanyLogo; CompanyInfo.Picture)
            { }

            column(No_; "No.")
            { }
            column(SupplierName; SupplierName)
            { }
            column(Buy_from_Vendor_Name; "Buy-from Vendor Name")
            { }
            column(SupplierAddress; SupplierAddress)
            { }
            column(Buy_from_Address; "Buy-from Address")
            { }
            column(Vendor_GST_Reg__No_; "Vendor GST Reg. No.")
            { }
            column(VendorPanNo; VendorPanNo)
            { }
            column(Requistion_No_; "Indent No.")
            { }
            column(DimensionSetEntry; DimensionSetEntry."Dimension Value Name")
            { }
            column(Order_Date; "Order Date")
            { }
            column(Expected_Receipt_Date; "Expected Receipt Date")
            { }
            column(FreightCost; FreightCost)
            { }
            column(PaymentTerms; PaymentTerms.Code)
            { }
            column(MakerDetail; Users."User Name")
            { }
            column(ApprovalEntry; ApprovalEntry."Approver ID")
            { }
            column(DeliveryAddr; DeliveryAddr)
            { }
            column(InvAddr; InvAddr)
            { }

            dataitem("Purchase Line"; "Purchase Line")
            {
                DataItemTableView = sorting("Document No.");

                DataItemLinkReference = "Purchase Header";
                DataItemLink = "Document No." = field("No.");

                column(Sr_No_; Sr_No)
                { }
                column(Material_Code; "No.")
                { }
                column(Description; Description)
                { }
                column(Unit_of_Measure; "Unit of Measure Code")
                { }
                column(HSN_SAC_Code; "HSN/SAC Code")
                { }
                column(Qty_Received; Quantity)
                { }
                column(Unit_Cost; "Unit Cost")
                { }
                column(AmountExclTax; "Line Amount")
                { }
                column(GST_Group_Code; "GST Group Code")
                { }
                column(Tax_Amnt; Tax_Amnt)
                { }
                column(Amount_Including_Tax; "Amount Including VAT")
                { }
                column(Remarks; Remarks)
                {

                }
                column(PurchCOmment; Narration)
                {
                }

                trigger OnAfterGetRecord()
                var
                    Tax_Percent: Decimal;
                    comments: Text[80];

                begin
                    Sr_No += 1;
                    "Line Amount" := Quantity * "Unit Cost";

                    IF ("GST Group Code" <> '') AND (StrLen(Format("GST Group Code")) <= 2) THEN
                        IF Evaluate(Tax_Percent, "GST Group Code") Then;

                    Tax_Amnt := ("Line Amount" * Tax_Percent) / 100;
                    "Amount Including VAT" := "Line Amount" + Tax_Amnt;


                end;
            }


            dataitem(PCL; PurchCommentLine)
            {
                column(CommentCode; CommentCode)
                { }
                column(Comment_No; Comment_No)
                { }
                column(Comment; Comment)
                { }

                trigger OnPreDataItem()
                var
                    PurchCommLine: Record PurchCommentLine;
                begin
                    PurchCommLine.Reset();
                    PurchCommLine.SetRange(CommentCode, 'GENERAL');

                    IF PurchCommLine.FindFirst() And ("Purchase Header".CommentCode <> '') Then
                        PCL.SetFilter(CommentCode, '=%1|%2', 'GENERAL', "Purchase Header".CommentCode);
                    PCL.FindSet();
                end;

                trigger OnAfterGetRecord()
                begin
                    Comment_No += 1;
                end;
            }

            trigger OnAfterGetRecord()
            var
                Location: Record Location;
            begin
                IF "Purchase Header".Status <> "Purchase Header".Status::Released Then
                    Error('The status is not released. First release the document to print the same..');

                IF PaymentTerms.Get("Purchase Header"."Payment Terms Code") then;

                IF "Vendor GST Reg. No." <> '' Then
                    VendorPanNo := Format("Vendor GST Reg. No.").Substring(3, 10);

                IF "Dimension Set ID" <> 0 Then begin
                    DimensionSetEntry.Reset();
                    DimensionSetEntry.SetRange("Dimension Set ID", "Dimension Set ID");
                    IF DimensionSetEntry.FindLast() then;
                    DimensionSetEntry.CalcFields("Dimension Value Name");
                end;

                // IF "Location Code" <> '' Then begin
                //     IF Location.Get("Location Code") Then
                //         DeliveryAddr := Location.Name + ' ' + Location.Address + ' ' + Location."Post Code" + ' ' + Location.City;
                //     InvAddr := DeliveryAddr;
                // end;
                if "Purchase Header"."Thrid Party vendor" = '' then begin
                    IF "Location Code" <> '' Then begin
                        IF Location.Get("Location Code") Then
                            DeliveryAddr := Location.Name + ' ' + Location.Address + ' ' + Location."Post Code" + ' ' + Location.City;
                        InvAddr := DeliveryAddr;

                    end;
                end;
                //PT-FBTS
                VendorRec.Reset();
                VendorRec.SetRange("No.", "Purchase Header"."Thrid Party vendor");
                if VendorRec.FindFirst() then
                    DeliveryAddr := VendorRec.Address + ' ' + VendorRec."Address 2";
                // InvAddr := DeliveryAddr;
                IF Location.Get("Location Code") Then
                    InvAddr := Location.Name + ' ' + Location.Address + ' ' + Location."Post Code" + ' ' + Location.City;
                //PT-FBTS


                IF "Bill to-Location(POS)" <> '' Then
                    IF Location.Get("Bill to-Location(POS)") then
                        InvAddr := Location.Name + ' ' + Location.Address + ' ' + Location.City;

                IF Users.Get(SystemCreatedBy) Then;

                ApprovalEntry.Reset();
                ApprovalEntry.SetRange("Document No.", "No.");
                IF ApprovalEntry.FindLast() Then;
                PurchCmntLine.Reset();
                PurchCmntLine.SetRange("Document Type", PurchCmntLine."Document Type"::Order);
                PurchCmntLine.SetRange("No.", "No.");
                if PurchCmntLine.FindSet() then begin
                    countt := PurchCmntLine.Count;
                    repeat
                        if PurchCmntLine.Comment <> '' then begin
                            if Narration = '' then
                                Narration := PurchCmntLine.Comment
                            else
                                Narration += '\' + PurchCmntLine.Comment;
                        end;
                    until PurchCmntLine.Next() = 0;

                end;

            end;
        }
    }

    trigger OnInitReport()
    begin
        CompanyInfo.Get();
        CompanyInfo.CalcFields(Picture);
        FormatAddr.Company(CompanyAddr, CompanyInfo);
    end;

    var
        PaymentTerms: Record "Payment Terms";
        DimensionSetEntry: Record "Dimension Set Entry";
        CompanyInfo: Record "Company Information";
        ApprovalEntry: Record "Approval Entry";
        Users: Record User;
        CompanyAddr: array[8] of Text[100];
        FormatAddr: Codeunit "Format Address";
        SupplierName: Label 'Vendor Name';
        SupplierAddress: Label 'Vendor Address';
        VendorPanNo: Code[20];
        Sr_No: Integer;
        Comment_No: Integer;
        DeliveryAddr: Text;
        InvAddr: Text;
        Tax_Amnt: Decimal;
        PurchCmntLine: Record "Purch. Comment Line";
        Purch_comments: Text[100];
        Countt: Integer;
        Narration: text;
        VendorRec: Record Vendor;//PT-FBTS
}