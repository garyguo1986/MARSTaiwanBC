/// <summary>
/// PageExtension Purchase Order List Ext. (ID 1044891) extends Record Purchase Order List.
/// </summary>
pageextension 1044893 "Purchase Order List Ext." extends "Purchase Order List"
{
    layout
    {
        addafter("Job Queue Status")
        {
            field("OCT Order No."; "OCT Order No.")
            {
            }
        }
    }
}
