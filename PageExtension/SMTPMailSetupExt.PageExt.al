pageextension 1044871 "SMTP Mail Setup Ext" extends "SMTP Mail Setup"
{
    layout
    {
        addafter("Sender Address")
        {
            field("SMS Mail Address"; "SMS Mail Address")
            {
            }
        }
    }
}

