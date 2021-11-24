report 1044886 "Fix VC Status for Perf. Report"
{
    Caption = 'Fix VC Status for Performance Report';
    ProcessingOnly = true;

    dataset
    {
        dataitem(TWTableKeyInfoSI; "TW Table Key Information")
        {
            trigger OnPreDataItem()
            begin
                SetRange("Table ID", Database::"Sales Invoice Header");
            end;

            trigger OnAfterGetRecord()
            var
                SalesInvoiceHeaderL: Record "Sales Invoice Header";
            begin
                if SalesInvoiceHeaderL.Get(TWTableKeyInfoSI."Document No.") then
                    SalesInvoiceVehicleCheckQuantity(SalesInvoiceHeaderL, FALSE);
            end;
        }
        dataitem(TWTableKeyInfoSCM; "TW Table Key Information")
        {
            trigger OnPreDataItem()
            begin
                SetRange("Table ID", Database::"Sales Cr.Memo Header");
            end;

            trigger OnAfterGetRecord()
            var
                SalesInvoiceHeaderL: Record "Sales Invoice Header";
                SalesCreditMemoHdrL: Record "Sales Cr.Memo Header";
            begin
                if SalesCreditMemoHdrL.Get(TWTableKeyInfoSCM."Document No.") then begin
                    SalesInvoiceHeaderL.Reset();
                    SalesInvoiceHeaderL.SetRange("Canceled By", SalesCreditMemoHdrL."No.");
                    if SalesInvoiceHeaderL.FindFirst() then
                        SalesInvoiceVehicleCheckQuantity(SalesInvoiceHeaderL, true);
                end;
            end;
        }
    }
    trigger OnPreReport()
    begin
        if MARSTempFlagMgtG.IsVehicelCheckStatusFixed() then
            CurrReport.Quit();

        BufferG.ModifyAll("Vehicle Check Order Count", 0);
        BufferG.ModifyAll("Vehicle Check Order Amount", 0);
    end;

    trigger OnPostReport()
    begin
        MARSTempFlagMgtG.FlagVehicleCheckStatus();
    end;

    local procedure SalesInvoiceVehicleCheckQuantity(var SalesInvoiceHeaderP: Record "Sales Invoice Header"; CancelP: Boolean)
    var
        CancelRateL: Integer;
    begin
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

    var
        TWTableKeyInfG: Record "TW Table Key Information";
        BufferG: Record "TW Performance Buffer";
        MARSTempFlagMgtG: Codeunit "MARS TWN Temp Flag Mgt";
}
