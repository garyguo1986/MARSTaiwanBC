tableextension 1073874 "Purch. Rcpt. Header Ext" extends "Purch. Rcpt. Header"
{
    fields
    {
        field(50000; "OCT Order No."; Code[30])
        {
            Caption = 'OCT Order No.';
            DataClassification = ToBeClassified;
        }
    }
}
