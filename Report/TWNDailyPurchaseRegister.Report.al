report 50047 "TWN Daily Purchase Register"
{
    // +--------------------------------------------------------------+
    // | @ 2017 incadea Taiwan Limited                                |
    // +--------------------------------------------------------------+
    // | PURPOSE: MARS_TWN                                            |
    // |                                                              |
    // | REMARK :                                                     |
    // +--------------------------------------------------------------+

    // Remark:       Witdh 31.05cm
    // VERSION       ID            WHO    DATE        DESCRIPTION
    // TWN.01.02     RGS_TWN-482   NN     2017-06-03  Upgrade from r3
    // +----------------------------------------------+
    // | Copyright (c) incadea China                  |
    // +----------------------------------------------+
    // TFS          ID             WHO    DATE        DESCRIPTION
    // 112117       MARS_TWN-6189  GG     2018-02-28  Change layout for the report
    // 117616       MARS_TWN-6594  GG     2018-12-05  Add new columns "Thread Pattern code/ Modelcode" "Thread Addon Infromation"    
    Caption = 'TWN Daily Purchase Register';
    DefaultLayout = RDLC;
    RDLCLayout = 'ReportLayout\report50047.rdl';
    UsageCategory = ReportsAndAnalysis;
    dataset
    {
        dataitem(Integer; Integer)
        {
            DataItemTableView = sorting(Number) order(ascending) where(Number = const(1));
            column(ReportTitle_Caption; ReportTitle_CaptionLbl) { }
            column(USERID; USERID) { }
            column(CompanyInfo_Picture; CompanyInfo.Picture) { }
            column(CompanyInfo_Name; CompanyInfo.Name + ' ' + CompanyInfo."Name 2") { }
            column(FORMAT_TODAY_0___Year4___Month_2___Day_2___; FORMAT(TODAY, 0, '<Year4>/<Month,2>/<Day,2>')) { }
            column(Page_Caption; PageCaptionLbl) { }
            //column(CurrReport_PAGENO; CurrReport.PAGENO) { }
            column(Filters; Filters) { }
            column(PrintSummary; PrintSummary) { }
            column(PricesIncludingVAT; PricesIncludingVAT) { }
            column(Purch_RegisterCaption; Purch_RegisterCaptionLbl) { }
            column(Purch_ReturnCaption; Purch_ReturnCaptionLbl) { }
            column(NetTotal_Caption; NetTotal_CaptionLbl) { }
            column(PostingDate_Caption; PostingDate_CaptionLbl) { }
            column(InvoiceNo_Caption; InvoiceNo_CaptionLbl) { }
            column(Pay2Name_Caption; Pay2Name_CaptionLbl) { }
            column(VendorInvNo_Caption; VendorInvNo_CaptionLbl) { }
            column(DescriptionCaption; DescriptionCaptionLbl) { }
            column(ThreadPattern_CaptionLbl; ThreadPattern_CaptionLbl) { }
            column(ThreadAddon_CaptionLbl; ThreadAddon_CaptionLbl) { }
            column(Qty_Caption; Qty_CaptionLbl) { }
            column(DirectUnitCost_Caption; DirectUnitCost_Caption) { }
            column(LineDiscAmt_Caption; LineDiscAmt_CaptionLbl) { }
            column(TaxAmt_Caption; TaxAmt_CaptionLbl) { }
            column(Amount_Caption; Amount_CaptionLbl) { }
            column(Total_Caption; Total_CaptionLbl) { }
            column(GrandTotal_Caption; GrandTotal_CaptionLbl) { }
            dataitem("Purch. Inv. Header"; "Purch. Inv. Header")
            {
                DataItemTableView = sorting("No.") order(ascending);
                DataItemLinkReference = Integer;
                RequestFilterFields = "Responsibility Center", "Posting Date", "Buy-from Vendor No.", "Buy-from Contact No.";
                column(PrintPurchSection; PrintPurchSection) { }
                column(PurchInvHeader_PostingDate; FORMAT("Posting Date", 0, '<Year4>/<Month,2>/<Day,2>')) { }
                column(PurchInvHeader_No_; "No.") { }
                column(PurchInvHeader_Pay2Name; "Pay-to Name") { }
                column(PurchInvHeader_VendorInvNo_; "Vendor Invoice No.") { }
                column(NoofPurchInvLine; NoofPurchInvLine) { }
                dataitem("Purch. Inv. Line"; "Purch. Inv. Line")
                {
                    DataItemTableView = sorting("Document No.", "Line No.") order(ascending);
                    DataItemLinkReference = "Purch. Inv. Header";
                    DataItemLink = "Document No." = field("No.");
                    RequestFilterFields = Type, "No.", "Item Category Code";
                    column(PurchInvLine_PostingDate; FORMAT("Posting Date", 0, '<Year4>/<Month,2>/<Day,2>')) { }
                    column(PurchInvLine_DocumentNo_; "Document No.") { }
                    column(PurchInvLine_Description; Description) { }
                    column(PurchInvLine_Quantity; Quantity) { }
                    column(PurchInvLine_DirectUnitCost; DirectUnitCost) { }
                    column(PurchInvLine_LineDiscAmount; LineDiscAmount) { }
                    column(PurchInvLine_TaxAmount; "Amount Including VAT" - Amount) { }
                    column(PurchInvLine_AmountInclVAT; "Amount Including VAT") { }
                    column(IsPurchaseInvoiceG; IsPurchaseInvoiceG) { }
                    column(PurchInvLine_ThreadPatternCode; Item."Tread Patterncode/Modelcode") { }
                    column(PurchInvLine_ThreadAddOnInfo; Item."Tread Addon Information") { }
                    trigger OnPreDataItem()
                    begin

                    end;

                    trigger OnAfterGetRecord()
                    begin
                        IF NOT PurchInvHeader.GET("Document No.") THEN BEGIN
                            DirectUnitCost := "Direct Unit Cost";
                            LineDiscAmount := "Line Discount Amount";
                        END ELSE BEGIN
                            IF (PurchInvHeader."Prices Including VAT" = TRUE) AND (PricesIncludingVAT = TRUE) THEN BEGIN
                                DirectUnitCost := "Direct Unit Cost";
                                LineDiscAmount := "Line Discount Amount";
                            END ELSE
                                IF (PurchInvHeader."Prices Including VAT" = FALSE) AND (PricesIncludingVAT = FALSE) THEN BEGIN
                                    DirectUnitCost := "Direct Unit Cost";
                                    LineDiscAmount := "Line Discount Amount";
                                END ELSE
                                    IF (PurchInvHeader."Prices Including VAT" = TRUE) AND (PricesIncludingVAT = FALSE) THEN BEGIN
                                        DirectUnitCost := "Direct Unit Cost" / (1 + "VAT %" / 100);
                                        LineDiscAmount := "Line Discount Amount" / (1 + "VAT %" / 100);
                                    END ELSE
                                        IF (PurchInvHeader."Prices Including VAT" = FALSE) AND (PricesIncludingVAT = TRUE) THEN BEGIN
                                            DirectUnitCost := "Direct Unit Cost" * (1 + "VAT %" / 100);
                                            LineDiscAmount := "Line Discount Amount" * (1 + "VAT %" / 100);
                                        END;
                        END;
                        //++MARS_TWN-6594.GG
                        CLEAR(Item);
                        IF Item.GET("No.") THEN;
                        //--MARS_TWN-6594.GG
                    end;

                }
                trigger OnPreDataItem()
                begin

                end;

                trigger OnAfterGetRecord()
                begin
                    PrintPurchSection := TRUE;

                    NoofPurchInvLine := 0;
                    CLEAR(PurchInvLine);
                    PurchInvLine.SETRANGE("Document No.", "Purch. Inv. Header"."No.");
                    PurchInvLine.SETFILTER(Type, '<>%1', PurchInvLine.Type::" ");
                    PurchInvLine.SETFILTER("No.", '<>%1', '');
                    NoofPurchInvLine := PurchInvLine.COUNT;
                    // Start 112117
                    IsPurchaseInvoiceG := 1;
                    // Stop 112117
                end;
            }
            dataitem("Purch. Cr. Memo Hdr."; "Purch. Cr. Memo Hdr.")
            {
                DataItemTableView = sorting("No.") order(ascending);
                DataItemLinkReference = Integer;
                column(PrintPurchReturnSection; PrintPurchReturnSection) { }
                column(PurchCrMemoHeader_PostingDate; FORMAT("Posting Date", 0, '<Year4>/<Month,2>/<Day,2>')) { }
                column(PurchCrMemoHeader_No_; "No.") { }
                column(PurchCrMemoHeader_Pay2Name; "Pay-to Name") { }
                column(PurchCrMemoHeader_VendorCrMemoNo_; "Vendor Cr. Memo No.") { }
                column(NoofPurchCrMemoLine; NoofPurchCrMemoLine) { }
                dataitem("Purch. Cr. Memo Line"; "Purch. Cr. Memo Line")
                {
                    DataItemTableView = sorting("Document No.", "Line No.") order(ascending);
                    DataItemLinkReference = "Purch. Cr. Memo Hdr.";
                    DataItemLink = "Document No." = field("No.");
                    column(PurchCrMemoLine_PostingDate; FORMAT("Posting Date", 0, '<Year4>/<Month,2>/<Day,2>')) { }
                    column(PurchCrMemoLine_DocumentNo_; "Document No.") { }
                    column(PurchCrMemoLine_Description; Description) { }
                    column(PurchCrMemoLine_Quantity; Quantity) { }
                    column(PurchCrMemoLine_DirectUnitCost; DirectUnitCost) { }
                    column(PurchCrMemoLine_LineDiscAmount; LineDiscAmount) { }
                    column(PurchCrMemoLine_TaxAmount; "Amount Including VAT" - Amount) { }
                    column(PurchCrMemoLine_AmountInclVAT; "Amount Including VAT") { }
                    column(IsPurchaseCredieMemoG; IsPurchaseCredieMemoG) { }
                    column(PurchCrMemoLine_ThreadPattenCode; Item."Tread Patterncode/Modelcode") { }
                    column(PurchCrMemoLine_ThreadAddonInfo; Item."Tread Addon Information") { }
                    trigger OnPreDataItem()
                    begin
                        IF (FltType = '') THEN BEGIN
                            SETFILTER(Type, '<>''''');
                        END ELSE BEGIN
                            SETFILTER(Type, FltType);
                        END;
                        SETFILTER("No.", FltNo);
                        SETFILTER("Item Category Code", FltItemCategoryCode);
                    end;

                    trigger OnAfterGetRecord()
                    var
                        PurchCreditMemoHeader: Record "Purch. Cr. Memo Hdr.";
                    begin
                        IF NOT PurchCreditMemoHeader.GET("Document No.") THEN BEGIN
                            DirectUnitCost := "Direct Unit Cost";
                            LineDiscAmount := "Line Discount Amount";
                        END ELSE BEGIN
                            IF (PurchCreditMemoHeader."Prices Including VAT" = TRUE) AND (PricesIncludingVAT = TRUE) THEN BEGIN
                                DirectUnitCost := "Direct Unit Cost";
                                LineDiscAmount := "Line Discount Amount";
                            END ELSE
                                IF (PurchCreditMemoHeader."Prices Including VAT" = FALSE) AND (PricesIncludingVAT = FALSE) THEN BEGIN
                                    DirectUnitCost := "Direct Unit Cost";
                                    LineDiscAmount := "Line Discount Amount";
                                END ELSE
                                    IF (PurchCreditMemoHeader."Prices Including VAT" = TRUE) AND (PricesIncludingVAT = FALSE) THEN BEGIN
                                        DirectUnitCost := "Direct Unit Cost" / (1 + "VAT %" / 100);
                                        LineDiscAmount := "Line Discount Amount" / (1 + "VAT %" / 100);
                                    END ELSE
                                        IF (PurchCreditMemoHeader."Prices Including VAT" = FALSE) AND (PricesIncludingVAT = TRUE) THEN BEGIN
                                            DirectUnitCost := "Direct Unit Cost" * (1 + "VAT %" / 100);
                                            LineDiscAmount := "Line Discount Amount" * (1 + "VAT %" / 100);
                                        END;
                        END;
                        //++MARS_TWN-6594.GG
                        CLEAR(Item);
                        IF Item.GET("No.") THEN;
                        //--MARS_TWN-6594.GG
                    end;

                }
                trigger OnPreDataItem()
                begin
                    SETRANGE("Posting Date", StartDate, EndDate);

                    IF FltRespCenter <> '' THEN
                        SETRANGE("Responsibility Center", FltRespCenter);

                    IF VendorNo <> '' THEN
                        SETFILTER("Buy-from Vendor No.", VendorNo);
                    SETFILTER("Buy-from Contact No.", ContactNo);
                end;

                trigger OnAfterGetRecord()
                begin
                    NoofPurchCrMemoLine := 0;
                    CLEAR(PurchCrMemoLine);
                    PurchCrMemoLine.SETRANGE("Document No.", "Purch. Cr. Memo Hdr."."No.");
                    PurchCrMemoLine.SETFILTER(Type, '<>%1', PurchCrMemoLine.Type::" ");
                    PurchCrMemoLine.SETFILTER("No.", '<>%1', '');
                    NoofPurchCrMemoLine := PurchCrMemoLine.COUNT;
                    // Start 112117
                    IsPurchaseCredieMemoG := 1;
                    // Stop 112117
                end;
            }
            trigger OnPreDataItem()
            begin
                CompanyInfo.GET;
                CompanyInfo.CALCFIELDS(CompanyInfo.Picture);

                IF RespCenter.GET(UserMgt.GetSalesFilter()) THEN BEGIN
                    FormatAddr.RespCenter(CompanyAddr, RespCenter);

                    CompanyInfo.Name := RespCenter.Name;
                    CompanyInfo."Name 2" := RespCenter."Name 2";
                    CompanyInfo.Address := RespCenter.Address;
                    CompanyInfo."Address 2" := RespCenter."Address 2";
                    CompanyInfo.City := RespCenter.City;
                    CompanyInfo."Post Code" := RespCenter."Post Code";
                    CompanyInfo.County := RespCenter.County;
                    CompanyInfo."Country/Region Code" := RespCenter."Country/Region Code";
                    CompanyInfo."Phone No." := RespCenter."Phone No.";
                    CompanyInfo."Fax No." := RespCenter."Fax No.";
                END ELSE BEGIN
                    FormatAddr.Company(CompanyAddr, CompanyInfo);
                END;

                IF NOT PricesIncludingVAT THEN
                    DirectUnitCost_Caption := DirectUnitCostExclVAT_CaptionLbl
                ELSE
                    DirectUnitCost_Caption := DirectUnitCostInclVAT_CaptionLbl;
            end;
        }
    }
    requestpage
    {
        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field("Print Summary"; PrintSummary)
                    {
                        Caption = 'Print Summary';
                    }
                    field("Prices Including VAT"; PricesIncludingVAT)
                    {
                        Caption = 'Prices Including VAT';
                    }
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
        MUTFuncs.AddUsageTrackingEntry('MUT_6020');
    end;

    trigger OnPreReport()
    begin
        StartDate := "Purch. Inv. Header".GETRANGEMIN("Posting Date");
        EndDate := "Purch. Inv. Header".GETRANGEMAX("Posting Date");

        VendorNo := "Purch. Inv. Header".GETFILTER("Buy-from Vendor No.");
        FltRespCenter := "Purch. Inv. Header".GETFILTER("Responsibility Center");
        ContactNo := "Purch. Inv. Header".GETFILTER("Buy-from Contact No.");
        FltType := "Purch. Inv. Line".GETFILTER(Type);
        FltNo := "Purch. Inv. Line".GETFILTER("No.");
        FltItemCategoryCode := "Purch. Inv. Line".GETFILTER("Item Category Code");

        Filters := "Purch. Inv. Header".GETFILTERS;
    end;

    trigger OnPostReport()
    begin

    end;

    var
        PurchInvHeader: Record "Purch. Inv. Header";
        Vendor: Record Vendor;
        Item: Record Item;
        VendorNo: Code[1024];
        PurchCrMemoHdr: Record "Purch. Cr. Memo Hdr.";
        StartDate: Date;
        EndDate: Date;
        PrintSummary: Boolean;
        PricesIncludingVAT: Boolean;
        PrintPurchSection: Boolean;
        PrintPurchReturnSection: Boolean;
        CompanyInfo: Record "Company Information";
        RespCenter: Record "Responsibility Center";
        FormatAddr: Codeunit "Format Address";
        CompanyAddr: array[8] of Text[50];
        UserMgt: Codeunit "User Setup Management";
        Filters: Text[1024];
        MUTFuncs: Codeunit "Usage Tracking";
        DirectUnitCost: Decimal;
        LineDiscAmount: Decimal;
        ContactNo: Code[1024];
        FltRespCenter: Code[1024];
        FltType: Code[1024];
        FltNo: Code[1024];
        FltItemCategoryCode: Code[1024];
        DirectUnitCost_Caption: Text[30];
        PurchInvLine: Record "Purch. Inv. Line";
        PurchCrMemoLine: Record "Purch. Cr. Memo Line";
        NoofPurchInvLine: Integer;
        NoofPurchCrMemoLine: Integer;
        IsPurchaseInvoiceG: Integer;
        IsPurchaseCredieMemoG: Integer;
        ReportTitle_CaptionLbl: label 'Daily Purchase Register';
        PageCaptionLbl: Label 'Page';
        Purch_RegisterCaptionLbl: Label 'Purchase Register';
        Purch_ReturnCaptionLbl: Label 'Purchase Return';
        PostingDate_CaptionLbl: Label 'Posting Date';
        InvoiceNo_CaptionLbl: Label 'Invoice No.';
        Pay2Name_CaptionLbl: Label 'Name of Vendor';
        VendorInvNo_CaptionLbl: Label 'Vendor Invoice No.';
        DescriptionCaptionLbl: Label 'Description';
        ThreadPattern_CaptionLbl: Label 'Tread Patterncode/Modelcode';
        ThreadAddon_CaptionLbl: Label 'Tread Addon Information';
        Qty_CaptionLbl: Label 'Qty';
        DirectUnitCostInclVAT_CaptionLbl: Label 'Direct Unit Cost (Incl. VAT)';
        DirectUnitCostExclVAT_CaptionLbl: Label 'Direct Unit Cost  (Excl. VAT)';
        LineDiscAmt_CaptionLbl: Label 'Line Disc.Amt';
        TaxAmt_CaptionLbl: Label 'Tax Amount';
        Amount_CaptionLbl: Label 'Amount to Vendor';
        NetTotal_CaptionLbl: Label 'Net Total';
        GrandTotal_CaptionLbl: Label 'Grand Total';
        Total_CaptionLbl: Label 'Total';
}
