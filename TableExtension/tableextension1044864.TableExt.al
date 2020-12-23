tableextension 1044864 tableextension1044864 extends "Fastfit Setup - Vehicle"
{
    // +--------------------------------------------------------------+
    // | ?2005 ff. Begusch Software Systeme                          |
    // #3..24
    // 
    // +----------------------------------------------+
    // | Copyright (c) incadea China                  |
    // +----------------------------------------------+
    // TFS          ID             WHO    DATE        DESCRIPTION
    // 117077       MARS_TWN-6963  GG     2018-10-29  Add new field "Check Vehicle Licence Type"
    fields
    {
        field(1044861; "Check Vehicle Licence Type"; Option)
        {
            Caption = 'Check Vehicle Licence Type';
            Description = '117077';
            OptionCaption = 'Search Name Vehicle,Licence-Plate No.,Search Name and License-Plate No.';
            OptionMembers = "Search Name Vehicle","Licence-Plate No.","Search Name and License-Plate No.";
        }
    }
}

