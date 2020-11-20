table 50004 "Check Ledger Entry Additional"
{
    // Documentation()
    // +--------------------------------------------------------------+
    // | @ 2017 incadea Taiwan Limited                                |
    // +--------------------------------------------------------------+
    // | PURPOSE: MARS_TWN                                            |
    // |                                                              |
    // | REMARK :                                                     |
    // +--------------------------------------------------------------+
    // 
    // VERSION       ID            WHO    DATE        DESCRIPTION
    // TWN.01.09     RGS_TWN-INC01 NN     2017-04-24  INITIAL RELEASE

    Caption = 'Check Additional Information';

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Check Entry No.';
        }
        field(2; "Drawee Bank No."; Code[20])
        {
            Caption = 'Drawee Bank No.';
        }
        field(3; "Drawee Bank Name"; Text[30])
        {
            Caption = 'Drawee Bank Name';
        }
        field(4; Drawee; Text[50])
        {
            Caption = 'Drawee';
        }
        field(5; "Invoice Domicile"; Text[80])
        {
            Caption = 'Invoice Domicile';
        }
        field(6; "Drawee Bank Domicile"; Text[80])
        {
            Caption = 'Drawee Bank Domicile';
        }
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

