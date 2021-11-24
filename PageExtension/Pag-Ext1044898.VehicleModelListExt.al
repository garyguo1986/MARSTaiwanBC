pageextension 1044898 "Vehicle Model List Ext." extends "Vehicle Model List"
{
    trigger OnOpenPage()
    begin
        SetRange("Deleted by HQ", false);
    end;
}