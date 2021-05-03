tableextension 1073880 "SMTP Mail Setup Ext" extends "SMTP Mail Setup"
{
    // +--------------------------------------------------------------+
    // | @ 2017 incadea Taiwan Limited                                |
    // +--------------------------------------------------------------+
    // | PURPOSE: MARS_TWN                                            |
    // |                                                              |
    // | REMARK :                                                     |
    // +--------------------------------------------------------------+
    // VERSION       ID          WHO    DATE        DESCRIPTION
    // TWN.01.03     RGS_TWN-605 AH     2017-08-02  Add Field 50000 SMS Mail Address for Taiwan SMS

    // +--------------------------------------------------------------+
    // | @ 2020 incadea Taiwan Limited                                |
    // +--------------------------------------------------------------+
    // | PURPOSE: MARS_TWN                                            |
    // |                                                              |
    // | REMARK :                                                     |
    // +--------------------------------------------------------------+

    // VERSION       ID            WHO    DATE        DESCRIPTION
    // RGS_AGL-3620  121528        GG     2020-04-08  Added field "Active CRM"
    fields
    {
        field(50000; "SMS Mail Address"; Text[80])
        {
            Caption = 'SMS Mail Address';
            DataClassification = ToBeClassified;
        }
    }
}
