pageextension 1044884 pageextension1044884 extends "Customer Groups"
{
    // +--------------------------------------------------------------+
    // | ?2005 ff. Begusch Software Systeme                          |
    // #3..14
    // 
    // +--------------------------------------------------------------+
    // | @ 2017 Incadea Taiwan Limited                                |
    // +--------------------------------------------------------------+
    // | PURPOSE: MARS_TWN                                            |
    // |                                                              |
    // | REMARK :                                                     |
    // +--------------------------------------------------------------+
    // 
    // VERSION   ID             WHO    DATE        DESCRIPTION
    // TWN.01.01 RGS_TWN-459    AH     2017-06-02  add field Retail on page.
    Caption = 'Customer Groups';
    layout
    {
        addafter(Description)
        {
            field(Retail; Retail)
            {
            }
        }
    }
}

