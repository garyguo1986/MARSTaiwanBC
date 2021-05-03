tableextension 1044873 "Item Statistics Buffer Ext" extends "Item Statistics Buffer"
{
    // +--------------------------------------------------------------+
    // | ?2010 ff. Begusch Software Systeme                          |
    // #3..13
    // 
    // +----------------------------------------------+
    // | Copyright (c) incadea China                  |
    // +----------------------------------------------+
    // TFS           ID             WHO    DATE        DESCRIPTION
    // 121392        MARS_TWN_7736  GG     2020-02-28  Add flowfilter field "Main Group Filter" "Sub Group Filter" ""Position Group Filter" and use the fields for flowfield
    fields
    {
        field(1044862; "Main Group Filter"; Code[10])
        {
            Caption = 'Main Group Filter';
            Description = '121392';
            FieldClass = FlowFilter;
            TableRelation = "Main Group";
            ValidateTableRelation = false;
        }
        field(1044863; "Sub Group Filter"; Code[10])
        {
            Caption = 'Sub Group Filter';
            Description = '121392';
            FieldClass = FlowFilter;
            TableRelation = "Sub Group";
            ValidateTableRelation = false;
        }
        field(1044864; "Position Group Filter"; Code[10])
        {
            Caption = 'Position Group Filter';
            Description = '121392';
            FieldClass = FlowFilter;
            TableRelation = "Position Group";
            ValidateTableRelation = false;
        }
        field(1045000; "Purchase Amount (Actual)"; Decimal)
        {
            FieldClass = FlowField;
            AutoFormatType = 1;
            CalcFormula = Sum("Value Entry"."Purchase Amount (Actual)" WHERE("Item No." = FIELD("Item Filter"), "Posting Date" = FIELD("Date Filter"), "Item Ledger Entry Type" = FIELD("Item Ledger Entry Type Filter"), "Entry Type" = FIELD("Entry Type Filter"), "Variance Type" = FIELD("Variance Type Filter"), "Location Code" = FIELD("Location Filter"), "Variant Code" = FIELD("Variant Filter"), "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"), "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter"), "Item Charge No." = FIELD("Item Charge No. Filter"), "Source Type" = FIELD("Source Type Filter"), "Source No." = FIELD("Source No. Filter"), "Service Center" = FIELD("Service Center Filter"), "Main Group Code" = FIELD("Main Group Filter"), "Sub Group Code" = FIELD("Sub Group Filter"), "Position Group Code" = FIELD("Position Group Filter")));
            Caption = 'Purchase Amount (Actual)';
            Description = '121392';
            Editable = false;
        }
    }
}

