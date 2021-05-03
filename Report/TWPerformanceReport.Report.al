report 50039 "TW Performance Report"
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
    // RGS_TWN-809   118849        GG     2019-03-13  New Object
    // RGS_TWN-832   119384        WP     2019-05-13  Add profit
    // RGS_TWN-837   119434        WP     2019-05-15  Add publisher OnPostReportEvent
    DefaultLayout = RDLC;
    RDLCLayout = './Report/TWPerformanceReport.rdlc';

    Caption = 'Performance Report';

    dataset
    {
        dataitem("Integer"; Integer)
        {
            DataItemTableView = SORTING(Number)
                                ORDER(Ascending);
            column(IntNumber; Integer.Number)
            {
            }
            column(ReportTitle; C_INC_002 + '(' + COPYSTR(CurrReport.OBJECTID(FALSE), 8) + ')')
            {
            }
            column(Picture_Company; CompanyInfoG.Picture)
            {
            }
            column(Name_Company; CompanyInfoG.Name + ' ' + CompanyInfoG."Name 2")
            {
            }
            column(CurrentDateTime; FORMAT(TODAY, 0, '<Year4>/<Month,2>/<Day,2>') + '  ' + FORMAT(TIME))
            {
            }
            column(PageCaption; C_INC_003)
            {
            }
            column(DatePeriodCaption; C_INC_004)
            {
            }
            column(ZoneCaption; C_INC_005)
            {
            }
            column(DealerCaption; C_INC_006)
            {
            }
            column(BranchCaption; C_INC_007)
            {
            }
            column(EvaluationRateCaption; C_INC_009)
            {
            }
            column(CurrentUSERID; USERID)
            {
            }
            column(DatePeriod; FORMAT(StartDateG) + '-' + FORMAT(EndDateG))
            {
            }
            column(ZoneNameG; ZoneNameG)
            {
            }
            column(DealerNameG; DealerNameG)
            {
            }
            column(BranchNameG; BranchNameG)
            {
            }
            column(DateCaption1; MonthNames(DATE2DMY(CurrMonthStartDateG, 2)) + FORMAT(DATE2DMY(CurrMonthStartDateG, 3)))
            {
            }
            column(DateCaption2; MonthNames(DATE2DMY(LastYearMonthStartDateG, 2)) + FORMAT(DATE2DMY(LastYearMonthStartDateG, 3)))
            {
            }
            column(DateCaption3; FORMAT(CurrPeriodStartDateG, 0, '<Year4>/<Month,2>/<Day,2>') + '..' + FORMAT(CurrPeriodEndDateG, 0, '<Year4>/<Month,2>/<Day,2>'))
            {
            }
            column(DateCaption4; FORMAT(LastPeriodStartDateG, 0, '<Year4>/<Month,2>/<Day,2>') + '..' + FORMAT(LastPeriodEndDateG, 0, '<Year4>/<Month,2>/<Day,2>'))
            {
            }
            column(NoofBays_Month; R(CurrMonthBufferG."No. of Bays"))
            {
            }
            column(TurnoverTotalAmount_Month; R(CurrMonthBufferG."Turnover Total Amount"))
            {
            }
            column(TurnoverTotalTyreAmount_Month; R(CurrMonthBufferG."Turnover Total Tyre Amount"))
            {
            }
            column(TurnoverTotalNonTyreAmount_Month; R(CurrMonthBufferG."Turnover Total NonTyre Amount"))
            {
            }
            column(TurnoverResourceAmount_Month; R(CurrMonthBufferG."Turnover Resource Amount"))
            {
            }
            column(GrossProfit_Month; R(CurrMonthBufferG."Gross Profit"))
            {
            }
            column(AverageBaysOutput_Month; R(CurrMonthBufferG."Average Bays Output"))
            {
            }
            column(AverageSaleryOutput_Month; R(CurrMonthBufferG."Average Salary Output"))
            {
            }
            column(SalesInvoiceCount_Month; R(CurrMonthBufferG."Sales Invoice Count"))
            {
            }
            column(SalesInvoiceCountTyre_Month; R(CurrMonthBufferG."Sales Invoice Count Tyre"))
            {
            }
            column(SalesInvoiceCountOilFilter_Month; R(CurrMonthBufferG."Sales Invoice Count Oil Filter"))
            {
            }
            column(SalesInvoiceCountOil_Month; R(CurrMonthBufferG."Sales Invoice Count Oil"))
            {
            }
            column(SalesInvoiceCountOilOrFilter_Month; R(CurrMonthBufferG."Sales Invoice Count Oil Or Fil"))
            {
            }
            column(SalesInvoiceCountOther_Month; R(CurrMonthBufferG."Sales Invoice Count Others"))
            {
            }
            column(NotifOrderCount_Month; R(CurrMonthBufferG."Notification Order Count"))
            {
            }
            column(NotifOrderAmount_Month; R(CurrMonthBufferG."Notification Order Amount"))
            {
            }
            column(VehicleCheckCount_Month; R(CurrMonthBufferG."Vehicle Check Order Count"))
            {
            }
            column(VehicleCheckAmt_Month; R(CurrMonthBufferG."Vehicle Check Order Amount"))
            {
            }
            column(CrossSalesCount_Month; R(CurrMonthBufferG."Cross Sales Order Count"))
            {
            }
            column(CrossSalesAmount_Month; R(CurrMonthBufferG."Cross Sales Order Amount"))
            {
            }
            column(TyreSalesQty_Month; R(CurrMonthBufferG."Tyre Sales Quantity"))
            {
            }
            column(BalanceQty_Month; R(CurrMonthBufferG."Resource Balance Quantity"))
            {
            }
            column(PCQty_Month; R(CurrMonthBufferG."Resource PC Quantity"))
            {
            }
            column(NoofBays_MonthLastYear; R(LastYearMonthBufferG."No. of Bays"))
            {
            }
            column(TurnoverTotalAmount_MonthLastYear; R(LastYearMonthBufferG."Turnover Total Amount"))
            {
            }
            column(TurnoverTotalTyreAmount_MonthLastYear; R(LastYearMonthBufferG."Turnover Total Tyre Amount"))
            {
            }
            column(TurnoverTotalNonTyreAmount_MonthLastYear; R(LastYearMonthBufferG."Turnover Total NonTyre Amount"))
            {
            }
            column(TurnoverResourceAmount_MonthLastYear; R(LastYearMonthBufferG."Turnover Resource Amount"))
            {
            }
            column(GrossProfit_MonthLastYear; R(LastYearMonthBufferG."Gross Profit"))
            {
            }
            column(AverageBaysOutput_MonthLastYear; R(LastYearMonthBufferG."Average Bays Output"))
            {
            }
            column(AverageSaleryOutput_MonthLastYear; R(LastYearMonthBufferG."Average Salary Output"))
            {
            }
            column(SalesInvoiceCount_MonthLastYear; R(LastYearMonthBufferG."Sales Invoice Count"))
            {
            }
            column(SalesInvoiceCountTyre_MonthLastYear; R(LastYearMonthBufferG."Sales Invoice Count Tyre"))
            {
            }
            column(SalesInvoiceCountOilFilter_MonthLastYear; R(LastYearMonthBufferG."Sales Invoice Count Oil Filter"))
            {
            }
            column(SalesInvoiceCountOil_MonthLastYear; R(LastYearMonthBufferG."Sales Invoice Count Oil"))
            {
            }
            column(SalesInvoiceCountOilOrFilter_MonthLastYear; R(LastYearMonthBufferG."Sales Invoice Count Oil Or Fil"))
            {
            }
            column(SalesInvoiceCountOther_MonthLastYear; R(LastYearMonthBufferG."Sales Invoice Count Others"))
            {
            }
            column(NotifOrderCount_MonthLastYear; R(LastYearMonthBufferG."Notification Order Count"))
            {
            }
            column(NotifOrderAmount_MonthLastYear; R(LastYearMonthBufferG."Notification Order Amount"))
            {
            }
            column(VehicleCheckCount_MonthLastYear; R(LastYearMonthBufferG."Vehicle Check Order Count"))
            {
            }
            column(VehicleCheckAmt_MonthLastYear; R(LastYearMonthBufferG."Vehicle Check Order Amount"))
            {
            }
            column(CrossSalesCount_MonthLastYear; R(LastYearMonthBufferG."Cross Sales Order Count"))
            {
            }
            column(CrossSalesAmount_MonthLastYear; R(LastYearMonthBufferG."Cross Sales Order Amount"))
            {
            }
            column(TyreSalesQty_MonthLastYear; R(LastYearMonthBufferG."Tyre Sales Quantity"))
            {
            }
            column(BalanceQty_MonthLastYear; R(LastYearMonthBufferG."Resource Balance Quantity"))
            {
            }
            column(PCQty_MonthLastYear; R(LastYearMonthBufferG."Resource PC Quantity"))
            {
            }
            column(NoofBays_MonthRate; R(TempMonthRateBufferG."No. of Bays"))
            {
            }
            column(TurnoverTotalAmount_MonthRate; R(TempMonthRateBufferG."Turnover Total Amount"))
            {
            }
            column(TurnoverTotalTyreAmount_MonthRate; R(TempMonthRateBufferG."Turnover Total Tyre Amount"))
            {
            }
            column(TurnoverTotalNonTyreAmount_MonthRate; R(TempMonthRateBufferG."Turnover Total NonTyre Amount"))
            {
            }
            column(TurnoverResourceAmount_MonthRate; R(TempMonthRateBufferG."Turnover Resource Amount"))
            {
            }
            column(GrossProfit_MonthRate; R(TempMonthRateBufferG."Gross Profit"))
            {
            }
            column(AverageBaysOutput_MonthRate; R(TempMonthRateBufferG."Average Bays Output"))
            {
            }
            column(AverageSaleryOutput_MonthRate; R(TempMonthRateBufferG."Average Salary Output"))
            {
            }
            column(SalesInvoiceCount_MonthRate; R(TempMonthRateBufferG."Sales Invoice Count"))
            {
            }
            column(SalesInvoiceCountTyre_MonthRate; R(TempMonthRateBufferG."Sales Invoice Count Tyre"))
            {
            }
            column(SalesInvoiceCountOilFilter_MonthRate; R(TempMonthRateBufferG."Sales Invoice Count Oil Filter"))
            {
            }
            column(SalesInvoiceCountOil_MonthRate; R(TempMonthRateBufferG."Sales Invoice Count Oil"))
            {
            }
            column(SalesInvoiceCountOilOrFilter_MonthRate; R(TempMonthRateBufferG."Sales Invoice Count Oil Or Fil"))
            {
            }
            column(SalesInvoiceCountOther_MonthRate; R(TempMonthRateBufferG."Sales Invoice Count Others"))
            {
            }
            column(NotifOrderCount_MonthRate; R(TempMonthRateBufferG."Notification Order Count"))
            {
            }
            column(NotifOrderAmount_MonthRate; R(TempMonthRateBufferG."Notification Order Amount"))
            {
            }
            column(VehicleCheckCount_MonthRate; R(TempMonthRateBufferG."Vehicle Check Order Count"))
            {
            }
            column(VehicleCheckAmt_MonthRate; R(TempMonthRateBufferG."Vehicle Check Order Amount"))
            {
            }
            column(CrossSalesCount_MonthRate; R(TempMonthRateBufferG."Cross Sales Order Count"))
            {
            }
            column(CrossSalesAmount_MonthRate; R(TempMonthRateBufferG."Cross Sales Order Amount"))
            {
            }
            column(TyreSalesQty_MonthRate; R(TempMonthRateBufferG."Tyre Sales Quantity"))
            {
            }
            column(BalanceQty_MonthRate; R(TempMonthRateBufferG."Resource Balance Quantity"))
            {
            }
            column(PCQty_MonthRate; R(TempMonthRateBufferG."Resource PC Quantity"))
            {
            }
            column(NoofBays_CurrPeriod; R(CurrPeriodBufferG."No. of Bays"))
            {
            }
            column(TurnoverTotalAmount_CurrPeriod; R(CurrPeriodBufferG."Turnover Total Amount"))
            {
            }
            column(TurnoverTotalTyreAmount_CurrPeriod; R(CurrPeriodBufferG."Turnover Total Tyre Amount"))
            {
            }
            column(TurnoverTotalNonTyreAmount_CurrPeriod; R(CurrPeriodBufferG."Turnover Total NonTyre Amount"))
            {
            }
            column(TurnoverResourceAmount_CurrPeriod; R(CurrPeriodBufferG."Turnover Resource Amount"))
            {
            }
            column(GrossProfit_CurrPeriod; R(CurrPeriodBufferG."Gross Profit"))
            {
            }
            column(AverageBaysOutput_CurrPeriod; R(CurrPeriodBufferG."Average Bays Output"))
            {
            }
            column(AverageSaleryOutput_CurrPeriod; R(CurrPeriodBufferG."Average Salary Output"))
            {
            }
            column(SalesInvoiceCount_CurrPeriod; R(CurrPeriodBufferG."Sales Invoice Count"))
            {
            }
            column(SalesInvoiceCountTyre_CurrPeriod; R(CurrPeriodBufferG."Sales Invoice Count Tyre"))
            {
            }
            column(SalesInvoiceCountOilFilter_CurrPeriod; R(CurrPeriodBufferG."Sales Invoice Count Oil Filter"))
            {
            }
            column(SalesInvoiceCountOil_CurrPeriod; R(CurrPeriodBufferG."Sales Invoice Count Oil"))
            {
            }
            column(SalesInvoiceCountOilOrFilter_CurrPeriod; R(CurrPeriodBufferG."Sales Invoice Count Oil Or Fil"))
            {
            }
            column(SalesInvoiceCountOther_CurrPeriod; R(CurrPeriodBufferG."Sales Invoice Count Others"))
            {
            }
            column(NotifOrderCount_CurrPeriod; R(CurrPeriodBufferG."Notification Order Count"))
            {
            }
            column(NotifOrderAmount_CurrPeriod; R(CurrPeriodBufferG."Notification Order Amount"))
            {
            }
            column(VehicleCheckCount_CurrPeriod; R(CurrPeriodBufferG."Vehicle Check Order Count"))
            {
            }
            column(VehicleCheckAmt_CurrPeriod; R(CurrPeriodBufferG."Vehicle Check Order Amount"))
            {
            }
            column(CrossSalesCount_CurrPeriod; R(CurrPeriodBufferG."Cross Sales Order Count"))
            {
            }
            column(CrossSalesAmount_CurrPeriod; R(CurrPeriodBufferG."Cross Sales Order Amount"))
            {
            }
            column(TyreSalesQty_CurrPeriod; R(CurrPeriodBufferG."Tyre Sales Quantity"))
            {
            }
            column(BalanceQty_CurrPeriod; R(CurrPeriodBufferG."Resource Balance Quantity"))
            {
            }
            column(PCQty_CurrPeriod; R(CurrPeriodBufferG."Resource PC Quantity"))
            {
            }
            column(NoofBays_PeriodLastYear; R(LastYearPeriodBufferG."No. of Bays"))
            {
            }
            column(TurnoverTotalAmount_PeriodLastYear; R(LastYearPeriodBufferG."Turnover Total Amount"))
            {
            }
            column(TurnoverTotalTyreAmount_PeriodLastYear; R(LastYearPeriodBufferG."Turnover Total Tyre Amount"))
            {
            }
            column(TurnoverTotalNonTyreAmount_PeriodLastYear; R(LastYearPeriodBufferG."Turnover Total NonTyre Amount"))
            {
            }
            column(TurnoverResourceAmount_PeriodLastYear; R(LastYearPeriodBufferG."Turnover Resource Amount"))
            {
            }
            column(GrossProfit_PeriodLastYear; R(LastYearPeriodBufferG."Gross Profit"))
            {
            }
            column(AverageBaysOutput_PeriodLastYear; R(LastYearPeriodBufferG."Average Bays Output"))
            {
            }
            column(AverageSaleryOutput_PeriodLastYear; R(LastYearPeriodBufferG."Average Salary Output"))
            {
            }
            column(SalesInvoiceCount_PeriodLastYear; R(LastYearPeriodBufferG."Sales Invoice Count"))
            {
            }
            column(SalesInvoiceCountTyre_PeriodLastYear; R(LastYearPeriodBufferG."Sales Invoice Count Tyre"))
            {
            }
            column(SalesInvoiceCountOilFilter_PeriodLastYear; R(LastYearPeriodBufferG."Sales Invoice Count Oil Filter"))
            {
            }
            column(SalesInvoiceCountOil_PeriodLastYear; R(LastYearPeriodBufferG."Sales Invoice Count Oil"))
            {
            }
            column(SalesInvoiceCountOilOrFilter_PeriodLastYear; R(LastYearPeriodBufferG."Sales Invoice Count Oil Or Fil"))
            {
            }
            column(SalesInvoiceCountOther_PeriodLastYear; R(LastYearPeriodBufferG."Sales Invoice Count Others"))
            {
            }
            column(NotifOrderCount_PeriodLastYear; R(LastYearPeriodBufferG."Notification Order Count"))
            {
            }
            column(NotifOrderAmount_PeriodLastYear; R(LastYearPeriodBufferG."Notification Order Amount"))
            {
            }
            column(VehicleCheckCount_PeriodLastYear; R(LastYearPeriodBufferG."Vehicle Check Order Count"))
            {
            }
            column(VehicleCheckAmt_PeriodLastYear; R(LastYearPeriodBufferG."Vehicle Check Order Amount"))
            {
            }
            column(CrossSalesCount_PeriodLastYear; R(LastYearPeriodBufferG."Cross Sales Order Count"))
            {
            }
            column(CrossSalesAmount_PeriodLastYear; R(LastYearPeriodBufferG."Cross Sales Order Amount"))
            {
            }
            column(TyreSalesQty_PeriodLastYear; R(LastYearPeriodBufferG."Tyre Sales Quantity"))
            {
            }
            column(BalanceQty_PeriodLastYear; R(LastYearPeriodBufferG."Resource Balance Quantity"))
            {
            }
            column(PCQty_PeriodLastYear; R(LastYearPeriodBufferG."Resource PC Quantity"))
            {
            }
            column(NoofBays_CurrPeriodRate; R(TempPeriodRateBufferG."No. of Bays"))
            {
            }
            column(TurnoverTotalAmount_CurrPeriodRate; R(TempPeriodRateBufferG."Turnover Total Amount"))
            {
            }
            column(TurnoverTotalTyreAmount_CurrPeriodRate; R(TempPeriodRateBufferG."Turnover Total Tyre Amount"))
            {
            }
            column(TurnoverTotalNonTyreAmount_CurrPeriodRate; R(TempPeriodRateBufferG."Turnover Total NonTyre Amount"))
            {
            }
            column(TurnoverResourceAmount_CurrPeriodRate; R(TempPeriodRateBufferG."Turnover Resource Amount"))
            {
            }
            column(GrossProfit_CurrPeriodRate; R(TempPeriodRateBufferG."Gross Profit"))
            {
            }
            column(AverageBaysOutput_CurrPeriodRate; R(TempPeriodRateBufferG."Average Bays Output"))
            {
            }
            column(AverageSaleryOutput_CurrPeriodRate; R(TempPeriodRateBufferG."Average Salary Output"))
            {
            }
            column(SalesInvoiceCount_CurrPeriodRate; R(TempPeriodRateBufferG."Sales Invoice Count"))
            {
            }
            column(SalesInvoiceCountTyre_CurrPeriodRate; R(TempPeriodRateBufferG."Sales Invoice Count Tyre"))
            {
            }
            column(SalesInvoiceCountOilFilter_CurrPeriodRate; R(TempPeriodRateBufferG."Sales Invoice Count Oil Filter"))
            {
            }
            column(SalesInvoiceCountOil_CurrPeriodRate; R(TempPeriodRateBufferG."Sales Invoice Count Oil"))
            {
            }
            column(SalesInvoiceCountOilOrFilter_CurrPeriodRate; R(TempPeriodRateBufferG."Sales Invoice Count Oil Or Fil"))
            {
            }
            column(SalesInvoiceCountOther_CurrPeriodRate; R(TempPeriodRateBufferG."Sales Invoice Count Others"))
            {
            }
            column(NotifOrderCount_CurrPeriodRate; R(TempPeriodRateBufferG."Notification Order Count"))
            {
            }
            column(NotifOrderAmount_CurrPeriodRate; R(TempPeriodRateBufferG."Notification Order Amount"))
            {
            }
            column(VehicleCheckCount_CurrPeriodRate; R(TempPeriodRateBufferG."Vehicle Check Order Count"))
            {
            }
            column(VehicleCheckAmt_CurrPeriodRate; R(TempPeriodRateBufferG."Vehicle Check Order Amount"))
            {
            }
            column(CrossSalesCount_CurrPeriodRate; R(TempPeriodRateBufferG."Cross Sales Order Count"))
            {
            }
            column(CrossSalesAmount_CurrPeriodRate; R(TempPeriodRateBufferG."Cross Sales Order Amount"))
            {
            }
            column(TyreSalesQty_CurrPeriodRate; R(TempPeriodRateBufferG."Tyre Sales Quantity"))
            {
            }
            column(BalanceQty_CurrPeriodRate; R(TempPeriodRateBufferG."Resource Balance Quantity"))
            {
            }
            column(PCQty_CurrPeriodRate; R(TempPeriodRateBufferG."Resource PC Quantity"))
            {
            }

            trigger OnAfterGetRecord()
            begin
                ClearVars;

                IF Number = 1 THEN
                    ServiceCenterG.FINDFIRST
                ELSE
                    ServiceCenterG.NEXT;

                ZoneDealerName(Number, ServiceCenterG);

                CurrMonthBufferG.RESET;
                CurrMonthBufferG.SETFILTER("Global Dimension Code 1", GlobalDimension1CodeFilterG);
                CurrMonthBufferG.SETFILTER("Global Dimension Code 2", GlobalDimension2CodeFilterG);
                IF IsServiceCenterSummaryG AND (Number = ServiceCenterCountG) THEN
                    CurrMonthBufferG.SETFILTER("Service Center", ServiceFilterG)
                ELSE
                    CurrMonthBufferG.SETRANGE("Service Center", ServiceCenterG.Code);

                CurrMonthBufferG.SETRANGE("Posting Date", CurrMonthStartDateG, CurrMonthEndDateG);
                CurrMonthBufferG.CALCSUMS("Turnover Total Amount",
                  "Turnover Total Tyre Amount",
                  "Turnover Total NonTyre Amount",
                  "Turnover Resource Amount",
                  "Sales Invoice Count",
                  "Sales Invoice Count Tyre",
                  "Sales Invoice Count Oil Filter",
                  "Sales Invoice Count Oil",
                  "Sales Invoice Count Oil Or Fil",
                  "Sales Invoice Count Others",
                  "Notification Order Count",
                  "Notification Order Amount",
                  "Vehicle Check Order Count",
                  "Vehicle Check Order Amount",
                  "Cross Sales Order Count",
                  "Cross Sales Order Amount",
                  "Tyre Sales Quantity",
                  "Resource Balance Quantity",
                  "Resource PC Quantity");
                // Start 119384
                CurrMonthBuffer2G.COPY(CurrMonthBufferG);
                CurrMonthBufferG.CALCSUMS("Total Amt", "Profit Amt");
                // Stop  119384

                LastYearMonthBufferG.COPYFILTERS(CurrMonthBufferG);
                LastYearMonthBufferG.SETRANGE("Posting Date", LastYearMonthStartDateG, LastYearMonthEndDateG);
                LastYearMonthBufferG.CALCSUMS("Turnover Total Amount",
                  "Turnover Total Tyre Amount",
                  "Turnover Total NonTyre Amount",
                  "Turnover Resource Amount",
                  "Sales Invoice Count",
                  "Sales Invoice Count Tyre",
                  "Sales Invoice Count Oil Filter",
                  "Sales Invoice Count Oil",
                  "Sales Invoice Count Oil Or Fil",
                  "Sales Invoice Count Others",
                  "Notification Order Count",
                  "Notification Order Amount",
                  "Vehicle Check Order Count",
                  "Vehicle Check Order Amount",
                  "Cross Sales Order Count",
                  "Cross Sales Order Amount",
                  "Tyre Sales Quantity",
                  "Resource Balance Quantity",
                  "Resource PC Quantity");
                // Start 119384
                LastYearMonthBuffer2G.COPY(LastYearMonthBufferG);
                LastYearMonthBufferG.CALCSUMS("Total Amt", "Profit Amt");
                // Stop  119384

                CurrPeriodBufferG.COPYFILTERS(CurrMonthBufferG);
                CurrPeriodBufferG.SETRANGE("Posting Date", CurrPeriodStartDateG, CurrPeriodEndDateG);
                CurrPeriodBufferG.CALCSUMS("Turnover Total Amount",
                  "Turnover Total Tyre Amount",
                  "Turnover Total NonTyre Amount",
                  "Turnover Resource Amount",
                  "Sales Invoice Count",
                  "Sales Invoice Count Tyre",
                  "Sales Invoice Count Oil Filter",
                  "Sales Invoice Count Oil",
                  "Sales Invoice Count Oil Or Fil",
                  "Sales Invoice Count Others",
                  "Notification Order Count",
                  "Notification Order Amount",
                  "Vehicle Check Order Count",
                  "Vehicle Check Order Amount",
                  "Cross Sales Order Count",
                  "Cross Sales Order Amount",
                  "Tyre Sales Quantity",
                  "Resource Balance Quantity",
                  "Resource PC Quantity");
                // Start 119384
                CurrPeriodBuffer2G.COPY(CurrPeriodBufferG);
                CurrPeriodBufferG.CALCSUMS("Total Amt", "Profit Amt");
                // Stop  119384

                LastYearPeriodBufferG.COPYFILTERS(CurrMonthBufferG);
                LastYearPeriodBufferG.SETRANGE("Posting Date", LastPeriodStartDateG, LastPeriodEndDateG);
                LastYearPeriodBufferG.CALCSUMS("Turnover Total Amount",
                  "Turnover Total Tyre Amount",
                  "Turnover Total NonTyre Amount",
                  "Turnover Resource Amount",
                  "Sales Invoice Count",
                  "Sales Invoice Count Tyre",
                  "Sales Invoice Count Oil Filter",
                  "Sales Invoice Count Oil",
                  "Sales Invoice Count Oil Or Fil",
                  "Sales Invoice Count Others",
                  "Notification Order Count",
                  "Notification Order Amount",
                  "Vehicle Check Order Count",
                  "Vehicle Check Order Amount",
                  "Cross Sales Order Count",
                  "Cross Sales Order Amount",
                  "Tyre Sales Quantity",
                  "Resource Balance Quantity",
                  "Resource PC Quantity");
                // Start 119384
                LastYearPeriodBuffer2G.COPY(LastYearPeriodBufferG);
                LastYearPeriodBufferG.CALCSUMS("Total Amt", "Profit Amt");
                // Stop  119384

                //++TWN1.00.122187.QX
                // Table Bay was removed
                // BayG.RESET;
                // IF IsServiceCenterSummaryG AND (Number = ServiceCenterCountG) THEN
                //     BayG.SETFILTER("Service Center", ServiceFilterG)
                // ELSE
                //     BayG.SETRANGE("Service Center", ServiceCenterG.Code);
                // CurrMonthBufferG."No. of Bays" := BayG.COUNT;
                // LastYearMonthBufferG."No. of Bays" := BayG.COUNT;
                // CurrPeriodBufferG."No. of Bays" := BayG.COUNT;
                // LastYearPeriodBufferG."No. of Bays" := BayG.COUNT;
                //--TWN1.00.122187.QX
                //++TWN1.00.122187.GG
                ServiceCenter2G.Reset();
                IF IsServiceCenterSummaryG AND (Number = ServiceCenterCountG) THEN
                    ServiceCenter2G.SETFILTER(Code, ServiceFilterG)
                ELSE
                    ServiceCenter2G.SETRANGE(Code, ServiceCenterG.Code);
                if ServiceCenter2G.FindSet() then
                    repeat
                        CurrMonthBufferG."No. of Bays" += ServiceCenter2G."No. of Bays";
                        LastYearMonthBufferG."No. of Bays" += ServiceCenter2G."No. of Bays";
                        CurrPeriodBufferG."No. of Bays" += ServiceCenter2G."No. of Bays";
                        LastYearPeriodBufferG."No. of Bays" += ServiceCenter2G."No. of Bays";
                    until ServiceCenter2G.Next() = 0;
                //++TWN1.00.122187.GG
                // Start 119384
                IF CurrMonthBufferG."Total Amt" <> 0 THEN
                    //CurrMonthBufferG."Gross Profit" := ROUND(CurrMonthBufferG."Profit Amt"/CurrMonthBufferG."Total Amt"*100,0.01);
                    CurrMonthBufferG."Gross Profit" := ROUND(CurrMonthBufferG."Profit Amt" / CurrMonthBufferG."Total Amt" * 100, 1);
                IF LastYearMonthBufferG."Total Amt" <> 0 THEN
                    //LastYearMonthBufferG."Gross Profit" := ROUND(LastYearMonthBufferG."Profit Amt"/LastYearMonthBufferG."Total Amt"*100,0.01);
                    LastYearMonthBufferG."Gross Profit" := ROUND(LastYearMonthBufferG."Profit Amt" / LastYearMonthBufferG."Total Amt" * 100, 1);
                IF CurrPeriodBufferG."Total Amt" <> 0 THEN
                    //CurrPeriodBufferG."Gross Profit" := ROUND(CurrPeriodBufferG."Profit Amt"/CurrPeriodBufferG."Total Amt"*100,0.01);
                    CurrPeriodBufferG."Gross Profit" := ROUND(CurrPeriodBufferG."Profit Amt" / CurrPeriodBufferG."Total Amt" * 100, 1);
                IF LastYearPeriodBufferG."Total Amt" <> 0 THEN
                    //LastYearPeriodBufferG."Gross Profit" := ROUND(LastYearPeriodBufferG."Profit Amt"/LastYearPeriodBufferG."Total Amt"*100,0.01);
                    LastYearPeriodBufferG."Gross Profit" := ROUND(LastYearPeriodBufferG."Profit Amt" / LastYearPeriodBufferG."Total Amt" * 100, 1);
                // Stop  119384

                IF CurrMonthBufferG."No. of Bays" <> 0 THEN
                    CurrMonthBufferG."Average Bays Output" := CurrMonthBufferG."Turnover Total Amount" / CurrMonthBufferG."No. of Bays";
                IF LastYearMonthBufferG."No. of Bays" <> 0 THEN
                    LastYearMonthBufferG."Average Bays Output" := LastYearMonthBufferG."Turnover Total Amount" / LastYearMonthBufferG."No. of Bays";
                IF CurrPeriodBufferG."No. of Bays" <> 0 THEN
                    CurrPeriodBufferG."Average Bays Output" := CurrPeriodBufferG."Turnover Total Amount" / CurrPeriodBufferG."No. of Bays";
                IF LastYearPeriodBufferG."No. of Bays" <> 0 THEN
                    LastYearPeriodBufferG."Average Bays Output" := LastYearPeriodBufferG."Turnover Total Amount" / LastYearPeriodBufferG."No. of Bays";
                IF CurrMonthBufferG."Sales Invoice Count" <> 0 THEN
                    CurrMonthBufferG."Average Salary Output" := CurrMonthBufferG."Turnover Total Amount" / CurrMonthBufferG."Sales Invoice Count";
                IF LastYearMonthBufferG."Sales Invoice Count" <> 0 THEN
                    LastYearMonthBufferG."Average Salary Output" := LastYearMonthBufferG."Turnover Total Amount" / LastYearMonthBufferG."Sales Invoice Count";
                IF CurrPeriodBufferG."Sales Invoice Count" <> 0 THEN
                    CurrPeriodBufferG."Average Salary Output" := CurrPeriodBufferG."Turnover Total Amount" / CurrPeriodBufferG."Sales Invoice Count";
                IF LastYearPeriodBufferG."Sales Invoice Count" <> 0 THEN
                    LastYearPeriodBufferG."Average Salary Output" := LastYearPeriodBufferG."Turnover Total Amount" / LastYearPeriodBufferG."Sales Invoice Count";

                IF IsServiceCenterSummaryG AND (Number = ServiceCenterCountG) THEN
                    GetAllPostedInvWithNotificationSent('', StartDateG, CurrMonthBufferG."Notification Order Count", CurrMonthBufferG."Notification Order Amount")
                ELSE
                    GetAllPostedInvWithNotificationSent(ServiceCenterG.Code, StartDateG, CurrMonthBufferG."Notification Order Count", CurrMonthBufferG."Notification Order Amount");

                CalculateProductivity(CurrMonthBufferG, LastYearMonthBufferG, TempMonthRateBufferG);
                CalculateProductivity(CurrPeriodBufferG, LastYearPeriodBufferG, TempPeriodRateBufferG);
            end;

            trigger OnPreDataItem()
            begin
                SETRANGE(Number, 1, ServiceCenterCountG);
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(StartDateG; StartDateG)
                {
                    Caption = 'Start Date';
                }
                field(EndDateG; EndDateG)
                {
                    Caption = 'End Date';
                }
                field(IsServiceCenterSummaryG; IsServiceCenterSummaryG)
                {
                    Caption = 'Resp. Center Summary';
                }
                group("選擇")
                {
                    Caption = 'Selection';
                    field(GlobalDimension1CodeFilterG; GlobalDimension1CodeFilterG)
                    {
                        Caption = 'ZONE';

                        trigger OnLookup(var Text: Text): Boolean
                        begin
                            EXIT(LookUpZoneFilter(Text));
                        end;
                    }
                    field(GlobalDimension2CodeFilterG; GlobalDimension2CodeFilterG)
                    {
                        Caption = 'DEALER';

                        trigger OnLookup(var Text: Text): Boolean
                        begin
                            EXIT(LookUpDealerFilter(Text));
                        end;
                    }
                    field(ServiceFilterG; ServiceFilterG)
                    {
                        Caption = 'Branch ';

                        trigger OnLookup(var Text: Text): Boolean
                        begin
                            EXIT(LookupServiceCenterFilter(Text));
                        end;
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
        C_INC_50001 = 'No. of Bays';
        C_INC_50002 = 'Total Turnover';
        C_INC_50003 = 'Tyre';
        C_INC_50004 = 'Non Tyre';
        C_INC_50005 = '    Total Service Revenue';
        C_INC_50006 = 'Gross Profit';
        C_INC_50007 = 'Bay Productivity';
        C_INC_50008 = 'Average Ticket';
        C_INC_50009 = 'Ticket Analysis';
        C_INC_50010 = 'No. of Invoice';
        C_INC_50011 = '    No. of Tire';
        C_INC_50012 = '    No. of Oil Filter';
        C_INC_50013 = '    No. of Oil';
        C_INC_50014 = '    No. of Tire+(Oil Filter or Oil)';
        C_INC_50015 = '    Other';
        C_INC_50016 = 'No. of Posted Inv. With Notification in two month';
        C_INC_50017 = 'Total Posted Inv. With Notification in two month';
        C_INC_50018 = 'No. of Check Vehicle';
        C_INC_50019 = 'Total Check Vehicle';
        C_INC_50020 = 'No. of Cross Selling';
        C_INC_50021 = 'Total of Cross Selling';
        C_INC_50022 = 'No. of Tires';
        C_INC_50023 = 'No. of Balancing';
        C_INC_50024 = 'No. of Aligment';
    }

    trigger OnInitReport()
    begin
        EndDateG := TODAY;
        MUTFuncsG.AddUsageTrackingEntry('MUT_6420');
    end;

    trigger OnPostReport()
    begin
        // Start 119434
        OnPostReportEvent;
        // Stop  119434
    end;

    trigger OnPreReport()
    begin
        CLEAR(UserSetupG);
        IF UserSetupG.GET(USERID) THEN
            IF UserSetupG."Zone Code" <> '' THEN
                GlobalDimension1CodeFilterG := UserSetupG."Zone Code";

        IF ServiceFilterG = '' THEN BEGIN
            CLEAR(ServiceCenterG);
            ServiceCenterG.RESET;
            IF GlobalDimension1CodeFilterG = '' THEN BEGIN
                CurrentServiceCenterG := GeneralFunctionsG.GetSCCode();
                CurrentServiceCenterFilterG := CurrentServiceCenterG;
                IF GeneralFunctionsG.CreateVisibleSCFilter('') <> '' THEN
                    CurrentServiceCenterFilterG := CurrentServiceCenterFilterG + '|' + GeneralFunctionsG.CreateVisibleSCFilter('');
                ServiceCenterG.SETFILTER(Code, CurrentServiceCenterFilterG);
            END ELSE BEGIN
                CurrentServiceCenterFilterG := GetRCFromZoneCode(GlobalDimension1CodeFilterG);
                ServiceCenterG.SETFILTER(Code, CurrentServiceCenterFilterG);
            END;
        END ELSE
            ServiceCenterG.SETFILTER(Code, ServiceFilterG);

        ServiceCenterCountG := ServiceCenterG.COUNT;
        IF ServiceCenterCountG < 1 THEN
            ERROR(C_INC_001);
        IF IsServiceCenterSummaryG THEN
            ServiceCenterCountG += 1;

        CompanyInfoG.GET;
        CompanyInfoG.CALCFIELDS(Picture);
        FormatAddressG.Company(CompanyAddrG, CompanyInfoG);

        CurrMonthStartDateG := CALCDATE('<-CM>', EndDateG);
        CurrMonthEndDateG := CALCDATE('<CM>', EndDateG);
        LastYearMonthStartDateG := CALCDATE('<-1Y>', CurrMonthStartDateG);
        LastYearMonthEndDateG := CALCDATE('<-1Y>', CurrMonthEndDateG);
        CurrPeriodStartDateG := StartDateG;
        CurrPeriodEndDateG := EndDateG;
        LastPeriodStartDateG := CALCDATE('<-1Y>', CurrPeriodStartDateG);
        LastPeriodEndDateG := CALCDATE('<-1Y>', CurrPeriodEndDateG);
    end;

    var
        StartDateG: Date;
        EndDateG: Date;
        IsServiceCenterSummaryG: Boolean;
        GlobalDimension1CodeFilterG: Text;
        GlobalDimension2CodeFilterG: Text;
        ServiceFilterG: Text;
        CompanyInfoG: Record "Company Information";
        ServiceCenterG: Record "Service Center";
        //++TWN1.00.122187.QX    
        // Table Bay was removed  
        // BayG: Record Bay;
        //--TWN1.00.122187.QX        
        ServiceCenter2G: Record "Service Center";
        DimensionValueG: Record "Dimension Value";
        UserSetupG: Record "User Setup";
        CurrMonthBufferG: Record "TW Performance Buffer";
        CurrMonthBuffer2G: Record "TW Performance Buffer";
        LastYearMonthBufferG: Record "TW Performance Buffer";
        LastYearMonthBuffer2G: Record "TW Performance Buffer";
        TempMonthRateBufferG: Record "TW Performance Buffer" temporary;
        CurrPeriodBufferG: Record "TW Performance Buffer";
        CurrPeriodBuffer2G: Record "TW Performance Buffer";
        LastYearPeriodBufferG: Record "TW Performance Buffer";
        LastYearPeriodBuffer2G: Record "TW Performance Buffer";
        TempPeriodRateBufferG: Record "TW Performance Buffer" temporary;
        MUTFuncsG: Codeunit "Usage Tracking";
        GeneralFunctionsG: Codeunit "General Functions";
        FormatAddressG: Codeunit "Format Address";
        ServiceCenterCountG: Integer;
        CurrentServiceCenterG: Code[10];
        CurrentServiceCenterFilterG: Code[1024];
        DealerNameG: Text;
        ZoneNameG: Text;
        C_INC_001: Label 'Please select Branch!';
        BranchNameG: Text;
        CompanyAddrG: array[8] of Text[50];
        CurrMonthStartDateG: Date;
        CurrMonthEndDateG: Date;
        LastYearMonthStartDateG: Date;
        LastYearMonthEndDateG: Date;
        CurrPeriodStartDateG: Date;
        CurrPeriodEndDateG: Date;
        LastPeriodStartDateG: Date;
        LastPeriodEndDateG: Date;
        C_INC_002: Label 'Performance Report ';
        C_INC_003: Label 'Page :';
        C_INC_004: Label 'Date from / to';
        C_INC_005: Label 'Zone';
        C_INC_006: Label 'Dealer ';
        C_INC_007: Label 'Branch ';
        C_INC_008: Label 'Summary';
        C_INC_009: Label 'Evolution';

    local procedure ClearVars()
    begin
        CLEAR(CurrMonthBufferG);
        CLEAR(LastYearMonthBufferG);
        CLEAR(CurrPeriodBufferG);
        CLEAR(LastYearPeriodBufferG);
        TempMonthRateBufferG.RESET;
        TempMonthRateBufferG.DELETEALL;
        TempPeriodRateBufferG.RESET;
        TempPeriodRateBufferG.DELETEALL;
    end;

    [Scope('OnPrem')]
    procedure LookUpZoneFilter(var Text: Text[250]): Boolean
    var
        DimensionValueL: Record "Dimension Value";
        RCL: Record "Service Center";
        DimensionValueListL: Page "Dimension Value List";
        GeneralFunctionsL: Codeunit "General Functions";
        RCCodeL: Code[20];
    begin
        RCCodeL := GeneralFunctionsL.GetSCCode();
        RCL.GET(RCCodeL);

        DimensionValueL.RESET;
        DimensionValueL.SETRANGE("Dimension Code", RCL."Zone Dimension");
        DimensionValueListL.LOOKUPMODE(TRUE);
        DimensionValueListL.SETTABLEVIEW(DimensionValueL);
        IF DimensionValueListL.RUNMODAL = ACTION::LookupOK THEN BEGIN
            DimensionValueListL.GETRECORD(DimensionValueL);
            Text += DimensionValueListL.GetSelectionFilter;
            EXIT(TRUE);
        END ELSE
            EXIT(FALSE);
    end;

    [Scope('OnPrem')]
    procedure LookUpDealerFilter(var Text: Text[250]): Boolean
    var
        DimensionValueL: Record "Dimension Value";
        RCL: Record "Service Center";
        DimensionValueListL: Page "Dimension Value List";
        GeneralFunctionsL: Codeunit "General Functions";
        RCCodeL: Code[20];
    begin
        RCCodeL := GeneralFunctionsL.GetSCCode();
        RCL.GET(RCCodeL);

        DimensionValueL.RESET;
        DimensionValueL.SETRANGE("Dimension Code", RCL."Dealer Dimension");
        DimensionValueListL.LOOKUPMODE(TRUE);
        DimensionValueListL.SETTABLEVIEW(DimensionValueL);
        IF DimensionValueListL.RUNMODAL = ACTION::LookupOK THEN BEGIN
            DimensionValueListL.GETRECORD(DimensionValueL);
            Text += DimensionValueListL.GetSelectionFilter;
            EXIT(TRUE);
        END ELSE
            EXIT(FALSE);
    end;

    local procedure LookupServiceCenterFilter(var Text: Text[250]): Boolean
    var
        ServiceCenterL: Record "Service Center";
        ServiceCenterListL: Page "Service Center List";
    begin
        ServiceCenterListL.LOOKUPMODE := TRUE;
        IF GlobalDimension2CodeFilterG <> '' THEN
            ServiceCenterL.SETFILTER("Dealer Dimension Value", GlobalDimension2CodeFilterG);
        ServiceCenterListL.SETTABLEVIEW(ServiceCenterL);
        IF ServiceCenterListL.RUNMODAL = ACTION::LookupOK THEN BEGIN
            ServiceCenterListL.GETRECORD(ServiceCenterL);
            Text := ServiceCenterListL.GetSelectionFilter;
            EXIT(TRUE);
        END ELSE
            EXIT(FALSE);
    end;

    [Scope('OnPrem')]
    procedure GetRCFromZoneCode(codZoneCodeP: Code[30]) txtRCodeFilterR: Code[1024]
    var
        recRespCenterL: Record "Service Center";
        intLoopL: Integer;
        codeRCCodeL: Code[1024];
    begin
        IF codZoneCodeP = '' THEN EXIT;

        codeRCCodeL := '';
        intLoopL := 0;
        CLEAR(recRespCenterL);
        //recRespCenterL.SETRANGE("Global Dimension 1 Code", codZoneCodeP);
        recRespCenterL.SETRANGE("Zone Dimension Value", codZoneCodeP);
        intLoopL := recRespCenterL.COUNT;

        IF recRespCenterL.FINDSET THEN
            REPEAT
                codeRCCodeL := codeRCCodeL + recRespCenterL.Code + '|';
            UNTIL recRespCenterL.NEXT = 0;

        IF STRLEN(codeRCCodeL) > 1 THEN
            txtRCodeFilterR := COPYSTR(codeRCCodeL, 1, (STRLEN(codeRCCodeL) - 1));
    end;

    local procedure ZoneDealerName(NumberP: Integer; ServiceCenterP: Record "Service Center")
    var
        RCL: Record "Service Center";
        GeneralFunctionsL: Codeunit "General Functions";
        RCCodeL: Code[20];
    begin
        RCCodeL := GeneralFunctionsL.GetSCCode();
        RCL.GET(RCCodeL);
        ZoneNameG := '';
        DealerNameG := '';

        //Zone Name
        IF GlobalDimension1CodeFilterG <> '' THEN BEGIN
            DimensionValueG.RESET;
            DimensionValueG.SETRANGE("Dimension Code", RCL."Zone Dimension");
            DimensionValueG.SETFILTER(Code, GlobalDimension1CodeFilterG);
            IF DimensionValueG.FINDFIRST THEN
                REPEAT
                    IF ZoneNameG <> '' THEN
                        ZoneNameG := ZoneNameG + ', ' + DimensionValueG.Name
                    ELSE
                        ZoneNameG := DimensionValueG.Name;
                UNTIL DimensionValueG.NEXT = 0
            ELSE
                ZoneNameG := DimensionValueG.Name;
        END;
        //Dealer Name
        IF GlobalDimension2CodeFilterG <> '' THEN BEGIN
            DimensionValueG.RESET;
            DimensionValueG.SETRANGE("Dimension Code", RCL."Dealer Dimension");
            DimensionValueG.SETFILTER(Code, GlobalDimension2CodeFilterG);
            IF DimensionValueG.FINDFIRST THEN
                REPEAT
                    IF DealerNameG <> '' THEN
                        DealerNameG := DealerNameG + ', ' + DimensionValueG.Name
                    ELSE
                        DealerNameG := DimensionValueG.Name;
                UNTIL DimensionValueG.NEXT = 0;
        END;

        //Branch Name
        IF IsServiceCenterSummaryG AND (NumberP = ServiceCenterCountG) THEN
            BranchNameG := C_INC_008
        ELSE
            BranchNameG := ServiceCenterP.Name;
    end;

    [Scope('OnPrem')]
    procedure MonthNames(MonthNumber: Integer) MonthName: Text[30]
    var
        C_BSS_INF010: Label 'January';
        C_BSS_INF011: Label 'February';
        C_BSS_INF012: Label 'March';
        C_BSS_INF013: Label 'April';
        C_BSS_INF014: Label 'May';
        C_BSS_INF015: Label 'June';
        C_BSS_INF016: Label 'July';
        C_BSS_INF017: Label 'August';
        C_BSS_INF018: Label 'September';
        C_BSS_INF019: Label 'October';
        C_BSS_INF020: Label 'November';
        C_BSS_INF021: Label 'December';
    begin
        CASE MonthNumber OF
            1:
                MonthName := C_BSS_INF010;
            2:
                MonthName := C_BSS_INF011;
            3:
                MonthName := C_BSS_INF012;
            4:
                MonthName := C_BSS_INF013;
            5:
                MonthName := C_BSS_INF014;
            6:
                MonthName := C_BSS_INF015;
            7:
                MonthName := C_BSS_INF016;
            8:
                MonthName := C_BSS_INF017;
            9:
                MonthName := C_BSS_INF018;
            10:
                MonthName := C_BSS_INF019;
            11:
                MonthName := C_BSS_INF020;
            12:
                MonthName := C_BSS_INF021;
        END
    end;

    local procedure CalculateProductivity(var BufferP: Record "TW Performance Buffer"; var LastPeriodBufferP: Record "TW Performance Buffer"; var BufferRateP: Record "TW Performance Buffer")
    begin
        BufferRateP."No. of Bays" := ProductivityRate(LastPeriodBufferP."No. of Bays", BufferP."No. of Bays");
        BufferRateP."Turnover Total Amount" := ProductivityRate(LastPeriodBufferP."Turnover Total Amount", BufferP."Turnover Total Amount");
        BufferRateP."Average Bays Output" := ProductivityRate(LastPeriodBufferP."Average Bays Output", BufferP."Average Bays Output");
        BufferRateP."Turnover Resource Amount" := ProductivityRate(LastPeriodBufferP."Turnover Resource Amount", BufferP."Turnover Resource Amount");
        BufferRateP."Sales Invoice Count" := ProductivityRate(LastPeriodBufferP."Sales Invoice Count", BufferP."Sales Invoice Count");
        BufferRateP."Sales Invoice Count Tyre" := ProductivityRate(LastPeriodBufferP."Sales Invoice Count Tyre", BufferP."Sales Invoice Count Tyre");
        BufferRateP."Sales Invoice Count Oil Filter" := ProductivityRate(LastPeriodBufferP."Sales Invoice Count Oil Filter", BufferP."Sales Invoice Count Oil Filter");
        BufferRateP."Sales Invoice Count Oil" := ProductivityRate(LastPeriodBufferP."Sales Invoice Count Oil", BufferP."Sales Invoice Count Oil");
        BufferRateP."Sales Invoice Count Oil Or Fil" := ProductivityRate(LastPeriodBufferP."Sales Invoice Count Oil Or Fil", BufferP."Sales Invoice Count Oil Or Fil");
        BufferRateP."Sales Invoice Count Others" := ProductivityRate(LastPeriodBufferP."Sales Invoice Count Others", BufferP."Sales Invoice Count Others");
        BufferRateP."Notification Order Count" := ProductivityRate(LastPeriodBufferP."Notification Order Count", BufferP."Notification Order Count");
        BufferRateP."Notification Order Amount" := ProductivityRate(LastPeriodBufferP."Notification Order Amount", BufferP."Notification Order Amount");
        BufferRateP."Vehicle Check Order Count" := ProductivityRate(LastPeriodBufferP."Vehicle Check Order Count", BufferP."Vehicle Check Order Count");
        BufferRateP."Vehicle Check Order Amount" := ProductivityRate(LastPeriodBufferP."Vehicle Check Order Amount", BufferP."Vehicle Check Order Amount");
        BufferRateP."Cross Sales Order Count" := ProductivityRate(LastPeriodBufferP."Cross Sales Order Count", BufferP."Cross Sales Order Count");
        BufferRateP."Cross Sales Order Amount" := ProductivityRate(LastPeriodBufferP."Cross Sales Order Amount", BufferP."Cross Sales Order Amount");
        BufferRateP."Tyre Sales Quantity" := ProductivityRate(LastPeriodBufferP."Tyre Sales Quantity", BufferP."Tyre Sales Quantity");
        BufferRateP."Resource Balance Quantity" := ProductivityRate(LastPeriodBufferP."Resource Balance Quantity", BufferP."Resource Balance Quantity");
        BufferRateP."Resource PC Quantity" := ProductivityRate(LastPeriodBufferP."Resource PC Quantity", BufferP."Resource PC Quantity");
        BufferRateP."Average Salary Output" := ProductivityRate(LastPeriodBufferP."Average Salary Output", BufferP."Average Salary Output");
        BufferRateP."Turnover Total Tyre Amount" := ProductivityRate(LastPeriodBufferP."Turnover Total Tyre Amount", BufferP."Turnover Total Tyre Amount");
        BufferRateP."Turnover Total NonTyre Amount" := ProductivityRate(LastPeriodBufferP."Turnover Total NonTyre Amount", BufferP."Turnover Total NonTyre Amount");
        BufferRateP."Gross Profit" := ProductivityRate(LastPeriodBufferP."Gross Profit", BufferP."Gross Profit");

        BufferRateP."Notification Order Count" := 0;
        BufferRateP."Notification Order Amount" := 0;
    end;

    local procedure ProductivityRate(OriginalValueP: Decimal; NewValueP: Decimal): Decimal
    begin
        IF (OriginalValueP = 0) AND (NewValueP > 0) THEN
            EXIT(1);
        IF (OriginalValueP = 0) AND (NewValueP < 0) THEN
            EXIT(-1);
        IF (OriginalValueP <> 0) THEN
            EXIT((NewValueP - OriginalValueP) / OriginalValueP);
    end;

    local procedure NotificationInvoiceFilters(var CalculateDateP: Date; var StartDateFilterP: Date; var EndDateFilterP: Date)
    var
        UserServCenterL: Record "User/Serv. Center";
        CalculateMonthFirstDateL: Date;
    begin
        CalculateMonthFirstDateL := DMY2DATE(1, DATE2DMY(CalculateDateP, 2), DATE2DMY(CalculateDateP, 3));
        StartDateFilterP := CALCDATE('<-2M>', CalculateMonthFirstDateL);
        EndDateFilterP := CalculateMonthFirstDateL - 1;
    end;

    [Scope('OnPrem')]
    procedure GetAllPostedInvWithNotificationSent(ServiceCenterFilterP: Code[100]; CalculateDateP: Date; var VehicleCheckCountP: Decimal; var VehicleCheckAmtP: Decimal)
    var
        SalesInvoiceHeaderL: Record "Sales Invoice Header";
        PostedInvWithNotificationL: Query "Posted Inv. With Notification";
        StartDateL: Date;
        EndDateL: Date;
    begin
        NotificationInvoiceFilters(CalculateDateP, StartDateL, EndDateL);

        VehicleCheckCountP := 0;
        VehicleCheckAmtP := 0;

        CLEAR(PostedInvWithNotificationL);
        PostedInvWithNotificationL.SETFILTER(Sell_to_Contact_No, '<>%1', '');
        PostedInvWithNotificationL.SETFILTER(Service_Center, ServiceCenterFilterP);
        PostedInvWithNotificationL.SETFILTER(Posting_Date, '%1..%2', StartDateL, CalculateDateP);
        PostedInvWithNotificationL.SETFILTER(Notif_Date_Sent, '%1..%2', StartDateL, EndDateL);
        PostedInvWithNotificationL.OPEN;
        WHILE PostedInvWithNotificationL.READ DO BEGIN
            IF SalesInvoiceHeaderL.GET(PostedInvWithNotificationL.No) THEN BEGIN
                SalesInvoiceHeaderL.CALCFIELDS("Amount Including VAT");
                VehicleCheckCountP += 1;
                VehicleCheckAmtP += SalesInvoiceHeaderL."Amount Including VAT";
            END;
        END;
    end;

    local procedure R(DecToRoundP: Decimal): Decimal
    begin
        EXIT(ROUND(DecToRoundP, 0.01));
    end;

    [IntegrationEvent(TRUE, TRUE)]
    local procedure OnPostReportEvent()
    begin
    end;
}

