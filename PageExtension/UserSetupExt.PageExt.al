pageextension 1073877 "User Setup Ext" extends "User Setup"
{
    // +--------------------------------------------------------------+
    // | @ 2017 Incadea Taiwan Limited                                |
    // +--------------------------------------------------------------+
    // | PURPOSE: MARS_TWN                                            |
    // |                                                              |
    // | REMARK :                                                     |
    // +--------------------------------------------------------------+

    // VERSION   ID             WHO    DATE        DESCRIPTION
    // TWN.01.01 RGS_TWN-459    AH     2017-06-02  add field "Zone Code" on page.

    // +--------------------------------------------------------------+
    // | @ 2020 incadea China Limited                                 |
    // +--------------------------------------------------------------+
    // | PURPOSE: MARS_TWN                                            |
    // |                                                              |
    // | REMARK :                                                     |
    // +--------------------------------------------------------------+

    // VERSION       ID            WHO    DATE        DESCRIPTION
    // RGS_TWN-872   122137        GG     2020-10-13  New field "Not Block Item Manufacturer"    
    layout
    {
        addafter("Preferred Cash Register")
        {
            field("Zone Code"; "Zone Code")
            {
            }
        }
        addafter("Undo Special Order allowed")
        {
            field("Not Block Item Manufacturer"; "Not Block Item Manufacturer")
            {
            }
        }
    }
}
