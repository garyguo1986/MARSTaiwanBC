page 50004 "Void Check"
{
    // +--------------------------------------------------------------+
    // | @ 2017 incadea Taiwan Limited                                |
    // +--------------------------------------------------------------+
    // | PURPOSE: MARS_TWN                                            |
    // |                                                              |
    // | REMARK :                                                     |
    // +--------------------------------------------------------------+

    // VERSION         ID                  WHO    DATE        DESCRIPTION
    // TWN.01.09       RGS_TWN-INC01_NPNR  AH     2017-06-05  INITIAL RELEASE

    Caption = 'Void Check';
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
            field("Amount"; CheckLedgerEntry."Amount")
            {
                Caption = 'Amount';
                Editable = false;
                ApplicationArea = All;
            }
            field(CheckDate; CheckDate)
            {
                Caption = 'Check Date';
                Editable = false;
                ApplicationArea = All;
            }
            field(VoidDate; VoidDate)
            {
                Caption = 'Void Date';
                ApplicationArea = All;
                trigger OnValidate()
                var
                    recDetailCheckLedger: Record "Detailed Check Entry";
                begin
                    CLEAR(recDetailCheckLedger);
                    recDetailCheckLedger.RESET;
                    recDetailCheckLedger.SETFILTER(recDetailCheckLedger."Check Entry No", FORMAT(CheckLedgerEntry."Entry No."));
                    recDetailCheckLedger.FIND('+');
                    IF VoidDate < recDetailCheckLedger."Posting Date" THEN
                        ERROR(Text000, CheckLedgerEntry.FIELDCAPTION("Posting Date"));
                end;
            }
            field(VoidSubType; VoidSubType)
            {
                Caption = 'Reason of Void';
                Visible = VSubTypeVisible;
                Editable = VSubTypeEditable;
                ApplicationArea = All;
            }
            group("Type of Void")
            {
                Visible = false;
                Caption = 'Type of Void';
                field(VoidType; VoidType)
                {
                    Caption = 'Type of Void';
                    Visible = false;
                }
            }
        }
    }
    trigger OnInit()
    begin
        VoidSubType := VoidSubType::Void;
    end;

    trigger OnOpenPage()
    var
        recDetailCheckLedger: Record "Detailed Check Entry";
    begin
        WITH CheckLedgerEntry DO BEGIN
            CheckDate := "Check Date";

            CLEAR(recDetailCheckLedger);
            recDetailCheckLedger.RESET;
            recDetailCheckLedger.SETFILTER(recDetailCheckLedger."Check Entry No", FORMAT("Entry No."));
            recDetailCheckLedger.FIND('+');
            VoidDate := recDetailCheckLedger."Posting Date";

            IF "Entry Status" = "Entry Status"::Note THEN BEGIN
                VSubTypeEditable := TRUE;
            END ELSE
                IF "Entry Status" = "Entry Status"::Posted THEN BEGIN
                    VSubTypeEditable := FALSE;
                END;


            IF "Bal. Account Type" IN ["Bal. Account Type"::Vendor, "Bal. Account Type"::Customer] THEN
                VoidType := VoidType::"Unapply and void check"
            ELSE
                VoidType := VoidType::"Void check only";


            IF (("Entry Status" = "Entry Status"::Posted) AND ("Statement Status" = "Statement Status"::Closed)) THEN BEGIN
                VSubTypeVisible := FALSE;
            END;
        END;
    end;

    procedure SetCheckLedgerEntry(var NewCheckLedgerEntry: Record "Check Ledger Entry")
    begin
        CheckLedgerEntry := NewCheckLedgerEntry;
    end;

    procedure GetVoidDate(): Date
    begin
        exit(VoidDate);
    end;

    procedure GetVoidType(): Integer
    begin
        exit(VoidType);
    end;

    procedure GetVoidSubType(): Integer
    begin
        EXIT(VoidSubType);
    end;

    var
        CheckLedgerEntry: Record "Check Ledger Entry";
        CheckDate: Date;
        VoidDate: Date;
        VoidType: Option "Unapply and void check","Void check only";
        VoidSubType: Option "","Void","Dishonored","Withdraw";
        [InDataSet]
        VSubTypeEditable: Boolean;
        [InDataSet]
        VSubTypeVisible: Boolean;
        Text000: Label 'Void Date must not be before the original %1.';
        Text001: Label '%1 No.';
}
