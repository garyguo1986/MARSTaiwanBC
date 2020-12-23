tableextension 1073877 tableextension1073877 extends "Purch. Inv. Line"
{
    // +--------------------------------------------------------------+
    // | @ 2020 incadea Taiwan Limited                                |
    // +--------------------------------------------------------------+
    // | PURPOSE: MARS_TWN                                            |
    // |                                                              |
    // | REMARK :                                                     |
    // +--------------------------------------------------------------+

    // VERSION       ID            WHO    DATE        DESCRIPTION
    // RGS_TWN-874   122010        GG     2020-08-28  Added field "OCT Line No." (RGS_CHN-1540  120360)

    fields
    {
        field(50105; "OCT Line No."; Integer)
        {
            Caption = 'OCT Line No.';
            Description = '120360';
            DataClassification = ToBeClassified;
        }
    }
}
