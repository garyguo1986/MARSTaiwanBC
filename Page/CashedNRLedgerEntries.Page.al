page 50014 "Cashed NR Ledger Entries"
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

    Caption = 'Cashed NR Ledger Entries';
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Check Ledger Entry";
    SourceTableView = WHERE("Entry Status" = CONST(Posted),
                            "Note Type" = FILTER(NR));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Posting Date"; "Posting Date")
                {
                }
                field("Bank Account No."; "Bank Account No.")
                {
                }
                field("Check No."; "Check No.")
                {
                }
                field("Check Date"; "Check Date")
                {
                }
                field(Description; Description)
                {
                }
                field(Drawee; Drawee)
                {
                }
                field("Drawee Bank No."; "Drawee Bank No.")
                {
                }
                field("Drawee Bank Name"; "Drawee Bank Name")
                {
                }
                field("Currency Code"; "Currency Code")
                {
                }
                field(Amount; Amount)
                {
                }
                field("Bal. Account Type"; "Bal. Account Type")
                {
                }
                field("Bal. Account No."; "Bal. Account No.")
                {
                }
                field("Entry Status"; "Entry Status")
                {
                }
                field("Original Entry Status"; "Original Entry Status")
                {
                }
                field("Bank Payment Type"; "Bank Payment Type")
                {
                }
                field("Document Type"; "Document Type")
                {
                }
                field("Document No."; "Document No.")
                {
                }
                field("Entry No."; "Entry No.")
                {
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action(VoidCheck)
            {
                Caption = 'Void Cashed Check';
                Image = VoidCheck;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    CheckManagement: Codeunit LocalizedCheckManagement;
                begin
                    CheckManagement.FinancialCashVoidCheck(Rec);
                end;
            }
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
            action(Navigate)
            {
                Caption = 'Navigate';
                Image = Navigate;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    Navigate.SetDoc("Posting Date", "Check No.");
                    Navigate.RUN;
                end;
            }
        }
    }

    var
        Navigate: Page "Check Navigate";
}

