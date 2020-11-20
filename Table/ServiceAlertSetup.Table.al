table 1044863 "Service Alert Setup"
{
    // +--------------------------------------------------------------+
    // | @ 2017 incadea Taiwan Limited                                |
    // +--------------------------------------------------------------+
    // | PURPOSE: MARS_TWN                                            |
    // |                                                              |
    // +--------------------------------------------------------------+
    // 
    // VERSION       ID          WHO    DATE        DESCRIPTION
    // TWN.01.03     RGW_TWN-350 NN     2017-06-04  Upgrade from r3
    // RGS_TWN-888   122187	     QX	    2020-10-26  Remove field Replication Filter because table Replication Filter was removed

    Caption = 'Service Alert Setup';
    DataPerCompany = false;
    //++TWN1.00.122187.QX
    // Page 1044457 (VC Info Subp. Brake Pad) is removed
    // LookupPageID = 1044457;
    LookupPageID = "Vehicle Check Values Sub";
    Description = '122187';
    //--TWN1.00.122187.QX

    fields
    {
        field(1; "Service Type"; Code[20])
        {
            Caption = 'Service Type';
            TableRelation = "Service Type Master".Code;
        }
        field(2; "Services Based On"; Option)
        {
            Caption = 'Services Based On';
            OptionCaption = 'Milage,Duration';
            OptionMembers = Milage,Duration;
        }
        field(3; "Milege Km per"; Integer)
        {
            Caption = 'Milege Km per';
        }
        field(4; "Due Date Formula"; DateFormula)
        {
            Caption = 'Due Date Formula';
        }
        field(1017361; "Central Maintenance"; Boolean)
        {
            Caption = 'Central Maintenance';
            Description = 'IT_6396';
        }
        field(1028275; "Deleted By HQ"; Boolean)
        {
            Caption = 'Deleted by HQ';
            Description = 'IT_7169';
        }
        field(1028276; "Replication Date"; DateTime)
        {
            Caption = 'Replication Date';
            Description = 'IT_7169';
            Editable = false;
        }
        field(1028277; "Repl. Post Run Finished"; Boolean)
        {
            Caption = 'Repl. Post Run Finished';
            Description = 'IT_7169';
        }

        //++TWN1.00.122187.QX
        field(1028278; "Replication Filter"; Code[2])
        {
            Caption = 'Replication Filter';
            Description = 'IT_7169,122187';
            // TableRelation = "Replication Filter";
            ObsoleteState = Removed;
            ObsoleteReason = 'Related table ''Replication Filter'' is removed.';
        }
        //--TWN1.00.122187.QX
    }

    keys
    {
        key(Key1; "Service Type")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

