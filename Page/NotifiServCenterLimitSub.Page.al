page 1044880 "Notifi. Serv. Center Limit Sub"
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


    Caption = 'Notifi. Serv. Center Limit Sub';
    PageType = ListPart;
    SourceTable = "Notifi. Serv. Center Limit";
    DelayedInsert = true;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Company Name"; Rec."Company Name")
                {
                    ToolTip = 'Specifies the value of the Name field';
                    ApplicationArea = All;
                }
                field("Tenant ID"; Rec."Tenant ID")
                {
                    ToolTip = 'Specifies the value of the Tenant ID field';
                    ApplicationArea = All;
                }
                field("Service Center"; Rec."Service Center")
                {
                    ToolTip = 'Specifies the value of the Service Center field';
                    ApplicationArea = All;
                }
            }
        }
    }

}
