codeunit 1044861 "Tobit Fax Interface"
{
    // +--------------------------------------------------------------+
    // | @ 2017 incadea Taiwan Limited                                |
    // +--------------------------------------------------------------+
    // | PURPOSE: MARS_TWN                                            |
    // |                                                              |
    // +--------------------------------------------------------------+
    // 
    // VERSION       ID          WHO    DATE        DESCRIPTION
    // TWN.01.03     RGW_TWN-350 NN     2017-06-04  Upgrade from r3


    trigger OnRun()
    begin
    end;

    var
        GeneralFunctions: Codeunit "General Functions";
        C_BSS_ERR001: Label 'Please enter a valid Fax Number!';

    [Scope('OnPrem')]
    procedure SetFaxPrinter(ReportID: Integer; FaxNo: Text[30]; DocumentNo: Code[20])
    var
        PrinterSelection: Record "Printer Selection";
        FaxTempPrinterSelection: Record "Fax History";
        ServiceCenter: Code[10];
        TireUserSetup: Record "Fastfit Setup - User";
    begin
        ServiceCenter := GeneralFunctions.GetSCCode;

        TireUserSetup.GET(USERID);
        IF TireUserSetup."Fax Printer Name" = '' THEN
            EXIT;

        FaxTempPrinterSelection.INIT;
        FaxTempPrinterSelection."Report ID" := ReportID;
        FaxTempPrinterSelection."Service Center" := ServiceCenter;
        FaxTempPrinterSelection."User ID" := USERID;
        FaxTempPrinterSelection."Fax No." := FaxNo;
        FaxTempPrinterSelection."Document No." := DocumentNo;

        IF PrinterSelection.GET(ServiceCenter, USERID, ReportID) THEN BEGIN
            FaxTempPrinterSelection."Original Printer Name" := PrinterSelection."Printer Name";
            FaxTempPrinterSelection."Restore Entry After Fax" := TRUE;
            IF FaxTempPrinterSelection.INSERT(TRUE) THEN;
            PrinterSelection."Appl. To Fax History Entry" := FaxTempPrinterSelection."Entry No.";
            PrinterSelection."Printer Name" := TireUserSetup."Fax Printer Name";
            PrinterSelection.MODIFY;
        END
        ELSE BEGIN
            IF FaxTempPrinterSelection.INSERT(TRUE) THEN;
            CLEAR(PrinterSelection);
            PrinterSelection.INIT;
            PrinterSelection."Report ID" := ReportID;
            PrinterSelection."Service Center" := ServiceCenter;
            PrinterSelection."User ID" := USERID;
            PrinterSelection."Printer Name" := TireUserSetup."Fax Printer Name";
            PrinterSelection."Appl. To Fax History Entry" := FaxTempPrinterSelection."Entry No.";
            IF PrinterSelection.INSERT THEN;
        END;

        COMMIT;
    end;

    [Scope('OnPrem')]
    procedure ResetPrinterLine(ReportID: Integer)
    var
        PrinterSelection: Record "Printer Selection";
        FaxTempPrinterSelection: Record "Fax History";
        ServiceCenter: Code[10];
        TireUserSetup: Record "Fastfit Setup - User";
    begin
        //---------------------------------------------------------------------//
        // * Just delete temporary created printer selection line              //
        //   OR                                                                //
        // * Restore printer selection line which was removed temporary due    //
        //   the fax sending with the SetFaxPrinter function                   //
        //---------------------------------------------------------------------//
        ServiceCenter := GeneralFunctions.GetSCCode;

        PrinterSelection.SETRANGE("Service Center", ServiceCenter);
        PrinterSelection.SETRANGE("User ID", USERID);
        IF ReportID <> 0 THEN
            PrinterSelection.SETRANGE("Report ID", ReportID);
        IF PrinterSelection.FIND('-') THEN BEGIN
            REPEAT
                IF (PrinterSelection."Appl. To Fax History Entry" <> 0) THEN BEGIN
                    IF FaxTempPrinterSelection.GET(PrinterSelection."Appl. To Fax History Entry") THEN BEGIN
                        IF FaxTempPrinterSelection."Restore Entry After Fax" THEN BEGIN
                            PrinterSelection."Appl. To Fax History Entry" := 0;
                            PrinterSelection."Printer Name" := FaxTempPrinterSelection."Original Printer Name";
                            PrinterSelection.MODIFY;
                        END ELSE
                            PrinterSelection.DELETE;
                        TireUserSetup.GET(USERID);
                        FaxTempPrinterSelection."Fax Printer Name" := TireUserSetup."Fax Printer Name";
                        FaxTempPrinterSelection.Finished := TRUE;
                        FaxTempPrinterSelection.MODIFY(TRUE);
                    END;
                END;
            UNTIL PrinterSelection.NEXT = 0;

            COMMIT;
        END;
    end;

    [Scope('OnPrem')]
    procedure ValidateFaxNo(FaxNo: Text[30]; DisplayError: Boolean): Boolean
    begin
        IF FaxNo = '' THEN BEGIN
            IF DisplayError THEN
                ERROR(C_BSS_ERR001);
            EXIT(FALSE);
        END;

        EXIT(TRUE);
    end;

    [Scope('OnPrem')]
    procedure QueryFaxNo(DefaultFaxNo: Text[30]): Text[30]
    var
        GetFaxNo: Page "Get Fax No.";
    begin
        GetFaxNo.ShowPrintButton(FALSE);
        GetFaxNo.SetFaxNo(DefaultFaxNo);
        IF GetFaxNo.RUNMODAL = ACTION::OK THEN
            EXIT(GetFaxNo.GetFaxNo)
        ELSE
            EXIT('');
    end;
}

