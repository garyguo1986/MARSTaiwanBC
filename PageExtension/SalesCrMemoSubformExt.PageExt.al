pageextension 1044867 "Sales Cr. Memo Subform Ext" extends "Sales Cr. Memo Subform"
{
    actions
    {
        addafter("Discount Details")
        {
            separator(Action1000000029)
            {
            }
            action(ItemTrackingLines_RGS)
            {
                Caption = 'Item &Tracking Lines';
                Image = ItemTrackingLines;
                ShortCutKey = 'Shift+Ctrl+I';

                trigger OnAction()
                begin
                    OpenItemTrackingLines;
                end;
            }
        }
    }
}

