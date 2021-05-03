report 1044879 "TW E Retail Orders"
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
    // RGS_TWN-849   120845        GG     2019-10-28  New Object

    Caption = 'E Retail Orders';
    ProcessingOnly = true;

    dataset
    {
        dataitem(SalesInvoiceHeader; "Sales Invoice Header")
        {
            DataItemTableView = SORTING("No.")
                                ORDER(Ascending);
            dataitem(SalesInvoiceLine; "Sales Invoice Line")
            {
                DataItemLink = "Document No." = FIELD("No.");
                DataItemTableView = SORTING("Document No.", "Line No.")
                                    ORDER(Ascending)
                                    WHERE(Type = FILTER(<> ' '),
                                          "No." = FILTER(<> ''));

                trigger OnAfterGetRecord()
                var
                    IL: Integer;
                begin
                    TempExcelBufferG.NewRow();
                    IF IsFirstLineG THEN BEGIN
                        CLEAR(ServiceCenterG);
                        CLEAR(ContactG);
                        IF ServiceCenterG.GET(SalesInvoiceHeader."Service Center") THEN
                            ;
                        IF ContactG.GET(SalesInvoiceHeader."Bill-to Contact No.") THEN
                            ;
                        AddTextColumn(FORMAT(SalesInvoiceHeader."Posting Date", 0, '<Year4>-<Month,2>-<Day,2>'));
                        AddTextColumn(SalesInvoiceHeader."Service Center");
                        AddTextColumn(ServiceCenterG.Name);
                        AddTextColumn(SalesInvoiceHeader."Order Type");
                        AddTextColumn(SalesInvoiceHeader."External Document No.");
                        AddTextColumn(SalesInvoiceHeader."No.");
                        AddTextColumn(ContactG.Name);
                        AddTextColumn(SalesInvoiceHeader."Licence-Plate No.");
                    END ELSE BEGIN
                        FOR IL := 1 TO 8 DO
                            AddTextColumn('');
                    END;
                    AddTextColumn(SalesInvoiceLine."No.");
                    AddTextColumn(SalesInvoiceLine.Description);
                    AddDecimalColumn(SalesInvoiceLine.Quantity);
                    IF SalesInvoiceLine.Quantity <> 0 THEN
                        AddUnitColumn(SalesInvoiceLine."Amount Including VAT" / SalesInvoiceLine.Quantity)
                    ELSE
                        AddUnitColumn(0);
                    AddDecimalColumn(SalesInvoiceLine."Amount Including VAT");

                    TotalAmountG := TotalAmountG + SalesInvoiceLine."Amount Including VAT";
                    IsFirstLineG := FALSE;
                end;

                trigger OnPostDataItem()
                var
                    IL: Integer;
                begin
                    TempExcelBufferG.NewRow();
                    FOR IL := 1 TO 12 DO
                        AddTextColumn('');
                    AddDecimalColumn(TotalAmountG);
                end;
            }

            trigger OnAfterGetRecord()
            begin
                IsFirstLineG := TRUE;
                TotalAmountG := 0;
            end;

            trigger OnPreDataItem()
            begin
                SETRANGE("Posting Date", StartDateG, EndDateG);
                SETFILTER("Order Type", OrderTypeFilterG);
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
                    field("Start Date"; StartDateG)
                    {
                    }
                    field("End Date"; EndDateG)
                    {
                    }
                    field("Order Type"; OrderTypeFilterG)
                    {

                        trigger OnLookup(var Text: Text): Boolean
                        begin
                            OrderTypeFilterG := OnLookupOrderType;
                        end;
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            StartDateG := DMY2DATE(1, DATE2DMY(WORKDATE, 2), DATE2DMY(WORKDATE, 3));
            EndDateG := WORKDATE;
            OrderTypeFilterG := '<>ZADHOC';
        end;
    }

    labels
    {
    }

    trigger OnPostReport()
    var
        FileNameL: Text;
    begin
        TempExcelBufferG.RESET;
        IF TempExcelBufferG.COUNT > 1 THEN BEGIN
            TempExcelBufferG.CreateBookAndOpenExcel(FileNameL, C_INC_002, C_INC_002, COMPANYNAME, USERID);
            ERROR('');
        END;
    end;

    trigger OnPreReport()
    begin
        IF (StartDateG = 0D) OR (EndDateG = 0D) OR (StartDateG > EndDateG) THEN
            ERROR(C_INC_001);
        IF (EndDateG >= CALCDATE('<1M>', StartDateG)) THEN
            ERROR(C_INC_001);

        GLSetupG.GET();
        AmountFormatG := GetNumFormat(GLSetupG."Amount Rounding Precision");
        MakeExcelHeader();
    end;

    var
        TempExcelBufferG: Record "Excel Buffer" temporary;
        GLSetupG: Record "General Ledger Setup";
        ServiceCenterG: Record "Service Center";
        ContactG: Record Contact;
        StartDateG: Date;
        EndDateG: Date;
        OrderTypeFilterG: Code[1000];
        C_INC_001: Label 'Please input start date or end date valid.';
        C_INC_002: Label 'E Retail Orders';
        C_INC_50001: Label 'Posting Date';
        C_INC_50002: Label 'Service Center';
        C_INC_50003: Label 'Service Center Name';
        C_INC_50004: Label 'Order Type';
        C_INC_50005: Label 'External Document No.';
        C_INC_50006: Label 'Invoice No.';
        C_INC_50007: Label 'Bill-to Name';
        C_INC_50008: Label 'License-Plate No.';
        C_INC_50009: Label 'No.';
        C_INC_50010: Label 'Description';
        C_INC_50011: Label 'Quantity';
        C_INC_50012: Label 'Line Amount Including VAT';
        C_INC_50013: Label 'Amount Including VAT';
        AmountFormatG: Text;
        IsFirstLineG: Boolean;
        TotalAmountG: Decimal;

    local procedure OnLookupOrderType(): Code[1000]
    var
        OrderTypeL: Record "Order Type";
        OrderTypeListL: Page "Order Type";
    begin
        CLEAR(OrderTypeListL);
        OrderTypeListL.EDITABLE := FALSE;
        OrderTypeListL.LOOKUPMODE := TRUE;
        IF OrderTypeListL.RUNMODAL = ACTION::LookupOK THEN BEGIN
            OrderTypeListL.GETRECORD(OrderTypeL);
            EXIT(OrderTypeL.Code);
        END;

        EXIT('');
    end;

    local procedure MakeExcelHeader()
    begin
        TempExcelBufferG.NewRow();
        AddHeaderColumn(C_INC_50001);
        AddHeaderColumn(C_INC_50002);
        AddHeaderColumn(C_INC_50003);
        AddHeaderColumn(C_INC_50004);
        AddHeaderColumn(C_INC_50005);
        AddHeaderColumn(C_INC_50006);
        AddHeaderColumn(C_INC_50007);
        AddHeaderColumn(C_INC_50008);
        AddHeaderColumn(C_INC_50009);
        AddHeaderColumn(C_INC_50010);
        AddHeaderColumn(C_INC_50011);
        AddHeaderColumn(C_INC_50012);
        AddHeaderColumn(C_INC_50013);
    end;

    local procedure AddHeaderColumn(HeaderCaptionP: Text)
    begin
        TempExcelBufferG.AddColumn(HeaderCaptionP, FALSE, '', TRUE, FALSE, TRUE, '@', TempExcelBufferG."Cell Type"::Text);
    end;

    local procedure AddTextColumn(TextValueP: Text)
    var
        refTableL: RecordRef;
        refFieldL: FieldRef;
        FieldNoL: Integer;
        TypeL: Integer;
        ColValueL: Text;
        TempDecL: Decimal;
        OCTNoL: Text;
        OrderNoL: Code[20];
        PostingDateL: Date;
    begin
        TempExcelBufferG.AddColumn(TextValueP, FALSE, '', FALSE, FALSE, FALSE, '@', TempExcelBufferG."Cell Type"::Text);
    end;

    local procedure AddDecimalColumn(DecimalValueP: Decimal)
    begin
        TempExcelBufferG.AddColumn(DecimalValueP, FALSE, '', FALSE, FALSE, FALSE, '##0.00', TempExcelBufferG."Cell Type"::Number);
    end;

    local procedure AddUnitColumn(DecimalValueP: Decimal)
    begin
        TempExcelBufferG.AddColumn(DecimalValueP, FALSE, '', FALSE, FALSE, FALSE, '##0.00###', TempExcelBufferG."Cell Type"::Number);
    end;

    local procedure GetNumFormat(RoundingPrecisionP: Decimal): Text[50]
    var
        NumFormatL: Text[50];
    begin
        IF RoundingPrecisionP <= 0 THEN
            EXIT('#0.00');

        IF RoundingPrecisionP >= 1 THEN
            EXIT('####');

        REPEAT
            RoundingPrecisionP *= 10;
            NumFormatL += '0';
        UNTIL RoundingPrecisionP >= 1;

        EXIT('#0.' + NumFormatL);
    end;
}

