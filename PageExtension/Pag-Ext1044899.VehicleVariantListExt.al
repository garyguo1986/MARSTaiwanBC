pageextension 1044899 "Vehicle Variant List Ext." extends "Vehicle Variant List"
{
    trigger OnOpenPage()
    begin
        SetRange("Deleted by HQ", false);
    end;
}
