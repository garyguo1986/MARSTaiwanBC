table 1044878 "TW Sales Data Line Buffer"
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
    // RGS_TWN-833   119130        WP     2019-06-26  Add field Date


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
        field(6; "Manufacturer Code"; Code[10])
        {
        }
        field(7; "Main Group Code"; Code[10])
        {
        }
        field(8; "Position Group Code"; Code[10])
        {
        }
        field(9; "Shop Name"; Text[50])
        {
        }
        field(104; "Sales Amount"; Decimal)
        {
            DecimalPlaces = 0 : 2;
        }
        field(108; "Sales Invoiced Qty"; Decimal)
        {
            DecimalPlaces = 0 : 2;
        }
        field(114; "Add. Sales Line Clicked"; Boolean)
        {
        }
        field(115; "Posted Invoice No."; Code[20])
        {
        }
        field(120; Date; Date)
        {
        }
    }

    keys
    {
        key(Key1; Year, Month, "Service Center", "Manufacturer Code", "Main Group Code", "Position Group Code", "Posted Invoice No.")
        {
            Clustered = true;
        }
        key(Key2; Date)
        {
        }
    }

    fieldgroups
    {
    }
}

