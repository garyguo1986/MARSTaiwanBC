page 1044862 "Report Shortcut List"
{
    // +--------------------------------------------------------------+
    // | 2017 incadea Taiwan Limited                                  |
    // +--------------------------------------------------------------+
    // | PURPOSE: MARS_TWN                                            |
    // +--------------------------------------------------------------+

    // VERSION     ID            WHO    DATE        DESCRIPTION
    // TWN.01.04   RGS_TWN-617   NN     2017-05-02  INITIAL RELEASE    

    ApplicationArea = All;
    Caption = 'Report Shortcut List';
    PageType = List;
    SourceTable = "Report Shortcut";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Report Area"; Rec."Report Area")
                {
                    Caption = 'Report Area';
                    ApplicationArea = All;
                }
                field("Report ID"; Rec."Report ID")
                {
                    Caption = 'Report ID';
                    ApplicationArea = All;
                }
                field("Report Name"; Rec."Report Name")
                {
                    Caption = 'Report Name';
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    Caption = 'Description';
                    ApplicationArea = All;
                }
            }
        }
    }
    actions
    {
        area(Navigation)
        {
            group(Function)
            {
                action("Start Print Report")
                {
                    Caption = '&Start Print Report';
                    Image = Start;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ShortcutKey = 'F11';
                    trigger OnAction()
                    begin
                        REPORT.RUN("Report ID");
                    end;
                }
            }
        }
    }
}
