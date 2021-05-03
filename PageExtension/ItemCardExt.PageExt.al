pageextension 1044860 "Item Card Ext" extends "Item Card"
{
    // 
    // +--------------------------------------------------------------+
    // | ?2005 ff. Begusch Software Systeme                          |
    // #3..37
    // 040003   IT_1445 AP     2005-08-15  added field "Diameter" to 鮢ubform?FrameAccessory
    // #39..141
    // 060100   IT_6242 MH     2011-02-16  added new field "Carcass Type"
    // #142..234
    // +--------------------------------------------------------------+
    // | ?2016 Incadea.fastfit                                       |
    // #238..247
    // 
    // +--------------------------------------------------------------+
    // | @ 2017 incadea Taiwan Limited                                |
    // +--------------------------------------------------------------+
    // | PURPOSE: MARS_TWN                                            |
    // |                                                              |
    // +--------------------------------------------------------------+
    // 
    // VERSION     ID            WHO    DATE        DESCRIPTION
    // RGS_TWN-511               AH     2017-05-19  Add <Main Group Code>, <Sub Group Code>, <Position Group Code> 's description on Page
    // TWN.01.10   RGS_TWN-648   AH     2017-10-18  Merge HF21160 :the new creation of items was changed so that they are no longer totally blocked
    //             116129        WW     2018-08-28  Add new function to fix zone Code
    layout
    {
        addafter("Main Group Code")
        {
            field(MainGroupDes; GetMainGroupDes)
            {
            }
        }
        addafter("Sub Group Code")
        {
            field(SubGroupDes; GetSubGroupDes)
            {
            }
        }
        addafter("Position Group Code")
        {
            field(PositionGroupDes; GetPositionGroupDes)
            {
            }
        }
    }
    actions
    {
        addafter("Create Label")
        {
            action("Update Zone Code")
            {
                Caption = 'Update Zone Code';
                Enabled = IsEnable();
                Image = PrintCover;

                trigger OnAction()
                begin
                    //Start 116129
                    CODEUNIT.Run(CODEUNIT::"Fix Zone Data");
                    //Stop 116129
                end;
            }
        }
    }
}

