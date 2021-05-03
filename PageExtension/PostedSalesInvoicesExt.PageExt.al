pageextension 1044873 "Posted Sales Invoices Ext" extends "Posted Sales Invoices"
{
    // #1..55
    // 
    // +--------------------------------------------------------------+
    // | @ 2017 incadea Taiwan Limited                                |
    // +--------------------------------------------------------------+
    // | PURPOSE: MARS_TWN                                            |
    // |                                                              |
    // | REMARK :                                                     |
    // +--------------------------------------------------------------+
    // 
    // VERSION       ID          WHO    DATE        DESCRIPTION
    // TWN.01.07     RGS_TWN-708 AH     2017-09-11  removed security filter for responsibility center because it is not used anymore(HF21214)
    // TWN.01.09     RGW_TWN-524 AH     2017-09-21  Show "Campaign No." on page.
    // +----------------------------------------------+
    // | Copyright (c) incadea China                  |
    // +----------------------------------------------+
    // TFS          ID             WHO    DATE        DESCRIPTION
    // 112051       MARS_TWN-6456  GG     2018-02-26  Add new key "Posting Date"
    Caption = 'Posted Sales Invoices';
    PromotedActionCategories = 'New,Process,Report,Invoice,Navigate,Dummy6,Dummy7,Dummy8,Dummy9,Correct';
    layout
    {
        addafter("Location Code")
        {
            field("Campaign No."; "Campaign No.")
            {
                Editable = false;
            }
        }
    }
}

