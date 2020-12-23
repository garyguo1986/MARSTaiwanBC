codeunit 50000 LocalizedCheckManagement
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
    // RGS_TWN-888   122187	     QX	    2020-12-03  Convert Option to Enum

    Permissions = TableData 21 = rm,
                  TableData 25 = rm,
                  TableData 271 = rm,
                  TableData 272 = rim;

    trigger OnRun()
    begin
    end;

    var
        Text000: Label 'Check %1 already exists for this %2.';
        Text001: Label 'Voiding check %1.';
        GenJnlLine2: Record "Gen. Journal Line";
        BankAcc: Record "Bank Account";
        BankAccLedgEntry2: Record "Bank Account Ledger Entry";
        CheckLedgEntry2: Record "Check Ledger Entry";
        SourceCodeSetup: Record "Source Code Setup";
        VendorLedgEntry: Record "Vendor Ledger Entry";
        GLEntry: Record "G/L Entry";
        CustLedgEntry: Record "Cust. Ledger Entry";
        FALedgEntry: Record "FA Ledger Entry";
        BankAccLedgEntry3: Record "Bank Account Ledger Entry";
        GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
        UpdateAnalysisView: Codeunit "Update Analysis View";
        NextCheckEntryNo: Integer;
        Text002: Label 'You cannot Financially Void checks posted in a non-balancing transaction.';
        AppliesIDCounter: Integer;
        Text004: Label 'must not be filled when %1 is different in %2 and %3.';
        Text005: Label ' must be entered when %1 is %2';
        Text006: Label 'Check %1 already exists for this Bank Account.';
        Text007: Label 'You cannot Financially Cash checks posted in a non-balancing transaction.';
        Text008: Label 'Cashing check %1.';
        Text009: Label 'Voiding cash check %1.';
        Text010: Label '請選擇相同幣別的票據進行兌現';
        Text011: Label 'The due date must be greater than or equal to the posting date!';
        NoAppliedEntryErr: Label 'Cannot find an applied entry within the specified filter.';
        CheckTransEntry: Record "Detailed Check Entry";
        BankCheckType: Option NP,NR;
        GenJnlBankLinebuf: Record "Gen. Journal Line" temporary;
        BankGLEntry: Record "G/L Entry";

    [Scope('OnPrem')]
    procedure InsertCheck(var CheckLedgEntry: Record "Check Ledger Entry"; xCurrencyCode: Code[20]; xCurrencyFactor: Decimal; xNoteType: Option NP,NR)
    begin
        IF NextCheckEntryNo = 0 THEN BEGIN
            CheckLedgEntry2.LOCKTABLE;
            CheckLedgEntry2.RESET;
            IF CheckLedgEntry2.FIND('+') THEN
                NextCheckEntryNo := CheckLedgEntry2."Entry No." + 1
            ELSE
                NextCheckEntryNo := 1;
        END;

        CheckLedgEntry2.RESET;
        CheckLedgEntry2.SETCURRENTKEY("Bank Account No.", "Entry Status", "Check No.");
        CheckLedgEntry2.SETRANGE("Bank Account No.", CheckLedgEntry."Bank Account No.");
        CheckLedgEntry2.SETFILTER(
          "Entry Status", '%1|%2|%3',
          CheckLedgEntry2."Entry Status"::Printed,
          CheckLedgEntry2."Entry Status"::Posted,
          CheckLedgEntry2."Entry Status"::"Financially Voided");
        CheckLedgEntry2.SETRANGE("Check No.", CheckLedgEntry."Document No.");
        IF CheckLedgEntry2.FIND('-') THEN
            ERROR(Text000, CheckLedgEntry."Document No.", BankAcc.TABLECAPTION);

        CheckLedgEntry.Open := CheckLedgEntry.Amount <> 0;
        CheckLedgEntry."User ID" := USERID;
        CheckLedgEntry."Entry No." := NextCheckEntryNo;
        IF xNoteType = xNoteType::NP THEN BEGIN
            CheckLedgEntry."Note Type" := CheckLedgEntry."Note Type"::NP;
        END ELSE
            IF xNoteType = xNoteType::NR THEN BEGIN
                CheckLedgEntry."Note Type" := CheckLedgEntry."Note Type"::NR;
            END;
        CheckLedgEntry.INSERT;
        InsertCheckTransEntry(CheckLedgEntry, xCurrencyCode, xCurrencyFactor, 8, 0);
        NextCheckEntryNo := NextCheckEntryNo + 1;
    end;

    [Scope('OnPrem')]
    procedure VoidCheck(var GenJnlLine: Record "Gen. Journal Line")
    var
        Currency: Record Currency;
        CheckAmountLCY: Decimal;
    begin
        GenJnlLine.TESTFIELD("Bank Payment Type", GenJnlLine2."Bank Payment Type"::"Computer Check");
        GenJnlLine.TESTFIELD("Check Printed", TRUE);
        GenJnlLine.TESTFIELD("Document No.");

        IF GenJnlLine."Bal. Account No." = '' THEN BEGIN
            GenJnlLine."Check Printed" := FALSE;
            //GenJnlLine.DELETE(TRUE);
        END;

        CheckAmountLCY := GenJnlLine."Amount (LCY)";
        IF GenJnlLine."Currency Code" <> '' THEN
            Currency.GET(GenJnlLine."Currency Code");

        GenJnlLine2.RESET;
        GenJnlLine2.SETCURRENTKEY("Journal Template Name", "Journal Batch Name", "Posting Date", "Document No.");
        GenJnlLine2.SETRANGE("Journal Template Name", GenJnlLine."Journal Template Name");
        GenJnlLine2.SETRANGE("Journal Batch Name", GenJnlLine."Journal Batch Name");
        GenJnlLine2.SETRANGE("Posting Date", GenJnlLine."Posting Date");
        GenJnlLine2.SETRANGE("Document No.", GenJnlLine."Document No.");
        IF GenJnlLine2.FIND('-') THEN
            REPEAT
                IF (GenJnlLine2."Line No." > GenJnlLine."Line No.") AND
                   (CheckAmountLCY = -GenJnlLine2."Amount (LCY)") AND
                   (GenJnlLine2."Currency Code" = '') AND (GenJnlLine."Currency Code" <> '') AND
                   (GenJnlLine2."Account Type" = GenJnlLine2."Account Type"::"G/L Account") AND
                   (GenJnlLine2."Account No." IN
                    [Currency."Conv. LCY Rndg. Debit Acc.", Currency."Conv. LCY Rndg. Credit Acc."]) AND
                   (GenJnlLine2."Bal. Account No." = '') AND NOT GenJnlLine2."Check Printed"
                THEN
                    GenJnlLine2.DELETE // Rounding correction line
                ELSE BEGIN
                    //IF GenJnlLine."Bal. Account No." = '' THEN BEGIN
                    //  IF GenJnlLine2."Account No." = '' THEN BEGIN
                    //    GenJnlLine2."Account Type" := GenJnlLine2."Account Type"::"Bank Account";
                    //    GenJnlLine2."Account No." := GenJnlLine."Account No.";
                    //  END ELSE BEGIN
                    //    GenJnlLine2."Bal. Account Type" := GenJnlLine2."Account Type"::"Bank Account";
                    //    GenJnlLine2."Bal. Account No." := GenJnlLine."Account No.";
                    //  END;
                    //  GenJnlLine2.VALIDATE(Amount);
                    //  GenJnlLine2."Bank Payment Type" := GenJnlLine."Bank Payment Type";
                    //END;
                    GenJnlLine2."Document No." := '';
                    GenJnlLine2."Check Printed" := FALSE;
                    GenJnlLine2.UpdateSource;
                    GenJnlLine2.MODIFY;
                END;
            UNTIL GenJnlLine2.NEXT = 0;

        CheckLedgEntry2.RESET;
        CheckLedgEntry2.SETCURRENTKEY("Bank Account No.", "Entry Status", "Check No.");
        IF GenJnlLine.Amount <= 0 THEN
            CheckLedgEntry2.SETRANGE("Bank Account No.", GenJnlLine."Account No.")
        ELSE
            CheckLedgEntry2.SETRANGE("Bank Account No.", GenJnlLine."Bal. Account No.");
        CheckLedgEntry2.SETRANGE("Entry Status", CheckLedgEntry2."Entry Status"::Printed);
        CheckLedgEntry2.SETRANGE("Check No.", GenJnlLine."Document No.");
        CheckLedgEntry2.FINDFIRST;
        //++TWN1.00.122187.QX
        // CheckLedgEntry2."Original Entry Status" := CheckLedgEntry2."Entry Status";
        CheckLedgEntry2."Original Entry Status" := "Check Ledger Entry Original Entry Status".FromInteger(CheckLedgEntry2."Entry Status".AsInteger());
        //--TWN1.00.122187.QX
        CheckLedgEntry2."Entry Status" := CheckLedgEntry2."Entry Status"::Voided;
        CheckLedgEntry2."Positive Pay Exported" := FALSE;
        CheckLedgEntry2.Open := FALSE;
        CheckLedgEntry2.MODIFY;

        InsertCheckTransEntry(CheckLedgEntry2, GenJnlLine."Currency Code", GenJnlLine."Currency Factor", 9, 0);
    end;

    [Scope('OnPrem')]
    procedure FinancialVoidCheck(var CheckLedgEntry: Record "Check Ledger Entry")
    var
        TransactionBalance: Decimal;
        VATPostingSetup: Record "VAT Posting Setup";
        Currency: Record Currency;
        ConfirmFinVoid: Page "Void Check";
        AmountToVoid: Decimal;
        CheckAmountLCY: Decimal;
        BalanceAmountLCY: Decimal;
        CurrencyRoundingDebitAccount: Code[20];
        CurrencyRoundingCreditAccount: Code[20];
        CheckTransEntry2: Record "Detailed Check Entry";
        PostedDocumentNo: Code[20];
        GLEntry2: Record "G/L Entry";
        CustLedgEntry2: Record "Cust. Ledger Entry";
        CreateEntry: Boolean;
        LastGLEntry: Record "G/L Entry";
        BankCheckAccSetup: Record "Bank Check Acc. Setup";
    begin
        CheckLedgEntry.TESTFIELD("Entry Status", CheckLedgEntry."Entry Status"::Note);
        CheckLedgEntry.TESTFIELD("Bal. Account No.");
        BankAcc.GET(CheckLedgEntry."Bank Account No.");
        BankCheckAccSetup.GET(CheckLedgEntry."Bank Account No.");
        BankCheckAccSetup.TESTFIELD("Note Payable Account");
        BankCheckAccSetup.TESTFIELD("Note Receivable Account");
        SourceCodeSetup.GET;

        //Get Original Factor
        CheckTransEntry2.RESET;
        CheckTransEntry2.SETRANGE("Check Entry No", CheckLedgEntry."Entry No.");
        CheckTransEntry2.FIND('+');
        CheckTransEntry2.TESTFIELD("Entry Status", CheckTransEntry2."Entry Status"::Note);
        BankAcc.TESTFIELD("Currency Code", CheckTransEntry2."Currency Code");

        WITH GLEntry DO BEGIN
            SETCURRENTKEY("Transaction No.");
            SETRANGE("Transaction No.", CheckTransEntry2."Transaction No.");
            SETRANGE("Document No.", CheckTransEntry2."Document No.");
            IF FINDSET THEN BEGIN
                CALCSUMS(Amount);
                TransactionBalance := Amount;
            END ELSE BEGIN
                SETRANGE(Reversed);
                FIND('+');
                MarkCheckEntriesVoid(CheckLedgEntry, CheckTransEntry2."Posting Date");
                InsertCheckTransEntry(CheckLedgEntry,
                                      CheckTransEntry2."Currency Code", CheckTransEntry2."Currency Factor", 1, "Transaction No.");
                EXIT;
            END;
        END;
        IF TransactionBalance <> 0 THEN
            ERROR(Text002);

        CLEAR(ConfirmFinVoid);
        ConfirmFinVoid.SetCheckLedgerEntry(CheckLedgEntry);
        ConfirmFinVoid.LOOKUPMODE(TRUE);
        IF ConfirmFinVoid.RUNMODAL <> ACTION::LookupOK THEN
            EXIT;

        PostedDocumentNo := GetPostedDocumentNo(CheckLedgEntry."Document No.",
                                                GLEntry."No. Series",
                                                ConfirmFinVoid.GetVoidDate);

        GenJnlLine2.INIT;
        GenJnlLine2."System-Created Entry" := TRUE;
        GenJnlLine2."Financial Void" := TRUE;
        GenJnlLine2."Document No." := CheckLedgEntry."Document No.";
        GenJnlLine2."Account Type" := GenJnlLine2."Account Type"::"G/L Account";
        GenJnlLine2."Posting Date" := ConfirmFinVoid.GetVoidDate;
        //Get G/L Entry
        GLEntry2.SETCURRENTKEY("Transaction No.");
        GLEntry2.SETRANGE("Transaction No.", CheckTransEntry2."Transaction No.");
        GLEntry2.SETRANGE("Document No.", CheckTransEntry2."Document No.");
        IF GLEntry2.FIND('-') THEN
            REPEAT
                IF NOT CustLedgEntry2.GET(GLEntry2."Entry No.") THEN BEGIN
                    CreateEntry := FALSE;
                    CASE CheckLedgEntry."Bal. Account Type" OF
                        CheckLedgEntry."Bal. Account Type"::Customer:
                            CreateEntry := GLEntry2."Bal. Account Type" = GLEntry2."Bal. Account Type"::Customer;
                        CheckLedgEntry."Bal. Account Type"::Vendor:
                            CreateEntry := GLEntry2."Bal. Account Type" = GLEntry2."Bal. Account Type"::Vendor;
                    END;

                    IF CreateEntry THEN BEGIN
                        GenJnlLine2.VALIDATE("Account No.", GLEntry2."G/L Account No.");
                        GenJnlLine2.Description := STRSUBSTNO(Text001, CheckLedgEntry."Check No.");
                        GenJnlLine2.VALIDATE(Amount, -GLEntry2.Amount);
                        GenJnlLine2."Source Code" := SourceCodeSetup."Financially Voided Check";
                        GenJnlLine2."Shortcut Dimension 1 Code" := GLEntry2."Global Dimension 1 Code";
                        GenJnlLine2."Shortcut Dimension 2 Code" := GLEntry2."Global Dimension 2 Code";
                        GenJnlLine2."Posting No. Series" := GLEntry2."No. Series";
                        GenJnlLine2."Allow Zero-Amount Posting" := TRUE;
                        GenJnlPostLine.RunWithCheck(GenJnlLine2);
                    END;
                END;
            UNTIL GLEntry2.NEXT = 0;

        GenJnlLine2.INIT;
        GenJnlLine2."System-Created Entry" := TRUE;
        GenJnlLine2."Financial Void" := TRUE;
        GenJnlLine2."Document No." := PostedDocumentNo;
        GenJnlLine2."External Document No." := CheckLedgEntry."External Document No.";
        GenJnlLine2."Account Type" := CheckLedgEntry."Bal. Account Type";
        GenJnlLine2."Posting Date" := ConfirmFinVoid.GetVoidDate;
        GenJnlLine2.VALIDATE("Account No.", CheckLedgEntry."Bal. Account No.");
        GenJnlLine2.VALIDATE("Currency Code", BankAcc."Currency Code");
        GenJnlLine2.VALIDATE("Currency Factor", CheckTransEntry2."Currency Factor");
        GenJnlLine2.Description := STRSUBSTNO(Text001, CheckLedgEntry."Check No.");
        GenJnlLine2."Source Code" := SourceCodeSetup."Financially Voided Check";
        GenJnlLine2."Posting No. Series" := GLEntry2."No. Series";
        GenJnlLine2."Allow Zero-Amount Posting" := TRUE;
        CASE CheckLedgEntry."Bal. Account Type" OF
            CheckLedgEntry."Bal. Account Type"::"G/L Account":
                WITH GLEntry DO BEGIN
                    SETCURRENTKEY("Transaction No.");
                    SETRANGE("Transaction No.", CheckTransEntry2."Transaction No.");
                    SETRANGE("Document No.", CheckTransEntry2."Document No.");
                    SETRANGE("Posting Date", CheckTransEntry2."Posting Date");
                    SETFILTER("Entry No.", '<>%1', GLEntry2."Entry No.");
                    SETRANGE("G/L Account No.", CheckLedgEntry."Bal. Account No.");
                    IF FINDSET THEN
                        REPEAT
                            GenJnlLine2.VALIDATE("Account No.", "G/L Account No.");
                            GenJnlLine2.Description := STRSUBSTNO(Text001, CheckLedgEntry."Check No.");
                            GenJnlLine2.VALIDATE(Amount, -Amount - "VAT Amount");
                            BalanceAmountLCY := BalanceAmountLCY + GenJnlLine2."Amount (LCY)";
                            GenJnlLine2."Shortcut Dimension 1 Code" := "Global Dimension 1 Code";
                            GenJnlLine2."Shortcut Dimension 2 Code" := "Global Dimension 2 Code";
                            GenJnlLine2."Dimension Set ID" := "Dimension Set ID";
                            GenJnlLine2."Gen. Posting Type" := "Gen. Posting Type";
                            GenJnlLine2."Gen. Bus. Posting Group" := "Gen. Bus. Posting Group";
                            GenJnlLine2."Gen. Prod. Posting Group" := "Gen. Prod. Posting Group";
                            GenJnlLine2."VAT Bus. Posting Group" := "VAT Bus. Posting Group";
                            GenJnlLine2."VAT Prod. Posting Group" := "VAT Prod. Posting Group";
                            IF VATPostingSetup.GET("VAT Bus. Posting Group", "VAT Prod. Posting Group") THEN
                                GenJnlLine2."VAT Calculation Type" := VATPostingSetup."VAT Calculation Type";
                            GenJnlPostLine.RunWithCheck(GenJnlLine2);
                        UNTIL NEXT = 0;
                END;
            CheckLedgEntry."Bal. Account Type"::Customer:
                BEGIN
                    IF ConfirmFinVoid.GetVoidType = 0 THEN BEGIN    // Unapply entry
                        IF UnApplyCustInvoices(CheckLedgEntry, ConfirmFinVoid.GetVoidDate, 0, PostedDocumentNo) THEN
                            GenJnlLine2."Applies-to ID" := CheckLedgEntry."Document No.";
                    END;
                    WITH CustLedgEntry DO BEGIN
                        SETCURRENTKEY("Transaction No.");
                        SETRANGE("Transaction No.", CheckTransEntry2."Transaction No.");
                        SETRANGE("Document No.", CheckTransEntry2."Document No.");
                        SETRANGE("Posting Date", CheckTransEntry2."Posting Date");
                        IF FINDSET THEN
                            REPEAT
                                CALCFIELDS("Original Amount");
                                GenJnlLine2.VALIDATE(Amount, -"Original Amount");
                                GenJnlLine2.VALIDATE("Currency Code", "Currency Code");
                                BalanceAmountLCY := BalanceAmountLCY + GenJnlLine2."Amount (LCY)";
                                MakeAppliesID(GenJnlLine2."Applies-to ID", CheckLedgEntry."Document No.");
                                GenJnlLine2."Shortcut Dimension 1 Code" := "Global Dimension 1 Code";
                                GenJnlLine2."Shortcut Dimension 2 Code" := "Global Dimension 2 Code";
                                GenJnlLine2."Dimension Set ID" := "Dimension Set ID";
                                GenJnlLine2."Source Currency Code" := "Currency Code";
                                GenJnlPostLine.RunWithCheck(GenJnlLine2);
                            UNTIL NEXT = 0;
                    END;
                END;
            CheckLedgEntry."Bal. Account Type"::Vendor:
                BEGIN
                    IF ConfirmFinVoid.GetVoidType = 0 THEN BEGIN    // Unapply entry
                        IF UnApplyVendInvoices(CheckLedgEntry, ConfirmFinVoid.GetVoidDate, 0, PostedDocumentNo) THEN
                            GenJnlLine2."Applies-to ID" := CheckLedgEntry."Document No.";
                    END;
                    WITH VendorLedgEntry DO BEGIN
                        SETCURRENTKEY("Transaction No.");
                        SETRANGE("Transaction No.", CheckTransEntry2."Transaction No.");
                        SETRANGE("Document No.", CheckTransEntry2."Document No.");
                        SETRANGE("Posting Date", CheckTransEntry2."Posting Date");
                        IF FINDSET THEN
                            REPEAT
                                CALCFIELDS("Original Amount");
                                GenJnlLine2.VALIDATE(Amount, -"Original Amount");
                                GenJnlLine2.VALIDATE("Currency Code", "Currency Code");
                                BalanceAmountLCY := BalanceAmountLCY + GenJnlLine2."Amount (LCY)";
                                MakeAppliesID(GenJnlLine2."Applies-to ID", CheckLedgEntry."Document No.");
                                GenJnlLine2."Shortcut Dimension 1 Code" := "Global Dimension 1 Code";
                                GenJnlLine2."Shortcut Dimension 2 Code" := "Global Dimension 2 Code";
                                GenJnlLine2."Dimension Set ID" := "Dimension Set ID";
                                GenJnlLine2."Source Currency Code" := "Currency Code";
                                GenJnlPostLine.RunWithCheck(GenJnlLine2);
                            UNTIL NEXT = 0;
                    END;
                END;
            CheckLedgEntry."Bal. Account Type"::"Bank Account":
                WITH BankAccLedgEntry3 DO BEGIN
                    SETCURRENTKEY("Transaction No.");
                    SETRANGE("Transaction No.", CheckTransEntry2."Transaction No.");
                    SETRANGE("Document No.", CheckTransEntry2."Document No.");
                    SETRANGE("Posting Date", CheckTransEntry2."Posting Date");
                    SETFILTER("Entry No.", '<>%1', GLEntry2."Entry No.");
                    IF FINDSET THEN
                        REPEAT
                            GenJnlLine2.VALIDATE(Amount, -Amount);
                            BalanceAmountLCY := BalanceAmountLCY + GenJnlLine2."Amount (LCY)";
                            GenJnlLine2."Shortcut Dimension 1 Code" := "Global Dimension 1 Code";
                            GenJnlLine2."Shortcut Dimension 2 Code" := "Global Dimension 2 Code";
                            GenJnlLine2."Dimension Set ID" := "Dimension Set ID";
                            GenJnlPostLine.RunWithCheck(GenJnlLine2);
                        UNTIL NEXT = 0;
                END;
            CheckLedgEntry."Bal. Account Type"::"Fixed Asset":
                WITH FALedgEntry DO BEGIN
                    SETCURRENTKEY("Transaction No.");
                    SETRANGE("Transaction No.", CheckTransEntry2."Transaction No.");
                    SETRANGE("Document No.", CheckTransEntry2."Document No.");
                    SETRANGE("Posting Date", CheckTransEntry2."Posting Date");
                    IF FINDSET THEN
                        REPEAT
                            GenJnlLine2.VALIDATE(Amount, -Amount);
                            BalanceAmountLCY := BalanceAmountLCY + GenJnlLine2."Amount (LCY)";
                            GenJnlLine2."Shortcut Dimension 1 Code" := "Global Dimension 1 Code";
                            GenJnlLine2."Shortcut Dimension 2 Code" := "Global Dimension 2 Code";
                            GenJnlLine2."Dimension Set ID" := "Dimension Set ID";
                            GenJnlPostLine.RunWithCheck(GenJnlLine2);
                        UNTIL NEXT = 0;
                END;
            ELSE BEGIN
                    GenJnlLine2."Bal. Account Type" := CheckLedgEntry."Bal. Account Type";
                    GenJnlLine2.VALIDATE("Bal. Account No.", CheckLedgEntry."Bal. Account No.");
                    GenJnlLine2."Shortcut Dimension 1 Code" := '';
                    GenJnlLine2."Shortcut Dimension 2 Code" := '';
                    GenJnlLine2."Dimension Set ID" := 0;
                    GenJnlPostLine.RunWithoutCheck(GenJnlLine2);
                END;
        END;

        //Get Posted Document No.
        LastGLEntry.LOCKTABLE;
        LastGLEntry.RESET;
        LastGLEntry.FIND('+');

        MarkCheckEntriesVoid(CheckLedgEntry, ConfirmFinVoid.GetVoidDate);
        InsertCheckTransEntry(CheckLedgEntry,
                              GenJnlLine2."Currency Code", GenJnlLine2."Currency Factor",
                              ConfirmFinVoid.GetVoidSubType, LastGLEntry."Transaction No.");
        COMMIT;
        UpdateAnalysisView.UpdateAll(0, TRUE);
    end;

    [Scope('OnPrem')]
    procedure FinancialCashVoidCheck(var CheckLedgEntry: Record "Check Ledger Entry")
    var
        TransactionBalance: Decimal;
        Currency: Record Currency;
        BankAccSetup: Record "Bank Account Posting Group";
        BankCheckAccSetup: Record "Bank Check Acc. Setup";
        ConfirmFinVoid: Page "Void Check";
        AmountToVoid: Decimal;
        AmountToVoidLCY: Decimal;
        CheckAmountLCY: Decimal;
        BalanceAmountLCY: Decimal;
        CheckTransEntry2: Record "Detailed Check Entry";
        LastGLEntry: Record "G/L Entry";
        CheckGLEntry: Record "G/L Entry";
        PostedDocumentNo: Code[20];
    begin
        CheckLedgEntry.TESTFIELD("Entry Status", CheckLedgEntry."Entry Status"::Posted);
        CheckLedgEntry.TESTFIELD("Bal. Account No.");
        BankAcc.GET(CheckLedgEntry."Bank Account No.");
        BankAccSetup.GET(BankAcc."Bank Acc. Posting Group");
        BankAccSetup.TESTFIELD("G/L Bank Account No.");
        BankAccLedgEntry2.GET(CheckLedgEntry."Bank Account Ledger Entry No.");
        BankCheckAccSetup.GET(CheckLedgEntry."Bank Account No.");
        BankCheckAccSetup.TESTFIELD("Note Payable Account");
        BankCheckAccSetup.TESTFIELD("Note Receivable Account");
        SourceCodeSetup.GET;

        //Get Original Factor
        CheckTransEntry2.RESET;
        CheckTransEntry2.SETRANGE("Check Entry No", CheckLedgEntry."Entry No.");
        CheckTransEntry2.FIND('+');

        WITH GLEntry DO BEGIN
            SETCURRENTKEY("Transaction No.");
            SETRANGE("Transaction No.", BankAccLedgEntry2."Transaction No.");
            SETRANGE("Document No.", BankAccLedgEntry2."Document No.");
            SETRANGE(Reversed, FALSE);
            IF FINDSET THEN
                REPEAT
                    TransactionBalance := TransactionBalance + Amount;
                UNTIL NEXT = 0
            ELSE BEGIN
                SETRANGE(Reversed);
                FIND('+');

                MarkCashCheckEntriesVoid(CheckLedgEntry, CheckTransEntry2."Posting Date");
                InsCashCheckVoidTransEntry(CheckLedgEntry, CheckTransEntry2."Currency Code",
                                           CheckTransEntry2."Currency Factor", "Transaction No.");
                EXIT;
            END;
        END;
        IF TransactionBalance <> 0 THEN
            ERROR(Text002);

        CLEAR(ConfirmFinVoid);
        ConfirmFinVoid.SetCheckLedgerEntry(CheckLedgEntry);
        ConfirmFinVoid.LOOKUPMODE(TRUE);
        IF ConfirmFinVoid.RUNMODAL <> ACTION::LookupOK THEN
            EXIT;

        AmountToVoid := 0;
        WITH CheckLedgEntry2 DO BEGIN
            RESET;
            SETCURRENTKEY("Bank Account No.", "Entry Status", "Check No.");
            SETRANGE("Bank Account No.", CheckLedgEntry."Bank Account No.");
            SETRANGE("Entry Status", CheckLedgEntry."Entry Status"::Posted);
            SETRANGE("Check No.", CheckLedgEntry."Check No.");
            SETRANGE("Check Date", CheckLedgEntry."Check Date");
            IF FINDSET THEN
                REPEAT
                    AmountToVoid := AmountToVoid + Amount;
                UNTIL NEXT = 0;
        END;

        AmountToVoidLCY := 0;
        CheckGLEntry.RESET;
        CheckGLEntry.SETCURRENTKEY("Transaction No.");
        CheckGLEntry.SETRANGE("Transaction No.", CheckTransEntry2."Transaction No.");
        CheckGLEntry.SETRANGE("Document No.", CheckTransEntry2."Document No.");
        CheckGLEntry.SETFILTER("G/L Account No.", '<>%1', BankAccSetup."G/L Bank Account No.");
        IF NOT CheckGLEntry.FIND('-') THEN EXIT;

        PostedDocumentNo := GetPostedDocumentNo(CheckLedgEntry."Document No.",
                                                CheckGLEntry."No. Series",
                                                ConfirmFinVoid.GetVoidDate);

        GenJnlLine2.INIT;
        GenJnlLine2."System-Created Entry" := TRUE;
        GenJnlLine2."Document No." := PostedDocumentNo;
        GenJnlLine2."External Document No." := CheckLedgEntry."External Document No.";
        GenJnlLine2."Account Type" := GenJnlLine2."Account Type"::"G/L Account";
        GenJnlLine2."Posting Date" := ConfirmFinVoid.GetVoidDate;
        GenJnlLine2."Source Code" := CheckGLEntry."Source Code";
        GenJnlLine2."Shortcut Dimension 1 Code" := CheckGLEntry."Global Dimension 1 Code";
        GenJnlLine2."Shortcut Dimension 2 Code" := CheckGLEntry."Global Dimension 2 Code";
        GenJnlLine2."Posting No. Series" := CheckGLEntry."No. Series";
        GenJnlLine2."Allow Zero-Amount Posting" := TRUE;
        WITH CheckGLEntry DO BEGIN
            REPEAT
                GenJnlLine2.VALIDATE("Account No.", "G/L Account No.");
                GenJnlLine2.Description := STRSUBSTNO(Text009, CheckLedgEntry."Check No.");
                GenJnlLine2.VALIDATE(Amount, -Amount);
                AmountToVoidLCY += Amount;
                GenJnlLine2."Dimension Set ID" := "Dimension Set ID";
                GenJnlPostLine.RunWithCheck(GenJnlLine2);
            UNTIL CheckGLEntry.NEXT = 0;
        END;

        BankAccLedgEntry2.GET(CheckLedgEntry."Bank Account Ledger Entry No.");
        BankAccLedgEntry2.Open := FALSE;
        BankAccLedgEntry2."Remaining Amount" := 0;
        BankAccLedgEntry2."Statement Status" := BankAccLedgEntry2."Statement Status"::Closed;
        BankAccLedgEntry2.MODIFY;

        GenJnlLine2.INIT;
        GenJnlLine2."System-Created Entry" := TRUE;
        GenJnlLine2."Financial Void" := TRUE;
        GenJnlLine2."Document No." := PostedDocumentNo;
        GenJnlLine2."External Document No." := CheckLedgEntry."External Document No.";
        GenJnlLine2."Account Type" := GenJnlLine2."Account Type"::"Bank Account";
        GenJnlLine2."Posting Date" := ConfirmFinVoid.GetVoidDate;
        GenJnlLine2.VALIDATE("Account No.", BankAcc."No.");
        GenJnlLine2.Description := STRSUBSTNO(Text009, CheckLedgEntry."Check No.");
        GenJnlLine2.VALIDATE("Currency Code", CheckTransEntry2."Currency Code");
        GenJnlLine2.VALIDATE(Amount, AmountToVoid);
        GenJnlLine2.VALIDATE("Currency Factor", CheckTransEntry2."Currency Factor");
        GenJnlLine2.VALIDATE("Amount (LCY)", AmountToVoidLCY);
        GenJnlLine2."Source Code" := SourceCodeSetup."Financially Voided Check";
        GenJnlLine2."Shortcut Dimension 1 Code" := BankAccLedgEntry2."Global Dimension 1 Code";
        GenJnlLine2."Shortcut Dimension 2 Code" := BankAccLedgEntry2."Global Dimension 2 Code";
        GenJnlLine2."Posting No. Series" := CheckGLEntry."No. Series";
        GenJnlLine2."Allow Zero-Amount Posting" := TRUE;
        GenJnlLine2."Dimension Set ID" := BankAccLedgEntry2."Dimension Set ID";
        GenJnlPostLine.RunWithCheck(GenJnlLine2);

        // Mark newly posted entry as cleared for bank reconciliation purposes.
        BankAccLedgEntry3.RESET;
        BankAccLedgEntry3.FINDLAST;
        BankAccLedgEntry3.Open := FALSE;
        BankAccLedgEntry3."Remaining Amount" := 0;
        BankAccLedgEntry3."Statement Status" := BankAccLedgEntry3."Statement Status"::Closed;
        BankAccLedgEntry3.MODIFY;

        //Get Posted Document No.
        LastGLEntry.LOCKTABLE;
        LastGLEntry.RESET;
        LastGLEntry.FIND('+');

        MarkCashCheckEntriesVoid(CheckLedgEntry, ConfirmFinVoid.GetVoidDate);
        InsCashCheckVoidTransEntry(CheckLedgEntry,
                                   GenJnlLine2."Currency Code", GenJnlLine2."Currency Factor", LastGLEntry."Transaction No.");
        COMMIT;
        UpdateAnalysisView.UpdateAll(0, TRUE);
    end;

    local procedure UnApplyVendInvoices(var CheckLedgEntry: Record "Check Ledger Entry"; VoidDate: Date; VoidFrom: Option Posted,Cash; UnApplyDocNo: Code[20]): Boolean
    var
        BankAccLedgEntry: Record "Bank Account Ledger Entry";
        OrigPaymentVendLedgEntry: Record "Vendor Ledger Entry";
        PaymentDetVendLedgEntry: Record "Detailed Vendor Ledg. Entry";
        GenJnlLine3: Record "Gen. Journal Line";
        AppliesID: Code[50];
        CheckTransEntry2: Record "Detailed Check Entry";
    begin
        CASE VoidFrom OF
            VoidFrom::Cash:
                BEGIN
                    // first, find first original payment line, if any
                    BankAccLedgEntry.GET(CheckLedgEntry."Bank Account Ledger Entry No.");
                    IF CheckLedgEntry."Bal. Account Type" = CheckLedgEntry."Bal. Account Type"::Vendor THEN BEGIN
                        WITH OrigPaymentVendLedgEntry DO BEGIN
                            SETCURRENTKEY("Transaction No.");
                            SETRANGE("Transaction No.", BankAccLedgEntry."Transaction No.");
                            SETRANGE("Document No.", BankAccLedgEntry."Document No.");
                            SETRANGE("Posting Date", BankAccLedgEntry."Posting Date");
                            IF NOT FINDFIRST THEN
                                EXIT(FALSE);
                        END;
                    END ELSE
                        EXIT(FALSE);
                END;
            VoidFrom::Posted:
                BEGIN
                    // first, find first original payment line, if any
                    CheckTransEntry2.SETRANGE("Check Entry No", CheckLedgEntry."Entry No.");
                    CheckTransEntry2.FIND('+');
                    CheckTransEntry2.TESTFIELD("Entry Status", CheckTransEntry2."Entry Status"::Note);
                    IF CheckLedgEntry."Bal. Account Type" = CheckLedgEntry."Bal. Account Type"::Vendor THEN BEGIN
                        WITH OrigPaymentVendLedgEntry DO BEGIN
                            SETCURRENTKEY("Transaction No.");
                            SETRANGE("Transaction No.", CheckTransEntry2."Transaction No.");
                            SETRANGE("Document No.", CheckTransEntry2."Document No.");
                            SETRANGE("Posting Date", CheckTransEntry2."Posting Date");
                            IF NOT FINDFIRST THEN
                                EXIT(FALSE);
                        END;
                    END ELSE
                        EXIT(FALSE);
                END;
        END;
        AppliesID := CheckLedgEntry."Document No.";

        PaymentDetVendLedgEntry.SETCURRENTKEY("Vendor Ledger Entry No.", "Entry Type", "Posting Date");
        PaymentDetVendLedgEntry.SETRANGE("Vendor Ledger Entry No.", OrigPaymentVendLedgEntry."Entry No.");
        PaymentDetVendLedgEntry.SETRANGE("Entry Type", PaymentDetVendLedgEntry."Entry Type"::Application);
        IF PaymentDetVendLedgEntry.FINDFIRST THEN BEGIN
            //GenJnlLine3."Document No." := OrigPaymentVendLedgEntry."Document No.";
            GenJnlLine3."Document No." := UnApplyDocNo;
            GenJnlLine3."External Document No." := CheckLedgEntry."External Document No.";
            GenJnlLine3."Posting Date" := VoidDate;
            GenJnlLine3."Account Type" := GenJnlLine3."Account Type"::Vendor;
            GenJnlLine3."Account No." := OrigPaymentVendLedgEntry."Vendor No.";
            GenJnlLine3.Correction := TRUE;
            GenJnlLine3.Description := STRSUBSTNO(Text001, CheckLedgEntry."Check No.");
            ;
            GenJnlLine3."Shortcut Dimension 1 Code" := OrigPaymentVendLedgEntry."Global Dimension 1 Code";
            GenJnlLine3."Shortcut Dimension 2 Code" := OrigPaymentVendLedgEntry."Global Dimension 2 Code";
            GenJnlLine3."Posting Group" := OrigPaymentVendLedgEntry."Vendor Posting Group";
            GenJnlLine3."Source Type" := GenJnlLine3."Source Type"::Vendor;
            GenJnlLine3."Source No." := OrigPaymentVendLedgEntry."Vendor No.";
            GenJnlLine3."Source Code" := SourceCodeSetup."Financially Voided Check";
            GenJnlLine3."System-Created Entry" := TRUE;
            GenJnlLine3."Financial Void" := TRUE;
            GenJnlPostLine.UnapplyVendLedgEntry(GenJnlLine3, PaymentDetVendLedgEntry);
        END;

        WITH OrigPaymentVendLedgEntry DO BEGIN
            FINDSET(TRUE, FALSE);  // re-get the now-modified payment entry.
            REPEAT                // set up to be applied by upcoming voiding entry.
                MakeAppliesID(AppliesID, CheckLedgEntry."Document No.");
                "Applies-to ID" := AppliesID;
                CALCFIELDS("Remaining Amount");
                "Amount to Apply" := "Remaining Amount";
                "Accepted Pmt. Disc. Tolerance" := FALSE;
                "Accepted Payment Tolerance" := 0;
                MODIFY;
            UNTIL NEXT = 0;
        END;
        EXIT(TRUE);
    end;

    local procedure UnApplyCustInvoices(var CheckLedgEntry: Record "Check Ledger Entry"; VoidDate: Date; VoidFrom: Option Posted,Cash; UnApplyDocNo: Code[20]): Boolean
    var
        BankAccLedgEntry: Record "Bank Account Ledger Entry";
        OrigPaymentCustLedgEntry: Record "Cust. Ledger Entry";
        PaymentDetCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
        GenJnlLine3: Record "Gen. Journal Line";
        AppliesID: Code[50];
        CheckTransEntry2: Record "Detailed Check Entry";
    begin

        CASE VoidFrom OF
            VoidFrom::Cash:
                BEGIN
                    // first, find first original payment line, if any
                    BankAccLedgEntry.GET(CheckLedgEntry."Bank Account Ledger Entry No.");
                    IF CheckLedgEntry."Bal. Account Type" = CheckLedgEntry."Bal. Account Type"::Customer THEN BEGIN
                        WITH OrigPaymentCustLedgEntry DO BEGIN
                            SETCURRENTKEY("Transaction No.");
                            SETRANGE("Transaction No.", BankAccLedgEntry."Transaction No.");
                            SETRANGE("Document No.", BankAccLedgEntry."Document No.");
                            SETRANGE("Posting Date", BankAccLedgEntry."Posting Date");
                            IF NOT FINDFIRST THEN
                                EXIT(FALSE);
                        END;
                    END ELSE
                        EXIT(FALSE);
                END;
            VoidFrom::Posted:
                BEGIN
                    // first, find first original payment line, if any
                    CheckTransEntry2.SETRANGE("Check Entry No", CheckLedgEntry."Entry No.");
                    CheckTransEntry2.FIND('+');
                    CheckTransEntry2.TESTFIELD("Entry Status", CheckTransEntry2."Entry Status"::Note);
                    IF CheckLedgEntry."Bal. Account Type" = CheckLedgEntry."Bal. Account Type"::Customer THEN BEGIN
                        WITH OrigPaymentCustLedgEntry DO BEGIN
                            SETCURRENTKEY("Transaction No.");
                            SETRANGE("Transaction No.", CheckTransEntry2."Transaction No.");
                            SETRANGE("Document No.", CheckTransEntry2."Document No.");
                            SETRANGE("Posting Date", CheckTransEntry2."Posting Date");
                            IF NOT FINDFIRST THEN
                                EXIT(FALSE);
                        END;
                    END ELSE
                        EXIT(FALSE);
                END;
        END;
        AppliesID := CheckLedgEntry."Document No.";

        PaymentDetCustLedgEntry.SETCURRENTKEY("Cust. Ledger Entry No.", "Entry Type", "Posting Date");
        PaymentDetCustLedgEntry.SETRANGE("Cust. Ledger Entry No.", OrigPaymentCustLedgEntry."Entry No.");
        PaymentDetCustLedgEntry.SETRANGE("Entry Type", PaymentDetCustLedgEntry."Entry Type"::Application);
        IF PaymentDetCustLedgEntry.FINDFIRST THEN BEGIN
            //GenJnlLine3."Document No." := OrigPaymentCustLedgEntry."Document No.";
            GenJnlLine3."Document No." := UnApplyDocNo;
            GenJnlLine3."External Document No." := CheckLedgEntry."External Document No.";
            GenJnlLine3."Posting Date" := VoidDate;
            GenJnlLine3."Account Type" := GenJnlLine3."Account Type"::Customer;
            GenJnlLine3."Account No." := OrigPaymentCustLedgEntry."Customer No.";
            GenJnlLine3.Correction := TRUE;
            GenJnlLine3.Description := STRSUBSTNO(Text001, CheckLedgEntry."Check No.");
            ;
            GenJnlLine3."Shortcut Dimension 1 Code" := OrigPaymentCustLedgEntry."Global Dimension 1 Code";
            GenJnlLine3."Shortcut Dimension 2 Code" := OrigPaymentCustLedgEntry."Global Dimension 2 Code";
            GenJnlLine3."Posting Group" := OrigPaymentCustLedgEntry."Customer Posting Group";
            GenJnlLine3."Source Type" := GenJnlLine3."Source Type"::Customer;
            GenJnlLine3."Source No." := OrigPaymentCustLedgEntry."Customer No.";
            GenJnlLine3."Source Code" := SourceCodeSetup."Financially Voided Check";
            GenJnlLine3."System-Created Entry" := TRUE;
            GenJnlLine3."Financial Void" := TRUE;
            GenJnlPostLine.UnapplyCustLedgEntry(GenJnlLine3, PaymentDetCustLedgEntry);
        END;

        WITH OrigPaymentCustLedgEntry DO BEGIN
            FINDSET(TRUE, FALSE);  // re-get the now-modified payment entry.
            REPEAT                // set up to be applied by upcoming voiding entry.
                MakeAppliesID(AppliesID, CheckLedgEntry."Document No.");
                "Applies-to ID" := AppliesID;
                CALCFIELDS("Remaining Amount");
                "Amount to Apply" := "Remaining Amount";
                "Accepted Pmt. Disc. Tolerance" := FALSE;
                "Accepted Payment Tolerance" := 0;
                MODIFY;
            UNTIL NEXT = 0;
        END;
        EXIT(TRUE);
    end;

    local procedure MarkCheckEntriesVoid(var OriginalCheckEntry: Record "Check Ledger Entry"; VoidDate: Date)
    var
        RelatedCheckEntry: Record "Check Ledger Entry";
        RelatedCheckEntry2: Record "Check Ledger Entry";
    begin
        WITH RelatedCheckEntry DO BEGIN
            RESET;
            SETCURRENTKEY("Bank Account No.", "Entry Status", "Check No.");
            SETRANGE("Bank Account No.", OriginalCheckEntry."Bank Account No.");
            SETRANGE("Entry Status", OriginalCheckEntry."Entry Status"::Posted);
            SETRANGE("Statement Status", OriginalCheckEntry."Statement Status"::Open);
            SETRANGE("Check No.", OriginalCheckEntry."Check No.");
            SETRANGE("Check Date", OriginalCheckEntry."Check Date");
            SETFILTER("Entry No.", '<>%1', OriginalCheckEntry."Entry No.");
            IF FINDSET THEN
                REPEAT
                    RelatedCheckEntry2 := RelatedCheckEntry;
                    //++TWN1.00.122187.QX
                    // RelatedCheckEntry2."Original Entry Status" := "Entry Status";
                    RelatedCheckEntry2."Original Entry Status" := "Check Ledger Entry Original Entry Status".FromInteger("Entry Status".AsInteger());
                    //--TWN1.00.122187.QX
                    RelatedCheckEntry2."Entry Status" := "Entry Status"::"Financially Voided";
                    RelatedCheckEntry2."Positive Pay Exported" := FALSE;
                    IF VoidDate = OriginalCheckEntry."Check Date" THEN BEGIN
                        RelatedCheckEntry2.Open := FALSE;
                        //RelatedCheckEntry2."Statement Status" := RelatedCheckEntry2."Statement Status"::Closed;
                    END;
                    RelatedCheckEntry2.MODIFY;
                UNTIL NEXT = 0;
        END;

        WITH OriginalCheckEntry DO BEGIN
            //++TWN1.00.122187.QX
            // "Original Entry Status" := "Entry Status";
            "Original Entry Status" := "Check Ledger Entry Original Entry Status".FromInteger("Entry Status".AsInteger());
            //--TWN1.00.122187.QX
            "Entry Status" := "Entry Status"::"Financially Voided";
            "Positive Pay Exported" := FALSE;
            //IF VoidDate = "Check Date" THEN BEGIN
            Open := FALSE;
            //END;
            MODIFY;
        END;
    end;

    local procedure MakeAppliesID(var AppliesID: Code[50]; CheckDocNo: Code[20])
    begin
        IF AppliesID = '' THEN
            EXIT;
        IF AppliesID = CheckDocNo THEN
            AppliesIDCounter := 0;
        AppliesIDCounter := AppliesIDCounter + 1;
        AppliesID :=
          COPYSTR(FORMAT(AppliesIDCounter) + CheckDocNo, 1, MAXSTRLEN(AppliesID));
    end;

    [Scope('OnPrem')]
    procedure CheckJnlLine(var GenJnlLineSource: Record "Gen. Journal Line")
    var
        GenJnlLine4: Record "Gen. Journal Line";
        BankAccNo: Code[20];
        BankCheckAccSetup: Record "Bank Check Acc. Setup";
    begin
        GenJnlLine4.COPY(GenJnlLineSource);
        WITH GenJnlLine4 DO BEGIN
            IF FIND('-') THEN
                REPEAT
                    IF "Bank Payment Type" = "Bank Payment Type"::"Computer Check" THEN
                        TESTFIELD("Check Printed", TRUE);

                    IF (("Account Type" = "Account Type"::"Bank Account") AND ("Account No." <> '')) OR
                       (("Bal. Account Type" = "Account Type"::"Bank Account") AND ("Bal. Account No." <> '')) THEN BEGIN
                        TESTFIELD("Due Date");

                        IF "Due Date" < "Posting Date" THEN BEGIN
                            ERROR(Text011);
                        END;

                        IF ("Bal. Account Type" = "Bal. Account Type"::"Bank Account") AND ("Bal. Account No." <> '') THEN
                            BankAccNo := "Bal. Account No.";
                        IF ("Account Type" = "Account Type"::"Bank Account") AND ("Account No." <> '') THEN
                            BankAccNo := "Account No.";

                        IF BankAccNo <> BankAcc."No." THEN
                            BankAcc.GET(BankAccNo);
                        IF BankAcc."Currency Code" <> "Currency Code" THEN
                            FIELDERROR(
                              "Bank Payment Type",
                              STRSUBSTNO(
                                Text004,
                                FIELDCAPTION("Currency Code"), TABLECAPTION, BankAcc.TABLECAPTION));

                        BankCheckAccSetup.GET(BankAccNo);

                        IF GenJnlLine4."Bank Payment Type" <> 1 THEN BEGIN
                            CheckLedgEntry2.RESET;
                            CheckLedgEntry2.SETCURRENTKEY("Bank Account No.", "Entry Status", "Check No.");
                            CheckLedgEntry2.SETRANGE("Bank Account No.", BankAccNo);
                            CheckLedgEntry2.SETFILTER(
                              "Entry Status", '%1|%2|%3',
                              CheckLedgEntry2."Entry Status"::Printed,
                              CheckLedgEntry2."Entry Status"::Posted,
                              CheckLedgEntry2."Entry Status"::"Financially Voided");
                            CheckLedgEntry2.SETRANGE("Check No.", "Document No.");
                            IF CheckLedgEntry2.FIND('-') THEN
                                ERROR(Text000, "Document No.", BankAcc.TABLECAPTION);
                        END;
                    END;
                UNTIL NEXT = 0;
        END;
    end;

    [Scope('OnPrem')]
    procedure PostCheckJnlLine(var GenJnlLineSource: Record "Gen. Journal Line"; PostPrint: Boolean; CheckType: Option NP,NR; xNoteType: Code[10])
    var
        GenJnlLine4: Record "Gen. Journal Line";
        BankCheckAccSetup: Record "Bank Check Acc. Setup";
        //++TWN1.00.122187.QX
        // JnlLineDim: Record "356";
        //--TWN1.00.122187.QX
        GLRegister: Record "G/L Register";
        RegisterFrom: Integer;
        RegisterTo: Integer;
        TransactionNo: Integer;
    begin
        GenJnlLine4.COPY(GenJnlLineSource);
        CheckJnlLine(GenJnlLine4);
        BankCheckType := CheckType;
        GenJnlBankLinebuf.DELETEALL;
        CLEAR(GenJnlBankLinebuf);

        WITH GenJnlLine4 DO BEGIN
            IF FIND('-') THEN
                REPEAT
                    IF (GenJnlLine4."Account Type" = GenJnlLine4."Account Type"::"G/L Account") AND
                       (GenJnlLine4."Bal. Account No." = '') THEN BEGIN
                        CASE CheckType OF
                            CheckType::NP:
                                GenJnlLine4.VALIDATE("Bal. Account Type", GenJnlLine4."Bal. Account Type"::Vendor);
                            CheckType::NR:
                                GenJnlLine4.VALIDATE("Bal. Account Type", GenJnlLine4."Bal. Account Type"::Customer);
                        END;
                    END;

                    IF (GenJnlLine4."Account Type" = GenJnlLine4."Account Type"::"Bank Account") AND
                       (GenJnlLine4."Account No." <> '') THEN BEGIN
                        IF (GenJnlLine4."Bank Payment Type" <> 1) OR
                           (((GenJnlLine4."Bank Payment Type" = 1) AND GenJnlLine4."Check Printed")) THEN BEGIN
                            InsetGenJnlBankLinebuf(GenJnlLine4);
                            BankCheckAccSetup.GET(GenJnlLine4."Account No.");
                            GenJnlLine4.VALIDATE("Account Type", GenJnlLine4."Account Type"::"G/L Account");
                            CASE CheckType OF
                                CheckType::NP:
                                    BEGIN
                                        BankCheckAccSetup.TESTFIELD("Note Payable Account");
                                        GenJnlLine4.VALIDATE("Account No.", BankCheckAccSetup."Note Payable Account");
                                        IF GenJnlLine4."Bal. Account No." = '' THEN
                                            GenJnlLine4.VALIDATE("Bal. Account Type", GenJnlLine4."Bal. Account Type"::Vendor);
                                    END;
                                CheckType::NR:
                                    BEGIN
                                        BankCheckAccSetup.TESTFIELD("Note Receivable Account");
                                        GenJnlLine4.VALIDATE("Account No.", BankCheckAccSetup."Note Receivable Account");
                                        IF GenJnlLine4."Bal. Account No." = '' THEN
                                            GenJnlLine4.VALIDATE("Bal. Account Type", GenJnlLine4."Bal. Account Type"::Customer);
                                    END;
                            END;
                            GenJnlLine4.VALIDATE("Currency Code", GenJnlBankLinebuf."Currency Code");
                            GenJnlLine4.VALIDATE("Currency Factor", GenJnlBankLinebuf."Currency Factor");
                            GenJnlLine4."Bank Payment Type" := 0;
                            GenJnlLine4."Dimension Set ID" := GenJnlBankLinebuf."Dimension Set ID";
                        END;
                    END;

                    IF (GenJnlLine4."Bal. Account Type" = GenJnlLine4."Account Type"::"Bank Account") AND
                       (GenJnlLine4."Bal. Account No." <> '') THEN BEGIN
                        IF (GenJnlLine4."Bank Payment Type" <> 1) OR
                           (((GenJnlLine4."Bank Payment Type" = 1) AND GenJnlLine4."Check Printed")) THEN BEGIN
                            InsetGenJnlBankLinebuf(GenJnlLine4);
                            BankCheckAccSetup.GET(GenJnlLine4."Bal. Account No.");
                            GenJnlLine4.VALIDATE("Bal. Account Type", GenJnlLine4."Account Type"::"G/L Account");
                            CASE CheckType OF
                                CheckType::NP:
                                    BEGIN
                                        BankCheckAccSetup.TESTFIELD("Note Payable Account");
                                        GenJnlLine4.VALIDATE("Bal. Account No.", BankCheckAccSetup."Note Payable Account");
                                    END;
                                CheckType::NR:
                                    BEGIN
                                        BankCheckAccSetup.TESTFIELD("Note Receivable Account");
                                        GenJnlLine4.VALIDATE("Bal. Account No.", BankCheckAccSetup."Note Receivable Account");
                                    END;
                            END;
                        END;
                    END;
                    GenJnlLine4."Bank Payment Type" := 0;
                    GenJnlLine4.MODIFY;
                UNTIL GenJnlLine4.NEXT = 0;

            IF NOT PostPrint THEN
                CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post", GenJnlLine4)
            ELSE
                CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post+Print", GenJnlLine4);

            GenJnlBankLinebuf.RESET;
            GenJnlBankLinebuf.SETRANGE("Document No.", GenJnlLine4."Document No.");
            IF GenJnlBankLinebuf.FIND('-') THEN BEGIN
                GenJnlBankLinebuf.RESET;
                IF GenJnlBankLinebuf.FIND('-') THEN
                    REPEAT
                        GenJnlLine4.SETRANGE("Journal Template Name", GenJnlBankLinebuf."Journal Template Name");
                        GenJnlLine4.SETRANGE("Journal Batch Name", GenJnlBankLinebuf."Journal Batch Name");
                        GenJnlLine4.SETRANGE("Line No.", GenJnlBankLinebuf."Line No.");
                        IF GenJnlLine4.FINDSET THEN BEGIN
                            GenJnlLine4.TRANSFERFIELDS(GenJnlBankLinebuf, FALSE);
                            GenJnlLine4.MODIFY;
                        END;
                        GenJnlLine4.SETRANGE("Journal Template Name");
                        GenJnlLine4.SETRANGE("Journal Batch Name");
                        GenJnlLine4.SETRANGE("Line No.");
                    UNTIL GenJnlBankLinebuf.NEXT = 0;
                EXIT;
            END;

            GLRegister.FIND('+');
            RegisterFrom := GLRegister."From Entry No.";
            RegisterTo := GLRegister."To Entry No.";
            CLEAR("Document No.");
            CLEAR("External Document No.");
        END;

        GenJnlBankLinebuf.RESET;
        IF GenJnlBankLinebuf.FIND('-') THEN
            REPEAT
                IF xNoteType = 'NP' THEN BEGIN
                    InsertCheckLedgEntry(GenJnlBankLinebuf, RegisterFrom, RegisterTo, TransactionNo, 0);
                END ELSE
                    IF xNoteType = 'NR' THEN BEGIN
                        InsertCheckLedgEntry(GenJnlBankLinebuf, RegisterFrom, RegisterTo, TransactionNo, 1);
                    END;
            UNTIL GenJnlBankLinebuf.NEXT = 0;
    end;

    local procedure InsertCheckLedgEntry(var GenJnlLine: Record "Gen. Journal Line"; RegisterFrom: Integer; RegisterTo: Integer; var TransactionNo: Integer; xNoteType: Option NP,NR)
    var
        BankAcc: Record "Bank Account";
        BankAccLedgEntry: Record "Bank Account Ledger Entry";
        CheckLedgEntry: Record "Check Ledger Entry";
        CheckLedgEntry2: Record "Check Ledger Entry";
        GLEntryNo: Integer;
        GLTransactionNo: Integer;
        BankCheckAccSetup: Record "Bank Check Acc. Setup";
        PositiveInt: Integer;
        LastGLEntry: Record "G/L Entry";
        CheckAdditionalBuf: Record "Check Ledger Entry buffer";
        CheckAdditional: Record "Check Ledger Entry Additional";
    begin
        //Get Posted Document No.
        LastGLEntry.LOCKTABLE;
        LastGLEntry.RESET;
        LastGLEntry.SETRANGE("Entry No.", RegisterFrom, RegisterTo);
        LastGLEntry.SETFILTER("Transaction No.", '>%1', TransactionNo);
        LastGLEntry.FIND('-');
        TransactionNo := LastGLEntry."Transaction No.";

        WITH GenJnlLine DO BEGIN
            PositiveInt := 1;
            BankAccLedgEntry.LOCKTABLE;
            IF ("Account Type" = "Account Type"::"Bank Account") AND
               ("Account No." <> '') THEN BEGIN
                IF BankAcc."No." <> "Account No." THEN
                    BankAcc.GET("Account No.");
            END;

            IF ("Bal. Account Type" = "Bal. Account Type"::"Bank Account") AND
               ("Bal. Account No." <> '') THEN BEGIN
                IF BankAcc."No." <> "Bal. Account No." THEN
                    BankAcc.GET("Bal. Account No.");
                PositiveInt := -1;
            END;

            BankAcc.TESTFIELD(Blocked, FALSE);
            IF "Currency Code" = '' THEN
                BankAcc.TESTFIELD("Currency Code", '')
            ELSE
                IF BankAcc."Currency Code" <> '' THEN
                    TESTFIELD("Currency Code", BankAcc."Currency Code");
            BankAcc.TESTFIELD("Bank Acc. Posting Group");

            IF "Bank Payment Type" = "Bank Payment Type"::"Computer Check" THEN
                TESTFIELD("Check Printed");

            IF BankAcc."Currency Code" <> "Currency Code" THEN
                FIELDERROR(
                  "Bank Payment Type",
                  STRSUBSTNO(
                    Text004,
                    FIELDCAPTION("Currency Code"), TABLECAPTION, BankAcc.TABLECAPTION));

            CASE "Bank Payment Type" OF
                "Bank Payment Type"::"Computer Check":
                    BEGIN
                        TESTFIELD("Check Printed", TRUE);
                        CheckLedgEntry.LOCKTABLE;
                        CheckLedgEntry.RESET;
                        CheckLedgEntry.SETCURRENTKEY("Bank Account No.", "Entry Status", "Check No.");
                        //CheckLedgEntry.SETRANGE("Bank Account No.","Account No.");
                        CheckLedgEntry.SETRANGE("Entry Status", CheckLedgEntry."Entry Status"::Printed);
                        CheckLedgEntry.SETRANGE("Check No.", "Document No.");
                        IF CheckLedgEntry.FINDSET THEN
                            REPEAT
                                CheckLedgEntry2 := CheckLedgEntry;
                                CheckLedgEntry2."Entry Status" := CheckLedgEntry2."Entry Status"::Note;
                                CheckLedgEntry2."Document No." := LastGLEntry."Document No.";
                                CheckLedgEntry2.MODIFY;
                                InsertCheckTransEntry(CheckLedgEntry2, "Currency Code", "Currency Factor", 0, LastGLEntry."Transaction No.");
                            UNTIL CheckLedgEntry.NEXT = 0;
                    END;

                "Bank Payment Type"::"Manual Check":
                    BEGIN
                        IF "Document No." = '' THEN
                            FIELDERROR(
                              "Document No.",
                              STRSUBSTNO(
                                Text005,
                                FIELDCAPTION("Bank Payment Type"), "Bank Payment Type"));

                        CheckLedgEntry.RESET;
                        IF NextCheckEntryNo = 0 THEN BEGIN
                            CheckLedgEntry.LOCKTABLE;
                            IF CheckLedgEntry.FINDLAST THEN
                                NextCheckEntryNo := CheckLedgEntry."Entry No." + 1
                            ELSE
                                NextCheckEntryNo := 1;
                        END;

                        IF NOT RECORDLEVELLOCKING THEN
                            CheckLedgEntry.SETCURRENTKEY("Bank Account No.", "Entry Status", "Check No.");
                        CheckLedgEntry.SETRANGE("Bank Account No.", "Account No.");
                        CheckLedgEntry.SETFILTER(
                          "Entry Status", '%1|%2|%3',
                          CheckLedgEntry."Entry Status"::Printed,
                          CheckLedgEntry."Entry Status"::Posted,
                          CheckLedgEntry."Entry Status"::"Financially Voided");
                        CheckLedgEntry.SETRANGE("Check No.", "Document No.");
                        IF CheckLedgEntry.FINDFIRST THEN
                            ERROR(Text006, "Document No.");

                        CheckLedgEntry.INIT;
                        CheckLedgEntry."Entry No." := NextCheckEntryNo;
                        CheckLedgEntry."Bank Account No." := BankAcc."No.";
                        CheckLedgEntry."Bank Account Ledger Entry No." := BankAccLedgEntry."Entry No.";
                        CheckLedgEntry."Posting Date" := LastGLEntry."Posting Date";
                        CheckLedgEntry."Document Type" := LastGLEntry."Document Type";
                        CheckLedgEntry."Document No." := LastGLEntry."Document No.";
                        CheckLedgEntry."External Document No." := "External Document No.";
                        CheckLedgEntry.Description := Description;
                        CheckLedgEntry."Bank Payment Type" := "Bank Payment Type";
                        SetCheckLedgEntryBal(LastGLEntry, CheckLedgEntry."Bal. Account Type", CheckLedgEntry."Bal. Account No.");
                        CheckLedgEntry."Entry Status" := CheckLedgEntry."Entry Status"::Note;
                        CheckLedgEntry.Open := TRUE;
                        CheckLedgEntry."User ID" := USERID;
                        CheckLedgEntry."Check Date" := "Due Date";
                        CheckLedgEntry."Check No." := "Document No.";
                        CheckLedgEntry.Amount := -PositiveInt * Amount;
                        CASE xNoteType OF
                            xNoteType::NP:
                                BEGIN
                                    CheckLedgEntry."Note Type" := CheckLedgEntry."Note Type"::NP;
                                END;
                            xNoteType::NR:
                                BEGIN
                                    CheckLedgEntry."Note Type" := CheckLedgEntry."Note Type"::NR;
                                END;
                        END;
                        CheckLedgEntry.INSERT;
                        InsertCheckTransEntry(CheckLedgEntry, "Currency Code", "Currency Factor", 0, LastGLEntry."Transaction No.");
                        NextCheckEntryNo := NextCheckEntryNo + 1;

                        //Insert Check Ledger Additional
                        CheckAdditionalBuf.RESET;
                        CheckAdditionalBuf.SETRANGE("Journal Document", CheckLedgEntry."Check No.");
                        IF CheckAdditionalBuf.FIND('-') THEN BEGIN
                            CheckAdditional.INIT;
                            CheckAdditional."Entry No." := CheckLedgEntry."Entry No.";
                            CheckAdditional."Drawee Bank No." := CheckAdditionalBuf."Drawee Bank No.";
                            CheckAdditional."Drawee Bank Name" := CheckAdditionalBuf."Drawee Bank Name";
                            CheckAdditional.Drawee := CheckAdditionalBuf.Drawee;
                            CheckAdditional."Invoice Domicile" := CheckAdditionalBuf."Invoice Domicile";
                            CheckAdditional."Drawee Bank Domicile" := CheckAdditionalBuf."Drawee Bank Domicile";
                            CheckAdditional.INSERT;
                            CheckAdditionalBuf.DELETEALL;
                        END;
                    END;
            END;
        END;
    end;

    [Scope('OnPrem')]
    procedure InserVoidBankLedgEntry(var GenJnlLine: Record "Gen. Journal Line")
    var
        BankAccLedgEntry: Record "Bank Account Ledger Entry";
        GLEntryNo: Integer;
        GLTransactionNo: Integer;
    begin
        WITH GenJnlLine DO BEGIN
            BankGLEntry.SETRANGE("Posting Date", "Posting Date");
            BankGLEntry.SETRANGE("Document No.", "Document No.");
            IF NOT BankGLEntry.FIND('+') THEN EXIT;
            GLEntryNo := BankGLEntry."Entry No.";
            GLTransactionNo := BankGLEntry."Transaction No.";

            BankAccLedgEntry.INIT;
            IF ("Account Type" = "Account Type"::"Bank Account") AND ("Account No." <> '') THEN
                BankAccLedgEntry."Bank Account No." := "Account No.";
            IF ("Bal. Account Type" = "Account Type"::"Bank Account") AND ("Bal. Account No." <> '') THEN
                BankAccLedgEntry."Bank Account No." := "Bal. Account No.";
            BankAccLedgEntry."Posting Date" := "Posting Date";
            BankAccLedgEntry."Document Date" := "Document Date";
            BankAccLedgEntry."Document Type" := "Document Type";
            BankAccLedgEntry."Document No." := "Document No.";
            BankAccLedgEntry."External Document No." := "External Document No.";
            BankAccLedgEntry.Description := Description;
            BankAccLedgEntry."Bank Acc. Posting Group" := BankAcc."Bank Acc. Posting Group";
            BankAccLedgEntry."Global Dimension 1 Code" := "Shortcut Dimension 1 Code";
            BankAccLedgEntry."Global Dimension 2 Code" := "Shortcut Dimension 2 Code";
            BankAccLedgEntry."Our Contact Code" := "Salespers./Purch. Code";
            BankAccLedgEntry."Source Code" := "Source Code";
            BankAccLedgEntry."Journal Batch Name" := "Journal Batch Name";
            BankAccLedgEntry."Reason Code" := "Reason Code";
            BankAccLedgEntry."Entry No." := GLEntryNo;
            BankAccLedgEntry."Transaction No." := GLTransactionNo;
            BankAccLedgEntry."Currency Code" := BankAcc."Currency Code";
            IF BankAcc."Currency Code" <> '' THEN
                BankAccLedgEntry.Amount := Amount
            ELSE
                BankAccLedgEntry.Amount := "Amount (LCY)";
            BankAccLedgEntry."Amount (LCY)" := "Amount (LCY)";
            BankAccLedgEntry."User ID" := USERID;
            IF BankAccLedgEntry.Amount <> 0 THEN BEGIN
                BankAccLedgEntry.Open := TRUE;
                BankAccLedgEntry."Remaining Amount" := BankAccLedgEntry.Amount;
            END;
            BankAccLedgEntry.Positive := BankAccLedgEntry.Amount > 0;
            BankAccLedgEntry."Bal. Account Type" := "Bal. Account Type";
            BankAccLedgEntry."Bal. Account No." := "Bal. Account No.";
            IF (Amount > 0) AND (NOT Correction) OR
               ("Amount (LCY)" > 0) AND (NOT Correction) OR
               (Amount < 0) AND Correction OR
               ("Amount (LCY)" < 0) AND Correction
            THEN BEGIN
                BankAccLedgEntry."Debit Amount" := BankAccLedgEntry.Amount;
                BankAccLedgEntry."Credit Amount" := 0;
                BankAccLedgEntry."Debit Amount (LCY)" := BankAccLedgEntry."Amount (LCY)";
                BankAccLedgEntry."Credit Amount (LCY)" := 0;
            END ELSE BEGIN
                BankAccLedgEntry."Debit Amount" := 0;
                BankAccLedgEntry."Credit Amount" := -BankAccLedgEntry.Amount;
                BankAccLedgEntry."Debit Amount (LCY)" := 0;
                BankAccLedgEntry."Credit Amount (LCY)" := -BankAccLedgEntry."Amount (LCY)";
            END;
            BankAccLedgEntry."Dimension Set ID" := GenJnlLine."Dimension Set ID";
            BankAccLedgEntry.INSERT;
        END;
    end;

    [Scope('OnPrem')]
    procedure InsetGenJnlBankLinebuf(GenJnlBankLine: Record "Gen. Journal Line")
    begin
        WITH GenJnlBankLine DO BEGIN
            GenJnlBankLinebuf.RESET;
            GenJnlBankLinebuf.SETRANGE("Journal Template Name", "Journal Template Name");
            GenJnlBankLinebuf.SETRANGE("Journal Batch Name", "Journal Batch Name");
            GenJnlBankLinebuf.SETRANGE("Line No.", "Line No.");
            IF NOT GenJnlBankLinebuf.FIND('+') THEN BEGIN
                GenJnlBankLinebuf.INIT;
                GenJnlBankLinebuf.TRANSFERFIELDS(GenJnlBankLine);
                GenJnlBankLinebuf.INSERT;
            END;
        END;
    end;

    [Scope('OnPrem')]
    procedure SetCheckLedgEntryBal(var pGLEntry: Record "G/L Entry"; var BalAccType: Option "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset"; var BalAccNo: Code[20])
    var
        CustLedgEntry: Record "Cust. Ledger Entry";
        VendLedEntry: Record "Vendor Ledger Entry";
    begin
        VendLedEntry.RESET;
        VendLedEntry.SETRANGE("Posting Date", pGLEntry."Posting Date");
        VendLedEntry.SETRANGE("Document No.", pGLEntry."Document No.");
        IF VendLedEntry.FIND('-') THEN BEGIN
            BalAccType := BalAccType::Vendor;
            BalAccNo := VendLedEntry."Vendor No.";
            EXIT;
        END;

        CustLedgEntry.RESET;
        CustLedgEntry.SETRANGE("Posting Date", pGLEntry."Posting Date");
        CustLedgEntry.SETRANGE("Document No.", pGLEntry."Document No.");
        IF CustLedgEntry.FIND('-') THEN BEGIN
            BalAccType := BalAccType::Customer;
            BalAccNo := CustLedgEntry."Customer No.";
            EXIT;
        END;
    end;

    [Scope('OnPrem')]
    procedure InsertCheckTransEntry(pCheckLedgEntry: Record "Check Ledger Entry"; pCurrencyCode: Code[10]; pCurrencyFactor: Decimal; pVoidSubType: Integer; pTransactionNo: Integer)
    var
        NextCheckTransEntryNo: Integer;
        TransactionGLEntry: Record "G/L Entry";
        CheckTransEntryPostingDate: Date;
        CheckTransEntryDocumentNo: Code[20];
    begin
        CheckTransEntry.LOCKTABLE;
        CheckTransEntry.RESET;
        IF CheckTransEntry.FIND('+') THEN
            NextCheckTransEntryNo := CheckTransEntry."Entry No." + 1
        ELSE
            NextCheckTransEntryNo := 1;

        WITH pCheckLedgEntry DO BEGIN
            CheckTransEntryDocumentNo := "Document No.";
            CheckTransEntryPostingDate := "Posting Date";

            IF pTransactionNo <> 0 THEN BEGIN
                TransactionGLEntry.SETCURRENTKEY("Transaction No.");
                TransactionGLEntry.SETRANGE("Transaction No.", pTransactionNo);
                IF TransactionGLEntry.FIND('+') THEN BEGIN
                    CheckTransEntryDocumentNo := TransactionGLEntry."Document No.";
                    CheckTransEntryPostingDate := TransactionGLEntry."Posting Date";
                END;
            END;

            CheckTransEntry.INIT;
            CheckTransEntry."Entry No." := NextCheckTransEntryNo;
            CheckTransEntry."Check Entry No" := "Entry No.";
            CheckTransEntry."Posting Date" := CheckTransEntryPostingDate;
            CheckTransEntry."Document Type" := "Document Type";
            CheckTransEntry."Document No." := CheckTransEntryDocumentNo;
            CheckTransEntry."Check Date" := "Check Date";
            CheckTransEntry."Check No." := "Check No.";
            CheckTransEntry."Check Type" := "Check Type";
            CheckTransEntry."Bank Payment Type" := "Bank Payment Type";
            CheckTransEntry."Entry Status" := "Entry Status";
            CheckTransEntry."User ID" := USERID;
            IF pCheckLedgEntry.Amount > 0 THEN
                CheckTransEntry."Note Type" := CheckTransEntry."Note Type"::NP
            ELSE
                CheckTransEntry."Note Type" := CheckTransEntry."Note Type"::NR;
            CheckTransEntry."Currency Code" := pCurrencyCode;
            CheckTransEntry."Currency Factor" := pCurrencyFactor;
            CheckTransEntry."Currency Date" := pCheckLedgEntry."Posting Date";
            CheckTransEntry."Transaction No." := pTransactionNo;
            CheckTransEntry."Status Sub Type" := pVoidSubType;
            CheckTransEntry.INSERT;
        END;
    end;

    [Scope('OnPrem')]
    procedure FinancialCashCheck(var CheckLedgEntry: Record "Check Ledger Entry")
    var
        TransactionBalance: Decimal;
        VATPostingSetup: Record "VAT Posting Setup";
        BankAccPostGrp: Record "Bank Account Posting Group";
        CheckTransEntry2: Record "Detailed Check Entry";
        Currency: Record Currency;
        ConfirmFinCash: Page "Cash Check";
        AmountToCash: Decimal;
        CheckAmountLCY: Decimal;
        BalanceAmountLCY: Decimal;
        CurrencyRoundingDebitAccount: Code[20];
        CurrencyRoundingCreditAccount: Code[20];
        CheckGLEntry: Record "G/L Entry";
        GLEntryNo: Integer;
        GLTransactionNo: Integer;
        BankCheckAccSetup: Record "Bank Check Acc. Setup";
        LastGLEntry: Record "G/L Entry";
        PostedDocumentNo: Code[20];
    begin
        CheckLedgEntry.TESTFIELD("Entry Status", CheckLedgEntry."Entry Status"::Note);

        CheckLedgEntry.TESTFIELD("Bal. Account No.");
        BankAcc.GET(CheckLedgEntry."Bank Account No.");
        BankAcc.TESTFIELD("Bank Acc. Posting Group");
        BankAccPostGrp.GET(BankAcc."Bank Acc. Posting Group");
        BankAccPostGrp.TESTFIELD("G/L Bank Account No.");
        BankCheckAccSetup.GET(CheckLedgEntry."Bank Account No.");

        //Get Original Factor
        CheckTransEntry2.RESET;
        CheckTransEntry2.SETRANGE("Check Entry No", CheckLedgEntry."Entry No.");
        CheckTransEntry2.FIND('+');
        BankAcc.TESTFIELD("Currency Code", CheckTransEntry2."Currency Code");

        WITH GLEntry DO BEGIN
            SETCURRENTKEY("Transaction No.");
            SETRANGE("Transaction No.", CheckTransEntry2."Transaction No.");
            SETRANGE("Document No.", CheckLedgEntry."Document No.");
            IF FINDSET THEN
                REPEAT
                    TransactionBalance := TransactionBalance + Amount;
                UNTIL NEXT = 0;
        END;
        IF TransactionBalance <> 0 THEN
            ERROR(Text002);

        CLEAR(ConfirmFinCash);
        ConfirmFinCash.SetCheckLedgerEntry(CheckLedgEntry);
        ConfirmFinCash.LOOKUPMODE(TRUE);
        IF ConfirmFinCash.RUNMODAL <> ACTION::LookupOK THEN
            EXIT;

        CheckGLEntry.RESET;
        CheckGLEntry.SETCURRENTKEY("Transaction No.");
        CheckGLEntry.SETRANGE("Transaction No.", CheckTransEntry2."Transaction No.");
        CheckGLEntry.SETRANGE("Document No.", CheckLedgEntry."Document No.");
        CASE CheckLedgEntry."Note Type" OF
            CheckLedgEntry."Note Type"::NP:
                CheckGLEntry.SETRANGE("G/L Account No.", BankCheckAccSetup."Note Payable Account");
            CheckLedgEntry."Note Type"::NR:
                CheckGLEntry.SETRANGE("G/L Account No.", BankCheckAccSetup."Note Receivable Account");
        END;
        IF CheckGLEntry.FIND('-') THEN;

        AmountToCash := 0;
        WITH CheckLedgEntry2 DO BEGIN
            RESET;
            SETCURRENTKEY("Bank Account No.", "Entry Status", "Check No.");
            SETRANGE("Bank Account No.", CheckLedgEntry."Bank Account No.");
            SETRANGE("Entry Status", CheckLedgEntry."Entry Status"::Note);
            SETRANGE("Check No.", CheckLedgEntry."Check No.");
            SETRANGE("Check Date", CheckLedgEntry."Check Date");
            IF FINDSET THEN
                REPEAT
                    AmountToCash := AmountToCash + Amount;
                UNTIL NEXT = 0;
        END;

        PostedDocumentNo := GetPostedDocumentNo(CheckLedgEntry."Document No.",
                                                CheckGLEntry."No. Series",
                                                ConfirmFinCash.GetCashDate);

        GenJnlLine2.INIT;
        GenJnlLine2."System-Created Entry" := TRUE;
        GenJnlLine2."Document No." := PostedDocumentNo;
        GenJnlLine2."External Document No." := CheckLedgEntry."External Document No.";
        GenJnlLine2."Account Type" := GenJnlLine2."Account Type"::"G/L Account";
        GenJnlLine2."Posting Date" := ConfirmFinCash.GetCashDate;
        GenJnlLine2.VALIDATE("Account No.", CheckGLEntry."G/L Account No.");
        GenJnlLine2.Description := STRSUBSTNO(Text008, CheckLedgEntry."Check No.");
        GenJnlLine2.VALIDATE("Currency Code", BankAcc."Currency Code");
        GenJnlLine2.VALIDATE(Amount, AmountToCash);
        GenJnlLine2.VALIDATE("Currency Factor", CheckTransEntry2."Currency Factor");
        CheckAmountLCY := GenJnlLine2."Amount (LCY)";
        BalanceAmountLCY := 0;
        GenJnlLine2."Source Code" := CheckGLEntry."Source Code";
        GenJnlLine2."Shortcut Dimension 1 Code" := CheckGLEntry."Global Dimension 1 Code";
        GenJnlLine2."Shortcut Dimension 2 Code" := CheckGLEntry."Global Dimension 2 Code";
        GenJnlLine2."Allow Zero-Amount Posting" := TRUE;
        GenJnlLine2."Posting No. Series" := CheckGLEntry."No. Series";
        GenJnlLine2."Dimension Set ID" := CheckGLEntry."Dimension Set ID";
        GenJnlPostLine.RunWithCheck(GenJnlLine2);

        GenJnlLine2.INIT;
        GenJnlLine2."System-Created Entry" := TRUE;
        GenJnlLine2."Document No." := PostedDocumentNo;
        GenJnlLine2."External Document No." := CheckLedgEntry."External Document No.";
        GenJnlLine2."Account Type" := GenJnlLine2."Account Type"::"Bank Account";
        GenJnlLine2."Posting Date" := ConfirmFinCash.GetCashDate;
        GenJnlLine2.VALIDATE("Account No.", CheckLedgEntry."Bank Account No.");
        GenJnlLine2.Description := STRSUBSTNO(Text008, CheckLedgEntry."Check No.");
        GenJnlLine2."Source Code" := CheckGLEntry."Source Code";
        GenJnlLine2.VALIDATE("Currency Code", BankAcc."Currency Code");
        GenJnlLine2.VALIDATE("Currency Factor", ConfirmFinCash.GetCurrencyFactor);
        GenJnlLine2.VALIDATE(Amount, -AmountToCash);
        BalanceAmountLCY := BalanceAmountLCY + GenJnlLine2."Amount (LCY)";
        GenJnlLine2."Shortcut Dimension 1 Code" := CheckGLEntry."Global Dimension 1 Code";
        GenJnlLine2."Shortcut Dimension 2 Code" := CheckGLEntry."Global Dimension 2 Code";
        GenJnlLine2."Allow Zero-Amount Posting" := TRUE;
        GenJnlLine2."Posting No. Series" := CheckGLEntry."No. Series";
        GenJnlLine2."Dimension Set ID" := CheckGLEntry."Dimension Set ID";
        GenJnlPostLine.RunWithCheck(GenJnlLine2);

        IF CheckAmountLCY + BalanceAmountLCY <> 0 THEN BEGIN  // rounding error from currency conversion
            Currency.GET(BankAcc."Currency Code");
            Currency.TESTFIELD("Realized Gains Acc.");
            Currency.TESTFIELD("Realized Losses Acc.");
            GenJnlLine2.INIT;
            GenJnlLine2."System-Created Entry" := TRUE;
            GenJnlLine2."Financial Void" := TRUE;
            GenJnlLine2."Document No." := PostedDocumentNo;
            GenJnlLine2."External Document No." := CheckLedgEntry."External Document No.";
            GenJnlLine2."Account Type" := GenJnlLine2."Account Type"::"G/L Account";
            GenJnlLine2."Posting Date" := ConfirmFinCash.GetCashDate;
            IF (CheckAmountLCY + BalanceAmountLCY) > 0 THEN
                GenJnlLine2.VALIDATE("Account No.", Currency."Realized Gains Acc.")
            ELSE
                GenJnlLine2.VALIDATE("Account No.", Currency."Realized Losses Acc.");
            GenJnlLine2.VALIDATE("Currency Code", BankAcc."Currency Code");
            GenJnlLine2.Description := STRSUBSTNO(Text008, CheckLedgEntry."Check No.");
            GenJnlLine2."Source Code" := CheckGLEntry."Source Code";
            GenJnlLine2."Allow Zero-Amount Posting" := TRUE;
            GenJnlLine2.VALIDATE(Amount, 0);
            GenJnlLine2."Amount (LCY)" := -(CheckAmountLCY + BalanceAmountLCY);
            GenJnlLine2."Shortcut Dimension 1 Code" := CheckGLEntry."Global Dimension 1 Code";
            GenJnlLine2."Shortcut Dimension 2 Code" := CheckGLEntry."Global Dimension 2 Code";
            GenJnlLine2."Posting No. Series" := CheckGLEntry."No. Series";
            GenJnlLine2."Dimension Set ID" := CheckGLEntry."Dimension Set ID";
            GenJnlPostLine.RunWithCheck(GenJnlLine2);
        END;

        //Get Posted Document No.
        LastGLEntry.LOCKTABLE;
        LastGLEntry.RESET;
        LastGLEntry.FIND('+');

        MarkCheckEntriesCash(CheckLedgEntry, ConfirmFinCash.GetCashDate);
        InsertCheckTransEntry(CheckLedgEntry,
                              GenJnlLine2."Currency Code", GenJnlLine2."Currency Factor", 4, LastGLEntry."Transaction No.");
        COMMIT;
        UpdateAnalysisView.UpdateAll(0, TRUE);
    end;

    [Scope('OnPrem')]
    procedure FinancialCashCheckBatch(var CheckLedgEntry: Record "Check Ledger Entry")
    var
        TransactionBalance: Decimal;
        VATPostingSetup: Record "VAT Posting Setup";
        BankAccPostGrp: Record "Bank Account Posting Group";
        CheckTransEntry2: Record "Detailed Check Entry";
        Currency: Record Currency;
        ConfirmFinCash: Page "Cash Checks by Batch";
        AmountToCash: Decimal;
        CheckAmountLCY: Decimal;
        BalanceAmountLCY: Decimal;
        CurrencyRoundingDebitAccount: Code[20];
        CurrencyRoundingCreditAccount: Code[20];
        CheckGLEntry: Record "G/L Entry";
        GLEntryNo: Integer;
        GLTransactionNo: Integer;
        BankCheckAccSetup: Record "Bank Check Acc. Setup";
        LastGLEntry: Record "G/L Entry";
        PostedDocumentNo: Code[20];
        CheckEntryBuf: Record "Check Ledger Entry buffer" temporary;
        BatchCurrency: Code[10];
    begin
        CheckLedgEntry.SETCURRENTKEY("Document No.", "Posting Date");
        IF NOT CheckLedgEntry.FIND('-') THEN EXIT;

        CheckEntryBuf.SETRANGE("Check No. Filter", CheckLedgEntry."Check No.");
        CheckEntryBuf.CALCFIELDS("Currency Code");
        BatchCurrency := CheckEntryBuf."Currency Code";
        CheckLedgEntry.NEXT;
        REPEAT
            CheckEntryBuf.SETRANGE("Check No. Filter", CheckLedgEntry."Check No.");
            CheckEntryBuf.CALCFIELDS("Currency Code");
            IF BatchCurrency <> CheckEntryBuf."Currency Code" THEN
                ERROR(Text010);
        UNTIL CheckLedgEntry.NEXT = 0;
        CheckLedgEntry.FIND('-');

        CLEAR(ConfirmFinCash);
        ConfirmFinCash.SetCheckLedgerEntry(CheckLedgEntry);
        ConfirmFinCash.LOOKUPMODE(TRUE);
        IF ConfirmFinCash.RUNMODAL <> ACTION::LookupOK THEN
            EXIT;

        REPEAT
            CheckLedgEntry.TESTFIELD("Entry Status", CheckLedgEntry."Entry Status"::Note);
            CheckLedgEntry.TESTFIELD("Bal. Account No.");
            BankAcc.GET(CheckLedgEntry."Bank Account No.");
            BankAcc.TESTFIELD("Bank Acc. Posting Group");
            BankAccPostGrp.GET(BankAcc."Bank Acc. Posting Group");
            BankAccPostGrp.TESTFIELD("G/L Bank Account No.");
            BankCheckAccSetup.GET(CheckLedgEntry."Bank Account No.");

            //Get Original Factor
            CheckTransEntry2.RESET;
            CheckTransEntry2.SETRANGE("Check Entry No", CheckLedgEntry."Entry No.");
            CheckTransEntry2.FIND('+');
            BankAcc.TESTFIELD("Currency Code", CheckTransEntry2."Currency Code");

            WITH GLEntry DO BEGIN
                SETCURRENTKEY("Transaction No.");
                SETRANGE("Transaction No.", CheckTransEntry2."Transaction No.");
                SETRANGE("Document No.", CheckLedgEntry."Document No.");
                IF FINDSET THEN
                    REPEAT
                        TransactionBalance := TransactionBalance + Amount;
                    UNTIL NEXT = 0;
            END;
            IF TransactionBalance <> 0 THEN
                ERROR(Text002);


            CheckGLEntry.RESET;
            CheckGLEntry.SETCURRENTKEY("Transaction No.");
            CheckGLEntry.SETRANGE("Transaction No.", CheckTransEntry2."Transaction No.");
            CheckGLEntry.SETRANGE("Document No.", CheckLedgEntry."Document No.");
            CASE CheckLedgEntry."Note Type" OF
                CheckLedgEntry."Note Type"::NP:
                    CheckGLEntry.SETRANGE("G/L Account No.", BankCheckAccSetup."Note Payable Account");
                CheckLedgEntry."Note Type"::NR:
                    CheckGLEntry.SETRANGE("G/L Account No.", BankCheckAccSetup."Note Receivable Account");
            END;

            IF CheckGLEntry.FIND('-') THEN;

            AmountToCash := 0;
            WITH CheckLedgEntry2 DO BEGIN
                RESET;
                SETCURRENTKEY("Bank Account No.", "Entry Status", "Check No.");
                SETRANGE("Bank Account No.", CheckLedgEntry."Bank Account No.");
                SETRANGE("Entry Status", CheckLedgEntry."Entry Status"::Note);
                SETRANGE("Check No.", CheckLedgEntry."Check No.");
                SETRANGE("Check Date", CheckLedgEntry."Check Date");
                IF FINDSET THEN
                    REPEAT
                        AmountToCash := AmountToCash + Amount;
                    UNTIL NEXT = 0;
            END;

            PostedDocumentNo := GetPostedDocumentNo(CheckLedgEntry."Document No.",
                                                    CheckGLEntry."No. Series",
                                                    ConfirmFinCash.GetCashDate);

            GenJnlLine2.INIT;
            GenJnlLine2."System-Created Entry" := TRUE;
            GenJnlLine2."Document No." := PostedDocumentNo;
            GenJnlLine2."External Document No." := CheckLedgEntry."External Document No.";
            GenJnlLine2."Account Type" := GenJnlLine2."Account Type"::"G/L Account";
            GenJnlLine2."Posting Date" := ConfirmFinCash.GetCashDate;
            GenJnlLine2.VALIDATE("Account No.", CheckGLEntry."G/L Account No.");
            GenJnlLine2.Description := STRSUBSTNO(Text008, CheckLedgEntry."Check No.");
            GenJnlLine2.VALIDATE("Currency Code", BankAcc."Currency Code");
            GenJnlLine2.VALIDATE(Amount, AmountToCash);
            GenJnlLine2.VALIDATE("Currency Factor", CheckTransEntry2."Currency Factor");
            CheckAmountLCY := GenJnlLine2."Amount (LCY)";
            BalanceAmountLCY := 0;
            GenJnlLine2."Source Code" := CheckGLEntry."Source Code";
            GenJnlLine2."Shortcut Dimension 1 Code" := CheckGLEntry."Global Dimension 1 Code";
            GenJnlLine2."Shortcut Dimension 2 Code" := CheckGLEntry."Global Dimension 2 Code";
            GenJnlLine2."Allow Zero-Amount Posting" := TRUE;
            GenJnlLine2."Posting No. Series" := CheckGLEntry."No. Series";
            GenJnlLine2."Dimension Set ID" := CheckGLEntry."Dimension Set ID";
            GenJnlPostLine.RunWithCheck(GenJnlLine2);

            GenJnlLine2.INIT;
            GenJnlLine2."System-Created Entry" := TRUE;
            GenJnlLine2."Document No." := PostedDocumentNo;
            GenJnlLine2."External Document No." := CheckLedgEntry."External Document No.";
            GenJnlLine2."Account Type" := GenJnlLine2."Account Type"::"Bank Account";
            GenJnlLine2."Posting Date" := ConfirmFinCash.GetCashDate;
            GenJnlLine2.VALIDATE("Account No.", CheckLedgEntry."Bank Account No.");
            GenJnlLine2.Description := STRSUBSTNO(Text008, CheckLedgEntry."Check No.");
            GenJnlLine2."Source Code" := CheckGLEntry."Source Code";
            GenJnlLine2.VALIDATE("Currency Code", BankAcc."Currency Code");
            GenJnlLine2.VALIDATE("Currency Factor", ConfirmFinCash.GetCurrencyFactor);
            GenJnlLine2.VALIDATE(Amount, -AmountToCash);
            BalanceAmountLCY := BalanceAmountLCY + GenJnlLine2."Amount (LCY)";
            GenJnlLine2."Shortcut Dimension 1 Code" := CheckGLEntry."Global Dimension 1 Code";
            GenJnlLine2."Shortcut Dimension 2 Code" := CheckGLEntry."Global Dimension 2 Code";
            GenJnlLine2."Allow Zero-Amount Posting" := TRUE;
            GenJnlLine2."Posting No. Series" := CheckGLEntry."No. Series";
            GenJnlLine2."Dimension Set ID" := CheckGLEntry."Dimension Set ID";
            GenJnlPostLine.RunWithCheck(GenJnlLine2);

            IF CheckAmountLCY + BalanceAmountLCY <> 0 THEN BEGIN  // rounding error from currency conversion
                Currency.GET(BankAcc."Currency Code");
                Currency.TESTFIELD("Realized Gains Acc.");
                Currency.TESTFIELD("Realized Losses Acc.");
                GenJnlLine2.INIT;
                GenJnlLine2."System-Created Entry" := TRUE;
                GenJnlLine2."Financial Void" := TRUE;
                GenJnlLine2."Document No." := PostedDocumentNo;
                GenJnlLine2."External Document No." := CheckLedgEntry."External Document No.";
                GenJnlLine2."Account Type" := GenJnlLine2."Account Type"::"G/L Account";
                GenJnlLine2."Posting Date" := ConfirmFinCash.GetCashDate;
                IF (CheckAmountLCY + BalanceAmountLCY) > 0 THEN
                    GenJnlLine2.VALIDATE("Account No.", Currency."Realized Gains Acc.")
                ELSE
                    GenJnlLine2.VALIDATE("Account No.", Currency."Realized Losses Acc.");
                GenJnlLine2.VALIDATE("Currency Code", BankAcc."Currency Code");
                GenJnlLine2.Description := STRSUBSTNO(Text008, CheckLedgEntry."Check No.");
                GenJnlLine2."Source Code" := CheckGLEntry."Source Code";
                GenJnlLine2."Allow Zero-Amount Posting" := TRUE;
                GenJnlLine2.VALIDATE(Amount, 0);
                GenJnlLine2."Amount (LCY)" := -(CheckAmountLCY + BalanceAmountLCY);
                GenJnlLine2."Shortcut Dimension 1 Code" := CheckGLEntry."Global Dimension 1 Code";
                GenJnlLine2."Shortcut Dimension 2 Code" := CheckGLEntry."Global Dimension 2 Code";
                GenJnlLine2."Posting No. Series" := CheckGLEntry."No. Series";
                GenJnlLine2."Dimension Set ID" := CheckGLEntry."Dimension Set ID";
                GenJnlPostLine.RunWithCheck(GenJnlLine2);
            END;

            //Get Posted Document No.
            LastGLEntry.LOCKTABLE;
            LastGLEntry.RESET;
            LastGLEntry.FIND('+');

            MarkCheckEntriesCash(CheckLedgEntry, ConfirmFinCash.GetCashDate);
            InsertCheckTransEntry(CheckLedgEntry,
                                  GenJnlLine2."Currency Code", GenJnlLine2."Currency Factor", 4, LastGLEntry."Transaction No.");
        UNTIL CheckLedgEntry.NEXT = 0;

        COMMIT;
        UpdateAnalysisView.UpdateAll(0, TRUE);
    end;

    [Scope('OnPrem')]
    procedure MarkCheckEntriesCash(var OriginalCheckEntry: Record "Check Ledger Entry"; CashDate: Date)
    var
        RelatedCheckEntry: Record "Check Ledger Entry";
        RelatedCheckEntry2: Record "Check Ledger Entry";
        VoidOriginal: Boolean;
        RelatedBankEntry: Record "Bank Account Ledger Entry";
    begin
        RelatedBankEntry.RESET;
        RelatedBankEntry.FIND('+');

        WITH RelatedCheckEntry DO BEGIN
            RESET;
            SETCURRENTKEY("Bank Account No.", "Entry Status", "Check No.");
            SETRANGE("Bank Account No.", OriginalCheckEntry."Bank Account No.");
            SETRANGE("Entry Status", OriginalCheckEntry."Entry Status"::Note);
            SETRANGE("Check No.", OriginalCheckEntry."Check No.");
            SETRANGE("Check Date", OriginalCheckEntry."Check Date");
            SETFILTER("Entry No.", '<>%1', OriginalCheckEntry."Entry No.");
            IF FINDSET THEN
                REPEAT
                    //++TWN1.00.122187.QX
                    RelatedCheckEntry2 := RelatedCheckEntry;
                    // RelatedCheckEntry2."Original Entry Status" := "Entry Status";
                    RelatedCheckEntry2."Original Entry Status" := "Check Ledger Entry Original Entry Status".FromInteger("Entry Status".AsInteger());
                    //--TWN1.00.122187.QX
                    IF CashDate = OriginalCheckEntry."Check Date" THEN BEGIN
                        RelatedCheckEntry2.Open := FALSE;
                        RelatedCheckEntry2."Entry Status" := RelatedCheckEntry2."Entry Status"::Posted;
                    END;
                    RelatedCheckEntry2."Bank Account Ledger Entry No." := RelatedBankEntry."Entry No.";
                    RelatedCheckEntry2.MODIFY;
                UNTIL NEXT = 0;
        END;

        WITH OriginalCheckEntry DO BEGIN
            //++TWN1.00.122187.QX
            // "Original Entry Status" := "Entry Status";
            "Original Entry Status" := "Check Ledger Entry Original Entry Status".FromInteger("Entry Status".AsInteger());
            //--TWN1.00.122187.QX
            //IF CashDate = "Check Date" THEN BEGIN
            Open := FALSE;
            "Entry Status" := "Entry Status"::Posted;
            //END;
            "Bank Account Ledger Entry No." := RelatedBankEntry."Entry No.";
            MODIFY;
        END;
    end;

    [Scope('OnPrem')]
    procedure MarkCashCheckEntriesVoid(var OriginalCheckEntry: Record "Check Ledger Entry"; VoidDate: Date)
    var
        RelatedCheckEntry: Record "Check Ledger Entry";
        RelatedCheckEntry2: Record "Check Ledger Entry";
        VoidOriginal: Boolean;
    begin
        WITH RelatedCheckEntry DO BEGIN
            RESET;
            SETCURRENTKEY("Bank Account No.", "Entry Status", "Check No.");
            SETRANGE("Bank Account No.", OriginalCheckEntry."Bank Account No.");
            SETRANGE("Entry Status", OriginalCheckEntry."Entry Status"::Posted);
            SETRANGE("Check No.", OriginalCheckEntry."Check No.");
            SETRANGE("Check Date", OriginalCheckEntry."Check Date");
            SETFILTER("Entry No.", '<>%1', OriginalCheckEntry."Entry No.");
            IF FINDSET THEN
                REPEAT
                    RelatedCheckEntry2 := RelatedCheckEntry;
                    //++TWN1.00.122187.QX
                    // RelatedCheckEntry2."Original Entry Status" := "Entry Status";
                    RelatedCheckEntry2."Original Entry Status" := "Check Ledger Entry Original Entry Status".FromInteger("Entry Status".AsInteger());
                    //--TWN1.00.122187.QX
                    RelatedCheckEntry2."Entry Status" := "Entry Status"::Note;
                    IF VoidDate = OriginalCheckEntry."Check Date" THEN BEGIN
                        RelatedCheckEntry2.Open := TRUE;
                    END;
                    RelatedCheckEntry2.MODIFY;
                UNTIL NEXT = 0;
        END;

        WITH OriginalCheckEntry DO BEGIN
            //++TWN1.00.122187.QX
            // "Original Entry Status" := "Entry Status";
            "Original Entry Status" := "Check Ledger Entry Original Entry Status".FromInteger("Entry Status".AsInteger());
            //--TWN1.00.122187.QX
            "Entry Status" := "Entry Status"::Note;
            //IF VoidDate = "Check Date" THEN BEGIN
            Open := TRUE;
            //END;
            MODIFY;
        END;
    end;

    [Scope('OnPrem')]
    procedure InsCashCheckVoidTransEntry(pCheckLedgEntry: Record "Check Ledger Entry"; pCurrencyCode: Code[10]; pCurrencyFactor: Decimal; pTransactionNo: Integer)
    var
        xBankLegeEntry: Record "Bank Account Ledger Entry";
        NextCheckTransEntryNo: Integer;
        CheckTransEntry2: Record "Detailed Check Entry";
    begin
        pCheckLedgEntry."Entry Status" := pCheckLedgEntry."Entry Status"::"Financially Voided";
        InsertCheckTransEntry(pCheckLedgEntry, pCurrencyCode, pCurrencyFactor, 5, pTransactionNo);

        CheckTransEntry.LOCKTABLE;
        CheckTransEntry.RESET;
        IF CheckTransEntry.FIND('+') THEN
            NextCheckTransEntryNo := CheckTransEntry."Entry No." + 1
        ELSE
            NextCheckTransEntryNo := 1;

        CheckTransEntry2.RESET;
        CheckTransEntry2.SETRANGE("Check Entry No", pCheckLedgEntry."Entry No.");
        CheckTransEntry2.SETRANGE("Entry Status", CheckTransEntry2."Entry Status"::Note);
        CheckTransEntry2.FIND('+');

        WITH CheckTransEntry2 DO BEGIN
            CheckTransEntry.INIT;
            CheckTransEntry."Entry No." := NextCheckTransEntryNo;
            CheckTransEntry."Check Entry No" := "Check Entry No";
            CheckTransEntry."Posting Date" := "Posting Date";
            CheckTransEntry."Document Type" := "Document Type";
            CheckTransEntry."Document No." := "Document No.";
            CheckTransEntry."Check Date" := "Check Date";
            CheckTransEntry."Check No." := "Check No.";
            CheckTransEntry."Check Type" := "Check Type";
            CheckTransEntry."Bank Payment Type" := "Bank Payment Type";
            CheckTransEntry."Entry Status" := "Entry Status"::Note;
            CheckTransEntry."User ID" := USERID;
            CheckTransEntry."Note Type" := "Note Type";
            CheckTransEntry."Currency Code" := "Currency Code";
            CheckTransEntry."Currency Factor" := "Currency Factor";
            CheckTransEntry."Currency Date" := "Currency Date";
            CheckTransEntry."Transaction No." := "Transaction No.";
            CheckTransEntry."Status Sub Type" := CheckTransEntry."Status Sub Type"::Note;
            CheckTransEntry.INSERT;
        END;
    end;

    [Scope('OnPrem')]
    procedure GetPostedDocumentNo(DocumentNo: Code[20]; NoSerialCode: Code[20]; PostingDate: Date): Code[20]
    var
        NoSerialMgt: Codeunit NoSeriesManagement;
    begin
        CASE TRUE OF
            NoSerialCode = '':
                EXIT(DocumentNo);
            NoSerialCode <> '':
                EXIT(NoSerialMgt.GetNextNo(NoSerialCode, PostingDate, TRUE));
        END;
    end;
}

