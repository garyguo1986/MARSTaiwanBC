report 1044882 "Service Reminder2"
{
    //The report is copied from report 1044534 "Service Reminder"
    //     +--------------------------------------------------------------
    // | ?2017 Incadea China Software System                          |
    // +--------------------------------------------------------------+
    // | PURPOSE: Local Customization                                 |
    // |                                                              |
    // | REMARK :                                                     |
    // +--------------------------------------------------------------+
    // VERSION     ID                  WHO    DATE        DESCRIPTION
    // TWN.01.00   RGS_TWN-756         QX     2017-11-22  Printing Report from Powershell
    // TWN.01.01   MARS_TWN-9068       GG     2021-07-05  Copy the object from 1044534 and add local code

    Caption = 'Service Reminder2';
    ProcessingOnly = true;
    ApplicationArea = Basic, Suite;
    UsageCategory = Tasks;

    dataset
    {
        dataitem("Service Due Entry"; "Service Due Entry")
        {
            DataItemTableView = SORTING("Entry No.") ORDER(Ascending) WHERE("Notification Created" = FILTER(false), "Bill-to Contact No." = FILTER(<> ''));

            trigger OnAfterGetRecord()
            begin

                NotificationFunctions.DC_ServiceReminder("Service Due Entry", DateToSend, TimeToSend);

                if GuiAllowed then
                    ProgressBar.UpdateProgressBar;
            end;

            trigger OnPostDataItem()
            begin
                if GuiAllowed then
                    ProgressBar.CloseProgressBar;
            end;

            trigger OnPreDataItem()
            begin

                SetRange("Notification Send Date", StartDate, EndDate);

                if GuiAllowed then
                    ProgressBar.OpenProgressBar(Count, TableCaption, false);
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
                    field(StartDate; StartDate)
                    {
                        Caption = 'Start Date';
                    }
                    field(EndDate; EndDate)
                    {
                        Caption = 'End Date';
                    }
                    field(DateToSend; DateToSend)
                    {
                        Caption = 'Date to send';
                    }
                    field(TimeToSend; TimeToSend)
                    {
                        Caption = 'Time to send';
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        var
            MARSNotifSetupL: Record "Fastfit Setup - Notification";
        begin

            if MARSNotifSetupL.Get() then begin
                TimeToSend := MARSNotifSetupL."ServRem Time To Send";
                StartDate := CalcDate(MARSNotifSetupL."ServRem Starting Date Formula", Today);
                EndDate := CalcDate(MARSNotifSetupL."ServRem Ending Date Formula", Today);
            end;
        end;
    }

    labels
    {
    }

    trigger OnPostReport()
    begin

        //++BSS.TFS_14781.CM
        OnAfterPostReport();
        //--BSS.TFS_14781.CM
    end;

    trigger OnPreReport()
    var
        MARSNotifSetupL: Record "Fastfit Setup - Notification";
        LocalTodayL: Date;
    begin
        //++RGS_TWN-756.QX
        IF CURRENTCLIENTTYPE = CLIENTTYPE::Management THEN BEGIN
            LocalTodayL := GetToday;
            IF MARSNotifSetupL.GET() THEN BEGIN
                DateToSend := LocalTodayL;
                TimeToSend := MARSNotifSetupL."ServRem Time To Send";
                StartDate := CALCDATE(MARSNotifSetupL."ServRem Starting Date Formula", LocalTodayL);
                EndDate := CALCDATE(MARSNotifSetupL."ServRem Ending Date Formula", LocalTodayL);
            END;
        END;
        //--RGS_TWN-756.QX

        if (StartDate = 0D) or (EndDate = 0D) then
            Error(C_BSS_ERR001);
    end;

    var
        StartDate: Date;
        EndDate: Date;
        DateToSend: Date;
        TimeToSend: Time;
        C_BSS_ERR001: Label 'Please make sure both Start Date and End Date are filled!';
        NotificationFunctions: Codeunit "Notification Functions";
        ProgressBar: Codeunit "Progress Bar";

    local procedure GetToday(): Date
    var
        currDateTimeL: DateTime;
        timezoneInfoL: DotNet SystemTimeZoneInfo;
    begin
        timezoneInfoL := timezoneInfoL.Local();
        currDateTimeL := CURRENTDATETIME;
        currDateTimeL := currDateTimeL + timezoneInfoL.BaseUtcOffset;
        EXIT(DT2DATE(currDateTimeL));
    end;

    local procedure __EVENTS__()
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterPostReport()
    begin
    end;
}

