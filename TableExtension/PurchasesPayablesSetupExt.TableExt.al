tableextension 1073878 "Purchases & Payables Setup Ext" extends "Purchases & Payables Setup"
{

    // +--------------------------------------------------------------+
    // | @ 2017 incadea Taiwan Limited                                |
    // +--------------------------------------------------------------+
    // | PURPOSE: MARS_TWN                                            |
    // |                                                              |
    // | REMARK :                                                     |
    // +--------------------------------------------------------------+

    // VERSION     ID                  WHO    DATE        DESCRIPTION
    // TWN.01.09   RGS_TWN-INC01_NPNR  AH     2017-06-05  Add New Field "Check Receipt Report ID"    
    fields
    {
        field(50000; "Check Receipt Report ID"; Integer)
        {
            Caption = 'Check Receipt Report ID';
            DataClassification = ToBeClassified;
        }
    }
}
