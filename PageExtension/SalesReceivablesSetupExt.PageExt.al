pageextension 1044872 "Sales & Receivables Setup Ext" extends "Sales & Receivables Setup"
{
    layout
    {
        addafter("Prom. Editing always allowed")
        {
            field("Price Includes VAT"; "Price Includes VAT")
            {
            }
            field(DefaultVehicleChkInfoTmplCode; DefaultVehicleChkInfoTmplCode)
            {
                Caption = 'Default Vehicle Check Info Tmpl Code';
            }
            field("No Modify Customer"; "No Modify Customer")
            {
            }
        }
        addafter("Labelling on Sales Documents")
        {
            field("Sales Alert Amount"; "Sales Alert Amount")
            {
            }
        }
    }
}

