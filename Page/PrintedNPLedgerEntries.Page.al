page 50005 "Printed NP Ledger Entries"
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
    Caption = 'Printed NP Ledger Entries';
    InsertAllowed = false;
    DeleteAllowed = false;
    PageType = List;
    SourceTable = "Check Ledger Entry";
    SourceTableView = where("Entry Status" = const(Printed), "Note Type" = filter(NP));
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
                field("Print Date"; "Print Date")
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
            group(Action1000000019)
            {
                action("Detailed Check Entries")
                {
                    Caption = 'Detailed Check Entries';
                    RunObject = page "Detailed Check Entries";
                    RunPageView = sorting("Check Entry No", "Posting Date");
                    RunPageLink = "Check Entry No" = field("Entry No.");
                }
                action("&Navigate")
                {
                    Caption = '&Navigate';
                    trigger OnAction()
                    begin
                        Navigate.SetDoc("Posting Date", "Check No.");
                        Navigate.RUN();
                    end;
                }
            }
        }
    }
    var
        Navigate: Page "Check Navigate";
}
