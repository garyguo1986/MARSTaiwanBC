tableextension 1044872 "Manufacturer Ext" extends Manufacturer
{
    // +--------------------------------------------------------------+
    // | ?2005 ff. Begusch Software Systeme                          |
    // #3..26
    // 
    // +--------------------------------------------------------------+
    // | @ 2017 incadea Taiwan Limited                                |
    // +--------------------------------------------------------------+
    // | PURPOSE: MARS_TWN                                            |
    // |                                                              |
    // +--------------------------------------------------------------+
    // 
    // VERSION       ID          WHO    DATE        DESCRIPTION
    // TWN.01.03     RGS_TWN-632 NN     2017-06-06  Added field: "Manufacturer Sorting" (ID:1044516)
    //                                              Added keys: "Manufacturer Sorting"
    fields
    {
        field(50000; "Limit Creation"; Boolean)
        {
            Caption = 'Limit Creation';
            Description = '122137';
        }
        field(1044516; "Manufacturer Sorting"; Integer)
        {
            Caption = 'Manufacturer Sorting';
            Description = 'TWN.01.03';
        }
    }
    keys
    {
        key(Key1044860; "Manufacturer Sorting")
        {
        }
    }
}

