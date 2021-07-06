report 1044877 "TW Sales Row Data Fill Data"
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
    // RGS_TWN-833   119130        GY     2019-04-08  New Object
    // RGS_TWN-833   119130        WP     2019-06-26  Add Date Update
    //                             WP     2019-07-08  bug fix
    // RGS_TWN-845   120529        GG     2019-09-11  Added field logic "Tire MI Sellout"
    // MI AS 2019-08-02 to optimize the update process
    // MARS_TWN-7689 121036      GG     2019-11-28  Remove "Amount Incl. VAT" filter
    // RGS_TWN-8365  122779        GG     2021-06-01  Use buffer table instand orignal table

    Caption = 'TW Main Dashboard Fill Data';
    ProcessingOnly = true;
    UsageCategory = ReportsAndAnalysis;
    dataset
    {
        dataitem("Service Center"; "Service Center")
        {

            trigger OnAfterGetRecord()
            begin
                PeriodG.RESET;
                PeriodG.SETRANGE("Period Type", PeriodG."Period Type"::Month);
                PeriodG.SETRANGE("Period Start", StartDateG, EndDateG);
                IF PeriodG.FINDFIRST THEN
                    REPEAT
                        InsertOrUpdateTWSalesRawDataBuffer(PeriodG."Period Start", "Service Center");
                    UNTIL PeriodG.NEXT = 0;
            end;

            trigger OnPostDataItem()
            begin
                TWSalesDataHeaderBufferG.RESET;
                ///MI <--
                TWSalesDataHeaderBufferG.SETRANGE(Date, StartDateG, EndDateG);
                ///MI -->
                TWSalesDataHeaderBufferG.FIND('-');
                REPEAT
                    PostedInvoice(TWSalesDataHeaderBufferG);
                    PostedInvoiceWithUpdatedVC(TWSalesDataHeaderBufferG);
                    PostedInvoiceWithAdditionalSales(TWSalesDataHeaderBufferG);
                UNTIL TWSalesDataHeaderBufferG.NEXT = 0;
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
        IndicatorLbl = 'Indicator';
        MonthLbl = 'Month';
        LastYearMonthLbl = 'Y-1';
        RateMonthvsLastYearMonthLbl = 'Month vs Y-1';
        YTDLbl = 'YTD';
        LastYearYTDLbl = 'Y-1';
        RateYTDvsLastYearYTDLbl = 'YTD vs Y-1';
    }

    trigger OnPreReport()
    begin
        //MI <--
        IF (StartDateG = 0D) AND (EndDateG = 0D) THEN BEGIN
            //StartDateG := DMY2DATE(1,1,2017);
            StartDateG := CALCDATE('CM-4M+1D', TODAY);
            EndDateG := TODAY;

            TWSalesDataHeaderBufferG.RESET;
            TWSalesDataHeaderBufferG.SETFILTER(Date, '>=%1', StartDateG);
            TWSalesDataHeaderBufferG.DELETEALL;

            TWSalesDataLineBufferG.RESET;
            TWSalesDataLineBufferG.SETFILTER(Date, '>=%1', StartDateG);
            TWSalesDataLineBufferG.DELETEALL;
        END ELSE BEGIN
            TWSalesDataHeaderBufferG.RESET;
            TWSalesDataHeaderBufferG.DELETEALL;

            //Line
            TWSalesDataLineBufferG.RESET;
            TWSalesDataLineBufferG.DELETEALL;
        END;
        //MI -->
    end;

    var
        TWSalesDataHeaderBufferG: Record "TW Sales Data Header Buffer";
        TWSalesDataLineBufferG: Record "TW Sales Data Line Buffer";
        // SalesInvoiceHeaderG: Record "Sales Invoice Header";
        // SalesInvoiceLineG: Record "Sales Invoice Line";
        // SalesCrMemoHeaderG: Record "Sales Cr.Memo Header";
        // SalesCrMemoLineG: Record "Sales Cr.Memo Line";
        ServiceCenterG: Record "Service Center";
        ServiceCenterCountG: Integer;
        C_INC_Tyre_Overall: Label 'Tyre_Overall';
        C_INC_Tyre_by_POS: Label 'Tyre_by POS';
        C_INC_NTP_Overall: Label 'NTP_Overall';
        C_INC_NTP_byPOS: Label 'NTP_by POS';
        C_INC_Overall: Label 'Overall';
        C_INC_Monthl_Traffic_by_POS: Label 'Monthly Traffic_by POS';
        C_INC_Tyre_MI_BFG: Label 'Tyre (MI + BFG)';
        C_INC_Lub: Label 'Lub.';
        C_INC_Avg_monthly_traffic: Label 'Avg. monthly traffic';
        C_INC_Stable_user: Label '% of stable user';
        C_INC_Report_usage: Label 'Report usage';
        TableKeyInfoG: Record "TW Table Key Information";
        PeriodG: Record Date;
        StartDateG: Date;
        EndDateG: Date;

    local procedure InsertOrUpdateTWSalesRawDataBuffer(PriodStartP: Date; var ServiceCenterP: Record "Service Center")
    var
        YearL: Integer;
        MonthL: Integer;
        ServCenterCodeL: Code[10];
        ManufacturerCodeL: Code[10];
        MainGroupCodeL: Code[10];
        PositionGroupCodeL: Code[10];
        ZoneCodeL: Code[20];
        PostCodeL: Code[20];
        ShopNameL: Text;
    begin
        YearL := DATE2DMY(PriodStartP, 3);
        MonthL := DATE2DMY(PriodStartP, 2);
        ServCenterCodeL := ServiceCenterP.Code;
        ZoneCodeL := ServiceCenterP."Global Dimension 1 Code";
        PostCodeL := ServiceCenterP."Post Code";
        ShopNameL := ServiceCenterP.Name;
        IF NOT TWSalesDataHeaderBufferG.GET(YearL, MonthL, ServCenterCodeL) THEN BEGIN
            TWSalesDataHeaderBufferG.INIT;
            TWSalesDataHeaderBufferG.Year := YearL;
            TWSalesDataHeaderBufferG.Month := MonthL;
            // Start 119130
            TWSalesDataHeaderBufferG.Date := DMY2DATE(1, MonthL, YearL);
            // Stop  119130
            TWSalesDataHeaderBufferG."Service Center" := ServCenterCodeL;
            TWSalesDataHeaderBufferG."Zone Code" := ZoneCodeL;
            TWSalesDataHeaderBufferG."Post Code" := PostCodeL;
            TWSalesDataHeaderBufferG."Shop Name" := ShopNameL;
            TWSalesDataHeaderBufferG.INSERT;
        END;
    end;

    local procedure PostedInvoice(var TWSalesRawDataBufferP: Record "TW Sales Data Header Buffer")
    var
        SalesInvoiceHdrL: Record "Sales Invoice Header Buffer";
        SalesCrMemoHdrL: Record "Sales Cr.Memo Header Buffer";
        SalesInvoiceLineL: Record "Sales Invoice Line Buffer";
        SalesCrMemoLineL: Record "Sales Cr.Memo Line Buffer";
        InvoiceCountL: Decimal;
        CreditCountL: Decimal;
        StartDateL: Date;
        EndDateL: Date;
        SalesAmountL: Decimal;
        CreditAmountL: Decimal;
        CreditAmountTotalL: Decimal;
        SalesAmountTyreL: Decimal;
        CreditAmountTyreL: Decimal;
        CreditAmountTyreTotalL: Decimal;
        SalesAmountNTPL: Decimal;
        CreditAmountNTPL: Decimal;
        CreditAmountNTPTotalL: Decimal;
        SalesAmountServiceL: Decimal;
        CreditAmountServiceL: Decimal;
        CreditAmountServiceTotalL: Decimal;
        SalesQuantityL: Decimal;
        CreditQuantityL: Decimal;
        CreditQuantityTotalL: Decimal;
        SalesProfitL: Decimal;
        CreditProfitL: Decimal;
        CreditProfitTotalL: Decimal;
        SOBTyreAmountL: Decimal;
        CreditSOBTyreAmountL: Decimal;
        CreditSOBTyreAmountTotalL: Decimal;
        SOBNTPAmountL: Decimal;
        CreditSOBNTPAmountL: Decimal;
        CreditSOBNTPAmountTotalL: Decimal;
        SalesTyreQuantityL: Decimal;
        CreditTyreQuantityL: Decimal;
        CreditTyreQuantityTotalL: Decimal;
        SalesTyreMIBFGQuantityL: Decimal;
        CreditTyreMIBFGQuantityL: Decimal;
        CreditTyreMIBFGQuantityTotalL: Decimal;
        SalesMIQtyL: Decimal;
        CreditSalesMIQtyL: Decimal;
        CreditSalesMIQtyTotalL: Decimal;
        FinalSalesAmountL: Decimal;
        IsNeedSkipL: Boolean;
    begin
        StartDateL := DMY2DATE(1, TWSalesRawDataBufferP.Month, TWSalesRawDataBufferP.Year);
        EndDateL := CALCDATE('CM', StartDateL);

        SalesInvoiceHdrL.RESET;
        SalesInvoiceHdrL.SETRANGE("Posting Date", StartDateL, EndDateL);
        SalesInvoiceHdrL.SETRANGE("Service Center", TWSalesRawDataBufferP."Service Center");
        // Start 121036
        //SalesInvoiceHdrL.SETFILTER("Amount Including VAT",'<>%1',0);
        //InvoiceCountL := SalesInvoiceHdrL.COUNT;
        InvoiceCountL := 0;
        // Stop 121036
        SalesAmountL := 0;
        SalesAmountTyreL := 0;
        SalesQuantityL := 0;
        SalesProfitL := 0;
        SOBTyreAmountL := 0;
        SOBNTPAmountL := 0;
        SalesTyreQuantityL := 0;
        SalesTyreMIBFGQuantityL := 0;
        // Start 120529
        SalesMIQtyL := 0;
        // Stop 120529
        IF SalesInvoiceHdrL.FINDFIRST THEN
            REPEAT
                // Start 121036
                IsNeedSkipL := IsSaleInvoiceDeleted(SalesInvoiceHdrL);
                IF (NOT IsNeedSkipL) THEN BEGIN
                    InvoiceCountL := InvoiceCountL + 1;
                    // Stop 121036
                    SalesInvoiceHdrL.CALCFIELDS("Amount Including VAT");
                    SalesAmountL += SalesInvoiceHdrL."Amount Including VAT";
                    SalesInvoiceLineL.RESET;
                    SalesInvoiceLineL.SetRange("Service Center Key", SalesInvoiceHdrL."Service Center Key");
                    SalesInvoiceLineL.SETRANGE("Document No.", SalesInvoiceHdrL."No.");
                    SalesInvoiceLineL.SETFILTER("No.", '<>%1', '');
                    IF SalesInvoiceLineL.FINDFIRST THEN
                        REPEAT
                            IF IsTyre(SalesInvoiceLineL."No.") THEN BEGIN
                                SalesAmountTyreL += SalesInvoiceLineL."Amount Including VAT";
                            END;
                            IF IsNonTyre(SalesInvoiceLineL."No.") THEN BEGIN
                                SalesAmountNTPL += SalesInvoiceLineL."Amount Including VAT";
                            END;
                            IF IsService(SalesInvoiceLineL."No.") THEN BEGIN
                                SalesAmountServiceL += SalesInvoiceLineL."Amount Including VAT";
                            END;
                            SalesQuantityL += SalesInvoiceLineL."Quantity (Base)";
                            SalesProfitL += (SalesInvoiceLineL."Amount Including VAT" - SalesInvoiceLineL."Unit Cost");
                            IF IsSOBTyre(SalesInvoiceLineL."No.") THEN BEGIN
                                SOBTyreAmountL += SalesInvoiceLineL."Amount Including VAT";
                            END;
                            IF IsSOBNTP(SalesInvoiceLineL."No.") THEN BEGIN
                                SOBNTPAmountL += SalesInvoiceLineL."Amount Including VAT";
                            END;
                            IF IsTyre(SalesInvoiceLineL."No.") THEN BEGIN
                                SalesTyreQuantityL += SalesInvoiceLineL."Quantity (Base)";
                            END;
                            IF IsTyreMIFBG(SalesInvoiceLineL."No.") THEN BEGIN
                                SalesTyreMIBFGQuantityL += SalesInvoiceLineL."Quantity (Base)";
                            END;
                            // Start 120529
                            IF IsMI(SalesInvoiceLineL."No.") THEN
                                SalesMIQtyL += SalesInvoiceLineL."Quantity (Base)";
                            // Stop 120529
                            //Line
                            InsertOrUpdateTWSalesDataLineInvoiceBuffer(SalesInvoiceLineL);
                        UNTIL SalesInvoiceLineL.NEXT = 0;
                    // Start 121036
                END;
            // Stop 121036
            UNTIL SalesInvoiceHdrL.NEXT = 0;
        CreditCountL := 0;
        CreditAmountL := 0;
        CreditAmountTotalL := 0;
        CreditAmountTyreL := 0;
        CreditAmountTyreTotalL := 0;
        CreditAmountNTPL := 0;
        CreditAmountNTPTotalL := 0;
        CreditQuantityL := 0;
        CreditQuantityTotalL := 0;
        CreditProfitL := 0;
        CreditProfitTotalL := 0;
        CreditSOBTyreAmountL := 0;
        CreditSOBTyreAmountTotalL := 0;
        CreditSOBNTPAmountL := 0;
        CreditSOBNTPAmountTotalL := 0;
        CreditTyreQuantityL := 0;
        CreditTyreQuantityTotalL := 0;
        CreditTyreMIBFGQuantityL := 0;
        CreditTyreMIBFGQuantityTotalL := 0;
        // Start 120529
        CreditSalesMIQtyL := 0;
        CreditSalesMIQtyTotalL := 0;
        // Stop 120529
        //SalesInvoiceHdrL.SETFILTER("Canceled By", '<>%1', '');
        SalesInvoiceHdrL.SetRange(Cancelled, true);
        IF SalesInvoiceHdrL.FINDFIRST THEN
            REPEAT
                IF CheckCancelledInvoice(SalesInvoiceHdrL, CreditAmountL) THEN BEGIN
                    CreditCountL += 1;
                END;
                // Except Count others calculate ignore amount
                CreditAmountTotalL += CreditAmountL;
                // Start 120529
                CheckCancelledInvoiceLine(SalesInvoiceHdrL, CreditAmountTyreL, CreditAmountNTPL, CreditAmountServiceL, CreditQuantityL, CreditProfitL,
                  CreditSOBTyreAmountL, CreditSOBNTPAmountL, CreditTyreQuantityL, CreditTyreMIBFGQuantityL, CreditSalesMIQtyL);
                // Stop 120529
                CreditAmountTyreTotalL += CreditAmountTyreL;
                CreditAmountNTPTotalL += CreditAmountNTPL;
                CreditAmountServiceTotalL += CreditAmountServiceL;
                CreditQuantityTotalL += CreditQuantityL;
                CreditProfitTotalL += CreditProfitL;
                CreditSOBTyreAmountTotalL += CreditSOBTyreAmountL;
                CreditSOBNTPAmountTotalL += CreditSOBNTPAmountL;
                CreditTyreQuantityTotalL += CreditTyreQuantityL;
                CreditTyreMIBFGQuantityTotalL += CreditTyreMIBFGQuantityL;
                // Start 120529
                CreditSalesMIQtyTotalL += CreditSalesMIQtyL;
            // Stop 120529
            UNTIL SalesInvoiceHdrL.NEXT = 0;

        InsertSalesInvoiceHeaderBuffer(TWSalesRawDataBufferP, TWSalesDataHeaderBufferG.FIELDNO("Posted Invoice Count"), InvoiceCountL - CreditCountL);
        FinalSalesAmountL := 0;
        FinalSalesAmountL := SalesAmountL - CreditAmountTotalL;
        InsertSalesInvoiceHeaderBuffer(TWSalesRawDataBufferP, TWSalesDataHeaderBufferG.FIELDNO("Sales Amount"), SalesAmountL - CreditAmountTotalL);
        InsertSalesInvoiceHeaderBuffer(TWSalesRawDataBufferP, TWSalesDataHeaderBufferG.FIELDNO("Sales Amount Tyre"), SalesAmountTyreL - CreditAmountTyreTotalL);
        InsertSalesInvoiceHeaderBuffer(TWSalesRawDataBufferP, TWSalesDataHeaderBufferG.FIELDNO("Sales Amount Non Tyre"), SalesAmountNTPL - CreditAmountNTPTotalL);
        InsertSalesInvoiceHeaderBuffer(TWSalesRawDataBufferP, TWSalesDataHeaderBufferG.FIELDNO("Sales Amount Service"), SalesAmountServiceL - CreditAmountServiceTotalL);
        InsertSalesInvoiceHeaderBuffer(TWSalesRawDataBufferP, TWSalesDataHeaderBufferG.FIELDNO("Sales invoiced Qty"), SalesQuantityL - CreditQuantityTotalL);
        IF FinalSalesAmountL <> 0 THEN BEGIN
            InsertSalesInvoiceHeaderBuffer(TWSalesRawDataBufferP, TWSalesDataHeaderBufferG.FIELDNO("GM %"), (SalesProfitL - CreditProfitTotalL) / FinalSalesAmountL);
            InsertSalesInvoiceHeaderBuffer(TWSalesRawDataBufferP, TWSalesDataHeaderBufferG.FIELDNO("SOB Tyre related services"), (SOBTyreAmountL - CreditSOBTyreAmountTotalL) / FinalSalesAmountL);
            InsertSalesInvoiceHeaderBuffer(TWSalesRawDataBufferP, TWSalesDataHeaderBufferG.FIELDNO("SOB NTP and Services"), (SOBNTPAmountL - CreditSOBNTPAmountTotalL) / FinalSalesAmountL);
        END ELSE BEGIN
            InsertSalesInvoiceHeaderBuffer(TWSalesRawDataBufferP, TWSalesDataHeaderBufferG.FIELDNO("GM %"), 0.0);
            InsertSalesInvoiceHeaderBuffer(TWSalesRawDataBufferP, TWSalesDataHeaderBufferG.FIELDNO("SOB Tyre related services"), 0.0);
            InsertSalesInvoiceHeaderBuffer(TWSalesRawDataBufferP, TWSalesDataHeaderBufferG.FIELDNO("SOB NTP and Services"), 0.0);
        END;
        InsertSalesInvoiceHeaderBuffer(TWSalesRawDataBufferP, TWSalesDataHeaderBufferG.FIELDNO("Tyre Sales A1"), SalesTyreQuantityL - CreditTyreQuantityTotalL);
        InsertSalesInvoiceHeaderBuffer(TWSalesRawDataBufferP, TWSalesDataHeaderBufferG.FIELDNO("Tyre Sales MI BFG"), SalesTyreMIBFGQuantityL - CreditTyreMIBFGQuantityTotalL);
        // Start 120529
        InsertSalesInvoiceHeaderBuffer(TWSalesRawDataBufferP, TWSalesDataHeaderBufferG.FIELDNO("Tire MI Sellout"), SalesMIQtyL - CreditSalesMIQtyTotalL);
        // Stop 120529
        //Line
        SalesCrMemoHdrL.RESET;
        SalesCrMemoHdrL.SETRANGE("Posting Date", StartDateL, EndDateL);
        SalesCrMemoHdrL.SETRANGE("Service Center", TWSalesRawDataBufferP."Service Center");
        IF SalesCrMemoHdrL.FINDFIRST THEN
            REPEAT
                SalesCrMemoLineL.RESET;
                SalesCrMemoLineL.SetRange("Service Center Key", SalesCrMemoHdrL."Service Center Key");
                SalesCrMemoLineL.SETRANGE("Document No.", SalesCrMemoHdrL."No.");
                SalesCrMemoLineL.SETFILTER("No.", '<>%1', '');
                IF SalesCrMemoLineL.FINDFIRST THEN
                    REPEAT
                        InsertOrUpdateTWSalesDataLineCreditBuffer(SalesCrMemoLineL);
                    UNTIL SalesCrMemoLineL.NEXT = 0;
            UNTIL SalesCrMemoHdrL.NEXT = 0;
    end;

    local procedure PostedInvoiceWithUpdatedVC(var TWSalesRawDataBufferP: Record "TW Sales Data Header Buffer")
    var
        SalesInvoiceHdrL: Record "Sales Invoice Header Buffer";
        SalesCrMemoHdrL: Record "Sales Cr.Memo Header Buffer";
        StartDateL: Date;
        EndDateL: Date;
        InvoiceCountL: Decimal;
        CreditCountL: Decimal;
        CreditAmountL: Decimal;
    begin
        StartDateL := DMY2DATE(1, TWSalesRawDataBufferP.Month, TWSalesRawDataBufferP.Year);
        EndDateL := CALCDATE('CM', StartDateL);

        SalesInvoiceHdrL.RESET;
        SalesInvoiceHdrL.SETRANGE("Posting Date", StartDateL, EndDateL);
        SalesInvoiceHdrL.SETRANGE("Service Center", TWSalesRawDataBufferP."Service Center");
        //++TWN1.00.122187.QX
        // Field 'Vehicle Check Status' is removed.
        // SalesInvoiceHdrL.SETRANGE("Vehicle Check Status", SalesInvoiceHdrL."Vehicle Check Status"::Done);
        //--TWN1.00.122187.QX

        // Start 121036
        //SalesInvoiceHdrL.SETFILTER("Amount Including VAT",'<>%1',0);
        // Stop 121036
        InvoiceCountL := SalesInvoiceHdrL.COUNT;
        CreditCountL := 0;
        //SalesInvoiceHdrL.SETFILTER("Canceled By", '<>%1', '');
        SalesInvoiceHdrL.SetRange(Cancelled, true);
        IF SalesInvoiceHdrL.FINDFIRST THEN
            REPEAT
                IF CheckCancelledInvoice(SalesInvoiceHdrL, CreditAmountL) THEN
                    CreditCountL += 1;
            UNTIL SalesInvoiceHdrL.NEXT = 0;

        InsertSalesInvoiceHeaderBuffer(TWSalesRawDataBufferP, TWSalesDataHeaderBufferG.FIELDNO("Posted Invoice with updated VC"), InvoiceCountL - CreditCountL);
    end;

    local procedure PostedInvoiceWithAdditionalSales(var TWSalesRawDataBufferP: Record "TW Sales Data Header Buffer")
    var
        SalesInvoiceHdrL: Record "Sales Invoice Header Buffer";
        SalesCrMemoHdrL: Record "Sales Cr.Memo Header Buffer";
        StartDateL: Date;
        EndDateL: Date;
        InvoiceCountL: Decimal;
        CreditCountL: Decimal;
        CreditAmountL: Decimal;
        AddSalesL: Integer;
    begin
        StartDateL := DMY2DATE(1, TWSalesRawDataBufferP.Month, TWSalesRawDataBufferP.Year);
        EndDateL := CALCDATE('CM', StartDateL);

        SalesInvoiceHdrL.RESET;
        SalesInvoiceHdrL.SETRANGE("Posting Date", StartDateL, EndDateL);
        SalesInvoiceHdrL.SETRANGE("Service Center", TWSalesRawDataBufferP."Service Center");
        InvoiceCountL := 0;
        CreditCountL := 0;
        IF SalesInvoiceHdrL.FINDFIRST THEN
            REPEAT
                IF NOT CheckCancelledInvoice(SalesInvoiceHdrL, CreditAmountL) THEN BEGIN
                    IF CheckAdditionalSales(SalesInvoiceHdrL) THEN
                        InvoiceCountL += 1;
                END;
            UNTIL SalesInvoiceHdrL.NEXT = 0;

        InsertSalesInvoiceHeaderBuffer(TWSalesRawDataBufferP, TWSalesDataHeaderBufferG.FIELDNO("Posted Inv. with add. Sales"), InvoiceCountL);
    end;

    local procedure CheckCancelledInvoice(SalesInvoiceHdrP: Record "Sales Invoice Header Buffer"; var CreditAmountP: Decimal): Boolean
    var
        SalesCrMemoHdrL: Record "Sales Cr.Memo Header Buffer";
        SalesCrMemoLineL: Record "Sales Cr.Memo Line Buffer";
        SalesInvLineL: Record "Sales Invoice Line Buffer";
        CancelledDocL: Record "Cancelled Document Buffer";
        InvTotalQtyL: Decimal;
    begin
        CreditAmountP := 0;
        if CancelledDocL.Get(SalesInvoiceHdrP."Service Center Key", 112, SalesInvoiceHdrP."No.") then begin
            if SalesCrMemoHdrL.Get(CancelledDocL."Service Center Key", CancelledDocL."Cancelled By Doc. No.") then begin
                SalesInvLineL.SetRange("Service Center Key", SalesInvoiceHdrP."Service Center Key");
                SalesInvLineL.SETRANGE("Document No.", SalesInvoiceHdrP."No.");
                SalesInvLineL.CALCSUMS(Quantity);
                REPEAT
                    SalesCrMemoLineL.SetRange("Service Center Key", SalesCrMemoHdrL."Service Center Key");
                    SalesCrMemoLineL.SETRANGE("Document No.", SalesCrMemoHdrL."No.");
                    SalesCrMemoLineL.CALCSUMS(Quantity);
                    SalesInvLineL.Quantity -= SalesCrMemoLineL.Quantity;

                    SalesCrMemoHdrL.CALCFIELDS("Amount Including VAT");
                    CreditAmountP += SalesCrMemoHdrL."Amount Including VAT";
                UNTIL SalesCrMemoHdrL.NEXT = 0;
                IF SalesInvLineL.Quantity > 0 THEN
                    EXIT(TRUE);
            end;
        end;
        // Start 119130
        // SalesCrMemoHdrL.SETRANGE("Corr. of Sales Invoice No.", SalesInvoiceHdrP."No.");
        // IF SalesCrMemoHdrL.FINDSET THEN BEGIN
        //     SalesInvLineL.SETRANGE("Document No.", SalesInvoiceHdrP."No.");
        //     SalesInvLineL.CALCSUMS(Quantity);
        //     REPEAT
        //         SalesCrMemoLineL.SETRANGE("Document No.", SalesCrMemoHdrL."No.");
        //         SalesCrMemoLineL.CALCSUMS(Quantity);
        //         SalesInvLineL.Quantity -= SalesCrMemoLineL.Quantity;

        //         SalesCrMemoHdrL.CALCFIELDS("Amount Including VAT");
        //         CreditAmountP += SalesCrMemoHdrL."Amount Including VAT";
        //     UNTIL SalesCrMemoHdrL.NEXT = 0;
        //     IF SalesInvLineL.Quantity > 0 THEN
        //         EXIT(TRUE);
        // END;
        /*
        IF SalesCrMemoHdrL.GET(SalesInvoiceHdrP."Canceled By") THEN BEGIN
          SalesCrMemoHdrL.CALCFIELDS("Amount Including VAT");
          SalesInvoiceHdrP.CALCFIELDS("Amount Including VAT");
          CreditAmountP := SalesCrMemoHdrL."Amount Including VAT";
          IF SalesCrMemoHdrL."Amount Including VAT" = SalesInvoiceHdrP."Amount Including VAT" THEN
            EXIT(TRUE);
        END;
        */
        // Stop  119130
        EXIT(FALSE);

    end;

    local procedure CheckCancelledInvoiceLine(SalesInvoiceHdrP: Record "Sales Invoice Header Buffer"; var CreditAmountP: Decimal; var CreditAmountNTPP: Decimal; var CreditAmountServiceP: Decimal; var CreditQuantityP: Decimal; var CreditProfitP: Decimal; var CreditSOBTyreAmountP: Decimal; var CreditSOBNTPAmountP: Decimal; var CreditTyreQuantityP: Decimal; var CreditTyreMIFBGQuantityP: Decimal; var CreditMIQuantityP: Decimal): Boolean
    var
        SalesCrMemoHdrL: Record "Sales Cr.Memo Header Buffer";
        SalesCrMemoLineL: Record "Sales Cr.Memo Line Buffer";
    begin
        CreditAmountP := 0;
        CreditTyreQuantityP := 0;
        CreditAmountNTPP := 0;
        CreditAmountServiceP := 0;
        CreditSOBTyreAmountP := 0;
        CreditSOBNTPAmountP := 0;
        CreditTyreMIFBGQuantityP := 0;
        CreditQuantityP := 0;
        CreditProfitP := 0;
        // Start 120529
        CreditMIQuantityP := 0;
        // Stop 120529
        // Start 119130
        SalesCrMemoHdrL.SETRANGE("Corr. of Sales Invoice No.", SalesInvoiceHdrP."No.");
        IF SalesCrMemoHdrL.FINDSET THEN
            REPEAT
                //IF SalesCrMemoHdrL.GET(SalesInvoiceHdrP."Canceled By") THEN BEGIN
                // Stop 119130
                SalesCrMemoLineL.RESET;
                SalesCrMemoLineL.SetRange("Service Center Key", SalesCrMemoHdrL."Service Center Key");
                SalesCrMemoLineL.SETRANGE("Document No.", SalesCrMemoHdrL."No.");
                SalesCrMemoLineL.SETFILTER("No.", '<>%1', '');
                IF SalesCrMemoLineL.FINDFIRST THEN
                    REPEAT
                        IF IsTyre(SalesCrMemoLineL."No.") THEN BEGIN
                            CreditAmountP += SalesCrMemoLineL."Amount Including VAT";
                            CreditTyreQuantityP += SalesCrMemoLineL."Quantity (Base)";
                        END;
                        IF IsNonTyre(SalesCrMemoLineL."No.") THEN BEGIN
                            CreditAmountNTPP += SalesCrMemoLineL."Amount Including VAT";
                        END;
                        IF IsService(SalesCrMemoLineL."No.") THEN BEGIN
                            CreditAmountServiceP += SalesCrMemoLineL."Amount Including VAT";
                        END;

                        IF IsSOBTyre(SalesCrMemoLineL."No.") THEN BEGIN
                            CreditSOBTyreAmountP += SalesCrMemoLineL."Amount Including VAT";
                        END;
                        IF IsSOBNTP(SalesCrMemoLineL."No.") THEN BEGIN
                            CreditSOBNTPAmountP += SalesCrMemoLineL."Amount Including VAT";
                        END;
                        IF IsTyreMIFBG(SalesCrMemoLineL."No.") THEN BEGIN
                            CreditTyreMIFBGQuantityP += SalesCrMemoLineL."Quantity (Base)";
                        END;
                        // Start 120529
                        IF IsMI(SalesCrMemoLineL."No.") THEN
                            CreditMIQuantityP += SalesCrMemoLineL."Quantity (Base)";
                        // Stop 120529
                        CreditQuantityP += SalesCrMemoLineL."Quantity (Base)";
                        CreditProfitP += (SalesCrMemoLineL."Amount Including VAT" - SalesCrMemoLineL."Unit Cost");
                    UNTIL SalesCrMemoLineL.NEXT = 0;
            // Start 119130
            //END;
            UNTIL SalesCrMemoHdrL.NEXT = 0;
        // Stop  119130
    end;

    local procedure CheckAdditionalSales(SalesInvoiceHdrP: Record "Sales Invoice Header Buffer"): Boolean
    var
        SalesInvoiceLineL: Record "Sales Invoice Line Buffer";
        IsExistadditionalSalesL: Boolean;
        IsNotExistadditionalSalesL: Boolean;
    begin
        SalesInvoiceLineL.RESET;
        SalesInvoiceLineL.SetRange("Service Center Key", SalesInvoiceHdrP."Service Center Key");
        SalesInvoiceLineL.SETRANGE("Document No.", SalesInvoiceHdrP."No.");
        SalesInvoiceLineL.SETRANGE("Additional Sale", TRUE);
        IF NOT SalesInvoiceLineL.ISEMPTY THEN
            IsExistadditionalSalesL := TRUE;
        SalesInvoiceLineL.SETRANGE("Additional Sale", FALSE);
        IF NOT SalesInvoiceLineL.ISEMPTY THEN
            IsNotExistadditionalSalesL := TRUE;

        IF IsExistadditionalSalesL AND IsNotExistadditionalSalesL THEN
            EXIT(TRUE);

        EXIT(FALSE);
    end;

    local procedure InsertSalesInvoiceHeaderBuffer(var TWSalesRawDataBufferP: Record "TW Sales Data Header Buffer"; FieldNoP: Integer; FieldValueP: Variant)
    var
        ItemL: Record Item;
        ResourceL: Record Resource;
        YearL: Integer;
        MonthL: Integer;
        ServCenterCodeL: Code[10];
        ManufacturerCodeL: Code[10];
        MainGroupCodeL: Code[10];
        PositionGroupCodeL: Code[10];
    begin
        YearL := TWSalesRawDataBufferP.Year;
        MonthL := TWSalesRawDataBufferP.Month;
        ServCenterCodeL := TWSalesRawDataBufferP."Service Center";

        InsertBuffer(YearL, MonthL, ServCenterCodeL, FieldNoP, FieldValueP);
    end;

    local procedure InsertBuffer(YearP: Integer; MonthP: Integer; ServCenterCodeP: Code[10]; FieldNoP: Integer; FieldValueP: Variant)
    var
        BufferL: Record "TW Sales Data Header Buffer";
        RecordRefL: RecordRef;
        FieldRefL: FieldRef;
        TempVarL: Variant;
        TempDecL: Decimal;
        TempDec2L: Decimal;
        TempIntL: Integer;
        TempInt2L: Integer;
        ServiceCenterL: Record "Service Center";
        YearL: Integer;
        MonthL: Integer;
        ServCenterCodeL: Code[10];
        ManufacturerCodeL: Code[10];
        MainGroupCodeL: Code[10];
        PositionGroupCodeL: Code[10];
        ItemL: Record Item;
        ResourceL: Record Resource;
        SalesInvoiceLineL: Record "Sales Invoice Line Buffer";
        SalesCrMemoLineL: Record "Sales Cr.Memo Line Buffer";
    begin
        IF BufferL.GET(YearP, MonthP, ServCenterCodeP) THEN BEGIN
            CLEAR(RecordRefL);
            CLEAR(FieldRefL);
            RecordRefL.GETTABLE(BufferL);
            FieldRefL := RecordRefL.FIELD(FieldNoP);
            TempVarL := FieldRefL.VALUE;
            IF TempVarL.ISDECIMAL AND FieldValueP.ISDECIMAL THEN BEGIN
                TempDecL := TempVarL;
                TempDec2L := FieldValueP;
                TempDecL := TempDec2L + TempDecL;
                TempVarL := TempDecL;
                FieldRefL.VALUE(TempVarL);
            END;
            IF TempVarL.ISINTEGER AND FieldValueP.ISINTEGER THEN BEGIN
                TempIntL := TempVarL;
                TempInt2L := FieldValueP;
                TempIntL := TempInt2L + TempIntL;
                TempVarL := TempIntL;
                FieldRefL.VALUE(TempVarL);
            END;
            RecordRefL.SETTABLE(BufferL);
            BufferL.MODIFY;
        END ELSE BEGIN
            BufferL.INIT;
            BufferL.Year := YearP;
            BufferL.Month := MonthP;
            // Start 119130
            BufferL.Date := DMY2DATE(1, MonthP, YearP);
            // Stop  119130
            BufferL."Service Center" := ServCenterCodeP;
            BufferL.INSERT;
            CLEAR(RecordRefL);
            CLEAR(FieldRefL);
            RecordRefL.GETTABLE(BufferL);
            FieldRefL := RecordRefL.FIELD(FieldNoP);
            TempVarL := FieldRefL.VALUE;
            IF TempVarL.ISDECIMAL AND FieldValueP.ISDECIMAL THEN
                FieldRefL.VALUE(FieldValueP);
            IF TempVarL.ISINTEGER AND FieldValueP.ISINTEGER THEN
                FieldRefL.VALUE(FieldValueP);
            RecordRefL.SETTABLE(BufferL);
            BufferL.MODIFY;
        END;
    end;

    local procedure IsTyre(NoP: Code[20]): Boolean
    var
        ReportSetupL: Record "Fastfit Setup - Reporting";
        ItemL: Record Item;
    begin
        ItemL.RESET;
        ItemL.SETRANGE("No.", NoP);
        ItemL.SETFILTER("Main Group Code", 'A1');
        EXIT(NOT ItemL.ISEMPTY);
    end;

    local procedure IsNonTyre(NoP: Code[20]): Boolean
    var
        ReportSetupL: Record "Fastfit Setup - Reporting";
        ItemL: Record Item;
        ResourceL: Record Resource;
        IsItemL: Boolean;
    begin
        // Start 120529
        ItemL.RESET;
        ItemL.SETRANGE("No.", NoP);
        //++TWN1.00.122187.QX
        // Field 'Product Group Code' is removed. Reason: Product Groups became first level children of Item Categories.
        // ItemL.SETFILTER("Product Group Code", '<>%1', '900-TIRE');
        // ItemL.SETFILTER("Item Category Code", '<>%1', '10-TIRES');
        ItemL.SETFILTER("Item Category Code", '<>%1&<>%2', '10-TIRES', '900-TIRE');
        //--TWN1.00.122187.QX
        IF (NOT ItemL.ISEMPTY) THEN
            EXIT(TRUE);
        ResourceL.RESET;
        ResourceL.SETRANGE("No.", NoP);
        //++TWN1.00.122187.QX
        // Field 'Product Group Code' is removed. Reason: Product Groups became first level children of Item Categories.
        // ResourceL.SETFILTER("Product Group Code", '<>%1', '900-TIRE');
        // ResourceL.SETFILTER("Item Category Code", '<>%1', '10-TIRES');
        ResourceL.SETFILTER("Item Category Code", '<>%1&<>%2', '10-TIRES', '900-TIRE');
        //--TWN1.00.122187.QX        
        IF (NOT ResourceL.ISEMPTY) THEN
            EXIT(TRUE);

        EXIT(FALSE);
        ItemL.RESET;
        ItemL.SETRANGE("No.", NoP);

        //++TWN1.00.122187.QX
        // Field 'Product Group Code' is removed. Reason: Product Groups became first level children of Item Categories.
        // ItemL.SETFILTER("Product Group Code", '<>%1', '900-TIRE');
        ItemL.SETFILTER("Item Category Code", '<>%1', '900-TIRE');
        //--TWN1.00.122187.QX
        IF (NOT ItemL.ISEMPTY) THEN
            EXIT(TRUE);

        //++TWN1.00.122187.QX
        // Field 'Product Group Code' is removed. Reason: Product Groups became first level children of Item Categories.
        // ItemL.SETRANGE("Product Group Code");
        ItemL.SETRANGE("Item Category Code");
        //--TWN1.00.122187.QX
        ItemL.SETFILTER("Item Category Code", '<>%1', '10-TIRES');
        IF (NOT ItemL.ISEMPTY) THEN
            EXIT(TRUE);
        ResourceL.RESET;
        ResourceL.SETRANGE("No.", NoP);
        //++TWN1.00.122187.QX
        // Field 'Product Group Code' is removed. Reason: Product Groups became first level children of Item Categories.
        // ResourceL.SETFILTER("Product Group Code", '<>%1', '900-TIRE');
        ResourceL.SETFILTER("Item Category Code", '<>%1', '900-TIRE');
        //--TWN1.00.122187.QX
        IF (NOT ResourceL.ISEMPTY) THEN
            EXIT(TRUE);
        //++TWN1.00.122187.QX
        // Field 'Product Group Code' is removed. Reason: Product Groups became first level children of Item Categories.
        // ResourceL.SETRANGE("Product Group Code");
        ResourceL.SETRANGE("Item Category Code");
        //--TWN1.00.122187.QX
        ResourceL.SETFILTER("Item Category Code", '<>%1', '10-TIRES');
        IF (NOT ResourceL.ISEMPTY) THEN
            EXIT(TRUE);

        EXIT(FALSE);
        // Stop 120529
        //Old Logic is unable again
        ItemL.RESET;
        ItemL.SETRANGE("No.", NoP);
        ItemL.SETFILTER("Position Group Code", 'B10001..B17001');
        IsItemL := NOT ItemL.ISEMPTY;
        // Start 119130
        IF NOT IsItemL THEN BEGIN
            ItemL.SETRANGE("Position Group Code");
            ItemL.SETFILTER("Main Group Code", 'A2..A9');
            IsItemL := NOT ItemL.ISEMPTY;
        END;
        // Stop  119130

        IF IsItemL THEN
            EXIT(IsItemL);
        ResourceL.RESET;
        ResourceL.SETRANGE("No.", NoP);
        ResourceL.SETFILTER("Position Group Code", 'B10001..B17001');
        EXIT(NOT ResourceL.ISEMPTY);
    end;

    local procedure IsMI(NoP: Code[20]): Boolean
    var
        ItemL: Record Item;
        ResourceL: Record Resource;
    begin
        // Start 120529
        ItemL.RESET;
        ItemL.SETRANGE("No.", NoP);
        ItemL.SETFILTER("Main Group Code", 'A1');
        ItemL.SETRANGE("Manufacturer Code", 'MI');
        IF (NOT ItemL.ISEMPTY) THEN
            EXIT(TRUE);

        ResourceL.RESET;
        ResourceL.SETRANGE("No.", NoP);
        ResourceL.SETFILTER("Main Group Code", 'A1');
        ResourceL.SETRANGE("Manufacturer Code", 'MI');
        IF (NOT ResourceL.ISEMPTY) THEN
            EXIT(TRUE);

        EXIT(FALSE);
        // Stop 120529
    end;

    local procedure IsService(NoP: Code[20]): Boolean
    var
        ResourceL: Record Resource;
    begin
        ResourceL.RESET;
        ResourceL.SETRANGE("No.", NoP);
        ResourceL.SETFILTER("Position Group Code", 'B21001..B21017');
        EXIT(NOT ResourceL.ISEMPTY);
    end;

    local procedure IsSOBTyre(NoP: Code[20]): Boolean
    var
        ReportSetupL: Record "Fastfit Setup - Reporting";
        ItemL: Record Item;
        ResourceL: Record Resource;
        IsItemL: Boolean;
    begin
        ItemL.RESET;
        ItemL.SETRANGE("No.", NoP);
        ItemL.SETFILTER("Position Group Code", 'B21003..B21007|B21011..B21016');
        IsItemL := NOT ItemL.ISEMPTY;
        IF IsItemL THEN
            EXIT(IsItemL);
        ResourceL.RESET;
        ResourceL.SETRANGE("No.", NoP);
        ResourceL.SETFILTER("Position Group Code", 'B21003..B21007|B21011..B21016');
        EXIT(NOT ResourceL.ISEMPTY);
    end;

    local procedure IsSOBNTP(NoP: Code[20]): Boolean
    var
        ReportSetupL: Record "Fastfit Setup - Reporting";
        ItemL: Record Item;
        ResourceL: Record Resource;
        IsItemL: Boolean;
    begin
        ItemL.RESET;
        ItemL.SETRANGE("No.", NoP);
        ItemL.SETFILTER("Position Group Code", 'B21001..B21002|B21009..B21010');
        IsItemL := NOT ItemL.ISEMPTY;
        IF IsItemL THEN
            EXIT(IsItemL);
        ResourceL.RESET;
        ResourceL.SETRANGE("No.", NoP);
        ResourceL.SETFILTER("Position Group Code", 'B21001..B21002|B21009..B21010');
        EXIT(NOT ResourceL.ISEMPTY);
    end;

    local procedure IsTyreMIFBG(NoP: Code[20]): Boolean
    var
        ReportSetupL: Record "Fastfit Setup - Reporting";
        ItemL: Record Item;
    begin
        ItemL.RESET;
        ItemL.SETRANGE("No.", NoP);
        ItemL.SETFILTER("Main Group Code", 'A1');
        ItemL.SETFILTER("Manufacturer Code", '%1|%2', 'MI', 'BFG');
        IF (NOT ItemL.ISEMPTY) THEN
            EXIT(TRUE);

        EXIT(FALSE);
    end;

    local procedure InsertOrUpdateTWSalesDataLineInvoiceBuffer(SalesInvoiceLineP: Record "Sales Invoice Line Buffer")
    var
        YearL: Integer;
        MonthL: Integer;
        ServCenterCodeL: Code[10];
        ManufacturerCodeL: Code[10];
        MainGroupCodeL: Code[10];
        PositionGroupCodeL: Code[10];
        SalesInvoiceLineL: Record "Sales Invoice Line Buffer";
        ItemL: Record Item;
        ResourceL: Record Resource;
        ServiceCenterL: Record "Service Center";
        ZoneCodeL: Code[20];
        PostCodeL: Code[20];
        ShopNameL: Text;
    begin
        YearL := DATE2DMY(SalesInvoiceLineP."Posting Date", 3);
        MonthL := DATE2DMY(SalesInvoiceLineP."Posting Date", 2);
        ServCenterCodeL := SalesInvoiceLineP."Service Center";
        IF ServiceCenterL.GET(ServCenterCodeL) THEN BEGIN
            ZoneCodeL := ServiceCenterL."Global Dimension 1 Code";
            PostCodeL := ServiceCenterL."Post Code";
            ShopNameL := ServiceCenterL.Name;
        END;
        IF SalesInvoiceLineP.Type = SalesInvoiceLineP.Type::Item THEN BEGIN
            IF ItemL.GET(SalesInvoiceLineP."No.") THEN BEGIN
                ManufacturerCodeL := ItemL."Manufacturer Code";
                MainGroupCodeL := ItemL."Main Group Code";
                PositionGroupCodeL := ItemL."Position Group Code";
            END;
        END;
        IF SalesInvoiceLineP.Type = SalesInvoiceLineP.Type::Resource THEN BEGIN
            IF ResourceL.GET(SalesInvoiceLineP."No.") THEN BEGIN
                ManufacturerCodeL := ResourceL."Manufacturer Code";
                MainGroupCodeL := ResourceL."Main Group Code";
                PositionGroupCodeL := ResourceL."Position Group Code";
            END;
        END;

        IF NOT TWSalesDataLineBufferG.GET(YearL, MonthL, ServCenterCodeL, ManufacturerCodeL, MainGroupCodeL, PositionGroupCodeL, SalesInvoiceLineP."Document No.") THEN BEGIN
            TWSalesDataLineBufferG.INIT;
            TWSalesDataLineBufferG.Year := YearL;
            TWSalesDataLineBufferG.Month := MonthL;
            // Start 119130
            TWSalesDataLineBufferG.Date := DMY2DATE(1, MonthL, YearL);
            // Stop  119130
            TWSalesDataLineBufferG."Service Center" := ServCenterCodeL;
            TWSalesDataLineBufferG."Manufacturer Code" := ManufacturerCodeL;
            TWSalesDataLineBufferG."Main Group Code" := MainGroupCodeL;
            TWSalesDataLineBufferG."Position Group Code" := PositionGroupCodeL;
            TWSalesDataLineBufferG."Zone Code" := ZoneCodeL;
            TWSalesDataLineBufferG."Post Code" := PostCodeL;
            TWSalesDataLineBufferG."Shop Name" := ShopNameL;
            TWSalesDataLineBufferG."Sales Invoiced Qty" := SalesInvoiceLineP."Quantity (Base)";
            TWSalesDataLineBufferG."Sales Amount" := SalesInvoiceLineP."Amount Including VAT";
            TWSalesDataLineBufferG."Posted Invoice No." := SalesInvoiceLineP."Document No.";
            TWSalesDataLineBufferG."Add. Sales Line Clicked" := SalesInvoiceLineP."Additional Sale";
            TWSalesDataLineBufferG.INSERT;
        END ELSE BEGIN
            TWSalesDataLineBufferG."Zone Code" := ZoneCodeL;
            TWSalesDataLineBufferG."Post Code" := PostCodeL;
            TWSalesDataLineBufferG."Shop Name" := ShopNameL;
            TWSalesDataLineBufferG."Sales Invoiced Qty" += SalesInvoiceLineP."Quantity (Base)";
            TWSalesDataLineBufferG."Sales Amount" += SalesInvoiceLineP."Amount Including VAT";
            TWSalesDataLineBufferG."Add. Sales Line Clicked" := SalesInvoiceLineP."Additional Sale";
            TWSalesDataLineBufferG.MODIFY;
        END;
    end;

    local procedure InsertOrUpdateTWSalesDataLineCreditBuffer(SalesCrMemoLineP: Record "Sales Cr.Memo Line Buffer")
    var
        YearL: Integer;
        MonthL: Integer;
        ServCenterCodeL: Code[10];
        ManufacturerCodeL: Code[10];
        MainGroupCodeL: Code[10];
        PositionGroupCodeL: Code[10];
        SalesInvoiceLineL: Record "Sales Invoice Line Buffer";
        ItemL: Record Item;
        ResourceL: Record Resource;
        ServiceCenterL: Record "Service Center";
        ZoneCodeL: Code[20];
        PostCodeL: Code[20];
        ShopNameL: Text;
    begin
        YearL := DATE2DMY(SalesCrMemoLineP."Posting Date", 3);
        MonthL := DATE2DMY(SalesCrMemoLineP."Posting Date", 2);
        ServCenterCodeL := SalesCrMemoLineP."Service Center";
        IF ServiceCenterL.GET(ServCenterCodeL) THEN BEGIN
            ZoneCodeL := ServiceCenterL."Global Dimension 1 Code";
            PostCodeL := ServiceCenterL."Post Code";
            ShopNameL := ServiceCenterL.Name;
        END;
        IF SalesCrMemoLineP.Type = SalesCrMemoLineP.Type::Item THEN BEGIN
            IF ItemL.GET(SalesCrMemoLineP."No.") THEN BEGIN
                ManufacturerCodeL := ItemL."Manufacturer Code";
                MainGroupCodeL := ItemL."Main Group Code";
                PositionGroupCodeL := ItemL."Position Group Code";
            END;
        END;
        IF SalesCrMemoLineP.Type = SalesCrMemoLineP.Type::Resource THEN BEGIN
            IF ResourceL.GET(SalesCrMemoLineP."No.") THEN BEGIN
                ManufacturerCodeL := ResourceL."Manufacturer Code";
                MainGroupCodeL := ResourceL."Main Group Code";
                PositionGroupCodeL := ResourceL."Position Group Code";
            END;
        END;

        IF NOT TWSalesDataLineBufferG.GET(YearL, MonthL, ServCenterCodeL, ManufacturerCodeL, MainGroupCodeL, PositionGroupCodeL, SalesCrMemoLineP."Document No.") THEN BEGIN
            TWSalesDataLineBufferG.INIT;
            TWSalesDataLineBufferG.Year := YearL;
            TWSalesDataLineBufferG.Month := MonthL;
            // Start 119130
            TWSalesDataLineBufferG.Date := DMY2DATE(1, MonthL, YearL);
            // Stop  119130
            TWSalesDataLineBufferG."Service Center" := ServCenterCodeL;
            TWSalesDataLineBufferG."Manufacturer Code" := ManufacturerCodeL;
            TWSalesDataLineBufferG."Main Group Code" := MainGroupCodeL;
            TWSalesDataLineBufferG."Position Group Code" := PositionGroupCodeL;
            TWSalesDataLineBufferG."Zone Code" := ZoneCodeL;
            TWSalesDataLineBufferG."Post Code" := PostCodeL;
            TWSalesDataLineBufferG."Shop Name" := ShopNameL;
            TWSalesDataLineBufferG."Sales Invoiced Qty" := SalesCrMemoLineP."Quantity (Base)";
            TWSalesDataLineBufferG."Sales Amount" := SalesCrMemoLineP."Amount Including VAT";
            TWSalesDataLineBufferG."Posted Invoice No." := SalesCrMemoLineP."Document No.";
            TWSalesDataLineBufferG."Add. Sales Line Clicked" := FALSE;
            TWSalesDataLineBufferG.INSERT;
        END ELSE BEGIN
            TWSalesDataLineBufferG."Zone Code" := ZoneCodeL;
            TWSalesDataLineBufferG."Post Code" := PostCodeL;
            TWSalesDataLineBufferG."Shop Name" := ShopNameL;
            TWSalesDataLineBufferG."Sales Invoiced Qty" += SalesCrMemoLineP."Quantity (Base)";
            TWSalesDataLineBufferG."Sales Amount" += SalesCrMemoLineP."Amount Including VAT";
            TWSalesDataLineBufferG."Add. Sales Line Clicked" := FALSE;
            TWSalesDataLineBufferG.MODIFY;
        END;
    end;

    [Scope('OnPrem')]
    procedure SetDateRange(_StartDateG: Date; _EndDateG: Date)
    begin
        StartDateG := _StartDateG;
        EndDateG := _EndDateG;
    end;

    local procedure IsSaleInvoiceDeleted(var SalesInvoiceHeaderP: Record "Sales Invoice Header Buffer"): Boolean
    var
        SalesInvoiceLineL: Record "Sales Invoice Line Buffer";
    begin
        // Start 121036
        SalesInvoiceHeaderP.CALCFIELDS("Amount Including VAT");
        IF SalesInvoiceHeaderP."Amount Including VAT" <> 0 THEN
            EXIT(FALSE);

        SalesInvoiceLineL.RESET;
        SalesInvoiceLineL.SetRange("Service Center Key", SalesInvoiceHeaderP."Service Center Key");
        SalesInvoiceLineL.SETRANGE("Document No.", SalesInvoiceHeaderP."No.");
        SalesInvoiceLineL.SETFILTER("No.", '<>%1', '');
        EXIT(SalesInvoiceLineL.ISEMPTY);
        // Stop 121036
    end;
}

