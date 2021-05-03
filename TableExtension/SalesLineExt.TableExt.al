tableextension 1044875 "Sales Line Ext" extends "Sales Line"
{
    // +--------------------------------------------------------------+
    // | . 2005 ff. Begusch Software Systeme                          |
    // #3..9
    // 040000   TDP001  SK     2005-02-09  check depot charging entries
    // #11..83
    // 040103   IT_2110 SK     2006-04-07  CheckDepotChargingEntries of shopping basket lines
    // #85..296
    // 050110   IT_5686 MH     2010-05-17  handling for new customer field "Limited Res. Selection" / "Item Blacklist Code"嚙窮dded
    // #298..314
    // 060100   IT_6242 MH     2011-02-14  - removed the following carcass related fields:
    //                                       1017730 Carcass Quality
    //                                       1017731 Carcass Quality Type
    //                                       1017732 Used Tire Disposal
    //                                       1017733 Desired Tread Design
    //                                       1017734 Customer Carcass
    //                                       1017735 Retread Item No.
    //                                       1017736 Skip for Orders
    //                                     - removed function "SearchMatchCodeRetreatItem"
    //                                     - added new fields
    //                                       1017730 Carcass Type
    //                                       1017731 Carcass Serial No.
    //                                       1017732 Carcass Sequential No.
    //                                       1017733 Carcass Quality
    //                                       1017734 Carc. Acceptable by Retreader
    //                                       1017736 Carcass Doc. Status
    //                                       1017737 Linked Sales Order No.
    //                                       1017738 Linked Sales Order Line No.
    //                                       1017400 Item Vendor No.
    //                                       1017741 Linked S. Ret. Order No.
    //                                       1017742 Linked S. Ret. Order Line No.
    //                                     - field "Document Type" extended by Carcass options
    //                                     - autom. reservation cancellation on "Undospecialorder"
    //                                     - new Function SetUndoSpecOrderAllowed
    //                                     - new key added:
    //                                       "Sell-to Customer No.,No.,Document Type,Carcass Doc. Status,Carcass Quality Code"
    // #318..362
    // 071100   IT_7859  MW    2013-07-15  fixed error for carcass items with additional items
    // #363..448
    // 
    // +--------------------------------------------------------------+
    // | @ 2017 incadea Taiwan Limited                                |
    // +--------------------------------------------------------------+
    // | PURPOSE: MARS_TWN                                            |
    // |                                                              |
    // +--------------------------------------------------------------+
    // 
    // VERSION       ID          WHO    DATE        DESCRIPTION
    // TWN.01.01     RGS_TWN-459 AH     2017-06-02  Add New Fields 50001..50002
    // +----------------------------------------------+
    // | Copyright (c) incadea China                  |
    // +----------------------------------------------+
    // TFS          ID             WHO    DATE        DESCRIPTION
    // 112159       MARS_TWN-6293  GG     2018-03-05  Add new field "Main Group Code"
    fields
    {
        field(50000; "Main Group Code"; Code[10])
        {
            Caption = 'Main Group Code';
            Description = '112159';
            TableRelation = "Main Group";
        }
        field(50001; "Item Type"; Option)
        {
            Caption = 'Item Type';
            Description = 'TWN.01.01';
            OptionCaption = ' ,Tire,Lightmetal Rim,Steel Rim PC,Steel Rim Truck,Tire Accessory,Chain,General,Spare Part';
            OptionMembers = " ",Tire,"Lightmetal Rim","Steel Rim PC","Steel Rim Truck","Tire Accessory",Chain,General,"Spare Part";
        }
        field(50002; Retail; Boolean)
        {
            Caption = 'Retail';
            Description = 'TWN.01.01';
        }
        field(1073850; "Item Vendor No."; Code[20])
        {
            // Removed Core ID: 1017400
            FieldClass = FlowField;
            CalcFormula = Lookup("Extended Line Information"."Vendor No." WHERE("Sales/Purchase" = CONST(Sales),
                                                                                 "Document Type" = FIELD("Document Type"),
                                                                                 "Document No." = FIELD("Document No."),
                                                                                 "Document Line No." = FIELD("Line No.")));
            Caption = 'Item Vendor No.';
            Description = 'IT_6424';
        }
        field(1073851; "Carcass Sequential No."; Integer)
        {
            // Removed Core ID: 1017732
            Caption = 'Carcass Sequential No.';
            Description = 'IT_6242';

            trigger OnValidate()
            var
                SalesLineL: Record "Sales Line";
                ExtendedLineInfoL: Record "Extended Line Information";
                ExtendedLineInfo2L: Record "Extended Line Information";
                LineFound: Boolean;
                Finished: Boolean;
            begin
                //++GG
                /*
                //++BSS.IT_6242.MH
                Finished := FALSE;
                TestStatusOpen;
                
                IF "Line No." <> 0 THEN BEGIN
                
                  IF "Attached to Line No." <> 0 THEN BEGIN
                    SalesLineL.GET("Document Type", "Document No.", "Attached to Line No.");
                    SalesLineL."Carcass Sequential No." := "Carcass Sequential No.";
                    SalesLineL.MODIFY;
                    IF ExtendedLineInfoL.GET(ExtendedLineInfoL."Sales/Purchase"::Sales,
                         SalesLineL."Document Type", SalesLineL."Document No.", SalesLineL."Line No.") AND
                       ExtendedLineInfo2L.GET(ExtendedLineInfoL."Sales/Purchase"::Sales,
                         "Document Type", "Document No.", "Line No.") THEN BEGIN
                      IF ExtendedLineInfo2L."Vendor No." <> '' THEN BEGIN
                        ExtendedLineInfoL."Vendor No." := ExtendedLineInfo2L."Vendor No.";
                        ExtendedLineInfoL.MODIFY;
                      END;
                    END;
                    Finished := TRUE;
                  END;
                
                  IF Finished THEN
                    EXIT;
                
                  // check for attached lines
                  SalesLineL.RESET;
                  SalesLineL.SETRANGE("Document Type", "Document Type");
                  SalesLineL.SETRANGE("Document No.", "Document No.");
                  SalesLineL.SETRANGE("Attached to Line No.", "Line No.");
                  IF SalesLineL.FINDSET THEN
                    REPEAT
                      SalesLineL."Carcass Sequential No." := "Carcass Sequential No.";
                      SalesLineL.MODIFY;
                      IF ExtendedLineInfoL.GET(ExtendedLineInfoL."Sales/Purchase"::Sales,
                           SalesLineL."Document Type", SalesLineL."Document No.", SalesLineL."Line No.") AND
                         ExtendedLineInfo2L.GET(ExtendedLineInfoL."Sales/Purchase"::Sales,
                           "Document Type", "Document No.", "Line No.") THEN BEGIN
                        IF ExtendedLineInfo2L."Vendor No." <> '' THEN BEGIN
                          ExtendedLineInfoL."Vendor No." := ExtendedLineInfo2L."Vendor No.";
                          ExtendedLineInfoL.MODIFY;
                        END;
                      END;
                      Finished := TRUE;
                    UNTIL SalesLineL.NEXT = 0;
                
                  IF Finished THEN
                    EXIT;
                
                  // check for non-attached lines
                  // we assume that the order of the lines is the following:
                  // 1: Carcass
                  // 2: Retreaded Tire
                
                  LineFound := FALSE;
                  CALCFIELDS("Retread Order No.");
                  SalesLineL.RESET;
                  SalesLineL.SETRANGE("Document Type", "Document Type");
                  SalesLineL.SETRANGE("Document No.", "Document No.");
                  IF "Retread Order No." = "Retread Order No."::"1" THEN BEGIN
                    SalesLineL.SETFILTER("Line No.", '>%1', "Line No.");
                    IF SalesLineL.FINDFIRST THEN
                      LineFound := TRUE;
                  END ELSE IF "Retread Order No." = "Retread Order No."::"3" THEN BEGIN
                    SalesLineL.SETFILTER("Line No.", '<%1', "Line No.");
                    IF SalesLineL.FINDLAST THEN
                      LineFound := TRUE;
                  END;
                
                  IF LineFound THEN BEGIN
                    IF "Retread Order No." = "Retread Order No."::"1" THEN BEGIN
                      SalesLineL.CALCFIELDS("Retread Order No.");
                      IF SalesLineL."Retread Order No." = SalesLineL."Retread Order No."::"3" THEN BEGIN
                        SalesLineL."Carcass Sequential No." := "Carcass Sequential No.";
                        SalesLineL.MODIFY;
                        IF ExtendedLineInfoL.GET(ExtendedLineInfoL."Sales/Purchase"::Sales,
                             SalesLineL."Document Type", SalesLineL."Document No.", SalesLineL."Line No.") AND
                           ExtendedLineInfo2L.GET(ExtendedLineInfoL."Sales/Purchase"::Sales,
                             "Document Type", "Document No.", "Line No.") THEN BEGIN
                          IF ExtendedLineInfoL."Vendor No." <> '' THEN BEGIN
                            ExtendedLineInfo2L."Vendor No." := ExtendedLineInfoL."Vendor No.";
                            ExtendedLineInfo2L.MODIFY;
                          END;
                        END;
                      END;
                    END ELSE IF "Retread Order No." = "Retread Order No."::"3" THEN BEGIN
                      SalesLineL.CALCFIELDS("Retread Order No.");
                      IF SalesLineL."Retread Order No." = SalesLineL."Retread Order No."::"1" THEN BEGIN
                        SalesLineL."Carcass Sequential No." := "Carcass Sequential No.";
                        SalesLineL.MODIFY;
                        IF ExtendedLineInfoL.GET(ExtendedLineInfoL."Sales/Purchase"::Sales,
                             SalesLineL."Document Type", SalesLineL."Document No.", SalesLineL."Line No.") AND
                           ExtendedLineInfo2L.GET(ExtendedLineInfoL."Sales/Purchase"::Sales,
                             "Document Type", "Document No.", "Line No.") THEN BEGIN
                          IF ExtendedLineInfo2L."Vendor No." <> '' THEN BEGIN
                            ExtendedLineInfoL."Vendor No." := ExtendedLineInfo2L."Vendor No.";
                            ExtendedLineInfoL.MODIFY;
                          END;
                        END;
                      END;
                    END;
                  END;
                
                END;
                //--BSS.IT_6242.MH
                *///--GG

            end;
        }
        field(1073852; "Carcass Quality Code"; Code[10])
        {
            // Removed Core ID: 1017733
            Caption = 'Carcass Quality Code';
            Description = 'IT_6242';
            TableRelation = "Retread Header";
        }
        field(1073853; "Carc. Acceptable by Retreader"; Boolean)
        {
            // Removed Core ID: 1017734
            FieldClass = FlowField;
            //++TWN1.00.122187.QX
            // CalcFormula = Lookup("Retread Header".Owner WHERE("Retread Order Doc. No." = FIELD("Carcass Quality Code")));
            CalcFormula = exist("Retread Header" WHERE("Retread Order Doc. No." = FIELD("Carcass Quality Code")));
            //--TWN1.00.122187.QX
            Caption = 'Carc. Acceptable by Retreader';
            Description = 'IT_6242';
            Editable = false;
        }
        field(1073854; "Carcass Doc. Status"; Option)
        {
            // Removed Core ID: 1017736
            Caption = 'Carcass Doc. Status';
            Description = 'IT_6242';
            Editable = false;
            OptionCaption = 'Open,Acceptance Registered,Pickup Registered,Purch. Shipment Posted,Purch. Cr. Memo Posted,Finished';
            OptionMembers = Open,"Acceptance Registered","Pickup Registered","Shipment Posted","Cr.Memo Posted",Finished;
        }
        field(1073855; "Linked Sales Order No."; Code[20])
        {
            // Removed Core ID: 1017737
            FieldClass = FlowField;
            CalcFormula = Lookup("Extended Line Information"."Linked Sales Order No." WHERE("Sales/Purchase" = CONST(Sales),
                                                                                             "Document Type" = FIELD("Document Type"),
                                                                                             "Document No." = FIELD("Document No."),
                                                                                             "Document Line No." = FIELD("Line No.")));
            Caption = 'Linked Sales Order No.';
            Description = 'IT_6242';
            Editable = false;
        }
        field(1073856; "Linked Sales Order Line No."; Integer)
        {
            // Removed Core ID: 1017738
            FieldClass = FlowField;
            CalcFormula = Lookup("Extended Line Information"."Linked Sales Order Line No." WHERE("Sales/Purchase" = CONST(Sales),
                                                                                                  "Document Type" = FIELD("Document Type"),
                                                                                                  "Document No." = FIELD("Document No."),
                                                                                                  "Document Line No." = FIELD("Line No.")));
            Caption = 'Linked Sales Order Line No.';
            Description = 'IT_6242';
            Editable = false;
        }
        field(1073857; "Linked Carcass Order No."; Code[20])
        {
            // Removed Core ID: 1017739
            FieldClass = FlowField;
            CalcFormula = Lookup("Extended Line Information"."Linked Carcass Order No." WHERE("Sales/Purchase" = CONST(Sales),
                                                                                               "Document Type" = FIELD("Document Type"),
                                                                                               "Document No." = FIELD("Document No."),
                                                                                               "Document Line No." = FIELD("Line No.")));
            Caption = 'Linked Carcass Order No.';
            Description = 'IT_6242';
            Editable = false;
        }
        field(1073858; "Linked Carcass Order Line No."; Integer)
        {
            // Removed Core ID: 1017740
            FieldClass = FlowField;
            CalcFormula = Lookup("Extended Line Information"."Linked Carcass Order Line No." WHERE("Sales/Purchase" = CONST(Sales),
                                                                                                    "Document Type" = FIELD("Document Type"),
                                                                                               "Document No." = FIELD("Document No."),
                                                                                               "Document Line No." = FIELD("Line No.")));
            Caption = 'Linked Carcass Order Line No.';
            Description = 'IT_6242';
            Editable = false;
        }
        field(1073859; "Linked S. Ret. Order No."; Code[20])
        {
            // Removed Core ID: 1017741
            FieldClass = FlowField;
            CalcFormula = Lookup("Extended Line Information"."Linked S. Ret. Order No." WHERE("Sales/Purchase" = CONST(Sales),
                                                                                                "Document Type" = FIELD("Document Type"),
                                                                                                "Document No." = FIELD("Document No."),
                                                                                                "Document Line No." = FIELD("Line No.")));
            Caption = 'Linked S. Ret. Order No.';
            Description = 'IT_6242';
            Editable = false;
        }
        field(1073860; "Linked S. Ret. Order Line No."; Integer)
        {
            // Removed Core ID: 1017742
            FieldClass = FlowField;
            CalcFormula = Lookup("Extended Line Information"."Linked S. Ret. Order Line No." WHERE("Sales/Purchase" = CONST(Sales),
                                                                                                "Document Type" = FIELD("Document Type"),
                                                                                                "Document No." = FIELD("Document No."),
                                                                                                "Document Line No." = FIELD("Line No.")));
            Caption = 'Linked S. Ret. Order Line No.';
            Description = 'IT_6242';
            Editable = false;
        }
        field(1073861; "Tour Code"; Code[4])
        {
            // Removed Core ID: 1018310
            Caption = 'Tour Code';
            Description = 'IT_2250,IT_8876';
            //TableRelation = Tour.Code;

            trigger OnValidate()
            begin
                //++BSS.IT_2250.SK
                TestStatusOpen;
                //--BSS.IT_2250.SK
            end;
        }
        field(1073862; "Tour Placement"; Integer)
        {
            // Removed Core ID: 1018311
            BlankZero = true;
            Caption = 'Tour Placement';
            Description = 'IT_2250';
            MinValue = 0;

            trigger OnValidate()
            begin
                //++BSS.IT_2250.SK
                TestStatusOpen;
                //--BSS.IT_2250.SK
            end;
        }

    }
}

