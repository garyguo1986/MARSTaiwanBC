page 50023 "Notification List Edit"
{
    // +--------------------------------------------------------------+
    // | @ 2017 incadea Taiwan Limited                                |
    // +--------------------------------------------------------------+
    // | PURPOSE: MARS_TWN                                            |
    // |                                                              |
    // | REMARK :                                                     |
    // +--------------------------------------------------------------+
    // 
    // VERSION       ID       WHO    DATE        DESCRIPTION
    // RGS_TWN-560            AH     2017-05-24  INITIAL RELEASE
    // 
    // 
    // +----------------------------------------------+
    // | Copyright (c) incadea China                  |
    // +----------------------------------------------+
    // TFS          ID             WHO    DATE        DESCRIPTION
    // 116996       MARS_TWN-6783  GG     2018-10-16  Add new action to on hold record which don't need to send

    Caption = 'Notification List Edit';
    CardPageID = "Notification Card";
    PageType = List;
    SourceTable = "Notification Sending Header";
    SourceTableView = WHERE(Type = CONST("In Progress"));
    UsageCategory = Tasks;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                FreezeColumn = "User ID";
                field("Notification No."; "Notification No.")
                {
                    Caption = 'Notification No.';
                    Editable = false;
                    StyleExpr = StyleTextG;
                }
                field("Notif. Sent"; "Notif. Sent")
                {
                    Caption = 'Notification sent';
                    Editable = NotifSentEditG;
                }
                field("Notif. Date Sent"; "Notif. Date Sent")
                {
                    Caption = 'Notification Date Sent';
                    Editable = false;
                }
                field("Notif. Time Sent"; "Notif. Time Sent")
                {
                    Caption = 'Notification Time Sent';
                    Editable = false;
                }
                field("Service Center"; "Service Center")
                {
                    Caption = 'Service Center';
                    Editable = false;
                }
                field("User ID"; "User ID")
                {
                    Caption = 'User ID';
                    Editable = false;
                }
                field("Contact No."; "Contact No.")
                {
                    Caption = 'Contact No.';
                    Editable = false;
                }
                field("Contact Name"; "Contact Name")
                {
                    Caption = 'Name';
                    Editable = false;
                }
                field("Contact E-Mail"; "Contact E-Mail")
                {
                    Caption = 'E-Mail';
                    Editable = false;
                }
                field("Contact Mobile Phone No."; "Contact Mobile Phone No.")
                {
                    Caption = 'Mobile Phone No.';
                    Editable = false;
                }
                field("Vehicle No."; "Vehicle No.")
                {
                    Caption = 'Vehicle No.';
                    Editable = false;
                }
                field("Vehicle Licence-Plate No."; "Vehicle Licence-Plate No.")
                {
                    Caption = 'Licence-Plate No.';
                    Editable = false;
                }
                field("Vehicle manufacturer"; "Vehicle manufacturer")
                {
                    Caption = 'Manufacturer';
                    Editable = false;
                }
                field("Vehicle Model"; "Vehicle Model")
                {
                    Caption = 'Model';
                    Editable = false;
                }
                field("Vehicle Variant"; "Vehicle Variant")
                {
                    Caption = 'Variant';
                    Editable = false;
                }
                field("Notification Type"; "Notification Type")
                {
                    Caption = 'Notification Type';
                    Editable = false;
                    OptionCaption = ' ,E-Mail,SMS';
                }
            }
        }
        area(factboxes)
        {
            part(NotificationHeader; "Notification Header Factbox")
            {
                Editable = false;
                SubPageLink = "Notification No." = FIELD("Notification No."),
                              Type = FIELD(Type);
            }
            part(NotificationLine; "Notification Lines Factbox")
            {
                Editable = false;
                SubPageLink = Type = FIELD(Type),
                              "Notification No." = FIELD("Notification No.");
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("Contact History")
            {
                Caption = 'Contact History';
                action("Archived Notifications")
                {
                    Caption = 'Archived Notifications';
                    Image = ContactPerson;
                    RunObject = Page "Archived Notifications";
                    RunPageLink = "Contact No." = FIELD("Contact No.");
                }
                action("Notification Entries")
                {
                    Caption = 'Notification Entries';
                    Image = ContactReference;
                    RunObject = Page 1044465;
                    RunPageLink = "Contact No." = FIELD("Contact No.");
                }
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
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        NotifSentEditG := ("Notif. Date Sent" = 0D) AND ("Notif. Time Sent" = 0T);

        //++MARS_TWN-6783.GG
        StyleTextG := SetStyle;
        //--MARS_TWN-6783.GG
    end;

    trigger OnOpenPage()
    begin

        FILTERGROUP(2);
        SETFILTER("Service Center", ApplicationMgmt.GetSCVisibilityFilter(1));
        FILTERGROUP(0);
        //++MARS_TWN-6783.GG
        SETRANGE("Hold Status", "Hold Status"::" ");
        //--MARS_TWN-6783.GG
    end;

    var
        ApplicationMgmt: Codeunit "Service Center Management";
        [InDataSet]
        NotifSentEditG: Boolean;
        StyleTextG: Text;
        NotificationSendingHeaderG: Record "Notification Sending Header";
}
