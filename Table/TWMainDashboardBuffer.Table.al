table 1044875 "TW Main Dashboard Buffer"
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


    fields
    {
        field(1; "Service Center"; Code[10])
        {
        }
        field(2; "Posting Date"; Date)
        {
        }
        field(3; Description; Text[250])
        {
        }
        field(4; "Post Code"; Code[20])
        {
        }
        field(101; "Tyre Amount"; Decimal)
        {
            DecimalPlaces = 0 : 2;
        }
        field(102; "NTP Amount"; Decimal)
        {
            DecimalPlaces = 0 : 2;
        }
        field(103; "Overall Count"; Decimal)
        {
        }
        field(104; "Tyre Total Quantity"; Decimal)
        {
            DecimalPlaces = 0 : 2;
        }
        field(105; "MI or BFG Total Quantity"; Decimal)
        {
            DecimalPlaces = 0 : 2;
        }
        field(106; "Lub Total Quantity"; Decimal)
        {
            DecimalPlaces = 0 : 2;
        }
        field(107; "Lub Deno Total Quantity"; Decimal)
        {
            DecimalPlaces = 0 : 2;
        }
        field(108; "POS Count"; Decimal)
        {
        }
    }

    keys
    {
        key(Key1; "Service Center", "Posting Date")
        {
            Clustered = true;
            SumIndexFields = "Tyre Amount", "NTP Amount", "Overall Count";
        }
    }

    fieldgroups
    {
    }
}

