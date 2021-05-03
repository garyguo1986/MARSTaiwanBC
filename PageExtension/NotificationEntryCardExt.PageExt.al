pageextension 1044890 "Notification Entry Card Ext" extends "Notification Entry Card"
{
    // +--------------------------------------------------------------+
    // | ?2015 ff. Begusch Software Systeme                          |
    // #3..14
    // 
    // +----------------------------------------------+
    // | Copyright (c) incadea China                  |
    // +----------------------------------------------+
    // TFS          ID             WHO    DATE        DESCRIPTION
    // 116996       MARS_TWN-6783  GG     2018-10-16  Add new action to on hold record which don't need to send
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
                    //++MARS_TWN-6783.GG
                    NotificationSendingHeaderG.RESET;
                    NotificationSendingHeaderG.SETRANGE(Type, Type);
                    NotificationSendingHeaderG.SETRANGE("Notification No.", "Notification No.");
                    OnHoldNotification(NotificationSendingHeaderG);
                    //--MARS_TWN-6783.GG
                end;
            }
        }
    }

    var
        NotificationSendingHeaderG: Record "Notification Sending Header";
}

