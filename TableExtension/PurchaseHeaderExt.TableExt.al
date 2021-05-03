tableextension 1073871 "Purchase Header Ext" extends "Purchase Header"
{
    // +----------------------------------------------+
    // | Copyright (c) incadea China                  |
    // +----------------------------------------------+
    // TFS          ID             WHO    DATE        DESCRIPTION
    // 112051       MARS_TWN-6456  GG     2018-03-02  Add new key "Document Date"
    // 122010       RGS_TWN-874    GG     2020-08-28  Add new field and key "OCT Order No." (RGS_CHN-1540  120360)
    fields
    {
        field(50000; "OCT Order No."; Code[30])
        {
            Caption = 'OCT Order No.';
            Description = '122010';
            Editable = false;
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(Key11; "OCT Order No.")
        {
            Enabled = true;
        }
    }
}
