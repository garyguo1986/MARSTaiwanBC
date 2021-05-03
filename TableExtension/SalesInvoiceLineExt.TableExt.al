tableextension 1044880 "Sales Invoice Line Ext" extends "Sales Invoice Line"
{
    // +--------------------------------------------------------------+
    // | ?2005 ff. Begusch Software Systeme                          |
    // #3..68
    //                                       1017460 Depot No.
    // #70..73
    // 040216   IT_3612 MH     2007-07-12  added field 'Depot No.' which was deleted by mistake
    // #75..143
    // 
    // +--------------------------------------------------------------+
    // | @ 2017 incadea Taiwan Limited                                |
    // +--------------------------------------------------------------+
    // | PURPOSE: MARS_TWN                                            |
    // |                                                              |
    // | REMARK :                                                     |
    // +--------------------------------------------------------------+
    // 
    // VERSION      ID          WHO    DATE        DESCRIPTION
    // TWN.01.01    RGS_TWN-425 NN     2017-05-31  Added field: "Main Group Code"
    // TWN.01.01    RGS_TWN-459 AH     2017-06-02  Add New Fields 50001..50002
    fields
    {
        field(50000; "Main Group Code"; Code[10])
        {
            Caption = 'Main Group Code';
            Description = 'TWN.01.01';
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

