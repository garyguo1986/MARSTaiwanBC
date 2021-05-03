pageextension 1073876 "Purch. Cr. Memo Subform Ext" extends "Purch. Cr. Memo Subform"
{

    // +--------------------------------------------------------------+
    // | @ 2017 incadea Taiwan Limited                                |
    // +--------------------------------------------------------------+
    // | PURPOSE: MARS_TWN                                            |
    // |                                                              |
    // | REMARK :                                                     |
    // +--------------------------------------------------------------+

    // VERSION       ID          WHO    DATE        DESCRIPTION
    // TWN.01.01     RGS_TWN-631 AH     2017-05-23  Add Item Tracking Line Action in MARSActionsLine ActionGroup.

    actions
    {
        addafter("Purchase Line &Discounts")
        {
            action("ItemTrackingLines_RGS")
            {
                Caption = 'Item &Tracking Lines';
                Image = ItemTrackingLines;
                ShortcutKey = 'Shift+Ctrl+I';
                trigger OnAction()
                begin
                    OpenItemTrackingLines();
                end;
            }
        }
    }
}
