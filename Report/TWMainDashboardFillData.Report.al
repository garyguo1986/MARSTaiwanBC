report 1044875 "TW Main Dashboard Fill Data"
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
    // MARS_TWN-7689 121036      GG     2019-11-28  Remove "Amount Incl. VAT" filter
    // RGS_TWN-8365  122779        GG     2021-06-01  Use buffer table instand orignal table

    Caption = 'TW Main Dashboard Fill Data';
    UsageCategory = ReportsAndAnalysis;
    ProcessingOnly = true;
    Permissions = tabledata "Sales Invoice Header Buffer" = rmid,
        tabledata "Sales Invoice Line Buffer" = rmid,
        tabledata "Sales Cr.Memo Header Buffer" = rmid,
        tabledata "Sales Cr.Memo Line Buffer" = rmid;
    dataset
    {
        dataitem(SalesInvoiceHeader; "Sales Invoice Header Buffer")
        {
            DataItemTableView = sorting("Service Center Key", "No.") order(ascending) where("Buffer Flag" = filter(false));
            trigger OnAfterGetRecord()
            begin
                // IF TableKeyInfoG.IsSalesInvoiceExist(SalesInvoiceHeader) THEN
                //     CurrReport.SKIP;
                // Start 121036
                //SalesInvoiceHeader.CALCFIELDS("Amount Including VAT");
                //IF SalesInvoiceHeader."Amount Including VAT" = 0 THEN
                //  CurrReport.SKIP;
                IF IsSaleInvoiceDeleted(SalesInvoiceHeader) THEN
                    CurrReport.SKIP;
                // Stop 121036
                TyreOverall(SalesInvoiceHeader, FALSE);
                NonTyreOverall(SalesInvoiceHeader, FALSE);
                OverallCount(SalesInvoiceHeader, FALSE);
                SalesInvoiceQuantity(SalesInvoiceHeader, FALSE);

                //TableKeyInfoG.RecordSalesInvoice(SalesInvoiceHeader);
                SalesInvoiceHeader."Buffer Flag" := true;
                SalesInvoiceHeader.Modify();
            end;
        }
        dataitem(SalesInvoiceHeaderCancelled; "Sales Invoice Header Buffer")
        {
            //DataItemTableView = WHERE("Canceled By" = FILTER(<> ''));
            DataItemTableView = where("Cancelled" = filter(true));
            trigger OnAfterGetRecord()
            var
                CancelldedDocL: Record "Cancelled Document Buffer";
            begin
                if not CancelldedDocL.Get(SalesInvoiceHeaderCancelled."Service Center Key", 112, SalesInvoiceHeaderCancelled."No.") then
                    CurrReport.Skip();
                // IF NOT SalesCrMemoHeaderG.GET(SalesInvoiceHeaderCancelled."Canceled By") THEN
                //     CurrReport.SKIP;
                IF NOT SalesCrMemoHeaderG.GET(CancelldedDocL."Service Center Key", CancelldedDocL."Cancelled By Doc. No.") THEN
                    CurrReport.SKIP;
                // IF TableKeyInfoG.IsSalesCreditMemoExist(SalesCrMemoHeaderG) THEN
                //     CurrReport.SKIP;
                if SalesCrMemoHeaderG."Buffer Flag" then
                    CurrReport.Skip();
                // Start 121036
                //SalesInvoiceHeaderCancelled.CALCFIELDS("Amount Including VAT");
                //IF SalesInvoiceHeaderCancelled."Amount Including VAT" = 0 THEN
                //  CurrReport.SKIP;
                IF IsSaleInvoiceDeleted(SalesInvoiceHeaderCancelled) THEN
                    CurrReport.SKIP;
                // Stop 121036
                TyreOverall(SalesInvoiceHeaderCancelled, TRUE);
                NonTyreOverall(SalesInvoiceHeaderCancelled, TRUE);
                IF CheckCancelledInvoice(SalesInvoiceHeaderCancelled) THEN
                    OverallCount(SalesInvoiceHeaderCancelled, TRUE);
                SalesInvoiceQuantity(SalesInvoiceHeaderCancelled, TRUE);
                //TableKeyInfoG.RecordSalesCreditMemo(SalesCrMemoHeaderG);
                SalesCrMemoHeaderG."Buffer Flag" := true;
                SalesCrMemoHeaderG.Modify();
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

    var
        TWMainDashboardBufferG: Record "TW Main Dashboard Buffer";
        // SalesInvoiceHeaderG: Record "Sales Invoice Header";
        // SalesInvoiceLineG: Record "Sales Invoice Line";
        SalesCrMemoHeaderG: Record "Sales Cr.Memo Header Buffer";
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

    local procedure TyreOverall(var SalesInvoiceHeaderP: Record "Sales Invoice Header Buffer"; CancelP: Boolean)
    var
        SalesInvoiceLineL: Record "Sales Invoice Line Buffer";
    begin
        SalesInvoiceLineL.RESET;
        SalesInvoiceLineL.SetRange("Service Center Key", SalesInvoiceHeaderP."Service Center Key");
        SalesInvoiceLineL.SETRANGE("Document No.", SalesInvoiceHeaderP."No.");
        SalesInvoiceLineL.SETFILTER("No.", '<>%1', '');
        IF SalesInvoiceLineL.FINDFIRST THEN
            REPEAT
                IF IsTyre(SalesInvoiceLineL."No.") THEN BEGIN
                    IF CancelP THEN BEGIN
                        InsertSalesInvoiceHeaderBuffer(SalesInvoiceHeaderP, TWMainDashboardBufferG.FIELDNO("Tyre Amount"), -SalesInvoiceLineL."Amount Including VAT");
                    END ELSE
                        InsertSalesInvoiceHeaderBuffer(SalesInvoiceHeaderP, TWMainDashboardBufferG.FIELDNO("Tyre Amount"), SalesInvoiceLineL."Amount Including VAT");
                END;
            UNTIL SalesInvoiceLineL.NEXT = 0;
    end;

    local procedure NonTyreOverall(var SalesInvoiceHeaderP: Record "Sales Invoice Header Buffer"; CancelP: Boolean)
    var
        SalesInvoiceLineL: Record "Sales Invoice Line Buffer";
        CancelRateL: Integer;
    begin
        SalesInvoiceLineL.RESET;
        SalesInvoiceLineL.SetRange("Service Center Key", SalesInvoiceHeaderP."Service Center Key");
        SalesInvoiceLineL.SETRANGE("Document No.", SalesInvoiceHeaderP."No.");
        SalesInvoiceLineL.SETFILTER("No.", '<>%1', '');
        IF SalesInvoiceLineL.FINDFIRST THEN
            REPEAT
                IF IsNonTyre(SalesInvoiceLineL."No.") THEN BEGIN
                    IF CancelP THEN BEGIN
                        InsertSalesInvoiceHeaderBuffer(SalesInvoiceHeaderP, TWMainDashboardBufferG.FIELDNO("NTP Amount"), -SalesInvoiceLineL."Amount Including VAT");
                    END ELSE
                        InsertSalesInvoiceHeaderBuffer(SalesInvoiceHeaderP, TWMainDashboardBufferG.FIELDNO("NTP Amount"), SalesInvoiceLineL."Amount Including VAT");
                END;
            UNTIL SalesInvoiceLineL.NEXT = 0;
    end;

    local procedure OverallCount(var SalesInvoiceHeaderP: Record "Sales Invoice Header Buffer"; CancelP: Boolean)
    var
        SalesInvoiceLineL: Record "Sales Invoice Line Buffer";
        SalesCrMemoHdrL: Record "Sales Cr.Memo Header Buffer";
        IsTyreL: Boolean;
        IsOilL: Boolean;
        IsOilFilterL: Boolean;
        IsAddSalesL: Boolean;
        IsNotAddSalesL: Boolean;
        InvoiceTypeL: Integer;
        CancelRateL: Integer;
    begin
        IF CancelP THEN
            CancelRateL := -1
        ELSE
            CancelRateL := 1;

        IF CancelP THEN BEGIN
            InsertSalesInvoiceHeaderBuffer(SalesInvoiceHeaderP, TWMainDashboardBufferG.FIELDNO("Overall Count"), 1.0 * CancelRateL);
        END ELSE
            InsertSalesInvoiceHeaderBuffer(SalesInvoiceHeaderP, TWMainDashboardBufferG.FIELDNO("Overall Count"), 1.0 * CancelRateL);
    end;

    local procedure SalesInvoiceQuantity(var SalesInvoiceHeaderP: Record "Sales Invoice Header Buffer"; CancelP: Boolean)
    var
        SalesInvoiceLineL: Record "Sales Invoice Line Buffer";
        CancelRateL: Integer;
    begin
        IF CancelP AND CheckCancelledInvoice(SalesInvoiceHeaderP) THEN
            CancelRateL := -1
        ELSE
            CancelRateL := 1;

        SalesInvoiceLineL.RESET;
        SalesInvoiceLineL.SetRange("Service Center Key", SalesInvoiceHeaderP."Service Center Key");
        SalesInvoiceLineL.SETRANGE("Document No.", SalesInvoiceHeaderP."No.");
        SalesInvoiceLineL.SETFILTER("No.", '<>%1', '');
        IF SalesInvoiceLineL.FINDFIRST THEN
            REPEAT
                IF IsTyre(SalesInvoiceLineL."No.") THEN
                    InsertSalesInvoiceHeaderBuffer(SalesInvoiceHeaderP, TWMainDashboardBufferG.FIELDNO("Tyre Total Quantity"), SalesInvoiceLineL."Quantity (Base)" * CancelRateL);
                IF IsMIorBFG(SalesInvoiceLineL."No.") THEN
                    InsertSalesInvoiceHeaderBuffer(SalesInvoiceHeaderP, TWMainDashboardBufferG.FIELDNO("MI or BFG Total Quantity"), SalesInvoiceLineL."Quantity (Base)" * CancelRateL);
                IF IsLub(SalesInvoiceLineL."No.") THEN
                    InsertSalesInvoiceHeaderBuffer(SalesInvoiceHeaderP, TWMainDashboardBufferG.FIELDNO("Lub Total Quantity"), SalesInvoiceLineL."Quantity (Base)" * CancelRateL);
                IF IsLubDeno(SalesInvoiceLineL."No.") THEN
                    InsertSalesInvoiceHeaderBuffer(SalesInvoiceHeaderP, TWMainDashboardBufferG.FIELDNO("Lub Deno Total Quantity"), SalesInvoiceLineL."Quantity (Base)" * CancelRateL);
            UNTIL SalesInvoiceLineL.NEXT = 0;
    end;

    local procedure InsertSalesInvoiceHeaderBuffer(var SalesInvoiceHeaderP: Record "Sales Invoice Header Buffer"; FieldNoP: Integer; FieldValueP: Variant)
    begin
        InsertBuffer(SalesInvoiceHeaderP."Service Center",
        SalesInvoiceHeaderP."Posting Date",
        FieldNoP,
        FieldValueP);
    end;

    local procedure InsertBuffer(ServiceCenterCodeP: Code[10]; PostingDateP: Date; FieldNoP: Integer; FieldValueP: Variant)
    var
        BufferL: Record "TW Main Dashboard Buffer";
        RecordRefL: RecordRef;
        FieldRefL: FieldRef;
        TempVarL: Variant;
        TempDecL: Decimal;
        TempDec2L: Decimal;
        TempIntL: Integer;
        TempInt2L: Integer;
        ServiceCenterL: Record "Service Center";
    begin
        IF BufferL.GET(ServiceCenterCodeP, PostingDateP) THEN BEGIN
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
            BufferL."Service Center" := ServiceCenterCodeP;
            BufferL."Posting Date" := PostingDateP;
            IF ServiceCenterL.GET(ServiceCenterCodeP) THEN
                BufferL."Post Code" := ServiceCenterL."Post Code";
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

    local procedure IsLub(ItemNoP: Code[20]): Boolean
    var
        ReportSetupL: Record "Fastfit Setup - Reporting";
        ItemL: Record Item;
    begin
        ItemL.RESET;
        ItemL.SETRANGE("No.", ItemNoP);
        ItemL.SETFILTER("Position Group Code", 'A60001..A60009');
        ItemL.SETFILTER("Manufacturer Code", 'TO|TP');
        EXIT(NOT ItemL.ISEMPTY);
    end;

    local procedure IsLubDeno(ItemNoP: Code[20]): Boolean
    var
        ReportSetupL: Record "Fastfit Setup - Reporting";
        ItemL: Record Item;
    begin
        ItemL.RESET;
        ItemL.SETRANGE("No.", ItemNoP);
        ItemL.SETFILTER("Position Group Code", 'A60001..A60009');
        EXIT(NOT ItemL.ISEMPTY);
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
    begin
        ItemL.RESET;
        ItemL.SETRANGE("No.", NoP);
        ItemL.SETFILTER("Position Group Code", 'A92002|A60001..A65001|A70001..A70002', 'A70005|90001..A90003|A42001..A42004');
        EXIT(NOT ItemL.ISEMPTY);
    end;

    local procedure IsMIorBFG(NoP: Code[20]): Boolean
    var
        ReportSetupL: Record "Fastfit Setup - Reporting";
        ItemL: Record Item;
        ResourceL: Record Resource;
    begin
        ItemL.RESET;
        ItemL.SETRANGE("No.", NoP);
        ItemL.SETFILTER("Main Group Code", 'A1');
        ItemL.SETFILTER("Manufacturer Code", '%1|%2', 'MI', 'BFG');
        IF (NOT ItemL.ISEMPTY) THEN
            EXIT(TRUE);

        EXIT(FALSE);
    end;

    local procedure CheckCancelledInvoice(SalesInvoiceHdrP: Record "Sales Invoice Header Buffer"): Boolean
    var
        SalesCrMemoHdrL: Record "Sales Cr.Memo Header Buffer";
        CancelledDocL: Record "Cancelled Document Buffer";
    begin
        if CancelledDocL.Get(SalesInvoiceHdrP."Service Center Key", 112, SalesInvoiceHdrP."No.") then begin
            if SalesCrMemoHdrL.Get(CancelledDocL."Service Center Key", CancelledDocL."Cancelled By Doc. No.") then begin
                SalesCrMemoHdrL.CALCFIELDS("Amount Including VAT");
                SalesInvoiceHdrP.CALCFIELDS("Amount Including VAT");
                IF SalesCrMemoHdrL."Amount Including VAT" = SalesInvoiceHdrP."Amount Including VAT" THEN
                    EXIT(TRUE);
            end;
        end;

        EXIT(FALSE);
    end;

    local procedure CheckCancelledInvoiceIgnoreAmount(SalesInvoiceHdrP: Record "Sales Invoice Header Buffer"): Boolean
    var
        SalesCrMemoHdrL: Record "Sales Cr.Memo Header Buffer";
        CancelledDocL: Record "Cancelled Document Buffer";
    begin
        if CancelledDocL.Get(SalesInvoiceHdrP."Service Center Key", 112, SalesInvoiceHdrP."No.") then begin
            if SalesCrMemoHdrL.Get(CancelledDocL."Service Center Key", CancelledDocL."Cancelled By Doc. No.") then begin
                SalesCrMemoHdrL.CALCFIELDS("Amount Including VAT");
                IF SalesCrMemoHdrL."Amount Including VAT" <> 0 THEN
                    EXIT(TRUE);
            end;
        end;
        // IF SalesCrMemoHdrL.GET(SalesInvoiceHdrP."Canceled By") THEN BEGIN
        //     SalesCrMemoHdrL.CALCFIELDS("Amount Including VAT");
        //     IF SalesCrMemoHdrL."Amount Including VAT" <> 0 THEN
        //         EXIT(TRUE);
        // END;

        EXIT(FALSE);
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

