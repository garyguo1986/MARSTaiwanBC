page 1044890 "Replication Company Old"
{

    ApplicationArea = All;
    Caption = 'Replication Company Old';
    PageType = List;
    SourceTable = "Replication Company Old";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
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
                field("Server Name"; Rec."Server Name")
                {
                    ToolTip = 'Specifies the value of the Server Name field';
                    ApplicationArea = All;
                }
                field("Database Name"; Rec."Database Name")
                {
                    ToolTip = 'Specifies the value of the Database Name field';
                    ApplicationArea = All;
                }
                field("Last Company Refresh"; Rec."Last Company Refresh")
                {
                    ToolTip = 'Specifies the value of the Last Company Refresh field';
                    ApplicationArea = All;
                }
                field(Master; Rec.Master)
                {
                    ToolTip = 'Specifies the value of the Master field';
                    ApplicationArea = All;
                }
                field(Reporting; Rec.Reporting)
                {
                    ToolTip = 'Specifies the value of the Reporting field';
                    ApplicationArea = All;
                }
                field("Selected for Initialization"; Rec."Selected for Initialization")
                {
                    ToolTip = 'Specifies the value of the Selected for Initialization field';
                    ApplicationArea = All;
                }
                field(Staging; Rec.Staging)
                {
                    ToolTip = 'Specifies the value of the Staging field';
                    ApplicationArea = All;
                }
                field("Synchronization (Master Data)"; Rec."Synchronization (Master Data)")
                {
                    ToolTip = 'Specifies the value of the Synchronization (Master Data) field';
                    ApplicationArea = All;
                }
                field("Synchronization (Reporting)"; Rec."Synchronization (Reporting)")
                {
                    ToolTip = 'Specifies the value of the Synchronization (Reporting) field';
                    ApplicationArea = All;
                }
            }
        }
    }

}
