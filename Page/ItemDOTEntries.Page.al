page 1044882 "Item DOT Entries"
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

    PageType = ListPart;
    SourceTable = "Item DOT Entry";
    SourceTableView = SORTING(Type, Tenant, "Upload Date")
                      ORDER(Ascending)
                      WHERE(Type = CONST(Item));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Item No."; "Item No.")
                {
                }
                field("Item Description"; "Item Description")
                {
                }
                field("Item Tracking Code"; "Item Tracking Code")
                {
                }
                field("Upload Date"; "Upload Date")
                {
                }
                field("Upload Time"; "Upload Time")
                {
                }
                field("Replication Date"; "Replication Date")
                {
                }
                field("Repl. Post Run Finished"; "Repl. Post Run Finished")
                {
                }
            }
        }
    }

    actions
    {
    }
}

