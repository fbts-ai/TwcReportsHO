//AJ_ALLE_25012024
report 50144 "Wastage Entry Status"
{
    Caption = 'Wastage Entry Status Report';
    ApplicationArea = all;
    ProcessingOnly = true;
    UsageCategory = ReportsAndAnalysis;
    // DefaultLayout = Excel;
    // ExcelLayout = '.vscode/Layouts/WastageEntryStatus.xlsx';

    dataset
    {
        dataitem(WastageEntryHeader; WastageEntryHeader)
        {
            RequestFilterFields = Status, "Created Date";

            column(No_; "No.") { }
            column(Location_Code; "Location Code") { }
            column(CreatedBy; CreatedBy) { }
            column(Created_Date; "Created Date") { }
            column(Status; Status) { }

            trigger OnAfterGetRecord()
            begin
                MakeExcelDataBody();
            end;
        }
    }
    requestpage
    {
        SaveValues = true;
        layout
        {
            area(Content)
            { }
        }
    }

    trigger OnPreReport()
    begin
        MakeExcelDataHeader();
    end;

    trigger OnPostReport()
    begin
        CreateExcelBook();
    end;

    var
        ExcelBuf: Record "Excel Buffer" temporary;

    local procedure MakeExcelDataHeader()
    begin
        AddTextColumn('No.');
        AddTextColumn('Location Code');
        AddTextColumn('CreatedBy');
        AddTextColumn('Created Date');
        AddTextColumn('Status');
    end;

    procedure MakeExcelDataBody()
    begin
        ExcelBuf.NewRow();
        AddTextColumn(WastageEntryHeader."No.");
        AddTextColumn(WastageEntryHeader."Location Code");
        AddTextColumn(WastageEntryHeader.CreatedBy);
        ExcelBuf.AddColumn(WastageEntryHeader."Created Date", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Date);
        AddTextColumn(WastageEntryHeader.Status);
    end;

    local procedure AddTextColumn(Value: Variant)
    begin
        ExcelBuf.AddColumn(Value, false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
    end;

    procedure CreateExcelBook()
    var
        CurrDateTime: DateTime;
    begin
        CurrDateTime := CurrentDateTime;
        ExcelBuf.CreateNewBook('Wastage Entry Status Report');
        ExcelBuf.WriteSheet('Wastage Entry Status Report', COMPANYNAME, USERID);
        ExcelBuf.CloseBook();
        ExcelBuf.SetFriendlyFilename('Wastage Entry Status Report ' + Format(CurrDateTime));
        ExcelBuf.OpenExcel();
    end;

}