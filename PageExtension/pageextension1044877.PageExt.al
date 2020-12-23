pageextension 1044877 pageextension1044877 extends "Items by SC"
{
    // +--------------------------------------------------------------+
    // | ?2005 ff. Begusch Software Systeme                          |
    // #3..14
    // 070003 IT_20001 1CF 2013-07-15  Upgraded to NAV 7
    // 070005   IT_20002 1CF   2013-08-28  Fixed columns layout
    // 071000   IT_20071 FT    2013-11-12  assigned icons to BSS Actions
    // 
    // +--------------------------------------------------------------+
    // | @ 2017 incadea Taiwan Limited                                |
    // +--------------------------------------------------------------+
    // | PURPOSE: MARS_TWN                                            |
    // |                                                              |
    // +--------------------------------------------------------------+
    // 
    // VERSION      ID           WHO    DATE        DESCRIPTION
    // RGS_TWN-434               NN     2017-04-24  Show "Manufacturer Item No." & "No.2"
    // 
    // +----------------------------------------------+
    // | Copyright (c) incadea China                  |
    // +----------------------------------------------+
    // TFS          ID             WHO    DATE        DESCRIPTION
    // 114388       MARS_TWN-6080  GG     2018-05-17  Add new field "Main Group Code" "Sub Group Code" "Position Group Code"
    //                                                Fix bug that when no records matched filters then page will crash
    //                                                Fix bug that ondrilldown page is incorrect when there have more than one Service Center
    //                                                Fix bug that matrix value is incorrect when there have more than one Service Center
    Caption = 'Items by Service Center';
    PromotedActionCategories = 'New,Process,Report,Availability';

    layout
    {
        addafter("No.")
        {
            field("No. 2"; "No. 2")
            {
            }
            field("Manufacturer Item No."; "Manufacturer Item No.")
            {
            }
        }
        addafter("Description 2")
        {
            field("Main Group Code"; "Main Group Code")
            {
                Editable = false;
            }
            field("Sub Group Code"; "Sub Group Code")
            {
                Editable = false;
            }
            field("Position Group Code"; "Position Group Code")
            {
                Editable = false;
            }
        }
    }
}

