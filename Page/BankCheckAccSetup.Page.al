page 50000 "Bank Check Acc. Setup"
{
    // +--------------------------------------------------------------+
    // | @ 2017 incadea Taiwan Limited                                |
    // +--------------------------------------------------------------+
    // | PURPOSE: MARS_TWN                                            |
    // |                                                              |
    // | REMARK :                                                     |
    // +--------------------------------------------------------------+
    // 
    // VERSION     ID                  WHO    DATE        DESCRIPTION
    // TWN.01.09   RGS_TWN-INC01_NPNR  AH     2017-06-05  INITIAL RELEASE

    Caption = 'Bank Check Acc. Setup';
    PageType = List;
    SourceTable = "Bank Check Acc. Setup";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Bank Account No."; "Bank Account No.")
                {
                }
                field("Note Payable Account"; "Note Payable Account")
                {
                }
                field("Note Receivable Account"; "Note Receivable Account")
                {
                }
            }
        }
    }

    actions
    {
    }
}

