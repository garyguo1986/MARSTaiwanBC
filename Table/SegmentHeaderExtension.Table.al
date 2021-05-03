table 1044888 "Segment Header Extension"
{
    // +--------------------------------------------------------------+
    // | @ 2020 incadea Taiwan Limited                                |
    // +--------------------------------------------------------------+
    // | PURPOSE: MARS_TWN                                            |
    // |                                                              |
    // | REMARK :                                                     |
    // +--------------------------------------------------------------+
    // 
    // VERSION       ID            WHO    DATE        DESCRIPTION
    // RGS_AGL-3620  121528        GG     2020-06-03  New object


    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
        }
        field(21; "Tenant ID"; Text[128])
        {
            Caption = 'Tenant ID';
        }
        field(1017361; "Central Maintenance"; Boolean)
        {
            Caption = 'Central Maintenance';
        }
        field(1028275; "Deleted by HQ"; Boolean)
        {
            Caption = 'Deleted by HQ';
        }
        field(1028276; "Replication Date"; DateTime)
        {
            Caption = 'Replication Date';
            Editable = false;
        }
        field(1028277; "Repl. Post Run Finished"; Boolean)
        {
            Caption = 'Repl. Post Run Finished';
        }
        field(1028278; "Replication Filter"; Code[2])
        {
            Caption = 'Replication Filter';
            // TableRelation = "Replication Filter";
        }
        field(1059110; "Prevent Synchronization"; Boolean)
        {
            Caption = 'Prevent Synchronization';
        }
        field(1059111; "Prevent Replication"; Boolean)
        {
            Caption = 'Prevent Replication';
        }
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

