pageextension 1073892 "Item Lookup Ext." extends "Item Lookup"
{
    layout
    {
        addafter("No.")
        {
            field(Inventory; Inventory)
            {
                ApplicationArea = All;
            }
        }
    }
}
