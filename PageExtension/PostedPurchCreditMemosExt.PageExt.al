pageextension 1073881 "Posted Purch. Credit Memos Ext" extends "Posted Purchase Credit Memos"
{
    // +--------------------------------------------------------------+
    // | @ 2017 incadea Taiwan Limited                                |
    // +--------------------------------------------------------------+
    // | PURPOSE: MARS_TWN                                            |
    // |                                                              |
    // | REMARK :                                                     |
    // +--------------------------------------------------------------+

    // VERSION       ID          WHO    DATE        DESCRIPTION
    // TWN.01.07     RGS_TWN-708 AH     2017-09-11  removed security filter for responsibility center because it is not used anymore(HF21214)
    // +----------------------------------------------+
    // | Copyright (c) incadea China                  |
    // +----------------------------------------------+
    // TFS          ID             WHO    DATE        DESCRIPTION
    // 112051       MARS_TWN-6456  GG     2018-03-02  Add new key "Posting Date"    
    trigger OnOpenPage()
    begin
        // Start 112051
        IF FINDFIRST THEN;
        // Stop 112051
    end;
}
