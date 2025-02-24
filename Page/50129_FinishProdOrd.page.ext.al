pageextension 50128 "FinishProdOrd - Pg Ext" extends "Finished Production Order"
{
    actions
    {
        // Add changes to page actions here
        addfirst("O&rder")
        {
            action("Print Label")
            {
                ApplicationArea = All;
                Image = PrintInstallment;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    ProdOrd: Record "Production Order";
                begin
                    ProdOrd.Reset();
                    ProdOrd.SetRange("No.", Rec."No.");

                    IF ProdOrd.FindFirst() then
                        Report.RunModal(Report::"Report - Label Print", true, false, ProdOrd);
                end;
            }
        }
    }

    var
        myInt: Integer;
}