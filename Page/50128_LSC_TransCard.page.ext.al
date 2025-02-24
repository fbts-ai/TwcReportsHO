pageextension 50129 "LscTransCard - Pg Ext" extends "LSC Transaction Card"
{
    actions
    {
        addfirst(Navigation)
        {
            action("Tax Invoice")
            {
                ApplicationArea = All;
                Image = SalesInvoice;
                Promoted = true;
                PromotedCategory = Report;
                PromotedOnly = true;

                trigger OnAction()
                var
                    LTH: Record "LSC Transaction Header";
                begin

                    LTH.Reset();
                    // LTH.SetRange("Sales Type", Rec."Sales Type");
                    // LTH.SetRange("Receipt No.", Rec."Receipt No.");
                    LTH.SetRange("Store No.", Rec."Store No.");
                    LTH.SetRange("POS Terminal No.", Rec."POS Terminal No.");
                    LTH.SetRange("Transaction No.", Rec."Transaction No.");
                    IF LTH.FindFirst() THEN;
                    Report.Run(Report::"TaxInvoice - Pos", true, false, LTH);
                end;
            }
        }
    }

    var
        myInt: Integer;
}