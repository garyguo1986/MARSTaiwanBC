tableextension 1044867 "Customer Group Ext" extends "Customer Group"
{
    // +--------------------------------------------------------------+
    // | ?2005 ff. Begusch Software Systeme                          |
    // #3..16
    // 
    // +--------------------------------------------------------------+
    // | @ 2017 incadea Taiwan Limited                                |
    // +--------------------------------------------------------------+
    // | PURPOSE: MARS_TWN                                            |
    // |                                                              |
    // +--------------------------------------------------------------+
    // 
    // VERSION       ID          WHO    DATE        DESCRIPTION
    // TWN.01.01     RGS_TWN-459 AH     2017-06-02  Add New Field 50000 and Key Retail
    fields
    {
        field(50000; Retail; Boolean)
        {
            Caption = 'Retail';
            Description = 'TWN.01.01';
        }
    }
    keys
    {
        key(Key1044860; Retail)
        {
        }
    }
}

