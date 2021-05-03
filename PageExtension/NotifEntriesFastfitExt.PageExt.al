pageextension 1044891 "Notif. Entries Fastfit Ext" extends "Notification Entries Fastfit"
{
    // +--------------------------------------------------------------+
    // | ?2015 ff. Begusch Software Systeme                          |
    // #3..13
    // 
    // +--------------------------------------------------------------+
    // | @ 2017 incadea Taiwan Limited                                |
    // +--------------------------------------------------------------+
    // | PURPOSE: MARS_TWN                                            |
    // |                                                              |
    // | REMARK :                                                     |
    // +--------------------------------------------------------------+
    // 
    // VERSION       ID          WHO    DATE        DESCRIPTION
    // TWN.01.02     RGS_TWN-611 AH     2017-05-22  Added one button to quick mark the entires.
    // +----------------------------------------------+
    // | Copyright (c) incadea                        |
    // +----------------------------------------------+
    // TFS          ID             WHO    DATE        DESCRIPTION
    // 112062       MARS_TWN-6446  GG     2018-02-26  Change translation for action "Select ALL"
    // 115415       MARS_TWN-6783  GG     2018-07-17  Change button "Mark All" perporty to show on home
    // 116996       MARS_TWN-6783  GG     2018-10-16  Add new action to on hold record which don't need to send
    layout
    {
        modify("Notification No.")
        {
            StyleExpr = StyleTextG;
        }
    }
    actions
    {
        addafter(Send)
        {
            action("On Hold")
            {
                Caption = 'On Hold';
                Image = Pause;
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    CurrPage.SETSELECTIONFILTER(NotificationSendingHeaderG);
                    OnHoldNotification(NotificationSendingHeaderG);
                end;
            }
            group(Action1000000023)
            {
                action("Mark ALL")
                {
                    Caption = 'Mark ALL';
                    Image = Delete;
                    Promoted = true;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        ErrorNotificationSendingHeaderL: Record "Notification Sending Header";
                    begin
                        //++INC.TWN-611.AH
                        //CurrPage.SETSELECTIONFILTER(recSMSEntries);
                        recSMSEntries.RESET;
                        recSMSEntries.SETRANGE(Type, recSMSEntries.Type::Ready);
                        IF recSMSEntries.FIND('-') THEN
                            REPEAT
                                ErrorNotificationSendingHeaderL.TRANSFERFIELDS(recSMSEntries);
                                ErrorNotificationSendingHeaderL."Notification No." := recSMSEntries."Notification No.";
                                ErrorNotificationSendingHeaderL.Type := ErrorNotificationSendingHeaderL.Type::Error;
                                ErrorNotificationSendingHeaderL."Error Message" := 'Segment Error';
                                IF ErrorNotificationSendingHeaderL.INSERT THEN
                                    recSMSEntries.DELETE;
                            UNTIL recSMSEntries.NEXT = 0;
                        EXIT;

                        //--INC.TWN-611.AH
                    end;
                }
            }
        }
    }

    var
        recSMSEntries: Record "Notification Sending Header";
        intCount: Integer;
        StyleTextG: Text;
        NotificationSendingHeaderG: Record "Notification Sending Header";

    //++TWN1.00.122187.QX
    procedure SetStyleText()
    begin
        StyleTextG := SetStyle();
    end;
    //--TWN1.00.122187.QX    
}

