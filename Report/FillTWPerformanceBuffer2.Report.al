report 1044873 "Fill TW Performance Buffer2"
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
    // RGS_TWN-839   119384        WP     2019-05-10  Add "Gross Profit"

    Caption = 'Fill TW Performance Buffer2';
    UsageCategory = Tasks;
    ApplicationArea = All;
    ProcessingOnly = true;

    dataset
    {
        dataitem(ServiceCenter; "Service Center")
        {
            dataitem(SalesInvoiceHeader; "Sales Invoice Header")
            {
                DataItemLink = "Service Center" = FIELD(Code);
                DataItemTableView = WHERE("Canceled By" = FILTER(''));
                RequestFilterFields = "Posting Date";

                trigger OnAfterGetRecord()
                begin
                    IF TableKeyInfoG.IsSalesInvoiceExist(SalesInvoiceHeader) THEN
                        CurrReport.SKIP;

                    IF IsSalesInvoiceDeleted(SalesInvoiceHeader) THEN
                        CurrReport.SKIP;

                    Turnover(SalesInvoiceHeader, FALSE);
                    TurnoverTyre(SalesInvoiceHeader, FALSE);
                    TurnoverNonTyre(SalesInvoiceHeader, FALSE);
                    TurnoverResource(SalesInvoiceHeader, FALSE);
                    SalesInvoiceVehicleCheckQuantity(SalesInvoiceHeader, FALSE);
                    SalesInvoiceCount(SalesInvoiceHeader, FALSE);
                    SalesInvoiceQuantity(SalesInvoiceHeader, FALSE);
                    // Start 119384
                    SalesInvoiceProfit(SalesInvoiceHeader, FALSE);
                    // Stop  119384
                    TableKeyInfoG.RecordSalesInvoice(SalesInvoiceHeader);
                end;
            }
            dataitem(SalesInvoiceHeaderCancelled; "Sales Invoice Header")
            {
                DataItemLink = "Service Center" = FIELD(Code);
                DataItemTableView = WHERE("Canceled By" = FILTER(<> ''));
                RequestFilterFields = "Posting Date";

                trigger OnAfterGetRecord()
                begin
                    CurrReport.SKIP;
                    IF NOT SalesCrMemoHeaderG.GET(SalesInvoiceHeaderCancelled."Canceled By") THEN
                        CurrReport.SKIP;
                    IF TableKeyInfoG.IsSalesCreditMemoExist(SalesCrMemoHeaderG) THEN
                        CurrReport.SKIP;
                    IF IsSalesInvoiceDeleted(SalesInvoiceHeaderCancelled) THEN
                        CurrReport.SKIP;

                    Turnover(SalesInvoiceHeaderCancelled, TRUE);
                    TurnoverTyre(SalesInvoiceHeaderCancelled, TRUE);
                    TurnoverNonTyre(SalesInvoiceHeaderCancelled, TRUE);
                    TurnoverResource(SalesInvoiceHeaderCancelled, TRUE);
                    SalesInvoiceVehicleCheckQuantity(SalesInvoiceHeaderCancelled, TRUE);
                    SalesInvoiceCount(SalesInvoiceHeaderCancelled, TRUE);
                    SalesInvoiceQuantity(SalesInvoiceHeaderCancelled, TRUE);
                    // Start 119384
                    SalesInvoiceProfit(SalesInvoiceHeader, TRUE);
                    // Stop  119384
                    TableKeyInfoG.RecordSalesCreditMemo(SalesCrMemoHeaderG);
                end;
            }
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(General)
                {
                    field(IsDeleteBufferG; IsDeleteBufferG)
                    {
                        Caption = 'Delete Buffer';
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPostReport()
    begin
        IF GUIALLOWED THEN
            MESSAGE(C_INC_001);
    end;

    trigger OnPreReport()
    begin
        IF IsDeleteBufferG THEN BEGIN
            BufferG.RESET;
            BufferG.DELETEALL;
            TableKeyInfoG.RESET;
            TableKeyInfoG.SETFILTER("Table ID", '112|114');
            TableKeyInfoG.DELETEALL;
        END;
        //++TWN1.00.122187.GG
        MARSTWNTempFlagMgtG.FixVehicleCheckStatusForPerformaceReport();
        //--TWN1.00.122187.GG
    end;

    var
        BufferG: Record 1044867;
        MARSTWNTempFlagMgtG: Codeunit "MARS TWN Temp Flag Mgt";
        C_INC_001: Label 'The buffer is filled success.';
        TableKeyInfoG: Record 1044868;
        SalesCrMemoHeaderG: Record 114;
        ItemLedEntryG: Record 32;
        IsDeleteBufferG: Boolean;
        ValueEntryG: Record 5802;
        CancelType: Option NoCancel,PartialCancel,AllCancel;

    local procedure Turnover(var SalesInvoiceHeaderP: Record "Sales Invoice Header"; CancelP: Boolean)
    begin
        SalesInvoiceHeaderP.CALCFIELDS("Amount Including VAT");
        IF CancelP THEN
            InsertSalesInvoiceHeaderBuffer(SalesInvoiceHeaderP, BufferG.FIELDNO("Turnover Total Amount"), -SalesInvoiceHeaderP."Amount Including VAT")
        ELSE
            InsertSalesInvoiceHeaderBuffer(SalesInvoiceHeaderP, BufferG.FIELDNO("Turnover Total Amount"), SalesInvoiceHeaderP."Amount Including VAT");
    end;

    local procedure TurnoverTyre(var SalesInvoiceHeaderP: Record "Sales Invoice Header"; CancelP: Boolean)
    var
        SalesInvoiceLineL: Record "Sales Invoice Line";
    begin
        SalesInvoiceLineL.RESET;
        SalesInvoiceLineL.SETRANGE("Document No.", SalesInvoiceHeaderP."No.");
        SalesInvoiceLineL.SETFILTER("No.", '<>%1', '');
        IF SalesInvoiceLineL.FINDFIRST THEN
            REPEAT
                IF IsTyre(SalesInvoiceLineL."No.") THEN BEGIN
                    IF CancelP THEN
                        InsertSalesInvoiceHeaderBuffer(SalesInvoiceHeaderP, BufferG.FIELDNO("Turnover Total Tyre Amount"), -SalesInvoiceLineL."Amount Including VAT")
                    ELSE
                        InsertSalesInvoiceHeaderBuffer(SalesInvoiceHeaderP, BufferG.FIELDNO("Turnover Total Tyre Amount"), SalesInvoiceLineL."Amount Including VAT");
                END;
            UNTIL SalesInvoiceLineL.NEXT = 0;
    end;

    local procedure TurnoverNonTyre(var SalesInvoiceHeaderP: Record "Sales Invoice Header"; CancelP: Boolean)
    var
        SalesInvoiceLineL: Record "Sales Invoice Line";
    begin
        SalesInvoiceLineL.RESET;
        SalesInvoiceLineL.SETRANGE("Document No.", SalesInvoiceHeaderP."No.");
        SalesInvoiceLineL.SETFILTER("No.", '<>%1', '');
        IF SalesInvoiceLineL.FINDFIRST THEN
            REPEAT
                IF IsNonTyre(SalesInvoiceLineL."No.") THEN BEGIN
                    IF CancelP THEN
                        InsertSalesInvoiceHeaderBuffer(SalesInvoiceHeaderP, BufferG.FIELDNO("Turnover Total NonTyre Amount"), -SalesInvoiceLineL."Amount Including VAT")
                    ELSE
                        InsertSalesInvoiceHeaderBuffer(SalesInvoiceHeaderP, BufferG.FIELDNO("Turnover Total NonTyre Amount"), SalesInvoiceLineL."Amount Including VAT");
                END;
            UNTIL SalesInvoiceLineL.NEXT = 0;
    end;

    local procedure TurnoverResource(var SalesInvoiceHeaderP: Record "Sales Invoice Header"; CancelP: Boolean)
    var
        SalesInvoiceLineL: Record "Sales Invoice Line";
    begin
        SalesInvoiceLineL.RESET;
        SalesInvoiceLineL.SETRANGE("Document No.", SalesInvoiceHeaderP."No.");
        SalesInvoiceLineL.SETRANGE(Type, SalesInvoiceLineL.Type::Resource);
        SalesInvoiceLineL.SETFILTER("No.", '<>%1', '');
        IF SalesInvoiceLineL.FINDFIRST THEN
            REPEAT
                IF IsResourceTurnover(SalesInvoiceLineL."No.") THEN BEGIN
                    IF CancelP THEN
                        InsertSalesInvoiceHeaderBuffer(SalesInvoiceHeaderP, BufferG.FIELDNO("Turnover Resource Amount"), -SalesInvoiceLineL."Amount Including VAT")
                    ELSE
                        InsertSalesInvoiceHeaderBuffer(SalesInvoiceHeaderP, BufferG.FIELDNO("Turnover Resource Amount"), SalesInvoiceLineL."Amount Including VAT");
                END;
            UNTIL SalesInvoiceLineL.NEXT = 0;
    end;

    local procedure SalesInvoiceCount(var SalesInvoiceHeaderP: Record "Sales Invoice Header"; CancelP: Boolean)
    var
        SalesInvoiceLineL: Record "Sales Invoice Line";
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

        // Tyre
        IsTyreL := FALSE;
        IsOilFilterL := FALSE;
        IsOilL := FALSE;

        // Additional sales
        IsAddSalesL := FALSE;
        IsNotAddSalesL := FALSE;
        InsertSalesInvoiceHeaderBuffer(SalesInvoiceHeaderP, BufferG.FIELDNO("Sales Invoice Count"), 1.0 * CancelRateL);

        //Invoice Type Business
        SalesInvoiceLineL.RESET;
        SalesInvoiceLineL.SETRANGE("Document No.", SalesInvoiceHeaderP."No.");
        SalesInvoiceLineL.SETRANGE(Type, SalesInvoiceLineL.Type::Item);
        SalesInvoiceLineL.SETFILTER("No.", '<>%1', '');
        IF SalesInvoiceLineL.FINDFIRST THEN
            REPEAT
                IF NOT IsTyreL THEN
                    IsTyreL := IsTyre(SalesInvoiceLineL."No.");
                IF NOT IsOilL THEN
                    IsOilL := IsOil(SalesInvoiceLineL."No.");
                IF NOT IsOilFilterL THEN
                    IsOilFilterL := IsOilFilter(SalesInvoiceLineL."No.");
            UNTIL SalesInvoiceLineL.NEXT = 0;
        InvoiceTypeL := InvoiceType(IsTyreL, IsOilL, IsOilFilterL);
        CASE InvoiceTypeL OF
            0:
                InsertSalesInvoiceHeaderBuffer(SalesInvoiceHeaderP, BufferG.FIELDNO("Sales Invoice Count Others"), 1.0 * CancelRateL);
            1:
                InsertSalesInvoiceHeaderBuffer(SalesInvoiceHeaderP, BufferG.FIELDNO("Sales Invoice Count Tyre"), 1.0 * CancelRateL);
            2:
                InsertSalesInvoiceHeaderBuffer(SalesInvoiceHeaderP, BufferG.FIELDNO("Sales Invoice Count Oil Filter"), 1.0 * CancelRateL);
            3:
                InsertSalesInvoiceHeaderBuffer(SalesInvoiceHeaderP, BufferG.FIELDNO("Sales Invoice Count Oil"), 1.0 * CancelRateL);
            4:
                InsertSalesInvoiceHeaderBuffer(SalesInvoiceHeaderP, BufferG.FIELDNO("Sales Invoice Count Oil Or Fil"), 1.0 * CancelRateL);
        END;

        //Cross Sales Business
        SalesInvoiceLineL.SETRANGE(Type);
        SalesInvoiceLineL.SETRANGE("Additional Sale", FALSE);
        IsNotAddSalesL := NOT SalesInvoiceLineL.ISEMPTY;
        SalesInvoiceLineL.SETRANGE("Additional Sale", TRUE);
        IsAddSalesL := NOT SalesInvoiceLineL.ISEMPTY;
        IF IsAddSalesL AND IsNotAddSalesL THEN BEGIN
            InsertSalesInvoiceHeaderBuffer(SalesInvoiceHeaderP, BufferG.FIELDNO("Cross Sales Order Count"), 1.0 * CancelRateL);
            IF SalesInvoiceLineL.FINDFIRST THEN
                REPEAT
                    InsertSalesInvoiceHeaderBuffer(SalesInvoiceHeaderP, BufferG.FIELDNO("Cross Sales Order Amount"), SalesInvoiceLineL."Amount Including VAT" * CancelRateL);
                UNTIL SalesInvoiceLineL.NEXT = 0;
        END;
    end;

    local procedure SalesInvoiceQuantity(var SalesInvoiceHeaderP: Record "Sales Invoice Header"; CancelP: Boolean)
    var
        SalesInvoiceLineL: Record "Sales Invoice Line";
        CancelRateL: Integer;
    begin
        IF CancelP THEN
            CancelRateL := -1
        ELSE
            CancelRateL := 1;

        SalesInvoiceLineL.RESET;
        SalesInvoiceLineL.SETRANGE("Document No.", SalesInvoiceHeaderP."No.");
        SalesInvoiceLineL.SETFILTER("No.", '<>%1', '');
        IF SalesInvoiceLineL.FINDFIRST THEN
            REPEAT
                IF IsTyre(SalesInvoiceLineL."No.") THEN
                    InsertSalesInvoiceHeaderBuffer(SalesInvoiceHeaderP, BufferG.FIELDNO("Tyre Sales Quantity"), SalesInvoiceLineL."Quantity (Base)" * CancelRateL);
                IF IsBalanceService(SalesInvoiceLineL."No.") THEN
                    InsertSalesInvoiceHeaderBuffer(SalesInvoiceHeaderP, BufferG.FIELDNO("Resource Balance Quantity"), SalesInvoiceLineL."Quantity (Base)" * CancelRateL);
                IF IsPosService(SalesInvoiceLineL."No.") THEN
                    InsertSalesInvoiceHeaderBuffer(SalesInvoiceHeaderP, BufferG.FIELDNO("Resource PC Quantity"), SalesInvoiceLineL."Quantity (Base)" * CancelRateL);
            UNTIL SalesInvoiceLineL.NEXT = 0;
    end;

    local procedure SalesInvoiceVehicleCheckQuantity(var SalesInvoiceHeaderP: Record "Sales Invoice Header"; CancelP: Boolean)
    var
        CancelRateL: Integer;
    begin
        //++TWN1.00.122187.QX
        // Field 'Vehicle Check Status' is removed.
        // IF SalesInvoiceHeaderP."Vehicle Check Status" <> SalesInvoiceHeaderP."Vehicle Check Status"::Done THEN
        //             EXIT;
        //--TWN1.00.122187.QX
        if not (SalesInvoiceHeaderP."VC Vehicle Check Status" in [SalesInvoiceHeaderP."VC Vehicle Check Status"::Done, SalesInvoiceHeaderP."VC Vehicle Check Status"::"On-Going"]) then
            exit;

        IF CancelP THEN
            CancelRateL := -1
        ELSE
            CancelRateL := 1;

        SalesInvoiceHeaderP.CALCFIELDS("Amount Including VAT");
        InsertSalesInvoiceHeaderBuffer(SalesInvoiceHeaderP, BufferG.FIELDNO("Vehicle Check Order Count"), 1.0 * CancelRateL);
        InsertSalesInvoiceHeaderBuffer(SalesInvoiceHeaderP, BufferG.FIELDNO("Vehicle Check Order Amount"), SalesInvoiceHeaderP."Amount Including VAT" * CancelRateL);
    end;

    local procedure InsertSalesInvoiceHeaderBuffer(var SalesInvoiceHeaderP: Record "Sales Invoice Header"; FieldNoP: Integer; FieldValueP: Variant)
    begin
        InsertBuffer(SalesInvoiceHeaderP."Shortcut Dimension 1 Code",
          SalesInvoiceHeaderP."Shortcut Dimension 2 Code",
          SalesInvoiceHeaderP."Service Center",
          SalesInvoiceHeaderP."Posting Date",
          FieldNoP,
          FieldValueP);
    end;

    local procedure InsertSalesLineBuffer(var SalesInvoiceHeaderP: Record "Sales Invoice Header"; var SalesInvoiceLineP: Record "Sales Invoice Line"; FieldNoP: Integer; FieldValueP: Variant)
    begin
        InsertBuffer(SalesInvoiceHeaderP."Shortcut Dimension 1 Code",
          SalesInvoiceHeaderP."Shortcut Dimension 2 Code",
          SalesInvoiceHeaderP."Service Center",
          SalesInvoiceHeaderP."Posting Date",
          FieldNoP,
          FieldValueP);
    end;

    local procedure InsertBuffer(GlobalDimOneP: Code[20]; GlobalDimTwoP: Code[20]; ServiceCenterCodeP: Code[10]; PostingDateP: Date; FieldNoP: Integer; FieldValueP: Variant)
    var
        BufferL: Record "TW Performance Buffer";
        RecordRefL: RecordRef;
        FieldRefL: FieldRef;
        TempVarL: Variant;
        TempDecL: Decimal;
        TempDec2L: Decimal;
        TempIntL: Integer;
        TempInt2L: Integer;
    begin
        IF BufferL.GET(GlobalDimOneP, GlobalDimTwoP, ServiceCenterCodeP, PostingDateP) THEN BEGIN
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
            BufferL."Global Dimension Code 1" := GlobalDimOneP;
            BufferL."Global Dimension Code 2" := GlobalDimTwoP;
            BufferL."Service Center" := ServiceCenterCodeP;
            BufferL.Year := DATE2DMY(PostingDateP, 3);
            BufferL.Month := DATE2DMY(PostingDateP, 2);
            BufferL.Day := DATE2DMY(PostingDateP, 1);
            BufferL."Posting Date" := PostingDateP;
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

    local procedure IsSalesInvoiceDeleted(var SalesInvoiceHeaderP: Record "Sales Invoice Header"): Boolean
    var
        SalesInvoiceLineL: Record "Sales Invoice Line";
    begin
        SalesInvoiceLineL.RESET;
        SalesInvoiceLineL.SETRANGE("Document No.", SalesInvoiceHeaderP."No.");
        SalesInvoiceLineL.SETFILTER(Type, '<>%1', SalesInvoiceLineL.Type::" ");
        SalesInvoiceLineL.SETFILTER("No.", '<>%1', '');
        EXIT(SalesInvoiceLineL.ISEMPTY);
    end;

    local procedure IsResourceTurnover(ResourceNoP: Code[20]): Boolean
    var
        ReportSetupL: Record "Fastfit Setup - Reporting";
        ResourceL: Record Resource;
    begin
        ReportSetupL.GET;
        IF ReportSetupL."Position Group For TurnOver" = '' THEN
            ReportSetupL."Position Group For TurnOver" := 'B21001..B21017';

        ResourceL.RESET;
        ResourceL.SETRANGE("No.", ResourceNoP);
        ResourceL.SETFILTER("Position Group Code", ReportSetupL."Position Group For TurnOver");
        EXIT(NOT ResourceL.ISEMPTY);
    end;

    local procedure IsTyre(NoP: Code[20]): Boolean
    var
        ReportSetupL: Record "Fastfit Setup - Reporting";
        ItemL: Record Item;
    begin
        ReportSetupL.GET;
        IF ReportSetupL."Main Group For Tire" = '' THEN
            ReportSetupL."Main Group For Tire" := 'A1';
        ItemL.RESET;
        ItemL.SETRANGE("No.", NoP);
        ItemL.SETFILTER("Main Group Code", ReportSetupL."Main Group For Tire");
        EXIT(NOT ItemL.ISEMPTY);
    end;

    local procedure IsNonTyre(NoP: Code[20]): Boolean
    var
        ReportSetupL: Record "Fastfit Setup - Reporting";
        ItemL: Record Item;
    begin
        ReportSetupL.GET;
        IF ReportSetupL."Position Group For NonTire" = '' THEN
            ReportSetupL."Position Group For NonTire" := 'A20001..A99999|B10001..B17001';

        ItemL.RESET;
        ItemL.SETRANGE("No.", NoP);
        ItemL.SETFILTER("Position Group Code", ReportSetupL."Position Group For NonTire");
        EXIT(NOT ItemL.ISEMPTY);
    end;

    local procedure IsOilFilter(NoP: Code[20]): Boolean
    var
        ReportSetupL: Record "Fastfit Setup - Reporting";
        ItemL: Record Item;
    begin
        ReportSetupL.GET;
        IF ReportSetupL."Position Group For OilFilter" = '' THEN
            ReportSetupL."Position Group For OilFilter" := 'A81004';

        ItemL.RESET;
        ItemL.SETRANGE("No.", NoP);
        ItemL.SETFILTER("Position Group Code", ReportSetupL."Position Group For OilFilter");
        EXIT(NOT ItemL.ISEMPTY);
    end;

    local procedure IsOil(NoP: Code[20]): Boolean
    var
        ReportSetupL: Record "Fastfit Setup - Reporting";
        ItemL: Record Item;
    begin
        ReportSetupL.GET;
        IF ReportSetupL."Position Group For Oil" = '' THEN
            ReportSetupL."Position Group For Oil" := 'A60001..A60009';

        ItemL.RESET;
        ItemL.SETRANGE("No.", NoP);
        ItemL.SETFILTER("Position Group Code", ReportSetupL."Position Group For Oil");
        EXIT(NOT ItemL.ISEMPTY);
    end;

    local procedure IsBalanceService(NoP: Code[20]): Boolean
    var
        ReportSetupL: Record "Fastfit Setup - Reporting";
        ItemL: Record Item;
        ResourceL: Record Resource;
    begin
        ReportSetupL.GET;
        IF ReportSetupL."Position group of Balancing" = '' THEN
            ReportSetupL."Position group of Balancing" := 'B21005';

        ResourceL.RESET;
        ResourceL.SETRANGE("No.", NoP);
        ResourceL.SETFILTER("Position Group Code", ReportSetupL."Position group of Balancing");
        IF (NOT ResourceL.ISEMPTY) THEN
            EXIT(TRUE);

        ItemL.RESET;
        ItemL.SETRANGE("No.", NoP);
        ItemL.SETFILTER("Position Group Code", ReportSetupL."Position group of Balancing");
        IF (NOT ItemL.ISEMPTY) THEN
            EXIT(TRUE);

        EXIT(FALSE);
    end;

    local procedure IsPosService(NoP: Code[20]): Boolean
    var
        ReportSetupL: Record "Fastfit Setup - Reporting";
        ItemL: Record Item;
        ResourceL: Record Resource;
    begin
        ReportSetupL.GET;
        IF ReportSetupL."Position group of Alignments" = '' THEN
            ReportSetupL."Position group of Alignments" := 'B21003';

        ResourceL.RESET;
        ResourceL.SETRANGE("No.", NoP);
        ResourceL.SETFILTER("Position Group Code", ReportSetupL."Position group of Alignments");
        IF (NOT ResourceL.ISEMPTY) THEN
            EXIT(TRUE);

        ItemL.RESET;
        ItemL.SETRANGE("No.", NoP);
        ItemL.SETFILTER("Position Group Code", ReportSetupL."Position group of Alignments");
        IF (NOT ItemL.ISEMPTY) THEN
            EXIT(TRUE);

        EXIT(FALSE);
    end;

    local procedure InvoiceType(IsTyreP: Boolean; IsOilP: Boolean; IsOilFilterP: Boolean): Integer
    begin
        IF IsTyreP AND (NOT IsOilP) AND (NOT IsOilFilterP) THEN
            EXIT(1); // Tyre
        IF (NOT IsTyreP) AND (NOT IsOilP) AND IsOilFilterP THEN
            EXIT(2); // Oilfilter
        IF (NOT IsTyreP) AND IsOilP AND IsOilFilterP THEN
            EXIT(2); // Oilfilter
        IF (NOT IsTyreP) AND IsOilP AND (NOT IsOilFilterP) THEN
            EXIT(3); // Oil
        IF (IsTyreP) AND IsOilP AND (NOT IsOilFilterP) THEN
            EXIT(4); // Tyre + Oil + Oilfilter
        IF (IsTyreP) AND (NOT IsOilP) AND (IsOilFilterP) THEN
            EXIT(4); // Tyre + Oil + Oilfilter
        IF (IsTyreP) AND IsOilP AND IsOilFilterP THEN
            EXIT(4); // Tyre + Oil + Oilfilter

        EXIT(0); // Others
    end;

    local procedure SalesInvoiceProfit(SalesInvoiceHeaderP: Record "Sales Invoice Header"; CancelP: Boolean)
    var
        SalesInvoiceLineL: Record "Sales Invoice Line";
        CancelRateL: Integer;
    begin
        // Start 119384
        IF CancelP THEN
            CancelRateL := -1
        ELSE
            CancelRateL := 1;

        SalesInvoiceLineL.RESET;
        SalesInvoiceLineL.SETRANGE("Document No.", SalesInvoiceHeaderP."No.");
        SalesInvoiceLineL.SETFILTER("No.", '<>%1', '');
        IF SalesInvoiceLineL.FINDFIRST THEN
            REPEAT
                //InsertSalesInvoiceHeaderBuffer(SalesInvoiceHeaderP,BufferG.FIELDNO("Total Amt"),SalesInvoiceLineL.Amount*CancelRateL);
                InsertSalesInvoiceHeaderBuffer(SalesInvoiceHeaderP, BufferG.FIELDNO("Total Amt"), SalesInvoiceLineL."Amount Including VAT" * CancelRateL);
                InsertSalesInvoiceHeaderBuffer(SalesInvoiceHeaderP, BufferG.FIELDNO("Profit Amt"), CancelRateL *
                    GetDocumentLineProfit2(ItemLedEntryG."Document Type"::"Sales Invoice", SalesInvoiceLineL."Document No.", SalesInvoiceLineL."Line No.",
                    //SalesInvoiceLineL.Type,SalesInvoiceLineL."No.",SalesInvoiceLineL.Amount));
                    SalesInvoiceLineL.Type, SalesInvoiceLineL."No.", SalesInvoiceLineL."Amount Including VAT"));
            UNTIL SalesInvoiceLineL.NEXT = 0;
        // Stop  119384
    end;

    local procedure GetDocumentLineProfit(DocumentTypeP: Option " ","Sales Shipment","Sales Invoice","Sales Return Receipt","Sales Credit Memo","Purchase Receipt","Purchase Invoice","Purchase Return Shipment","Purchase Credit Memo","Transfer Shipment","Transfer Receipt","Service Shipment","Service Invoice","Service Credit Memo","Posted Assembly"; DocumentNoP: Code[20]; DocLineNoP: Integer; LineTypeP: Option " ","G/L Account",Item,Resource,"Fixed Asset","Charge (Item)"; LineItemNoP: Code[20]; LineAmtP: Decimal) ProfitR: Decimal
    begin
        // Start 119384
        CASE LineTypeP OF
            LineTypeP::Item:
                CASE DocumentTypeP OF
                    DocumentTypeP::"Sales Invoice":
                        BEGIN
                            ItemLedEntryG.RESET;
                            ItemLedEntryG.SETCURRENTKEY("Document No.", "Document Type", "Document Line No.");
                            ItemLedEntryG.SETRANGE("Document Type", DocumentTypeP);
                            ItemLedEntryG.SETRANGE("Document No.", DocumentNoP);
                            ItemLedEntryG.SETRANGE("Document Line No.", DocLineNoP);
                            ItemLedEntryG.SETRANGE("Item No.", LineItemNoP);
                            IF ItemLedEntryG.FINDSET THEN
                                REPEAT
                                    ItemLedEntryG.CALCFIELDS("Cost Amount (Expected)", "Cost Amount (Actual)");
                                    ProfitR += LineAmtP - (ItemLedEntryG."Cost Amount (Expected)" + ItemLedEntryG."Cost Amount (Actual)");
                                UNTIL ItemLedEntryG.NEXT = 0;
                        END;
                END;
            LineTypeP::Resource:
                ProfitR := LineAmtP;
        END;
        // Stop  119384
    end;

    local procedure GetDocumentLineProfit2(DocumentTypeP: Option " ","Sales Shipment","Sales Invoice","Sales Return Receipt","Sales Credit Memo","Purchase Receipt","Purchase Invoice","Purchase Return Shipment","Purchase Credit Memo","Transfer Shipment","Transfer Receipt","Service Shipment","Service Invoice","Service Credit Memo","Posted Assembly"; DocumentNoP: Code[20]; DocLineNoP: Integer; LineTypeP: Option " ","G/L Account",Item,Resource,"Fixed Asset","Charge (Item)"; LineItemNoP: Code[20]; LineAmtP: Decimal) ProfitR: Decimal
    begin
        // Start 119384
        CASE LineTypeP OF
            LineTypeP::Item:
                CASE DocumentTypeP OF
                    DocumentTypeP::"Sales Invoice":
                        BEGIN
                            ValueEntryG.RESET;
                            //ValueEntryG.SETCURRENTKEY("Document No.","Document Type","Document Line No.");
                            ValueEntryG.SETRANGE("Document Type", DocumentTypeP);
                            ValueEntryG.SETRANGE("Document No.", DocumentNoP);
                            ValueEntryG.SETRANGE("Document Line No.", DocLineNoP);
                            ValueEntryG.SETRANGE("Item No.", LineItemNoP);
                            IF ValueEntryG.FINDSET THEN
                                REPEAT
                                    //ValueEntryG.CALCFIELDS("Cost Amount (Expected)","Cost Amount (Actual)");
                                    ProfitR += (ValueEntryG."Cost Amount (Expected)" + ValueEntryG."Cost Amount (Actual)");
                                UNTIL ValueEntryG.NEXT = 0;
                        END;
                END;
            LineTypeP::Resource:
                ProfitR := 0;
        END;

        ProfitR += LineAmtP;
        // Stop  119384
    end;

    local procedure GetCancelType(SalesInvHeader: Record "Sales Invoice Header")
    var
        SalesCrMemoHeaderL: Record "Sales Cr.Memo Header";
    begin
        IF SalesInvHeader."Canceled By" <> '' THEN BEGIN
            SalesCrMemoHeaderL.RESET;
            SalesCrMemoHeaderL.SETRANGE("Corr. of Sales Invoice No.", SalesInvHeader."No.");
        END
        ELSE
            CancelType := CancelType::NoCancel;
    end;
}

