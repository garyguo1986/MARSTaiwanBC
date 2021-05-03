pageextension 1044896 "Sales Return Order Ext." extends "Sales Return Order"
{
    layout
    {
        addafter("Phone No.")
        {
            field("VATRegistrationNo"; "VAT Registration No.")
            {
            }
        }
    }
}
