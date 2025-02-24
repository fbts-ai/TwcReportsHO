report 50165 "Item Voided Report"
{
    UsageCategory = ReportsAndAnalysis;
    Caption = 'Item Voided Report';
    ApplicationArea = All;
    ExcelLayout = 'Report/Item Voided Report.xlsx';
    DefaultLayout = Excel;

    dataset
    {
        dataitem("LSC POS Voided Trans. Line"; "LSC POS Voided Trans. Line")
        {
            RequestFilterFields = "Store No.", "Trans. Date";
            DataItemTableView = where("Entry Type" = filter('Item'));
            column(Date_; "Trans. Date")
            {
            }
            column(Trans__Time; "Trans. Time")
            { }
            column(Store_No_; "Store No.")
            {
            }
            column(Receipt_No_; "Receipt No.")
            {
            }
            column(Item_No; Number)
            {
            }
            column(Description; Description)
            {
            }
            column(Quantity; Quantity)
            { }
            column(Created_by_Staff_ID; "Created by Staff ID")
            { }
            column(staff_Name; staffName)
            { }
            trigger OnAfterGetRecord()
            var
                myInt: Integer;
            begin
                Clear(staffName);
                Staff.Reset();
                Staff.SetRange(ID, "LSC POS Voided Trans. Line"."Created by Staff ID");
                if Staff.FindFirst() then
                    staffName := Staff."First Name";
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
                    //     ApplicationArea = All;

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
                    ApplicationArea = All;

                }
            }
        }
    }


    var
        Staff: Record "LSC Staff";
        staffName: Text[30];
}