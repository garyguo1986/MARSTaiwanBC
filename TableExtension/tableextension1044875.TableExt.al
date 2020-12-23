tableextension 1044875 tableextension1044875 extends "Sales Line"
{
    // +--------------------------------------------------------------+
    // | . 2005 ff. Begusch Software Systeme                          |
    // #3..9
    // 040000   TDP001  SK     2005-02-09  check depot charging entries
    // #11..83
    // 040103   IT_2110 SK     2006-04-07  CheckDepotChargingEntries of shopping basket lines
    // #85..296
    // 050110   IT_5686 MH     2010-05-17  handling for new customer field "Limited Res. Selection" / "Item Blacklist Code"嚙窮dded
    // #298..314
    // 060100   IT_6242 MH     2011-02-14  - removed the following carcass related fields:
    //                                       1017730 Carcass Quality
    //                                       1017731 Carcass Quality Type
    //                                       1017732 Used Tire Disposal
    //                                       1017733 Desired Tread Design
    //                                       1017734 Customer Carcass
    //                                       1017735 Retread Item No.
    //                                       1017736 Skip for Orders
    //                                     - removed function "SearchMatchCodeRetreatItem"
    //                                     - added new fields
    //                                       1017730 Carcass Type
    //                                       1017731 Carcass Serial No.
    //                                       1017732 Carcass Sequential No.
    //                                       1017733 Carcass Quality
    //                                       1017734 Carc. Acceptable by Retreader
    //                                       1017736 Carcass Doc. Status
    //                                       1017737 Linked Sales Order No.
    //                                       1017738 Linked Sales Order Line No.
    //                                       1017400 Item Vendor No.
    //                                       1017741 Linked S. Ret. Order No.
    //                                       1017742 Linked S. Ret. Order Line No.
    //                                     - field "Document Type" extended by Carcass options
    //                                     - autom. reservation cancellation on "Undospecialorder"
    //                                     - new Function SetUndoSpecOrderAllowed
    //                                     - new key added:
    //                                       "Sell-to Customer No.,No.,Document Type,Carcass Doc. Status,Carcass Quality Code"
    // #318..362
    // 071100   IT_7859  MW    2013-07-15  fixed error for carcass items with additional items
    // #363..448
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

