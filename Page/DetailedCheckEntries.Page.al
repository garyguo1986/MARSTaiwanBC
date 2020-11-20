page 50007 "Detailed Check Entries"
{
    // +--------------------------------------------------------------+
    // | @ 2017 incadea Taiwan Limited                                |
    // +--------------------------------------------------------------+
    // | PURPOSE: MARS_TWN                                            |
    // |                                                              |
    // | REMARK :                                                     |
    // +--------------------------------------------------------------+
    // 
    // VERSION         ID                  WHO    DATE        DESCRIPTION
    // TWN.01.09       RGS_TWN-INC01_NPNR  AH     2017-06-05  INITIAL RELEASE

    Caption = 'Detailed Check Entries';
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    PageType = List;
    SourceTable = "Detailed Check Entry";
    SourceTableView = SORTING("Entry No.");

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Posting Date"; "Posting Date")
                {
                }
                field("Document Type"; "Document Type")
                {
                }
                field("Document No."; "Document No.")
                {
                }
                field("Check Date"; "Check Date")
                {
                }
                field("Check No."; "Check No.")
                {
                }
                field("Bank Payment Type"; "Bank Payment Type")
                {
                }
                field("User ID"; "User ID")
                {
                }
                field("Note Type"; "Note Type")
                {
                }
                field("Currency Code"; "Currency Code")
                {
                }
                field("Currency Factor"; "Currency Factor")
                {
                }
                field("Currency Date"; "Currency Date")
                {
                }
                field("Entry Status"; "Entry Status")
                {
                }
                field("Status Sub Type"; "Status Sub Type")
                {
                }
                field("Transaction No."; "Transaction No.")
                {
                }
            }
        }
    }

    actions
    {
    }
}

