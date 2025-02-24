pageextension 50127 "OpenStatement - Pg Ext" extends "LSC Open Statement"
{
    layout
    {

        // modify("Trans. Starting Time")
        // {
        //     ApplicationArea = all;
        //     Visible = Show;
        //     Editable = Show;
        // }
        // modify("Trans. Starting Date")
        // {
        //     Caption = 'Tran. Starting_Date';
        //     ApplicationArea = all;
        //     Visible = Show;
        //     Editable = Show;
        // }
        // modify("Trans. Ending Date")
        // {
        //     ApplicationArea = all;
        //     Visible = Show;
        //     Editable = Show;
        // }
        // modify("Trans. Ending Time")
        // {
        //     ApplicationArea = all;
        //     Visible = Show;
        //     Editable = Show;

        // }
    }
    actions
    {
        addafter("&Post Statement")
        {
            action(CalcDiff)
            {
                ApplicationArea = All;
                Visible = false;
                Promoted = true;
                PromotedCategory = Process;
                Image = Excel;


                trigger OnAction()
                begin
                    SalesEntryStatus.Reset();
                    SalesEntryStatus.SetRange(Date, Rec."Posting Date");
                    SalesEntryStatus.SetRange("Store No.", Rec."Store No.");

                    IF SalesEntryStatus.FindSet() Then
                        GenStatemntDiff()
                    Else
                        Message('No Statement Found for Date %1  & Store %2', Rec."Posting Date", Rec."Store No.");
                end;
            }
            action("CalcDiff - CSV")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                Image = CalcWorkCenterCalendar;
                Visible = false;

                trigger OnAction()
                begin
                    CsvDiff(Rec."Posting Date", Rec."Store No.");
                end;
            }
        }
    }

    local procedure GenStatemntDiff()
    var
        TempBlob: Codeunit "Temp Blob";
        FileManagement: Codeunit "File Management";
        Instr: InStream;
        OutStrm: OutStream;
        StatDiff: Report "Report - Statement Diff";
        Progress: Dialog;
        ProgressStatus: Text;
    begin

        TempBlob.CreateOutStream(OutStrm);
        StatDiff.SetTableView(SalesEntryStatus);

        Progress.Open('Generating File... #1', ProgressStatus);
        IF StatDiff.SaveAs('', ReportFormat::Excel, OutStrm) THEN
            FileManagement.BLOBExport(TempBlob, 'Statement_Diff_' + Format(CURRENTDATETIME, 0, '<Day,2>_<Month,2>__<Hours24, 2><Minutes,2>') + '.xlsx', true);

        ProgressStatus := 'Completed Successfully';
        Progress.Update();
        Sleep(1500);
        Progress.Close();

        Commit();

        // Report.RunModal(Report::"Report - Statement Diff", true, false, SalesEntryStatus);
    end;

    local procedure CsvDiff(PostingDate: Date; StoreNo: Code[10])
    var
        TempBlob: Codeunit "Temp Blob";
        InS: InStream;
        OutS: OutStream;
        FileName: Text;
        TxtBuilder: TextBuilder;
        // StatEntry1: Record "LSC Trans. Sales Entry Status";
        TransSalesEntry: Record "LSC Trans. Sales Entry";
        ItemUOM: Record "Item Unit of Measure";
        BomComponent: Record "BOM Component";
        Item: Record Item;
        ItemList: List of [Code[20]];
        ItemQtyList: List of [Decimal];
        Indx: Integer;
        TransQty: Decimal;
        QtyReq: Decimal;
        DiffQty: Decimal;
        TempText: Text;
    begin
        FileName := 'Statement_Diff_CSV_' + Format(CURRENTDATETIME, 0, '<Day,2>_<Month,2>__<Hours24, 2><Minutes,2>') + '.csv';
        TxtBuilder.AppendLine('Date' + ',' + 'POS' + ',' + 'Item No.' + ',' + 'Description' + ',' + 'Quantity' + ',' + 'Inventory Qty' + ',' + 'UOM' + ',' + 'Difference' + ',' + 'Remarks');

        SalesEntryStatus.Reset();
        SalesEntryStatus.SetRange(Date, PostingDate);
        SalesEntryStatus.SetRange("Store No.", StoreNo);
        IF SalesEntryStatus.FindSet() Then Begin
            repeat
                TransSalesEntry.Reset();
                TransSalesEntry.SetRange("Transaction No.", SalesEntryStatus."Transaction No.");
                TransSalesEntry.SetRange("Store No.", SalesEntryStatus."Store No.");
                TransSalesEntry.SetRange("POS Terminal No.", SalesEntryStatus."POS Terminal No.");
                TransSalesEntry.SetRange("Line No.", SalesEntryStatus."Line No.");
                IF TransSalesEntry.FindFirst() Then begin
                    //Converting the item qty in base unit of measure
                    // ItemUOM.Reset();
                    // ItemUOM.SetRange("Item No.", TransSalesEntry."Item No.");
                    // ItemUOM.SetRange(Code, TransSalesEntry."Unit of Measure");
                    // IF ItemUOM.FindFirst() Then;

                    //Incase of modifier changing qty value
                    // IF TransSalesEntry."Parent Line No." <> 0 Then
                    //     TransSalesEntry.Quantity := TransSalesEntry."Infocode Selected Qty.";

                    //Inorder to convert Qty 2 Base UOM
                    TransQty := (TransSalesEntry.Quantity);

                    Clear(QtyReq);
                    BomComponent.SetRange("Parent Item No.", TransSalesEntry."Item No.");
                    IF BomComponent.FindSet() then begin
                        repeat
                            ItemUOM.Reset();
                            ItemUOM.SetRange("Item No.", BomComponent."No.");
                            ItemUOM.SetRange(Code, BomComponent."Unit of Measure Code");
                            IF ItemUOM.FindFirst() Then;
                            //Quantity Required
                            QtyReq := ABS(TransQty * (BomComponent."Quantity per" * ItemUOM."Qty. per Unit of Measure"));

                            IF ItemList.Contains(BomComponent."No.") Then begin
                                Indx := ItemList.IndexOf(BomComponent."No.");
                                ItemQtyList.Set(Indx, ItemQtyList.Get(Indx) + QtyReq);
                            end
                            Else begin
                                ItemList.Add(BomComponent."No.");
                                ItemQtyList.Add(QtyReq);
                            end;

                        until BomComponent.Next() = 0;
                    end
                    Else begin
                        //Quantity Required
                        QtyReq := ABS(TransQty);

                        IF ItemList.Contains(TransSalesEntry."Item No.") Then begin
                            Indx := ItemList.IndexOf(TransSalesEntry."Item No.");
                            ItemQtyList.Set(Indx, ItemQtyList.Get(Indx) + QtyReq);
                        end
                        Else begin
                            ItemList.Add(TransSalesEntry."Item No.");
                            ItemQtyList.Add(QtyReq);
                        end;
                    end;
                end;
            until SalesEntryStatus.Next() = 0;

            Clear(Indx);
            IF ItemList.Count > 0 Then begin
                for Indx := 1 to ItemList.Count do begin

                    IF ItemList.Get(Indx) <> '' Then begin
                        Item.Reset();
                        Item.SetRange("No.", ItemList.Get(Indx));
                        Item.SetFilter("Location Filter", '=%1', SalesEntryStatus."Store No.");
                        IF Item.FindFirst() Then
                            Item.CalcFields(Inventory);

                        //Difference
                        IF StrLen(Format(ItemQtyList.Get(Indx))) > 7 Then
                            ItemQtyList.Set(Indx, 0.00001);

                        DiffQty := ItemQtyList.Get(Indx) - Item.Inventory;


                        IF DiffQty > 0 Then
                            TxtBuilder.AppendLine(AddQuotes(Format(SalesEntryStatus.Date)) + ',' + AddQuotes(Format(SalesEntryStatus."POS Terminal No.")) + ',' + AddQuotes(ItemList.Get(Indx)) + ',' + AddQuotes(Item.Description) + ',' +
                                        AddQuotes(Format(ItemQtyList.Get(Indx))) + ',' + AddQuotes(Format(Item.Inventory)) + ',' + AddQuotes(Item."Base Unit of Measure") + ',' + AddQuotes(Format(DiffQty)));
                    end;

                end;
            end;

            TempBlob.CreateOutStream(OutS);
            OutS.WriteText(TxtBuilder.ToText());
            TempBlob.CreateInStream(InS);
            DownloadFromStream(InS, '', '', '', FileName);
        End
        Else
            Message('No Statement Found for Date %1  & Store %2', Rec."Posting Date", Rec."Store No.");
    end;

    local procedure AddQuotes(FieldValue: Text): Text
    begin
        exit('"' + FieldValue + '"');
    end;

    // trigger OnOpenPage()
    // var
    //     myInt: Integer;
    //     UserSetup: Record "User Setup";

    // begin
    //     if UserSetup.Get(UserId) then;
    //     if UserSetup."User ID" = 'DYNAMICS-DEV-VM\ALLE2' then //ALLE
    //         Show := true
    //     else
    //         Show := false;
    // end;


    var
        SalesEntryStatus: Record "LSC Trans. Sales Entry Status";
        test: Record "LSC Transaction Header";
    // Show: Boolean;
}