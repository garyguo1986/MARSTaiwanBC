table 1044868 "TW Table Key Information"
{
    // +--------------------------------------------------------------+
    // | @ 2019 incadea Taiwan Limited                                |
    // +--------------------------------------------------------------+
    // | PURPOSE: MARS_TWN                                            |
    // |                                                              |
    // | REMARK :                                                     |
    // +--------------------------------------------------------------+
    // 
    // VERSION       ID            WHO    DATE        DESCRIPTION
    // RGS_TWN-809   118849        GG     2019-03-13  New Object


    fields
    {
        field(1; "Table ID"; Integer)
        {
            Caption = 'Table ID';
        }
        field(2; "Document Type"; Integer)
        {
            Caption = 'Document Type';
        }
        field(3; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(4; "Document Line No."; Integer)
        {
            Caption = 'Document Line No.';
        }
        field(21; "Table Name"; Text[100])
        {
            CalcFormula = Lookup("Table Information"."Table Name" WHERE("Table No." = FIELD("Table ID")));
            Caption = 'Table Name';
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Table ID", "Document Type", "Document No.", "Document Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    [Scope('OnPrem')]
    procedure RecordSalesInvoice(var SalesInvoiceHeaderP: Record "Sales Invoice Header")
    var
        TableKeyInfoL: Record "TW Table Key Information";
    begin
        IF NOT IsSalesInvoiceExist(SalesInvoiceHeaderP) THEN BEGIN
            TableKeyInfoL.INIT;
            TableKeyInfoL.VALIDATE("Table ID", DATABASE::"Sales Invoice Header");
            TableKeyInfoL.VALIDATE("Document No.", SalesInvoiceHeaderP."No.");
            TableKeyInfoL.INSERT(TRUE);
        END;
    end;

    [Scope('OnPrem')]
    procedure RecordSalesCreditMemo(var SalesCrMemoHeaderP: Record "Sales Cr.Memo Header")
    var
        TableKeyInfoL: Record "TW Table Key Information";
    begin
        IF NOT IsSalesCreditMemoExist(SalesCrMemoHeaderP) THEN BEGIN
            TableKeyInfoL.INIT;
            TableKeyInfoL.VALIDATE("Table ID", DATABASE::"Sales Cr.Memo Header");
            TableKeyInfoL.VALIDATE("Document No.", SalesCrMemoHeaderP."No.");
            TableKeyInfoL.INSERT(TRUE);
        END;
    end;

    [Scope('OnPrem')]
    procedure IsSalesInvoiceExist(var SalesInvoiceHeaderP: Record "Sales Invoice Header"): Boolean
    var
        TableKeyInfoL: Record "TW Table Key Information";
    begin
        EXIT(TableKeyInfoL.GET(DATABASE::"Sales Invoice Header", 0, SalesInvoiceHeaderP."No.", 0));
    end;

    [Scope('OnPrem')]
    procedure IsSalesCreditMemoExist(var SalesCrMemoHeaderP: Record "Sales Cr.Memo Header"): Boolean
    var
        TableKeyInfoL: Record "TW Table Key Information";
    begin
        EXIT(TableKeyInfoL.GET(DATABASE::"Sales Cr.Memo Header", 0, SalesCrMemoHeaderP."No.", 0));
    end;
}

