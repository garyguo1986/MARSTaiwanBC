tableextension 1044879 "Sales Invoice Header Ext" extends "Sales Invoice Header"
{
    // +--------------------------------------------------------------+
    // | ?2005 ff. Begusch Software Systeme                          |
    // #3..9
    // 040000   COR     SK     2005-02-08  additional fields for vehicle and depot
    // #11..32
    // 040122   IT_2845 AP     2006-09-18  changed field length fld 1017460 - "Depot No."
    // #34..49
    // 040302   IT_3930 MH     2008-02-18  field "Depot Storage Code" changed from Code10 -> Code20
    // #51..74
    //                                       Depot Responsibility Center
    //                                       Depot Storage Code
    //                                       Depot Bin No.
    // #78..154
    // HF21918  IT_21918 SS    2018-09-11  added key "Service Center","Salesperson code", "Vehicle No", "Vehicle Check Status"
    // 
    // +--------------------------------------------------------------+
    // | @ 2017 incadea Taiwan Limited                                |
    // +--------------------------------------------------------------+
    // | PURPOSE: MARS_TWN                                            |
    // |                                                              |
    // +--------------------------------------------------------------+
    // 
    // VERSION      ID           WHO    DATE        DESCRIPTION
    // RGS_TWN-561  TWN_R03_T03  NN     2017-04-20  Add field 50000 Final Check Name
    // TWN.01.01    RGS_TWN-401  AH     2017-05-17  Add field 1044863 Credit Memo No.
    // RGS_TWN-342               AH     2017-05-19  Add field Bill-to Company Name (1044864)
    fields
    {
        field(50001; "Final Check Name"; Code[20])
        {
            Caption = 'Final Check Name';
            Description = 'RGS_TWN-561';
            Editable = false;
            TableRelation = "Salesperson/Purchaser".Code;
        }
        field(1044863; "Credit Memo No."; Code[20])
        {
            Caption = 'Credit Memo No.';
            Description = 'TWN.01.01';
        }
        field(1044864; "Bill-to Company Name"; Text[50])
        {
            Caption = 'Bill-to Company Name';
            Description = 'RGS_TWN-342';
        }
        field(1073850; "Canceled By"; Code[20])
        {
            // Removed Core ID: 1300
            Caption = 'Canceled By';
            Editable = false;
            TableRelation = "Sales Cr.Memo Header";
        }
        field(1073851; Canceled; Boolean)
        {
            // Removed Core ID: 1301
            FieldClass = FlowField;
            CalcFormula = Exist("Sales Cr.Memo Header" WHERE(Canceled = CONST(true),
                                                              "Applies-to Doc. Type" = CONST(Invoice),
                                                              "Applies-to Doc. No." = FIELD("No.")));
            Caption = 'Canceled';
            Editable = false;
        }

    }
}

