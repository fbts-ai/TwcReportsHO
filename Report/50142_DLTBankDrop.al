report 50146 "DLT-BankDropSpecific"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    ProcessingOnly = true;
    Permissions = tabledata "Bank Drop Main" = d, tabledata "Bank Drop Denomination Main" = d, tabledata "Bank Drop Denomination Temp" = d;
    dataset
    {
        dataitem("Bank Drop Main"; "Bank Drop Main")
        {
            //RequestFilterFields = StoreCode, BankDropDate1;
            trigger OnAfterGetRecord()
            begin
                "Bank Drop Main".Delete();
            end;

            trigger OnPreDataItem()
            var
                myInt: Integer;
            begin
                "Bank Drop Main".SetFilter(BankDropDate1, '%1', "Select Date");
                "Bank Drop Main".SetRange(StoreCode, "Store Code");
            end;
        }
        dataitem("Bank Drop Denomination Main"; "Bank Drop Denomination Main")
        {
            // RequestFilterFields = Store_No, BankDropDate;
            trigger OnAfterGetRecord()
            begin
                "Bank Drop Denomination Main".Delete();
            end;

            trigger OnPreDataItem()
            var
                myInt: Integer;
            begin
                "Bank Drop Denomination Main".SetFilter(BankDropDate, '%1', "Select Date");
                "Bank Drop Denomination Main".SetRange(Store_No, "Store Code");
            end;
        }
        dataitem("Bank Drop Denomination Temp"; "Bank Drop Denomination Temp")
        {
            //RequestFilterFields = Store_No, "Date/Time";
            trigger OnAfterGetRecord()
            begin
                "Bank Drop Denomination Temp".Delete();
            end;

            trigger OnPreDataItem()
            var
                myInt: Integer;
            begin
                "Bank Drop Denomination Temp".SetFilter("Date/Time", '%1', "Select Date & Time");
                "Bank Drop Denomination Temp".SetRange(Store_No, "Store Code");
            end;
        }

    }
    requestpage
    {
        layout
        {
            area(Content)
            {

                field("Store Code"; "Store Code")
                {
                    ApplicationArea = all;
                    TableRelation = "LSC Store"."No.";
                }
                field("Select Date"; "Select Date")
                {
                    ApplicationArea = all;
                }
                field("Select Date & Time"; "Select Date & Time")
                {
                    ApplicationArea = all;
                }
            }
        }
    }
    trigger OnPreReport()
    var
        myInt: Integer;

    begin
        if UserSetup.Get(UserId) then;
        if UserSetup."User ID" <> 'ALLE' then Error('Not Authorised');
        //if UserSetup."User ID" <> 'DYNAMICS-DEV-VM\ALLE2' then Error('Not Authorised');
        if "Store Code" = '' then Error('Store Can Not be Empty');
        if "Select Date" = 0D then Error('Date Can Not be Empty');
        if "Select Date & Time" = 0DT then Error('Date & Time Can not be empty');
    end;

    var
        UserSetup: Record "User Setup";
        "Store Code": Code[20];
        "Select Date": Date;
        "Select Date & Time": DateTime;

}