tableextension 1044868 tableextension1044868 extends "Check Ledger Entry"
{
    // +--------------------------------------------------------------+
    // | @ 2017 incadea Taiwan Limited                                |
    // +--------------------------------------------------------------+
    // | PURPOSE: MARS_TWN                                            |
    // |                                                              |
    // +--------------------------------------------------------------+
    // 
    // VERSION       ID              WHO    DATE        DESCRIPTION
    // TWN.01.09     RGS_TWN-INC01   NN     2017-04-25  Add Field 50000..50006
    //                                                  Entry Status add new option Note
    //                                                  Original Entry Status add new option Note
    fields
    {
        field(50000; "Currency Code"; Code[20])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup("Detailed Check Entry"."Currency Code" WHERE("Check Entry No" = FIELD("Entry No.")));
            Caption = 'Currency Code';
            Description = 'TWN.01.09';
        }
        field(50001; Drawee; Text[50])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup("Check Ledger Entry Additional".Drawee WHERE("Entry No." = FIELD("Entry No.")));
            Caption = 'Drawee';
            Description = 'TWN.01.09';
        }
        field(50002; "Drawee Bank No."; Code[20])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup("Check Ledger Entry Additional"."Drawee Bank No." WHERE("Entry No." = FIELD("Entry No.")));
            Caption = 'Drawee Bank No.';
            Description = 'TWN.01.09';

        }
        field(50003; "Drawee Bank Name"; Text[30])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup("Check Ledger Entry Additional"."Drawee Bank Name" WHERE("Entry No." = FIELD("Entry No.")));
            Caption = 'Drawee Bank Name';
            Description = 'TWN.01.09';
        }
        field(50004; "Print Date"; Date)
        {
            FieldClass = FlowField;
            CalcFormula = Lookup("Detailed Check Entry"."Posting Date" WHERE("Check Entry No" = FIELD("Entry No.")));
            Caption = 'Print Date';
            Description = 'TWN.01.09';
        }
        field(50005; "Doc Date"; Date)
        {
            Caption = 'Doc Date';
            Description = 'TWN.01.09';
        }
        field(50006; "Note Type"; Option)
        {
            Caption = 'Note Type';
            Description = 'TWN.01.09';
            OptionCaption = 'NP,NR';
            OptionMembers = NP,NR;
        }
    }
}

