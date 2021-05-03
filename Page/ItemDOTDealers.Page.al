page 1044881 "Item DOT Dealers"
{
    // +--------------------------------------------------------------+
    // | @ 2019 incadea Taiwan Limited                                |
    // +--------------------------------------------------------------+
    // | PURPOSE: MARS_TWN                                            |
    // |                                                              |
    // | REMARK :                                                     |
    // +--------------------------------------------------------------+
    // 
    // VERSION       ID            WHO    DATE        DESCRIPTION
    // RGS_TWN-848   120846        GG     2019-11-18  New object

    Caption = 'Item DOT Dealers';
    PageType = List;
    SourceTable = "Item DOT Entry";
    SourceTableView = SORTING(Type, Tenant, "Upload Date")
                      ORDER(Ascending)
                      WHERE(Type = CONST(Tenant));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Tenant; Tenant)
                {
                }
                field(Active; Active)
                {
                }
            }
            part(Items; "Item DOT Entries")
            {
            }
        }
    }

    actions
    {
        area(processing)
        {
            group(General)
            {
                action("Upload Item Tracking Code To Master")
                {
                    Caption = 'Upload Item Tracking Code To Master';
                    Image = UpdateDescription;
                    Promoted = true;
                    PromotedIsBig = true;
                    RunObject = Report "Upload Item Tracking";
                }
            }
        }
    }
}

