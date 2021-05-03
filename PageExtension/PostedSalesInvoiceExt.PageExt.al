pageextension 1044868 "Posted Sales Invoice Ext" extends "Posted Sales Invoice"
{
    layout
    {
        addafter("Pre-Assigned No.")
        {
            field("Campaign No."; "Campaign No.")
            {
                Editable = false;
            }
        }
        addafter("Fitter 1")
        {
            field("Final Check Name"; "Final Check Name")
            {
                Editable = false;
            }
        }
        addafter("Order Type")
        {
            field("VAT Registration No."; "VAT Registration No.")
            {
                Editable = false;
            }
            field("Bill-to Company Name"; "Bill-to Company Name")
            {
                Editable = false;
            }
        }
    }
}

