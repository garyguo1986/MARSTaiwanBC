tableextension 1044877 "Sales Header Ext" extends "Sales Header"
{
    // +--------------------------------------------------------------+
    // | ?2005 ff. Begusch Software Systeme                          |
    // #3..9
    // 040000   COR001  SK     2005-02-01  additional fields for vehicle and depot
    // #11..23
    //                                     vehicle and depot
    // #25..52
    // 040102   IT_1724 SK     2006-03-13  only update vehicle no. and depot no. if pressed ok
    // #54..57
    //                                     clear depot data if depot no. is removed
    // 040103   IT_2110 SK     2006-04-07  added functions to call depot card and depot order
    // #60..69
    // 040103   IT_2373 SK     2006-05-18  new function to create depot with information from sales header
    // #71..84
    // 040104   IT_2577 SK     2006-06-30  changed depot no. from code 10 to code 20
    // #86..112
    // 040202   IT_2983 SK     2006-11-21  set key for vehicle lookup and depot lookup
    // 040203   IT_3040 SK     2006-12-18  corrected assignment of "Customer Commission Code"
    // 040204   IT_3048 SK     2007-01-03  added check of depot no. in functions CallDepot and CallDepotOrder
    // #116..165
    // 040302   IT_3930 MH     2008-02-18  field "Depot Storage Code" changed from Code10 -> Code20
    // #167..201
    // 050103   IT_4639 MH     2009-02-16  clear depot and vehicle information in case the customer changed
    // #203..235
    //                                     is changed due to change of "Vehicle No." or "Depot No."
    // 050110   IT_4425 GS     2010-10-28  CreateVehicle: create with search name
    // 050110   IT_5836 SR     2010-10-20  Fields Text 1 .. Text 7 are extended from Text30 -> Text50.
    // 050110   IT_6085 GS     2010-11-12  CreateDepot: VALIDATE and MODIFY after RUNMODAL
    // #240..247
    // 060100   IT_6242 MH     2011-02-14  - field "Document Type" extended by Carcass options
    //                                     - several code changes for carcass functionallity
    // #248..274
    //                                       1017461 Depot Responsibility Center
    //                                       1017462 Depot Storage Code
    //                                       1017463 Depot Bin No.
    // #278..301
    // 060100   IT_6609 FT     2011-10-18  fixed bug at function "Create New Depot"
    // #303..354
    //                                     Now it is possible to post an evacuation-depot-order, even if the Contact is blocked.
    // 071100   IT_8573  SS    2013-10-14  fix: "TecDoc Vehicle No." was not updated
    // 071100   IT_8726  AK    2014-01-20  MERGE 06.04.00
    // 071100   IT_8583  MW    2014-03-11  added HideValidation Functionality on "Depot No." and "Vehicle No." Validate
    // #359..441
    // HF21636   IT_21636 SS      2017-12-19   fix runmodal error - when in the sales order a contact
    //                                         from page "Contact Search Results" with overdue balance was selected
    // 
    // +--------------------------------------------------------------+
    // | @ 2017 incadea Taiwan Limited                                |
    // +--------------------------------------------------------------+
    // | PURPOSE: MARS_TWN                                            |
    // |                                                              |
    // +--------------------------------------------------------------+
    // 
    // VERSION      ID           WHO    DATE        DESCRIPTION
    // RGS_TWN-561               NN     2017-04-20  Add fields 50000 and Merge R3 customization
    // TWN.01.09    RGS_TWN-524  NN     2017-04-24  Add a record filter to Compaign Lists when lookup "Campaign No.".
    // TWN.01.03    RGS_TWN-327  AH     2017-05-22  Add 1044861,1044862 fields for Personal Information Agreement
    // RGS_TWN-342               AH     2017-05-19  Add field Bill-to Company Name (1044864)
    // TWN.01.06    RGS_TWN-695  AH     2017-09-06  removed duplicate search execution from service selection and fixes variables for main execution (HF21473)
    // +----------------------------------------------+
    // | Copyright (c) incadea China                  |
    // +----------------------------------------------+
    // TFS          ID             WHO    DATE        DESCRIPTION
    // 112051       MARS_TWN-6456  GG     2018-02-26  Add new key "Posting Date" "Document Date"
    // 112162       MARS_TWN-6441  GG     2018-03-12  Add new field "Check Flag"
    // 115762       RGS_TWN-798    GG     2018-08-03  Add "Service Center" filter for salesperson code onlookup
    // RGS_TWN-888   122187	       QX	  2020-12-01  Changed SalespersonLookup to SpecialSalespersonLookup, SalespersonValidate to SpecialSalespersonValidate
    fields
    {
        field(50001; "Final Check Name"; Code[20])
        {
            Caption = 'Final Check Name';
            Description = 'RGS_TWN-561';
            TableRelation = "Salesperson/Purchaser".Code WHERE(Retired = CONST(false));

            trigger OnLookup()
            //++TWN1.00.122187.QX
            var
                SalespersonCodeL: code[10];
                IsSpecialSalespersonLookupL: Boolean;
            //--TWN1.00.122187.QX
            begin
                //++TWN1.00.122187.QX
                // //Start RGS_TWN-561
                // VALIDATE("Final Check Name", SalespersonLookup("Final Check Name", FALSE, FALSE, FALSE, TRUE));
                // //Stop RGS_TWN-561
                SpecialSalespersonLookup("Final Check Name", FALSE, FALSE, FALSE, TRUE, IsSpecialSalespersonLookupL, SalespersonCodeL);
                VALIDATE("Final Check Name", SalespersonCodeL);
                //--TWN1.00.122187.QX
            end;

            trigger OnValidate()
            //++TWN1.00.122187.QX
            var
                IsSpecialSalespersonValidationL: Boolean;
                IsValidL: Boolean;
            //--TWN1.00.122187.QX
            begin
                //++TWN1.00.122187.QX
                // // Start RGS_TWN-561
                // IF NOT SalespersonValidate("Final Check Name", FALSE, FALSE, FALSE, TRUE) THEN
                //     ERROR(C_TWN_ERR001);
                // // Stop RGS_TWN-561
                SpecialSalespersonValidate("Final Check Name", FALSE, FALSE, FALSE, TRUE, IsSpecialSalespersonValidationL, IsValidL);
                if not IsValidL then
                    ERROR(C_TWN_ERR001);
                //--TWN1.00.122187.QX
            end;
        }
        field(50100; "Check Flag"; Boolean)
        {
            Caption = 'Check Flag';
            Description = '112162_MARS_TWN-6441';
        }
        field(1044861; "Personal Data Status"; Option)
        {
            CalcFormula = Lookup(Contact."Personal Data Status" WHERE("No." = FIELD("Sell-to Contact No.")));
            Caption = 'Personal Data Status';
            Description = 'TWN.01.03';
            Editable = false;
            FieldClass = FlowField;
            OptionCaption = 'None,Yes,No,N/A';
            OptionMembers = "None",Yes,No,"N/A";
        }
        field(1044862; "Personal Data Agreement Date"; Date)
        {
            CalcFormula = Lookup(Contact."Personal Data Agreement Date" WHERE("No." = FIELD("Sell-to Contact No.")));
            Caption = 'Personal Data Agreement Date';
            Description = 'TWN.01.03';
            Editable = false;
            FieldClass = FlowField;
        }
        field(1044864; "Bill-to Company Name"; Text[50])
        {
            Caption = 'Bill-to Company Name';
            Description = 'RGS_TWN-342';
        }
    }

    var
        C_TWN_ERR001: Label 'No valid Final Check Name can be found.';
}

