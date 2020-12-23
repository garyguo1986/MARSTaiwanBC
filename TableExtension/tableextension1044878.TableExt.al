tableextension 1044878 tableextension1044878 extends "Sales Shipment Line"
{
    // +--------------------------------------------------------------+
    // | ?2005 ff. Begusch Software Systeme                          |
    // #3..73
    //                                       1017460 Depot No.
    // #75..82
    // 040216   IT_3612 MH     2007-07-12  added field 'Depot No.' which was deleted by mistake
    // #84..175
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
    // +----------------------------------------------+
    // | Copyright (c) incadea China                  |
    // +----------------------------------------------+
    // TFS          ID             WHO    DATE        DESCRIPTION
    // 112159       MARS_TWN-6293  GG     2018-03-05  Add new field "Main Group Code"
    fields
    {
        field(50000; "Main Group Code"; Code[10])
        {
            Caption = 'Main Group Code';
            Description = '112159';
            Editable = false;
            TableRelation = "Main Group";
        }
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

