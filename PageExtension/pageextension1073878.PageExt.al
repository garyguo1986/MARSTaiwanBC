pageextension 1073878 pageextension1073878 extends "Posted Purchase Rcpt. Subform"
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
    layout
    {
        addafter("Item EAN No.")
        {
            field("Direct Unit Cost"; "Direct Unit Cost")
            {
            }
            field("Unit Cost (LCY)"; "Unit Cost (LCY)")
            {
            }
            field("VAT Base Amount"; "VAT Base Amount")
            {
            }
        }
    }
}
