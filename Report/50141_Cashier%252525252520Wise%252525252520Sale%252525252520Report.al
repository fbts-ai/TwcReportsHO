// report 50141 "Cashier Wise Sale-Pos"
// {
//     UsageCategory = ReportsAndAnalysis;
//     DefaultLayout = RDLC;
//     RDLCLayout = '.vscode/Layouts/TaxInvPosLayout1.rdl';
//     ApplicationArea = All;
//     EnableHyperlinks = true;

//     dataset
//     {
//         dataitem("LSC Transaction Header"; "LSC Transaction Header")
//         {
//             DataItemTableView = sorting("Staff ID", Date) order(ascending);
//             column(Skip; Skip)
//             {

//             }
//             column(CompanyLogo; CompanyInfo.Picture)
//             { }
//             column(CompanyName; CompanyInfo.Name)
//             { }
//             column(SelectStore; SelectStore)
//             {

//             }
//             column(SelectDate; SelectDate)
//             {

//             }
//             column(Staff_ID; "Staff ID")
//             { }
//             column(TotalSale; Payment)
//             {

//             }
//             column(Total_Discount; "Total Discount")
//             {

//             }
//             column(LSCIN_GST_Amount; Abs("LSCIN GST Amount"))
//             {

//             }
//             column(StaffName; StaffName)
//             {

//             }
//             column(TotalDiscount; TotalDiscount)
//             {

//             }
//             column(TotalGst; TotalGst)
//             {

//             }
//             trigger OnAfterGetRecord()
//             var
//                 TransSalesEntry: Record "LSC Trans. Sales Entry";
//             begin
//                 StaffRec.Get("LSC Transaction Header"."Staff ID");
//                 StaffName := StaffRec."First Name";

//             end;

//             trigger OnPreDataItem()
//             var
//                 myInt: Integer;
//             begin
//                 "LSC Transaction Header".SetFilter(Date, '%1', SelectDate);
//                 "LSC Transaction Header".SetFilter("Store No.", '%1', SelectStore);
//             end;


//         }
//         dataitem("LSC Trans. Payment Entry"; "LSC Trans. Payment Entry")
//         {
//             column(TenderType; "LSC Trans. Payment Entry"."Tender Type")
//             {

//             }
//             column(Tender_Type; TenderType.Description)
//             { }
//             column(Amount_Tendered; "Amount Tendered")
//             { }
//             trigger OnPreDataItem()
//             var
//                 myInt: Integer;
//             begin
//                 "LSC Trans. Payment Entry".SetFilter(Date, '%1', SelectDate);
//                 "LSC Trans. Payment Entry".SetFilter("Store No.", '%1', SelectStore);
//             end;

//             trigger OnAfterGetRecord()
//             var
//                 PosDataEntry: Record "LSC POS Data Entry";
//             begin
//                 TenderType.Reset();
//                 TenderType.SetRange(Code, "Tender Type");
//                 TenderType.SetFilter("Store No.", '=%1', SelectStore);
//                 IF TenderType.FindFirst() then;
//             end;
//         }
//         dataitem("LSC Trans. Sales Entry"; "LSC Trans. Sales Entry")
//         {
//             // DataItemLinkReference = "LSC Transaction Header";
//             // DataItemLink = "Store No." = field("Store No."), "POS Terminal No." = field("POS Terminal No."), "Transaction No." = field("Transaction No.");
//             column(Item_No_; "LSC Trans. Sales Entry"."Item No.")
//             {

//             }
//             column(ItemDes; ItemDes)
//             {

//             }
//             // column()
//             column(Quantity;
//             Abs(Quantity))
//             {

//             }
//             column(Total_Rounded_Amt_; Abs("Total Rounded Amt."))
//             {

//             }
//             column(Discount_Amount; "Discount Amount")
//             {

//             }
//             column(LSCIN_GST_Amount1; "LSCIN GST Amount")
//             {

//             }
//             column(ItemSaleRequired; ItemSaleRequired)
//             {

//             }
//             // column(Skip; Skip)
//             // {

//             // }
//             column(Total; Total)
//             {

//             }
//             trigger OnPreDataItem()
//             begin
//                 // if ItemSaleRequired = true then CurrReport.Skip();
//                 "LSC Trans. Sales Entry".SetFilter(Date, '%1', SelectDate);
//                 "LSC Trans. Sales Entry".SetFilter("Store No.", '%1', SelectStore);
//                 //"LSC Trans. Sales Entry".SetFilter("Transaction No.", '%1', "LSC Transaction Header"."Transaction No.");
//             end;

//             trigger OnAfterGetRecord()
//             var

//             begin
//                 //if ItemSaleRequired = true then CurrReport.Skip();
//                 ItemDes := '';
//                 if Iterec.get("LSC Trans. Sales Entry"."Item No.") then begin
//                     ItemDes := Iterec.Description;
//                 end;
//             end;
//         }


//     }
//     requestpage
//     {
//         SaveValues = true;
//         layout
//         {
//             area(Content)
//             {

//                 field("Select Store"; SelectStore)
//                 {
//                     ApplicationArea = all;
//                     TableRelation = "LSC Store"."No.";
//                 }
//                 field("Select Date"; SelectDate)
//                 {
//                     ApplicationArea = all;
//                 }
//                 field("Item Sale Required"; ItemSaleRequired)
//                 {
//                     Caption = 'Item Sale Required';
//                     ApplicationArea = all;
//                     //Visible = false;
//                 }
//             }
//         }
//     }
//     trigger OnPreReport()
//     var
//         myInt: Integer;
//     begin
//         CompanyInfo.get();
//         TotalDiscount := 0;
//         TotalGst := 0;
//         LscTransactionHeader.SetRange("Store No.", SelectStore);
//         LscTransactionHeader.SetFilter(Date, '%1', SelectDate);
//         if LscTransactionHeader.FindSet() then begin
//             repeat
//                 TotalDiscount += abs(LscTransactionHeader."Discount Amount");
//                 TotalGst += abs(LscTransactionHeader."LSCIN GST Amount");
//             until LscTransactionHeader.Next() = 0;
//         end;


//         if ItemSaleRequired = true then begin
//             Skip := True;
//         end else begin
//             Skip := false;
//         end;
//         // Message(Format(Skip));
//         // Total := 0;
//         // LScTransSalesEntry.SetRange("Store No.", SelectStore);
//         // LScTransSalesEntry.SetFilter(Date, '%1', SelectDate);
//         // if LScTransSalesEntry.FindSet() then begin
//         //     repeat
//         //         Total += LScTransSalesEntry."Total Rounded Amt.";
//         //     until LScTransSalesEntry.Next() = 0;
//         // end;
//     end;

//     var
//         SelectStore: Code[10];
//         SelectDate: Date;
//         ItemSaleRequired: Boolean;
//         CompanyInfo: Record "Company Information";
//         KotHeader: Record "LSC KOT Header";
//         UpHeader: Record "UP Header";
//         HospType: Record "LSC Hospitality Type";
//         Store: Record "LSC Store";
//         SalesType: Text;
//         Item: Record Item;
//         TenderType: Record "LSC Tender Type";
//         TableNo: Text;
//         EncodeStr: Text;
//         Sr_No: Integer;
//         copyText: Text;
//         TotDis: Decimal;

//         InvoiceTxt: Text;
//         Line_Total: Decimal;
//         Disc_Total: Decimal;
//         GstCode: Decimal;
//         GstValue: Decimal;
//         SGST: Decimal;
//         CGST: Decimal;
//         Grand_Total: Decimal;
//         CreditNoteNo: Code[20];
//         WalletBal: Decimal;
//         ReceiptNoString: Text;
//         CreditNoteNoString: Text;
//         StaffId: Code[20];
//         LscTransactionHeader: Record "LSC Transaction Header";
//         LScTransSalesEntry: Record "LSC Trans. Sales Entry";
//         Total: Decimal;
//         Skip: Boolean;

//         TotalSale: Decimal;
//         StaffName: Text[200];
//         StaffRec: Record "LSC Staff";
//         TotalDiscount: Decimal;
//         TotalGst: Decimal;
//         ItemDes: Text[200];
//         Iterec: Record Item;
// }