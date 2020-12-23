pageextension 1044866 pageextension1044866 extends "Sales Invoice Subform"
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

