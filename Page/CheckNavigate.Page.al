page 50006 "Check Navigate"
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
    // RGS_TWN-888 122187	           QX	  2020-12-16  Fix bugs
    //                                                    Handle ApplicationManagement because Codeunit 1 was removed

    Caption = 'Check Navigate';
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = Worksheet;
    PromotedActionCategories = 'New,Process,Report,Find By';
    SaveValues = false;
    SourceTable = "Document Entry";
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            group(Document)
            {
                Caption = 'Document';
                Visible = DocumentVisible;
                field(DocNoFilter; DocNoFilter)
                {
                    Caption = 'Document No.';

                    trigger OnValidate()
                    begin
                        SetDocNo(DocNoFilter);
                        ContactType := ContactType::" ";
                        ContactNo := '';
                        ExtDocNo := '';
                    end;
                }
                field(PostingDateFilter; PostingDateFilter)
                {
                    Caption = 'Posting Date';

                    trigger OnValidate()
                    begin
                        SetPostingDate(PostingDateFilter);
                        ContactType := ContactType::" ";
                        ContactNo := '';
                        ExtDocNo := '';
                    end;
                }
            }
            group("Business Contact")
            {
                Caption = 'Business Contact';
                field(ContactType; ContactType)
                {
                    Caption = 'Business Contact Type';
                    OptionCaption = ' ,Vendor,Customer';

                    trigger OnValidate()
                    begin
                        SetDocNo('');
                        SetPostingDate('');
                    end;
                }
                field(ContactNo; ContactNo)
                {
                    Caption = 'Business Contact No.';

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        Vend: Record Vendor;
                        Cust: Record Customer;
                    begin
                        CASE ContactType OF
                            ContactType::Vendor:
                                IF PAGE.RUNMODAL(0, Vend) = ACTION::LookupOK THEN BEGIN
                                    Text := Vend."No.";
                                    EXIT(TRUE);
                                END;
                            ContactType::Customer:
                                IF PAGE.RUNMODAL(0, Cust) = ACTION::LookupOK THEN BEGIN
                                    Text := Cust."No.";
                                    EXIT(TRUE);
                                END;
                        END;
                    end;

                    trigger OnValidate()
                    begin
                        SetDocNo('');
                        SetPostingDate('');
                    end;
                }
                field(ExtDocNo; ExtDocNo)
                {
                    Caption = 'External Document No.';

                    trigger OnValidate()
                    begin
                        SetDocNo('');
                        SetPostingDate('');
                    end;
                }
            }
            group(Notification)
            {
                Caption = 'Notification';
                InstructionalText = 'The filter has been changed. Choose Find to update the list of related entries.';
            }
            repeater(Group)
            {
                Editable = false;
                field("Entry No."; "Entry No.")
                {
                    Visible = false;
                }
                field("Table ID"; "Table ID")
                {
                    Visible = false;
                }
                field("Table Name"; "Table Name")
                {
                    Caption = 'Related Entries';
                }
                field("No. of Records"; "No. of Records")
                {
                    Caption = 'No. of Entries';
                    DrillDown = true;

                    trigger OnDrillDown()
                    begin
                        ShowRecords;
                    end;
                }
            }
            group(Source)
            {
                Caption = 'Source';
                field(DocType; DocType)
                {
                    Caption = 'Document Type';
                    Editable = false;
                    Enabled = DocTypeEnable;
                }
                field(SourceType; SourceType)
                {
                    Caption = 'Source Type';
                    Editable = false;
                    Enabled = SourceTypeEnable;
                }
                field(SourceNo; SourceNo)
                {
                    Caption = 'Source No.';
                    Editable = false;
                    Enabled = SourceNoEnable;
                }
                field(SourceName; SourceName)
                {
                    Caption = 'Source Name';
                    Editable = false;
                    Enabled = SourceNameEnable;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group(Process)
            {
                Caption = 'Process';
                action(Show)
                {
                    Caption = '&Show Related Entries';
                    Enabled = ShowENABLE;
                    Image = ViewDocumentLine;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunPageMode = View;

                    trigger OnAction()
                    begin
                        ShowRecords;
                    end;
                }
                action(Find)
                {
                    Caption = 'Fi&nd';
                    Image = Find;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        FindPush;
                    end;
                }
            }
            action(Print)
            {
                Caption = '&Print';
                Ellipsis = true;
                Enabled = PrintENABLE;
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    ItemTrackingNavigate: Report "Item Tracking Navigate";
                    DocumentEntries: Report "Document Entries";
                begin
                    DocumentEntries.TransferDocEntries(Rec);
                    DocumentEntries.TransferFilters(DocNoFilter, PostingDateFilter);
                    DocumentEntries.RUN;
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        IF (NewDocNo = '') AND (NewPostingDate = 0D) THEN BEGIN
            DELETEALL;
            ShowENABLE := FALSE;
            PrintENABLE := FALSE;
            SetSource(0D, '', '', 0, '');
        END ELSE BEGIN
            SETRANGE("Document No.", NewDocNo);
            SETRANGE("Posting Date", NewPostingDate);
            DocNoFilter := GETFILTER("Document No.");
            PostingDateFilter := GETFILTER("Posting Date");
            ContactType := ContactType::" ";
            ContactNo := '';
            ExtDocNo := '';
            FindRecords;
        END;
    end;

    var
        Cust: Record Customer;
        Vend: Record Vendor;
        SOSalesHeader: Record "Sales Header";
        SISalesHeader: Record "Sales Header";
        SROSalesHeader: Record "Sales Header";
        SCMSalesHeader: Record "Sales Header";
        SalesShptHeader: Record "Sales Shipment Header";
        SalesInvHeader: Record "Sales Invoice Header";
        ReturnRcptHeader: Record "Return Receipt Header";
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
        SOServHeader: Record "Service Header";
        SIServHeader: Record "Service Header";
        SCMServHeader: Record "Service Header";
        ServShptHeader: Record "Service Shipment Header";
        ServInvHeader: Record "Service Invoice Header";
        ServCrMemoHeader: Record "Service Cr.Memo Header";
        IssuedReminderHeader: Record "Issued Reminder Header";
        IssuedFinChrgMemoHeader: Record "Issued Fin. Charge Memo Header";
        PurchRcptHeader: Record "Purch. Rcpt. Header";
        PurchInvHeader: Record "Purch. Inv. Header";
        ReturnShptHeader: Record "Return Shipment Header";
        PurchCrMemoHeader: Record "Purch. Cr. Memo Hdr.";
        ProductionOrderHeader: Record "Production Order";
        TransShptHeader: Record "Transfer Shipment Header";
        TransRcptHeader: Record "Transfer Receipt Header";
        PostedWhseRcptLine: Record "Posted Whse. Receipt Line";
        PostedWhseShptLine: Record "Posted Whse. Shipment Line";
        GLEntry: Record "G/L Entry";
        VATEntry: Record "VAT Entry";
        CustLedgEntry: Record "Cust. Ledger Entry";
        DtldCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
        VendLedgEntry: Record "Vendor Ledger Entry";
        DtldVendLedgEntry: Record "Detailed Vendor Ledg. Entry";
        ItemLedgEntry: Record "Item Ledger Entry";
        PhysInvtLedgEntry: Record "Phys. Inventory Ledger Entry";
        ResLedgEntry: Record "Res. Ledger Entry";
        JobLedgEntry: Record "Job Ledger Entry";
        ValueEntry: Record "Value Entry";
        BankAccLedgEntry: Record "Bank Account Ledger Entry";
        CheckLedgEntry: Record "Check Ledger Entry";
        ReminderEntry: Record "Reminder/Fin. Charge Entry";
        FALedgEntry: Record "FA Ledger Entry";
        MaintenanceLedgEntry: Record "Maintenance Ledger Entry";
        InsuranceCovLedgEntry: Record "Ins. Coverage Ledger Entry";
        CapacityLedgEntry: Record "Capacity Ledger Entry";
        ServLedgerEntry: Record "Service Ledger Entry";
        WarrantyLedgerEntry: Record "Warranty Ledger Entry";
        WhseEntry: Record "Warehouse Entry";
        TempRecordBuffer: Record "Record Buffer" temporary;
        //++TWN1.00.122187.QX
        // ApplicationManagement: Codeunit "1";
        ApplicationManagement: Codeunit "Filter Tokens";
        //--TWN1.00.122187.QX

        ItemTrackingNavigateMgt: Codeunit "Item Tracking Navigate Mgt.";
        Window: Dialog;
        DocNoFilter: Code[250];
        PostingDateFilter: Text[250];
        NewDocNo: Code[20];
        ContactNo: Code[250];
        ExtDocNo: Code[250];
        NewPostingDate: Date;
        DocType: Text[50];
        SourceType: Text[30];
        SourceNo: Code[20];
        SourceName: Text[50];
        ContactType: Option " ",Vendor,Customer;
        DocExists: Boolean;
        DetailedCheckEntry: Record "Detailed Check Entry";
        Text000: Label 'The business contact type was not specified.';
        Text001: Label 'There are no posted records with this external document number.';
        Text002: Label 'Counting records...';
        Text003: Label 'Posted Sales Invoice';
        Text004: Label 'Posted Sales Credit Memo';
        Text005: Label 'Posted Sales Shipment';
        Text006: Label 'Issued Reminder';
        Text007: Label 'Issued Finance Charge Memo';
        Text008: Label 'Posted Purchase Invoice';
        Text009: Label 'Posted Purchase Credit Memo';
        Text010: Label 'Posted Purchase Receipt';
        Text011: Label 'The document number has been used more than once.';
        Text012: Label 'This combination of document number and posting date has been used more than once.';
        Text013: Label 'There are no posted records with this document number.';
        Text014: Label 'There are no posted records with this combination of document number and posting date.';
        Text015: Label 'The search results in too many external documents. Please specify a business contact no.';
        Text016: Label 'The search results in too many external documents. Please use Navigate from the relevant ledger entries.';
        Text017: Label 'Posted Return Receipt';
        Text018: Label 'Posted Return Shipment';
        Text019: Label 'Posted Transfer Shipment';
        Text020: Label 'Posted Transfer Receipt';
        Text021: Label 'Sales Order';
        Text022: Label 'Sales Invoice';
        Text023: Label 'Sales Return Order';
        Text024: Label 'Sales Credit Memo';
        sText003: Label 'Posted Service Invoice';
        sText004: Label 'Posted Service Credit Memo';
        sText005: Label 'Posted Service Shipment';
        sText021: Label 'Service Order';
        sText022: Label 'Service Invoice';
        sText024: Label 'Service Credit Memo';
        Text99000000: Label 'Production Order';
        [InDataSet]
        ShowENABLE: Boolean;
        [InDataSet]
        PrintENABLE: Boolean;
        [InDataSet]
        DocumentVisible: Boolean;
        [InDataSet]
        DocTypeEnable: Boolean;
        [InDataSet]
        SourceTypeEnable: Boolean;
        [InDataSet]
        SourceNoEnable: Boolean;
        [InDataSet]
        SourceNameEnable: Boolean;

    [Scope('OnPrem')]
    procedure SetDoc(PostingDate: Date; DocNo: Code[20])
    begin
        NewDocNo := DocNo;
        NewPostingDate := PostingDate;
    end;

    local procedure FindExtRecords()
    var
        VendLedgEntry2: Record "Vendor Ledger Entry";
        FoundRecords: Boolean;
        DateFilter2: Code[250];
        DocNoFilter2: Code[250];
    begin
        FoundRecords := FALSE;
        CASE ContactType OF
            ContactType::Vendor:
                BEGIN
                    VendLedgEntry2.SETCURRENTKEY("External Document No.");
                    VendLedgEntry2.SETFILTER("External Document No.", ExtDocNo);
                    VendLedgEntry2.SETFILTER("Vendor No.", ContactNo);
                    IF VendLedgEntry2.FINDSET THEN BEGIN
                        REPEAT
                            MakeExtFilter(
                              DateFilter2,
                              VendLedgEntry2."Posting Date",
                              DocNoFilter2,
                              VendLedgEntry2."Document No.");
                        UNTIL VendLedgEntry2.NEXT = 0;
                        SetPostingDate(DateFilter2);
                        SetDocNo(DocNoFilter2);
                        FindRecords;
                        FoundRecords := TRUE;
                    END;
                END;
            ContactType::Customer:
                BEGIN
                    DELETEALL;
                    "Entry No." := 0;
                    FindUnpostedSalesDocs(SOSalesHeader."Document Type"::Order, Text021, SOSalesHeader);
                    FindUnpostedSalesDocs(SISalesHeader."Document Type"::Invoice, Text022, SISalesHeader);
                    FindUnpostedSalesDocs(SROSalesHeader."Document Type"::"Return Order", Text023, SROSalesHeader);
                    FindUnpostedSalesDocs(SCMSalesHeader."Document Type"::"Credit Memo", Text024, SCMSalesHeader);
                    IF SalesShptHeader.READPERMISSION THEN BEGIN
                        SalesShptHeader.RESET;
                        SalesShptHeader.SETCURRENTKEY("Sell-to Customer No.", "External Document No.");
                        SalesShptHeader.SETFILTER("Sell-to Customer No.", ContactNo);
                        SalesShptHeader.SETFILTER("External Document No.", ExtDocNo);
                        InsertIntoDocEntry(
                          DATABASE::"Sales Shipment Header", 0, Text005, SalesShptHeader.COUNT);
                    END;
                    IF SalesInvHeader.READPERMISSION THEN BEGIN
                        SalesInvHeader.RESET;
                        SalesInvHeader.SETCURRENTKEY("Sell-to Customer No.", "External Document No.");
                        SalesInvHeader.SETFILTER("Sell-to Customer No.", ContactNo);
                        SalesInvHeader.SETFILTER("External Document No.", ExtDocNo);
                        InsertIntoDocEntry(
                          DATABASE::"Sales Invoice Header", 0, Text003, SalesInvHeader.COUNT);
                    END;
                    IF ReturnRcptHeader.READPERMISSION THEN BEGIN
                        ReturnRcptHeader.RESET;
                        ReturnRcptHeader.SETCURRENTKEY("Sell-to Customer No.", "External Document No.");
                        ReturnRcptHeader.SETFILTER("Sell-to Customer No.", ContactNo);
                        ReturnRcptHeader.SETFILTER("External Document No.", ExtDocNo);
                        InsertIntoDocEntry(
                          DATABASE::"Return Receipt Header", 0, Text017, ReturnRcptHeader.COUNT);
                    END;
                    IF SalesCrMemoHeader.READPERMISSION THEN BEGIN
                        SalesCrMemoHeader.RESET;
                        SalesCrMemoHeader.SETCURRENTKEY("Sell-to Customer No.", "External Document No.");
                        SalesCrMemoHeader.SETFILTER("Sell-to Customer No.", ContactNo);
                        SalesCrMemoHeader.SETFILTER("External Document No.", ExtDocNo);
                        InsertIntoDocEntry(
                          DATABASE::"Sales Cr.Memo Header", 0, Text004, SalesCrMemoHeader.COUNT);
                    END;
                    FindUnpostedServDocs(SOServHeader."Document Type"::Order, sText021, SOServHeader);
                    FindUnpostedServDocs(SIServHeader."Document Type"::Invoice, sText022, SIServHeader);
                    FindUnpostedServDocs(SCMServHeader."Document Type"::"Credit Memo", sText024, SCMServHeader);
                    IF ServShptHeader.READPERMISSION THEN BEGIN
                        IF ExtDocNo = '' THEN BEGIN
                            ServShptHeader.RESET;
                            ServShptHeader.SETCURRENTKEY("Customer No.");
                            ServShptHeader.SETFILTER("Customer No.", ContactNo);
                            InsertIntoDocEntry(
                              DATABASE::"Service Shipment Header", 0, sText005, ServShptHeader.COUNT);
                        END;
                    END;
                    IF ServInvHeader.READPERMISSION THEN BEGIN
                        IF ExtDocNo = '' THEN BEGIN
                            ServInvHeader.RESET;
                            ServShptHeader.SETCURRENTKEY("Customer No.");
                            ServInvHeader.SETFILTER("Customer No.", ContactNo);
                            InsertIntoDocEntry(
                              DATABASE::"Service Invoice Header", 0, sText003, ServInvHeader.COUNT);
                        END;
                    END;
                    IF ServCrMemoHeader.READPERMISSION THEN BEGIN
                        IF ExtDocNo = '' THEN BEGIN
                            ServCrMemoHeader.RESET;
                            ServShptHeader.SETCURRENTKEY("Customer No.");
                            ServCrMemoHeader.SETFILTER("Customer No.", ContactNo);
                            InsertIntoDocEntry(
                              DATABASE::"Service Cr.Memo Header", 0, sText004, ServCrMemoHeader.COUNT);
                        END;
                    END;

                    DocExists := FINDFIRST;

                    UpdateFormAfterFindRecords;
                    FoundRecords := DocExists;
                END;
            ELSE
                ERROR(Text000);
        END;

        IF NOT FoundRecords THEN BEGIN
            SetSource(0D, '', '', 0, '');
            MESSAGE(Text001);
        END;
    end;

    local procedure FindRecords()
    var
        xDocNoFilter: Text[1000];
        xTransactionNoFilter: Code[1000];
    begin
        DetailedCheckEntry.SETFILTER("Check No.", DocNoFilter);
        DetailedCheckEntry.SETFILTER("Currency Date", PostingDateFilter);
        IF NOT DetailedCheckEntry.FIND('-') THEN EXIT;
        REPEAT
            IF STRPOS(xDocNoFilter, DetailedCheckEntry."Document No.") = 0 THEN
                xDocNoFilter := xDocNoFilter + '|' + DetailedCheckEntry."Document No.";
        UNTIL DetailedCheckEntry.NEXT = 0;
        xDocNoFilter := COPYSTR(xDocNoFilter, 2);
        Window.OPEN(Text002);
        RESET;
        DELETEALL;
        "Entry No." := 0;
        IF GLEntry.READPERMISSION THEN BEGIN
            GLEntry.RESET;
            GLEntry.SETCURRENTKEY("Document No.", "Posting Date");
            GLEntry.SETFILTER("Document No.", xDocNoFilter);
            //GLEntry.SETFILTER("Posting Date",xPostingDateFilter);
            InsertIntoDocEntry(
              DATABASE::"G/L Entry", 0, GLEntry.TABLECAPTION, GLEntry.COUNT);
        END;
        IF SalesShptHeader.READPERMISSION THEN BEGIN
            SalesShptHeader.RESET;
            SalesShptHeader.SETFILTER("No.", xDocNoFilter);
            //SalesShptHeader.SETRANGE("Posting Date",xPostingDateFilter);
            InsertIntoDocEntry(
              DATABASE::"Sales Shipment Header", 0, Text005, SalesShptHeader.COUNT);
        END;
        IF SalesInvHeader.READPERMISSION THEN BEGIN
            SalesInvHeader.RESET;
            SalesInvHeader.SETFILTER("No.", xDocNoFilter);
            //SalesInvHeader.SETRANGE("Posting Date",xPostingDateFilter);
            InsertIntoDocEntry(
              DATABASE::"Sales Invoice Header", 0, Text003, SalesInvHeader.COUNT);
        END;
        IF ReturnRcptHeader.READPERMISSION THEN BEGIN
            ReturnRcptHeader.RESET;
            ReturnRcptHeader.SETFILTER("No.", xDocNoFilter);
            //ReturnRcptHeader.SETRANGE("Posting Date",xPostingDateFilter);
            InsertIntoDocEntry(
              DATABASE::"Return Receipt Header", 0, Text017, ReturnRcptHeader.COUNT);
        END;
        IF SalesCrMemoHeader.READPERMISSION THEN BEGIN
            SalesCrMemoHeader.RESET;
            SalesCrMemoHeader.SETFILTER("No.", xDocNoFilter);
            //SalesCrMemoHeader.SETRANGE("Posting Date",xPostingDateFilter);
            InsertIntoDocEntry(
              DATABASE::"Sales Cr.Memo Header", 0, Text004, SalesCrMemoHeader.COUNT);
        END;
        IF ServShptHeader.READPERMISSION THEN BEGIN
            ServShptHeader.RESET;
            ServShptHeader.SETFILTER("No.", xDocNoFilter);
            //ServShptHeader.SETRANGE("Posting Date",xPostingDateFilter);
            InsertIntoDocEntry(
              DATABASE::"Service Shipment Header", 0, sText005, ServShptHeader.COUNT);
        END;
        IF ServInvHeader.READPERMISSION THEN BEGIN
            ServInvHeader.RESET;
            ServInvHeader.SETFILTER("No.", xDocNoFilter);
            //ServInvHeader.SETRANGE("Posting Date",xPostingDateFilter);
            InsertIntoDocEntry(
              DATABASE::"Service Invoice Header", 0, sText003, ServInvHeader.COUNT);
        END;
        IF ServCrMemoHeader.READPERMISSION THEN BEGIN
            ServCrMemoHeader.RESET;
            ServCrMemoHeader.SETFILTER("No.", xDocNoFilter);
            //ServCrMemoHeader.SETRANGE("Posting Date",xPostingDateFilter);
            InsertIntoDocEntry(
              DATABASE::"Service Cr.Memo Header", 0, sText004, ServCrMemoHeader.COUNT);
        END;
        IF IssuedReminderHeader.READPERMISSION THEN BEGIN
            IssuedReminderHeader.RESET;
            IssuedReminderHeader.SETFILTER("No.", xDocNoFilter);
            //IssuedReminderHeader.SETRANGE("Posting Date",xPostingDateFilter);
            InsertIntoDocEntry(
              DATABASE::"Issued Reminder Header", 0, Text006, IssuedReminderHeader.COUNT);
        END;
        IF IssuedFinChrgMemoHeader.READPERMISSION THEN BEGIN
            IssuedFinChrgMemoHeader.RESET;
            IssuedFinChrgMemoHeader.SETFILTER("No.", xDocNoFilter);
            //IssuedFinChrgMemoHeader.SETRANGE("Posting Date",xPostingDateFilter);
            InsertIntoDocEntry(
              DATABASE::"Issued Fin. Charge Memo Header", 0, Text007,
                IssuedFinChrgMemoHeader.COUNT);
        END;
        IF PurchRcptHeader.READPERMISSION THEN BEGIN
            PurchRcptHeader.RESET;
            PurchRcptHeader.SETFILTER("No.", xDocNoFilter);
            //PurchRcptHeader.SETRANGE("Posting Date",xPostingDateFilter);
            InsertIntoDocEntry(
              DATABASE::"Purch. Rcpt. Header", 0, Text010, PurchRcptHeader.COUNT);
        END;
        IF PurchInvHeader.READPERMISSION THEN BEGIN
            PurchInvHeader.RESET;
            PurchInvHeader.SETFILTER("No.", xDocNoFilter);
            //PurchInvHeader.SETRANGE("Posting Date",xPostingDateFilter);
            InsertIntoDocEntry(
              DATABASE::"Purch. Inv. Header", 0, Text008, PurchInvHeader.COUNT);
        END;
        IF ReturnShptHeader.READPERMISSION THEN BEGIN
            ReturnShptHeader.RESET;
            ReturnShptHeader.SETFILTER("No.", xDocNoFilter);
            //ReturnShptHeader.SETRANGE("Posting Date",xPostingDateFilter);
            InsertIntoDocEntry(
              DATABASE::"Return Shipment Header", 0, Text018, ReturnShptHeader.COUNT);
        END;
        IF PurchCrMemoHeader.READPERMISSION THEN BEGIN
            PurchCrMemoHeader.RESET;
            PurchCrMemoHeader.SETFILTER("No.", xDocNoFilter);
            //PurchCrMemoHeader.SETRANGE("Posting Date",xPostingDateFilter);
            InsertIntoDocEntry(
              DATABASE::"Purch. Cr. Memo Hdr.", 0, Text009, PurchCrMemoHeader.COUNT);
        END;
        IF ProductionOrderHeader.READPERMISSION THEN BEGIN
            ProductionOrderHeader.RESET;
            ProductionOrderHeader.SETRANGE(
              Status,
              ProductionOrderHeader.Status::Released,
              ProductionOrderHeader.Status::Finished);
            ProductionOrderHeader.SETFILTER("No.", xDocNoFilter);
            InsertIntoDocEntry(
              DATABASE::"Production Order", 0, Text99000000, ProductionOrderHeader.COUNT);
        END;
        IF TransShptHeader.READPERMISSION THEN BEGIN
            TransShptHeader.RESET;
            TransShptHeader.SETFILTER("No.", xDocNoFilter);
            //TransShptHeader.SETRANGE("Posting Date",xPostingDateFilter);
            InsertIntoDocEntry(
              DATABASE::"Transfer Shipment Header", 0, Text019, TransShptHeader.COUNT);
        END;
        IF TransRcptHeader.READPERMISSION THEN BEGIN
            TransRcptHeader.RESET;
            TransRcptHeader.SETFILTER("No.", xDocNoFilter);
            //TransRcptHeader.SETRANGE("Posting Date",xPostingDateFilter);
            InsertIntoDocEntry(
              DATABASE::"Transfer Receipt Header", 0, Text020, TransRcptHeader.COUNT);
        END;
        IF PostedWhseShptLine.READPERMISSION THEN BEGIN
            PostedWhseShptLine.RESET;
            PostedWhseShptLine.SETCURRENTKEY("Posted Source No.", "Posting Date");
            PostedWhseShptLine.SETFILTER("Posted Source No.", xDocNoFilter);
            //PostedWhseShptLine.SETRANGE("Posting Date",xPostingDateFilter);
            InsertIntoDocEntry(
              DATABASE::"Posted Whse. Shipment Line", 0,
              PostedWhseShptLine.TABLECAPTION, PostedWhseShptLine.COUNT);
        END;
        IF PostedWhseRcptLine.READPERMISSION THEN BEGIN
            PostedWhseRcptLine.RESET;
            PostedWhseRcptLine.SETCURRENTKEY("Posted Source No.", "Posting Date");
            PostedWhseRcptLine.SETFILTER("Posted Source No.", xDocNoFilter);
            //PostedWhseRcptLine.SETRANGE("Posting Date",xPostingDateFilter);
            InsertIntoDocEntry(
              DATABASE::"Posted Whse. Receipt Line", 0,
              PostedWhseRcptLine.TABLECAPTION, PostedWhseRcptLine.COUNT);
        END;
        IF VATEntry.READPERMISSION THEN BEGIN
            VATEntry.RESET;
            VATEntry.SETCURRENTKEY("Document No.", "Posting Date");
            VATEntry.SETFILTER("Document No.", xDocNoFilter);
            //VATEntry.SETRANGE("Posting Date",xPostingDateFilter);
            InsertIntoDocEntry(
              DATABASE::"VAT Entry", 0, VATEntry.TABLECAPTION, VATEntry.COUNT);
        END;
        IF CustLedgEntry.READPERMISSION THEN BEGIN
            CustLedgEntry.RESET;
            CustLedgEntry.SETCURRENTKEY("Document No.");
            CustLedgEntry.SETFILTER("Document No.", xDocNoFilter);
            //CustLedgEntry.SETRANGE("Posting Date",xPostingDateFilter);
            InsertIntoDocEntry(
              DATABASE::"Cust. Ledger Entry", 0, CustLedgEntry.TABLECAPTION, CustLedgEntry.COUNT);
        END;
        IF DtldCustLedgEntry.READPERMISSION THEN BEGIN
            DtldCustLedgEntry.RESET;
            DtldCustLedgEntry.SETCURRENTKEY("Document No.");
            DtldCustLedgEntry.SETFILTER("Document No.", xDocNoFilter);
            //DtldCustLedgEntry.SETRANGE("Posting Date",xPostingDateFilter);
            InsertIntoDocEntry(
              DATABASE::"Detailed Cust. Ledg. Entry", 0, DtldCustLedgEntry.TABLECAPTION, DtldCustLedgEntry.COUNT);
        END;
        IF ReminderEntry.READPERMISSION THEN BEGIN
            ReminderEntry.RESET;
            ReminderEntry.SETCURRENTKEY(Type, "No.");
            ReminderEntry.SETFILTER("No.", xDocNoFilter);
            //ReminderEntry.SETRANGE("Posting Date",xPostingDateFilter);
            InsertIntoDocEntry(
              DATABASE::"Reminder/Fin. Charge Entry", 0, ReminderEntry.TABLECAPTION, ReminderEntry.COUNT);
        END;
        IF VendLedgEntry.READPERMISSION THEN BEGIN
            VendLedgEntry.RESET;
            VendLedgEntry.SETCURRENTKEY("Document No.");
            VendLedgEntry.SETFILTER("Document No.", xDocNoFilter);
            //VendLedgEntry.SETRANGE("Posting Date",xPostingDateFilter);
            InsertIntoDocEntry(
              DATABASE::"Vendor Ledger Entry", 0, VendLedgEntry.TABLECAPTION, VendLedgEntry.COUNT);
        END;
        IF DtldVendLedgEntry.READPERMISSION THEN BEGIN
            DtldVendLedgEntry.RESET;
            DtldVendLedgEntry.SETCURRENTKEY("Document No.");
            DtldVendLedgEntry.SETFILTER("Document No.", xDocNoFilter);
            //DtldVendLedgEntry.SETRANGE("Posting Date",xPostingDateFilter);
            InsertIntoDocEntry(
              DATABASE::"Detailed Vendor Ledg. Entry", 0, DtldVendLedgEntry.TABLECAPTION, DtldVendLedgEntry.COUNT);
        END;
        IF ItemLedgEntry.READPERMISSION THEN BEGIN
            ItemLedgEntry.RESET;
            ItemLedgEntry.SETCURRENTKEY("Document No.");
            ItemLedgEntry.SETFILTER("Document No.", xDocNoFilter);
            //ItemLedgEntry.SETRANGE("Posting Date",xPostingDateFilter);
            InsertIntoDocEntry(
              DATABASE::"Item Ledger Entry", 0, ItemLedgEntry.TABLECAPTION, ItemLedgEntry.COUNT);
        END;
        IF ValueEntry.READPERMISSION THEN BEGIN
            ValueEntry.RESET;
            ValueEntry.SETCURRENTKEY("Document No.");
            ValueEntry.SETFILTER("Document No.", xDocNoFilter);
            //ValueEntry.SETRANGE("Posting Date",xPostingDateFilter);
            InsertIntoDocEntry(
              DATABASE::"Value Entry", 0, ValueEntry.TABLECAPTION, ValueEntry.COUNT);
        END;
        IF PhysInvtLedgEntry.READPERMISSION THEN BEGIN
            PhysInvtLedgEntry.RESET;
            PhysInvtLedgEntry.SETCURRENTKEY("Document No.", "Posting Date");
            PhysInvtLedgEntry.SETFILTER("Document No.", xDocNoFilter);
            //PhysInvtLedgEntry.SETRANGE("Posting Date",xPostingDateFilter);
            InsertIntoDocEntry(
              DATABASE::"Phys. Inventory Ledger Entry", 0, PhysInvtLedgEntry.TABLECAPTION, PhysInvtLedgEntry.COUNT);
        END;
        IF ResLedgEntry.READPERMISSION THEN BEGIN
            ResLedgEntry.RESET;
            ResLedgEntry.SETCURRENTKEY("Document No.", "Posting Date");
            ResLedgEntry.SETFILTER("Document No.", xDocNoFilter);
            //ResLedgEntry.SETRANGE("Posting Date",xPostingDateFilter);
            InsertIntoDocEntry(
              DATABASE::"Res. Ledger Entry", 0, ResLedgEntry.TABLECAPTION, ResLedgEntry.COUNT);
        END;
        IF JobLedgEntry.READPERMISSION THEN BEGIN
            JobLedgEntry.RESET;
            JobLedgEntry.SETCURRENTKEY("Document No.", "Posting Date");
            JobLedgEntry.SETFILTER("Document No.", xDocNoFilter);
            //JobLedgEntry.SETRANGE("Posting Date",xPostingDateFilter);
            InsertIntoDocEntry(
              DATABASE::"Job Ledger Entry", 0, JobLedgEntry.TABLECAPTION, JobLedgEntry.COUNT);
        END;
        IF BankAccLedgEntry.READPERMISSION THEN BEGIN
            BankAccLedgEntry.RESET;
            BankAccLedgEntry.SETCURRENTKEY("Document No.", "Posting Date");
            BankAccLedgEntry.SETFILTER("Document No.", xDocNoFilter);
            //BankAccLedgEntry.SETRANGE("Posting Date",xPostingDateFilter);
            InsertIntoDocEntry(
              DATABASE::"Bank Account Ledger Entry", 0, BankAccLedgEntry.TABLECAPTION, BankAccLedgEntry.COUNT);
        END;
        IF CheckLedgEntry.READPERMISSION THEN BEGIN
            CheckLedgEntry.RESET;
            CheckLedgEntry.SETCURRENTKEY("Document No.", "Posting Date");
            CheckLedgEntry.SETFILTER("Document No.", xDocNoFilter);
            //CheckLedgEntry.SETRANGE("Posting Date",xPostingDateFilter);
            InsertIntoDocEntry(
              DATABASE::"Check Ledger Entry", 0, CheckLedgEntry.TABLECAPTION, CheckLedgEntry.COUNT);
        END;
        IF DetailedCheckEntry.READPERMISSION THEN BEGIN
            DetailedCheckEntry.RESET;
            DetailedCheckEntry.SETFILTER("Check No.", DocNoFilter);
            DetailedCheckEntry.SETFILTER("Currency Date", PostingDateFilter);
            //++TWN1.00.122187.QX
            // InsertIntoDocEntry(
            //   DATABASE::Table50080, 0, DetailedCheckEntry.TABLECAPTION, DetailedCheckEntry.COUNT);
            InsertIntoDocEntry(
              DATABASE::"Detailed Check Entry", 0, DetailedCheckEntry.TABLECAPTION, DetailedCheckEntry.COUNT);
            //--TWN1.00.122187.QX
        END;
        IF FALedgEntry.READPERMISSION THEN BEGIN
            FALedgEntry.RESET;
            FALedgEntry.SETCURRENTKEY("Document No.", "Posting Date");
            FALedgEntry.SETFILTER("Document No.", xDocNoFilter);
            //FALedgEntry.SETRANGE("Posting Date",xPostingDateFilter);
            InsertIntoDocEntry(
              DATABASE::"FA Ledger Entry", 0, FALedgEntry.TABLECAPTION, FALedgEntry.COUNT);
        END;
        IF MaintenanceLedgEntry.READPERMISSION THEN BEGIN
            MaintenanceLedgEntry.RESET;
            MaintenanceLedgEntry.SETCURRENTKEY("Document No.", "Posting Date");
            MaintenanceLedgEntry.SETFILTER("Document No.", xDocNoFilter);
            //MaintenanceLedgEntry.SETRANGE("Posting Date",xPostingDateFilter);
            InsertIntoDocEntry(
              DATABASE::"Maintenance Ledger Entry", 0, MaintenanceLedgEntry.TABLECAPTION, MaintenanceLedgEntry.COUNT);
        END;
        IF InsuranceCovLedgEntry.READPERMISSION THEN BEGIN
            InsuranceCovLedgEntry.RESET;
            InsuranceCovLedgEntry.SETCURRENTKEY("Document No.", "Posting Date");
            InsuranceCovLedgEntry.SETFILTER("Document No.", xDocNoFilter);
            //InsuranceCovLedgEntry.SETRANGE("Posting Date",xPostingDateFilter);
            InsertIntoDocEntry(
              DATABASE::"Ins. Coverage Ledger Entry", 0, InsuranceCovLedgEntry.TABLECAPTION, InsuranceCovLedgEntry.COUNT);
        END;
        IF CapacityLedgEntry.READPERMISSION THEN BEGIN
            CapacityLedgEntry.RESET;
            CapacityLedgEntry.SETCURRENTKEY("Document No.", "Posting Date");
            CapacityLedgEntry.SETFILTER("Document No.", xDocNoFilter);
            //CapacityLedgEntry.SETRANGE("Posting Date",xPostingDateFilter);
            InsertIntoDocEntry(
              DATABASE::"Capacity Ledger Entry", 0, CapacityLedgEntry.TABLECAPTION, CapacityLedgEntry.COUNT);
        END;
        IF WhseEntry.READPERMISSION THEN BEGIN
            WhseEntry.RESET;
            WhseEntry.SETCURRENTKEY("Reference No.", "Registering Date");
            WhseEntry.SETFILTER("Reference No.", xDocNoFilter);
            //WhseEntry.SETRANGE("Registering Date",xPostingDateFilter);
            InsertIntoDocEntry(
              DATABASE::"Warehouse Entry", 0, WhseEntry.TABLECAPTION, WhseEntry.COUNT);
        END;
        IF ServLedgerEntry.READPERMISSION THEN BEGIN
            ServLedgerEntry.RESET;
            ServLedgerEntry.SETCURRENTKEY("Document No.", "Posting Date");
            ServLedgerEntry.SETFILTER("Document No.", xDocNoFilter);
            //ServLedgerEntry.SETRANGE("Posting Date",xPostingDateFilter);
            InsertIntoDocEntry(
              DATABASE::"Service Ledger Entry", 0, ServLedgerEntry.TABLECAPTION, ServLedgerEntry.COUNT);
        END;
        IF WarrantyLedgerEntry.READPERMISSION THEN BEGIN
            WarrantyLedgerEntry.RESET;
            WarrantyLedgerEntry.SETCURRENTKEY("Document No.", "Posting Date");
            WarrantyLedgerEntry.SETFILTER("Document No.", xDocNoFilter);
            //WarrantyLedgerEntry.SETRANGE("Posting Date",xPostingDateFilter);
            InsertIntoDocEntry(
              DATABASE::"Warranty Ledger Entry", 0, WarrantyLedgerEntry.TABLECAPTION, WarrantyLedgerEntry.COUNT);
        END;

        DocExists := FINDFIRST;

        SetSource(0D, '', '', 0, '');
        IF DocExists THEN BEGIN
            IF (NoOfRecords(DATABASE::"Cust. Ledger Entry") + NoOfRecords(DATABASE::"Vendor Ledger Entry") <= 1) AND
               (NoOfRecords(DATABASE::"Sales Invoice Header") + NoOfRecords(DATABASE::"Sales Cr.Memo Header") +
                NoOfRecords(DATABASE::"Sales Shipment Header") + NoOfRecords(DATABASE::"Issued Reminder Header") +
                NoOfRecords(DATABASE::"Issued Fin. Charge Memo Header") + NoOfRecords(DATABASE::"Purch. Inv. Header") +
                NoOfRecords(DATABASE::"Return Shipment Header") + NoOfRecords(DATABASE::"Return Receipt Header") +
                NoOfRecords(DATABASE::"Purch. Cr. Memo Hdr.") + NoOfRecords(DATABASE::"Purch. Rcpt. Header") +
                NoOfRecords(DATABASE::"Service Invoice Header") + NoOfRecords(DATABASE::"Service Cr.Memo Header") +
                NoOfRecords(DATABASE::"Service Shipment Header") +
                NoOfRecords(DATABASE::"Transfer Shipment Header") + NoOfRecords(DATABASE::"Transfer Receipt Header") <= 1)
            THEN BEGIN
                // Service Management
                IF NoOfRecords(DATABASE::"Service Ledger Entry") = 1 THEN BEGIN
                    ServLedgerEntry.FINDFIRST;
                    IF ServLedgerEntry.Type = ServLedgerEntry.Type::"Service Contract" THEN
                        SetSource(
                          ServLedgerEntry."Posting Date", FORMAT(ServLedgerEntry."Document Type"), ServLedgerEntry."Document No.",
                          2, ServLedgerEntry."Service Contract No.")
                    ELSE
                        SetSource(
                          ServLedgerEntry."Posting Date", FORMAT(ServLedgerEntry."Document Type"), ServLedgerEntry."Document No.",
                          2, ServLedgerEntry."Service Order No.")
                END;
                IF NoOfRecords(DATABASE::"Warranty Ledger Entry") = 1 THEN BEGIN
                    WarrantyLedgerEntry.FINDFIRST;
                    SetSource(
                      WarrantyLedgerEntry."Posting Date", '', WarrantyLedgerEntry."Document No.",
                      2, WarrantyLedgerEntry."Service Order No.")
                END;
                // Sales
                IF NoOfRecords(DATABASE::"Cust. Ledger Entry") = 1 THEN BEGIN
                    CustLedgEntry.FINDFIRST;
                    SetSource(
                      CustLedgEntry."Posting Date", FORMAT(CustLedgEntry."Document Type"), CustLedgEntry."Document No.",
                      1, CustLedgEntry."Customer No.");
                END;
                IF NoOfRecords(DATABASE::"Detailed Cust. Ledg. Entry") = 1 THEN BEGIN
                    DtldCustLedgEntry.FINDFIRST;
                    SetSource(
                      DtldCustLedgEntry."Posting Date", FORMAT(DtldCustLedgEntry."Document Type"), DtldCustLedgEntry."Document No.",
                      1, DtldCustLedgEntry."Customer No.");
                END;
                IF NoOfRecords(DATABASE::"Sales Invoice Header") = 1 THEN BEGIN
                    SalesInvHeader.FINDFIRST;
                    SetSource(
                      SalesInvHeader."Posting Date", FORMAT("Table Name"), SalesInvHeader."No.",
                      1, SalesInvHeader."Bill-to Customer No.");
                END;
                IF NoOfRecords(DATABASE::"Sales Cr.Memo Header") = 1 THEN BEGIN
                    SalesCrMemoHeader.FINDFIRST;
                    SetSource(
                      SalesCrMemoHeader."Posting Date", FORMAT("Table Name"), SalesCrMemoHeader."No.",
                      1, SalesCrMemoHeader."Bill-to Customer No.");
                END;
                IF NoOfRecords(DATABASE::"Return Receipt Header") = 1 THEN BEGIN
                    ReturnRcptHeader.FINDFIRST;
                    SetSource(
                      ReturnRcptHeader."Posting Date", FORMAT("Table Name"), ReturnRcptHeader."No.",
                      1, ReturnRcptHeader."Sell-to Customer No.");
                END;
                IF NoOfRecords(DATABASE::"Sales Shipment Header") = 1 THEN BEGIN
                    SalesShptHeader.FINDFIRST;
                    SetSource(
                      SalesShptHeader."Posting Date", FORMAT("Table Name"), SalesShptHeader."No.",
                      1, SalesShptHeader."Sell-to Customer No.");
                END;
                IF NoOfRecords(DATABASE::"Posted Whse. Shipment Line") = 1 THEN BEGIN
                    PostedWhseShptLine.FINDFIRST;
                    SetSource(
                      PostedWhseShptLine."Posting Date", FORMAT("Table Name"), PostedWhseShptLine."No.",
                      1, PostedWhseShptLine."Destination No.");
                END;
                IF NoOfRecords(DATABASE::"Issued Reminder Header") = 1 THEN BEGIN
                    IssuedReminderHeader.FINDFIRST;
                    SetSource(
                      IssuedReminderHeader."Posting Date", FORMAT("Table Name"), IssuedReminderHeader."No.",
                      1, IssuedReminderHeader."Customer No.");
                END;
                IF NoOfRecords(DATABASE::"Issued Fin. Charge Memo Header") = 1 THEN BEGIN
                    IssuedFinChrgMemoHeader.FINDFIRST;
                    SetSource(
                      IssuedFinChrgMemoHeader."Posting Date", FORMAT("Table Name"), IssuedFinChrgMemoHeader."No.",
                      1, IssuedFinChrgMemoHeader."Customer No.");
                END;
                IF NoOfRecords(DATABASE::"Service Invoice Header") = 1 THEN BEGIN
                    ServInvHeader.FIND('-');
                    SetSource(
                      ServInvHeader."Posting Date", FORMAT("Table Name"), ServInvHeader."No.",
                      1, ServInvHeader."Bill-to Customer No.");
                END;
                IF NoOfRecords(DATABASE::"Service Cr.Memo Header") = 1 THEN BEGIN
                    ServCrMemoHeader.FIND('-');
                    SetSource(
                      ServCrMemoHeader."Posting Date", FORMAT("Table Name"), ServCrMemoHeader."No.",
                      1, ServCrMemoHeader."Bill-to Customer No.");
                END;
                IF NoOfRecords(DATABASE::"Service Shipment Header") = 1 THEN BEGIN
                    ServShptHeader.FIND('-');
                    SetSource(
                      ServShptHeader."Posting Date", FORMAT("Table Name"), ServShptHeader."No.",
                      1, ServShptHeader."Customer No.");
                END;

                // Purchase
                IF NoOfRecords(DATABASE::"Vendor Ledger Entry") = 1 THEN BEGIN
                    VendLedgEntry.FINDFIRST;
                    SetSource(
                      VendLedgEntry."Posting Date", FORMAT(VendLedgEntry."Document Type"), VendLedgEntry."Document No.",
                      2, VendLedgEntry."Vendor No.");
                END;
                IF NoOfRecords(DATABASE::"Detailed Vendor Ledg. Entry") = 1 THEN BEGIN
                    DtldVendLedgEntry.FINDFIRST;
                    SetSource(
                      DtldVendLedgEntry."Posting Date", FORMAT(DtldVendLedgEntry."Document Type"), DtldVendLedgEntry."Document No.",
                      2, DtldVendLedgEntry."Vendor No.");
                END;
                IF NoOfRecords(DATABASE::"Purch. Inv. Header") = 1 THEN BEGIN
                    PurchInvHeader.FINDFIRST;
                    SetSource(
                      PurchInvHeader."Posting Date", FORMAT("Table Name"), PurchInvHeader."No.",
                      2, PurchInvHeader."Pay-to Vendor No.");
                END;
                IF NoOfRecords(DATABASE::"Purch. Cr. Memo Hdr.") = 1 THEN BEGIN
                    PurchCrMemoHeader.FINDFIRST;
                    SetSource(
                      PurchCrMemoHeader."Posting Date", FORMAT("Table Name"), PurchCrMemoHeader."No.",
                      2, PurchCrMemoHeader."Pay-to Vendor No.");
                END;
                IF NoOfRecords(DATABASE::"Return Shipment Header") = 1 THEN BEGIN
                    ReturnShptHeader.FINDFIRST;
                    SetSource(
                      ReturnShptHeader."Posting Date", FORMAT("Table Name"), ReturnShptHeader."No.",
                      2, ReturnShptHeader."Buy-from Vendor No.");
                END;
                IF NoOfRecords(DATABASE::"Purch. Rcpt. Header") = 1 THEN BEGIN
                    PurchRcptHeader.FINDFIRST;
                    SetSource(
                      PurchRcptHeader."Posting Date", FORMAT("Table Name"), PurchRcptHeader."No.",
                      2, PurchRcptHeader."Buy-from Vendor No.");
                END;
                IF NoOfRecords(DATABASE::"Posted Whse. Receipt Line") = 1 THEN BEGIN
                    PostedWhseRcptLine.FINDFIRST;
                    SetSource(
                      PostedWhseRcptLine."Posting Date", FORMAT("Table Name"), PostedWhseRcptLine."No.",
                      2, '');
                END;
            END ELSE BEGIN
                IF DocNoFilter <> '' THEN
                    IF PostingDateFilter = '' THEN
                        MESSAGE(Text011)
                    ELSE
                        MESSAGE(Text012);
            END;
        END ELSE
            IF PostingDateFilter = '' THEN
                MESSAGE(Text013)
            ELSE
                MESSAGE(Text014);
        UpdateFormAfterFindRecords;
        Window.CLOSE;
    end;

    local procedure UpdateFormAfterFindRecords()
    begin
        ShowENABLE := DocExists;
        PrintENABLE := DocExists;
        CurrPage.UPDATE(FALSE);
        DocExists := FINDFIRST;
        //IF DocExists THEN
        //  CurrPage."Table Name".ACTIVATE;
    end;

    local procedure InsertIntoDocEntry(DocTableID: Integer; DocType: Option; DocTableName: Text[1024]; DocNoOfRecords: Integer)
    begin
        IF DocNoOfRecords = 0 THEN
            EXIT;
        INIT;
        "Entry No." := "Entry No." + 1;
        "Table ID" := DocTableID;
        "Document Type" := DocType;
        "Table Name" := COPYSTR(DocTableName, 1, MAXSTRLEN("Table Name"));
        "No. of Records" := DocNoOfRecords;
        INSERT;
    end;

    local procedure NoOfRecords(TableID: Integer): Integer
    begin
        SETRANGE("Table ID", TableID);
        IF NOT FINDFIRST THEN
            INIT;
        SETRANGE("Table ID");
        EXIT("No. of Records");
    end;

    local procedure SetSource(PostingDate: Date; DocType2: Text[50]; DocNo: Text[50]; SourceType2: Integer; SourceNo2: Code[20])
    begin
        IF SourceType2 = 0 THEN BEGIN
            DocType := '';
            SourceType := '';
            SourceNo := '';
            SourceName := '';
        END ELSE BEGIN
            DocType := DocType2;
            SourceNo := SourceNo2;
            SETRANGE("Document No.", DocNo);
            SETRANGE("Posting Date", PostingDate);
            DocNoFilter := GETFILTER("Document No.");
            PostingDateFilter := GETFILTER("Posting Date");
            CASE SourceType2 OF
                1:
                    BEGIN
                        SourceType := Cust.TABLECAPTION;
                        IF NOT Cust.GET(SourceNo) THEN
                            Cust.INIT;
                        SourceName := Cust.Name;
                    END;
                2:
                    BEGIN
                        SourceType := Vend.TABLECAPTION;
                        IF NOT Vend.GET(SourceNo) THEN
                            Vend.INIT;
                        SourceName := Vend.Name;
                    END;
            END;
        END;
        DocTypeEnable := SourceType2 <> 0;
        SourceTypeEnable := SourceType2 <> 0;
        SourceNoEnable := SourceType2 <> 0;
        SourceNameEnable := SourceType2 <> 0;
    end;

    local procedure ShowRecords()
    begin
        CASE "Table ID" OF
            DATABASE::"Sales Header":
                CASE "Document Type" OF
                    "Document Type"::Order:
                        IF "No. of Records" = 1 THEN
                            PAGE.RUN(PAGE::"Sales Order", SOSalesHeader)
                        ELSE
                            PAGE.RUN(0, SOSalesHeader);
                    "Document Type"::Invoice:
                        IF "No. of Records" = 1 THEN
                            PAGE.RUN(PAGE::"Sales Invoice", SISalesHeader)
                        ELSE
                            PAGE.RUN(0, SISalesHeader);
                    "Document Type"::"Return Order":
                        IF "No. of Records" = 1 THEN
                            PAGE.RUN(PAGE::"Sales Return Order", SROSalesHeader)
                        ELSE
                            PAGE.RUN(0, SROSalesHeader);
                    "Document Type"::"Credit Memo":
                        IF "No. of Records" = 1 THEN
                            PAGE.RUN(PAGE::"Sales Credit Memo", SCMSalesHeader)
                        ELSE
                            PAGE.RUN(0, SCMSalesHeader);
                END;
            DATABASE::"Sales Invoice Header":
                IF "No. of Records" = 1 THEN
                    PAGE.RUN(PAGE::"Posted Sales Invoice", SalesInvHeader)
                ELSE
                    PAGE.RUN(0, SalesInvHeader);
            DATABASE::"Sales Cr.Memo Header":
                IF "No. of Records" = 1 THEN
                    PAGE.RUN(PAGE::"Posted Sales Credit Memo", SalesCrMemoHeader)
                ELSE
                    PAGE.RUN(0, SalesCrMemoHeader);
            DATABASE::"Return Receipt Header":
                IF "No. of Records" = 1 THEN
                    PAGE.RUN(PAGE::"Posted Return Receipt", ReturnRcptHeader)
                ELSE
                    PAGE.RUN(0, ReturnRcptHeader);
            DATABASE::"Sales Shipment Header":
                IF "No. of Records" = 1 THEN
                    PAGE.RUN(PAGE::"Posted Sales Shipment", SalesShptHeader)
                ELSE
                    PAGE.RUN(0, SalesShptHeader);
            DATABASE::"Issued Reminder Header":
                IF "No. of Records" = 1 THEN
                    PAGE.RUN(PAGE::"Issued Reminder", IssuedReminderHeader)
                ELSE
                    PAGE.RUN(0, IssuedReminderHeader);
            DATABASE::"Issued Fin. Charge Memo Header":
                IF "No. of Records" = 1 THEN
                    PAGE.RUN(PAGE::"Issued Finance Charge Memo", IssuedFinChrgMemoHeader)
                ELSE
                    PAGE.RUN(0, IssuedFinChrgMemoHeader);
            DATABASE::"Purch. Inv. Header":
                IF "No. of Records" = 1 THEN
                    PAGE.RUN(PAGE::"Posted Purchase Invoice", PurchInvHeader)
                ELSE
                    PAGE.RUN(0, PurchInvHeader);
            DATABASE::"Purch. Cr. Memo Hdr.":
                IF "No. of Records" = 1 THEN
                    PAGE.RUN(PAGE::"Posted Purchase Credit Memo", PurchCrMemoHeader)
                ELSE
                    PAGE.RUN(0, PurchCrMemoHeader);
            DATABASE::"Return Shipment Header":
                IF "No. of Records" = 1 THEN
                    PAGE.RUN(PAGE::"Posted Return Shipment", ReturnShptHeader)
                ELSE
                    PAGE.RUN(0, ReturnShptHeader);
            DATABASE::"Purch. Rcpt. Header":
                IF "No. of Records" = 1 THEN
                    PAGE.RUN(PAGE::"Posted Purchase Receipt", PurchRcptHeader)
                ELSE
                    PAGE.RUN(0, PurchRcptHeader);
            DATABASE::"Production Order":
                PAGE.RUN(0, ProductionOrderHeader);
            DATABASE::"Transfer Shipment Header":
                IF "No. of Records" = 1 THEN
                    PAGE.RUN(PAGE::"Posted Transfer Shipment", TransShptHeader)
                ELSE
                    PAGE.RUN(0, TransShptHeader);
            DATABASE::"Transfer Receipt Header":
                IF "No. of Records" = 1 THEN
                    PAGE.RUN(PAGE::"Posted Transfer Receipt", TransRcptHeader)
                ELSE
                    PAGE.RUN(0, TransRcptHeader);
            DATABASE::"Posted Whse. Shipment Line":
                PAGE.RUN(0, PostedWhseShptLine);
            DATABASE::"Posted Whse. Receipt Line":
                PAGE.RUN(0, PostedWhseRcptLine);
            DATABASE::"G/L Entry":
                PAGE.RUN(0, GLEntry);
            DATABASE::"VAT Entry":
                PAGE.RUN(0, VATEntry);
            DATABASE::"Detailed Cust. Ledg. Entry":
                PAGE.RUN(0, DtldCustLedgEntry);
            DATABASE::"Cust. Ledger Entry":
                PAGE.RUN(0, CustLedgEntry);
            DATABASE::"Reminder/Fin. Charge Entry":
                PAGE.RUN(0, ReminderEntry);
            DATABASE::"Vendor Ledger Entry":
                PAGE.RUN(0, VendLedgEntry);
            DATABASE::"Detailed Vendor Ledg. Entry":
                PAGE.RUN(0, DtldVendLedgEntry);
            DATABASE::"Item Ledger Entry":
                PAGE.RUN(0, ItemLedgEntry);
            DATABASE::"Value Entry":
                PAGE.RUN(0, ValueEntry);
            DATABASE::"Phys. Inventory Ledger Entry":
                PAGE.RUN(0, PhysInvtLedgEntry);
            DATABASE::"Res. Ledger Entry":
                PAGE.RUN(0, ResLedgEntry);
            DATABASE::"Job Ledger Entry":
                PAGE.RUN(0, JobLedgEntry);
            DATABASE::"Bank Account Ledger Entry":
                PAGE.RUN(0, BankAccLedgEntry);
            DATABASE::"Check Ledger Entry":
                PAGE.RUN(0, CheckLedgEntry);
            DATABASE::"FA Ledger Entry":
                PAGE.RUN(0, FALedgEntry);
            DATABASE::"Maintenance Ledger Entry":
                PAGE.RUN(0, MaintenanceLedgEntry);
            DATABASE::"Ins. Coverage Ledger Entry":
                PAGE.RUN(0, InsuranceCovLedgEntry);
            DATABASE::"Capacity Ledger Entry":
                PAGE.RUN(0, CapacityLedgEntry);
            DATABASE::"Warehouse Entry":
                PAGE.RUN(0, WhseEntry);
            DATABASE::"Service Header":
                CASE "Document Type" OF
                    "Document Type"::Order:
                        PAGE.RUN(0, SOServHeader);
                    "Document Type"::Invoice:
                        PAGE.RUN(0, SIServHeader);
                    "Document Type"::"Credit Memo":
                        PAGE.RUN(0, SCMServHeader);
                END;
            DATABASE::"Service Invoice Header":
                PAGE.RUN(0, ServInvHeader);
            DATABASE::"Service Cr.Memo Header":
                PAGE.RUN(0, ServCrMemoHeader);
            DATABASE::"Service Shipment Header":
                PAGE.RUN(0, ServShptHeader);
            DATABASE::"Service Ledger Entry":
                PAGE.RUN(0, ServLedgerEntry);
            DATABASE::"Warranty Ledger Entry":
                PAGE.RUN(0, WarrantyLedgerEntry);
            //++TWN1.00.122187.QX
            // DATABASE::Table50080:
            //     PAGE.RUN(0, DetailedCheckEntry);
            DATABASE::"Detailed Check Entry":
                PAGE.RUN(0, DetailedCheckEntry);
        //--TWN1.00.122187.QX
        END;
    end;

    local procedure SetPostingDate(PostingDate: Text[250])
    begin
        //++TWN1.00.122187.QX
        // IF ApplicationManagement.MakeDateFilter(PostingDate) = 0 THEN;
        ApplicationManagement.MakeDateFilter(PostingDate);
        //--TWN1.00.122187.QX
        SETFILTER("Posting Date", PostingDate);
        PostingDateFilter := GETFILTER("Posting Date");
    end;

    local procedure SetDocNo(DocNo: Text[250])
    begin
        SETFILTER("Document No.", DocNo);
        DocNoFilter := GETFILTER("Document No.");
        PostingDateFilter := GETFILTER("Posting Date");
    end;

    local procedure ClearSourceInfo()
    begin
        IF DocExists THEN BEGIN
            DocExists := FALSE;
            DELETEALL;
            ShowENABLE := FALSE;
            SetSource(0D, '', '', 0, '');
            CurrPage.UPDATE(FALSE);
        END;
    end;

    local procedure MakeExtFilter(var DateFilter: Code[250]; AddDate: Date; var DocNoFilter: Code[250]; AddDocNo: Code[20])
    begin
        IF DateFilter = '' THEN
            DateFilter := FORMAT(AddDate)
        ELSE
            IF STRPOS(DateFilter, FORMAT(AddDate)) = 0 THEN
                IF MAXSTRLEN(DateFilter) >= STRLEN(DateFilter + '|' + FORMAT(AddDate)) THEN
                    DateFilter := DateFilter + '|' + FORMAT(AddDate)
                ELSE
                    TooLongFilter;

        IF DocNoFilter = '' THEN
            DocNoFilter := AddDocNo
        ELSE
            IF STRPOS(DocNoFilter, AddDocNo) = 0 THEN
                IF MAXSTRLEN(DocNoFilter) >= STRLEN(DocNoFilter + '|' + AddDocNo) THEN
                    DocNoFilter := DocNoFilter + '|' + AddDocNo
                ELSE
                    TooLongFilter;
    end;

    local procedure FindPush()
    begin
        IF (DocNoFilter = '') AND (PostingDateFilter = '') AND
           ((ContactType <> 0) OR (ContactNo <> '') OR (ExtDocNo <> ''))
        THEN
            FindExtRecords
        ELSE
            FindRecords;
    end;

    local procedure TooLongFilter()
    begin
        IF ContactNo = '' THEN
            ERROR(Text015)
        ELSE
            ERROR(Text016);
    end;

    local procedure FindUnpostedSalesDocs(DocType: Option; DocTableName: Text[100]; var SalesHeader: Record "Sales Header")
    begin
        IF SalesHeader.READPERMISSION THEN BEGIN
            SalesHeader.RESET;
            SalesHeader.SETCURRENTKEY("Sell-to Customer No.", "External Document No.");
            SalesHeader.SETFILTER("Sell-to Customer No.", ContactNo);
            SalesHeader.SETFILTER("External Document No.", ExtDocNo);
            SalesHeader.SETRANGE("Document Type", DocType);
            InsertIntoDocEntry(DATABASE::"Sales Header", DocType, DocTableName, SalesHeader.COUNT);
        END;
    end;

    local procedure FindUnpostedServDocs(DocType: Option; DocTableName: Text[100]; var ServHeader: Record "Service Header")
    begin
        IF ServHeader.READPERMISSION THEN BEGIN
            IF ExtDocNo = '' THEN BEGIN
                ServHeader.RESET;
                ServHeader.SETCURRENTKEY("Customer No.");
                ServHeader.SETFILTER("Customer No.", ContactNo);
                ServHeader.SETRANGE("Document Type", DocType);
                InsertIntoDocEntry(DATABASE::"Service Header", DocType, DocTableName, ServHeader.COUNT);
            END;
        END;
    end;

    [Scope('OnPrem')]
    procedure ClearInfo()
    begin
        SetDocNo('');
        SetPostingDate('');
        ContactType := ContactType::" ";
        ContactNo := '';
        ExtDocNo := '';
    end;
}

