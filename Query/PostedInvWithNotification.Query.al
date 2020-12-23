query 1044861 "Posted Inv. With Notification"
{
    // +----------------------------------------------+
    // | Copyright (c) incadea China                  |
    // +----------------------------------------------+
    // TFS          ID             WHO    DATE        DESCRIPTION
    // 117247       MARS_TWN-6901  GG     2018-11-05  New object to calculate posted sales invoice have notification sent

    Caption = 'Posted Inv. With Notification';

    elements
    {
        dataitem(Sales_Invoice_Header; "Sales Invoice Header")
        {
            SqlJoinType = InnerJoin;
            filter(Sell_to_Contact_No; "Sell-to Contact No.")
            {
            }
            filter(Service_Center; "Service Center")
            {
            }
            filter(Posting_Date; "Posting Date")
            {
            }
            column(No; "No.")
            {
            }
            dataitem(Archived_Notification_Header; "Archived Notification Header")
            {
                DataItemLink = "Contact No." = Sales_Invoice_Header."Sell-to Contact No.";
                SqlJoinType = InnerJoin;
                filter(Notif_Date_Sent; "Notif. Date Sent")
                {
                }
                filter(Notification_Source; "Notification Source")
                {
                    ColumnFilter = Notification_Source = FILTER("Service Reminder" | Segment);
                }
                column(Contact_No; "Contact No.")
                {
                }
                column(Count_)
                {
                    Method = Count;
                }
            }
        }
    }
}

