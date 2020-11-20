tableextension 1044861 tableextension1044861 extends "Fastfit Setup - Notification"
{
    // +--------------------------------------------------------------+
    // | ?2016 ff. Begusch Software Systeme                          |
    // #3..21
    // 
    // +--------------------------------------------------------------+
    // | @ 2017 incadea Taiwan Limited                                |
    // +--------------------------------------------------------------+
    // | PURPOSE: MARS_TWN                                            |
    // |                                                              |
    // | REMARK :                                                     |
    // +--------------------------------------------------------------+
    // 
    // VERSION     ID          WHO    DATE        DESCRIPTION
    // TWN.01.03   RGS_TWN-327 AH     2017-04-20  Add Fields : 1044861 - 1044862
    fields
    {
        field(1044861; "Birthday Greetings Text Code"; Code[20])
        {
            Caption = 'Birthday Greetings Text Code';
            Description = 'TWN.01.03';
            TableRelation = "Standard Text".Code;
        }
        field(1044862; "Customer Agreement Text Code"; Code[20])
        {
            Caption = 'Customer Agreement Text Code';
            Description = 'TWN.01.03';
            TableRelation = "Standard Text".Code;
        }
    }
}

