tableextension 1044865 tableextension1044865 extends "Fastfit Setup - General"
{
    // +--------------------------------------------------------------+
    // | ?2005 ff. Begusch Software Systeme                          |
    // #3..199
    // +--------------------------------------------------------------+
    // | @ 2017 incadea Taiwan Limited                                |
    // +--------------------------------------------------------------+
    // | PURPOSE: MARS_TWN                                            |
    // |                                                              |
    // +--------------------------------------------------------------+
    // 
    // VERSION      ID           WHO    DATE        DESCRIPTION
    // RGS_TWN-561               NN     2017-04-21  Add "No SC Check for Fin Chk Name"
    // 
    // 
    // ---SLA---
    //       FEATURE ID  DATE      WHO  ID     DESCRIPTION
    //       AP.0040898  15.01.20  SS   40898  SLA: added new field "Special Character To Remove" - FieldNo.1017161
    fields
    {
        field(50000; "No SC Check for Fin Chk Name"; Boolean)
        {
            Description = 'RGS_TWN-561';
        }
    }
}

