pageextension 1044885 "Fastfit Setup - Vehicle Ext" extends "Fastfit Setup - Vehicle"
{
    // +--------------------------------------------------------------+
    // | ?2005 ff. Begusch Software Systeme                          |
    // #3..31
    // 
    // +----------------------------------------------+
    // | Copyright (c) incadea China                  |
    // +----------------------------------------------+
    // TFS          ID             WHO    DATE        DESCRIPTION
    // 117077       MARS_TWN-6963  GG     2018-10-29  Add new field "Check Vehicle Licence Type"
    Caption = 'Vehicle Setup';
    layout
    {
        addafter("Allow Duplicate Licence Plate")
        {
            field("Check Vehicle Licence Type"; "Check Vehicle Licence Type")
            {
            }
        }
    }

}

