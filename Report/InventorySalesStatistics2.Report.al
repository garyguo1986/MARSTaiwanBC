report 1044881 "Inventory - Sales Statistics2"
{
    // +--------------------------------------------------------------+
    // | ?2013 ff. Begusch Software Systeme                          |
    // +--------------------------------------------------------------+
    // | PURPOSE: Fastfit                                             |
    // +--------------------------------------------------------------+
    // 
    // VERSION  ID       WHO    DATE        DESCRIPTION
    // 070100   IT_20050 FT     2013-08-12  added Description 2
    //                                       - extended length of "Description" and "Description 2"
    //                                       - changed orientation to Landscape
    //                                       - new filter criteria
    //                                         Manufacturer, Main-/Sub-/Positiongroupcode
    //                                       - added fields on requestform to show only items
    //                                         with either greater than or equal or
    //                                         lesser than a or equal a specified profit %
    // 
    // 081100   IT_20447 SG    2015-03-17  made some enhancemants for MARS R5
    // 081100   IT_20609 SG    2015-07-14  added "Starting Date" and "Ending Date" to the request page
    // 081100   IT_20890 SG    2016-01-26  added the columns "Sales Unit of Measure" and "Sales Disc. (LCY)"
    // 081100   IT_20894 CM    2016-01-28  added the columns "Sales Unit of Measure" and "Sales Disc. (LCY)" to excel export
    // 081200   IT_20913 SG    2016-02-22  Merged to NAV 2016 CU04
    // 081400   IT_20992 PW    2016-05-10  print the column "Base Unit of Measure" instead of "Sales Unit of Measure" on the Report
    // 
    // +--------------------------------------------------------------+
    // | @ 2017 incadea Taiwan Limited                                |
    // +--------------------------------------------------------------+
    // | PURPOSE: MARS_TWN                                            |
    // |                                                              |
    // | REMARK :                                                     |
    // +--------------------------------------------------------------+
    // 
    // VERSION     ID          WHO    DATE        DESCRIPTION
    // RGS_TWN-537             NN     2017-04-26  Add FlowFilter "Customer No. Filter".
    // RGS_TWN-837 119434      WP     2019-05-15  Add publisher OnPostReportEvent
    DefaultLayout = RDLC;
    RDLCLayout = './Report/InventorySalesStatistics2.rdlc';

    Caption = 'Item - Sales Statistics';

    dataset
    {
        dataitem(Item; Item)
        {
            CalcFields = Inventory;
            RequestFilterFields = "No.", "Search Description", "Assembly BOM", "Inventory Posting Group", "Statistics Group", "Base Unit of Measure", "Customer No. Filter";
            column(PeriodTextCaption; STRSUBSTNO(Text000, PeriodText))
            {
            }
            column(CompanyName; COMPANYNAME)
            {
            }
            column(PrintAlsoWithoutSale; PrintAlsoWithoutSale)
            {
            }
            column(ItemFilterCaption; STRSUBSTNO('%1: %2', TABLECAPTION, ItemFilter))
            {
            }
            column(ItemFilter; ItemFilter)
            {
            }
            column(InventoryPostingGrp_Item; "Inventory Posting Group")
            {
            }
            column(No_Item; "No.")
            {
                IncludeCaption = true;
            }
            column(Description_Item; Description + ' ' + "Description 2")
            {
            }
            column(AssemblyBOM_Item; FORMAT("Assembly BOM"))
            {
            }
            column(BaseUnitofMeasure_Item; "Base Unit of Measure")
            {
                IncludeCaption = true;
            }
            column(UnitCost; UnitCost)
            {
            }
            column(UnitPrice; UnitPrice)
            {
            }
            column(SalesQty; SalesQty)
            {
            }
            column(SalesAmount; SalesAmount)
            {
            }
            column(ItemsProfit; ItemProfit)
            {
                AutoFormatType = 1;
            }
            column(ItemProfitPct; ItemProfitPct)
            {
                DecimalPlaces = 1 : 1;
            }
            column(InvSalesStatisticsCapt; InvSalesStatisticsCaptLbl)
            {
            }
            column(PageCaption; PageCaptionLbl)
            {
            }
            column(IncludeNotSoldItemsCaption; IncludeNotSoldItemsCaptionLbl)
            {
            }
            column(ItemAssemblyBOMCaption; ItemAssemblyBOMCaptionLbl)
            {
            }
            column(UnitCostCaption; UnitCostCaptionLbl)
            {
            }
            column(UnitPriceCaption; UnitPriceCaptionLbl)
            {
            }
            column(SalesQtyCaption; SalesQtyCaptionLbl)
            {
            }
            column(SalesAmountCaption; SalesAmountCaptionLbl)
            {
            }
            column(ItemProfitCaption; ItemProfitCaptionLbl)
            {
            }
            column(ItemProfitPctCaption; ItemProfitPctCaptionLbl)
            {
            }
            column(TotalCaption; TotalCaptionLbl)
            {
            }
            column(CompanyPicture; CompanyInfo.Picture)
            {
            }
            column(DateHeader; FORMAT(TODAY, 0, 7))
            {
            }
            column(TimeHeader; FORMAT(TIME))
            {
            }
            column(ManufacturerCode; "Manufacturer Code")
            {
            }
            column(SortingOrderMARS; SortingOrderMARS)
            {
            }
            column(Manufacturer_Item_No; "Manufacturer Item No.")
            {
            }
            column(DescriptionCaption; DescriptionCaptionLbl)
            {
            }
            column(ManufItemNoCaption; ManufItemNoCaptionLbl)
            {
            }
            column(Inventory; Inventory)
            {
            }
            column(SalesUnitOfMeasure; "Sales Unit of Measure")
            {
                IncludeCaption = true;
            }
            column(SalesDiscountAmount; SalesDiscountAmount)
            {
            }
            column(SalesDiscountCaption; SalesDiscountCaptionLbl)
            {
            }

            trigger OnAfterGetRecord()
            begin
                CALCFIELDS("Assembly BOM");

                SetFilters;
                Calculate;

                IF (SalesAmount = 0) AND NOT PrintAlsoWithoutSale THEN
                    CurrReport.SKIP;

                //++BSS.IT_20050.FT
                IF (ProfitPctGreaterThan <> 0) THEN
                    IF (ItemProfitPct <= ProfitPctGreaterThan) THEN
                        CurrReport.SKIP;

                IF (ProfitPctSmallerThan <> 0) THEN
                    IF (ItemProfitPct >= ProfitPctSmallerThan) THEN
                        CurrReport.SKIP;
                //--BSS.IT_20050.FT

                //++BSS.IT_20447.SG
                SalesQtyTotal += SalesQty;
                SalesAmountTotal += SalesAmount;
                ItemProfitTotal += ItemProfit;
                //++BSS.IT_20894.CM
                SalesDiscountAmountTotal += SalesDiscountAmount;
                //--BSS.IT_20894.CM
                IF ExcelExport THEN
                    MakeExcelDataBody("No.", "Manufacturer Item No.", Description + ' ' + "Description 2", FORMAT(UnitCost), FORMAT(UnitPrice),
                      //++BSS.IT_20894.CM
                      //FORMAT(SalesQty), FORMAT(SalesAmount), FORMAT(ItemProfit), FORMAT(ItemProfitPct), "Manufacturer Code", FORMAT("Item Type"), FORMAT(Width), FORMAT(Diameter));
                      //++BSS.IT_20992.PW
                      //FORMAT(SalesQty), FORMAT(SalesAmount), FORMAT(ItemProfit), FORMAT(ItemProfitPct), "Manufacturer Code", FORMAT("Item Type"), FORMAT(Width), FORMAT(Diameter),Item."Sales Unit of Measure",FORMAT(SalesDiscountAmount));
                      FORMAT(SalesQty), FORMAT(SalesAmount), FORMAT(ItemProfit), FORMAT(ItemProfitPct), "Manufacturer Code", FORMAT("Item Type"), FORMAT(Width), FORMAT(Diameter), Item."Base Unit of Measure", FORMAT(SalesDiscountAmount));
                //--BSS.IT_20992.PW
                //--BSS.IT_20894.CM
                //--BSS.IT_20447.SG
            end;

            trigger OnPostDataItem()
            begin
                //++BSS.IT_20447.SG
                IF SalesAmountTotal <> 0 THEN
                    ItemProfitPctTotal := ROUND(100 * ItemProfitTotal / SalesAmountTotal, 0.1)
                ELSE
                    ItemProfitPctTotal := 0;

                IF ExcelExport THEN
                    //++BSS.IT_20894.CM
                    //MakeExcelDataBodyBold('','', '', '', TotalCaptionLbl, FORMAT(SalesQtyTotal), FORMAT(SalesAmountTotal), FORMAT(ItemProfitTotal), FORMAT(ItemProfitPctTotal), '', '', '', '');
                    MakeExcelDataBodyBold('', '', '', '', TotalCaptionLbl, FORMAT(SalesQtyTotal), FORMAT(SalesAmountTotal), FORMAT(ItemProfitTotal), FORMAT(ItemProfitPctTotal), '', '', '', '', '', FORMAT(SalesDiscountAmountTotal));
                //--BSS.IT_20894.CM
                //--BSS.IT_20447.SG
            end;

            trigger OnPreDataItem()
            begin
                CurrReport.CREATETOTALS(SalesQty, SalesAmount, COGSAmount, ItemProfit);
                //++BSS.IT_20447.SG
                /*
                //++BSS.IT_20050.FT
                IF (SortingOrder = SortingOrder::"Inventory Posting Group") THEN
                  SETCURRENTKEY("Inventory Posting Group")
                ELSE IF (SortingOrder = SortingOrder::"Item Category") THEN
                  SETCURRENTKEY("Item Category Code")
                ELSE IF (SortingOrder = SortingOrder::"Product Group") THEN
                  SETCURRENTKEY("Product Group Code")
                ELSE IF (SortingOrder = SortingOrder::"Manufacturer Code") THEN
                  SETCURRENTKEY("Manufacturer Code","Main Group Code","Sub Group Code","Position Group Code")
                ELSE IF (SortingOrder = SortingOrder::"Main Group") THEN
                  SETCURRENTKEY("Main Group Code","Item Type","Inventory Value Zero");
                //--BSS.IT_20050.FT
                */
                CASE SortingOrderMARS OF
                    0:
                        SETCURRENTKEY("Inventory Posting Group", "Manufacturer Code", Speedindex, Diameter, Width, "Aspect Ratio");
                    1:
                        SETCURRENTKEY("Inventory Posting Group", "Manufacturer Code", Diameter, Width, "Aspect Ratio", Speedindex);
                    2:
                        SETCURRENTKEY("Inventory Posting Group", "Manufacturer Code", "Tread Patterncode/Modelcode", Diameter, Width, "Aspect Ratio");
                    3:
                        SETCURRENTKEY("Inventory Posting Group", Diameter, Width, "Aspect Ratio", Speedindex);
                    4:
                        SETCURRENTKEY("Inventory Posting Group", "Manufacturer Code", Inventory);
                    5:
                        SETCURRENTKEY("Inventory Posting Group", Inventory);
                END;

                IF ExcelExport THEN
                    MakeExcelDataBodyBold(FIELDCAPTION("No."), ManufItemNoCaptionLbl, FIELDCAPTION(Description), UnitCostCaptionLbl, UnitPriceCaptionLbl,
                      //++BSS.IT_20894.CM
                      //SalesQtyCaptionLbl, SalesAmountCaptionLbl, ItemProfitCaptionLbl, ItemProfitPctCaptionLbl, C_BSS_INF004, C_BSS_INF005, C_BSS_INF006, C_BSS_INF007);
                      SalesQtyCaptionLbl, SalesAmountCaptionLbl, ItemProfitCaptionLbl, ItemProfitPctCaptionLbl, C_BSS_INF004, C_BSS_INF005, C_BSS_INF006, C_BSS_INF007,
                      //++BSS.IT_20992.PW
                      //FIELDCAPTION(Item."Sales Unit of Measure") , SalesDiscountCaptionLbl);
                      FIELDCAPTION(Item."Base Unit of Measure"), SalesDiscountCaptionLbl);
                //--BSS.IT_20992.PW
                //--BSS.IT_20894.CM
                //--BSS.IT_20447.SG

            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group("選項")
                {
                    Caption = 'Options';
                    group("銷售期間")
                    {
                        Caption = 'Sales Period';
                        field(StartDate; StartDate)
                        {
                            Caption = 'Starting Date';
                            ShowCaption = true;
                        }
                        field(EndDate; EndDate)
                        {
                            Caption = 'Ending Date';
                            ShowCaption = true;
                        }
                    }
                    field(PrintAlsoWithoutSale; PrintAlsoWithoutSale)
                    {
                        Caption = 'Include Items Not Sold';
                        MultiLine = true;
                    }
                    field(ProfitPctGreaterThan; ProfitPctGreaterThan)
                    {
                        Caption = 'Items with Profit % >=';
                    }
                    field(ProfitPctSmallerThan; ProfitPctSmallerThan)
                    {
                        Caption = 'Items with Profit % <=';
                    }
                    field(SortingOrder; SortingOrder)
                    {
                        Caption = 'Sorting By';
                        OptionCaption = 'Inventory Posting Group,Item Category,Product Group,Manufacturer Code,Main Group';
                        Visible = false;
                    }
                    field(SortingOrderMARS; SortingOrderMARS)
                    {
                        Caption = 'Sorting By';
                        OptionCaption = 'Brand / Speedindex / Wheel Diameter / Width / Aspect Ratio,Brand / Wheel diameter / Width / Aspect Ratio / Speedindex,Brand / Tread Pattern / Wheel diameter / Width / Aspect Ratio,Wheel diameter / Width / Aspect Ratio / Speedindex';
                    }
                    field(ExcelExport; ExcelExport)
                    {
                        Caption = 'Export to Excel';
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
    }

    trigger OnPostReport()
    begin
        // Start 119434
        OnPostReportEvent;
        // Stop  119434
        //++BSS.IT_20447.SG
        IF ExcelExport THEN
            CreateExcelBook;
        //--BSS.IT_20447.SG
    end;

    trigger OnPreReport()
    begin
        GLSetup.GET;

        //++BSS.IT_20609.SG
        IF (StartDate <> 0D) AND (EndDate <> 0D) THEN
            Item.SETFILTER("Date Filter", '%1..%2', StartDate, EndDate)
        ELSE BEGIN
            IF StartDate <> 0D THEN
                Item.SETFILTER("Date Filter", '%1..', StartDate);
            IF EndDate <> 0D THEN
                Item.SETFILTER("Date Filter", '..%2', EndDate);
        END;
        //--BSS.IT_20609.SG
        ItemFilter := Item.GETFILTERS;
        PeriodText := Item.GETFILTER("Date Filter");

        WITH ItemStatisticsBuf DO BEGIN
            IF Item.GETFILTER("Date Filter") <> '' THEN
                SETFILTER("Date Filter", PeriodText);
            IF Item.GETFILTER("Location Filter") <> '' THEN
                SETFILTER("Location Filter", Item.GETFILTER("Location Filter"));
            IF Item.GETFILTER("Variant Filter") <> '' THEN
                SETFILTER("Variant Filter", Item.GETFILTER("Variant Filter"));
            IF Item.GETFILTER("Global Dimension 1 Filter") <> '' THEN
                SETFILTER("Global Dimension 1 Filter", Item.GETFILTER("Global Dimension 1 Filter"));
            IF Item.GETFILTER("Global Dimension 2 Filter") <> '' THEN
                SETFILTER("Global Dimension 2 Filter", Item.GETFILTER("Global Dimension 2 Filter"));
            //++BSS.IT_20050.FT
            IF Item.GETFILTER("Service Center Filter") <> '' THEN
                SETFILTER("Service Center Filter", Item.GETFILTER("Service Center Filter"));
            //--BSS.IT_20050.FT
            // Start RGS_TWN-537
            IF Item.GETFILTER("Customer No. Filter") <> '' THEN BEGIN
                SETRANGE("Source Type Filter", "Source Type Filter"::Customer);
                SETFILTER("Source No. Filter", Item.GETFILTER("Customer No. Filter"));
            END;
            // Stop RGS_TWN-537
        END;

        //++BSS.IT_20050.FT
        CompanyInfo.GET;
        CompanyInfo.CALCFIELDS(CompanyInfo.Picture);
        FormatAddr.Company(CompanyAddr, CompanyInfo);
        //--BSS.IT_20050.FT
        //++BSS.IT_20447.SG
        IF ExcelExport THEN
            MakeExcelInfo;
        //--BSS.IT_20447.SG
    end;

    var
        Text000: Label 'Period: %1';
        ItemStatisticsBuf: Record "Item Statistics Buffer";
        GLSetup: Record "General Ledger Setup";
        ItemFilter: Text;
        PeriodText: Text[30];
        SalesQty: Decimal;
        SalesAmount: Decimal;
        COGSAmount: Decimal;
        ItemProfit: Decimal;
        ItemProfitPct: Decimal;
        UnitPrice: Decimal;
        UnitCost: Decimal;
        PrintAlsoWithoutSale: Boolean;
        InvSalesStatisticsCaptLbl: Label 'Item - Sales Statistics';
        PageCaptionLbl: Label 'Page';
        IncludeNotSoldItemsCaptionLbl: Label 'This report also includes items that are not sold.';
        ItemAssemblyBOMCaptionLbl: Label 'BOM';
        UnitCostCaptionLbl: Label 'Unit Cost';
        UnitPriceCaptionLbl: Label 'Unit Price';
        SalesQtyCaptionLbl: Label 'Sales (Qty.)';
        ItemProfitCaptionLbl: Label 'Profit';
        ItemProfitPctCaptionLbl: Label 'Profit %';
        TotalCaptionLbl: Label 'Total';
        CompanyInfo: Record "Company Information";
        FormatAddr: Codeunit "Format Address";
        CompanyAddr: array[8] of Text[50];
        _BSS_: Integer;
        ProfitPctGreaterThan: Decimal;
        ProfitPctSmallerThan: Decimal;
        ServCenter: Record "Service Center";
        SortingOrder: Option "Inventory Posting Group","Item Category","Product Group","Manufacturer Code","Main Group";
        MainGroup: Record "Main Group";
        Manufacturer: Record Manufacturer;
        SortingOrderMARS: Option Sorting1,Sorting2,Sorting3,Sorting4,Sorting5,Sorting6;
        ExcelExport: Boolean;
        ExcelBuf: Record "Excel Buffer" temporary;
        C_BSS_INF001: Label 'Item - Sales Statistics';
        C_BSS_INF002: Label 'Company Name';
        C_BSS_INF003: Label 'Report Name';
        C_BSS_INF004: Label 'Brand';
        C_BSS_INF005: Label 'Item Type';
        C_BSS_INF006: Label 'Tyre Width';
        C_BSS_INF007: Label 'Tyre Diameter';
        SalesQtyTotal: Decimal;
        SalesAmountTotal: Decimal;
        ItemProfitTotal: Decimal;
        ItemProfitPctTotal: Decimal;
        DescriptionCaptionLbl: Label 'Description';
        ManufItemNoCaptionLbl: Label 'Man. Item No.';
        StartDate: Date;
        EndDate: Date;
        SalesDiscountAmount: Decimal;
        SalesDiscountCaptionLbl: Label 'Sales Disc. (LCY)';
        SalesAmountCaptionLbl: Label 'Sales (LCY)';
        SalesDiscountAmountTotal: Decimal;

    local procedure Calculate()
    begin
        SalesQty := -CalcInvoicedQty;
        SalesAmount := CalcSalesAmount;
        //++BSS.IT_20890.SG
        SalesDiscountAmount := CalcSalesDiscountAmount;
        //--BSS.IT_20890.SG
        COGSAmount := CalcCostAmount + CalcCostAmountNonInvnt;
        ItemProfit := SalesAmount + COGSAmount;

        IF SalesAmount <> 0 THEN
            ItemProfitPct := ROUND(100 * ItemProfit / SalesAmount, 0.1)
        ELSE
            ItemProfitPct := 0;

        UnitPrice := CalcPerUnit(SalesAmount, SalesQty);
        UnitCost := -CalcPerUnit(COGSAmount, SalesQty);
    end;

    local procedure SetFilters()
    begin
        WITH ItemStatisticsBuf DO BEGIN
            SETRANGE("Item Filter", Item."No.");
            SETRANGE("Item Ledger Entry Type Filter", "Item Ledger Entry Type Filter"::Sale);
            SETFILTER("Entry Type Filter", '<>%1', "Entry Type Filter"::Revaluation);
        END;
    end;

    local procedure CalcSalesAmount(): Decimal
    begin
        WITH ItemStatisticsBuf DO BEGIN
            CALCFIELDS("Sales Amount (Actual)");
            EXIT("Sales Amount (Actual)");
        END;
    end;

    local procedure CalcCostAmount(): Decimal
    begin
        WITH ItemStatisticsBuf DO BEGIN
            CALCFIELDS("Cost Amount (Actual)");
            EXIT("Cost Amount (Actual)");
        END;
    end;

    local procedure CalcCostAmountNonInvnt(): Decimal
    begin
        WITH ItemStatisticsBuf DO BEGIN
            SETRANGE("Item Ledger Entry Type Filter");
            CALCFIELDS("Cost Amount (Non-Invtbl.)");
            EXIT("Cost Amount (Non-Invtbl.)");
        END;
    end;

    local procedure CalcInvoicedQty(): Decimal
    begin
        WITH ItemStatisticsBuf DO BEGIN
            SETRANGE("Entry Type Filter");
            CALCFIELDS("Invoiced Quantity");
            EXIT("Invoiced Quantity");
        END;
    end;

    local procedure CalcPerUnit(Amount: Decimal; Qty: Decimal): Decimal
    begin
        IF Qty <> 0 THEN
            EXIT(ROUND(Amount / ABS(Qty), GLSetup."Unit-Amount Rounding Precision"));
        EXIT(0);
    end;

    [Scope('OnPrem')]
    procedure MakeExcelInfo()
    begin
        //++BSS.IT_20447.SG
        ExcelBuf.SetUseInfoSheet;
        //++TWN1.00.122187.QX
        // ExcelBuf.AddInfoColumn(FORMAT(C_BSS_INF002), FALSE, '', TRUE, FALSE, FALSE, '', 1);
        // ExcelBuf.AddInfoColumn(COMPANYNAME, FALSE, '', TRUE, FALSE, FALSE, '', 1);
        // ExcelBuf.NewRow;
        // ExcelBuf.NewRow;
        // ExcelBuf.AddInfoColumn(FORMAT(C_BSS_INF003), FALSE, '', TRUE, FALSE, FALSE, '', 1);
        // ExcelBuf.AddInfoColumn(FORMAT(C_BSS_INF001), FALSE, '', TRUE, FALSE, FALSE, '', 1);
        // ExcelBuf.NewRow;
        // ExcelBuf.AddInfoColumn('Printed on', FALSE, '', TRUE, FALSE, FALSE, '', 1);
        // ExcelBuf.AddInfoColumn(TODAY, FALSE, '', TRUE, FALSE, FALSE, '', 1);


        // ExcelBuf.NewRow;
        // ExcelBuf.AddInfoColumn('Printed By', FALSE, '', TRUE, FALSE, FALSE, '', 1);
        // ExcelBuf.AddInfoColumn(USERID, FALSE, '', FALSE, FALSE, FALSE, '', 1);

        ExcelBuf.AddInfoColumn(FORMAT(C_BSS_INF002), FALSE, TRUE, FALSE, FALSE, '', 1);
        ExcelBuf.AddInfoColumn(COMPANYNAME, FALSE, TRUE, FALSE, FALSE, '', 1);
        ExcelBuf.NewRow;
        ExcelBuf.NewRow;
        ExcelBuf.AddInfoColumn(FORMAT(C_BSS_INF003), FALSE, TRUE, FALSE, FALSE, '', 1);
        ExcelBuf.AddInfoColumn(FORMAT(C_BSS_INF001), FALSE, TRUE, FALSE, FALSE, '', 1);
        ExcelBuf.NewRow;
        ExcelBuf.AddInfoColumn('Printed on', FALSE, TRUE, FALSE, FALSE, '', 1);
        ExcelBuf.AddInfoColumn(TODAY, FALSE, TRUE, FALSE, FALSE, '', 1);


        ExcelBuf.NewRow;
        ExcelBuf.AddInfoColumn('Printed By', FALSE, TRUE, FALSE, FALSE, '', 1);
        ExcelBuf.AddInfoColumn(USERID, FALSE, FALSE, FALSE, FALSE, '', 1);
        //--TWN1.00.122187.QX

        ExcelBuf.ClearNewRow;
        MakeExcelDataHeader;
        //--BSS.IT_20447.SG
    end;

    local procedure MakeExcelDataHeader()
    begin
        //++BSS.IT_20447.SG
        ExcelBuf.AddColumn(C_BSS_INF001 + '(' + COPYSTR(CurrReport.OBJECTID(FALSE), 8) + ')', FALSE, '', TRUE, FALSE, FALSE, '', 1);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', 1);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', 1);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', 1);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', 1);
        ExcelBuf.AddColumn(TODAY, FALSE, '', FALSE, FALSE, FALSE, '', 1);
        ExcelBuf.AddColumn(TIME, FALSE, '', FALSE, FALSE, FALSE, '', 1);
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn(CompanyInfo.Name + ' ' + CompanyInfo."Name 2", FALSE, '', TRUE, FALSE, FALSE, '', 1);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', 1);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', 1);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', 1);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', 1);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', 1);
        ExcelBuf.AddColumn(USERID, FALSE, '', FALSE, FALSE, FALSE, '', 1);
        ExcelBuf.NewRow;
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn(ItemFilter, FALSE, '', FALSE, FALSE, FALSE, '', 1);
        ExcelBuf.AddColumn(PeriodText, FALSE, '', FALSE, FALSE, FALSE, '', 1);
        ExcelBuf.NewRow;
        //--BSS.IT_20447.SG
    end;

    [Scope('OnPrem')]
    procedure CreateExcelBook()
    var
        FileNameL: Text;
    begin
        //++BSS.IT_20447.SG
        //++BSS.IT_20913.SG
        //ExcelBuf.CreateBookAndOpenExcel(C_BSS_INF002,C_BSS_INF003,COMPANYNAME,USERID);
        ExcelBuf.CreateBookAndOpenExcel(FileNameL, C_BSS_INF002, C_BSS_INF003, COMPANYNAME, USERID);
        //--BSS.IT_20913.SG
        //--BSS.IT_20447.SG
    end;

    [Scope('OnPrem')]
    procedure MakeExcelDataBody(par1: Text[150]; par2: Text[150]; par3: Text[150]; par4: Text[150]; par5: Text[150]; par6: Text[150]; par7: Text[150]; par8: Text[150]; par9: Text; par10: Text; par11: Text; par12: Text; par13: Text; par14: Text; par15: Text)
    var
        BlankFiller: Text[250];
    begin
        //++BSS.IT_20447.SG
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn(par1, FALSE, '', FALSE, FALSE, FALSE, '', 0);
        ExcelBuf.AddColumn(par2, FALSE, '', FALSE, FALSE, FALSE, '', 0);
        ExcelBuf.AddColumn(par3, FALSE, '', FALSE, FALSE, FALSE, '', 0);
        //++BSS.IT_20894.CM
        ExcelBuf.AddColumn(par14, FALSE, '', FALSE, FALSE, FALSE, '', 1);
        //--BSS.IT_20894.CM
        ExcelBuf.AddColumn(par4, FALSE, '', FALSE, FALSE, FALSE, '0.00', 0);
        ExcelBuf.AddColumn(par5, FALSE, '', FALSE, FALSE, FALSE, '0.00', 0);
        ExcelBuf.AddColumn(par6, FALSE, '', FALSE, FALSE, FALSE, '0.00', 0);
        ExcelBuf.AddColumn(par7, FALSE, '', FALSE, FALSE, FALSE, '0.00', 0);
        //++BSS.IT_20894.CM
        ExcelBuf.AddColumn(par15, FALSE, '', FALSE, FALSE, FALSE, '0.00', 0);
        //--BSS.IT_20894.CM
        ExcelBuf.AddColumn(par8, FALSE, '', FALSE, FALSE, FALSE, '0.00', 0);
        ExcelBuf.AddColumn(par9, FALSE, '', FALSE, FALSE, FALSE, '0.00', 0);
        ExcelBuf.AddColumn(par10, FALSE, '', FALSE, FALSE, FALSE, '', 0);
        ExcelBuf.AddColumn(par11, FALSE, '', FALSE, FALSE, FALSE, '', 0);
        ExcelBuf.AddColumn(par12, FALSE, '', FALSE, FALSE, FALSE, '', 0);
        ExcelBuf.AddColumn(par13, FALSE, '', FALSE, FALSE, FALSE, '', 0);
        //--BSS.IT_20447.SG
    end;

    [Scope('OnPrem')]
    procedure MakeExcelDataBodyBold(par1: Text[150]; par2: Text[150]; par3: Text[150]; par4: Text[150]; par5: Text[150]; par6: Text[150]; par7: Text[150]; par8: Text[150]; par9: Text; par10: Text; par11: Text; par12: Text; par13: Text; par14: Text; par15: Text)
    var
        BlankFiller: Text[250];
    begin
        //++BSS.IT_20447.SG
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn(par1, FALSE, '', TRUE, FALSE, FALSE, '', 0);
        ExcelBuf.AddColumn(par2, FALSE, '', TRUE, FALSE, FALSE, '', 0);
        ExcelBuf.AddColumn(par3, FALSE, '', TRUE, FALSE, FALSE, '', 0);
        //++BSS.IT_20894.CM
        ExcelBuf.AddColumn(par14, FALSE, '', TRUE, FALSE, FALSE, '', 1);
        //--BSS.IT_20894.CM
        ExcelBuf.AddColumn(par4, FALSE, '', TRUE, FALSE, FALSE, '0.00', 0);
        ExcelBuf.AddColumn(par5, FALSE, '', TRUE, FALSE, FALSE, '0.00', 0);
        ExcelBuf.AddColumn(par6, FALSE, '', TRUE, FALSE, FALSE, '0.00', 0);
        ExcelBuf.AddColumn(par7, FALSE, '', TRUE, FALSE, FALSE, '0.00', 0);
        //++BSS.IT_20894.CM
        ExcelBuf.AddColumn(par15, FALSE, '', TRUE, FALSE, FALSE, '0.00', 0);
        //--BSS.IT_20894.CM
        ExcelBuf.AddColumn(par8, FALSE, '', TRUE, FALSE, FALSE, '0.00', 0);
        ExcelBuf.AddColumn(par9, FALSE, '', TRUE, FALSE, FALSE, '0.00', 0);
        ExcelBuf.AddColumn(par10, FALSE, '', TRUE, FALSE, FALSE, '', 0);
        ExcelBuf.AddColumn(par11, FALSE, '', TRUE, FALSE, FALSE, '', 0);
        ExcelBuf.AddColumn(par12, FALSE, '', TRUE, FALSE, FALSE, '', 0);
        ExcelBuf.AddColumn(par13, FALSE, '', TRUE, FALSE, FALSE, '', 0);
        //--BSS.IT_20447.SG
    end;

    local procedure CalcSalesDiscountAmount(): Decimal
    begin
        //++BSS.IT_20890.SG
        WITH ItemStatisticsBuf DO BEGIN
            CALCFIELDS("Discount Amount");
            EXIT("Discount Amount");
        END;
        //--BSS.IT_20890.SG
    end;

    [IntegrationEvent(TRUE, TRUE)]
    local procedure OnPostReportEvent()
    begin
    end;
}

