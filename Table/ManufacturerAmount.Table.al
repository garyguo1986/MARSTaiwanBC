table 1044864 "Manufacturer Amount"
{
    // +--------------------------------------------------------------+
    // | @ 2017 incadea Taiwan Limited                                |
    // +--------------------------------------------------------------+
    // | PURPOSE: MARS_TWN                                            |
    // |                                                              |
    // +--------------------------------------------------------------+
    // 
    // VERSION       ID          WHO    DATE        DESCRIPTION
    // TWN.01.03     RGS_TWN-632 NN     2017-06-06  Upgrade from r3

    Caption = 'Manufacturer Amount';

    fields
    {
        field(1; Manufacturer; Code[20])
        {
            Caption = 'Manufacturer';
        }
        field(2; Amount; Decimal)
        {
            Caption = 'Amount';
        }
        field(3; "Amount(LCY)"; Decimal)
        {
            Caption = 'Amount(LCY)';
        }
        field(4; "Item Code"; Code[30])
        {
            Caption = 'item code';
        }
        field(5; YTDMinus1Total; Decimal)
        {
            Caption = 'YTDMinus1Total';
        }
        field(6; MTDTotal; Decimal)
        {
            Caption = 'MTDTotal';
        }
        field(7; MTDMinus1Total; Decimal)
        {
            Caption = 'MTDMinus1Total';
        }
        field(8; DateTotal; Decimal)
        {
            Caption = 'DateTotal';
        }
        field(9; YTDAvgGMTotal; Decimal)
        {
            Caption = 'YTDAvgGMTotal';
        }
        field(10; YTDMinus1AvgGMTotal; Decimal)
        {
            Caption = 'YTDMinus1AvgGMTotal';
        }
        field(11; Width; Decimal)
        {
            Caption = 'Width';
        }
        field(12; "Aspect Ratio"; Decimal)
        {
            Caption = 'Aspect Ratio';
        }
        field(13; "Construction Type"; Code[15])
        {
            Caption = 'Construction Type';
        }
        field(14; Diameter; Decimal)
        {
            Caption = 'Diameter';
        }
    }

    keys
    {
        key(Key1; Amount, "Amount(LCY)", Manufacturer, "Item Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

