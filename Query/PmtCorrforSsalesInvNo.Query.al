// +--------------------------------------------------------------
// | ?2020 Incadea China Software System                          |
// +--------------------------------------------------------------+
// | PURPOSE: Local Customization                                 |
// |                                                              |
// | REMARK :                                                     |
// +--------------------------------------------------------------+
// 
// VERSION       ID       WHO    DATE        DESCRIPTION
// RGS_TWN-888   122187	  QX	 2020-12-14  Create Object

query 1044860 "Pmt. Corr. for Ssales Inv. No."
{
    OrderBy = Descending(Pmt_Corr_for_Sales_Inv_No), Descending(No);

    elements
    {
        dataitem(PostedCashRegisterHeader; "Posted Cash Register Header")
        {
            column(No; "No.")
            {
            }
            column(Pmt_Corr_for_Sales_Inv_No; "Pmt. Corr. for Sales Inv. No.")
            {
            }
            column(Correction; Correction)
            {
            }
        }
    }
}

