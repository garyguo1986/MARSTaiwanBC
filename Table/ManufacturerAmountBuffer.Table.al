table 1044865 "Manufacturer Amount Buffer"
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
    //                                  2017-06-09  Added field: "Manufacturer Sorting"(11)

    Caption = 'Manufacturer Amount Buffer';

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
        field(11; "Manufacturer Sorting"; Integer)
        {
            Description = 'TWN.01.03';
        }
        field(12; YTDSOATotal; Decimal)
        {
            Description = 'TWN.01.03';
        }
        field(13; YTDMinus1SOATotal; Decimal)
        {
            Description = 'TWN.01.03';
        }
        field(14; MTDSOATotal; Decimal)
        {
            Description = 'TWN.01.03';
        }
    }

    keys
    {
        key(Key1; Manufacturer, "Item Code")
        {
            Clustered = true;
        }
        key(Key2; Amount)
        {
        }
        key(Key3; "Manufacturer Sorting")
        {
        }
    }

    fieldgroups
    {
    }
}

