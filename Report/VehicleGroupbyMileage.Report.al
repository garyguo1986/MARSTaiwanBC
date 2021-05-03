report 1044861 "Vehicle Group by Mileage"
{
    // +--------------------------------------------------------------+
    // | ?2010 ff. Begusch Software Systeme                          |
    // +--------------------------------------------------------------+
    // | PURPOSE: TRS                                                 |
    // |                                                              |
    // | REMARK :                                                     |
    // +--------------------------------------------------------------+
    // 
    // VERSION       ID      WHO    DATE        DESCRIPTION
    // TRS_R1.00.08  IT_5965 SR     2010-09-24  INITIAL RELEASE
    // MARS_R3.00.00 IT_6977 AP     2012-05-29  added MUT call
    // 
    // --------------------------------------------------------------+
    // | @ 2017 incadea Taiwan Limited                                |
    // +--------------------------------------------------------------+
    // | PURPOSE: MARS_TWN                                            |
    // |                                                              |
    // | REMARK :                                                     |
    // +--------------------------------------------------------------+
    // 
    // VERSION       ID          WHO    DATE        DESCRIPTION
    // RGS_TWN-555               AH     2017-04-22  INITIAL RELEASE
    DefaultLayout = RDLC;
    RDLCLayout = './Report/VehicleGroupbyMileage.rdlc';

    Caption = 'Vehicle Group by Mileage';

    dataset
    {
        dataitem(TotalVehicleMileageCalculation; Vehicle)
        {
            DataItemTableView = SORTING("Vehicle No.");

            trigger OnAfterGetRecord()
            begin
                IF Mileage <= MileageBucket[1] THEN
                    TotalVehicleMileage[1] += 1
                ELSE
                    IF (Mileage > MileageBucket[1]) AND (Mileage <= MileageBucket[2]) THEN
                        TotalVehicleMileage[2] += 1
                    ELSE
                        IF (Mileage > MileageBucket[2]) AND (Mileage <= MileageBucket[3]) THEN
                            TotalVehicleMileage[3] += 1
                        ELSE
                            IF (Mileage > MileageBucket[3]) AND (Mileage <= MileageBucket[4]) THEN
                                TotalVehicleMileage[4] += 1
                            ELSE
                                IF (Mileage > MileageBucket[4]) AND (Mileage <= MileageBucket[5]) THEN
                                    TotalVehicleMileage[5] += 1
                                ELSE
                                    IF (Mileage > MileageBucket[5]) AND (Mileage <= MileageBucket[6]) THEN
                                        TotalVehicleMileage[6] += 1;
            end;

            trigger OnPostDataItem()
            begin
                FOR i := 1 TO 6 DO BEGIN
                    TotalVehicleMileage[7] += TotalVehicleMileage[i];
                END;
            end;

            trigger OnPreDataItem()
            begin
                CLEAR(TotalVehicleMileage);
            end;
        }
        dataitem(Vehicle1; Vehicle)
        {
            DataItemTableView = SORTING("Vehicle Manufacturer");
            column(USERID; USERID)
            {
            }
            column(CompanyInfo_Picture; CompanyInfo.Picture)
            {
            }
            column(CurrReport_PAGENO; CurrReport.PAGENO)
            {
            }
            column(CompanyInfo_Name_____CompanyInfo__Name_2_; CompanyInfo.Name + ' ' + CompanyInfo."Name 2")
            {
            }
            column(TIME; TIME)
            {
            }
            column(FORMAT_TODAY_0___Year4___Month_2___Day_2___; FORMAT(TODAY, 0, '<Year4>/<Month,2>/<Day,2>'))
            {
            }
            column(C_BSS_INF001_____COPYSTR_CurrReport_OBJECTID_FALSE__8_____; C_BSS_INF001 + '(' + COPYSTR(CurrReport.OBJECTID(FALSE), 8) + ')')
            {
            }
            column(STRSUBSTNO_C_BSS_INF002_0_MileageBucket_1__; STRSUBSTNO(C_BSS_INF002, 0, MileageBucket[1]))
            {
            }
            column(STRSUBSTNO_C_BSS_INF002_MileageBucket_1__MileageBucket_2__; STRSUBSTNO(C_BSS_INF002, MileageBucket[1], MileageBucket[2]))
            {
            }
            column(STRSUBSTNO_C_BSS_INF002_MileageBucket_2__MileageBucket_3__; STRSUBSTNO(C_BSS_INF002, MileageBucket[2], MileageBucket[3]))
            {
            }
            column(STRSUBSTNO_C_BSS_INF002_MileageBucket_3__MileageBucket_4__; STRSUBSTNO(C_BSS_INF002, MileageBucket[3], MileageBucket[4]))
            {
            }
            column(STRSUBSTNO_C_BSS_INF002_MileageBucket_4__MileageBucket_5__; STRSUBSTNO(C_BSS_INF002, MileageBucket[4], MileageBucket[5]))
            {
            }
            column(STRSUBSTNO_C_BSS_INF002_MileageBucket_5__MileageBucket_6__; STRSUBSTNO(C_BSS_INF002, MileageBucket[5], MileageBucket[6]))
            {
            }
            column(Vehicle1_Vehicle1__Vehicle_Manufacturer_; Vehicle1."Vehicle Manufacturer")
            {
            }
            column(VehicleMileage_1_; VehicleMileage[1])
            {
                DecimalPlaces = 0 : 0;
            }
            column(VehicleMileage_2_; VehicleMileage[2])
            {
                DecimalPlaces = 0 : 0;
            }
            column(VehicleMileage_3_; VehicleMileage[3])
            {
                DecimalPlaces = 0 : 0;
            }
            column(VehicleMileage_4_; VehicleMileage[4])
            {
                DecimalPlaces = 0 : 0;
            }
            column(VehicleMileage_5_; VehicleMileage[5])
            {
                DecimalPlaces = 0 : 0;
            }
            column(VehicleMileage_6_; VehicleMileage[6])
            {
                DecimalPlaces = 0 : 0;
            }
            column(VehicleMileage_7_; VehicleMileage[7])
            {
                DecimalPlaces = 0 : 0;
            }
            column(MileageKMText_1_; MileageKMText[1])
            {
            }
            column(MileageKMText_2_; MileageKMText[2])
            {
            }
            column(MileageKMText_3_; MileageKMText[3])
            {
            }
            column(MileageKMText_4_; MileageKMText[4])
            {
            }
            column(MileageKMText_5_; MileageKMText[5])
            {
            }
            column(MileageKMText_6_; MileageKMText[6])
            {
            }
            column(MileageKMText_7_; MileageKMText[7])
            {
            }
            column(VehicleMileage_1__Control1100023002; VehicleMileage[1])
            {
                DecimalPlaces = 0 : 0;
            }
            column(MileageKMText_1__Control1100023004; MileageKMText[1])
            {
            }
            column(VehicleMileage_2__Control1100023005; VehicleMileage[2])
            {
                DecimalPlaces = 0 : 0;
            }
            column(MileageKMText_2__Control1100023019; MileageKMText[2])
            {
            }
            column(VehicleMileage_3__Control1100023020; VehicleMileage[3])
            {
                DecimalPlaces = 0 : 0;
            }
            column(MileageKMText_3__Control1100023021; MileageKMText[3])
            {
            }
            column(VehicleMileage_4__Control1100023022; VehicleMileage[4])
            {
                DecimalPlaces = 0 : 0;
            }
            column(MileageKMText_4__Control1100023070; MileageKMText[4])
            {
            }
            column(VehicleMileage_5__Control1100023071; VehicleMileage[5])
            {
                DecimalPlaces = 0 : 0;
            }
            column(MileageKMText_5__Control1100023072; MileageKMText[5])
            {
            }
            column(VehicleMileage_6__Control1100023073; VehicleMileage[6])
            {
                DecimalPlaces = 0 : 0;
            }
            column(MileageKMText_6__Control1100023074; MileageKMText[6])
            {
            }
            column(VehicleMileage_7__Control1100023075; VehicleMileage[7])
            {
                DecimalPlaces = 0 : 0;
            }
            column(MileageKMText_7__Control1100023076; MileageKMText[7])
            {
            }
            column(PageCaption; PageCaptionLbl)
            {
            }
            column(Vehicle1_Vehicle1__Vehicle_Manufacturer_Caption; Vehicle1_Vehicle1__Vehicle_Manufacturer_CaptionLbl)
            {
            }
            column(TOTALCaption; TOTALCaptionLbl)
            {
            }
            column(TOTALCaption_Control1100023027; TOTALCaption_Control1100023027Lbl)
            {
            }
            column(Vehicle1_Vehicle_No_; "Vehicle No.")
            {
            }

            trigger OnAfterGetRecord()
            begin
                CLEAR(VehicleMileage);
                IF Mileage <= MileageBucket[1] THEN
                    VehicleMileage[1] := 1
                ELSE
                    IF (Mileage > MileageBucket[1]) AND (Mileage <= MileageBucket[2]) THEN
                        VehicleMileage[2] := 1
                    ELSE
                        IF (Mileage > MileageBucket[2]) AND (Mileage <= MileageBucket[3]) THEN
                            VehicleMileage[3] := 1
                        ELSE
                            IF (Mileage > MileageBucket[3]) AND (Mileage <= MileageBucket[4]) THEN
                                VehicleMileage[4] := 1
                            ELSE
                                IF (Mileage > MileageBucket[4]) AND (Mileage <= MileageBucket[5]) THEN
                                    VehicleMileage[5] := 1
                                ELSE
                                    IF (Mileage > MileageBucket[5]) AND (Mileage <= MileageBucket[6]) THEN
                                        VehicleMileage[6] := 1;

                FOR i := 1 TO 6 DO BEGIN
                    VehicleMileage[7] += VehicleMileage[i];
                END;
            end;

            trigger OnPreDataItem()
            begin
                CurrReport.CREATETOTALS(VehicleMileage);
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnInitReport()
    begin
        //++BSS.IT_6977.AP
        MUTFuncs.AddUsageTrackingEntry('MUT_6290');
        //--BSS.IT_6977.AP


        MileageBucket[1] := 10000;
        FOR i := 2 TO 6 DO BEGIN
            MileageBucket[i] := MileageBucket[i - 1] + 10000;
        END;
    end;

    trigger OnPreReport()
    begin
        CompanyInfo.GET;
        CompanyInfo.CALCFIELDS(CompanyInfo.Picture);
        FormatAddr.Company(CompanyAddr, CompanyInfo);
    end;

    var
        MileageBucket: array[6] of Decimal;
        VehicleMileage: array[7] of Decimal;
        TotalVehicleMileage: array[7] of Decimal;
        i: Integer;
        C_BSS_INF001: Label 'Vehicle Group By Mileage';
        C_BSS_INF002: Label '%1 - %2 [KM]';
        C_BSS_INF003: Label '%1%';
        MileageKMText: array[7] of Text[50];
        CompanyInfo: Record "Company Information";
        RespCenter: Record "Responsibility Center";
        FormatAddr: Codeunit "Format Address";
        CompanyAddr: array[8] of Text[50];
        MUTFuncs: Codeunit "Usage Tracking";
        PageCaptionLbl: Label 'Page';
        Vehicle1_Vehicle1__Vehicle_Manufacturer_CaptionLbl: Label 'Vehicle Manufacturer';
        TOTALCaptionLbl: Label 'TOTAL';
        TOTALCaption_Control1100023027Lbl: Label 'TOTAL';

    [Scope('OnPrem')]
    procedure CalculatePercent(i: Integer; MileageKM: Decimal): Decimal
    begin
        IF TotalVehicleMileage[i] <> 0 THEN
            EXIT(ROUND((MileageKM / TotalVehicleMileage[i]) * 100))
        ELSE
            EXIT(0);
    end;

    [Scope('OnPrem')]
    procedure CalculateTotalPercent(i: Integer; MileageKM: Decimal): Decimal
    begin
        IF TotalVehicleMileage[7] <> 0 THEN
            EXIT(ROUND((MileageKM / TotalVehicleMileage[7]) * 100))
        ELSE
            EXIT(0);
    end;
}

