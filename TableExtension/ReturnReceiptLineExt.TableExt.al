tableextension 1044874 "Return Receipt Line Ext" extends "Return Receipt Line"
{
    // #1..133
    // 
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
    }
}

