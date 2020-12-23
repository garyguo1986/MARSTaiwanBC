page 50002 "Localized Reconciliation"
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
    Caption = 'Localized Reconciliation';
    PageType = List;
    SourceTable = "G/L Account Net Change";
    SourceTableTemporary = true;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                }
                field("Net Change in Jnl."; Rec."Net Change in Jnl.")
                {
                    ApplicationArea = All;
                }
                field("Balance after Posting"; Rec."Balance after Posting")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
    procedure SetGenJnlLine(var NewGenJnlLine: Record "Gen. Journal Line")
    var
        myInt: Integer;
    begin
        GenJnlLine.COPY(NewGenJnlLine);
        Heading := GenJnlLine."Journal Batch Name";
        DELETEALL;
        GLAcc.SETCURRENTKEY("Reconciliation Account");
        GLAcc.SETRANGE("Reconciliation Account", TRUE);
        IF GLAcc.FIND('-') THEN
            REPEAT
                InsertGLAccNetChange;
            UNTIL GLAcc.NEXT = 0;

        IF GenJnlLine.FIND('-') THEN
            REPEAT
                SaveNetChange(
                  GenJnlLine."Account Type", GenJnlLine."Account No.",
                  ROUND(GenJnlLine."Amount (LCY)" / (1 + GenJnlLine."VAT %" / 100)));
                SaveNetChange(
                  GenJnlLine."Bal. Account Type", GenJnlLine."Bal. Account No.",
                  -ROUND(GenJnlLine."Amount (LCY)" / (1 + GenJnlLine."Bal. VAT %" / 100)));
            UNTIL GenJnlLine.NEXT = 0;
        IF FIND('-') THEN;
    end;

    local procedure SaveNetChange(AccType: Integer; AccNo: Code[20]; NetChange: Decimal)
    begin
        IF AccNo = '' THEN
            EXIT;
        CASE AccType OF
            GenJnlLine."Account Type"::"G/L Account":
                IF NOT GET(AccNo) THEN
                    EXIT;
            GenJnlLine."Account Type"::"Bank Account":
                BEGIN
                    IF AccNo <> BankAcc."No." THEN BEGIN
                        BankAcc.GET(AccNo);
                        BankAcc.TESTFIELD("Bank Acc. Posting Group");
                        BankAccPostingGr.GET(BankAcc."Bank Acc. Posting Group");
                        BankAccPostingGr.TESTFIELD("G/L Bank Account No.");
                    END;
                    AccNo := BankAccPostingGr."G/L Bank Account No.";
                    IF NOT GET(AccNo) THEN BEGIN
                        GLAcc.GET(AccNo);
                        InsertGLAccNetChange;
                    END;

                    IF BankAcc."No." <> BankCheckAccSetup."Bank Account No." THEN BEGIN
                        BankCheckAccSetup.GET(BankAcc."No.");
                        BankCheckAccSetup.TESTFIELD("Note Payable Account");
                        BankCheckAccSetup.TESTFIELD("Note Receivable Account");
                        AccNo := BankCheckAccSetup."Note Payable Account";
                        IF NOT GET(AccNo) THEN BEGIN
                            GLAcc.GET(AccNo);
                            InsertGLAccNetChange;
                        END;
                        IF BankCheckAccSetup."Note Payable Account" <>
                          BankCheckAccSetup."Note Receivable Account" THEN BEGIN
                            AccNo := BankCheckAccSetup."Note Receivable Account";
                            IF NOT GET(AccNo) THEN BEGIN
                                GLAcc.GET(BankCheckAccSetup."Note Receivable Account");
                                InsertGLAccNetChange;
                            END;
                        END;
                    END;
                END;
            ELSE
                EXIT;
        END;

        "Net Change in Jnl." := "Net Change in Jnl." + NetChange;
        "Balance after Posting" := "Balance after Posting" + NetChange;
        MODIFY;
    end;

    procedure InsertGLAccNetChange()
    begin
        GLAcc.CALCFIELDS("Balance at Date");
        INIT;
        "No." := GLAcc."No.";
        Name := GLAcc.Name;
        "Balance after Posting" := GLAcc."Balance at Date";
        INSERT;

    end;

    var
        GenJnlLine: Record "Gen. Journal Line";
        GLAcc: Record "G/L Account";
        BankAccPostingGr: Record "Bank Account Posting Group";
        BankAcc: Record "Bank Account";
        BankCheckAccSetup: Record "Bank Check Acc. Setup";
        Heading: Code[10];
}
