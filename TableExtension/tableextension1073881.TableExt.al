tableextension 1073881 tableextension1073881 extends "Return Reason"
{
    // +--------------------------------------------------------------+
    // | @ 2017 incadea Taiwan Limited                                |
    // +--------------------------------------------------------------+
    // | PURPOSE: MARS_TWN                                            |
    // |                                                              |
    // | REMARK :                                                     |
    // +--------------------------------------------------------------+

    // VERSION      ID          WHO    DATE        DESCRIPTION
    // TWN.01.01    RGS_TWN-425 NN     2017-05-31  Added field: "Cancel of Invoice"

    fields
    {
        field(50000; "Cancel of Invoice"; Boolean)
        {
            Caption = 'Cancel of Invoice';
            Description = 'TWN.01.01';
            DataClassification = ToBeClassified;
        }
    }
}
