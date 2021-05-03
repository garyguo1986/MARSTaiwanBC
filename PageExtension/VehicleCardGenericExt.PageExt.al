pageextension 1044886 "Vehicle Card Generic Ext" extends "Vehicle Card Generic"
{
    // +--------------------------------------------------------------+
    // | ?2003 ff. Begusch Software Systeme                          |
    // #3..24
    // 070001 IT_20001 1CF 2013-06-25  Upgraded to NAV 7
    // #26..62
    // +--------------------------------------------------------------+
    // | @ 2017 incadea Taiwan Limited                                |
    // +--------------------------------------------------------------+
    // | PURPOSE: MARS_TWN                                            |
    // |                                                              |
    // +--------------------------------------------------------------+
    // 
    // VERSION       ID          WHO    DATE        DESCRIPTION
    // TWN.01.01     RGW_TWN-425 NN     2017-06-01  Added PageAction - Report TWN Daily Sales Register
    Caption = 'Vehicle Card';
    PromotedActionCategories = 'New,Process,Report,Manage';
    actions
    {
        addfirst(reporting)
        {
            action("TWN Daily Sales Register")
            {
                Caption = 'TWN Daily Sales Register';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";

                trigger OnAction()
                var
                    SalesInvHeaderL: Record "Sales Invoice Header";
                    SalesInvLineL: Record "Sales Invoice Line";
                    TWNDailySalesReportL: Report "TWN Daily Sales Register";
                begin
                    //++Inc.TWN-425.NN
                    CLEAR(SalesInvHeaderL);
                    SalesInvHeaderL.SETFILTER("Posting Date", '%1..%2', DMY2DATE(1, 1, 2013), TODAY);
                    SalesInvHeaderL.SETRANGE("Vehicle No.", "Vehicle No.");
                    TWNDailySalesReportL.SETTABLEVIEW(SalesInvHeaderL);
                    TWNDailySalesReportL.RUN;
                    //--Inc.TWN-425.NN
                end;
            }
        }
    }
}

