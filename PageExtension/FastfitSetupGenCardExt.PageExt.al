pageextension 1073888 "Fastfit Setup - Gen. Card Ext" extends "Fastfit Setup - General Card"
{
    // +--------------------------------------------------------------+
    // | @ 2017 incadea Taiwan Limited                                |
    // +--------------------------------------------------------------+
    // | PURPOSE: MARS_TWN                                            |
    // |                                                              |
    // +--------------------------------------------------------------+

    // VERSION       ID          WHO    DATE        DESCRIPTION
    // RGW_TWN-561               NN     2017-05-23  Show filed: "No SC Check for Fin Chk Name" on page.

    // ---SLA---
    // FEATURE ID  DATE      WHO  ID     DESCRIPTION
    // AP.0040898  15.01.20  SS   40898  SLA: added new field "Special Character To Remove"    
    layout
    {
        addafter("No SC Check for Fitter")
        {
            field("No SC Check for Fin Chk Name"; "No SC Check for Fin Chk Name")
            {
                ApplicationArea = All;
            }
        }
    }
}
