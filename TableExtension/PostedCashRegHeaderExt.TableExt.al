tableextension 1044883 "Posted Cash Reg. Header Ext" extends "Posted Cash Register Header"
{
    fields
    {
        field(50000; "Pmt. Corr. for Sales Inv. No."; Code[20])
        {
            Caption = 'Pmt Corr. for Sales Inv. No.';
            Description = 'RGS_TWN-425';
            Editable = false;
            TableRelation = "Sales Invoice Header"."No.";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
    }
}
