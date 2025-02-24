//AJ_Alle_09192023
report 50136 "Postive Adj. against Neg sale"
{
    DefaultLayout = RDLC;
    RDLCLayout = '.vscode/Layouts/Postive Adj. against Neg sale.rdl';
    PDFFontEmbedding = default;
    ApplicationArea = all;
    dataset
    {
        dataitem(Location; 14)
        {

            trigger OnPreDataItem()
            begin
                Location.SETRANGE(Code, LocG_1);
                LocG := LocG_1;
            end;
        }
        dataitem(Item; 27)
        {
            CalcFields = Inventory, "Assembly BOM";
            DataItemTableView = SORTING("No.")
                                WHERE("No." = FILTER(<> 'ADV' & <> 'CITEM' & <> 'GH' & <> 'TOPKG' & <> 'A10001' & <> 'BANQUET'), ///some
                                      "Assembly BOM" = FILTER('No'));
            //   "Combo/Single/Hamper" = FILTER(<> 'Hamper Item'));
            RequestFilterFields = "No.";
            column(No_Item; Item."No.")
            {
            }
            column(Description_Item; Item.Description)
            {
            }
            column(Inventory_Item; Item.Inventory)
            {
            }
            column(QtySoldNotPst; QtySoldNotPst)
            {
            }
            column(Actual_Inv; Item.Inventory - QtySoldNotPst)
            {
            }
            column(RecCompanyInfo_Name; CompanyInfo.Name)
            {
            }
            column(RecCompanyInfo_Address; CompanyInfo.Address)
            {
            }
            column(RecCompanyInfo_Address2; CompanyInfo."Address 2")
            {
            }
            column(UOM; Item."Base Unit of Measure")
            {
            }
            column(GRP; Item."Item Category Code")
            {
            }
            column(LocG_1; LocG)
            {
            }
            column(DtG_1; DtG)
            {
            }

            trigger OnAfterGetRecord()
            begin
                QtySoldNotPst := BOUtils.ReturnQtySoldNotPosted(Item."No.", LocG, LocG, '', DtG) +
                                 GetSOItem(Item."No.", LocG, DtG, FALSE) +
                                 GetSOItem(Item."No.", LocG, DtG, TRUE);

                // IF NOT Item."No Stock Posting" THEN //AJ_Alle_09192023
                IF ((Item.Inventory - QtySoldNotPst) < 0) THEN
                    CreateIJL(Item."No.", LocG, (Item.Inventory - QtySoldNotPst), DtG);

                //MESSAGE(FORMAT(Item.Inventory));
                //MESSAGE(FORMAT(QtySoldNotPst));
            end;

            trigger OnPreDataItem()
            begin
                QtySoldNotPst := 0;
                Item.SETFILTER("Date Filter", FORMAT(_Date));
                Item.SETRANGE("Location Filter", LocG);
                //Item.SETRANGE("Store code", LocG);
                //Item.SETRANGE("Store Filter", LocG);//AJ_Alle_09192023
            end;
        }
        dataitem("BOM Component"; 90)
        {
            DataItemTableView = SORTING("Parent Item No.", "Line No.");
            column(CItem; "BOM Component"."No.")
            {
            }
            column(IRec_Desc; ItemRec.Description)
            {
            }
            column(IRec_Cat; ItemRec."Item Category Code")
            {
            }
            column(IRec_UOM; "BOM Component"."Unit of Measure Code")
            {
            }
            column(CQty; ROUND(QtyPer, 0.00001))
            {
            }
            column(PItem; "BOM Component"."Parent Item No.")
            {
            }
            column(IRecParent_Desc; ItemRecParent.Description)
            {
            }
            column(IRecParent_Cat; ItemRecParent."Item Category Code")
            {
            }
            column(IRecParent_UOM; ItemRecParent."Base Unit of Measure")
            {
            }
            column(QtySoldNotPst_bom1; QtySoldNotPst_BOM)
            {
            }
            column(ChildQtySold; ROUND(QtyPer, 0.00001) * QtySoldNotPst_BOM)
            {
            }
            column(INvChild; ItemRec.Inventory)
            {
            }
            column(Actual_Child_Inv; (ROUND(QtyPer, 0.00001) * QtySoldNotPst_BOM))
            {
            }

            trigger OnAfterGetRecord()
            begin
                IF ItemUnit.GET("BOM Component"."No.", "BOM Component"."Unit of Measure Code") THEN
                    QtyPer := "BOM Component"."Quantity per" * ItemUnit."Qty. per Unit of Measure";

                QtySoldNotPst_BOM := BOUtils.ReturnQtySoldNotPosted("BOM Component"."No.", LocG, LocG, '', DtG) +
                                     //GetSOItem("BOM Component"."Parent Item No.",LocG,DtG,FALSE)+
                                     GetSOItem("BOM Component"."No.", LocG, DtG, TRUE);

                ItemRec.RESET;
                ItemRec.SETRANGE("No.", "BOM Component"."No.");
                ItemRec.SETFILTER("Date Filter", DtG);
                ItemRec.SETFILTER("Location Filter", LocG);
                // ItemRec.SETFILTER("Store Filter", LocG);//Commented TRI S.S  //AJ_Alle_09192023
                ItemRec.SETFILTER("Store code", LocG);//Commented TRI S.S
                IF ItemRec.FINDFIRST THEN BEGIN
                    ItemRec.CALCFIELDS(Inventory);
                    //TRI S.S New Code - 21.03.18 -

                    IF ((ItemRec.Inventory - QtySoldNotPst_BOM) <= 0) AND (QtySoldNotPst_BOM <> 0) THEN
                        CreateIJL(ItemRec."No.", LocG, (ItemRec.Inventory - QtySoldNotPst_BOM), DtG);
                END;
                ///
                //TRI S.S New Code - 21.03.18 +

                //IF ItemRecParent.GET("BOM Component"."Parent Item No.") THEN;
            end;

            trigger OnPreDataItem()
            begin
                QtySoldNotPst_BOM := 0;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(Date_Filter; Date_Filter)
                {
                    Caption = 'Date Filter';
                }
                field(LocationFilter; LocationFilter)
                {
                    Caption = 'Location Filter';
                    Lookup = true;
                    TableRelation = Location.Code;
                }
                field(JnlTemplateName; JnlTemplateName)
                {
                    Caption = 'Batch Name';
                    Lookup = true;
                    TableRelation = "Item Journal Batch".Name WHERE("Journal Template Name" = FILTER('ITEM'));
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

    trigger OnPostReport()
    begin
        //CODEUNIT.RUN(CODEUNIT::"Item Jnl.-Post",IJLine);
    end;

    trigger OnPreReport()
    begin
        CompanyInfo.GET;
        DtG := FORMAT(Date_Filter);//FORMAT(TODAY);
        EVALUATE(_Date, DtG);
        LocG_1 := LocationFilter;
        IF JnlTemplateName = '' THEN
            ERROR('JnlTemplateName must have value');
        JnlTemplateBatch := JnlTemplateName;
    end;

    var
        QtySoldNotPst: Decimal;
        BOUtils: Codeunit 99001452;
        BomComponent: Record 90;
        Qty: Decimal;
        QtySoldNotPst_BOM: Decimal;
        ItemRec: Record 27;
        CompanyInfo: Record 79;
        ItemG: Code[20];
        LocG: Code[20];
        DtG: Code[20];
        ItemRecParent: Record 27;
        LocG_1: Code[20];
        QtyPer: Decimal;
        ItemUnit: Record 5404;
        UpdateIJL: Boolean;
        ItemJournalLine: Record 83;
        Date_Filter: Date;
        LocationFilter: Code[20];
        JnlTemplateBatch: Code[20];
        JnlTemplateName: Code[20];
        IJLine: Record 83;
        ItemRec1: Record 27;
        _Date: Date;
    //ItemJournalBatches: Page 262;

    procedure GetFilterData(DtFilter: Code[20]; LocFilter: Code[20])
    begin
        //ItemG:=ItemFilter;
        DtG := DtFilter;
        LocG_1 := LocFilter;
    end;

    procedure GetSOItem(ItemLocal: Code[20]; LocLocal: Code[20]; DateLocal: Text; Assembly: Boolean): Decimal
    var
        ItemFilter: Record 27;
    begin
        ItemFilter.RESET;
        ItemFilter.SETRANGE("No.", ItemLocal);
        ItemFilter.SETRANGE("Location Filter", LocLocal);
        ItemFilter.SETFILTER("Date Filter", DateLocal);
        IF ItemFilter.FINDFIRST THEN BEGIN
            IF NOT Assembly THEN BEGIN
                ItemFilter.CALCFIELDS("Qty. on Sales Order");
                EXIT(ItemFilter."Qty. on Sales Order");
            END ELSE BEGIN
                ItemFilter.CALCFIELDS("Qty. on Asm. Component");
                EXIT(ROUND(ItemFilter."Qty. on Asm. Component", 0.0001));
            END;
        END;
    end;

    local procedure CreateIJL(ItemCode: Code[20]; LocVar: Code[20]; QtyLocal: Decimal; DTLocal: Text)
    var
        IJLineTmp: Record 83;
        DTLoc: Date;
        Store: Record 99001470;
    begin
        IJLine.INIT;
        IJLine.VALIDATE("Journal Template Name", 'ITEM');
        IJLine.VALIDATE("Journal Batch Name", JnlTemplateName);
        IJLine.VALIDATE("Item No.", ItemCode);
        IJLine.VALIDATE("Entry Type", IJLine."Entry Type"::"Positive Adjmt.");
        EVALUATE(DTLoc, DTLocal);
        IJLine.VALIDATE("Posting Date", TODAY);
        IJLine.VALIDATE("Document No.", 'NEGS' + DTLocal);
        IJLineTmp.RESET;
        IJLineTmp.SETRANGE("Journal Template Name", 'ITEM');
        IJLineTmp.SETRANGE("Journal Batch Name", JnlTemplateName);
        IF IJLineTmp.FINDLAST THEN
            IJLine."Line No." := IJLineTmp."Line No." + 10000
        ELSE
            IJLine."Line No." := 10000;

        IJLine."Reason Code" := '+VEADJ';
        IJLine.VALIDATE("Location Code", LocVar);
        IJLine.VALIDATE(Quantity, -1 * QtyLocal);
        IF Store.GET(LocVar) THEN
            IJLine.VALIDATE("Shortcut Dimension 1 Code", Store."Global Dimension 1 Code");
        IJLine."Gen. Bus. Posting Group" := 'CONS';     //TRI TS
        IJLine.INSERT(TRUE);
    end;
}

