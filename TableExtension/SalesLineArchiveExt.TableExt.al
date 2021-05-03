tableextension 1044871 "Sales Line Archive Ext" extends "Sales Line Archive"
{
    // +--------------------------------------------------------------+
    // | ?2005 ff. Begusch Software Systeme                          |
    // #3..43
    // 060100   IT_6242 MH     2011-02-23  carcass fields added
    // #44..68
    // 
    // +--------------------------------------------------------------+
    // | @ 2017 incadea Taiwan Limited                                |
    // +--------------------------------------------------------------+
    // | PURPOSE: MARS_TWN                                            |
    // |                                                              |
    // +--------------------------------------------------------------+
    // 
    // VERSION       ID          WHO    DATE        DESCRIPTION
    // TWN.01.01     RGS_TWN-459 AH     2017-06-02  Add New Fields 50001..50002
    fields
    {
        field(50001; "Item Type"; Option)
        {
            Caption = 'Item Type';
            Description = 'TWN.01.01';
            OptionCaption = ' ,Tire,Lightmetal Rim,Steel Rim PC,Steel Rim Truck,Tire Accessory,Chain,General,Spare Part';
            OptionMembers = " ",Tire,"Lightmetal Rim","Steel Rim PC","Steel Rim Truck","Tire Accessory",Chain,General,"Spare Part";
        }
        field(50002; Retail; Boolean)
        {
            Caption = 'Retail';
            Description = 'TWN.01.01';
        }
    }
}

