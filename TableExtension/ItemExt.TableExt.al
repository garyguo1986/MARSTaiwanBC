tableextension 1044886 "Item Ext" extends Item
{
    fields
    {
        field(1073850; "Carcass Type"; Option)
        {
            // Removed Core ID: 1017747
            Caption = 'Carcass Type';
            Description = 'IT_6242';
            OptionCaption = ' ,Customer Carcass,Customer Carcass to Purch.,Retreaded Customer Tire,Retreaded Tire,Carcass Disposal';
            OptionMembers = " ","Customer Carcass","Customer Carcass to Purch.","Retreaded Customer Tire","Retreaded Tire","Carcass Disposal";
        }
        field(1073851; "Carcass Disposal No."; Code[20])
        {
            // Removed Core ID: 1017749
            Caption = 'Carcass Disposal No.';
            Description = 'IT_6242';
            TableRelation = Item;
        }
    }
}

