codeunit 50005 "Schedule Report"
{
    // +--------------------------------------------------------------
    // | ?2017 Incadea China Software System                          |
    // +--------------------------------------------------------------+
    // | PURPOSE: Local Customization                                 |
    // |                                                              |
    // | REMARK :                                                     |
    // +--------------------------------------------------------------+
    // VERSION     ID                  WHO    DATE        DESCRIPTION
    // TWN.01.00   RGS_TWN-756         QX     2017-11-21  INITIALIZE
    // 119387      RGS_TWN-839         WP     2019-05-08  Add function GetParameter and logic


    trigger OnRun()
    begin
    end;

    [Scope('OnPrem')]
    procedure GetCompanyTenant(FileNameP: Text)
    var
        OutSL: OutStream;
        TempFileL: File;
    begin
        TempFileL.WRITEMODE(TRUE);
        TempFileL.OPEN(FileNameP);
        TempFileL.CREATEOUTSTREAM(OutSL);

        XMLPORT.EXPORT(XMLPORT::"Replication Company", OutSL);
        TempFileL.CLOSE;
    end;

    [Scope('OnPrem')]
    procedure PrintReport(ReportNumberP: Text)
    var
        SendNotificationsL: Report "Send Notifications";
        ReportIDL: Integer;
    begin
        // Start 119387
        EVALUATE(ReportIDL, GetParameter(ReportNumberP, 1));
        CASE ReportIDL OF
            REPORT::"Send Notifications":
                BEGIN
                    //++TWN1.00.122187.QX
                    // SendNotificationsL.SetServCenterLimit(GetParameter(ReportNumberP, 2));
                    SendNotificationsL.SetServiceCenterFilter(GetParameter(ReportNumberP, 2));
                    //--TWN1.00.122187.QX                    
                    SendNotificationsL.USEREQUESTPAGE := FALSE;
                    SendNotificationsL.RUNMODAL;
                END
            ELSE
                // Stop  119387
                REPORT.RUNMODAL(ReportIDL, FALSE);
        // Start 119387
        END;
        // Stop  119387
    end;

    local procedure GetParameter(ArgTxtP: Text; IndexP: Integer): Text
    var
        TempTxtL: Text;
        PosL: Integer;
    begin
        // Start 119387
        TempTxtL := ArgTxtP;
        REPEAT
            IndexP -= 1;
            PosL := STRPOS(TempTxtL, ';');
            IF IndexP > 0 THEN BEGIN
                IF PosL > 0 THEN
                    TempTxtL := COPYSTR(TempTxtL, PosL + 1)
                ELSE
                    TempTxtL := '';
            END;
        UNTIL (TempTxtL = '') OR (IndexP = 0);

        IF TempTxtL > '' THEN
            IF PosL > 0 THEN
                EXIT(COPYSTR(TempTxtL, 1, PosL - 1))
            ELSE
                EXIT(TempTxtL);
        // Stop  119387
    end;
}

