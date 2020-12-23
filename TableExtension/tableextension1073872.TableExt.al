tableextension 1073872 tableextension1073872 extends "Purchase Line"
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
            Description = '122010';
            DataClassification = ToBeClassified;
        }
    }
}
