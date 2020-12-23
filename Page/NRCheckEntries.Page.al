page 50019 "NR Check Entries"
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

    Caption = 'NR Check Entries';
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Check Ledger Entry";
    SourceTableView = SORTING("Bank Account No.", "Check Date")
                      ORDER(Ascending)
                      WHERE("Note Type" = FILTER(NR));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Check Date"; "Check Date")
                {
                }
                field("Print Date"; "Print Date")
                {
                }
                field(RenewDate; RenewDate)
                {
                    Caption = 'Cash Date';
                }
                field(VoidDate; VoidDate)
                {
                    Caption = 'Void Date';
                }
                field("Check No."; "Check No.")
                {
                }
                field("Bal. Account No."; "Bal. Account No.")
                {
                }
                field(Description; Description)
                {
                }
                field(Amount; Amount)
                {
                }
                field("Currency Code"; "Currency Code")
                {
                }
                field("Entry Status"; "Entry Status")
                {
                }
                field("Drawee Bank No."; "Drawee Bank No.")
                {
                }
                field("Drawee Bank Name"; "Drawee Bank Name")
                {
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action(ShowDetail)
            {
                Caption = 'Detailed Check Entries';
                Image = ViewDocumentLine;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "Detailed Check Entries";
                RunPageLink = "Check Entry No" = FIELD("Entry No.");
                RunPageView = SORTING("Check Entry No", "Posting Date")
                              ORDER(Ascending);
            }
        }
    }

    trigger OnAfterGetRecord()
    var
        tempPostingDate: Date;
    begin
        CLEAR(tempPostingDate);
        tempPostingDate := GetPostingDate("Entry No.");
        IF ("Entry Status" = "Entry Status"::Voided) OR ("Entry Status" = "Entry Status"::"Financially Voided") THEN BEGIN
            CLEAR(RenewDate);
            VoidDate := tempPostingDate;
        END ELSE
            IF ("Entry Status" = "Entry Status"::Posted) THEN BEGIN
                CLEAR(VoidDate);
                RenewDate := tempPostingDate;
            END ELSE BEGIN
                CLEAR(VoidDate);
                CLEAR(RenewDate);
            END;
    end;

    var
        RenewDate: Date;
        VoidDate: Date;

    [Scope('OnPrem')]
    procedure GetPostingDate(tempEntryNo: Integer) tPostingDate: Date
    var
        recDetailLedgerEntry: Record "Detailed Check Entry";
    begin
        CLEAR(tPostingDate);
        CLEAR(recDetailLedgerEntry);
        recDetailLedgerEntry.RESET;

        recDetailLedgerEntry.SETCURRENTKEY("Entry No.");
        recDetailLedgerEntry.SETFILTER(recDetailLedgerEntry."Check Entry No", FORMAT(tempEntryNo));
        IF recDetailLedgerEntry.FIND('+') THEN BEGIN
            tPostingDate := recDetailLedgerEntry."Posting Date";
        END;
    end;
}

