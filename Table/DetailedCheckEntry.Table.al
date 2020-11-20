table 50003 "Detailed Check Entry"
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

    Caption = 'Detailed Check Entry';
    LookupPageID = "Detailed Check Entries";

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(2; "Check Entry No"; Integer)
        {
            Caption = 'Check Entry No';
        }
        field(3; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }
        field(4; "Document Type"; Option)
        {
            Caption = 'Document Type';
            OptionCaption = ' ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund';
            OptionMembers = " ",Payment,Invoice,"Credit Memo","Finance Charge Memo",Reminder,Refund;
        }
        field(5; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(6; "Check Date"; Date)
        {
            Caption = 'Expected Cash Date';
        }
        field(7; "Check No."; Code[20])
        {
            Caption = 'Check No.';
        }
        field(8; "Check Type"; Option)
        {
            Caption = 'Check Type';
            OptionCaption = 'Total Check,Partial Check';
            OptionMembers = "Total Check","Partial Check";
        }
        field(9; "Bank Payment Type"; Option)
        {
            Caption = 'Bank Payment Type';
            OptionCaption = ' ,Computer Check,Manual Check';
            OptionMembers = " ","Computer Check","Manual Check";
        }
        field(10; "Entry Status"; Option)
        {
            Caption = 'Entry Status';
            OptionCaption = ',Printed,Voided,Posted,Financially Voided,Test Print,Note';
            OptionMembers = ,Printed,Voided,Posted,"Financially Voided","Test Print",Note;
        }
        field(11; "Status Sub Type"; Option)
        {
            Caption = 'Status Sub Type';
            OptionCaption = 'Note,Reversed,Dishonored,Withdraw,Cash,Cancel cash,,,Printed,Cancel Printed';
            OptionMembers = Note,Reversed,Dishonored,Withdraw,Cash,"Cancel Cash",Discount,"Cancel Discount",Printed,"Cancel Printed";
        }
        field(12; "User ID"; Code[20])
        {
            Caption = 'User ID';
            TableRelation = User;
            //This property is currently not supported
            //TestTableRelation = false;

            trigger OnLookup()
            var
                LoginMgt: Codeunit "User Management";
            begin
            end;
        }
        field(13; "Note Type"; Option)
        {
            Caption = 'Note Type';
            OptionCaption = 'NP,NR';
            OptionMembers = NP,NR;
        }
        field(14; "Currency Code"; Code[20])
        {
            Caption = 'Currency Code';
        }
        field(15; "Currency Factor"; Decimal)
        {
            Caption = 'Currency Factor';
        }
        field(16; "Currency Date"; Date)
        {
            Caption = 'Currency Date';
        }
        field(17; "Transaction No."; Integer)
        {
            Caption = 'Transaction No.';
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
        key(Key2; "Check Entry No", "Posting Date")
        {
        }
        key(Key3; "Posting Date", "Document No.")
        {
        }
        key(Key4; "Posting Date", "Check No.")
        {
        }
        key(Key5; "Check Entry No", "Document No.", "Check No.", "Posting Date")
        {
        }
    }

    fieldgroups
    {
    }
}

