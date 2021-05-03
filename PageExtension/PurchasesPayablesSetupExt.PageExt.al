pageextension 1073883 "Purchases & Payables Setup Ext" extends "Purchases & Payables Setup"
{
    // +--------------------------------------------------------------+
    // | @ 2017 incadea Taiwan Limited                                |
    // +--------------------------------------------------------------+
    // | PURPOSE: MARS_TWN                                            |
    // +--------------------------------------------------------------+

    // VERSION     ID                    WHO    DATE        DESCRIPTION
    // TWN.01.09   RGS_TWN-INC01_NPNR    AH     2017-06-02  Show field: "Check Receipt Report ID"

    layout
    {
        addafter("Default Qty. to Receive")
        {
            field("Check Receipt Report ID"; "Check Receipt Report ID")
            {
                ApplicationArea = All;
            }
        }
    }
}
