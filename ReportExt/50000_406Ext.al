reportextension 50000 TransferRecExt extends 5705
{
    dataset
    {
        // Add changes to dataitems and columns here
        add("Transfer Receipt Header")
        {
            column(Transfer_Order_No_; "Transfer Order No.")
            {

            }
        }
    }

    requestpage
    {
        // Add changes to the requestpage here
    }

    rendering
    {
        layout(LayoutName)
        {
            Type = RDLC;
            LayoutFile = 'mylayout.rdl';
        }
    }
}