report 50168 "FA-In_Transit Report"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = Excel;
    ExcelLayout = 'Report/Through Transfer order.xlsx';
    dataset
    {
        dataitem("Transfer Line"; "Transfer Line")
        {
            DataItemTableView = where(
             "Derived From Line No." = filter(0), "Quantity Shipped" = filter(<> 0));
            RequestFilterFields = "Transfer-from Code", "Transfer-to Code";   //(FixedAssetNo = filter(<> ''),
            column(In_Transit_Code; "In-Transit Code")
            { }
            column(TO_Number; "Document No.")
            { }
            column(From_Location_Code; "Transfer-from Code")
            { }
            column(From_Location_Name; FromName)
            { }
            column(To_Location_Code; "Transfer-to Code")
            { }
            column(To_Location_Name; Toname)
            { }
            column(FAR; FixedAssetNo)
            { }
            column(Description; Description)
            { }
            column(FAM_Code; "Parent Fixed Asset")
            { }
            column(Posting_Date; TH_gvar."Posting Date")
            { }
            trigger OnAfterGetRecord()
            var
                myInt: Integer;
            begin
                Clear(Toname);
                Clear(FromName);
                if Location_Gvar.Get("Transfer-from Code") then
                    FromName := Location_Gvar.Name;
                if Location_Gvar.Get("Transfer-to Code") then
                    Toname := Location_Gvar.Name;
                TH_gvar.Reset();
                TH_gvar.SetRange("No.", "Transfer Line"."Document No.");
                if TH_gvar.FindFirst() then;
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
        myInt: Integer;
        Location_Gvar: Record Location;
        FromName: Text[100];
        Toname: Text[100];
        TH_gvar: Record "Transfer Header";
}