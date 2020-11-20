page 50001 "Bank Code"
{
    // +--------------------------------------------------------------+
    // | @ 2017 incadea Taiwan Limited                                |
    // +--------------------------------------------------------------+
    // | PURPOSE: MARS_TWN                                            |
    // |                                                              |
    // | REMARK :                                                     |
    // +--------------------------------------------------------------+
    // 
    // VERSION     ID                  WHO    DATE        DESCRIPTION
    // TWN.01.09   RGS_TWN-INC01_NPNR  AH     2017-06-05  INITIAL RELEASE

    Caption = 'Bank Code';
    PageType = List;
    SourceTable = "Bank Code";
    UsageCategory = Tasks;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Code; Code)
                {
                }
                field(Name; Name)
                {
                }
                field("Name 2"; "Name 2")
                {
                }
            }
        }
    }

    actions
    {
    }
}

