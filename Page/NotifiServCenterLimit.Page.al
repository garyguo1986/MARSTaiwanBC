page 1044879 "Notifi. Serv. Center Limit"
{
    // +--------------------------------------------------------------
    // | ?2019 Incadea China Software System                          |
    // +--------------------------------------------------------------+
    // | PURPOSE: Local Customization                                 |
    // |                                                              |
    // | REMARK :                                                     |
    // +--------------------------------------------------------------+
    // VERSION     ID                  WHO    DATE        DESCRIPTION
    // 119387      RGS_TWN-839         WP     2019-05-08  Create by
    Caption = 'Notifi. Serv. Center Limit';
    PageType = Document;
    InsertAllowed = false;
    DeleteAllowed = false;
    SourceTable = "Replication Company Old";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field(Name; Rec.Name)
                {
                    ToolTip = 'Specifies the value of the Name field';
                    ApplicationArea = All;
                }
                field("Tenant ID"; Rec."Tenant ID")
                {
                    ToolTip = 'Specifies the value of the Tenant ID field';
                    ApplicationArea = All;
                }
                field("Database Name"; Rec."Database Name")
                {
                    ToolTip = 'Specifies the value of the Database Name field';
                    ApplicationArea = All;
                }
                field("Server Name"; Rec."Server Name")
                {
                    ToolTip = 'Specifies the value of the Server Name field';
                    ApplicationArea = All;
                }
                part("Notifi. Serv. Center Limit Sub"; "Notifi. Serv. Center Limit Sub")
                {
                    SubPageLink = "Company Name" = field(Name), "Tenant ID" = field("Tenant ID");
                }
            }
        }
    }

}
