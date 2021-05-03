tableextension 1044882 "Sales Cr.Memo Header Ext" extends "Sales Cr.Memo Header"
{
    fields
    {
        field(50000; "Sales Cancellation"; Boolean)
        {
            Caption = 'Sales Cancellation';
            Description = 'RGS_TWN-425';
        }
        field(1044864; "Bill-to Company Name"; Text[50])
        {
            Caption = 'Bill-to Company Name';
            Description = 'RGS_TWN-342';
        }
        field(1073850; Canceled; Boolean)
        {
            // Removed Core ID: 1300
            Caption = 'Canceled';
        }
    }
}

