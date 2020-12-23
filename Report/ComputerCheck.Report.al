report 50007 "Computer Check"
{
    // +--------------------------------------------------------------+
    // | @ 2017 incadea Taiwan Limited                                |
    // +--------------------------------------------------------------+
    // | PURPOSE: MARS_TWN                                            |
    // |                                                              |
    // | REMARK :                                                     |
    // +--------------------------------------------------------------+

    // VERSION     ID                  WHO    DATE        DESCRIPTION
    // TWN.01.09   RGS_TWN-INC01_NPNR  AH     2017-06-05  INITIAL RELEASE   
    Caption = 'Computer Check';
    Permissions = tabledata "Bank Account" = m;
    DefaultLayout = RDLC;
    RDLCLayout = 'ReportLayout\report50007.rdl';
    UsageCategory = ReportsAndAnalysis;
    dataset
    {
        dataitem(VoidGenJnlLine; "Gen. Journal Line")
        {
            DataItemTableView = sorting("Journal Template Name", "Journal Batch Name", "Posting Date", "Document No.");
            RequestFilterFields = "Journal Template Name", "Journal Batch Name", "Posting Date";
            trigger OnPreDataItem()
            begin
                IF CurrReport.PREVIEW THEN
                    ERROR(Text000);

                IF UseCheckNo = '' THEN
                    ERROR(Text001);

                IF TestPrint THEN
                    CurrReport.BREAK;

                IF NOT ReprintChecks THEN
                    CurrReport.BREAK;

                IF (GETFILTER("Line No.") <> '') OR (GETFILTER("Document No.") <> '') THEN
                    ERROR(
                      Text002, FIELDCAPTION("Line No."), FIELDCAPTION("Document No."));
                SETRANGE("Bank Payment Type", "Bank Payment Type"::"Computer Check");
                SETRANGE("Check Printed", TRUE);
            end;

            trigger OnAfterGetRecord()
            begin
                CheckManagement.VoidCheck(VoidGenJnlLine);
            end;
        }
        dataitem(GenJnlLine; "Gen. Journal Line")
        {
            DataItemTableView = sorting("Journal Template Name", "Journal Batch Name", "Posting Date", "Document No.");
            dataitem(CheckPages; Integer)
            {
                DataItemTableView = sorting(Number);
                DataItemLinkReference = GenJnlLine;
                column(CheckPagesGrp; 'CheckPages')
                {
                }
                column(CheckPages_CheckToAddr_1_; CheckToAddr[1])
                {
                }
                column(CheckPages_CheckDateText; CheckDateText)
                {
                }
                column(CheckNoText; CheckNoText)
                {
                }
                column(CheckNoLab; CheckNoLab)
                {
                }
                column(FoundLast; FoundLast)
                {
                }
                column(TotalLineAmount; TotalLineAmount)
                {
                }
                column(TotalLineDiscount; TotalLineDiscount)
                {
                }
                dataitem(PrintSettledLoop; Integer)
                {
                    DataItemTableView = sorting(Number);
                    DataItemLinkReference = CheckPages;
                    column(PrintSettledLoopGrp; 'PrintSettledLoop')
                    {
                    }
                    column(ShowPreprintedStub; ShowPreprintedStub)
                    {
                    }
                    column(DocumentNoLab; DocumentNoLab)
                    {
                    }
                    column(YourDocNoLab; YourDocNoLab)
                    {
                    }
                    column(DocumentDateLab; DocumentDateLab)
                    {
                    }
                    column(CurrencyCodeLab; CurrencyCodeLab)
                    {
                    }
                    column(AmountLab; AmountLab)
                    {
                    }
                    column(DiscountLab; DiscountLab)
                    {
                    }
                    column(NetTotalAmountLab; NetTotalAmountLab)
                    {
                    }
                    column(NetAmountLab; NetAmountLab)
                    {
                    }
                    column(TransportLab; TransportLab)
                    {
                    }
                    column(DocNo; DocNo)
                    {
                    }
                    column(ExtDocNo; ExtDocNo)
                    {
                    }
                    column(DocDate; DocDate)
                    {
                    }
                    column(CurrencyCode2; CurrencyCode2)
                    {
                    }
                    column(Amount; ABS(LineAmount + LineDiscount))
                    {
                    }
                    column(LineDiscount; ABS(LineDiscount))
                    {
                    }
                    column(NetAmount; ABS(LineAmount))
                    {
                    }
                    column(CurrentLineAmount; ABS(CurrentLineAmount))
                    {
                    }
                    column(TotalTransportLineDiscount; ABS(TotalLineDiscount - LineDiscount))
                    {
                    }
                    column(TotalTransportLineAmount; ABS(TotalLineAmount - LineAmount))
                    {
                    }
                    column(TotalTransportLineAmount2; ABS(TotalLineAmount - LineAmount2))
                    {
                    }
                    column(FirstPage; FirstPage)
                    {
                    }
                    trigger OnPreDataItem()
                    begin
                        IF NOT TestPrint THEN
                            IF FirstPage THEN BEGIN
                                FoundLast := TRUE;
                                CASE ApplyMethod OF
                                    ApplyMethod::OneLineOneEntry:
                                        FoundLast := FALSE;
                                    ApplyMethod::OneLineID:
                                        CASE BalancingType OF
                                            BalancingType::Customer:
                                                BEGIN
                                                    CustLedgEntry.RESET;
                                                    CustLedgEntry.SETCURRENTKEY("Customer No.", Open, Positive);
                                                    CustLedgEntry.SETRANGE("Customer No.", BalancingNo);
                                                    CustLedgEntry.SETRANGE(Open, TRUE);
                                                    CustLedgEntry.SETRANGE(Positive, TRUE);
                                                    CustLedgEntry.SETRANGE("Applies-to ID", GenJnlLine."Applies-to ID");
                                                    FoundLast := NOT CustLedgEntry.FIND('-');
                                                    IF FoundLast THEN BEGIN
                                                        CustLedgEntry.SETRANGE(Positive, FALSE);
                                                        FoundLast := NOT CustLedgEntry.FIND('-');
                                                        FoundNegative := TRUE;
                                                    END ELSE
                                                        FoundNegative := FALSE;
                                                END;
                                            BalancingType::Vendor:
                                                BEGIN
                                                    VendLedgEntry.RESET;
                                                    VendLedgEntry.SETCURRENTKEY("Vendor No.", Open, Positive);
                                                    VendLedgEntry.SETRANGE("Vendor No.", BalancingNo);
                                                    VendLedgEntry.SETRANGE(Open, TRUE);
                                                    VendLedgEntry.SETRANGE(Positive, TRUE);
                                                    VendLedgEntry.SETRANGE("Applies-to ID", GenJnlLine."Applies-to ID");
                                                    FoundLast := NOT VendLedgEntry.FIND('-');
                                                    IF FoundLast THEN BEGIN
                                                        VendLedgEntry.SETRANGE(Positive, FALSE);
                                                        FoundLast := NOT VendLedgEntry.FIND('-');
                                                        FoundNegative := TRUE;
                                                    END ELSE
                                                        FoundNegative := FALSE;
                                                END;
                                        END;
                                    ApplyMethod::MoreLinesOneEntry:
                                        FoundLast := FALSE;
                                END;
                            END
                            ELSE
                                FoundLast := FALSE;
                    end;

                    trigger OnAfterGetRecord()
                    begin
                        IF NOT TestPrint THEN BEGIN
                            IF FoundLast THEN BEGIN
                                IF RemainingAmount <> 0 THEN BEGIN
                                    DocType := Text015;
                                    DocNo := '';
                                    ExtDocNo := '';
                                    LineAmount := RemainingAmount;
                                    LineAmount2 := RemainingAmount;
                                    CurrentLineAmount := LineAmount2;
                                    LineDiscount := 0;
                                    RemainingAmount := 0;
                                END ELSE
                                    CurrReport.BREAK;
                            END ELSE BEGIN
                                CASE ApplyMethod OF
                                    ApplyMethod::OneLineOneEntry:
                                        BEGIN
                                            CASE BalancingType OF
                                                BalancingType::Customer:
                                                    BEGIN
                                                        CustLedgEntry.RESET;
                                                        CustLedgEntry.SETCURRENTKEY("Document No.");
                                                        CustLedgEntry.SETRANGE("Document Type", GenJnlLine."Applies-to Doc. Type");
                                                        CustLedgEntry.SETRANGE("Document No.", GenJnlLine."Applies-to Doc. No.");
                                                        CustLedgEntry.SETRANGE("Customer No.", BalancingNo);
                                                        CustLedgEntry.FIND('-');
                                                        CustUpdateAmounts(CustLedgEntry, RemainingAmount);
                                                    END;
                                                BalancingType::Vendor:
                                                    BEGIN
                                                        VendLedgEntry.RESET;
                                                        VendLedgEntry.SETCURRENTKEY("Document No.");
                                                        VendLedgEntry.SETRANGE("Document Type", GenJnlLine."Applies-to Doc. Type");
                                                        VendLedgEntry.SETRANGE("Document No.", GenJnlLine."Applies-to Doc. No.");
                                                        VendLedgEntry.SETRANGE("Vendor No.", BalancingNo);
                                                        VendLedgEntry.FIND('-');
                                                        VendUpdateAmounts(VendLedgEntry, RemainingAmount);
                                                    END;
                                            END;
                                            RemainingAmount := RemainingAmount - LineAmount2;
                                            CurrentLineAmount := LineAmount2;
                                            FoundLast := TRUE;
                                        END;
                                    ApplyMethod::OneLineID:
                                        BEGIN
                                            CASE BalancingType OF
                                                BalancingType::Customer:
                                                    BEGIN
                                                        CustUpdateAmounts(CustLedgEntry, RemainingAmount);
                                                        FoundLast := (CustLedgEntry.NEXT = 0) OR (RemainingAmount <= 0);
                                                        IF FoundLast AND NOT FoundNegative THEN BEGIN
                                                            CustLedgEntry.SETRANGE(Positive, FALSE);
                                                            FoundLast := NOT CustLedgEntry.FIND('-');
                                                            FoundNegative := TRUE;
                                                        END;
                                                    END;
                                                BalancingType::Vendor:
                                                    BEGIN
                                                        VendUpdateAmounts(VendLedgEntry, RemainingAmount);
                                                        FoundLast := (VendLedgEntry.NEXT = 0) OR (RemainingAmount <= 0);
                                                        IF FoundLast AND NOT FoundNegative THEN BEGIN
                                                            VendLedgEntry.SETRANGE(Positive, FALSE);
                                                            FoundLast := NOT VendLedgEntry.FIND('-');
                                                            FoundNegative := TRUE;
                                                        END;
                                                    END;
                                            END;
                                            RemainingAmount := RemainingAmount - LineAmount2;
                                            CurrentLineAmount := LineAmount2
                                        END;
                                    ApplyMethod::MoreLinesOneEntry:
                                        BEGIN
                                            CurrentLineAmount := GenJnlLine2.Amount;
                                            LineAmount2 := CurrentLineAmount;

                                            IF GenJnlLine2."Applies-to ID" <> '' THEN
                                                ERROR(
                                                  Text016 +
                                                  Text017);
                                            GenJnlLine2.TESTFIELD("Check Printed", FALSE);
                                            GenJnlLine2.TESTFIELD("Bank Payment Type", GenJnlLine2."Bank Payment Type"::"Computer Check");

                                            IF GenJnlLine2."Applies-to Doc. No." = '' THEN BEGIN
                                                DocType := Text015;
                                                DocNo := '';
                                                ExtDocNo := '';
                                                LineAmount := CurrentLineAmount;
                                                LineDiscount := 0;
                                            END ELSE BEGIN
                                                CASE BalancingType OF
                                                    BalancingType::"G/L Account":
                                                        BEGIN
                                                            DocType := FORMAT(GenJnlLine2."Document Type");
                                                            DocNo := GenJnlLine2."Document No.";
                                                            ExtDocNo := GenJnlLine2."External Document No.";
                                                            LineAmount := CurrentLineAmount;
                                                            LineDiscount := 0;
                                                        END;
                                                    BalancingType::Customer:
                                                        BEGIN
                                                            CustLedgEntry.RESET;
                                                            CustLedgEntry.SETCURRENTKEY("Document No.");
                                                            CustLedgEntry.SETRANGE("Document Type", GenJnlLine2."Applies-to Doc. Type");
                                                            CustLedgEntry.SETRANGE("Document No.", GenJnlLine2."Applies-to Doc. No.");
                                                            CustLedgEntry.SETRANGE("Customer No.", BalancingNo);
                                                            CustLedgEntry.FIND('-');
                                                            CustUpdateAmounts(CustLedgEntry, CurrentLineAmount);
                                                            LineAmount := CurrentLineAmount;
                                                        END;
                                                    BalancingType::Vendor:
                                                        BEGIN
                                                            VendLedgEntry.RESET;
                                                            VendLedgEntry.SETCURRENTKEY("Document No.");
                                                            VendLedgEntry.SETRANGE("Document Type", GenJnlLine2."Applies-to Doc. Type");
                                                            VendLedgEntry.SETRANGE("Document No.", GenJnlLine2."Applies-to Doc. No.");
                                                            VendLedgEntry.SETRANGE("Vendor No.", BalancingNo);
                                                            VendLedgEntry.FIND('-');
                                                            VendUpdateAmounts(VendLedgEntry, CurrentLineAmount);
                                                            LineAmount := CurrentLineAmount;
                                                        END;
                                                    BalancingType::"Bank Account":
                                                        BEGIN
                                                            DocType := FORMAT(GenJnlLine2."Document Type");
                                                            DocNo := GenJnlLine2."Document No.";
                                                            ExtDocNo := GenJnlLine2."External Document No.";
                                                            LineAmount := CurrentLineAmount;
                                                            LineDiscount := 0;
                                                        END;
                                                END;
                                            END;
                                            FoundLast := GenJnlLine2.NEXT = 0;
                                        END;
                                END;
                            END;

                            TotalLineAmount := TotalLineAmount + CurrentLineAmount;
                            TotalLineDiscount := TotalLineDiscount + LineDiscount;
                        END ELSE BEGIN
                            IF FoundLast THEN
                                CurrReport.BREAK;
                            FoundLast := TRUE;
                            DocType := Text018;
                            DocNo := Text010;
                            ExtDocNo := Text010;
                            LineAmount := 0;
                            LineDiscount := 0;
                        END;

                        IF DocNo = '' THEN
                            CurrencyCode2 := GenJnlLine."Currency Code";
                    end;

                    trigger OnPostDataItem()
                    begin

                    end;
                }
                dataitem(PrintCheck; Integer)
                {
                    DataItemTableView = sorting(Number);
                    DataItemLinkReference = CheckPages;
                    column(PrintCheckGrp; 'PrintCheck')
                    {
                    }
                    column(CompanyAddr_1_; CompanyAddr[1])
                    {
                    }
                    column(CompanyAddr_2_; CompanyAddr[2])
                    {
                    }
                    column(CompanyAddr_3_; CompanyAddr[3])
                    {
                    }
                    column(CompanyAddr_4_; CompanyAddr[4])
                    {
                    }
                    column(CompanyAddr_5_; CompanyAddr[5])
                    {
                    }
                    column(CompanyAddr_6_; CompanyAddr[6])
                    {
                    }
                    column(CompanyAddr_7_; CompanyAddr[7])
                    {
                    }
                    column(CompanyAddr_8_; CompanyAddr[8])
                    {
                    }
                    column(DescriptionLine_1_; DescriptionLine[1])
                    {
                    }
                    column(DescriptionLine_2_; DescriptionLine[2])
                    {
                    }
                    column(CheckToAddr_1_; CheckToAddr[1])
                    {
                    }
                    column(CheckToAddr_2_; CheckToAddr[2])
                    {
                    }
                    column(CheckToAddr_3_; CheckToAddr[3])
                    {
                    }
                    column(CheckToAddr_4_; CheckToAddr[4])
                    {
                    }
                    column(CheckToAddr_5_; CheckToAddr[5])
                    {
                    }
                    column(CheckDateText; CheckDateText)
                    {
                    }
                    column(CheckAmountText; CheckAmountText)
                    {
                    }
                    column(VoidText; VoidText)
                    {
                    }
                    column(TotalText; TotalText)
                    {
                    }
                    column(PrintCheck_TotalLineAmount; ABS(TotalLineAmount))
                    {
                    }
                    column(PrintCheck_CheckNoText; CheckNoText)
                    {
                    }
                    trigger OnPreDataItem()
                    begin

                    end;

                    trigger OnAfterGetRecord()
                    var
                        Decimals: Decimal;
                        xCurrencyFactor: Decimal;
                    begin
                        IF (NOT TestPrint) THEN BEGIN
                            WITH GenJnlLine DO BEGIN
                                CheckLedgEntry.INIT;
                                CheckLedgEntry."Bank Account No." := BankAcc2."No.";
                                CheckLedgEntry."Posting Date" := "Posting Date";
                                CheckLedgEntry."Document Type" := "Document Type";
                                CheckLedgEntry."Document No." := UseCheckNo;
                                CheckLedgEntry.Description := Description;
                                CheckLedgEntry."Bank Payment Type" := "Bank Payment Type";
                                CheckLedgEntry."Bal. Account Type" := BalancingType;
                                CheckLedgEntry."Bal. Account No." := BalancingNo;
                                //TWNPNR 20130129 Andrew (+)
                                CLEAR(xCurrencyFactor);
                                CheckLedgEntry."Currency Code" := "Currency Code";
                                xCurrencyFactor := "Currency Factor";
                                //TWNPNR 20130129 Andrew (-)
                                IF FoundLast THEN BEGIN
                                    CASE TRUE OF
                                        "Bal. Account No." <> '':
                                            IF TotalLineAmount < 0 THEN
                                                ERROR(
                                                  Text020,
                                                  UseCheckNo, TotalLineAmount);
                                        "Bal. Account No." = '':
                                            IF TotalLineAmount > 0 THEN
                                                ERROR(
                                                  Text066,
                                                  UseCheckNo, TotalLineAmount);
                                    END;
                                    CheckLedgEntry."Entry Status" := CheckLedgEntry."Entry Status"::Printed;
                                    CheckLedgEntry.Amount := ABS(TotalLineAmount);
                                END ELSE BEGIN
                                    CheckLedgEntry."Entry Status" := CheckLedgEntry."Entry Status"::Voided;
                                    CheckLedgEntry.Amount := 0;
                                END;
                                CheckLedgEntry."Check Date" := "Posting Date";
                                CheckLedgEntry."Check No." := UseCheckNo;
                                //TWNPNR 20130129 Andrew (+)
                                CheckManagement.InsertCheck(CheckLedgEntry, CheckLedgEntry."Currency Code", xCurrencyFactor, NoteType);
                                //TWNPNR 20130129 Andrew (-)

                                IF FoundLast THEN BEGIN
                                    IF BankAcc2."Currency Code" <> '' THEN
                                        Currency.GET(BankAcc2."Currency Code")
                                    ELSE
                                        Currency.InitRoundingPrecision;
                                    Decimals := CheckLedgEntry.Amount - ROUND(CheckLedgEntry.Amount, 1, '<');
                                    IF STRLEN(FORMAT(Decimals)) < STRLEN(FORMAT(Currency."Amount Rounding Precision")) THEN
                                        IF Decimals = 0 THEN
                                            CheckAmountText := FORMAT(CheckLedgEntry.Amount, 0, 0) +
                                              COPYSTR(FORMAT(0.01), 2, 1) +
                                              PADSTR('', STRLEN(FORMAT(Currency."Amount Rounding Precision")) - 2, '0')
                                        ELSE
                                            CheckAmountText := FORMAT(CheckLedgEntry.Amount, 0, 0) +
                                              PADSTR('', STRLEN(FORMAT(Currency."Amount Rounding Precision")) - STRLEN(FORMAT(Decimals)), '0')
                                    ELSE
                                        CheckAmountText := FORMAT(CheckLedgEntry.Amount, 0, 0);
                                    FormatNoText(DescriptionLine, CheckLedgEntry.Amount, BankAcc2."Currency Code");
                                    //TWNPNR 20130227 Andrew (+)
                                    DescriptionLine[2] := '';
                                    //TWNPNR 20130227 Andrew (-)
                                    VoidText := '';
                                END ELSE BEGIN
                                    CLEAR(CheckAmountText);
                                    CLEAR(DescriptionLine);
                                    DescriptionLine[1] := Text021;
                                    DescriptionLine[2] := DescriptionLine[1];
                                    VoidText := Text022;
                                END;
                            END;
                        END ELSE BEGIN
                            WITH GenJnlLine DO BEGIN
                                CheckLedgEntry.INIT;
                                CheckLedgEntry."Bank Account No." := BankAcc2."No.";
                                CheckLedgEntry."Posting Date" := "Posting Date";
                                CheckLedgEntry."Document No." := UseCheckNo;
                                CheckLedgEntry.Description := Text023;
                                CheckLedgEntry."Bank Payment Type" := "Bank Payment Type"::"Computer Check";
                                CheckLedgEntry."Entry Status" := CheckLedgEntry."Entry Status"::"Test Print";
                                CheckLedgEntry."Check Date" := "Posting Date";
                                CheckLedgEntry."Check No." := UseCheckNo;
                                //TWNPNR 20130129 Andrew (+)
                                CheckLedgEntry."Currency Code" := "Currency Code";
                                xCurrencyFactor := "Currency Factor";
                                //TWNPNR 20130129 Andrew (-)
                                //TWNPNR 20130129 Andrew (+)
                                CheckManagement.InsertCheck(CheckLedgEntry, CheckLedgEntry."Currency Code", xCurrencyFactor, NoteType);
                                //TWNPNR 20130129 Andrew (-)

                                CheckAmountText := Text024;
                                DescriptionLine[1] := Text025;
                                DescriptionLine[2] := DescriptionLine[1];
                                VoidText := Text022;
                            END;
                        END;

                        ChecksPrinted := ChecksPrinted + 1;
                        FirstPage := FALSE;
                    end;
                }
                trigger OnPreDataItem()
                begin
                    FirstPage := TRUE;
                    FoundLast := FALSE;
                    TotalLineAmount := 0;
                    TotalLineDiscount := 0;
                end;

                trigger OnAfterGetRecord()
                begin
                    IF FoundLast THEN
                        CurrReport.BREAK;

                    UseCheckNo := INCSTR(UseCheckNo);
                    IF NOT TestPrint THEN
                        CheckNoText := UseCheckNo
                    ELSE
                        CheckNoText := Text011;

                    IF NOT PreprintedStub THEN BEGIN
                        TotalText := Text019;
                        ShowPreprintedStub := FALSE;
                    END;
                end;

                trigger OnPostDataItem()
                begin
                    IF NOT TestPrint THEN BEGIN
                        IF UseCheckNo <> GenJnlLine."Document No." THEN BEGIN
                            GenJnlLine3.RESET;
                            GenJnlLine3.SETCURRENTKEY("Journal Template Name", "Journal Batch Name", "Posting Date", "Document No.");
                            GenJnlLine3.SETRANGE("Journal Template Name", GenJnlLine."Journal Template Name");
                            GenJnlLine3.SETRANGE("Journal Batch Name", GenJnlLine."Journal Batch Name");
                            GenJnlLine3.SETRANGE("Posting Date", GenJnlLine."Posting Date");
                            GenJnlLine3.SETRANGE("Document No.", UseCheckNo);
                            IF GenJnlLine3.FIND('-') THEN
                                GenJnlLine3.FIELDERROR("Document No.", STRSUBSTNO(Text013, UseCheckNo));
                        END;

                        IF ApplyMethod <> ApplyMethod::MoreLinesOneEntry THEN BEGIN
                            GenJnlLine3.RESET;
                            GenJnlLine3.SETRANGE("Journal Template Name", GenJnlLine."Journal Template Name");
                            GenJnlLine3.SETRANGE("Journal Batch Name", GenJnlLine."Journal Batch Name");
                            GenJnlLine3.SETRANGE("Document No.", GenJnlLine."Document No.");
                            IF GenJnlLine3.FIND('-') THEN
                                REPEAT
                                    GenJnlLine3."Document No." := UseCheckNo;
                                    GenJnlLine3."External Document No." := UseCheckNo;
                                    GenJnlLine3."Check Printed" := TRUE;
                                    GenJnlLine3.MODIFY;
                                UNTIL GenJnlLine3.NEXT = 0;
                        END ELSE BEGIN
                            IF GenJnlLine2.FIND('-') THEN BEGIN
                                HighestLineNo := GenJnlLine2."Line No.";
                                REPEAT
                                    IF GenJnlLine2."Line No." > HighestLineNo THEN
                                        HighestLineNo := GenJnlLine2."Line No.";
                                    GenJnlLine3 := GenJnlLine2;
                                    //GenJnlLine3.TESTFIELD("Posting No. Series",'');
                                    GenJnlLine3."Bal. Account No." := '';
                                    GenJnlLine3."Bank Payment Type" := GenJnlLine3."Bank Payment Type"::" ";
                                    GenJnlLine3."Document No." := UseCheckNo;
                                    GenJnlLine3."External Document No." := UseCheckNo;
                                    GenJnlLine3."Check Printed" := TRUE;
                                    GenJnlLine3.VALIDATE(Amount);
                                    GenJnlLine3.MODIFY;
                                UNTIL GenJnlLine2.NEXT = 0;
                            END;
                            GenJnlLine3.RESET;
                            GenJnlLine3 := GenJnlLine;
                            GenJnlLine3.SETRANGE("Journal Template Name", GenJnlLine."Journal Template Name");
                            GenJnlLine3.SETRANGE("Journal Batch Name", GenJnlLine."Journal Batch Name");
                            GenJnlLine3."Line No." := HighestLineNo;
                            IF GenJnlLine3.NEXT = 0 THEN
                                GenJnlLine3."Line No." := HighestLineNo + 10000
                            ELSE BEGIN
                                WHILE GenJnlLine3."Line No." = HighestLineNo + 1 DO BEGIN
                                    HighestLineNo := GenJnlLine3."Line No.";
                                    IF GenJnlLine3.NEXT = 0 THEN
                                        GenJnlLine3."Line No." := HighestLineNo + 20000;
                                END;
                                GenJnlLine3."Line No." := (GenJnlLine3."Line No." + HighestLineNo) DIV 2;
                            END;
                            GenJnlLine3.INIT;
                            GenJnlLine3.VALIDATE("Posting Date", GenJnlLine."Posting Date");
                            GenJnlLine3."Document Type" := GenJnlLine."Document Type";
                            GenJnlLine3."Document No." := UseCheckNo;
                            GenJnlLine3."External Document No." := UseCheckNo;
                            GenJnlLine3."Account Type" := GenJnlLine3."Account Type"::"Bank Account";
                            GenJnlLine3.VALIDATE("Account No.", BankAcc2."No.");
                            IF BalancingType <> BalancingType::"G/L Account" THEN
                                GenJnlLine3.Description := STRSUBSTNO(Text014, SELECTSTR(BalancingType + 1, Text062), BalancingNo);
                            GenJnlLine3.VALIDATE(Amount, -TotalLineAmount);
                            GenJnlLine3."Bank Payment Type" := GenJnlLine3."Bank Payment Type"::"Computer Check";
                            GenJnlLine3."Check Printed" := TRUE;
                            GenJnlLine3."Source Code" := GenJnlLine."Source Code";
                            GenJnlLine3."Reason Code" := GenJnlLine."Reason Code";
                            GenJnlLine3."Allow Zero-Amount Posting" := TRUE;
                            GenJnlLine3.INSERT;
                        END;
                    END;

                    BankAcc2."Last Check No." := UseCheckNo;
                    BankAcc2.MODIFY;

                    COMMIT;
                    CLEAR(CheckManagement);
                end;
            }
            trigger OnPreDataItem()
            var
                GenJnlDocNo: Code[20];
                GenJnlLineBalance: Record "Gen. Journal Line";
                BalanceLCY: Decimal;
            begin
                GenJnlLine.COPY(VoidGenJnlLine);
                CompanyInfo.GET;

                IF NOT TestPrint THEN BEGIN
                    FormatAddr.Company(CompanyAddr, CompanyInfo);
                    BankAcc2.GET(BankAcc2."No.");
                    BankAcc2.TESTFIELD(Blocked, FALSE);
                    COPY(VoidGenJnlLine);
                    SETRANGE("Bank Payment Type", "Bank Payment Type"::"Computer Check");
                    SETRANGE("Check Printed", FALSE);
                END ELSE BEGIN
                    CLEAR(CompanyAddr);
                    FOR i := 1 TO 5 DO
                        CompanyAddr[i] := Text003;
                END;
                ChecksPrinted := 0;

                SETRANGE("Account Type", GenJnlLine."Account Type"::"Fixed Asset");
                IF FIND('-') THEN
                    GenJnlLine.FIELDERROR("Account Type");
                SETRANGE("Account Type");

                GenJnlLineBalance.COPY(VoidGenJnlLine);
                GenJnlLineBalance.SETCURRENTKEY("Journal Template Name", "Journal Batch Name", "Line No.");
                SETFILTER("Bal. Account No.", '=%1', '');
                IF FIND('-') THEN BEGIN
                    REPEAT
                        IF (GenJnlDocNo <> "Document No.") THEN BEGIN
                            BalanceLCY := 0;
                            GenJnlLineBalance.SETRANGE("Document No.", "Document No.");
                            IF GenJnlLineBalance.FIND('-') THEN
                                REPEAT
                                    BalanceLCY += GenJnlLineBalance."Balance (LCY)";
                                UNTIL GenJnlLineBalance.NEXT = 0;
                            IF BalanceLCY <> 0 THEN
                                ERROR(Text065);
                            GenJnlDocNo := "Document No.";
                            GenJnlLineBalance.SETRANGE("Document No.");
                        END;
                    UNTIL NEXT = 0;
                    GenJnlLineBalance.SETRANGE("Line No.");
                    GenJnlLineBalance.SETRANGE("Bank Payment Type");
                    GenJnlLineBalance.SETRANGE("Check Printed");
                    GenJnlLineBalance.CALCSUMS("Balance (LCY)");
                    IF GenJnlLineBalance."Balance (LCY)" <> 0 THEN
                        ERROR(Text065);
                END;
                SETRANGE("Bal. Account No.");
            end;

            trigger OnAfterGetRecord()
            begin

            end;

            trigger OnPostDataItem()
            begin
                IF OneCheckPrVendor AND (GenJnlLine."Currency Code" <> '') AND
                   (GenJnlLine."Currency Code" <> Currency.Code)
                THEN BEGIN
                    Currency.GET(GenJnlLine."Currency Code");
                    Currency.TESTFIELD("Conv. LCY Rndg. Debit Acc.");
                    Currency.TESTFIELD("Conv. LCY Rndg. Credit Acc.");
                END;

                IF NOT TestPrint THEN BEGIN
                    IF Amount = 0 THEN
                        CurrReport.SKIP;

                    CASE TRUE OF
                        "Bal. Account No." <> '':
                            BEGIN
                                TESTFIELD("Bal. Account Type", "Bal. Account Type"::"Bank Account");
                                IF "Bal. Account No." <> BankAcc2."No." THEN
                                    CurrReport.SKIP;
                            END;
                        "Bal. Account No." = '':
                            BEGIN
                                IF ("Account Type" <> "Account Type"::"Bank Account") OR
                                   ("Account No." <> BankAcc2."No.") THEN
                                    CurrReport.SKIP;
                            END;
                    END;
                    TESTFIELD("Due Date");

                    CASE TRUE OF
                        ("Account No." <> '') AND ("Bal. Account No." <> ''):
                            BEGIN
                                BalancingType := "Account Type";
                                BalancingNo := "Account No.";
                                RemainingAmount := Amount;
                                IF OneCheckPrVendor THEN BEGIN
                                    ApplyMethod := ApplyMethod::MoreLinesOneEntry;
                                    GenJnlLine2.RESET;
                                    GenJnlLine2.SETCURRENTKEY("Journal Template Name", "Journal Batch Name", "Posting Date", "Document No.");
                                    GenJnlLine2.SETRANGE("Journal Template Name", "Journal Template Name");
                                    GenJnlLine2.SETRANGE("Journal Batch Name", "Journal Batch Name");
                                    GenJnlLine2.SETRANGE("Posting Date", "Posting Date");
                                    GenJnlLine2.SETRANGE("Document No.", "Document No.");
                                    GenJnlLine2.SETRANGE("Account Type", "Account Type");
                                    GenJnlLine2.SETRANGE("Account No.", "Account No.");
                                    GenJnlLine2.SETRANGE("Bal. Account Type", "Bal. Account Type");
                                    GenJnlLine2.SETRANGE("Bal. Account No.", "Bal. Account No.");
                                    GenJnlLine2.SETRANGE("Bank Payment Type", "Bank Payment Type");
                                    GenJnlLine2.FIND('-');
                                    RemainingAmount := 0;
                                END ELSE
                                    IF "Applies-to Doc. No." <> '' THEN
                                        ApplyMethod := ApplyMethod::OneLineOneEntry
                                    ELSE
                                        IF "Applies-to ID" <> '' THEN
                                            ApplyMethod := ApplyMethod::OneLineID
                                        ELSE
                                            ApplyMethod := ApplyMethod::Payment;
                            END;
                        ("Account No." <> '') AND ("Bal. Account No." = ''):
                            BEGIN
                                GenJnlLine2.RESET;
                                GenJnlLine2.SETCURRENTKEY("Journal Template Name", "Journal Batch Name", "Posting Date", "Document No.");
                                GenJnlLine2.SETRANGE("Journal Template Name", "Journal Template Name");
                                GenJnlLine2.SETRANGE("Journal Batch Name", "Journal Batch Name");
                                GenJnlLine2.SETRANGE("Posting Date", "Posting Date");
                                GenJnlLine2.SETRANGE("Document No.", "Document No.");
                                GenJnlLine2.SETFILTER("Line No.", '<>%1', "Line No.");
                                GenJnlLine2.MODIFYALL("Bank Payment Type", 0);
                                GenJnlLine2.FIND('-');
                                BalancingType := GenJnlLine2."Account Type";
                                BalancingNo := GenJnlLine2."Account No.";
                                RemainingAmount := Amount;
                                IF OneCheckPrVendor THEN BEGIN
                                    ApplyMethod := ApplyMethod::MoreLinesOneEntry;
                                    RemainingAmount := 0;
                                END ELSE
                                    IF "Applies-to Doc. No." <> '' THEN
                                        ApplyMethod := ApplyMethod::OneLineOneEntry
                                    ELSE
                                        IF "Applies-to ID" <> '' THEN
                                            ApplyMethod := ApplyMethod::OneLineID
                                        ELSE
                                            ApplyMethod := ApplyMethod::Payment;
                            END;
                        ELSE BEGIN
                                IF "Account No." = '' THEN
                                    FIELDERROR("Account No.", Text004)
                                ELSE
                                    FIELDERROR("Bal. Account No.", Text004);
                            END;
                    END;

                    CLEAR(CheckToAddr);
                    ContactText := '';
                    CLEAR(SalesPurchPerson);
                    CASE BalancingType OF
                        BalancingType::"G/L Account":
                            BEGIN
                                CheckToAddr[1] := GenJnlLine.Description;
                            END;
                        BalancingType::Customer:
                            BEGIN
                                Cust.GET(BalancingNo);
                                IF Cust.Blocked = Cust.Blocked::All THEN
                                    ERROR(Text064, Cust.FIELDCAPTION(Blocked), Cust.Blocked, Cust.TABLECAPTION, Cust."No.");
                                Cust.Contact := '';
                                FormatAddr.Customer(CheckToAddr, Cust);
                                IF BankAcc2."Currency Code" <> GenJnlLine."Currency Code" THEN
                                    ERROR(Text005);
                                IF Cust."Salesperson Code" <> '' THEN BEGIN
                                    ContactText := Text006;
                                    SalesPurchPerson.GET(Cust."Salesperson Code");
                                END;
                            END;
                        BalancingType::Vendor:
                            BEGIN
                                Vend.GET(BalancingNo);
                                IF Vend.Blocked IN [Vend.Blocked::All, Vend.Blocked::Payment] THEN
                                    ERROR(Text064, Vend.FIELDCAPTION(Blocked), Vend.Blocked, Vend.TABLECAPTION, Vend."No.");
                                Vend.Contact := '';
                                FormatAddr.Vendor(CheckToAddr, Vend);
                                IF BankAcc2."Currency Code" <> GenJnlLine."Currency Code" THEN
                                    ERROR(Text005);
                                IF Vend."Purchaser Code" <> '' THEN BEGIN
                                    ContactText := Text007;
                                    SalesPurchPerson.GET(Vend."Purchaser Code");
                                END;
                            END;
                        BalancingType::"Bank Account":
                            BEGIN
                                BankAcc.GET(BalancingNo);
                                BankAcc.TESTFIELD(Blocked, FALSE);
                                BankAcc.Contact := '';
                                FormatAddr.BankAcc(CheckToAddr, BankAcc);
                                IF BankAcc2."Currency Code" <> BankAcc."Currency Code" THEN
                                    ERROR(Text008);
                                IF BankAcc."Our Contact Code" <> '' THEN BEGIN
                                    ContactText := Text009;
                                    SalesPurchPerson.GET(BankAcc."Our Contact Code");
                                END;
                            END;
                    END;

                    CheckDateText := FORMAT(GenJnlLine."Posting Date", 0, 4);

                END ELSE BEGIN
                    IF ChecksPrinted > 0 THEN
                        CurrReport.BREAK;
                    BalancingType := BalancingType::Vendor;
                    BalancingNo := Text010;
                    CLEAR(CheckToAddr);
                    FOR i := 1 TO 5 DO
                        CheckToAddr[i] := Text003;
                    ContactText := '';
                    CLEAR(SalesPurchPerson);
                    CheckNoText := Text011;
                    CheckDateText := Text012;
                END;
            end;
        }
    }
    requestpage
    {
        layout
        {
            area(content)
            {
                field("Bank Account"; BankAcc2."No.")
                {
                    Caption = 'Bank Account';
                    TableRelation = "Bank Account";
                }
                field("Last Check No."; UseCheckNo)
                {
                    Caption = 'Last Check No.';
                }
                field("One Check per Vendor per Document No."; OneCheckPrVendor)
                {
                    Caption = 'One Check per Vendor per Document No.';
                    Visible = false;
                }
                field("Reprint Checks"; ReprintChecks)
                {
                    Caption = 'Reprint Checks';
                }
                field("Test Print"; TestPrint)
                {
                    Caption = 'Test Print';
                    Visible = false;
                }
                field("Preprinted Stub"; PreprintedStub)
                {
                    Caption = 'Preprinted Stub';
                    Visible = false;
                }
            }
        }
        actions
        {
            area(processing)
            {
            }
        }
    }
    trigger OnInitReport()
    begin
        CLEAR(NoteType);
        IF BankAcc2."No." <> '' THEN BEGIN
            IF BankAcc2.GET(BankAcc2."No.") THEN
                UseCheckNo := BankAcc2."Last Check No."
            ELSE BEGIN
                BankAcc2."No." := '';
                UseCheckNo := '';
            END;
        END;
    end;

    trigger OnPreReport()
    begin
        InitTextVariable();
    end;

    procedure FormatNoText(var NoText: array[2] of Text[80]; No: Decimal; CurrencyCode: Code[10])
    var
        PrintExponent: Boolean;
        Ones: Integer;
        Tens: Integer;
        Hundreds: Integer;
        Exponent: Integer;
        NoTextIndex: array[2] of Integer;
        CompanyInfo: Record "Company Information";
        Thusands: Integer;
    begin
        CLEAR(NoText);
        No := ROUND(No, 1);
        IF (CompanyInfo.GET) THEN BEGIN
            TCInitTextVariable;
            NoTextIndex[1] := 1;
            NoTextIndex[2] := 2;
            NoText[1] := '';
            Printed := FALSE;
            IF CurrencyCode <> '' THEN
                NoText[1] := CurrencyCode;

            IF No < 1 THEN BEGIN
                TCAddToNoText(NoText, NoTextIndex[1], PrintExponent, Text032);
                TCAddToNoText(NoText, NoTextIndex[2], PrintExponent, Text032);
            END ELSE BEGIN
                FOR Exponent := 4 DOWNTO 1 DO BEGIN
                    PrintExponent := FALSE;
                    Ones := No DIV POWER(10000, Exponent - 1);
                    Thusands := Ones DIV 1000;
                    Hundreds := (Ones MOD 1000) DIV 100;
                    Tens := (Ones MOD 100) DIV 10;
                    Ones := Ones MOD 10;
                    IF (Thusands > 9) THEN ERROR(Text003 + Text002);
                    //---------------------Thusands Process--------------------
                    IF Thusands > 0 THEN BEGIN
                        TCAddToNoText(NoText, NoTextIndex[1], PrintExponent, OnesText[Thusands]);
                        TCAddToNoText(NoText, NoTextIndex[1], PrintExponent, Text059);
                    END;
                    IF Thusands > 0 THEN
                        TCAddToNoText(NoText, NoTextIndex[2], PrintExponent, OnesText[Thusands])
                    ELSE
                        TCAddToNoText(NoText, NoTextIndex[2], PrintExponent, Text026);

                    //---------------------Hundreds Process--------------------
                    IF Hundreds > 0 THEN BEGIN
                        IF (Printed) AND (Thusands = 0) THEN TCAddToNoText(NoText, NoTextIndex[1], PrintExponent, Text026);
                        TCAddToNoText(NoText, NoTextIndex[1], PrintExponent, OnesText[Hundreds]);
                        TCAddToNoText(NoText, NoTextIndex[1], PrintExponent, Text027);
                    END;
                    IF Hundreds > 0 THEN
                        TCAddToNoText(NoText, NoTextIndex[2], PrintExponent, OnesText[Hundreds])
                    ELSE
                        TCAddToNoText(NoText, NoTextIndex[2], PrintExponent, Text026);

                    //---------------------Tens Process--------------------
                    IF Tens > 0 THEN BEGIN
                        IF (Printed) AND (Hundreds = 0) THEN TCAddToNoText(NoText, NoTextIndex[1], PrintExponent, Text026);
                        TCAddToNoText(NoText, NoTextIndex[1], PrintExponent, OnesText[Tens]);
                        TCAddToNoText(NoText, NoTextIndex[1], PrintExponent, Text041);
                    END;
                    IF Tens > 0 THEN
                        TCAddToNoText(NoText, NoTextIndex[2], PrintExponent, OnesText[Tens])
                    ELSE
                        TCAddToNoText(NoText, NoTextIndex[2], PrintExponent, Text026);

                    //---------------------Ones Process--------------------
                    IF Ones > 0 THEN BEGIN
                        IF (Printed) AND (Tens = 0) THEN TCAddToNoText(NoText, NoTextIndex[1], PrintExponent, Text026);
                        TCAddToNoText(NoText, NoTextIndex[1], PrintExponent, OnesText[Ones]);
                    END;
                    IF Ones > 0 THEN
                        TCAddToNoText(NoText, NoTextIndex[2], PrintExponent, OnesText[Ones])
                    ELSE
                        TCAddToNoText(NoText, NoTextIndex[2], PrintExponent, Text026);

                    IF PrintExponent AND (Exponent > 1) THEN
                        TCAddToNoText(NoText, NoTextIndex[1], PrintExponent, ExponentText[Exponent]);
                    No := No - (Thusands * 1000 + Hundreds * 100 + Tens * 10 + Ones) * POWER(10000, Exponent - 1);
                END;
            END;

            TCAddToNoText(NoText, NoTextIndex[1], PrintExponent, '元整');
        END;
    end;

    local procedure AddToNoText(var NoText: array[2] of Text[80]; var NoTextIndex: Integer; var PrintExponent: Boolean; AddText: Text[30])
    begin
        PrintExponent := TRUE;

        WHILE STRLEN(NoText[NoTextIndex] + ' ' + AddText) > MAXSTRLEN(NoText[1]) DO BEGIN
            NoTextIndex := NoTextIndex + 1;
            IF NoTextIndex > ARRAYLEN(NoText) THEN
                ERROR(Text029, AddText);
        END;

        NoText[NoTextIndex] := DELCHR(NoText[NoTextIndex] + ' ' + AddText, '<');
    end;

    local procedure CustUpdateAmounts(var CustLedgEntry2: Record "Cust. Ledger Entry"; RemainingAmount2: Decimal)
    begin
        IF (ApplyMethod = ApplyMethod::OneLineOneEntry) OR
     (ApplyMethod = ApplyMethod::MoreLinesOneEntry)
  THEN BEGIN
            GenJnlLine3.RESET;
            GenJnlLine3.SETCURRENTKEY(
              "Account Type", "Account No.", "Applies-to Doc. Type", "Applies-to Doc. No.");
            GenJnlLine3.SETRANGE("Account Type", GenJnlLine3."Account Type"::Customer);
            GenJnlLine3.SETRANGE("Account No.", CustLedgEntry2."Customer No.");
            GenJnlLine3.SETRANGE("Applies-to Doc. Type", CustLedgEntry2."Document Type");
            GenJnlLine3.SETRANGE("Applies-to Doc. No.", CustLedgEntry2."Document No.");
            IF ApplyMethod = ApplyMethod::OneLineOneEntry THEN
                GenJnlLine3.SETFILTER("Line No.", '<>%1', GenJnlLine."Line No.")
            ELSE
                GenJnlLine3.SETFILTER("Line No.", '<>%1', GenJnlLine2."Line No.");
            IF CustLedgEntry2."Document Type" <> CustLedgEntry2."Document Type"::" " THEN
                IF GenJnlLine3.FIND('-') THEN
                    GenJnlLine3.FIELDERROR(
                      "Applies-to Doc. No.",
                      STRSUBSTNO(
                        Text030,
                        CustLedgEntry2."Document Type", CustLedgEntry2."Document No.",
                        CustLedgEntry2."Customer No."));
        END;

        DocType := FORMAT(CustLedgEntry2."Document Type");
        DocNo := CustLedgEntry2."Document No.";
        ExtDocNo := CustLedgEntry2."External Document No.";
        DocDate := CustLedgEntry2."Posting Date";
        CurrencyCode2 := CustLedgEntry2."Currency Code";

        CustLedgEntry2.CALCFIELDS("Remaining Amount");

        LineAmount := -(CustLedgEntry2."Remaining Amount" - CustLedgEntry2."Remaining Pmt. Disc. Possible" -
          CustLedgEntry2."Accepted Payment Tolerance");
        LineAmount2 :=
          ROUND(
            ExchangeAmt(CustLedgEntry2."Posting Date", GenJnlLine."Currency Code", CurrencyCode2, LineAmount),
            Currency."Amount Rounding Precision");

        IF ((((CustLedgEntry2."Document Type" = CustLedgEntry2."Document Type"::Invoice) AND
             (LineAmount2 >= RemainingAmount2)) OR
            ((CustLedgEntry2."Document Type" = CustLedgEntry2."Document Type"::"Credit Memo") AND
             (LineAmount2 <= RemainingAmount2))) AND
            (GenJnlLine."Posting Date" <= CustLedgEntry2."Pmt. Discount Date")) OR
            CustLedgEntry2."Accepted Pmt. Disc. Tolerance"
        THEN BEGIN
            LineDiscount := -CustLedgEntry2."Remaining Pmt. Disc. Possible";
            IF CustLedgEntry2."Accepted Payment Tolerance" <> 0 THEN
                LineDiscount := LineDiscount - CustLedgEntry2."Accepted Payment Tolerance";
        END ELSE BEGIN
            IF RemainingAmount2 >=
               ROUND(
                -(ExchangeAmt(CustLedgEntry2."Posting Date", GenJnlLine."Currency Code", CurrencyCode2,
                  CustLedgEntry2."Remaining Amount")), Currency."Amount Rounding Precision")
            THEN
                LineAmount2 :=
                  ROUND(
                    -(ExchangeAmt(CustLedgEntry2."Posting Date", GenJnlLine."Currency Code", CurrencyCode2,
                      CustLedgEntry2."Remaining Amount")), Currency."Amount Rounding Precision")
            ELSE BEGIN
                LineAmount2 := RemainingAmount2;
                LineAmount :=
                  ROUND(
                    ExchangeAmt(CustLedgEntry2."Posting Date", CurrencyCode2, GenJnlLine."Currency Code",
                    LineAmount2), Currency."Amount Rounding Precision");
            END;
            LineDiscount := 0;
        END;
    end;

    local procedure VendUpdateAmounts(var VendLedgEntry2: Record "Vendor Ledger Entry"; RemainingAmount2: Decimal)
    begin
        IF (ApplyMethod = ApplyMethod::OneLineOneEntry) OR
    (ApplyMethod = ApplyMethod::MoreLinesOneEntry)
 THEN BEGIN
            GenJnlLine3.RESET;
            GenJnlLine3.SETCURRENTKEY(
              "Account Type", "Account No.", "Applies-to Doc. Type", "Applies-to Doc. No.");
            GenJnlLine3.SETRANGE("Account Type", GenJnlLine3."Account Type"::Vendor);
            GenJnlLine3.SETRANGE("Account No.", VendLedgEntry2."Vendor No.");
            GenJnlLine3.SETRANGE("Applies-to Doc. Type", VendLedgEntry2."Document Type");
            GenJnlLine3.SETRANGE("Applies-to Doc. No.", VendLedgEntry2."Document No.");
            IF ApplyMethod = ApplyMethod::OneLineOneEntry THEN
                GenJnlLine3.SETFILTER("Line No.", '<>%1', GenJnlLine."Line No.")
            ELSE
                GenJnlLine3.SETFILTER("Line No.", '<>%1', GenJnlLine2."Line No.");
            IF VendLedgEntry2."Document Type" <> VendLedgEntry2."Document Type"::" " THEN
                IF GenJnlLine3.FIND('-') THEN
                    GenJnlLine3.FIELDERROR(
                      "Applies-to Doc. No.",
                      STRSUBSTNO(
                        Text031,
                        VendLedgEntry2."Document Type", VendLedgEntry2."Document No.",
                        VendLedgEntry2."Vendor No."));
        END;

        DocType := FORMAT(VendLedgEntry2."Document Type");
        DocNo := VendLedgEntry2."Document No.";
        ExtDocNo := VendLedgEntry2."External Document No.";
        DocDate := VendLedgEntry2."Posting Date";
        CurrencyCode2 := VendLedgEntry2."Currency Code";
        VendLedgEntry2.CALCFIELDS("Remaining Amount");

        LineAmount := -(VendLedgEntry2."Remaining Amount" - VendLedgEntry2."Remaining Pmt. Disc. Possible" -
          VendLedgEntry2."Accepted Payment Tolerance");

        LineAmount2 :=
          ROUND(
            ExchangeAmt(VendLedgEntry2."Posting Date", GenJnlLine."Currency Code", CurrencyCode2, LineAmount),
            Currency."Amount Rounding Precision");

        IF ((((VendLedgEntry2."Document Type" = VendLedgEntry2."Document Type"::Invoice) AND
              (LineAmount2 <= RemainingAmount2)) OR
             ((VendLedgEntry2."Document Type" = VendLedgEntry2."Document Type"::"Credit Memo") AND
              (LineAmount2 >= RemainingAmount2))) AND
           (GenJnlLine."Posting Date" <= VendLedgEntry2."Pmt. Discount Date")) OR
            VendLedgEntry2."Accepted Pmt. Disc. Tolerance"
        THEN BEGIN
            LineDiscount := -VendLedgEntry2."Remaining Pmt. Disc. Possible";
            IF VendLedgEntry2."Accepted Payment Tolerance" <> 0 THEN
                LineDiscount := LineDiscount - VendLedgEntry2."Accepted Payment Tolerance";
        END ELSE BEGIN
            IF RemainingAmount2 >=
                ROUND(
                 -(ExchangeAmt(VendLedgEntry2."Posting Date", GenJnlLine."Currency Code", CurrencyCode2,
                   VendLedgEntry2."Amount to Apply")), Currency."Amount Rounding Precision")
             THEN BEGIN
                LineAmount2 :=
                  ROUND(
                    -(ExchangeAmt(VendLedgEntry2."Posting Date", GenJnlLine."Currency Code", CurrencyCode2,
                      VendLedgEntry2."Amount to Apply")), Currency."Amount Rounding Precision");
                LineAmount :=
                  ROUND(
                    ExchangeAmt(VendLedgEntry2."Posting Date", CurrencyCode2, GenJnlLine."Currency Code",
                    LineAmount2), Currency."Amount Rounding Precision");
            END ELSE BEGIN
                LineAmount2 := RemainingAmount2;
                LineAmount :=
                  ROUND(
                    ExchangeAmt(VendLedgEntry2."Posting Date", CurrencyCode2, GenJnlLine."Currency Code",
                    LineAmount2), Currency."Amount Rounding Precision");
            END;
            LineDiscount := 0;
        END;
    end;

    procedure InitTextVariable()
    begin
        OnesText[1] := Text032;
        OnesText[2] := Text033;
        OnesText[3] := Text034;
        OnesText[4] := Text035;
        OnesText[5] := Text036;
        OnesText[6] := Text037;
        OnesText[7] := Text038;
        OnesText[8] := Text039;
        OnesText[9] := Text040;
        OnesText[10] := Text041;
        OnesText[11] := Text042;
        OnesText[12] := Text043;
        OnesText[13] := Text044;
        OnesText[14] := Text045;
        OnesText[15] := Text046;
        OnesText[16] := Text047;
        OnesText[17] := Text048;
        OnesText[18] := Text049;
        OnesText[19] := Text050;

        TensText[1] := '';
        TensText[2] := Text051;
        TensText[3] := Text052;
        TensText[4] := Text053;
        TensText[5] := Text054;
        TensText[6] := Text055;
        TensText[7] := Text056;
        TensText[8] := Text057;
        TensText[9] := Text058;

        ExponentText[1] := '';
        ExponentText[2] := Text059;
        ExponentText[3] := Text060;
        ExponentText[4] := Text061;
    end;

    procedure InitializeRequest(BankAcc: Code[20]; LastCheckNo: Code[20]; NewOneCheckPrVend: Boolean; NewReprintChecks: Boolean; NewTestPrint: Boolean; NewPreprintedStub: Boolean)
    begin
        IF BankAcc <> '' THEN
            IF BankAcc2.GET(BankAcc) THEN BEGIN
                UseCheckNo := LastCheckNo;
                OneCheckPrVendor := NewOneCheckPrVend;
                ReprintChecks := NewReprintChecks;
                TestPrint := NewTestPrint;
                PreprintedStub := NewPreprintedStub;
            END;
    end;

    procedure ExchangeAmt(PostingDate: Date; CurrencyCode: Code[10]; CurrencyCode2: Code[10]; Amount: Decimal) Amount2: Decimal
    begin
        IF (CurrencyCode <> '') AND (CurrencyCode2 = '') THEN
            Amount2 :=
              CurrencyExchangeRate.ExchangeAmtLCYToFCY(
                PostingDate, CurrencyCode, Amount, CurrencyExchangeRate.ExchangeRate(PostingDate, CurrencyCode))
        ELSE
            IF (CurrencyCode = '') AND (CurrencyCode2 <> '') THEN
                Amount2 :=
                  CurrencyExchangeRate.ExchangeAmtFCYToLCY(
                    PostingDate, CurrencyCode2, Amount, CurrencyExchangeRate.ExchangeRate(PostingDate, CurrencyCode2))
            ELSE
                IF (CurrencyCode <> '') AND (CurrencyCode2 <> '') AND (CurrencyCode <> CurrencyCode2) THEN
                    Amount2 := CurrencyExchangeRate.ExchangeAmtFCYToFCY(PostingDate, CurrencyCode2, CurrencyCode, Amount)
                ELSE
                    Amount2 := Amount;
    end;

    procedure SetNoteType(xType: Code[20])
    begin
        IF xType = 'NP' THEN BEGIN
            NoteType := NoteType::NP;
        END ELSE
            IF xType = 'NR' THEN BEGIN
                NoteType := NoteType::NR;
            END;
    end;

    procedure TCAddToNoText(var NoText: array[2] of Text[80]; var NoTextIndex: Integer; var PrintExponent: Boolean; AddText: Text[30])
    begin
        IF NoTextIndex = 1 THEN BEGIN
            PrintExponent := TRUE;
            Printed := TRUE;
        END;
        WHILE STRLEN(NoText[NoTextIndex] + AddText) > MAXSTRLEN(NoText[1]) DO BEGIN
            NoTextIndex := NoTextIndex + 1;
            IF NoTextIndex > ARRAYLEN(NoText) THEN
                ERROR(Text029, AddText);
        END;

        NoText[NoTextIndex] := DELCHR(NoText[NoTextIndex] + AddText, '<');
    end;

    procedure TCInitTextVariable()
    begin
        OnesText[1] := Text032;
        OnesText[2] := Text033;
        OnesText[3] := Text034;
        OnesText[4] := Text035;
        OnesText[5] := Text036;
        OnesText[6] := Text037;
        OnesText[7] := Text038;
        OnesText[8] := Text039;
        OnesText[9] := Text040;
        OnesText[10] := Text041;


        ExponentText[1] := '';
        ExponentText[2] := Text067;
        ExponentText[3] := Text068;
        ExponentText[4] := Text069;
        //MaxLineNo:=4;

    end;

    var
        CompanyInfo: Record "Company Information";
        SalesPurchPerson: Record "Salesperson/Purchaser";
        GenJnlLine2: Record "Gen. Journal Line";
        GenJnlLine3: Record "Gen. Journal Line";
        Cust: Record Customer;
        CustLedgEntry: Record "Cust. Ledger Entry";
        Vend: Record Vendor;
        VendLedgEntry: Record "Vendor Ledger Entry";
        BankAcc: Record "Bank Account";
        BankAcc2: Record "Bank Account";
        CheckLedgEntry: Record "Check Ledger Entry";
        Currency: Record Currency;
        FormatAddr: Codeunit "Format Address";
        CheckManagement: Codeunit "LocalizedCheckManagement";
        CompanyAddr: array[8] of Text[50];
        CheckToAddr: array[8] of Text[50];
        OnesText: array[20] of Text[30];
        TensText: array[10] of Text[30];
        ExponentText: array[5] of Text[30];
        BalancingType: Option "G/L Account","Customer","Vendor","Bank Account";
        BalancingNo: Code[20];
        ContactText: Text[30];
        CheckNoText: Text[30];
        CheckDateText: Text[30];
        CheckAmountText: Text[30];
        DescriptionLine: array[2] of Text[80];
        DocType: Text[30];
        DocNo: Text[30];
        ExtDocNo: Text[30];
        VoidText: Text[30];
        LineAmount: Decimal;
        LineDiscount: Decimal;
        TotalLineAmount: Decimal;
        TotalLineDiscount: Decimal;
        RemainingAmount: Decimal;
        CurrentLineAmount: Decimal;
        UseCheckNo: Code[20];
        FoundLast: Boolean;
        ReprintChecks: Boolean;
        TestPrint: Boolean;
        FirstPage: Boolean;
        OneCheckPrVendor: Boolean;
        FoundNegative: Boolean;
        ApplyMethod: Option "Payment","OneLineOneEntry","OneLineID","MoreLinesOneEntry";
        ChecksPrinted: Integer;
        HighestLineNo: Integer;
        PreprintedStub: Boolean;
        TotalText: Text[10];
        DocDate: Date;
        i: Integer;
        CurrencyCode2: Code[10];
        NetAmount: Text[30];
        CurrencyExchangeRate: Record "Currency Exchange Rate";
        LineAmount2: Decimal;
        GLSetup: Record "General Ledger Setup";
        NPBankSetup: Record "Bank Check Acc. Setup";
        NoteType: Option "NP","NR";
        Printed: Boolean;
        ShowPreprintedStub: Boolean;
        Text000: Label 'Preview is not allowed.';
        Text001: Label 'Last Check No. must be filled in.';
        Text002: Label 'Filters on %1 and %2 are not allowed.';
        Text003: Label 'XXXXXXXXXXXXXXXX';
        Text004: Label 'must be entered.';
        Text005: Label 'The Bank Account and the General Journal Line must have the same currency.';
        Text006: Label 'Salesperson';
        Text007: Label 'Purchaser';
        Text008: Label 'Both Bank Accounts must have the same currency.';
        Text009: Label 'Our Contact';
        Text010: Label 'XXXXXXXXXX';
        Text011: Label 'XXXX';
        Text012: Label 'XX.XXXXXXXXXX.XXXX';
        Text013: Label '%1 already exists.';
        Text014: Label 'Check for %1 %2';
        Text015: Label 'Payment';
        Text016: Label 'In the Check report, One Check per Vendor and Document No.\';
        Text017: Label 'must not be activated when Applies-to ID is specified in the journal lines.';
        Text018: Label 'XXX';
        Text019: Label 'Total';
        Text020: Label 'The total amount of check %1 is %2. The amount must be positive.';
        Text021: Label 'VOID VOID VOID VOID VOID VOID VOID VOID VOID VOID VOID VOID VOID VOID VOID VOID';
        Text022: Label 'NON-NEGOTIABLE';
        Text023: Label 'Test print';
        Text024: Label 'XXXX.XX';
        Text025: Label 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX';
        Text026: Label 'ZERO';
        Text027: Label 'HUNDRED';
        Text028: Label 'AND';
        Text029: Label '%1 results in a written number that is too long.';
        Text030: Label ' is already applied to %1 %2 for customer %3.';
        Text031: Label ' is already applied to %1 %2 for vendor %3.';
        Text032: Label 'ONE';
        Text033: Label 'TWO';
        Text034: Label 'THREE';
        Text035: Label 'FOUR';
        Text036: Label 'FIVE';
        Text037: Label 'SIX';
        Text038: Label 'SEVEN';
        Text039: Label 'EIGHT';
        Text040: Label 'NINE';
        Text041: Label 'TEN';
        Text042: Label 'ELEVEN';
        Text043: Label 'TWELVE';
        Text044: Label 'THIRTEEN';
        Text045: Label 'FOURTEEN';
        Text046: Label 'FIFTEEN';
        Text047: Label 'SIXTEEN';
        Text048: Label 'SEVENTEEN';
        Text049: Label 'EIGHTEEN';
        Text050: Label 'NINETEEN';
        Text051: Label 'TWENTY';
        Text052: Label 'THIRTY';
        Text053: Label 'FORTY';
        Text054: Label 'FIFTY';
        Text055: Label 'SIXTY';
        Text056: Label 'SEVENTY';
        Text057: Label 'EIGHTY';
        Text058: Label 'NINETY';
        Text059: Label 'THOUSAND';
        Text060: Label 'MILLION';
        Text061: Label 'BILLION';
        Text062: Label 'G/L Account,Customer,Vendor,Bank Account';
        Text063: Label 'Net Amount %1';
        Text064: Label '%1 must not be %2 for %3 %4.';
        Text065: Label '日記帳結餘不為零';
        Text066: Label 'The total amount of check %1 is %2. The amount must be negative.';
        Text067: Label '萬';
        Text068: Label '億';
        Text069: Label '兆';
        Text070: Label 'Table 79: ';
        DocumentNoLab: Label 'Document No.';
        YourDocNoLab: Label 'Your Doc. No.';
        DocumentDateLab: Label 'Document Date';
        CurrencyCodeLab: Label 'Currency Code';
        AmountLab: Label 'Amount';
        DiscountLab: Label 'Discount';
        NetTotalAmountLab: Label 'Net Amount';
        NetAmountLab: Label 'Net Amount';
        TransportLab: Label 'Transport';
        CheckNoLab: Label 'Check No.';

}
