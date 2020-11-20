table 50006 "Customer Agreement Detail"
{
    // 
    // +--------------------------------------------------------------+
    // | @ 2017 incadea Taiwan Limited                                |
    // +--------------------------------------------------------------+
    // | PURPOSE: MARS_TWN                                            |
    // |                                                              |
    // | REMARK :                                                     |
    // +--------------------------------------------------------------+
    // 
    // VERSION     ID          WHO    DATE        DESCRIPTION
    // TWN.01.03   RGS_TWN-327 AH     2017-04-20  INITIAL RELEASE
    // RGS_TWN-888 122187	   QX	  2020-10-26  Table Rmoved
    //                                            Remove field Replication Filter because table Replication Filter was removed

    //++TWN1.00.122187.QX
    ObsoleteState = Removed;
    ObsoleteReason = '2020/10/20 - Biz response : Rmove';
    Description = '122187';
    //--TWN1.00.122187.QX

    Caption = 'Customer Agreement Detail';
    DataPerCompany = false;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(2; Content; Text[200])
        {
            Caption = 'Content';
        }
        field(1017361; "Central Maintenance"; Boolean)
        {
            Caption = 'Central Maintenance';
        }
        field(1028275; "Deleted By HQ"; Boolean)
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
        //++TWN1.00.122187.QX
        field(1028278; "Replication Filter"; Code[2])
        {
            Caption = 'Replication Filter';
            Description = '122187';
            // TableRelation = "Replication Filter";
            ObsoleteState = Removed;
            ObsoleteReason = 'Related table ''Replication Filter'' is removed.';
        }
        //--TWN1.00.122187.QX
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

