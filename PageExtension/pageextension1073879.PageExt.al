pageextension 1073879 pageextension1073879 extends "Posted Purchase Receipts"
{
    // +--------------------------------------------------------------+
    // | @ 2017 incadea Taiwan Limited                                |
    // +--------------------------------------------------------------+
    // | PURPOSE: MARS_TWN                                            |
    // |                                                              |
    // | REMARK :                                                     |
    // +--------------------------------------------------------------+
    // VERSION     ID          WHO    DATE        DESCRIPTION
    // RGS_TWN-545             BH     2017-05-24  Add fields "<Direct Unit Cost>", "<Unit Cost (LCY)>", "<VAT Base Amount>".    
    trigger OnOpenPage()
    begin
        // Start 112051
        IF FINDFIRST THEN;
        // Stop 112051
    end;
}
