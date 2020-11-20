tableextension 1044860 tableextension1044860 extends "Notification Sending Header"
{
    // #1..23
    // 
    // +----------------------------------------------+
    // | Copyright (c) incadea China                  |
    // +----------------------------------------------+
    // VERSION       ID            WHO    DATE        DESCRIPTION
    // MARS_TWN-6783 116996        GG     2018-10-16  Add new field "Hold Status"
    // RGS_AGL-3620  121528        GG     2020-04-08  Add new field "Type ID" "Type Value"
    fields
    {
        field(1044861; "Hold Status"; Option)
        {
            Caption = 'Hold Status';
            OptionCaption = ' ,On Hold';
            OptionMembers = " ","On Hold";
        }
        //++TWN1.00.122187.QX
        // field(1044862; "Type ID"; Integer)
        // {
        //     Caption = 'Type ID';
        //     Description = '121528';
        //     TableRelation = "CRM Type Setup"."Type ID";
        // }
        // field(1044863; "Type Value"; Text[50])
        // {
        //     FieldClass = FlowField;
        //     CalcFormula = Lookup("CRM Type Setup"."Type Value" WHERE("Type ID" = FIELD("Type ID")));
        //     Caption = 'Type Value';
        //     Description = '121528';
        //     Editable = false;
        // }
        // field(1044864; "Appointment Date"; Date)
        // {
        //     Caption = 'Appointment Date';
        //     Description = '121528';
        // }
        // field(1044865; "Appointment Time"; Time)
        // {
        //     Caption = 'Appointment Time';
        //     Description = '121528';
        //--TWN1.00.122187.QX        
    }


    local procedure "---Incadea China---"()
    begin
    end;

    procedure OnHoldNotification(var NotificationSendingHeaderP: Record "Notification Sending Header")
    begin
        IF (NOT CONFIRM(C_INC_TXT001)) THEN
            EXIT;

        OnHoldNotificationEntry(NotificationSendingHeaderP);
    end;

    local procedure OnHoldNotificationEntry(var NotificationSendingHeaderP: Record "Notification Sending Header")
    begin
        IF NotificationSendingHeaderP.FINDFIRST THEN
            REPEAT
                NotificationSendingHeaderP."Hold Status" := NotificationSendingHeaderP."Hold Status"::"On Hold";
                NotificationSendingHeaderP.MODIFY(TRUE);
            UNTIL NotificationSendingHeaderP.NEXT = 0;
    end;

    procedure ResetNotification(var NotificationSendingHeaderP: Record "Notification Sending Header")
    begin
        IF (NOT CONFIRM(C_INC_TXT002)) THEN
            EXIT;

        ResetNotificationEntry(NotificationSendingHeaderP);
    end;

    procedure ResetNotificationEntry(var NotificationSendingHeaderP: Record "Notification Sending Header")
    begin
        IF NotificationSendingHeaderP.FINDFIRST THEN
            REPEAT
                NotificationSendingHeaderP."Hold Status" := NotificationSendingHeaderP."Hold Status"::" ";
                NotificationSendingHeaderP.MODIFY(TRUE);
            UNTIL NotificationSendingHeaderP.NEXT = 0;
    end;

    procedure SetStyle(): Text
    begin
        IF "Hold Status" = "Hold Status"::"On Hold" THEN
            EXIT('Attention');

        EXIT('');
    end;

    var
        C_INC_TXT001: Label 'the record will not send anymore.Do you want on hold the record?';
        C_INC_TXT002: Label 'the record will be send again.Do you want to reset the record hold status?';
}
