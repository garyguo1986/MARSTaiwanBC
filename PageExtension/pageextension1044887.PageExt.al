pageextension 1044887 pageextension1044887 extends "Post. Cash Reg. Statement List"
{
    // +--------------------------------------------------------------+
    // | ?2005 ff. Begusch Software Systeme                          |
    // #3..20
    // +----------------------------------------------+
    // | Copyright (c) incadea China                  |
    // +----------------------------------------------+
    // TFS          ID             WHO    DATE        DESCRIPTION
    // 120525       RGS_TWN-828    GG     2019-09-05  Add new fields "Cash Reg. Balance (LCY)","Cash Reg. Balance" and add CHT translation for the two fields
    Caption = 'Posted Cash Register Statements';
    layout
    {
        addafter("Cash Register No.")
        {
            field("Cash Reg. Balance (LCY)"; "Cash Reg. Balance (LCY)")
            {
                Caption = 'Amount (LCY)';
            }
            field("Cash Reg. Balance"; "Cash Reg. Balance")
            {
                Caption = 'Amount';
            }
        }
    }
}

