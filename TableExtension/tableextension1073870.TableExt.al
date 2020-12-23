tableextension 1073870 tableextension1073870 extends Vendor
{
    // +--------------------------------------------------------------+
    // | @ 2020 incadea Taiwan Limited                                |
    // +--------------------------------------------------------------+
    // | PURPOSE: MARS_TWN                                            |
    // |                                                              |
    // | REMARK :                                                     |
    // +--------------------------------------------------------------+
    // VERSION       ID            WHO    DATE        DESCRIPTION
    // RGS_TWN-874   122010        GG     2020-08-28  Added field Michelin (RGS_CHN-1540  120360)
    fields
    {
        field(50010; Michelin; Boolean)
        {
            Caption = 'Michelin';
            DataClassification = ToBeClassified;
            Description = '122010: Warning the field will copy to contact, avoid id collision!';
        }
    }
}
