pageextension 1044874 pageextension1044874 extends "Posted Sales Credit Memos"
{
    // +--------------------------------------------------------------+
    // | ?2005 ff. Begusch Software Systeme                          |
    // #3..38
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
    Caption = 'Posted Sales Credit Memos';
    PromotedActionCategories = 'New,Process,Report,Cr. Memo,Dummy5,Dummy6,Dummy7,Dummy8,Dummy9,Navigate';
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

