tableextension 1073876 "Purch. Inv. Header Ext" extends "Purch. Inv. Header"
{

    // +----------------------------------------------+
    // | Copyright (c) incadea China                  |
    // +----------------------------------------------+
    // TFS          ID             WHO    DATE        DESCRIPTION
    // 112051       MARS_TWN-6456  GG     2018-03-02  Add new key "Posting Date"
    // RGS_TWN-874   122010        GG     2020-08-28  Added field "OCT Order No." (RGS_CHN-1540  120360)    
    fields
    {
        field(50000; "OCT Order No."; Code[30])
        {
            Caption = 'OCT Order No.';
            Description = '122010';
            DataClassification = ToBeClassified;
        }
    }
}
