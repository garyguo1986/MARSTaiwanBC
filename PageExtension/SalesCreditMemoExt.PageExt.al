pageextension 1044895 "Sales Credit Memo Ext." extends "Sales Credit Memo"
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
