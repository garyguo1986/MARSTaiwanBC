pageextension 1073872 pageextension1073872 extends "Vendor Card"
{
    // +--------------------------------------------------------------+
    // | @ 2017 incadea Taiwan Limited                                |
    // +--------------------------------------------------------------+
    // | PURPOSE: MARS_TWN                                            |
    // |                                                              |
    // +--------------------------------------------------------------+

    // VERSION      ID           WHO    DATE        DESCRIPTION
    // TWN.01.07    RGS_TWN-532  AH     2017-09-12  AssistEdit Properity of No. set to False    
    layout
    {
        modify("No.")
        {
            AssistEdit = false;
        }
    }
}
