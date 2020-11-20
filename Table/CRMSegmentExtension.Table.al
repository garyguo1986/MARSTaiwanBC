table 1044886 "CRM Segment Extension"
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
    // RGS_AGL-3620  121528        GG     2020-04-22  New object

    Caption = 'CRM Segment Extension';

    fields
    {
        field(1; "Segment No."; Code[20])
        {
            Caption = 'Segment No.';
        }
        field(21; "Calculated Flag"; Boolean)
        {
            Caption = 'Calculated Flag';
        }
    }

    keys
    {
        key(Key1; "Segment No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

