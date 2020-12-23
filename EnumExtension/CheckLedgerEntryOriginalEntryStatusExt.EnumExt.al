// +--------------------------------------------------------------
// | ?2015 Incadea China Software System                          |
// +--------------------------------------------------------------+
// | PURPOSE: Local Customization                                 |
// |                                                              |
// | REMARK :                                                     |
// +--------------------------------------------------------------+
// 
// VERSION       ID       WHO    DATE        DESCRIPTION
// RGS_TWN-888   122187	  QX	 2020-11-23  Create Object

enumextension 1044861 "Check Ledger Entry Original Entry Status Ext" extends "Check Ledger Entry Original Entry Status"
{
    value(1044860; "Test Print")
    {
        Caption = 'Test Print';
    }
    value(1044861; Note)
    {
        Caption = 'Note';
    }
}
