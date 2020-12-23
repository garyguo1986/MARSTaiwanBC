report 50015 "BSS Cash Reg. Rece. Inv. Upgra"
{
    // +--------------------------------------------------------------+
    // | @ 2017 incadea Taiwan Limited                                |
    // +--------------------------------------------------------------+
    // | PURPOSE: MARS_TWN                                            |
    // |                                                              |
    // | REMARK :                                                     |
    // +--------------------------------------------------------------+

    // VERSION     ID          WHO    DATE        DESCRIPTION
    // RGS_TWN-395             AH     2017-05-02  INITIAL RELEASE    
    dataset
    {
        dataitem(PostedCashRegisterHeader; "Posted Cash Register Header")
        {
        }
    }
    requestpage
    {
        layout
        {
            area(content)
            {
                group(GroupName)
                {
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
    var
        GLSetup: Record "General Ledger Setup";
        ShipmentMethod: Record "Shipment Method";
        PaymentTerms: Record "Payment Terms";
        SalesPurchPerson: Record "Salesperson/Purchaser";
        CompanyInfo: Record "Company Information";
        CompanyInfo1: Record "Company Information";
        CompanyInfo2: Record "Company Information";
        SalesSetup: Record "Sales & Receivables Setup";
        Cust: Record Customer;
        VATAmountLine: Record "VAT Amount Line";
        //PostedDocDim1: Record "Posted Document Dimension"; //?GG
        //PostedDocDim2: Record "Posted Document Dimension"; //?GG
        RespCenter: Record "Service Center";
        Language: Record "Language";
        SalesInvCountPrinted: Codeunit "Sales Inv.-Printed";
        FormatAddr: Codeunit "Format Address";
        SegManagement: Codeunit "SegManagement";
        SalesShipmentBuffer: Record "Sales Shipment Buffer";
        PostedShipmentDate: Date;
        CustAddr: Text[50];
        ShipToAddr: Text[50];
        CompanyAddr: Text[50];
        OrderNoText: Text[30];
        SalesPersonText: Text[30];
        VATNoText: Text[30];
        ReferenceText: Text[30];
        TotalText: Text[50];
        TotalExclVATText: Text[50];
        TotalInclVATText: Text[50];
        MoreLines: Boolean;
        NoOfCopies: Integer;
        NoOfLoops: Integer;
        CopyText: Text[30];
        ShowShippingAddr: Boolean;
        i: Integer;
        NextEntryNo: Integer;
        FirstValueEntryNo: Integer;
        DimText: Text[120];
        OldDimText: Text[75];
        ShowInternalInfo: Boolean;
        Continue: Boolean;
        LogInteraction: Boolean;
        _BSS_: Integer;
        RespCtrText: Text[80];
        ProcessNoText: Text[80];
        DepotNoText: Text[80];
        DepotStorageBinNoText: Text[80];
        PricesInclVATText: Text[80];
        VehicleText: Text[80];
        VehicleModelVarText: Text[80];
        ExtDocNoText: Text[80];
        CompanyHdrText: Text[120];
        PmtMethodText: Text[150];
        PaymentMethod: Record "Payment Method";
        LastLineDiscNo: Integer;
        LineDiscText: Text[30];
        MaxLineDiscNo: Integer;
        AmountToPay: Decimal;
        TransExtText: Codeunit "Transfer Extended Text";
        ExtTextHdr: Record "Extended Text Header";
        TmpExtTextLine: Record "Extended Text Line";
        PmtDiscText: Text[80];
        PmtMeansText: Text[80];
        PmtMeansDesc: Text[80];
        PmtMeans: Record "Cash Register Means of Payment";
        IsFirstLine: Boolean;
        FitterName: Text[80];
        SalesPurchPerson2: Record "Salesperson/Purchaser";
        FinalAmountText: Text[30];
        SalesInvLine: Record "Sales Invoice Line";
        CRegLineCnt: Integer;
        NetPrice: Decimal;
        SalesCrMemoCountPrinted: Codeunit "Sales Cr. Memo-Printed";
        SalesCrMemoLine: Record "Sales Cr.Memo Line";
        VATHeaderText: Text[100];
        PaymentDiscountAllowed: Boolean;
        PmtDiscountBase: Decimal;
        DownPaymentAmount: Decimal;
        DownPaymentAmountText: Text[30];
        OpenAmountText: Text[30];
        AmountToAdd: Decimal;
        VehicleDataAvailable: Boolean;
        DepotDataAvailable: Boolean;
        DepotStorageBinNo: Text[80];
        FitterText: Text[80];
        ReportSetting: Record "Report Extended Settings";
        CompanyFooterText: Text[250];
        LogoText: Text[250];
        LogoHeader: Text[250];
        FooterText: Text[250];
        ReportExtTextFunctions: Codeunit "Report Ext. Text Functions";
        DocumentHeaderText: Text[250];
        DisplayHeader: Boolean;
        GenFunc: Codeunit "General Functions";
        CurrReportObjectID: Integer;
        OurAccNoText: Text[250];
        InvDiscountAmtPct: Decimal;
        ReportExtSettings: Record "Report Extended Settings";
        TextNetPrice: Decimal;
        RepExtSettings: Record "Report Extended Settings";
        AddTextZeroPositions: Text[250];
        TransferAmount: Decimal;
        Number2: Text[22];
        LabellingInfo: Text[30];
        LabellingInfoExplanation: Text[100];
        LineAmount: Decimal;
        TextLineAmount: Decimal;
        IsTransAmountSubtract: Boolean;
        _TWN_V: Integer;
        Contact: Record Contact;
        FinalChecker: Record "Salesperson/Purchaser";
        cuUserSetup: Codeunit "User Setup Management";
        cdeLoginResp: Code[20];
        recRespCenter: Record "Service Center";
        recContact: Record Contact;
        TWNFirstLine: Boolean;
        recCustLedgerEntry: Record "Cust. Ledger Entry";
        recServiceAlertSetup: Record "Service Alert Setup";
        decCashTotal: Decimal;
        decOtherTotal: Decimal;
        txtDesc: Text[100];
        intDescLength: Integer;
        decMileage: Decimal;
        txtType: Text[30];
        decNoteTotal: Decimal;
        txtPaymentMethod: Text[100];
        txtPayment: Text[100];
        txtVATRegNo: Text[20];
        LogInteractionEnable: Boolean;
        SalesInvoiceLineShow: Boolean;
        SalesInvoiceLineShow2: Boolean;
        SalesInvoiceLineShow3: Boolean;
        SalesInvoiceLineShow4: Boolean;
        SalesInvoiceLineShow5: Boolean;
        SalesInvoiceLineShow6: Boolean;
        SalesCreditLineShow: Boolean;
        SalesCreditLineShow2: Boolean;
        SalesCreditLineShow3: Boolean;
        SalesCreditLineShow4: Boolean;
        SalesCreditLineShow5: Boolean;
        DiscountBufferCrMShow: Boolean;
        BHLineShow: Boolean;
        SalesCredTotalShow: Boolean;
        SalesCredTotalShow2: Boolean;
        SalesCredTotalShow3: Boolean;
        TotalCrmShow: Boolean;
        CustExtTextFooterCrMShow: Boolean;
        PageLoopCrMFootShow: Boolean;
}
