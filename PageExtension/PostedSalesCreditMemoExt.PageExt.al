pageextension 1044869 "Posted Sales Credit Memo Ext" extends "Posted Sales Credit Memo"
{
    layout
    {
        addafter("External Document No.")
        {
            field("Campaign No."; "Campaign No.")
            {
                Editable = false;
            }
        }
        addafter("No. Printed")
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

