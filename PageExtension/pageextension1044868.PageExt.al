pageextension 1044868 pageextension1044868 extends "Posted Sales Invoice"
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
            }
        }
        addafter("Order Type")
        {
            field("VAT Registration No."; "VAT Registration No.")
            {
            }
            field("Bill-to Company Name"; "Bill-to Company Name")
            {
            }
        }
    }
}

