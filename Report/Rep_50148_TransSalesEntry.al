// //sks_070224
// report 50148 "Trans Sales Entry"
// {
//     ApplicationArea = all;
//     UsageCategory = ReportsAndAnalysis;
//     DefaultLayout = Excel;
//     ExcelLayout = '.vscode/Layouts/TransSalesEntry.xlsx';
//     dataset
//     {
//         dataitem("LSC Trans. Sales Entry"; "LSC Trans. Sales Entry")
//         {

//             RequestFilterFields = Date;
//             CalcFields =;
//             column(BarcodeNo_LSCTransSalesEntry; "Barcode No.")
//             {
//             }
//             // column(BITimestamp_LSCTransSalesEntry; "BI Timestamp")
//             // {
//             // }
//             column(CostAmount_LSCTransSalesEntry; "Cost Amount")
//             {
//             }
//             column(Counter_LSCTransSalesEntry; Counter)
//             {
//             }
//             column(CouponAmtForPrinting_LSCTransSalesEntry; "Coupon Amt. For Printing")
//             {
//             }
//             column(CouponDiscount_LSCTransSalesEntry; "Coupon Discount")
//             {
//             }
//             column(CreatedbyStaffID_LSCTransSalesEntry; "Created by Staff ID")
//             {
//             }
//             column(CustInvoiceDiscount_LSCTransSalesEntry; "Cust. Invoice Discount")
//             {
//             }
//             column(CustomerDiscount_LSCTransSalesEntry; "Customer Discount")
//             {
//             }
//             column(CustomerNo_LSCTransSalesEntry; "Customer No.")
//             {
//             }
//             column(Date_LSCTransSalesEntry; "Date")
//             {
//             }
//             column(DealHeaderLineNo_LSCTransSalesEntry; "Deal Header Line No.")
//             {
//             }
//             column(DealLine_LSCTransSalesEntry; "Deal Line")
//             {
//             }
//             column(DealLineAddedAmt_LSCTransSalesEntry; "Deal Line Added Amt.")
//             {
//             }
//             column(DealLineNo_LSCTransSalesEntry; "Deal Line No.")
//             {
//             }
//             column(DealModifierAddedAmt_LSCTransSalesEntry; "Deal Modifier Added Amt.")
//             {
//             }
//             column(DealModifierLineNo_LSCTransSalesEntry; "Deal Modifier Line No.")
//             {
//             }
//             column(DiscAmountFromStdPrice_LSCTransSalesEntry; "Disc. Amount From Std. Price")
//             {
//             }
//             column(Discount_LSCTransSalesEntry; "Discount %")
//             {
//             }
//             column(DiscountAmount_LSCTransSalesEntry; "Discount Amount")
//             {
//             }
//             column(DiscountAmtForPrinting_LSCTransSalesEntry; "Discount Amt. For Printing")
//             {
//             }
//             column(DivisionCode_LSCTransSalesEntry; "Division Code")
//             {
//             }
//             column(EBTCash_LSCTransSalesEntry; EBTCash)
//             {
//             }
//             column(EBTCashTaxExempted_LSCTransSalesEntry; "EBTCash Tax Exempted")
//             {
//             }
//             column(ExcludedBOMLineNo_LSCTransSalesEntry; "Excluded BOM Line No.")
//             {
//             }
//             column(ExpirationDate_LSCTransSalesEntry; "Expiration Date")
//             {
//             }
//             column(GenBusPostingGroup_LSCTransSalesEntry; "Gen. Bus. Posting Group")
//             {
//             }
//             column(GenProdPostingGroup_LSCTransSalesEntry; "Gen. Prod. Posting Group")
//             {
//             }
//             column(InfocodeDiscount_LSCTransSalesEntry; "Infocode Discount")
//             {
//             }
//             column(InfocodeEntryLineNo_LSCTransSalesEntry; "Infocode Entry Line No.")
//             {
//             }
//             column(InfocodeSelectedQty_LSCTransSalesEntry; "Infocode Selected Qty.")
//             {
//             }
//             column(ItemCategoryCode_LSCTransSalesEntry; "Item Category Code")
//             {
//             }
//             column(ItemCorrectedLine_LSCTransSalesEntry; "Item Corrected Line")
//             {
//             }
//             column(ItemDiscGroup_LSCTransSalesEntry; "Item Disc. Group")
//             {
//             }
//             column(ItemNo_LSCTransSalesEntry; "Item No.")
//             {
//             }
//             column(ItemNumberScanned_LSCTransSalesEntry; "Item Number Scanned")
//             {
//             }
//             column(ItemPostingGroup_LSCTransSalesEntry; "Item Posting Group")
//             {
//             }
//             column(KeyboardItemEntry_LSCTransSalesEntry; "Keyboard Item Entry")
//             {
//             }
//             column(Limitation_LSCTransSalesEntry; Limitation)
//             {
//             }
//             column(LimitationTaxExempted_LSCTransSalesEntry; "Limitation Tax Exempted")
//             {
//             }
//             column(LineDiscount_LSCTransSalesEntry; "Line Discount")
//             {
//             }
//             column(LineNo_LSCTransSalesEntry; "Line No.")
//             {
//             }
//             column(LineType_LSCTransSalesEntry; "Line Type")
//             {
//             }
//             column(LinewasDiscounted_LSCTransSalesEntry; "Line was Discounted")
//             {
//             }
//             column(LinkedNonotOrig_LSCTransSalesEntry; "Linked No. not Orig.")
//             {
//             }
//             column(LotNo_LSCTransSalesEntry; "Lot No.")
//             {
//             }
//             column(LSCINExempted_LSCTransSalesEntry; "LSCIN Exempted")
//             {
//             }
//             column(LSCINGSTAmount_LSCTransSalesEntry; "LSCIN GST Amount")
//             {
//             }
//             column(LSCINGSTGroupCode_LSCTransSalesEntry; "LSCIN GST Group Code")
//             {
//             }
//             column(LSCINGSTGroupType_LSCTransSalesEntry; "LSCIN GST Group Type")
//             {
//             }
//             column(LSCINGSTJurisdictionType_LSCTransSalesEntry; "LSCIN GST Jurisdiction Type")
//             {
//             }
//             column(LSCINGSTPlaceofSupply_LSCTransSalesEntry; "LSCIN GST Place of Supply")
//             {
//             }
//             column(LSCINHSNSACCode_LSCTransSalesEntry; "LSCIN HSN/SAC Code")
//             {
//             }
//             column(LSCINNetPrice_LSCTransSalesEntry; "LSCIN Net Price")
//             {
//             }
//             column(LSCINPriceInclusiveofTax_LSCTransSalesEntry; "LSCIN Price Inclusive of Tax")
//             {
//             }
//             column(LSCINRestaurantSale_LSCTransSalesEntry; "LSCIN Restaurant Sale")
//             {
//             }
//             column(LSCINTaxDiscPolicyApplied_LSCTransSalesEntry; "LSCIN Tax Disc. Policy Applied")
//             {
//             }
//             column(LSCINTaxType_LSCTransSalesEntry; "LSCIN Tax Type")
//             {
//             }
//             column(LSCINTotalUPITAmount_LSCTransSalesEntry; "LSCIN Total UPIT Amount")
//             {
//             }
//             column(LSCINUnitPriceInclofTax_LSCTransSalesEntry; "LSCIN Unit Price Incl. of Tax")
//             {
//             }
//             column(MarkedforGiftReceipt_LSCTransSalesEntry; "Marked for Gift Receipt")
//             {
//             }
//             column(MemberPoints_LSCTransSalesEntry; "Member Points")
//             {
//             }
//             column(MemberPointsType_LSCTransSalesEntry; "Member Points Type")
//             {
//             }
//             column(NetAmount_LSCTransSalesEntry; "Net Amount")
//             {
//             }
//             column(NetPrice_LSCTransSalesEntry; "Net Price")
//             {
//             }
//             column(OfferBlockedPoints_LSCTransSalesEntry; "Offer Blocked Points")
//             {
//             }
//             column(OrigTransLineNo_LSCTransSalesEntry; "Orig Trans Line No.")
//             {
//             }
//             column(OrigTransNo_LSCTransSalesEntry; "Orig Trans No.")
//             {
//             }
//             column(OrigTransPos_LSCTransSalesEntry; "Orig Trans Pos")
//             {
//             }
//             column(OrigTransStore_LSCTransSalesEntry; "Orig Trans Store")
//             {
//             }
//             column(OrigCostPrice_LSCTransSalesEntry; "Orig. Cost Price")
//             {
//             }
//             column(OrigfromInfocode_LSCTransSalesEntry; "Orig. from Infocode")
//             {
//             }
//             column(OrigfromSubcode_LSCTransSalesEntry; "Orig. from Subcode")
//             {
//             }
//             column(OrigofaLinkedItemList_LSCTransSalesEntry; "Orig. of a Linked Item List")
//             {
//             }
//             column(PackageParentLineNo_LSCTransSalesEntry; "Package Parent Line No.")
//             {
//             }
//             column(ParentItemNo_LSCTransSalesEntry; "Parent Item No.")
//             {
//             }
//             column(ParentLineNo_LSCTransSalesEntry; "Parent Line No.")
//             {
//             }
//             column(PeriodicDiscGroup_LSCTransSalesEntry; "Periodic Disc. Group")
//             {
//             }
//             column(PeriodicDiscType_LSCTransSalesEntry; "Periodic Disc. Type")
//             {
//             }
//             column(PeriodicDiscount_LSCTransSalesEntry; "Periodic Discount")
//             {
//             }
//             column(PLBItem_LSCTransSalesEntry; "PLB Item")
//             {
//             }
//             column(POSTerminalNo_LSCTransSalesEntry; "POS Terminal No.")
//             {
//             }
//             column(PostingExceptionKey_LSCTransSalesEntry; "Posting Exception Key")
//             {
//             }
//             column(Price_LSCTransSalesEntry; Price)
//             {
//             }
//             column(PriceChange_LSCTransSalesEntry; "Price Change")
//             {
//             }
//             column(PriceGroupCode_LSCTransSalesEntry; "Price Group Code")
//             {
//             }
//             column(PriceinBarcode_LSCTransSalesEntry; "Price in Barcode")
//             {
//             }
//             column(PromotionNo_LSCTransSalesEntry; "Promotion No.")
//             {
//             }
//             column(Quantity_LSCTransSalesEntry; Quantity)
//             {
//             }
//             column(ReceiptNo_LSCTransSalesEntry; "Receipt No.")
//             {
//             }
//             column(RecommendedItem_LSCTransSalesEntry; "Recommended Item")
//             {
//             }
//             column(ReducedQuantity_LSCTransSalesEntry; "Reduced Quantity")
//             {
//             }
//             column(RefundQty_LSCTransSalesEntry; "Refund Qty.")
//             {
//             }
//             column(RefundedLineNo_LSCTransSalesEntry; "Refunded Line No.")
//             {
//             }
//             column(RefundedPOSNo_LSCTransSalesEntry; "Refunded POS No.")
//             {
//             }
//             column(RefundedStoreNo_LSCTransSalesEntry; "Refunded Store No.")
//             {
//             }
//             column(RefundedTransNo_LSCTransSalesEntry; "Refunded Trans. No.")
//             {
//             }
//             column(Replicated_LSCTransSalesEntry; Replicated)
//             {
//             }
//             column(ReplicationCounter_LSCTransSalesEntry; "Replication Counter")
//             {
//             }
//             column(RetailProductCode_LSCTransSalesEntry; "Retail Product Code")
//             {
//             }
//             column(ReturnNoSale_LSCTransSalesEntry; "Return No Sale")
//             {
//             }
//             column(SalesStaff_LSCTransSalesEntry; "Sales Staff")
//             {
//             }
//             column(SalesTaxRounding_LSCTransSalesEntry; "Sales Tax Rounding")
//             {
//             }
//             column(SalesType_LSCTransSalesEntry; "Sales Type")
//             {
//             }
//             column(ScaleItem_LSCTransSalesEntry; "Scale Item")
//             {
//             }
//             column(Section_LSCTransSalesEntry; Section)
//             {
//             }
//             column(SerialNo_LSCTransSalesEntry; "Serial No.")
//             {
//             }
//             column(SerialLotNoNotValid_LSCTransSalesEntry; "Serial/Lot No. Not Valid")
//             {
//             }
//             column(Shelf_LSCTransSalesEntry; Shelf)
//             {
//             }
//             column(ShiftDate_LSCTransSalesEntry; "Shift Date")
//             {
//             }
//             column(ShiftNo_LSCTransSalesEntry; "Shift No.")
//             {
//             }
//             column(StaffID_LSCTransSalesEntry; "Staff ID")
//             {
//             }
//             column(StandardNetPrice_LSCTransSalesEntry; "Standard Net Price")
//             {
//             }
//             column(StatementCode_LSCTransSalesEntry; "Statement Code")
//             {
//             }
//             column(StoreNo_LSCTransSalesEntry; "Store No.")
//             {
//             }
//             column(SystemExcludeFromPrint_LSCTransSalesEntry; "System-Exclude From Print")
//             {
//             }
//             column(SystemCreatedAt_LSCTransSalesEntry; SystemCreatedAt)
//             {
//             }
//             column(SystemCreatedBy_LSCTransSalesEntry; SystemCreatedBy)
//             {
//             }
//             column(SystemId_LSCTransSalesEntry; SystemId)
//             {
//             }
//             column(SystemModifiedAt_LSCTransSalesEntry; SystemModifiedAt)
//             {
//             }
//             column(SystemModifiedBy_LSCTransSalesEntry; SystemModifiedBy)
//             {
//             }
//             column(TaxGroupCode_LSCTransSalesEntry; "Tax Group Code")
//             {
//             }
//             column(Time_LSCTransSalesEntry; "Time")
//             {
//             }
//             column(TotDiscInfoLineNo_LSCTransSalesEntry; "Tot. Disc Info Line No.")
//             {
//             }
//             column(TotalDisc_LSCTransSalesEntry; "Total Disc.%")
//             {
//             }
//             column(TotalDiscount_LSCTransSalesEntry; "Total Discount")
//             {
//             }
//             column(TotalRoundedAmt_LSCTransSalesEntry; "Total Rounded Amt.")
//             {
//             }
//             column(TransDate_LSCTransSalesEntry; "Trans. Date")
//             {
//             }
//             column(TransTime_LSCTransSalesEntry; "Trans. Time")
//             {
//             }
//             column(TransactionCode_LSCTransSalesEntry; "Transaction Code")
//             {
//             }
//             column(TransactionNo_LSCTransSalesEntry; "Transaction No.")
//             {
//             }
//             column(TypeofSale_LSCTransSalesEntry; "Type of Sale")
//             {
//             }
//             column(UnitofMeasure_LSCTransSalesEntry; "Unit of Measure")
//             {
//             }
//             column(UOMPrice_LSCTransSalesEntry; "UOM Price")
//             {
//             }
//             column(UOMQuantity_LSCTransSalesEntry; "UOM Quantity")
//             {
//             }
//             column(VariantCode_LSCTransSalesEntry; "Variant Code")
//             {
//             }
//             column(VATAmount_LSCTransSalesEntry; "VAT Amount")
//             {
//             }
//             column(VATBusPostingGroup_LSCTransSalesEntry; "VAT Bus. Posting Group")
//             {
//             }
//             column(VATCalculationType_LSCTransSalesEntry; "VAT Calculation Type")
//             {
//             }
//             column(VATCode_LSCTransSalesEntry; "VAT Code")
//             {
//             }
//             column(VATProdPostingGroup_LSCTransSalesEntry; "VAT Prod. Posting Group")
//             {
//             }
//             column(WeightItem_LSCTransSalesEntry; "Weight Item")
//             {
//             }
//             column(WeightManuallyEntered_LSCTransSalesEntry; "Weight Manually Entered")
//             {
//             }
//             column(xStatementNo_LSCTransSalesEntry; "xStatement No.")
//             {
//             }
//             column(xTransactionStatus_LSCTransSalesEntry; "xTransaction Status")
//             {
//             }
//             trigger OnAfterGetRecord()
//             begin
//             end;

//             trigger OnPreDataItem()
//             var
//                 myInt: Integer;
//             begin

//             end;
//         }

//     }
//     requestpage
//     {
//         layout
//         {
//             area(Content)
//             {


//             }
//         }
//     }
//     trigger OnPreReport()
//     var
//         myInt: Record "LSC Trans. SalesTax Entry";
//     begin

//     end;

//     var

// }