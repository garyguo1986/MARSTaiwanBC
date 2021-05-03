tableextension 1073882 "Cust. Ledger Entry Ext" extends "Cust. Ledger Entry"
{

    // +--------------------------------------------------------------+
    // | @ 2017 incadea Taiwan Limited                                |
    // +--------------------------------------------------------------+
    // | PURPOSE: MARS_TWN                                            |
    // |                                                              |
    // +--------------------------------------------------------------+

    // VERSION      WHO    DATE        DESCRIPTION
    // RGS_TWN-336  NN     2017-04-20  Add fields 50000 - 50003    
    fields
    {
        field(50000; "Bill-to Contact Name"; Text[50])
        {
            Description = 'RGS_TWN-336';
            Caption = 'Bill-to Contact Name';
            FieldClass = FlowField;
            CalcFormula = lookup(Contact.Name where("No." = field("Bill-to Contact No.")));
            Editable = false;
        }
        field(50001; "Bill-to Phone No."; Text[30])
        {
            Description = 'RGS_TWN-336';
            Caption = 'Bill-to Phone No.';
            FieldClass = FlowField;
            CalcFormula = lookup(Contact."Phone No." where("No." = field("Bill-to Contact No.")));
            Editable = false;
        }
        field(50002; "Bill-to Mobile Phone No."; Text[30])
        {
            Description = 'RGS_TWN-336';
            Caption = 'Bill-to Mobile Phone No.';
            FieldClass = FlowField;
            CalcFormula = lookup(Contact."Mobile Phone No." where("No." = field("Bill-to Contact No.")));
            Editable = false;
        }
        field(50003; "Licence-Plate No."; Text[20])
        {
            Description = 'RGS_TWN-336';
            Caption = 'Licence-Plate No.';
            FieldClass = FlowField;
            CalcFormula = lookup("Sales Invoice Header"."Licence-Plate No." where("No." = field("Document No.")));
            Editable = false;
        }
    }
}
