tableextension 1044885 "Fastfit Setup - User Ext" extends "Fastfit Setup - User"
{
    fields
    {
        field(1073850; "Fax Printer Name"; Text[250])
        {
            // Removed Core ID: 1022
            Caption = 'Fax Printer Name';
            Description = 'RGS_TWN-350';
            TableRelation = Printer;
        }
    }
}

