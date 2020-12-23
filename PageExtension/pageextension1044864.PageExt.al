pageextension 1044864 pageextension1044864 extends "Sales Invoice"
{
    // #1..154
    // 
    // +--------------------------------------------------------------+
    // | @ 2017 incadea Taiwan Limited                                |
    // +--------------------------------------------------------------+
    // | PURPOSE: MARS_TWN                                            |
    // |                                                              |
    // +--------------------------------------------------------------+
    // 
    // VERSION     ID          WHO    DATE        DESCRIPTION
    // TWN.01.09   RGW_TWN-524 AH     2017-09-21  Show "Campaign No." on page.
    Caption = 'Sales Invoice';
    PromotedActionCategories = 'New,Process,Report,Approve,Release,Posting,Prepare,Invoice,Request Approval';
    layout
    {
        addafter("Representative Code")
        {
            field("Campaign No."; "Campaign No.")
            {
            }
        }
    }
}

