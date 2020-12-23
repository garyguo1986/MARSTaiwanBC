pageextension 1044865 pageextension1044865 extends "Sales Order Subform"
{
    actions
    {
        addafter("Discount Details")
        {
            separator(Action1000000045)
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

