table 1044862 "Loyalty Points"
{
    // +--------------------------------------------------------------+
    // | @ 2017 incadea Taiwan Limited                                |
    // +--------------------------------------------------------------+
    // | PURPOSE: MARS_TWN                                            |
    // |                                                              |
    // +--------------------------------------------------------------+
    // 
    // VERSION       ID          WHO    DATE        DESCRIPTION
    // TWN.01.03     RGS_TWN-350 NN     2017-06-04  Upgrade from r3

    Caption = 'Loyalty Points';
    DrillDownPageID = "Notification Header Factbox";
    LookupPageID = "Notification Header Factbox";

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(2; "Bill to Contact No."; Code[20])
        {
            Caption = 'Bill to Contact No.';
        }
        field(3; "Bill to Contact"; Text[50])
        {
            Caption = 'Bill to Contact';
        }
        field(4; "Bill to Customer No."; Code[20])
        {
            Caption = 'Bill to Customer No.';
        }
        field(5; "Bill to Customer Name"; Text[50])
        {
            Caption = 'Bill to Customer Name';
        }
        field(6; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }
        field(7; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = ' ,G/L Account,Item,Resource,Fixed Asset,Charge (Item)';
            OptionMembers = " ","G/L Account",Item,Resource,"Fixed Asset","Charge (Item)";
        }
        field(8; "No."; Code[30])
        {
            Caption = 'No.';
        }
        field(9; Description; Text[50])
        {
            Caption = 'Description';
        }
        field(10; "Description 2"; Text[50])
        {
            Caption = 'Description 2';
        }
        field(11; "Bonus Allowed"; Boolean)
        {
            Caption = 'Bonus Allowed';
        }
        field(12; "Bonus %"; Decimal)
        {
            Caption = 'Bonus %';
        }
        field(13; "Bonus Code"; Code[10])
        {
            Caption = 'Bonus Code';
            TableRelation = Bonus;
        }
        field(14; "Bonusable Amount"; Decimal)
        {
            Caption = 'Bonusable Amount';
        }
        field(15; "Bonusable Amount (CB)"; Decimal)
        {
            Caption = 'Bonusable Amount (CB)';
        }
        field(16; "Bonus Amount (Expected)"; Decimal)
        {
            Caption = 'Bonus Amount (Expected)';
        }
        field(17; "Rem. Bonusable Amount"; Decimal)
        {
            Caption = 'Rem. Bonusable Amount';
        }
        field(18; "Document Type"; Option)
        {
            Caption = 'Document Type';
            OptionCaption = 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order,,,,,Basket';
            OptionMembers = Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order",,,,,Basket;
        }
        field(19; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(20; Quantity; Decimal)
        {
            Caption = 'Quantity';
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
        key(Key2; "Bill to Contact No.")
        {
            SumIndexFields = "Rem. Bonusable Amount";
        }
    }

    fieldgroups
    {
    }
}

