tableextension 1073879 "Excel Buffer Ext" extends "Excel Buffer"
{
    // +--------------------------------------------------------------+
    // | @ 2019 incadea Taiwan Limited                                |
    // +--------------------------------------------------------------+
    // | PURPOSE: MARS_TWN                                            |
    // |                                                              |
    // | REMARK :                                                     |
    // +--------------------------------------------------------------+

    // VERSION       ID            WHO    DATE        DESCRIPTION
    // RGS_TWN-833   119130        GY     2019-04-08  Add function AddMultiSheet
    // RGS_TWN-848   120846        GG     2019-10-31  Add functions SelectSheetsNameByID,IsSheetExist,AddSheetAndOpenExcel,CreateBookAndSaveToStream,OnlyAddSheet,ActiveSheet

    procedure AddMultiSheet(SheetName: Text[20])
    begin
        SelectOrAddSheet(SheetName);
    end;

    procedure SelectSheetsNameByID(FileName: Text; IDP: Integer): Text[250]
    var
        TempNameValueBuffer: Record "Name/Value Buffer" temporary;
        SheetNames: DotNet SystemCollectionsArrayList;
        XlWrkBkReader: DotNet WorkbookReader;
        SheetName: Text[250];
        SelectedSheetName: Text;
        i: Integer;
        TotalSheetsNumberL: Integer;
    begin
        // Start 120846
        IF FileName = '' THEN
            ERROR(INC_002);

        XlWrkBkReader := XlWrkBkReader.Open(FileName);

        SelectedSheetName := '';
        SheetNames := SheetNames.ArrayList(XlWrkBkReader.SheetNames);
        TotalSheetsNumberL := SheetNames.Count;
        IF (IDP < 1) OR (IDP > TotalSheetsNumberL) THEN
            ERROR(INC_001);
        IF NOT ISNULL(SheetNames) THEN BEGIN
            FOR i := 0 TO TotalSheetsNumberL - 1 DO BEGIN
                SheetName := SheetNames.Item(i);
                IF SheetName <> '' THEN BEGIN
                    TempNameValueBuffer.INIT;
                    TempNameValueBuffer.ID := i;
                    TempNameValueBuffer.Name := FORMAT(i + 1);
                    TempNameValueBuffer.Value := SheetName;
                    TempNameValueBuffer.INSERT;
                END;
            END;
            IF NOT TempNameValueBuffer.ISEMPTY THEN
                IF TempNameValueBuffer.COUNT = 1 THEN
                    SelectedSheetName := TempNameValueBuffer.Value
                ELSE BEGIN
                    TempNameValueBuffer.FINDFIRST;
                    //IF PAGE.RUNMODAL(PAGE::"Name/Value Lookup",TempNameValueBuffer) = ACTION::LookupOK THEN
                    //  SelectedSheetName := TempNameValueBuffer.Value;
                    IF IDP <= 1 THEN
                        SelectedSheetName := TempNameValueBuffer.Value
                    ELSE BEGIN
                        TempNameValueBuffer.NEXT(IDP - 1);
                        SelectedSheetName := TempNameValueBuffer.Value;
                    END;
                END;
        END;

        QuitExcel;
        EXIT(SelectedSheetName);
        // Stop 120846
    end;

    procedure IsSheetExist(FileNameP: Text; SheetNameP: Text[250]): Boolean
    var
        TempNameValueBuffer: Record "Name/Value Buffer" temporary;
        SheetNames: DotNet SystemCollectionsArrayList;
        XlWrkBkReader: DotNet WorkbookReader;
        SheetName: Text;
        i: Integer;
    begin
        // Start 120846
        IF FileNameP = '' THEN
            ERROR(INC_002);

        XlWrkBkReader := XlWrkBkReader.Open(FileNameP);

        SheetNames := SheetNames.ArrayList(XlWrkBkReader.SheetNames);

        XlWrkBkReader.Close();
        QuitExcel;

        IF NOT ISNULL(SheetNames) THEN BEGIN
            FOR i := 0 TO SheetNames.Count - 1 DO BEGIN
                SheetName := SheetNames.Item(i);
                IF SheetName <> '' THEN BEGIN
                    TempNameValueBuffer.INIT;
                    TempNameValueBuffer.ID := i;
                    TempNameValueBuffer.Name := FORMAT(i + 1);
                    TempNameValueBuffer.Value := SheetName;
                    TempNameValueBuffer.INSERT;
                END;
            END;
            TempNameValueBuffer.RESET;
            TempNameValueBuffer.SETRANGE(Value, SheetNameP);
            EXIT(NOT TempNameValueBuffer.ISEMPTY);
        END ELSE BEGIN
            EXIT(FALSE);
        END;
        // Stop 120846
    end;

    procedure AddSheetAndOpenExcel(FileNameP: Text; SheetNameP: Text[250]; ReportHeaderP: Text; CompanyName2P: Text; UserID2P: Text)
    begin
        // Start 120846
        OnlyAddSheet(FileNameP, SheetNameP, ReportHeaderP, CompanyName2P, UserID2P);

        OpenExcel;
        GiveUserControl;
        // Stop 120846
    end;

    procedure CreateBookAndSaveToStream(SheetNameP: Text[250]; ReportHeaderP: Text; CompanyName2P: Text; UserID2P: Text; var ExcelOutStreamP: OutStream)
    var
        FileL: File;
        ExcelInStreamL: InStream;
    begin
        // Start 120846
        CreateBook('', SheetNameP);
        WriteSheet(ReportHeaderP, CompanyName2P, UserID2P);
        CloseBook;

        FileL.OPEN(FileNameServer);
        FileL.CREATEINSTREAM(ExcelInStreamL);
        COPYSTREAM(ExcelOutStreamP, ExcelInStreamL);
        FileL.CLOSE;
        // Stop 120846
    end;

    procedure OnlyAddSheet(FileNameP: Text; SheetNameP: Text[250]; ReportHeaderP: Text; CompanyName2P: Text; UserID2P: Text)
    var
        SheetNamesL: DotNet SystemCollectionsArrayList;
        XlWrkBkWriter: DotNet WorkbookWriter;
        XlWrkShtWriter: DotNet WorksheetWriter;
        SheetNameL: Text;
    begin
        // Start 120846
        IF FileNameP = '' THEN
            ERROR(INC_002);

        IF SheetNameP = '' THEN
            ERROR(INC_003);

        FileNameServer := FileNameP;

        XlWrkBkWriter := XlWrkBkWriter.Open(FileNameServer);
        IF XlWrkBkWriter.HasWorksheet(SheetNameP) THEN
            XlWrkBkWriter.DeleteWorksheet(SheetNameP);

        XlWrkShtWriter := XlWrkBkWriter.AddWorksheet(SheetNameP);
        ActiveSheetName := SheetNameP;

        //WriteSheet(ReportHeaderP,CompanyName2P,UserID2P);
        CloseBook;
        // Stop 120846

    end;

    procedure ActiveSheet(FileNameP: Text; SheetNameP: Text[250])
    var
        XlWrkBkWriter: DotNet WorkbookWriter;
        XlWrkShtWriter: DotNet WorksheetWriter;
    begin
        // Start 120846
        XlWrkShtWriter := XlWrkBkWriter.GetWorksheetByName(SheetNameP);
        IF SheetNameP <> '' THEN BEGIN
            XlWrkShtWriter.Name := SheetNameP;
            ActiveSheetName := SheetNameP;
        END
        // Stop 120846
    end;

    var
        FileNameServer: Text;
        ActiveSheetName: Text;
        INC_001: Label 'Excel sheet you select is not exist.';
        INC_002: Label 'You must enter a file name.';
        INC_003: Label 'You must enter an Excel worksheet name.';
}
