table 50002 "Check Ledger Entry buffer"
{
    // +--------------------------------------------------------------+
    // | @ 2017 incadea Taiwan Limited                                |
    // +--------------------------------------------------------------+
    // | PURPOSE: MARS_TWN                                            |
    // |                                                              |
    // | REMARK :                                                     |
    // +--------------------------------------------------------------+
    // 
    // VERSION       ID              WHO    DATE        DESCRIPTION
    // TWN.01.09     RGS_TWN-INC01   NN     2017-04-24  INITIAL RELEASE

    Caption = 'Check Ledger Entry buffer';

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(2; "Postinge Date"; Date)
        {
            FieldClass = FlowField;
            CalcFormula = Lookup ("Detailed Check Entry"."Posting Date" WHERE("Check Entry No" = FIELD("Entry No. Filter"),
                                                                              "Check No." = FIELD("Check No. Filter")));
            Caption = 'Postinge Date';
        }
        field(3; "Currency Date"; Date)
        {
            FieldClass = FlowField;
            CalcFormula = Lookup ("Detailed Check Entry"."Currency Date" WHERE("Check Entry No" = FIELD("Entry No. Filter"),
                                                                               "Check No." = FIELD("Check No. Filter")));
            Caption = 'Currency Date';
        }
        field(4; "Currency Code"; Code[20])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup ("Detailed Check Entry"."Currency Code" WHERE("Check Entry No" = FIELD("Entry No. Filter"),
                                                                               "Check No." = FIELD("Check No. Filter")));
            Caption = 'Currency Code';
        }
        field(5; "Currency Rate"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Lookup ("Detailed Check Entry"."Currency Factor" WHERE("Check Entry No" = FIELD("Entry No. Filter"),
                                                                                    "Check No." = FIELD("Check No. Filter"),
                                                                                    "Posting Date" = FIELD(UPPERLIMIT("Posting Date Filter"))));
            Caption = 'Currency Rate';
        }
        field(6; "Entry Status"; Option)
        {
            CalcFormula = Lookup ("Detailed Check Entry"."Entry Status" WHERE("Check Entry No" = FIELD("Entry No. Filter"),
                                                                              "Check No." = FIELD("Check No. Filter"),
                                                                              "Posting Date" = FIELD(UPPERLIMIT("Posting Date Filter"))));
            Caption = 'Entry Status';
            FieldClass = FlowField;
            OptionCaption = ',Printed,Voided,Posted,Financially Voided,Test Print,Note';
            OptionMembers = ,Printed,Voided,Posted,"Financially Voided","Test Print",Note;
        }
        field(7; "Sub Status"; Option)
        {
            CalcFormula = Lookup ("Detailed Check Entry"."Status Sub Type" WHERE("Check Entry No" = FIELD("Entry No. Filter"),
                                                                              "Check No." = FIELD("Check No. Filter"),
                                                                              "Posting Date" = FIELD(UPPERLIMIT("Posting Date Filter"))));
            Caption = 'Sub Status';
            FieldClass = FlowField;
            OptionCaption = ' ,Reversed,Return,Dishonored,Cash,Cancel cash,Discount,Cancel discount,Printed,Cancel Printed';
            OptionMembers = " ",Reversed,Return,Dishonored,Cash,"Cancel Cash",Discount,"Cancel Discount",Printed,"Cancel Printed";
        }
        field(8; "USER ID"; Code[20])
        {
            CalcFormula = Max ("Detailed Check Entry"."User ID" WHERE("Check Entry No" = FIELD("Entry No. Filter"),
                                                                              "Check No." = FIELD("Check No. Filter"),
                                                                              "Posting Date" = FIELD(UPPERLIMIT("Posting Date Filter"))));
            Caption = 'USER ID';
            FieldClass = FlowField;
        }
        field(9; "Point Entry No."; Integer)
        {
            CalcFormula = Max ("Detailed Check Entry"."Entry No." WHERE("Check Entry No" = FIELD("Entry No. Filter"),
                                                                        "Check No." = FIELD("Check No. Filter"),
                                                                        "Document No." = FIELD("Document No. Filter"),
                                                                        "Posting Date" = FIELD(UPPERLIMIT(FILTER("Posting Date Filter")))));
            Caption = 'Point Entry No.';
            FieldClass = FlowField;
        }
        field(10; "Point Postinge Date"; Date)
        {
            FieldClass = FlowField;
            CalcFormula = Lookup ("Detailed Check Entry"."Posting Date" WHERE("Entry No." = FIELD("Point Entry No.")));
            Caption = 'Point Postinge Date';
        }
        field(11; "Point Currency Rate"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Lookup ("Detailed Check Entry"."Currency Factor" WHERE("Entry No." = FIELD("Point Entry No.")));
            Caption = 'Point Currency Rate';
        }
        field(12; "Point Entry Status"; Option)
        {
            FieldClass = FlowField;
            CalcFormula = Lookup ("Detailed Check Entry"."Entry Status" WHERE("Entry No." = FIELD("Point Entry No.")));
            Caption = 'Point Entry Status';

            OptionCaption = ',Printed,Voided,Posted,Financially Voided,Test Print,Note';
            OptionMembers = ,Printed,Voided,Posted,"Financially Voided","Test Print",Note;
        }
        field(13; "Point Sub Status"; Option)
        {
            FieldClass = FlowField;
            CalcFormula = Lookup ("Detailed Check Entry"."Status Sub Type" WHERE("Entry No." = FIELD("Point Entry No.")));
            Caption = 'Point Sub Status';

            OptionCaption = 'Note,Reversed,Dishonored,Withdraw,Cash,Cancel cash,Discount,Cancel discount,Printed,Cancel Printed';
            OptionMembers = Note,Reversed,Dishonored,Withdraw,Cash,"Cancel Cash",Discount,"Cancel Discount",Printed,"Cancel Printed";
        }
        field(14; "Point USER ID"; Code[20])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup ("Detailed Check Entry"."User ID" WHERE("Entry No." = FIELD("Point Entry No.")));
            Caption = 'Point USER ID';

        }
        field(30; "Check No. Filter"; Code[20])
        {
            Caption = 'Check No. Filter';
            FieldClass = FlowFilter;
        }
        field(31; "Posting Date Filter"; Date)
        {
            Caption = 'Posting Date Filter';
            FieldClass = FlowFilter;
        }
        field(32; "Entry No. Filter"; Integer)
        {
            Caption = 'Entry No. Filter';
            FieldClass = FlowFilter;
        }
        field(33; "Document No. Filter"; Code[20])
        {
            Caption = 'Document No. Filter';
            FieldClass = FlowFilter;
        }
        field(50; "Journal Template Name"; Code[20])
        {
            Caption = 'Journal Template Name';
        }
        field(51; "Journal Batch Name"; Code[20])
        {
            Caption = 'Journal Batch Name';
        }
        field(52; "Journal Document"; Code[20])
        {
            Caption = 'Journal Document';
        }
        field(53; "Account Type"; Option)
        {
            Caption = 'Account Type';
            OptionCaption = 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner';
            OptionMembers = "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner";
        }
        field(54; "Account No."; Code[20])
        {
            Caption = 'Account No.';
            TableRelation = IF ("Account Type" = CONST("G/L Account")) "G/L Account"
            ELSE
            IF ("Account Type" = CONST(Customer)) Customer
            ELSE
            IF ("Account Type" = CONST(Vendor)) Vendor
            ELSE
            IF ("Account Type" = CONST("Bank Account")) "Bank Account"
            ELSE
            IF ("Account Type" = CONST("Fixed Asset")) "Fixed Asset"
            ELSE
            IF ("Account Type" = CONST("IC Partner")) "IC Partner";
        }
        field(55; "Drawee Bank No."; Code[20])
        {
            Caption = 'Drawee Bank No.';
            Description = 'TWNPNR1.00';
            TableRelation = "Bank Code";

            trigger OnValidate()
            var
                xBankCode: Record "Bank Code";
            begin
                IF xRec."Drawee Bank No." <> "Drawee Bank No." THEN BEGIN
                    xBankCode.GET("Drawee Bank No.");
                    "Drawee Bank Name" := xBankCode.Name;
                END;
            end;
        }
        field(56; "Drawee Bank Name"; Text[30])
        {
            Caption = 'Drawee Bank Name';
            Description = 'TWNPNR1.00';
        }
        field(57; Drawee; Text[50])
        {
            Caption = 'Deawee';
            Description = 'TWNPNR1.00';
        }
        field(58; "Invoice Domicile"; Text[80])
        {
            Caption = 'Invoice Domicile';
            Description = 'TWNPNR1.00';
        }
        field(59; "Drawee Bank Domicile"; Text[80])
        {
            Caption = 'Drawee Bank Domicile';
            Description = 'TWNPNR1.00';
        }
    }

    keys
    {
        key(Key1; "Journal Template Name", "Journal Batch Name", "Journal Document", "Entry No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

