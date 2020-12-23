page 50010 "Cashed NP Ledger Entries"
{
    // +--------------------------------------------------------------+
    // | @ 2017 incadea Taiwan Limited                                |
    // +--------------------------------------------------------------+
    // | PURPOSE: MARS_TWN                                            |
    // |                                                              |
    // | REMARK :                                                     |
    // +--------------------------------------------------------------+

    // VERSION       ID                  WHO    DATE        DESCRIPTION
    // TWN.01.09     RGS_TWN-INC01_NPNR  AH     2017-06-05  INITIAL RELEASE
    ApplicationArea = All;
    Editable = false;
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    DataCaptionFields = "Bank Account No.";
    Caption = 'Cashed NP Ledger Entries';
    PageType = List;
    SourceTable = "Check Ledger Entry";
    SourceTableView = where("Entry Status" = const(Posted), "Note Type" = filter(NP));
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                }
                field("Bal. Account No."; Rec."Bal. Account No.")
                {
                    ApplicationArea = All;
                }
                field("Check No."; Rec."Check No.")
                {
                    ApplicationArea = All;
                }
                field("Check Date"; Rec."Check Date")
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field(Drawee; Rec.Drawee)
                {
                    ApplicationArea = All;
                }
                field("Drawee Bank No."; Rec."Drawee Bank No.")
                {
                    ApplicationArea = All;
                }
                field("Drawee Bank Name"; Rec."Drawee Bank Name")
                {
                    ApplicationArea = All;
                }
                field("Currency Code"; "Currency Code")
                {
                    ApplicationArea = All;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                }
                field("Bal. Account Type"; Rec."Bal. Account Type")
                {
                    ApplicationArea = All;
                }
                field("Bank Account No."; Rec."Bank Account No.")
                {
                    ApplicationArea = All;
                }
                field("Entry Status"; Rec."Entry Status")
                {
                    ApplicationArea = All;
                }
                field("Original Entry Status"; Rec."Original Entry Status")
                {
                    ApplicationArea = All;
                }
                field("Bank Payment Type"; Rec."Bank Payment Type")
                {
                    ApplicationArea = All;
                }
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = All;
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                }
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
    actions
    {
        area(Navigation)
        {
            action("VoidCheck")
            {
                Caption = 'Void Cashed Check';
                Image = VoidCheck;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                trigger OnAction()
                var
                    CheckManagement: Codeunit "LocalizedCheckManagement";
                begin
                    CheckManagement.FinancialVoidCheck(Rec);
                end;
            }
            action("ShowDetail")
            {
                Caption = 'Detailed Check Entries';
                Image = ViewDocumentLine;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                RunObject = page "Detailed Check Entries";
                RunPageView = sorting("Check Entry No", "Posting Date") order(ascending);
                RunPageLink = "Check Entry No" = field("Entry No.");
            }
            action("Navigate")
            {
                Caption = 'Navigate';
                Image = Navigate;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
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
