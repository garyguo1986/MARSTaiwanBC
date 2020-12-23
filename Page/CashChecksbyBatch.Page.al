page 50017 "Cash Checks by Batch"
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

    Caption = 'Cash Checks by Batch';
    PageType = StandardDialog;

    layout
    {
        area(content)
        {
            field(CashDate; CashDate)
            {
                Caption = 'Cash Date';
            }
            field(CurrencyCode; CurrencyCode)
            {
                Caption = 'Currency Code';
            }
            field(CurrentExchRate; CurrentExchRate)
            {
                Caption = 'Exchange Rate Amount';
                Editable = CurrentExchRateEDITABLE;
            }
            field(RefExchRate; RefExchRate)
            {
                Caption = 'Relational Exch. Rate Amount';
                Editable = RefExchRateEDITABLE;
            }
            field("Relational Currency Code"; ShowCurrencyCode(RefCurrencyCode, TRUE))
            {
                Caption = 'Relational Currency Code';
            }
        }
    }

    actions
    {
    }

    trigger OnInit()
    begin
        GLSetup.GET;
    end;

    trigger OnOpenPage()
    begin
        InitForm;
    end;

    var
        CurrExchRate: Record "Currency Exchange Rate";
        GLSetup: Record "General Ledger Setup";
        CheckLedgerEntry: Record "Check Ledger Entry";
        CashDate: Date;
        CurrencyCode: Code[20];
        CurrencyCode2: Code[10];
        CurrentExchRate: Decimal;
        CurrentExchRate2: Decimal;
        RefExchRate2: Decimal;
        RefCurrencyCode: Code[10];
        RefCurrencyCode2: Code[10];
        RefExchRate: Decimal;
        Fix: Option;
        Fix2: Option;
        CurrencyFactor: Decimal;
        CurrencyDate: Date;
        Text000: Label 'Cash Date must not be before the original %1.';
        Text001: Label '%1 No.';
        Text002: Label 'The value must be greater than 0';
        Text003: Label 'The %1 field is not set up properly in the Currrency Exchange Rates window. ';
        Text004: Label 'For %2 or the currency set up in the %3 field, the %1 field should be set to both.';
        [InDataSet]
        CurrentExchRateEDITABLE: Boolean;
        [InDataSet]
        RefExchRateEDITABLE: Boolean;

    [Scope('OnPrem')]
    procedure SetCheckLedgerEntry(var NewCheckLedgerEntry: Record "Check Ledger Entry")
    begin
        CheckLedgerEntry.COPY(NewCheckLedgerEntry);
    end;

    [Scope('OnPrem')]
    procedure GetCashDate(): Date
    begin
        EXIT(CashDate);
    end;

    [Scope('OnPrem')]
    procedure GetCurrencyFactor(): Decimal
    begin
        EXIT(CurrencyFactor)
    end;

    [Scope('OnPrem')]
    procedure InitForm()
    var
        DetailedCheckEntry: Record "Detailed Check Entry";
    begin
        DetailedCheckEntry.SETRANGE("Check Entry No", CheckLedgerEntry."Entry No.");
        DetailedCheckEntry.FIND('-');
        CurrencyFactor := DetailedCheckEntry."Currency Factor";
        CurrencyDate := DetailedCheckEntry."Currency Date";
        IF DetailedCheckEntry."Currency Code" = '' THEN BEGIN
            CurrencyCode := ShowCurrencyCode('', TRUE);
            CurrentExchRate := 1;
            CurrentExchRateEDITABLE := FALSE;
            RefExchRate := 1;
            RefExchRateEDITABLE := FALSE;
            EXIT;
        END;
        WITH CurrExchRate DO BEGIN
            SETRANGE("Currency Code", DetailedCheckEntry."Currency Code");
            SETRANGE("Starting Date", 0D, CurrencyDate);
            FIND('+');
            CurrencyCode := "Currency Code";
            CurrentExchRate := "Exchange Rate Amount";
            RefExchRate := "Relational Exch. Rate Amount";
            RefCurrencyCode := "Relational Currency Code";
            Fix := "Fix Exchange Rate Amount";
            SETRANGE("Currency Code", RefCurrencyCode);
            SETRANGE("Starting Date", 0D, CurrencyDate);
            IF FIND('+') THEN BEGIN
                CurrencyCode2 := "Currency Code";
                CurrentExchRate2 := "Exchange Rate Amount";
                RefExchRate2 := "Relational Exch. Rate Amount";
                RefCurrencyCode2 := "Relational Currency Code";
                Fix2 := "Fix Exchange Rate Amount";
            END;

            CASE Fix OF
                "Fix Exchange Rate Amount"::Currency:
                    BEGIN
                        CurrentExchRateEDITABLE := FALSE;
                        RefExchRateEDITABLE := TRUE;
                        IF RefCurrencyCode = '' THEN
                            RefExchRate := CurrentExchRate / CurrencyFactor
                        ELSE
                            RefExchRate := (CurrentExchRate * CurrentExchRate2) / (CurrencyFactor * RefExchRate2);
                    END;
                "Fix Exchange Rate Amount"::"Relational Currency":
                    BEGIN
                        CurrentExchRateEDITABLE := TRUE;
                        RefExchRateEDITABLE := FALSE;
                        IF RefCurrencyCode = '' THEN
                            CurrentExchRate := CurrencyFactor * RefExchRate
                        ELSE
                            CurrentExchRate := (RefExchRate * RefExchRate2 * CurrencyFactor) / CurrentExchRate2;
                    END;
                "Fix Exchange Rate Amount"::Both:
                    BEGIN
                        CurrentExchRateEDITABLE := FALSE;
                        RefExchRateEDITABLE := FALSE;
                    END;
            END;

            IF RefCurrencyCode <> '' THEN BEGIN
                IF (Fix <> "Fix Exchange Rate Amount"::Both) AND (Fix2 <> "Fix Exchange Rate Amount"::Both) THEN
                    ERROR(
                      Text003 +
                      Text004,
                      CurrExchRate.FIELDCAPTION("Fix Exchange Rate Amount"), CurrencyCode,
                      CurrExchRate.FIELDCAPTION("Relational Currency Code"));
                CASE Fix2 OF
                    "Fix Exchange Rate Amount"::Currency:
                        BEGIN
                            RefExchRate2 := (CurrentExchRate * CurrentExchRate2) / (CurrencyFactor * RefExchRate);
                        END;
                    "Fix Exchange Rate Amount"::"Relational Currency":
                        BEGIN
                            CurrentExchRate2 := (CurrencyFactor * RefExchRate * RefExchRate2) / CurrentExchRate;
                        END;
                    "Fix Exchange Rate Amount"::Both:
                        ;
                END;
            END;
        END;
    end;

    [Scope('OnPrem')]
    procedure ShowCurrencyCode(ShowCurrency: Code[10]; DoShow: Boolean): Code[10]
    begin
        IF NOT DoShow THEN
            EXIT('');
        IF ShowCurrency = '' THEN
            EXIT(GLSetup."LCY Code")
        ELSE
            EXIT(ShowCurrency);
    end;
}

