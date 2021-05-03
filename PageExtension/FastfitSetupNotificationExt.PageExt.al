pageextension 1044889 "Fastfit Setup-Notification Ext" extends "Fastfit Setup - Notification"
{
    // +--------------------------------------------------------------+
    // | ?2015 ff. Begusch Software Systeme                          |
    // #3..21
    // +--------------------------------------------------------------+
    // | @ 2017 incadea Taiwan Limited                                |
    // +--------------------------------------------------------------+
    // | PURPOSE: MARS_TWN                                            |
    // |                                                              |
    // | REMARK :                                                     |
    // +--------------------------------------------------------------+
    // 
    // VERSION     ID          WHO    DATE        DESCRIPTION
    // TWN.01.03   RGS_TWN-327 AH     2017-04-20  Add Fields : Birthday Greetings Text Code and Customer Agreement Text Code on Sales Group
    // 122779	   RGS_TWN-8365 QX	   2021-04-06  Added field Disagreement Code

    Caption = 'Fastfit Setup - Notification';
    layout
    {
        addafter("Customer Visit Service Type")
        {
            field("Birthday Greetings Text Code"; "Birthday Greetings Text Code")
            {
            }
            field("Customer Agreement Text Code"; "Customer Agreement Text Code")
            {
            }
        }
        //++TWN1.0.0.3.122779.QX
        addafter("Consent Lev. Bus. Commun.")
        {
            field("Disagreement Code"; "Disagreement Code")
            {
            }
        }
        //--TWN1.0.0.3.122779.QX
    }
}

