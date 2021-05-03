pageextension 1044870 "Apply Customer Entries Ext" extends "Apply Customer Entries"
{
    // +--------------------------------------------------------------+
    // | ?2005 ff. Begusch Software Systeme                          |
    // #3..41
    // 
    // +--------------------------------------------------------------+
    // | @ 2017 incadea Taiwan Limited                                |
    // +--------------------------------------------------------------+
    // | PURPOSE: MARS_TWN                                            |
    // |                                                              |
    // +--------------------------------------------------------------+
    // 
    // VERSION      WHO    DATE        DESCRIPTION
    // RGS_TWN-336  NN     2017-04-20  Add fields 50000 - 50003
    Caption = 'Apply Customer Entries';
    layout
    {
        addafter("Customer No.")
        {
            field("Bill-to Contact Name"; "Bill-to Contact Name")
            {
            }
            field("Licence-Plate No."; "Licence-Plate No.")
            {
            }
            field("Bill-to Phone No."; "Bill-to Phone No.")
            {
            }
            field("Bill-to Mobile Phone No."; "Bill-to Mobile Phone No.")
            {
            }
        }
    }
}

