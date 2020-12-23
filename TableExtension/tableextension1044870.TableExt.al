tableextension 1044870 tableextension1044870 extends Contact
{
    // +--------------------------------------------------------------+
    // | ?2005 ff. Begusch Software Systeme                          |
    // #3..18
    // 040202   IT_2978 SK     2006-11-17  if changing company no. then update customer in vehicle and depot
    //                                     and update search names in depot and vehicle
    // #21..24
    // 040301   IT_3710 MH     2008-01-14  update vehicle and depot record for contact/customer search name
    // #26..41
    // 050110   IT_6060 MH     2010-11-04  bugfix for function UpdateDepotData and UpdateVehicleData
    // #43..47
    // 050110   IT_6133 SS     2010-12-03  added additional check for cancelled Depots
    // #49..102
    // 
    // +--------------------------------------------------------------+
    // | @ 2017 incadea Taiwan Limited                                |
    // +--------------------------------------------------------------+
    // | PURPOSE: MARS_TWN                                            |
    // |                                                              |
    // | REMARK :                                                     |
    // +--------------------------------------------------------------+
    // 
    // VERSION       ID          WHO    DATE        DESCRIPTION
    // TWN.01.03     RGS_TWN-327 AH     2017-04-20  Add 1044861,1044862 fields for Personal Information Agreement
    // RGS_TWN-342               AH     2017-05-19  Add field Bill-to Company Name (1044863)
    // RGS_TWN-342               AH     2017-05-19  Clear "Bill-to Company Name" field when "Central Maintenance" is true
    // RGS_TWN-342               AH     2017-06-21  Add New Field Blocked
    // TWN.01.05     RGS_TWN-421 AH     2017-09-04  Set Accept E-Mail defaule value
    // +----------------------------------------------+
    // | Copyright (c) incadea China                  |
    // +----------------------------------------------+
    // TFS          ID             WHO    DATE        DESCRIPTION
    // 112172       MARS_TWN-6457  GG     2018-03-09  Change error message if contact status is in maintenance
    fields
    {
        field(50001; "Personal Data Status"; Option)
        {
            Caption = 'Personal Data Status';
            Description = 'TWN.01.03';
            Editable = false;
            OptionCaption = 'None,Yes,No,N/A';
            OptionMembers = "None",Yes,No,"N/A";

            trigger OnValidate()
            begin
                //++TWN1.00.122187.QX
                // "Accept SMS", "Accept E-Mail", "Accept Notification" were removed
                //
                // "Accept SMS" := FALSE;
                // IF "Personal Data Status" = "Personal Data Status"::Yes THEN BEGIN
                //     "Accept Notification" := TRUE;
                //     "Accept SMS" := TRUE;
                //     //++Inc.TWN-421.AH
                //     //"Accept E-Mail"  := TRUE;
                //     //--Inc.TWN-421.AH
                // END ELSE BEGIN
                //     IF NOT ("Accept SMS" AND "Accept E-Mail") THEN BEGIN
                //         "Accept Notification" := FALSE;
                //         //++Inc.TWN-421.AH
                //         //"Accept E-Mail"  := FALSE;
                //         //--Inc.TWN-421.AH
                //     END;
                // END;
                //++TWN1.00.122187.QX
            end;
        }
        field(50002; "Personal Data Agreement Date"; Date)
        {
            Caption = 'Personal Data Agreement Date';
            Description = 'TWN.01.03';
            Editable = false;
        }
        field(50003; "Bill-to Company Name"; Text[50])
        {
            Caption = 'Bill-to Company Name';
            Description = 'RGS_TWN-342';
        }
        field(50004; Blocked; Boolean)
        {
            Caption = 'Blocked';
            Description = 'RGS_TWN-395';
        }
    }
}

