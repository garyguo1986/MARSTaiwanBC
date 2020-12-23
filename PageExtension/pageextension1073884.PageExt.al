pageextension 1073884 pageextension1073884 extends "Purch. Receipt Lines"
{
    // +--------------------------------------------------------------+
    // | @ 2017 incadea Taiwan Limited                                |
    // +--------------------------------------------------------------+
    // | PURPOSE: MARS_TWN                                            |
    // +--------------------------------------------------------------+

    // VERSION       ID            WHO    DATE        DESCRIPTION
    // TWN.01.02     RGS_TWN-370   NN     2017-04-18  Show "Posting Date"    
    layout
    {
        addafter("Buy-from Vendor No.")
        {
            field("Posting Date"; "Posting Date")
            {
                ApplicationArea = All;
                trigger OnValidate()
                begin

                end;
            }
        }
    }
}
