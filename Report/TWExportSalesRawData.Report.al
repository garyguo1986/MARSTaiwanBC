report 1044878 "TW Export Sales Raw Data"
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
    // RGS_TWN-833   119130        WP     2019-04-08  New Object
    // RGS_TWN-845   120529        GG     2019-09-11  Added field "Tire MI Sellout"

    Caption = 'Export Sales Raw Data';
    ProcessingOnly = true;

    dataset
    {
        dataitem(Integer; Integer)
        {
            DataItemTableView = SORTING(Number)
                                WHERE(Number = CONST(1));

            trigger OnAfterGetRecord()
            var
                Window: Dialog;
                RecNo: Integer;
                TotalRecNo: Integer;
                RowNo: Integer;
                ColumnNo: Integer;
                MainGroupCodeL: Code[10];
                SubGroupCodeL: Code[10];
                PositionGroupCodeL: Code[10];
            begin
                Window.OPEN(
                  Text000 +
                  '@1@@@@@@@@@@@@@@@@@@@@@\');
                Window.UPDATE(1, 0);

                TotalRecNo := TWSalesDataHeaderBufferG.COUNT;
                RecNo := 0;

                TempExcelBufferG.DELETEALL(FALSE);
                CLEAR(TempExcelBufferG);

                RowNo := 1;
                EnterHeaderCell(RowNo, 1, C_MIL_Header01, TRUE, FALSE, FALSE, FALSE, '', TempExcelBufferG."Cell Type"::Text);
                EnterHeaderCell(RowNo, 2, C_MIL_Header02, TRUE, FALSE, FALSE, FALSE, '', TempExcelBufferG."Cell Type"::Text);
                EnterHeaderCell(RowNo, 3, C_MIL_Header19, TRUE, FALSE, FALSE, FALSE, '', TempExcelBufferG."Cell Type"::Text);
                EnterHeaderCell(RowNo, 4, C_MIL_Header03, TRUE, FALSE, FALSE, FALSE, '', TempExcelBufferG."Cell Type"::Text);
                EnterHeaderCell(RowNo, 5, C_MIL_Header04, TRUE, FALSE, FALSE, FALSE, '', TempExcelBufferG."Cell Type"::Text);
                EnterHeaderCell(RowNo, 6, C_MIL_Header05, TRUE, FALSE, FALSE, FALSE, '', TempExcelBufferG."Cell Type"::Text);
                EnterHeaderCell(RowNo, 7, C_MIL_Header06, TRUE, FALSE, FALSE, FALSE, '', TempExcelBufferG."Cell Type"::Text);
                EnterHeaderCell(RowNo, 8, C_MIL_Header07, TRUE, FALSE, FALSE, FALSE, '', TempExcelBufferG."Cell Type"::Text);
                EnterHeaderCell(RowNo, 9, C_MIL_Header08, TRUE, FALSE, FALSE, FALSE, '', TempExcelBufferG."Cell Type"::Text);
                EnterHeaderCell(RowNo, 10, C_MIL_Header09, TRUE, FALSE, FALSE, FALSE, '', TempExcelBufferG."Cell Type"::Text);
                EnterHeaderCell(RowNo, 11, C_MIL_Header10, TRUE, FALSE, FALSE, FALSE, '', TempExcelBufferG."Cell Type"::Text);
                EnterHeaderCell(RowNo, 12, C_MIL_Header11, TRUE, FALSE, FALSE, FALSE, '', TempExcelBufferG."Cell Type"::Text);
                EnterHeaderCell(RowNo, 13, C_MIL_Header12, TRUE, FALSE, FALSE, FALSE, '', TempExcelBufferG."Cell Type"::Text);
                EnterHeaderCell(RowNo, 14, C_MIL_Header13, TRUE, FALSE, FALSE, FALSE, '', TempExcelBufferG."Cell Type"::Text);
                EnterHeaderCell(RowNo, 15, C_MIL_Header14, TRUE, FALSE, FALSE, FALSE, '', TempExcelBufferG."Cell Type"::Text);
                EnterHeaderCell(RowNo, 16, C_MIL_Header15, TRUE, FALSE, FALSE, FALSE, '', TempExcelBufferG."Cell Type"::Text);
                EnterHeaderCell(RowNo, 17, C_MIL_Header16, TRUE, FALSE, FALSE, FALSE, '', TempExcelBufferG."Cell Type"::Text);
                EnterHeaderCell(RowNo, 18, C_MIL_Header17, TRUE, FALSE, FALSE, FALSE, '', TempExcelBufferG."Cell Type"::Text);
                EnterHeaderCell(RowNo, 19, C_MIL_Header18, TRUE, FALSE, FALSE, FALSE, '', TempExcelBufferG."Cell Type"::Text);
                // Start 120529
                EnterHeaderCell(RowNo, 20, C_MIL_Header24, TRUE, FALSE, FALSE, FALSE, '', TempExcelBufferG."Cell Type"::Text);
                // Stop 120529

                TWSalesDataHeaderBufferG.RESET;
                // Start 119130
                IF StartDateG <> 0D THEN BEGIN
                    TWSalesDataHeaderBufferG.SETCURRENTKEY(Date);
                    TWSalesDataHeaderBufferG.SETRANGE(Date, StartDateG, EndDateG);
                END;
                // Stop  119130
                IF TWSalesDataHeaderBufferG.FIND('-') THEN BEGIN
                    REPEAT
                        RecNo := RecNo + 1;
                        Window.UPDATE(1, ROUND(RecNo / TotalRecNo * 10000, 1));
                        RowNo := RowNo + 1;
                        ColumnNo := 1;
                        EnterCell(
                          RowNo,
                          ColumnNo,
                          FORMAT(TWSalesDataHeaderBufferG.Year),
                          FALSE,
                          FALSE,
                          FALSE,
                          FALSE,
                          '',
                          TempExcelBufferG."Cell Type"::Text);
                        ColumnNo := 2;
                        EnterCell(
                          RowNo,
                          ColumnNo,
                          FORMAT(TWSalesDataHeaderBufferG.Month),
                          FALSE,
                          FALSE,
                          FALSE,
                          FALSE,
                          '',
                          TempExcelBufferG."Cell Type"::Text);
                        ColumnNo := 3;
                        EnterCell(
                          RowNo,
                          ColumnNo,
                          TWSalesDataHeaderBufferG."Zone Code",
                          FALSE,
                          FALSE,
                          FALSE,
                          FALSE,
                          '',
                          TempExcelBufferG."Cell Type"::Text);
                        ColumnNo := 4;
                        EnterCell(
                          RowNo,
                          ColumnNo,
                          TWSalesDataHeaderBufferG."Service Center",
                          FALSE,
                          FALSE,
                          FALSE,
                          FALSE,
                          '',
                          TempExcelBufferG."Cell Type"::Text);
                        ColumnNo := 5;
                        EnterCell(
                          RowNo,
                          ColumnNo,
                          TWSalesDataHeaderBufferG."Shop Name",
                          FALSE,
                          FALSE,
                          FALSE,
                          FALSE,
                          '',
                          TempExcelBufferG."Cell Type"::Text);
                        ColumnNo := 6;
                        EnterCell(
                          RowNo,
                          ColumnNo,
                          TWSalesDataHeaderBufferG."Post Code",
                          FALSE,
                          FALSE,
                          FALSE,
                          FALSE,
                          '',
                          TempExcelBufferG."Cell Type"::Text);
                        ColumnNo := 7;
                        EnterCell(
                          RowNo,
                          ColumnNo,
                          FORMAT(TWSalesDataHeaderBufferG."Posted Invoice Count"),
                          FALSE,
                          FALSE,
                          FALSE,
                          FALSE,
                          '',
                          TempExcelBufferG."Cell Type"::Number);
                        ColumnNo := 8;
                        EnterCell(
                          RowNo,
                          ColumnNo,
                          FORMAT(TWSalesDataHeaderBufferG."Posted Invoice with updated VC"),
                          FALSE,
                          FALSE,
                          FALSE,
                          FALSE,
                          '',
                          TempExcelBufferG."Cell Type"::Number);
                        ColumnNo := 9;
                        EnterCell(
                          RowNo,
                          ColumnNo,
                          FORMAT(TWSalesDataHeaderBufferG."Posted Inv. with add. Sales"),
                          FALSE,
                          FALSE,
                          FALSE,
                          FALSE,
                          '',
                          TempExcelBufferG."Cell Type"::Number);
                        ColumnNo := 10;
                        EnterCell(
                          RowNo,
                          ColumnNo,
                          FORMAT(TWSalesDataHeaderBufferG."Sales invoiced Qty"),
                          FALSE,
                          FALSE,
                          FALSE,
                          FALSE,
                          '',
                          TempExcelBufferG."Cell Type"::Number);
                        ColumnNo := 11;
                        EnterCell(
                          RowNo,
                          ColumnNo,
                          FORMAT(TWSalesDataHeaderBufferG."Sales Amount"),
                          FALSE,
                          FALSE,
                          FALSE,
                          FALSE,
                          '',
                          TempExcelBufferG."Cell Type"::Number);
                        ColumnNo := 12;
                        EnterCell(
                          RowNo,
                          ColumnNo,
                          FORMAT(TWSalesDataHeaderBufferG."Sales Amount Tyre"),
                          FALSE,
                          FALSE,
                          FALSE,
                          FALSE,
                          '',
                          TempExcelBufferG."Cell Type"::Number);
                        ColumnNo := 13;
                        EnterCell(
                          RowNo,
                          ColumnNo,
                          FORMAT(TWSalesDataHeaderBufferG."Sales Amount Non Tyre"),
                          FALSE,
                          FALSE,
                          FALSE,
                          FALSE,
                          '',
                          TempExcelBufferG."Cell Type"::Number);
                        ColumnNo := 14;
                        EnterCell(
                          RowNo,
                          ColumnNo,
                          FORMAT(TWSalesDataHeaderBufferG."Sales Amount Service"),
                          FALSE,
                          FALSE,
                          FALSE,
                          FALSE,
                          '',
                          TempExcelBufferG."Cell Type"::Number);
                        ColumnNo := 15;
                        EnterCell(
                          RowNo,
                          ColumnNo,
                          FORMAT(TWSalesDataHeaderBufferG."GM %"),
                          FALSE,
                          FALSE,
                          FALSE,
                          FALSE,
                          '',
                          TempExcelBufferG."Cell Type"::Number);
                        ColumnNo := 16;
                        EnterCell(
                          RowNo,
                          ColumnNo,
                          FORMAT(TWSalesDataHeaderBufferG."SOB Tyre related services"),
                          FALSE,
                          FALSE,
                          FALSE,
                          FALSE,
                          '',
                          TempExcelBufferG."Cell Type"::Number);
                        ColumnNo := 17;
                        EnterCell(
                          RowNo,
                          ColumnNo,
                          FORMAT(TWSalesDataHeaderBufferG."SOB NTP and Services"),
                          FALSE,
                          FALSE,
                          FALSE,
                          FALSE,
                          '',
                          TempExcelBufferG."Cell Type"::Number);
                        ColumnNo := 18;
                        EnterCell(
                          RowNo,
                          ColumnNo,
                          FORMAT(TWSalesDataHeaderBufferG."Tyre Sales A1"),
                          FALSE,
                          FALSE,
                          FALSE,
                          FALSE,
                          '',
                          TempExcelBufferG."Cell Type"::Number);
                        ColumnNo := 19;
                        EnterCell(
                          RowNo,
                          ColumnNo,
                          FORMAT(TWSalesDataHeaderBufferG."Tyre Sales MI BFG"),
                          FALSE,
                          FALSE,
                          FALSE,
                          FALSE,
                          '',
                          TempExcelBufferG."Cell Type"::Number);
                        ColumnNo := 20;
                        // Start 120529
                        EnterCell(
                          RowNo,
                          ColumnNo,
                          FORMAT(TWSalesDataHeaderBufferG."Tire MI Sellout"),
                          FALSE,
                          FALSE,
                          FALSE,
                          FALSE,
                          '',
                          TempExcelBufferG."Cell Type"::Number);
                    // Stop 120529
                    UNTIL TWSalesDataHeaderBufferG.NEXT = 0;
                END;

                Window.CLOSE;
                Window.OPEN(
                  Text000 +
                  '@1@@@@@@@@@@@@@@@@@@@@@\');
                Window.UPDATE(1, 0);
                TempExcelBufferG.SetFriendlyFilename('Sales Raw Data');
                TempExcelBufferG.CreateBook('', 'Raw Data Analysis');
                TempExcelBufferG.WriteSheet('Raw Data Analysis', COMPANYNAME, USERID);
                TempExcelBufferG.DELETEALL(FALSE);
                TempExcelBufferG.AddMultiSheet('Raw Data Details');
                TempExcelBufferG.ClearNewRow;
                TWSalesDataLineBufferG.RESET;
                TotalRecNo := TWSalesDataLineBufferG.COUNT;
                RecNo := 0;
                RowNo := 1;
                EnterHeaderCell(RowNo, 1, C_MIL_Header01, TRUE, FALSE, FALSE, FALSE, '', TempExcelBufferG."Cell Type"::Text);
                EnterHeaderCell(RowNo, 2, C_MIL_Header02, TRUE, FALSE, FALSE, FALSE, '', TempExcelBufferG."Cell Type"::Text);
                EnterHeaderCell(RowNo, 3, C_MIL_Header19, TRUE, FALSE, FALSE, FALSE, '', TempExcelBufferG."Cell Type"::Text);
                EnterHeaderCell(RowNo, 4, C_MIL_Header03, TRUE, FALSE, FALSE, FALSE, '', TempExcelBufferG."Cell Type"::Text);
                EnterHeaderCell(RowNo, 5, C_MIL_Header04, TRUE, FALSE, FALSE, FALSE, '', TempExcelBufferG."Cell Type"::Text);
                EnterHeaderCell(RowNo, 6, C_MIL_Header05, TRUE, FALSE, FALSE, FALSE, '', TempExcelBufferG."Cell Type"::Text);
                EnterHeaderCell(RowNo, 7, C_MIL_Header20, TRUE, FALSE, FALSE, FALSE, '', TempExcelBufferG."Cell Type"::Text);
                EnterHeaderCell(RowNo, 8, C_MIL_Header21, TRUE, FALSE, FALSE, FALSE, '', TempExcelBufferG."Cell Type"::Text);
                EnterHeaderCell(RowNo, 9, C_MIL_Header22, TRUE, FALSE, FALSE, FALSE, '', TempExcelBufferG."Cell Type"::Text);
                EnterHeaderCell(RowNo, 10, C_MIL_Header23, TRUE, FALSE, FALSE, FALSE, '', TempExcelBufferG."Cell Type"::Text);
                EnterHeaderCell(RowNo, 11, C_MIL_Header08, TRUE, FALSE, FALSE, FALSE, '', TempExcelBufferG."Cell Type"::Text);
                EnterHeaderCell(RowNo, 12, C_MIL_Header09, TRUE, FALSE, FALSE, FALSE, '', TempExcelBufferG."Cell Type"::Text);
                EnterHeaderCell(RowNo, 13, C_MIL_Header10, TRUE, FALSE, FALSE, FALSE, '', TempExcelBufferG."Cell Type"::Text);

                // Start 119130
                IF StartDateG <> 0D THEN BEGIN
                    TWSalesDataLineBufferG.SETCURRENTKEY(Date);
                    TWSalesDataLineBufferG.SETRANGE(Date, StartDateG, EndDateG);
                END;
                // Stop  119130
                IF TWSalesDataLineBufferG.FINDFIRST THEN BEGIN
                    REPEAT
                        RecNo := RecNo + 1;
                        Window.UPDATE(1, ROUND(RecNo / TotalRecNo * 10000, 1));
                        RowNo := RowNo + 1;
                        ColumnNo := 1;
                        EnterCell(
                          RowNo,
                          ColumnNo,
                          FORMAT(TWSalesDataLineBufferG.Year),
                          FALSE,
                          FALSE,
                          FALSE,
                          FALSE,
                          '',
                          TempExcelBufferG."Cell Type"::Text);
                        ColumnNo := 2;
                        EnterCell(
                          RowNo,
                          ColumnNo,
                          FORMAT(TWSalesDataLineBufferG.Month),
                          FALSE,
                          FALSE,
                          FALSE,
                          FALSE,
                          '',
                          TempExcelBufferG."Cell Type"::Text);
                        ColumnNo := 3;
                        EnterCell(
                          RowNo,
                          ColumnNo,
                          TWSalesDataLineBufferG."Zone Code",
                          FALSE,
                          FALSE,
                          FALSE,
                          FALSE,
                          '',
                          TempExcelBufferG."Cell Type"::Text);
                        ColumnNo := 4;
                        EnterCell(
                          RowNo,
                          ColumnNo,
                          TWSalesDataLineBufferG."Service Center",
                          FALSE,
                          FALSE,
                          FALSE,
                          FALSE,
                          '',
                          TempExcelBufferG."Cell Type"::Text);
                        ColumnNo := 5;
                        EnterCell(
                          RowNo,
                          ColumnNo,
                          TWSalesDataLineBufferG."Shop Name",
                          FALSE,
                          FALSE,
                          FALSE,
                          FALSE,
                          '',
                          TempExcelBufferG."Cell Type"::Text);
                        ColumnNo := 6;
                        EnterCell(
                          RowNo,
                          ColumnNo,
                          TWSalesDataLineBufferG."Post Code",
                          FALSE,
                          FALSE,
                          FALSE,
                          FALSE,
                          '',
                          TempExcelBufferG."Cell Type"::Text);
                        ColumnNo := 7;
                        EnterCell(
                          RowNo,
                          ColumnNo,
                          FORMAT(TWSalesDataLineBufferG."Manufacturer Code"),
                          FALSE,
                          FALSE,
                          FALSE,
                          FALSE,
                          '',
                          TempExcelBufferG."Cell Type"::Text);
                        ColumnNo := 8;
                        EnterCell(
                          RowNo,
                          ColumnNo,
                          FORMAT(TWSalesDataLineBufferG."Main Group Code"),
                          FALSE,
                          FALSE,
                          FALSE,
                          FALSE,
                          '',
                          TempExcelBufferG."Cell Type"::Text);
                        ColumnNo := 9;
                        EnterCell(
                          RowNo,
                          ColumnNo,
                          FORMAT(TWSalesDataLineBufferG."Position Group Code"),
                          FALSE,
                          FALSE,
                          FALSE,
                          FALSE,
                          '',
                          TempExcelBufferG."Cell Type"::Text);
                        ColumnNo := 10;
                        EnterCell(
                          RowNo,
                          ColumnNo,
                          FORMAT(TWSalesDataLineBufferG."Posted Invoice No."),
                          FALSE,
                          FALSE,
                          FALSE,
                          FALSE,
                          '',
                          TempExcelBufferG."Cell Type"::Text);
                        ColumnNo := 11;
                        EnterCell(
                          RowNo,
                          ColumnNo,
                          FORMAT(TWSalesDataLineBufferG."Add. Sales Line Clicked"),
                          FALSE,
                          FALSE,
                          FALSE,
                          FALSE,
                          '',
                          TempExcelBufferG."Cell Type"::Text);
                        ColumnNo := 12;
                        EnterCell(
                          RowNo,
                          ColumnNo,
                          FORMAT(TWSalesDataLineBufferG."Sales Invoiced Qty"),
                          FALSE,
                          FALSE,
                          FALSE,
                          FALSE,
                          '',
                          TempExcelBufferG."Cell Type"::Number);
                        ColumnNo := 13;
                        EnterCell(
                          RowNo,
                          ColumnNo,
                          FORMAT(TWSalesDataLineBufferG."Sales Amount"),
                          FALSE,
                          FALSE,
                          FALSE,
                          FALSE,
                          '',
                          TempExcelBufferG."Cell Type"::Number);
                    UNTIL TWSalesDataLineBufferG.NEXT = 0;
                END;
                TempExcelBufferG.WriteSheet('Details', COMPANYNAME, USERID);
                TempExcelBufferG.DELETEALL(FALSE);

                TempExcelBufferG.CloseBook;
                TempExcelBufferG.DownloadAndOpenExcel;
                TempExcelBufferG.GiveUserControl;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(StartDate; StartDateG)
                {
                    AutoFormatType = 0;
                    Caption = 'Start Date';

                    trigger OnValidate()
                    begin
                        // Start 119130
                        IF StartDateG <> 0D THEN
                            StartDateG := CALCDATE('-CM', StartDateG);
                        IF EndDateG <> 0D THEN
                            IF StartDateG > EndDateG THEN
                                ERROR(C_Text100);
                        // Stop  119130
                    end;
                }
                field(EndDate; EndDateG)
                {
                    Caption = 'End Date';

                    trigger OnValidate()
                    begin
                        // Start 119130
                        IF EndDateG <> 0D THEN
                            EndDateG := CALCDATE('CM', EndDateG);
                        IF StartDateG > EndDateG THEN
                            ERROR(C_Text100);
                        // Stop  119130
                    end;
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

    trigger OnPreReport()
    begin
        // Start 119130
        IF StartDateG <> 0D THEN BEGIN
            IF EndDateG = 0D THEN
                EndDateG := TODAY;
        END;
        // Stop  119130
    end;

    var
        Text000: Label 'Analyzing Data...\\';
        Text001: Label 'Filters';
        Text002: Label 'Update Workbook';
        TempExcelBufferG: Record "Excel Buffer" temporary;
        C_Text100: Label 'Start Date must be less than End Date!';
        ExcelFileExtensionTok: Label '.xlsx', Locked = true;
        TWSalesDataHeaderBufferG: Record "TW Sales Data Header Buffer";
        C_MIL_Header01: Label 'Year';
        C_MIL_Header02: Label 'Month';
        C_MIL_Header03: Label 'Service center';
        C_MIL_Header04: Label 'Shop Name';
        C_MIL_Header05: Label 'Post Code';
        C_MIL_Header06: Label 'Posted Invoice';
        C_MIL_Header07: Label 'Posted Invoice with updated VC';
        C_MIL_Header08: Label 'Posted Invoice with additional sales line';
        C_MIL_Header09: Label 'Sales invoiced Qty';
        C_MIL_Header10: Label 'Sales Amount';
        C_MIL_Header11: Label 'Sales Amount_Tyre';
        C_MIL_Header12: Label 'Sales Amount_Non Tyre Product';
        C_MIL_Header13: Label 'Sales Amount_Service';
        C_MIL_Header14: Label 'GM%';
        C_MIL_Header15: Label 'SOB Tyre related services';
        C_MIL_Header16: Label 'SOB NTP and Services';
        C_MIL_Header17: Label 'Tyre Sales(A1)';
        C_MIL_Header18: Label 'Tyre Sales(MI+BFG)';
        TWSalesDataLineBufferG: Record "TW Sales Data Line Buffer";
        C_MIL_Header19: Label 'Zone Code';
        C_MIL_Header20: Label 'Manufacturer Code';
        C_MIL_Header21: Label 'Main Group';
        C_MIL_Header22: Label 'Position Group';
        C_MIL_Header23: Label 'Posted Invoice No.';
        StartDateG: Date;
        EndDateG: Date;
        C_MIL_Header24: Label 'Tire MI Sellout';

    local procedure EnterCell(RowNo: Integer; ColumnNo: Integer; CellValue: Text[250]; Bold: Boolean; Italic: Boolean; UnderLine: Boolean; DoubleUnderLine: Boolean; Format: Text[30]; CellType: Option)
    begin
        TempExcelBufferG.INIT;
        TempExcelBufferG.VALIDATE("Row No.", RowNo);
        TempExcelBufferG.VALIDATE("Column No.", ColumnNo);
        TempExcelBufferG."Cell Value as Text" := CellValue;
        TempExcelBufferG.Formula := '';
        TempExcelBufferG.Bold := Bold;
        TempExcelBufferG.Italic := Italic;
        IF DoubleUnderLine = TRUE THEN BEGIN
            TempExcelBufferG."Double Underline" := TRUE;
            TempExcelBufferG.Underline := FALSE;
        END ELSE BEGIN
            TempExcelBufferG."Double Underline" := FALSE;
            TempExcelBufferG.Underline := UnderLine;
        END;
        TempExcelBufferG.NumberFormat := Format;
        TempExcelBufferG."Cell Type" := CellType;
        TempExcelBufferG.INSERT;
    end;

    local procedure EnterHeaderCell(RowNo: Integer; ColumnNo: Integer; CellValue: Text[250]; Bold: Boolean; Italic: Boolean; UnderLine: Boolean; DoubleUnderLine: Boolean; Format: Text[30]; CellType: Option)
    begin
        TempExcelBufferG.INIT;
        TempExcelBufferG.VALIDATE("Row No.", RowNo);
        TempExcelBufferG.VALIDATE("Column No.", ColumnNo);
        TempExcelBufferG."Cell Value as Text" := CellValue;
        TempExcelBufferG.Formula := '';
        TempExcelBufferG.Bold := Bold;
        TempExcelBufferG.Italic := Italic;
        IF DoubleUnderLine = TRUE THEN BEGIN
            TempExcelBufferG."Double Underline" := TRUE;
            TempExcelBufferG.Underline := FALSE;
        END ELSE BEGIN
            TempExcelBufferG."Double Underline" := FALSE;
            TempExcelBufferG.Underline := UnderLine;
        END;
        TempExcelBufferG.NumberFormat := Format;
        TempExcelBufferG."Cell Type" := CellType;
        TempExcelBufferG.INSERT;
    end;
}

