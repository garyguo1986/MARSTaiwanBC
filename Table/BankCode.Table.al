table 50001 "Bank Code"
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
    // TWN.01.09     RGS_TWN-INC01 NN     2017-04-24  INITIAL RELEASE

    Caption = 'Bank Code';
    DrillDownPageID = "Bank Code";
    LookupPageID = "Bank Code";

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';
            NotBlank = true;

            trigger OnValidate()
            var
                PostCode: Record "Post Code";
            begin
            end;
        }
        field(2; Name; Text[30])
        {
            Caption = 'Name';

            trigger OnValidate()
            var
                PostCode: Record "Post Code";
            begin
            end;
        }
        field(3; "Name 2"; Text[80])
        {
            Caption = 'Name 2';
        }
    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        Text000: Label '%1 %2 already exists.';
}

