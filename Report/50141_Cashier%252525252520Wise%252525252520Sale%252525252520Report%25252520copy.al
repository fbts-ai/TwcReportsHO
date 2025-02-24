// report 50141 "TO Qty Report"
// {
//     UsageCategory = ReportsAndAnalysis;
//     DefaultLayout = RDLC;
//     RDLCLayout = '.vscode/Layouts/TOQtyLayout.rdl';
//     ApplicationArea = All;

//     dataset
//     {
//         dataitem("Transfer Header"; "Transfer Header")
//         {
//             RequestFilterFields = "Posting Date";
//             DataItemTableView = where("Completely Shipped" = filter(true));

//             column(No_; "No.")
//             {

//             }
//             column(To_Location_Code; "Transfer-to Code")
//             {

//             }
//             column(From_Location_Code; "Transfer-from Code")
//             {

//             }
//             dataitem("Transfer Line"; "Transfer Line")
//             {
//                 DataItemLink = "Document No." = field("No.");
//                 DataItemLinkReference = "Transfer Header";
//                 DataItemTableView = where("Qty. to Receive" = filter(<= 0));
//                 column(Item_No_; "Item No.")
//                 {

//                 }
//                 column(Quantity; Quantity)
//                 {

//                 }
//                 column(Qty__to_Receive; "Qty. to Receive")
//                 {

//                 }
//                 trigger OnPreDataItem()
//                 var
//                     myInt: Integer;
//                 begin
//                     //"Transfer Line".SetFilter("Qty. to Receive", '%1', 0);

//                 end;
//             }
//         }
//     }

//     requestpage
//     {
//         layout
//         {
//             area(Content)
//             {
//                 group(GroupName)
//                 {
//                     // field(Name; SourceExpression)
//                     // {
//                     //     ApplicationArea = All;

//                     // }
//                 }
//             }
//         }

//         actions
//         {
//             area(processing)
//             {
//                 action(ActionName)
//                 {
//                     ApplicationArea = All;

//                 }
//             }
//         }
//     }



//     var
//         myInt: Integer;
// }