table 50000 "Bank Check Acc. Setup"
{
    // +--------------------------------------------------------------+
    // | @ 2017 incadea Taiwan Limited                                |
    // +--------------------------------------------------------------+
    // | PURPOSE: MARS_TWN                                            |
    // |                                                              |
    // | REMARK :                                                     |
    // +--------------------------------------------------------------+
    // 
    // VERSION       ID            WHO    DATE        DESCRIPTION
    // TWN.01.09     RGS_TWN-INC01 NN     2017-04-25  INITIAL RELEASE

    Caption = 'Bank Check Acc. Setup';

    fields
    {
        field(1; "Bank Account No."; Code[20])
        {
            Caption = 'Bank Account No.';
            TableRelation = "Bank Account";
        }
        field(2; "Note Payable Account"; Code[20])
        {
            Caption = 'Note Payable Account';
            TableRelation = "G/L Account";
        }
        field(3; "Note Receivable Account"; Code[20])
        {
            Caption = 'Note Receivable Account';
            TableRelation = "G/L Account";
        }
    }

    keys
    {
        key(Key1; "Bank Account No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

