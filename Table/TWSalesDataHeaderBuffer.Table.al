table 1044877 "TW Sales Data Header Buffer"
{
    // +--------------------------------------------------------------+
    // | @ 2019 incadea Taiwan Limited                                |
    // +--------------------------------------------------------------+
    // | PURPOSE: MARS_TWN                                            |
    // |                                                              |
    // | REMARK :                                                     |
    // +--------------------------------------------------------------+
    // 
    // VERSION       ID            WHO    DATE        DESCRIPTION
    // RGS_TWN-833   119130        GY     2019-04-08  New Object
    // RGS_TWN-833   119130        WP     2019-06-26  Add field Date and Add key
    // RGS_TWN-845   120529        GG     2019-09-11  Added field "Tire MI Sellout"


    fields
    {
        field(1; Year; Integer)
        {
        }
        field(2; Month; Integer)
        {
        }
        field(3; "Service Center"; Code[10])
        {
        }
        field(4; "Zone Code"; Code[20])
        {
        }
        field(5; "Post Code"; Code[20])
        {
        }
        field(6; "Shop Name"; Text[50])
        {
        }
        field(101; "Posted Invoice Count"; Decimal)
        {
        }
        field(102; "Posted Invoice with updated VC"; Decimal)
        {
            DecimalPlaces = 0 : 2;
        }
        field(103; "Posted Inv. with add. Sales"; Decimal)
        {
            DecimalPlaces = 0 : 2;
        }
        field(104; "Sales Amount"; Decimal)
        {
            DecimalPlaces = 0 : 2;
        }
        field(105; "Sales Amount Tyre"; Decimal)
        {
            DecimalPlaces = 0 : 2;
        }
        field(106; "Sales Amount Non Tyre"; Decimal)
        {
            DecimalPlaces = 0 : 2;
        }
        field(107; "Sales Amount Service"; Decimal)
        {
            DecimalPlaces = 0 : 2;
        }
        field(108; "Sales invoiced Qty"; Decimal)
        {
            DecimalPlaces = 0 : 2;
        }
        field(109; "GM %"; Decimal)
        {
            DecimalPlaces = 0 : 3;
        }
        field(110; "SOB Tyre related services"; Decimal)
        {
            DecimalPlaces = 0 : 2;
        }
        field(111; "SOB NTP and Services"; Decimal)
        {
            DecimalPlaces = 0 : 2;
        }
        field(112; "Tyre Sales A1"; Decimal)
        {
            DecimalPlaces = 0 : 2;
        }
        field(113; "Tyre Sales MI BFG"; Decimal)
        {
            DecimalPlaces = 0 : 2;
        }
        field(114; "Tire MI Sellout"; Decimal)
        {
            Caption = 'Tire MI Sellout';
        }
        field(120; Date; Date)
        {
        }
    }

    keys
    {
        key(Key1; Year, Month, "Service Center")
        {
            Clustered = true;
            SumIndexFields = "Posted Invoice Count", "Posted Invoice with updated VC", "Posted Inv. with add. Sales", "Sales Amount", "Sales Amount Tyre", "Sales Amount Non Tyre", "Sales Amount Service", "Sales invoiced Qty", "GM %", "SOB Tyre related services", "SOB NTP and Services", "Tyre Sales A1", "Tyre Sales MI BFG";
        }
        key(Key2; Date)
        {
        }
    }

    fieldgroups
    {
    }
}

