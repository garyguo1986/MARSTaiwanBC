pageextension 1044889 pageextension1044889 extends "Fastfit Setup - Notification"
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
    }
}

