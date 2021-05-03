report 1044876 "TW Main Dashboard"
{
    // +--------------------------------------------------------------+
    // | @ 2019 incadea Taiwan Limited                                |
    // +--------------------------------------------------------------+
    // | PURPOSE: MARS_TWN                                            |
    // |                                                              |
    // | REMARK :                                                     |
    // +--------------------------------------------------------------+
    // 
    // VERSION       ID            WHO    DATE        DESCRIPTION
    // RGS_TWN-833   119130        GY     2019-04-08  New Object
    // RGS_TWN-833   119130        WP     2019-05-13  Add colum
    //                                    2019-07-08  Modify service Center count logic
    // MARS_TWN_7690121391        GG     2020-03-03  Add new Indicator '外島' and modify '台北市+新北市' and '花蓮+台東'
    DefaultLayout = RDLC;
    RDLCLayout = './Report/TWMainDashboard.rdlc';

    Caption = 'Main Dashboard';

    dataset
    {
        dataitem(Integer_Root; Integer)
        {
            DataItemTableView = SORTING(Number)
                                ORDER(Ascending)
                                WHERE(Number = CONST(1));
            column(CurrentMonth_Tyre_Overall; R(CurrentMonthAllBrandBufferG."Tyre Amount"))
            {
            }
            column(LastPeriodMonth_Tyre_Overall; R(LastPeriodAllBrandCurrentMonthBufferG."Tyre Amount"))
            {
            }
            column(YTD_Tyre_Overall; R(YTDAllBrandBufferG."Tyre Amount"))
            {
            }
            column(LastPeriodYTD_Tyre_Overall; R(LastPeriodYTDAllBrandBufferG."Tyre Amount"))
            {
            }
            column(CurrentMonth_Tyre_By_POS; R(GetDivideV(CurrentMonthAllBrandBufferG."Tyre Amount", ServiceCenterCountG[1])))
            {
            }
            column(LastPeriodMonth_Tyre_By_POS; R(GetDivideV(LastPeriodAllBrandCurrentMonthBufferG."Tyre Amount", ServiceCenterCountG[2])))
            {
            }
            column(YTD_Tyre_By_POS; R(GetDivideV(YTDAllBrandBufferG."Tyre Amount", ServiceCenterCountG[3])))
            {
            }
            column(LastPeriodYTD_Tyre_By_POS; R(GetDivideV(LastPeriodYTDAllBrandBufferG."Tyre Amount", ServiceCenterCountG[4])))
            {
            }
            column(CurrentMonth_NTP_Overall; R(CurrentMonthAllBrandBufferG."NTP Amount"))
            {
            }
            column(LastPeriodMonth_NTP_Overall; R(LastPeriodAllBrandCurrentMonthBufferG."NTP Amount"))
            {
            }
            column(YTD_NTP_Overall; R(YTDAllBrandBufferG."NTP Amount"))
            {
            }
            column(LastPeriodYTD_NTP_Overall; R(LastPeriodYTDAllBrandBufferG."NTP Amount"))
            {
            }
            column(CurrentMonth_NTP_By_POS; R(GetDivideV(CurrentMonthAllBrandBufferG."NTP Amount", ServiceCenterCountG[1])))
            {
            }
            column(LastPeriodMonth_NTP_By_POS; R(GetDivideV(LastPeriodAllBrandCurrentMonthBufferG."NTP Amount", ServiceCenterCountG[2])))
            {
            }
            column(YTD_NTP_By_POS; R(GetDivideV(YTDAllBrandBufferG."NTP Amount", ServiceCenterCountG[3])))
            {
            }
            column(LastPeriodYTD_NTP_By_POS; R(GetDivideV(LastPeriodYTDAllBrandBufferG."NTP Amount", ServiceCenterCountG[4])))
            {
            }
            column(CurrentMonth_Overall_Count; R(CurrentMonthAllBrandBufferG."Overall Count"))
            {
            }
            column(LastPeriodMonth_Overall_Count; R(LastPeriodAllBrandCurrentMonthBufferG."Overall Count"))
            {
            }
            column(YTD_Overall_Count; R(YTDAllBrandBufferG."Overall Count"))
            {
            }
            column(LastPeriodYTD_Overall_Count; R(LastPeriodYTDAllBrandBufferG."Overall Count"))
            {
            }
            column(CurrentMonth_Overall_By_POS; R(GetDivideV(CurrentMonthAllBrandBufferG."Overall Count", ServiceCenterCountG[1])))
            {
            }
            column(LastPeriodMonth_Overall_By_POS; R(GetDivideV(LastPeriodAllBrandCurrentMonthBufferG."Overall Count", ServiceCenterCountG[2])))
            {
            }
            column(YTD_Overall_By_POS; R(GetDivideV(YTDAllBrandBufferG."Overall Count", ServiceCenterCountG[3])))
            {
            }
            column(LastPeriodYTD_Overall_By_POS; R(GetDivideV(LastPeriodYTDAllBrandBufferG."Overall Count", ServiceCenterCountG[4])))
            {
            }
            column(CurrentMonth_MI_BFG; R(GetDivideV(CurrentMonthAllBrandBufferG."MI or BFG Total Quantity", CurrentMonthAllBrandBufferG."Tyre Total Quantity")))
            {
            }
            column(LastPeriodMonth_MI_BFG; R(GetDivideV(LastPeriodAllBrandCurrentMonthBufferG."MI or BFG Total Quantity", LastPeriodAllBrandCurrentMonthBufferG."Tyre Total Quantity")))
            {
            }
            column(YTD_MI_BFG; R(GetDivideV(YTDAllBrandBufferG."MI or BFG Total Quantity", YTDAllBrandBufferG."Tyre Total Quantity")))
            {
            }
            column(LastPeriodYTD_MI_BFG; R(GetDivideV(LastPeriodYTDAllBrandBufferG."MI or BFG Total Quantity", LastPeriodYTDAllBrandBufferG."Tyre Total Quantity")))
            {
            }
            column(CurrentMonth_Tyre_Total_Quantity; R(CurrentMonthAllBrandBufferG."Tyre Total Quantity"))
            {
            }
            column(LastPeriodMonth_Tyre_Total_Quantity; R(LastPeriodAllBrandCurrentMonthBufferG."Tyre Total Quantity"))
            {
            }
            column(YTD_Tyre_Total_Quantity; R(YTDAllBrandBufferG."Tyre Total Quantity"))
            {
            }
            column(LastPeriodYTD_Tyre_Total_Quantity; R(LastPeriodYTDAllBrandBufferG."Tyre Total Quantity"))
            {
            }
            column(CurrentMonth_Lub; R(GetDivideV(CurrentMonthAllBrandBufferG."Lub Total Quantity", CurrentMonthAllBrandBufferG."Lub Deno Total Quantity")))
            {
            }
            column(LastPeriodMonth_Lub; R(GetDivideV(LastPeriodAllBrandCurrentMonthBufferG."Lub Total Quantity", LastPeriodAllBrandCurrentMonthBufferG."Lub Deno Total Quantity")))
            {
            }
            column(YTD_Lub; R(GetDivideV(YTDAllBrandBufferG."Lub Total Quantity", YTDAllBrandBufferG."Lub Deno Total Quantity")))
            {
            }
            column(LastPeriodYTD_Lub; R(GetDivideV(LastPeriodYTDAllBrandBufferG."Lub Total Quantity", LastPeriodYTDAllBrandBufferG."Lub Deno Total Quantity")))
            {
            }
            column(CurrentMonth_Lub_Deno_Total_Quantiy; R(CurrentMonthAllBrandBufferG."Lub Deno Total Quantity"))
            {
            }
            column(LastPeriodMonth_Lub_Deno_Total_Quantiy; R(LastPeriodAllBrandCurrentMonthBufferG."Lub Deno Total Quantity"))
            {
            }
            column(YTD_Lub_Deno_Total_Quantiy; R(YTDAllBrandBufferG."Lub Deno Total Quantity"))
            {
            }
            column(LastPeriodYTD_Lub_Deno_Total_Quantiy; R(LastPeriodYTDAllBrandBufferG."Lub Deno Total Quantity"))
            {
            }
            column(CurrentMonth_Avg_Monthly_Traffic; R(GetDivideV(CurrentMonthAllBrandBufferG."Overall Count", ServiceCenterCountG[1])))
            {
            }
            column(LastPeriodMonth_Avg_Monthly_Traffic; R(GetDivideV(LastPeriodAllBrandCurrentMonthBufferG."Overall Count", ServiceCenterCountG[2])))
            {
            }
            column(YTD_Avg_Monthly_Traffic; R(GetDivideV(YTDAllBrandBufferG."Overall Count", ServiceCenterCountG[3])))
            {
            }
            column(LastPeriodYTD_Avg_Monthly_Traffic; R(GetDivideV(LastPeriodYTDAllBrandBufferG."Overall Count", ServiceCenterCountG[4])))
            {
            }
            column(CurrentMonthPosCountG; R(GetDivideV(CurrentMonthPosCountG, ServiceCenterCountG[1])))
            {
            }
            column(LastPeriodMonthPosCountG; R(GetDivideV(LastPeriodMonthPosCountG, ServiceCenterCountG[2])))
            {
            }
            column(YTDPosCountG; R(GetDivideV(YTDPosCountG, ServiceCenterCountG[3])))
            {
            }
            column(LastPeriodYTDPosCountG; R(GetDivideV(LastPeriodYTDPosCountG, ServiceCenterCountG[4])))
            {
            }

            trigger OnAfterGetRecord()
            begin
                //All Brand
                CurrentMonthAllBrandBufferG.RESET;
                CurrentMonthAllBrandBufferG.SETRANGE("Posting Date", CurrentMonthStartDateG, CurrentMonthEndDateG);
                // Start 119130
                CLEAR(ServiceCenterCountG);
                IF CurrentMonthAllBrandBufferG.FINDSET THEN
                    REPEAT
                        CurrentMonthAllBrandBufferG.SETRANGE("Service Center", CurrentMonthAllBrandBufferG."Service Center");
                        ServiceCenterCountG[1] += 1;
                        CurrentMonthAllBrandBufferG.FINDLAST;
                        CurrentMonthAllBrandBufferG.SETRANGE("Service Center");
                    UNTIL CurrentMonthAllBrandBufferG.NEXT = 0;
                // Stop  119130
                CurrentMonthAllBrandBufferG.CALCSUMS("Tyre Amount",
                "NTP Amount",
                "Overall Count",
                "Tyre Total Quantity",
                "MI or BFG Total Quantity",
                "Lub Total Quantity",
                "Lub Deno Total Quantity",
                "POS Count");


                LastPeriodAllBrandCurrentMonthBufferG.RESET;
                LastPeriodAllBrandCurrentMonthBufferG.SETRANGE("Posting Date", LastPeriodCMStartDateG, LastPeriodCMEndDateG);
                // Start 119130
                IF LastPeriodAllBrandCurrentMonthBufferG.FINDSET THEN
                    REPEAT
                        LastPeriodAllBrandCurrentMonthBufferG.SETRANGE("Service Center", LastPeriodAllBrandCurrentMonthBufferG."Service Center");
                        ServiceCenterCountG[2] += 1;
                        LastPeriodAllBrandCurrentMonthBufferG.FINDLAST;
                        LastPeriodAllBrandCurrentMonthBufferG.SETRANGE("Service Center");
                    UNTIL LastPeriodAllBrandCurrentMonthBufferG.NEXT = 0;
                // Stop  119130
                LastPeriodAllBrandCurrentMonthBufferG.CALCSUMS("Tyre Amount",
                "NTP Amount",
                "Overall Count",
                "Tyre Total Quantity",
                "MI or BFG Total Quantity",
                "Lub Total Quantity",
                "Lub Deno Total Quantity",
                "POS Count");

                YTDAllBrandBufferG.RESET;
                YTDAllBrandBufferG.SETRANGE("Posting Date", YTDStartDateG, YTDEndDateG);
                // Start 119130
                IF YTDAllBrandBufferG.FINDSET THEN
                    REPEAT
                        YTDAllBrandBufferG.SETRANGE("Service Center", YTDAllBrandBufferG."Service Center");
                        ServiceCenterCountG[3] += 1;
                        YTDAllBrandBufferG.FINDLAST;
                        YTDAllBrandBufferG.SETRANGE("Service Center");
                    UNTIL YTDAllBrandBufferG.NEXT = 0;
                // Stop  119130
                YTDAllBrandBufferG.CALCSUMS("Tyre Amount",
                "NTP Amount",
                "Overall Count",
                "Tyre Total Quantity",
                "MI or BFG Total Quantity",
                "Lub Total Quantity",
                "Lub Deno Total Quantity",
                "POS Count");

                LastPeriodYTDAllBrandBufferG.RESET;
                LastPeriodYTDAllBrandBufferG.SETRANGE("Posting Date", YTDLastPeriodStartDateG, YTDLastPeriodEndDateG);
                // Start 119130
                IF LastPeriodYTDAllBrandBufferG.FINDSET THEN
                    REPEAT
                        LastPeriodYTDAllBrandBufferG.SETRANGE("Service Center", LastPeriodYTDAllBrandBufferG."Service Center");
                        ServiceCenterCountG[4] += 1;
                        LastPeriodYTDAllBrandBufferG.FINDLAST;
                        LastPeriodYTDAllBrandBufferG.SETRANGE("Service Center");
                    UNTIL LastPeriodYTDAllBrandBufferG.NEXT = 0;
                // Stop  119130
                LastPeriodYTDAllBrandBufferG.CALCSUMS("Tyre Amount",
                "NTP Amount",
                "Overall Count",
                "Tyre Total Quantity",
                "MI or BFG Total Quantity",
                "Lub Total Quantity",
                "Lub Deno Total Quantity",
                "POS Count");
            end;
        }
        dataitem(Integer; Integer)
        {
            DataItemTableView = SORTING(Number);
            column(IndicatorG; TempServiceCenterG.Code)
            {
            }
            column(CurrentMonth_Tyre_Amount; R(CurrentMonthTyreAmountG))
            {
            }
            column(LastPeriod_Tyre_Amount; R(LastPeriodMonthTyreAmountG))
            {
            }
            column(YTD_Tyre_Amount; R(YTDTyreAmountG))
            {
            }
            column(LastPeriodYTD_Tyre_Amount; R(LastPeriodYTDTyreAmountG))
            {
            }
            column(CurrentMonth_NTP_Amount; R(CurrentMonthServCenterBufferG."NTP Amount"))
            {
            }
            column(LastPeriod_NTP_Amount; R(LastPeriodServCenterCurrentMonthBufferG."NTP Amount"))
            {
            }
            column(YTD_NTP_Amount; R(YTDServCenterBufferG."NTP Amount"))
            {
            }
            column(LastPeriodYTD_NTP_Amount; R(LastPeriodYTDServCenterBufferG."NTP Amount"))
            {
            }
            column(CurrentMonth_OverallCount; R(CurrentMonthOverallCountG))
            {
            }
            column(LastPeriod_OverallCount; R(LastPeriodMonthOverallCountG))
            {
            }
            column(YTD_OverallCount; R(YTDOverallCountG))
            {
            }
            column(LastPeriodYTD_OverallCount; R(LastPeriodYTDOverallCountG))
            {
            }

            trigger OnAfterGetRecord()
            var
                ServCenterFilterL: Text;
            begin
                IF Number = 1 THEN
                    TempServiceCenterG.FINDFIRST
                ELSE
                    TempServiceCenterG.NEXT;

                CurrentMonthTyreAmountG := 0;
                CurrentMonthOverallCountG := 0;
                LastPeriodMonthTyreAmountG := 0;
                LastPeriodMonthOverallCountG := 0;
                YTDTyreAmountG := 0;
                YTDOverallCountG := 0;
                LastPeriodYTDTyreAmountG := 0;
                LastPeriodYTDOverallCountG := 0;

                ConvertIndicator2ServCenter(TempServiceCenterG.Code, ServCenterFilterL);
                // Service Center
                MainDashboardBufferG.RESET;
                MainDashboardBufferG.SETRANGE("Posting Date", CurrentMonthStartDateG, CurrentMonthEndDateG);
                MainDashboardBufferG.SETFILTER("Service Center", ServCenterFilterL);
                IF MainDashboardBufferG.FINDFIRST THEN BEGIN
                    REPEAT
                        CurrentMonthTyreAmountG += MainDashboardBufferG."Tyre Amount";
                        CurrentMonthOverallCountG += MainDashboardBufferG."Overall Count";
                    UNTIL MainDashboardBufferG.NEXT = 0;
                END;
                MainDashboardBufferG.SETRANGE("Posting Date", LastPeriodCMStartDateG, LastPeriodCMEndDateG);
                IF MainDashboardBufferG.FINDFIRST THEN BEGIN
                    REPEAT
                        LastPeriodMonthTyreAmountG += MainDashboardBufferG."Tyre Amount";
                        LastPeriodMonthOverallCountG += MainDashboardBufferG."Overall Count";
                    UNTIL MainDashboardBufferG.NEXT = 0;
                END;
                MainDashboardBufferG.SETRANGE("Posting Date", YTDStartDateG, YTDEndDateG);
                IF MainDashboardBufferG.FINDFIRST THEN BEGIN
                    REPEAT
                        YTDTyreAmountG += MainDashboardBufferG."Tyre Amount";
                        YTDOverallCountG += MainDashboardBufferG."Overall Count";
                    UNTIL MainDashboardBufferG.NEXT = 0;
                END;
                MainDashboardBufferG.SETRANGE("Posting Date", YTDLastPeriodStartDateG, YTDLastPeriodEndDateG);
                IF MainDashboardBufferG.FINDFIRST THEN BEGIN
                    REPEAT
                        LastPeriodYTDTyreAmountG += MainDashboardBufferG."Tyre Amount";
                        LastPeriodYTDOverallCountG += MainDashboardBufferG."Overall Count";
                    UNTIL MainDashboardBufferG.NEXT = 0;
                END;
            end;

            trigger OnPreDataItem()
            begin
                SETRANGE(Number, 1, TempServiceCenterG.COUNT);
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(CalEndDateG; CalEndDateG)
                {
                    Caption = 'Calculate End Date';

                    trigger OnValidate()
                    begin
                        IF CalEndDateG > 0D THEN
                            CalEndDateG := CALCDATE('-CM', CalEndDateG);
                    end;
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
        IndicatorLbl = 'Indicator';
        MonthLbl = 'Month';
        LastYearMonthLbl = 'Y-1';
        RateMonthvsLastYearMonthLbl = 'Month vs Y-1';
        YTDLbl = 'YTD';
        LastYearYTDLbl = 'Y-1';
        RateYTDvsLastYearYTDLbl = 'YTD vs Y-1';
        Tyre_OverallLbl = 'Tyre Overall';
        Tyre_by_POSLbl = 'Tyre by POS';
        NTP_OverallLbl = 'NTP_Overall';
        NTP_By_POSLbl = 'NTP_by POS';
        OverallLbl = 'Overall';
        Monthly_Traffic_by_POSLbl = 'Monthly Traffic_by POS';
        Tyre_MI_BFGLbl = 'Tyre (MI + BFG)';
        LubLbl = 'Lub.';
        Avg_monthly_trafficLbl = 'Avg. monthly traffic';
        Stable_userLbl = '% of stable user';
        Report_usageLbl = 'Report usage';
        C_Lab_Other = 'Other';
    }

    trigger OnPreReport()
    begin
        ClearVars;
        EndDateG := TODAY;
        // Start 119130
        IF CalEndDateG = 0D THEN
            CalEndDateG := CALCDATE('-1M', WORKDATE);
        //CurrentMonthStartDateG := DMY2DATE(1,DATE2DMY(WORKDATE,2),DATE2DMY(WORKDATE,3));
        //CurrentMonthStartDateG := CALCDATE('-1M', CurrentMonthStartDateG);
        //CurrentMonthEndDateG := CALCDATE('-CM',WORKDATE);
        //CurrentMonthEndDateG := CALCDATE('-1D', CurrentMonthEndDateG);
        CurrentMonthStartDateG := DMY2DATE(1, DATE2DMY(CalEndDateG, 2), DATE2DMY(CalEndDateG, 3));
        CurrentMonthEndDateG := CALCDATE('CM', CalEndDateG);
        // Stop  119130

        LastPeriodCMStartDateG := CALCDATE('-1Y', CurrentMonthStartDateG);
        LastPeriodCMEndDateG := CALCDATE('-1Y', CurrentMonthEndDateG);
        // Start 119130
        //YTDStartDateG := DMY2DATE(1,1,DATE2DMY(WORKDATE,3));
        YTDStartDateG := DMY2DATE(1, 1, DATE2DMY(CalEndDateG, 3));
        // Stop  119130
        YTDEndDateG := CurrentMonthEndDateG;
        YTDLastPeriodStartDateG := CALCDATE('-1Y', YTDStartDateG);
        YTDLastPeriodEndDateG := CALCDATE('-1Y', YTDEndDateG);

        CLEAR(ServiceCenterG);
        ServiceCenterG.RESET;
        // Start 119130
        //ServiceCenterCountG := ServiceCenterG.COUNT;
        // Stop  119130
        // Pos Count
        IF ServiceCenterG.FINDFIRST THEN
            REPEAT
                PosCountCalc(ServiceCenterG);
                ConvertServCenter2Indicator(ServiceCenterG.Code);
            UNTIL ServiceCenterG.NEXT = 0;
    end;

    var
        MainDashboardBufferG: Record "TW Main Dashboard Buffer";
        TempMainDashboardBufferG: Record "TW Main Dashboard Buffer" temporary;
        CurrentMonthStartDateG: Date;
        CurrentMonthEndDateG: Date;
        LastPeriodCMStartDateG: Date;
        LastPeriodCMEndDateG: Date;
        YTDStartDateG: Date;
        YTDEndDateG: Date;
        YTDLastPeriodStartDateG: Date;
        YTDLastPeriodEndDateG: Date;
        StartDateG: Date;
        EndDateG: Date;
        ServiceCenterG: Record "Service Center";
        ServiceCenterCountG: array[4] of Integer;
        CurrentMonthAllBrandBufferG: Record "TW Main Dashboard Buffer";
        LastPeriodAllBrandCurrentMonthBufferG: Record "TW Main Dashboard Buffer";
        YTDAllBrandBufferG: Record "TW Main Dashboard Buffer";
        LastPeriodYTDAllBrandBufferG: Record "TW Main Dashboard Buffer";
        CurrentMonthServCenterBufferG: Record "TW Main Dashboard Buffer";
        LastPeriodServCenterCurrentMonthBufferG: Record "TW Main Dashboard Buffer";
        YTDServCenterBufferG: Record "TW Main Dashboard Buffer";
        LastPeriodYTDServCenterBufferG: Record "TW Main Dashboard Buffer";
        IndicatorG: Text;
        CurrentMonthPosCountG: Integer;
        LastPeriodMonthPosCountG: Integer;
        YTDPosCountG: Integer;
        LastPeriodYTDPosCountG: Integer;
        ServCenterCodeFilterG: Text;
        TempServiceCenterG: Record "Service Center" temporary;
        CurrentMonthTyreAmountG: Decimal;
        LastPeriodMonthTyreAmountG: Decimal;
        YTDTyreAmountG: Decimal;
        LastPeriodYTDTyreAmountG: Decimal;
        CurrentMonthOverallCountG: Decimal;
        LastPeriodMonthOverallCountG: Decimal;
        YTDOverallCountG: Decimal;
        LastPeriodYTDOverallCountG: Decimal;
        CalEndDateG: Date;

    local procedure R(DecToRoundP: Decimal): Decimal
    begin
        EXIT(ROUND(DecToRoundP, 0.01));
    end;

    local procedure ClearVars()
    begin
        CLEAR(CurrentMonthAllBrandBufferG);
        CLEAR(LastPeriodAllBrandCurrentMonthBufferG);
        CLEAR(YTDAllBrandBufferG);
        CLEAR(LastPeriodYTDAllBrandBufferG);
        TempServiceCenterG.RESET;
        TempServiceCenterG.DELETEALL;
        CurrentMonthPosCountG := 0;
        LastPeriodMonthPosCountG := 0;
        YTDPosCountG := 0;
        LastPeriodYTDPosCountG := 0;
    end;

    local procedure ConvertServCenter2Indicator(ServiceCenterCodeP: Code[10])
    var
        ServCenterL: Record "Service Center";
        PostCodeL: Code[20];
        ServCenterCodeFilterL: Text;
    begin
        IndicatorG := '';
        IF ServCenterL.GET(ServiceCenterCodeP) THEN BEGIN
            PostCodeL := ServCenterL."Post Code";
            IF (PostCodeL IN ['260', '261', '262', '263', '264', '265', '266', '267', '268', '269', '270', '272', '290']) THEN BEGIN
                IndicatorG := '宜蘭';
                TempIndicator(IndicatorG);
            END;
            // Start 121391
            IF PostCodeL IN ['970', '971', '972', '973', '974', '975', '976', '977', '978', '979', '981', '982', '983',
              '950', '951', '952', '953', '954', '955', '956', '957', '958', '959', '961', '962', '963', '964', '965', '966'] THEN BEGIN
                IndicatorG := '花蓮+台東';
                TempIndicator(IndicatorG);
            END;
            IF PostCodeL IN ['100', '103', '104', '105', '106', '108', '110', '111', '112', '114', '115', '116',
              '200', '201', '202', '203', '204', '205', '206', '207', '208',
              '220', '221', '222', '223', '224', '226', '227', '228',
              '231', '232', '233', '234', '235', '236', '237', '238', '239',
              '241', '242', '243', '244', '247', '248', '249',
              '251', '252', '253'] THEN BEGIN
                IndicatorG := '台北市+新北市';
                TempIndicator(IndicatorG);
            END;
            // Stop 121391
            IF PostCodeL IN ['320', '324', '325', '326', '327', '328', '330', '333', '334', '335', '336', '337', '338'] THEN BEGIN
                IndicatorG := '桃園';
                TempIndicator(IndicatorG);
            END;
            IF PostCodeL IN ['300', '302', '303', '304', '305', '306', '307', '308', '310', '311', '312', '313', '314', '315', '350', '351', '352', '353', '354',
              '356', '357', '358', '360', '361', '362', '363', '364', '365', '366', '367', '368', '369'] THEN BEGIN
                IndicatorG := '新竹+苗栗';
                TempIndicator(IndicatorG);
            END;
            IF PostCodeL IN ['400', '401', '402', '403', '404', '406', '407', '408', '411', '412', '413', '414', '420', '421', '422', '423', '424', '426', '427', '428',
              '429', '432', '433', '434', '435', '436', '437', '438', '439', '500', '502', '503', '504', '505', '506', '507', '508', '509', '510', '511', '512', '513',
              '514', '515', '516', '520', '521', '522', '523', '524', '525', '526', '527', '528', '530', '540', '541', '542', '544', '545', '546', '551', '552', '553',
              '555', '556', '557', '558'] THEN BEGIN
                IndicatorG := '台中+彰化+南投';
                TempIndicator(IndicatorG);
            END;
            IF PostCodeL IN ['600', '602', '603', '604', '605', '606', '607', '608', '611', '612', '613', '614', '615', '616', '621', '622', '623', '624', '625', '630', '631',
              '632', '633', '634', '635', '636', '637', '638', '640', '643', '646', '647', '648', '649', '651', '652', '653', '654', '655'] THEN BEGIN
                IndicatorG := '雲林+嘉義';
                TempIndicator(IndicatorG);
            END;
            IF PostCodeL IN ['700', '701', '702', '704', '708', '709', '710', '712', '713', '714', '715', '716', '717', '718', '719', '720', '721', '722', '723', '724', '725',
              '726', '727', '730', '731', '732', '733', '734', '735', '736', '737', '741', '742', '743', '744', '745'] THEN BEGIN
                IndicatorG := '台南';
                TempIndicator(IndicatorG);
            END;
            IF PostCodeL IN ['800', '801', '802', '803', '804', '805', '806', '807', '811', '812', '813', '814', '815', '820', '821', '822', '823', '824', '825', '826', '827', '828',
              '829', '830', '831', '832', '833', '840', '842', '843', '844', '845', '846', '847', '848', '849', '851', '852', '900', '901', '902', '903', '904', '905', '906',
              '907', '908', '909', '911', '912', '913', '920', '921', '922', '923', '924', '925', '926', '927', '928', '929', '931', '932', '940', '941', '942', '943', '944', '945', '946', '947'] THEN BEGIN
                IndicatorG := '高雄+屏東';
                TempIndicator(IndicatorG);
            END;
            // Start 121391
            IF PostCodeL IN ['817', '819', '880', '881', '882', '883', '884', '885', '890', '891', '892', '893', '894', '896', '209', '210', '211', '212'] THEN BEGIN
                IndicatorG := '外島';
                TempIndicator(IndicatorG);
            END;
            // Stop 121391
        END;
    end;

    local procedure PosCountCalc(ServCenterP: Record "Service Center")
    var
        TWMainDashboardBufferL: Record "TW Main Dashboard Buffer";
    begin
        TWMainDashboardBufferL.RESET;
        TWMainDashboardBufferL.SETRANGE("Service Center", ServCenterP.Code);
        TWMainDashboardBufferL.SETRANGE("Posting Date", CurrentMonthStartDateG, CurrentMonthEndDateG);
        TWMainDashboardBufferL.CALCSUMS("Overall Count");
        IF TWMainDashboardBufferL."Overall Count" > 100 THEN
            CurrentMonthPosCountG += 1;
        TWMainDashboardBufferL.SETRANGE("Posting Date", LastPeriodCMStartDateG, LastPeriodCMEndDateG);
        TWMainDashboardBufferL.CALCSUMS("Overall Count");
        IF TWMainDashboardBufferL."Overall Count" > 100 THEN
            LastPeriodMonthPosCountG += 1;
        TWMainDashboardBufferL.SETRANGE("Posting Date", YTDStartDateG, YTDEndDateG);
        TWMainDashboardBufferL.CALCSUMS("Overall Count");
        IF TWMainDashboardBufferL."Overall Count" > 100 THEN
            YTDPosCountG += 1;
        TWMainDashboardBufferL.SETRANGE("Posting Date", YTDLastPeriodStartDateG, YTDLastPeriodEndDateG);
        TWMainDashboardBufferL.CALCSUMS("Overall Count");
        IF TWMainDashboardBufferL."Overall Count" > 100 THEN
            LastPeriodYTDPosCountG += 1;
    end;

    local procedure GetDivideV(OriginalValueP: Decimal; NewValueP: Decimal): Decimal
    begin
        //IF NewValueP = 0 THEN
        //  EXIT(1)
        //ELSE
        //  EXIT(OriginalValueP/NewValueP);
        IF (OriginalValueP = 0) AND (NewValueP = 0) THEN
            EXIT(0);
        IF (OriginalValueP > 0) AND (NewValueP = 0) THEN
            EXIT(1);
        IF (OriginalValueP < 0) AND (NewValueP = 0) THEN
            EXIT(-1);
        EXIT(OriginalValueP / NewValueP);
    end;

    local procedure ConvertIndicator2ServCenter(IndicatorP: Text; var ServCenterFilterP: Text)
    var
        ServCenterL: Record "Service Center";
        PostCodeL: Code[20];
        ServCenterCodeFilterL: Text;
    begin
        IF IndicatorP = '宜蘭' THEN BEGIN
            ServCenterL.RESET;
            ServCenterL.SETFILTER("Post Code", '260|261|262|263|264|265|266|267|268|269|270|272|290');
            IF ServCenterL.FINDFIRST THEN
                REPEAT
                    ServCenterFilterP += ServCenterL.Code + '|';
                UNTIL ServCenterL.NEXT = 0;
            ServCenterFilterP := COPYSTR(ServCenterFilterP, 1, STRLEN(ServCenterFilterP) - 1);
        END;
        // Start 121391
        IF IndicatorP = '花蓮+台東' THEN BEGIN
            ServCenterL.RESET;
            ServCenterL.SETFILTER("Post Code", '970|971|972|973|974|975|976|977|978|979|981|982|983|950|951|952|953|954|955|956|957|958|959|961|962|963|964|965|966');
            IF ServCenterL.FINDFIRST THEN
                REPEAT
                    ServCenterFilterP += ServCenterL.Code + '|';
                UNTIL ServCenterL.NEXT = 0;
            ServCenterFilterP := COPYSTR(ServCenterFilterP, 1, STRLEN(ServCenterFilterP) - 1);
        END;
        IF IndicatorP = '台北市+新北市' THEN BEGIN
            ServCenterL.RESET;
            ServCenterL.SETFILTER("Post Code", '100|103|104|105|106|108|110|111|112|114|115|116|200|201|202|203|204|205|206|207|208|220|221|222|223|224|226|227|228|231|232|233|234|235|236|237|238|239|241|242|243|244|247|248|249|251|252|253');
            IF ServCenterL.FINDFIRST THEN
                REPEAT
                    ServCenterFilterP += ServCenterL.Code + '|';
                UNTIL ServCenterL.NEXT = 0;
            ServCenterFilterP := COPYSTR(ServCenterFilterP, 1, STRLEN(ServCenterFilterP) - 1);
        END;
        // Stop 121391
        IF IndicatorP = '桃園' THEN BEGIN
            ServCenterL.RESET;
            ServCenterL.SETFILTER("Post Code", '320|324|325|326|327|328|330|333|334|335|336|337|338');
            IF ServCenterL.FINDFIRST THEN
                REPEAT
                    ServCenterFilterP += ServCenterL.Code + '|';
                UNTIL ServCenterL.NEXT = 0;
            ServCenterFilterP := COPYSTR(ServCenterFilterP, 1, STRLEN(ServCenterFilterP) - 1);
        END;
        IF IndicatorP = '新竹+苗栗' THEN BEGIN
            ServCenterL.RESET;
            ServCenterL.SETFILTER("Post Code", '300|302|303|304|305|306|307|308|310|311|312|313|314|315|350|351|352|353|354|356|357|358|360|361|362|363|364|365|366|367|368|369');
            IF ServCenterL.FINDFIRST THEN
                REPEAT
                    ServCenterFilterP += ServCenterL.Code + '|';
                UNTIL ServCenterL.NEXT = 0;
            ServCenterFilterP := COPYSTR(ServCenterFilterP, 1, STRLEN(ServCenterFilterP) - 1);
        END;
        IF IndicatorP = '台中+彰化+南投' THEN BEGIN
            ServCenterL.RESET;
            ServCenterL.SETFILTER("Post Code", '400|401|402|403|404|406|407|408|411|412|413|414|420|421|422|423|424|426|427|428|429|432|433|434|435|436|437|438' +
            '|439|500|502|503|504|505|506|507|508|509|510|511|512|513|514|515|516|520|521|522|523|524|525|526|527|528|530|540|541|542|544|545|546|551|552|553|555|556|557|558');
            IF ServCenterL.FINDFIRST THEN
                REPEAT
                    ServCenterFilterP += ServCenterL.Code + '|';
                UNTIL ServCenterL.NEXT = 0;
            ServCenterFilterP := COPYSTR(ServCenterFilterP, 1, STRLEN(ServCenterFilterP) - 1);
        END;
        IF IndicatorP = '雲林+嘉義' THEN BEGIN
            ServCenterL.RESET;
            ServCenterL.SETFILTER("Post Code", '600|602|603|604|605|606|607|608|611|612|613|614|615|616|621|622|623|624|625|630|631|632|633|634|635|636|637|638|640|643|646|647|648|649|651|652|653|654|655');
            IF ServCenterL.FINDFIRST THEN
                REPEAT
                    ServCenterFilterP += ServCenterL.Code + '|';
                UNTIL ServCenterL.NEXT = 0;
            ServCenterFilterP := COPYSTR(ServCenterFilterP, 1, STRLEN(ServCenterFilterP) - 1);
        END;
        IF IndicatorP = '台南' THEN BEGIN
            ServCenterL.RESET;
            ServCenterL.SETFILTER("Post Code", '700|701|702|704|708|709|710|711|712|713|714|715|716|717|718|719|720|721|722|723|724|725|726|727|730|731|732|733|734|735|736|737|741|742|743|744|745');
            IF ServCenterL.FINDFIRST THEN
                REPEAT
                    ServCenterFilterP += ServCenterL.Code + '|';
                UNTIL ServCenterL.NEXT = 0;
            ServCenterFilterP := COPYSTR(ServCenterFilterP, 1, STRLEN(ServCenterFilterP) - 1);
        END;
        IF IndicatorP = '高雄+屏東' THEN BEGIN
            ServCenterL.RESET;
            ServCenterL.SETFILTER("Post Code", '800|801|802|803|804|805|806|807|811|812|813|814|815|820|821|822|823|824|825|826|827|828|829|830|831|832|833|840|842|843|844|845|846|847|848|849|851' +
            '|852|900|901|902|903|904|905|906|907|908|909|911|912|913|920|921|922|923|924|925|926|927|928|929|931|932|940|941|942|943|944|945|946|947');
            IF ServCenterL.FINDFIRST THEN
                REPEAT
                    ServCenterFilterP += ServCenterL.Code + '|';
                UNTIL ServCenterL.NEXT = 0;
            ServCenterFilterP := COPYSTR(ServCenterFilterP, 1, STRLEN(ServCenterFilterP) - 1);
        END;
        // Start 121391
        IF IndicatorP = '外島' THEN BEGIN
            ServCenterL.RESET;
            ServCenterL.SETFILTER("Post Code", '817|819|880|881|882|883|884|885|890|891|892|893|894|896|209|210|211|212');
            IF ServCenterL.FINDFIRST THEN
                REPEAT
                    ServCenterFilterP += ServCenterL.Code + '|';
                UNTIL ServCenterL.NEXT = 0;
            ServCenterFilterP := COPYSTR(ServCenterFilterP, 1, STRLEN(ServCenterFilterP) - 1);
        END;
        // Stop 121391
    end;

    local procedure TempIndicator(IndicatorP: Text)
    begin
        IF NOT TempServiceCenterG.GET(IndicatorP) THEN BEGIN
            TempServiceCenterG.Code := IndicatorP;
            TempServiceCenterG.INSERT;
        END;
    end;
}

