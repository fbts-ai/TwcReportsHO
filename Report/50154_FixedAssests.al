report 50158 FixedAssetsReport
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    Caption = 'Fixed Assets Report';
    DefaultLayout = Excel;
    ExcelLayout = 'Report/Fixed Assets Report.xlsx';
    //RDLCLayout = 'Report/Fixed Assets Report.rdl';
    dataset
    {
        dataitem("Fixed Asset"; "Fixed Asset")
        {
            RequestFilterFields = "No.", "FA Class Code", "FA Subclass Code", "FA Posting Group", "FA Location Code";

            column(No_; "No.")
            { }
            column(Description; Description)
            { }
            column(FA_Class_Code; "FA Class Code")
            { }
            column(FA_Subclass_Code; "FA Subclass Code")
            { }
            column(FA_Location_Code; "FA Location Code")
            { }
            column(FA_Location_Name; LocationRec_gVar.Name)
            { }
            column(Parent_Fixed_Asset; "Parent Fixed Asset")
            { }
            column(Search_Description; "Search Description")
            { }
            column(Acquired; Acquired)
            { }
            column(Amount; '')
            { }
            dataitem("FA Depreciation Book"; "FA Depreciation Book")
            {
                DataItemLink = "FA No." = field("No.");
                CalcFields = "Book Value";
                column(Book_Value; "Book Value")
                { }
            }
            trigger OnAfterGetRecord()
            var
                myInt: Integer;
            begin

                If LocationRec_gVar.Get("FA Location Code") then;
            end;
        }
    }

    requestpage
    {
        AboutTitle = 'Teaching tip title';
        AboutText = 'Teaching tip content';
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                    // field(Name; SourceExpression)
                    // {

                    // }
                }
            }
        }

        actions
        {
            area(processing)
            {
                action(LayoutName)
                {

                }
            }
        }
    }

    var
        LocationRec_gVar: Record Location;
}