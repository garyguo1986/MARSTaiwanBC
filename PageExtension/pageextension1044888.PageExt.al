pageextension 1044888 pageextension1044888 extends "Fastfit Setup - Reporting"
{
    // +--------------------------------------------------------------+
    // | ?2015 ff. Begusch Software Systeme                          |
    // #3..22
    // +--------------------------------------------------------------+
    // | @ 2017 Incadea Taiwan Limited                                |
    // +--------------------------------------------------------------+
    // | PURPOSE: MARS_TWN                                            |
    // |                                                              |
    // | REMARK :                                                     |
    // +--------------------------------------------------------------+
    // 
    // VERSION   ID             WHO    DATE        DESCRIPTION
    // TWN.01.01 RGS_TWN-459    AH     2017-06-02  add fields on Sales table of page.
    //                                               1."Position group of Balancing"
    //                                               2."Position group of Alignments"
    //                                               3."Position Group For Tire"
    //                                               4."Position Group For Tire RelSer"
    // +--------------------------------------------------------------+
    // | @ 2019 incadea Taiwan Limited                                |
    // +--------------------------------------------------------------+
    // | PURPOSE: MARS_TWN                                            |
    // |                                                              |
    // | REMARK :                                                     |
    // +--------------------------------------------------------------+
    // 
    // VERSION       ID            WHO    DATE        DESCRIPTION
    // RGS_TWN-809   118849        GG     2019-03-13  Add new fields "Position Group For TurnOver" "Main Group For Tire" "Position Group For OilFilter" "Position Group For Oil"
    Caption = 'Fastfit Setup - Reporting';
    layout
    {
        addafter("Product Mix Template")
        {
            field("Position Group For Tire"; "Position Group For Tire")
            {
            }
            field("Position Group For Tire RelSer"; "Position Group For Tire RelSer")
            {
            }
            field("Position group of Balancing"; "Position group of Balancing")
            {
            }
            field("Position group of Alignments"; "Position group of Alignments")
            {
            }
            field("Position Group For TurnOver"; "Position Group For TurnOver")
            {
            }
            field("Main Group For Tire"; "Main Group For Tire")
            {
            }
            field("Position Group For NonTire"; "Position Group For NonTire")
            {
            }
            field("Position Group For OilFilter"; "Position Group For OilFilter")
            {
            }
            field("Position Group For Oil"; "Position Group For Oil")
            {
            }
        }
    }
}

