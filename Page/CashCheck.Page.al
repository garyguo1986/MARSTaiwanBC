page 50003 "Cash Check"
{

    Caption = 'Cash Check';
    PageType = StandardDialog;

    layout
    {
        area(content)
        {
            field("Bank Account No."; CheckLedgerEntry."Bank Account No.")
            {
                Caption = 'Bank Account No.';
                Editable = false;
                ApplicationArea = All;
            }
            field("Check No."; CheckLedgerEntry."Check No.")
            {
                Caption = 'Check No.';
                Editable = false;
                ApplicationArea = All;
            }
            field("Bal. Account No."; CheckLedgerEntry."Bal. Account No.")
            {
                Caption = 'Bal. Account No.';
                Editable = false;
                ApplicationArea = All;
            }
            field(Amount; CheckLedgerEntry.Amount)
            {
                Caption = 'Amount';
                Editable = false;
                ApplicationArea = All;
            }
            field("Check Date"; CheckLedgerEntry."Check Date")
            {
                Caption = 'Check Date';
                Editable = false;
                ApplicationArea = All;
            }
            field("Cash Date"; CashDate)
            {
                Caption = 'Cash Date';
                ApplicationArea = All;
                trigger OnValidate()
                begin
                    if CashDate < CheckLedgerEntry."Check Date" then
                        Error(Text000, CheckLedgerEntry.FieldCaption("Check Date"));
                end;
            }
            field("Currency Code"; CurrencyCode)
            {
                Caption = 'Currency Code';
                Editable = false;
                ApplicationArea = All;
            }
            field("Exchange Rate Amount"; CurrentExchRate)
            {
                Caption = 'Exchange Rate Amount';
                Editable = CurrentExchRateEditable;
                ApplicationArea = All;
                trigger OnValidate()
                begin
                    IF CurrentExchRate <= 0 THEN
                        ERROR(Text000);
                    IF RefCurrencyCode = '' THEN
                        CurrencyFactor := CurrentExchRate / RefExchRate
                    ELSE
                        CurrencyFactor := (CurrentExchRate * CurrentExchRate2) / (RefExchRate * RefExchRate2);
                end;
            }
            field("Relational Exch. Rate Amount"; RefExchRate)
            {
                Caption = 'Relational Exch. Rate Amount';
                Editable = RefExchRateEditable;
                ApplicationArea = All;
                trigger OnValidate()
                begin
                    IF RefExchRate <= 0 THEN
                        ERROR(Text000);
                    IF RefCurrencyCode = '' THEN
                        CurrencyFactor := CurrentExchRate / RefExchRate
                    ELSE
                        CurrencyFactor := (CurrentExchRate * CurrentExchRate2) / (RefExchRate * RefExchRate2);
                end;
            }
            field("Relational Currency Code"; ShowCurrencyCode(RefCurrencyCode, TRUE))
            {
                Caption = 'Relational Currency Code';
                Editable = false;
                ApplicationArea = All;
            }
        }
    }
    trigger OnInit()
    begin
        GLSetup.Get();
    end;

    trigger OnOpenPage()
    begin
        with CheckLedgerEntry do begin
            CashDate := "Check Date";
        end;
        InitForm();
    end;

    procedure SetCheckLedgerEntry(var NewCheckLedgerEntry: Record "Check Ledger Entry")
    begin
        CheckLedgerEntry := NewCheckLedgerEntry;
    end;

    procedure GetCashDate(): Date
    begin
        exit(CashDate);
    end;

    procedure GetCurrencyFactor(): Decimal
    begin
        EXIT(CurrencyFactor);
    end;

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
            CurrentExchRateEditable := CurrentExchRate <> 1;
            RefExchRate := 1;
            RefExchRateEditable := RefExchRate <> 1;
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
                        CurrentExchRateEditable := FALSE;
                        RefExchRateEditable := FALSE;
                        IF RefCurrencyCode = '' THEN
                            RefExchRate := CurrentExchRate / CurrencyFactor
                        ELSE
                            RefExchRate := (CurrentExchRate * CurrentExchRate2) / (CurrencyFactor * RefExchRate2);
                    END;
                "Fix Exchange Rate Amount"::"Relational Currency":
                    BEGIN
                        CurrentExchRateEditable := TRUE;
                        RefExchRateEditable := FALSE;
                        IF RefCurrencyCode = '' THEN
                            CurrentExchRate := CurrencyFactor * RefExchRate
                        ELSE
                            CurrentExchRate := (RefExchRate * RefExchRate2 * CurrencyFactor) / CurrentExchRate2;
                    END;
                "Fix Exchange Rate Amount"::Both:
                    BEGIN
                        CurrentExchRateEditable := FALSE;
                        RefExchRateEditable := FALSE;
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

    procedure ShowCurrencyCode(ShowCurrency: Code[10]; DoShow: Boolean): Code[10]
    begin
        IF NOT DoShow THEN
            EXIT('');
        IF ShowCurrency = '' THEN
            EXIT(GLSetup."LCY Code")
        ELSE
            EXIT(ShowCurrency);

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
        [InDataSet]
        CurrentExchRateEditable: Boolean;
        [InDataSet]
        RefExchRateEditable: Boolean;
        Text000: Label 'Cash Date must not be before the original %1.';
        Text001: Label '%1 No.';
        Text002: Label 'The value must be greater than 0';
        Text003: Label 'The %1 field is not set up properly in the Currrency Exchange Rates window. ';
        Text004: Label 'For %2 or the currency set up in the %3 field, the %1 field should be set to both.';
}
