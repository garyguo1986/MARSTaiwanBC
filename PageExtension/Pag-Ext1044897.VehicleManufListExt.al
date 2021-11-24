pageextension 1044897 "Vehicle Manuf. List Ext." extends "Vehicle Manufacturers List"
{
    trigger OnOpenPage()
    begin
        SetRange("Deleted by HQ", false);
    end;
}
