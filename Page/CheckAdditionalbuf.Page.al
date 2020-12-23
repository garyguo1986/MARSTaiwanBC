page 50016 "Check Additional buf"
{
    // +--------------------------------------------------------------+
    // | @ 2017 incadea Taiwan Limited                                |
    // +--------------------------------------------------------------+
    // | PURPOSE: MARS_TWN                                            |
    // |                                                              |
    // | REMARK :                                                     |
    // +--------------------------------------------------------------+
    // 
    // VERSION       ID                  WHO    DATE        DESCRIPTION
    // TWN.01.09     RGS_TWN-INC01_NPNR  AH     2017-06-05  INITIAL RELEASE

    Caption = 'Check Additional buf';
    DelayedInsert = true;
    DeleteAllowed = false;
    LinksAllowed = false;
    MultipleNewLines = true;
    PageType = CardPart;
    RefreshOnActivate = true;
    SourceTable = "Check Ledger Entry buffer";
    SourceTableView = SORTING("Journal Template Name", "Journal Batch Name", "Journal Document", "Entry No.");

    layout
    {
        area(content)
        {
            field(Drawee; Drawee)
            {
            }
            field("Drawee Bank No."; "Drawee Bank No.")
            {
            }
            field("Drawee Bank Name"; "Drawee Bank Name")
            {
            }
            field("Drawee Bank Domicile"; "Drawee Bank Domicile")
            {
            }
        }
    }

    actions
    {
    }
}

