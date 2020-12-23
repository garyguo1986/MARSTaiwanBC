tableextension 1044863 tableextension1044863 extends "Service Center"
{
    // +--------------------------------------------------------------+
    // | ?2011 ff. Begusch Software Systeme                          |
    // #3..11
    // 060100   IT_6242  MH     2011-02-14  new fields
    //                                       1017730 Default Carcass Location Code
    //                                       1017731 Def. Carc. Purch. Ret. Reason
    // #12..14
    // 070008   IT_20002 1CF    2013-11-13  Field "Advertising Text Sales" Length changed 10 -> 20
    // #16..45
    // 
    // +--------------------------------------------------------------+
    // | @ 2017 incadea Taiwan Limited                                |
    // +--------------------------------------------------------------+
    // | PURPOSE: MARS_TWN                                            |
    // |                                                              |
    // +--------------------------------------------------------------+
    // 
    // VERSION       ID          WHO    DATE        DESCRIPTION
    // TWN.01.03     RGS_TWN-350 NN     2017-06-04  Added field "Tire Rotation Service Type" (ID:50000)
    // TWN.01.01     RGS_TWN-459 AH     2017-06-02  Add New Fields 50001
    // RGS_TWN-395               AH     2017-06-21  Add New Fields 50002
    // 
    // +----------------------------------------------+
    // | Copyright (c) incadea China                  |
    // +----------------------------------------------+
    // TFS          ID             WHO    DATE        DESCRIPTION
    // 121393     MARS_TWN_7737  GG     2020-02-27  Add new field "MDM Code"
    // 121868       MARS_TWN-866   GG     2020-07-14  Add new field "Group ID"
    fields
    {
        field(50000; "Tire Rotation Service Type"; Code[20])
        {
            Caption = 'Tire Rotation Service Type';
            Description = 'TWN.01.03';
            TableRelation = "Service Alert Setup"."Service Type";
        }
        field(50001; "No. of Bays"; Integer)
        {
            Caption = 'No. of Bays';
            Description = 'TWN.01.01';
        }
        field(50002; "Tire Rotation Mileage"; Decimal)
        {
            Description = 'RGS_TWN-395';
        }
        field(1044862; "MDM code"; Code[20])
        {
            Caption = 'MDM code';
            Description = '121393';
        }
        field(1044863; "Group ID"; Code[10])
        {
            Caption = 'Group ID';
            Description = '121868';
        }
    }
}

