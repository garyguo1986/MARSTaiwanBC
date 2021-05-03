pageextension 1073875 "Purch. Invoice Subform Ext" extends "Purch. Invoice Subform"
{
    // +--------------------------------------------------------------+
    // | @ 2017 incadea Taiwan Limited                                |
    // +--------------------------------------------------------------+
    // | PURPOSE: MARS_TWN                                            |
    // |                                                              |
    // | REMARK :                                                     |
    // +--------------------------------------------------------------+

    // VERSION       ID          WHO    DATE        DESCRIPTION
    // TWN.01.02     RGW_TWN-370 NN     2017-05-04  Copy "Item Charge Assignment" to MARSActionsLine
    // TWN.01.01     RGS_TWN-631 AH     2017-05-23  Add Item Tracking Line Action in MARSActionsLine ActionGroup.    
    actions
    {
        addafter("Item Availability by Location")
        {
            action("ItemChargeAssignment_MARS")
            {
                AccessByPermission = tabledata "Item Charge" = R;
                Image = SuggestItemCost;
                trigger OnAction()
                begin
                    ShowItemChargeAssgnt();
                end;
            }
        }
        addafter("Purchase Line &Discounts")
        {
            action("ItemTrackingLines_RGS")
            {
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
