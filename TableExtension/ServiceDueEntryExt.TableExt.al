tableextension 1044884 "Service Due Entry Ext" extends "Service Due Entry"
{
    fields
    {
        field(1073850; "SMS Entry No."; Integer)
        {
            // Removed Core ID: 10 
            Caption = 'SMS Entry No.';
            Description = 'RGS_TWN-558';
        }
        field(1073851; "SMS Entry Creation Date"; Date)
        {
            // Removed Core ID: 11
            Caption = 'SMS Sent Date';
            Description = 'RGS_TWN-558';
        }
    }
}

