pageextension 1073871 "Customer Ledger Entries Ext" extends "Customer Ledger Entries"
{
    // +--------------------------------------------------------------+
    // | @ 2017 incadea Taiwan Limited                                |
    // +--------------------------------------------------------------+
    // | PURPOSE: MARS_TWN                                            |
    // |                                                              |
    // +--------------------------------------------------------------+

    // VERSION      WHO    DATE        DESCRIPTION
    // RGS_TWN-336  NN     2017-04-20  Add fields 50000 - 50003    
    layout
    {
        addafter("Bill-to Contact No.")
        {
            field("Bill-to Contact Name"; "Bill-to Contact Name")
            {
                ApplicationArea = All;
            }
            field("Licence-Plate No."; "Licence-Plate No.")
            {
                ApplicationArea = All;
            }
            field("Bill-to Phone No."; "Bill-to Phone No.")
            {
                ApplicationArea = All;
            }
            field("Bill-to Mobile Phone No."; "Bill-to Mobile Phone No.")
            {
                ApplicationArea = All;
            }
        }
    }
}
