codeunit 50003 "TWN General EventSubscriber"
{
    // +----------------------------------------------+
    // | Copyright (c) incadea China                  |
    // +----------------------------------------------+
    // TFS          ID             WHO    DATE        DESCRIPTION
    // 112168       MARS_TWN-6450  GG     2018-03-12  Add new function to default value in segment card
    // 115763       RGS_TWN-799    GG     2018-08-03  Add new function to default customer no. in Cash Register Customer
    // 117077       MARS_TWN-6963  GG     2018-10-29  Add new function OnFunctionGeneralInVehicleTable to get check type
    // RGS_TWN-888   122187	       QX	  2020-12-04  Chanfed VehicleGeneralPublisher to OnBeforeCheckLicencePlate

    trigger OnRun()
    begin
    end;

    var
        C_INC_001: Label 'The same licence plate no. is used by vehicle %1.';

    [EventSubscriber(ObjectType::Page, 5091, 'OnNewRecordEvent', '', true, false)]
    local procedure OnNewRecordEventInSegmentCard(var Rec: Record "Segment Header"; BelowxRec: Boolean; var xRec: Record "Segment Header")
    begin
        // Page 5091 Segment OnNewRecordEvent
        // Start 112168
        Rec."Send with Notification" := TRUE;
        Rec."Notification Type (Default)" := Rec."Notification Type (Default)"::SMS;
        // Stop 112168
    end;

    [EventSubscriber(ObjectType::Table, 1017581, 'OnAfterInsertEvent', '', true, false)]
    local procedure OnInsertEventInCashRegisterHeaderTable(var Rec: Record "Cash Register Header"; RunTrigger: Boolean)
    var
        FastfitSetupGeneralL: Record "Fastfit Setup - General";
    begin
        // Table 1017581 "Cash Register Header" OnInsert
        // Start 115763
        IF Rec."Source Type" <> Rec."Source Type"::Customer THEN
            EXIT;
        IF Rec."Source No." <> '' THEN
            EXIT;
        IF NOT FastfitSetupGeneralL.GET THEN
            EXIT;
        IF FastfitSetupGeneralL."Std. Customer" = '' THEN
            EXIT;

        Rec.VALIDATE("Source No.", FastfitSetupGeneralL."Std. Customer");
        // Stop 115763
    end;
    //++TWN1.00.122187.QX
    // [EventSubscriber(ObjectType::Table, 1017540, 'VehicleGeneralPublisher', '', true, false)]
    [EventSubscriber(ObjectType::Table, 1017540, 'OnBeforeCheckLicencePlate', '', true, false)]
    //--TWN1.00.122187.QX
    local procedure OnFunctionGeneralInVehicleTable(var Sender: Record Vehicle; var VehiclePlateCheckType: Integer)
    var
        FastfitSetupVehicleL: Record "Fastfit Setup - Vehicle";
        VehicleL: Record Vehicle;
    begin
        // Table 1017540 Vehicle
        // Start 117077
        FastfitSetupVehicleL.GET;
        VehiclePlateCheckType := FastfitSetupVehicleL."Check Vehicle Licence Type";

        IF Sender."Licence-Plate No." = '' THEN
            EXIT;

        IF VehiclePlateCheckType IN [FastfitSetupVehicleL."Check Vehicle Licence Type"::"Licence-Plate No.",
           FastfitSetupVehicleL."Check Vehicle Licence Type"::"Search Name and License-Plate No."] THEN BEGIN
            VehicleL.RESET;
            VehicleL.SETRANGE("Licence-Plate No.", Sender."Licence-Plate No.");
            VehicleL.SETRANGE(Blocked, FALSE);
            VehicleL.SETFILTER("Vehicle No.", '<>%1', Sender."Vehicle No.");
            IF VehicleL.FIND('-') THEN
                ERROR(C_INC_001, VehicleL."Vehicle No.");
        END;
        // Stop 117077
    end;
}

