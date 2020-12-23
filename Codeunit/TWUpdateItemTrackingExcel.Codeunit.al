codeunit 1044882 "TW Update Item Tracking Excel"
{

    // +--------------------------------------------------------------+
    // | @ 2019 incadea Taiwan Limited                                |
    // +--------------------------------------------------------------+
    // | PURPOSE: MARS_TWN                                            |
    // |                                                              |
    // | REMARK :                                                     |
    // +--------------------------------------------------------------+

    // VERSION       ID            WHO    DATE        DESCRIPTION
    // RGS_TWN-848   120846        GG     2019-10-31  New object    

    trigger OnRun()
    begin
        ProcessItemTrackingTable();
    end;

    procedure ImportItemTrackingCode(FilePathP: Text)
    var
        ExcelFileNameL: Text;
        SheetNameL: Text;
        LastStrL: Text;
    begin
        TempExcelBufferG.RESET;
        TempExcelBufferG.DELETEALL;

        ExcelFileNameL := FilePathP;
        IF ExcelFileNameL = '' THEN
            ExcelFileNameL := GetServerExcelFileName();
        SheetNameL := GetSheetNameByID(ExcelFileNameL, 2);
        ErrorFileNameG := '';
        ErrorFileNameG := FileMgtG.GetDirectoryName(ExcelFileNameL);
        LastStrL := COPYSTR(ErrorFileNameG, STRLEN(ErrorFileNameG), 1);
        IF LastStrL <> '\' THEN BEGIN
            ErrorFileNameG := ErrorFileNameG + '\' + C_INC_001 + FileMgtG.GetFileName(ExcelFileNameL);
            ;
        END ELSE
            ErrorFileNameG := ErrorFileNameG + C_INC_001 + FileMgtG.GetFileName(ExcelFileNameL);
        ReadSheet(ExcelFileNameL, SheetNameL);
        ProcessExcelSheet(TempExcelBufferG);

        IF TempErrorExcelBufferG.ISEMPTY THEN
            EXIT;

        OpenOrCreateExcelFile(TempErrorExcelBufferG, ErrorFileNameG, TENANTID);
    end;

    procedure InsertErrorBuffer(KeyP: Text; StatusP: Text; ErrorTextP: Text)
    begin
        ExportRowNoG += 1;

        TempErrorExcelBufferG.INIT;
        TempErrorExcelBufferG.VALIDATE("Row No.", ExportRowNoG);
        TempErrorExcelBufferG.VALIDATE("Column No.", 1);
        TempErrorExcelBufferG."Cell Value as Text" := COPYSTR(KeyP, 1, 250);
        TempErrorExcelBufferG.INSERT;
        TempErrorExcelBufferG.INIT;
        TempErrorExcelBufferG.VALIDATE("Row No.", ExportRowNoG);
        TempErrorExcelBufferG.VALIDATE("Column No.", 2);
        TempErrorExcelBufferG."Cell Value as Text" := COPYSTR(StatusP, 1, 250);
        TempErrorExcelBufferG.INSERT;
        TempErrorExcelBufferG.INIT;
        TempErrorExcelBufferG.VALIDATE("Row No.", ExportRowNoG);
        TempErrorExcelBufferG.VALIDATE("Column No.", 3);
        TempErrorExcelBufferG."Cell Value as Text" := COPYSTR(ErrorTextP, 1, 250);
        TempErrorExcelBufferG.INSERT;
    end;

    procedure InsertErrorBufferToMUT(KeyP: Text; IsErrorP: Boolean; MessageTextP: Text)
    var
        MUTEntryL: Record "Usage Tracking Entry";
        TrackingFunctionL: Record "Usage Tracking Function";
        CompanyInfoL: Record "Company Information";
        LogTypeL: Option Information,Warning,Error;
        ServiceCenterL: Record "Service Center";
        GeneralFunctionsL: Codeunit "General Functions";
        LastPrimaryKey: Integer;
    begin
        IF MUTEntryL.FINDLAST THEN
            LastPrimaryKey := MUTEntryL."Entry No."
        ELSE
            LastPrimaryKey := 0;

        WITH MUTEntryL DO BEGIN
            INIT;
            "Entry No." := LastPrimaryKey + 1;
            IF IsErrorP THEN
                "Log Type" := "Log Type"::Error
            ELSE
                "Log Type" := "Log Type"::Information;
            "Reason Code" := KeyP;
            "Tracking Function Name" := COPYSTR(MessageTextP, 1, 100);

            CalcDateTimeData(MUTEntryL);

            "User ID" := USERID;
            "Service Center Code" := GeneralFunctionsL.GetSCCode();
            IF ServiceCenterL.GET("Service Center Code") THEN
                "Service Center Name" := ServiceCenterL.Name;

            IF CompanyInfoL.GET THEN
                "Company ID" := CompanyInfoL.Name;
            "Company Name" := COMPANYNAME;


            "Tenant ID" := TenantId();
            INSERT(TRUE);
        END;
        COMMIT;
    end;

    local procedure CalcDateTimeData(var TempMUTEntryP: Record "Usage Tracking Entry" temporary)
    var
        MillisecondsL: Integer;
        HoursL: Integer;
        MinutesL: Integer;
        SecondsL: Integer;
        TimeSlotL: Time;
        TimeSlotEndL: Time;
        HoursMSL: Integer;
        HoursMSEndL: Integer;
        DateTimeL: DateTime;
        DateTimeEndL: DateTime;
        FullTimeSlotL: Text;
        LocalDateL: Date;
        LocalTimeL: Time;
    begin
        WITH TempMUTEntryP DO BEGIN
            LocalDateL := TODAY;
            LocalTimeL := TIME;

            // Converting local time to server time

            "Creation DateTime" := CREATEDATETIME(LocalDateL, LocalTimeL);
            "Creation Time" := DT2TIME("Creation DateTime");
            "Creation Date" := DT2DATE("Creation DateTime");

            // Filling general date data

            "Day of Creation Month" := DATE2DMY("Creation Date", 1);
            "Month of Creation Date" := DATE2DMY("Creation Date", 2);
            "Year of Creation Date" := DATE2DMY("Creation Date", 3);

            "Day of Creation Week" := DATE2DWY("Creation Date", 1);
            "Week of Creation Date" := DATE2DWY("Creation Date", 2);

            "Month/Year of Creation Date" := FORMAT("Month of Creation Date") + '/' + FORMAT("Year of Creation Date");

            // Calculating Time Slot

            MillisecondsL := LocalTimeL - 000000T;

            HoursL := MillisecondsL DIV 1000 DIV 60 DIV 60;

            HoursMSL := HoursL * 1000 * 60 * 60;
            TimeSlotL := 000000T;
            TimeSlotL += HoursMSL;

            HoursMSEndL := (HoursL + 1) * 1000 * 60 * 60;
            TimeSlotEndL := 000000T;
            TimeSlotEndL += HoursMSEndL;

            // Converting local time slot to server time slot

            DateTimeL := CREATEDATETIME(LocalDateL, TimeSlotL);
            DateTimeEndL := CREATEDATETIME(LocalDateL, TimeSlotEndL);

            TimeSlotL := DT2TIME(DateTimeL);
            TimeSlotEndL := DT2TIME(DateTimeEndL);

            FullTimeSlotL := FORMAT(TimeSlotL) + ' - ' + FORMAT(TimeSlotEndL);

            "Time Slot" := FullTimeSlotL;

        END;
    end;

    procedure GetServerExcelFileName(): Text
    var
        myInt: Integer;
    begin
        IF FileNameG <> '' THEN
            EXIT(FileNameG);

        EXIT('D:\DOT.xlsx');
    end;

    procedure GetSheetNameByID(FileNameP: Text; IDP: Integer): Text
    var
        ExcelBufferL: Record "Excel Buffer";
    begin
        EXIT(ExcelBufferL.SelectSheetsNameByID(FileNameP, IDP));
    end;

    local procedure GetTodayTimeString(): Text
    begin
        EXIT(GetTodayString() + GetTimeString());
    end;

    local procedure GetTodayString(): Text
    begin
        EXIT(FORMAT(TODAY, 0, '<Year4><Month,2><Day,2>'));
    end;

    local procedure GetTimeString(): Text
    begin
        EXIT(FORMAT(TIME, 0, '<Hours24><Minutes,2><Seconds,2>'));
    end;

    procedure ReadSheet(FileNameP: Text; SheetNameP: Text)
    begin
        TempExcelBufferG.OpenBook(FileNameP, SheetNameP);
        TempExcelBufferG.ReadSheet();
        TempExcelBufferG.CloseBook();
    end;

    procedure ProcessExcelSheet(var TempExcelBufferP: Record "Excel Buffer" temporary)
    var
        UpdateItemTrackingCodeL: Codeunit "TW Update Item Tracking Code";
        TempItemL: Record Item temporary;
    begin
        CLEAR(UpdateItemTrackingCodeL);
        UpdateItemTrackingCodeL.SetAction(1);
        UpdateItemTrackingCodeL.SetExcelBuffer(TempExcelBufferP);
        IF UpdateItemTrackingCodeL.RUN THEN BEGIN
            UpdateItemTrackingCodeL.GetItemBuffer(TempItemL);
        END ELSE BEGIN
            InsertErrorBuffer('', C_INC_004, C_INC_002 + GETLASTERRORTEXT);
            EXIT;
        END;

        TempItemL.RESET;
        IF TempItemL.FINDFIRST THEN
            REPEAT
                CLEARLASTERROR;
                CLEAR(UpdateItemTrackingCodeL);
                UpdateItemTrackingCodeL.SetAction(2);
                UpdateItemTrackingCodeL.SetExcelBuffer(TempExcelBufferP);
                UpdateItemTrackingCodeL.SetSingleItemBuffer(TempItemL);
                IF NOT UpdateItemTrackingCodeL.RUN THEN BEGIN
                    InsertErrorBuffer(TempItemL."No.", C_INC_004, GETLASTERRORTEXT);
                END ELSE
                    InsertErrorBuffer(TempItemL."No.", C_INC_003, '');
            UNTIL TempItemL.NEXT = 0;
    end;

    procedure ReadExcelToTable(var FilePathP: Text)
    var
        IsSuccessL: Boolean;
    begin
        //The function is only used in master tenant
        IsSuccessL := ReadExcelTenantSheetToTable(FilePathP);
        IF NOT IsSuccessL THEN
            EXIT;
        IsSuccessL := ReadExcelItemSheetToTable(FilePathP);
    end;

    procedure ReadExcelTenantSheetToTable(var FilePathP: Text): Boolean
    var
        UpdateItemTrackingCodeL: Codeunit "TW Update Item Tracking Code";
        TempItemL: Record "Item" temporary;
        ExcelFileNameL: Text;
        SheetNameL: Text;
        IsSuccessL: Boolean;
    begin
        TempExcelBufferG.RESET;
        TempExcelBufferG.DELETEALL;

        ExcelFileNameL := FilePathP;
        SheetNameL := GetSheetNameByID(ExcelFileNameL, 1);
        ReadSheet(ExcelFileNameL, SheetNameL);

        IF TempExcelBufferG.ISEMPTY THEN
            EXIT;

        CLEAR(UpdateItemTrackingCodeL);
        CLEARLASTERROR;
        UpdateItemTrackingCodeL.SetAction(3);
        UpdateItemTrackingCodeL.SetExcelBuffer(TempExcelBufferG);
        IF UpdateItemTrackingCodeL.RUN THEN BEGIN
            IsSuccessL := TRUE;
        END ELSE BEGIN
            InsertErrorBufferToMUT(C_INC_006, TRUE, C_INC_002 + GETLASTERRORTEXT);
            IsSuccessL := FALSE;
        END;

        IF (GETLASTERRORTEXT <> '') THEN
            MESSAGE(STRSUBSTNO(C_INC_008, GETLASTERRORTEXT));

        EXIT(IsSuccessL);
    end;

    procedure ReadExcelItemSheetToTable(var FilePathP: Text): Boolean
    var
        UpdateItemTrackingCodeL: Codeunit "TW Update Item Tracking Code";
        TempItemL: Record Item temporary;
        ExcelFileNameL: Text;
        SheetNameL: Text;
        IsSuccessL: Boolean;
    begin
        //The function is only used in master tenant
        TempExcelBufferG.RESET;
        TempExcelBufferG.DELETEALL;

        ExcelFileNameL := FilePathP;
        SheetNameL := GetSheetNameByID(ExcelFileNameL, 2);
        ReadSheet(ExcelFileNameL, SheetNameL);

        IF TempExcelBufferG.ISEMPTY THEN
            EXIT;

        CLEAR(UpdateItemTrackingCodeL);
        CLEARLASTERROR;
        UpdateItemTrackingCodeL.SetAction(4);
        UpdateItemTrackingCodeL.SetExcelBuffer(TempExcelBufferG);
        IF UpdateItemTrackingCodeL.RUN THEN BEGIN
            IsSuccessL := TRUE;
        END ELSE BEGIN
            InsertErrorBufferToMUT(C_INC_006, TRUE, C_INC_002 + GETLASTERRORTEXT);
            IsSuccessL := FALSE;
        END;

        IF (GETLASTERRORTEXT <> '') THEN
            MESSAGE(STRSUBSTNO(C_INC_008, GETLASTERRORTEXT));

        EXIT(IsSuccessL)
    end;

    procedure ProcessItemTrackingTable()
    var
        ItemDOTEntryL: Record "Item DOT Entry";
        ItemDOTEntrySetupL: Record "Item DOT Entry";
        UpdateItemTrackingCodeL: Codeunit "TW Update Item Tracking Code";
        StartDateL: Date;
        EndDateL: Date;
    begin
        IF IsTenantInScope THEN BEGIN
            IF ItemDOTEntrySetupL.GET(ItemDOTEntrySetupL.Type::Setup, '', '', 0D) THEN BEGIN
                IF ItemDOTEntrySetupL."Last Update Date" = 0D THEN
                    StartDateL := CALCDATE('<-1D>', TODAY)
                ELSE
                    StartDateL := ItemDOTEntrySetupL."Last Update Date" - 1;
            END ELSE BEGIN
                ItemDOTEntrySetupL.INIT;
                ItemDOTEntrySetupL.Type := ItemDOTEntrySetupL.Type::Setup;
                ItemDOTEntrySetupL."Last Update Date" := CALCDATE('<-1D>', TODAY);
                ItemDOTEntrySetupL.INSERT(TRUE);
                StartDateL := ItemDOTEntrySetupL."Last Update Date";
            END;
            EndDateL := TODAY;
            COMMIT;

            ItemDOTEntryL.RESET;
            ItemDOTEntryL.SETRANGE(Type, ItemDOTEntryL.Type::Item);
            ItemDOTEntryL.SETFILTER("Item No.", '<>%1', '');
            ItemDOTEntryL.SETRANGE("Upload Date", StartDateL, EndDateL);
            IF ItemDOTEntryL.FINDFIRST THEN
                REPEAT
                    CLEARLASTERROR;
                    CLEAR(UpdateItemTrackingCodeL);
                    UpdateItemTrackingCodeL.SetAction(5);
                    UpdateItemTrackingCodeL.SetItemTrackingBuffer(ItemDOTEntryL);
                    IF NOT UpdateItemTrackingCodeL.RUN THEN BEGIN
                        InsertErrorBufferToMUT(C_INC_006, TRUE, STRSUBSTNO(C_INC_007, ItemDOTEntryL."Item No.", ItemDOTEntryL."Upload Date", GETLASTERRORTEXT));
                    END ELSE
                        InsertErrorBufferToMUT(C_INC_006, FALSE, STRSUBSTNO(C_INC_005, ItemDOTEntryL."Item No.", ItemDOTEntryL."Upload Date"));
                UNTIL ItemDOTEntryL.NEXT = 0;

            IF ItemDOTEntrySetupL.GET(ItemDOTEntrySetupL.Type::Setup, '', 0D) THEN BEGIN
                ItemDOTEntrySetupL."Last Update Date" := TODAY;
                ItemDOTEntrySetupL.MODIFY;
            END;
        END;

        UpdateTenant;
    end;

    local procedure IsTenantInScope(): Boolean
    var
        ItemDOTEntryL: Record "Item DOT Entry";
    begin
        ItemDOTEntryL.RESET;
        ItemDOTEntryL.SETRANGE(Type, ItemDOTEntryL.Type::Tenant);
        ItemDOTEntryL.SETRANGE(Tenant, TENANTID);
        ItemDOTEntryL.SETRANGE(Active, TRUE);
        EXIT(NOT ItemDOTEntryL.ISEMPTY);
    end;

    local procedure UpdateTenant()
    var
        ItemDOTEntryL: Record "Item DOT Entry";
    begin
        ItemDOTEntryL.RESET;
        ItemDOTEntryL.SETRANGE(Type, ItemDOTEntryL.Type::Tenant);
        ItemDOTEntryL.MODIFYALL(Active, FALSE);
    end;

    procedure OpenOrCreateExcelFile(var TempExcelBufferP: Record "Excel Buffer"; FileNameP: Text; SheetNameP: Text)
    begin
        IF FileMgtG.ServerFileExists(FileNameP) THEN BEGIN
            IF (NOT TempExcelBufferP.IsSheetExist(FileNameP, SheetNameP)) THEN BEGIN
                TempExcelBufferP.OnlyAddSheet(FileNameP, SheetNameP, '', COMPANYNAME, USERID);
            END;
            TempExcelBufferP.UpdateBook(FileNameP, SheetNameP);
            TempExcelBufferP.WriteSheet(SheetNameP, COMPANYNAME, USERID);
            TempExcelBufferP.CloseBook;
            TempExcelBufferP.GiveUserControl;
        END ELSE BEGIN
            TempExcelBufferP.CreateBook(FileNameP, SheetNameP);
            TempExcelBufferP.WriteSheet(SheetNameP, COMPANYNAME, USERID);
            TempExcelBufferP.CloseBook;
            TempExcelBufferP.GiveUserControl;
        END;
    end;

    procedure SetFileName(FileNameP: Text)
    begin
        FileNameG := FileNameP;
    end;

    var
        TempExcelBufferG: Record "Excel Buffer" temporary;
        TempErrorExcelBufferG: Record "Excel Buffer" temporary;
        FileMgtG: Codeunit "File Management";
        FileNameG: Text;
        ErrorFileNameG: Text;
        ExportRowNoG: Integer;
        C_INC_001: Label 'LOG';
        C_INC_002: Label 'Get Item list to import failed.';
        C_INC_003: Label 'Success';
        C_INC_004: Label 'Failed';
        C_INC_005: Label 'Update Item %1 %2 Success';
        C_INC_006: Label 'Item Tracking Code';
        C_INC_007: Label 'Update Item %1 %2 Failed: %3';
        C_INC_008: Label 'Import excel failed: %1';
}
