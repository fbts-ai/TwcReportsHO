//AJ_ALLE_092520233
report 50135 AllowPostingFrom
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    ProcessingOnly = true;
    dataset
    {
        dataitem("User Setup"; "User Setup")
        {
            // trigger OnAfterGetRecord() //OLD Code //PT-FBTS
            // begin
            //     if "User Setup"."Admin-Allow Post" = true then begin
            //         "User Setup"."Allow Posting To" := 0D;
            //         "User Setup"."Allow Posting From" := 0D;
            //         "User Setup".Modify();
            //     end else begin
            //         "User Setup"."Allow Posting To" := Today;
            //         "User Setup".Modify();
            //     end;

            // end;
            trigger OnAfterGetRecord() //New Code //PT-FBTS
            begin
                if "User Setup"."Admin-Allow Post" = true then begin
                    "User Setup"."Allow Posting To" := 0D;
                    "User Setup"."Allow Posting From" := 0D;
                    "User Setup".Modify();
                end else begin
                    if "User Setup".StoreLive = true then begin
                        "User Setup"."Allow Posting To" := Today;
                        "User Setup"."Allow Posting From" := Today - 1;
                        "User Setup".Modify();
                    end else begin
                        if "User Setup".AutomaticPostingDateCheck = true then begin
                            "User Setup"."Allow Posting To" := Today;
                            "User Setup"."Allow Posting From" := Today;
                            "User Setup".Modify();

                        end else begin
                            "User Setup"."Allow Posting To" := Today;
                            "User Setup".Modify();
                        end;
                    end;
                end;
            end;

        }
    }
}