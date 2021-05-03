report 50038 "TWN Update Performance Buffer"
{
    // +--------------------------------------------------------------+
    // | @ 2017 incadea Taiwan Limited                                |
    // +--------------------------------------------------------------+
    // | PURPOSE: MARS_TWN                                            |
    // |                                                              |
    // +--------------------------------------------------------------+
    // 
    // VERSION       ID          WHO    DATE        DESCRIPTION
    // TWN.01.01     RGS_TWN-459 AH     2017-06-02  Upgraded from R3
    // +----------------------------------------------+
    // | Copyright (c) incadea China                  |
    // +----------------------------------------------+
    // TFS          ID             WHO    DATE        DESCRIPTION
    // 112816       RGS_TWN-777    GG     2018-03-21  Change filter from "Responsibility Center" to "Service Center"

    ProcessingOnly = true;

    dataset
    {
        dataitem("Responsibility Center1"; "Service Center")
        {
            DataItemTableView = SORTING(Code);
            RequestFilterFields = "Code";

            trigger OnAfterGetRecord()
            begin

                TireSetup.GET;
                TireSetup.TESTFIELD("Position group of Balancing");
                TireSetup.TESTFIELD("Position group of Alignments");
                TireSetup.TESTFIELD("Position Group For Tire");
                CalculateDate1;
                //++BSS.IT_6000.SR
                TireSetup.TESTFIELD("Position Group For Tire RelSer");
                //--BSS.IT_6000.SR
                //++BSS.IT_8888.WL
                IF GUIALLOWED THEN
                    //--BSS.IT_8888.WL
                    Window.OPEN(
                    '#1#################################\\' +
                    C_BSS_INF001 +
                    C_BSS_INF002 +
                    C_BSS_INF003 +
                    C_BSS_INF004 +
                    C_BSS_INF005 +
                    C_BSS_INF006 +
                    C_BSS_INF007 +
                    C_BSS_INF008 +
                    //++BSS.IT_6008.SR
                    C_BSS_INF009
                    //--BSS.IT_6008.SR
                    );

                //++BSS.IT_6966.AP
                //Window.UPDATE(1,STRSUBSTNO('Dealer-%1 Zone-%2 Branch-%3',"Global Dimension 2 Code","Global Dimension 1 Code",Code));
                //++BSS.IT_8888.WL
                IF GUIALLOWED THEN
                    Window.UPDATE(1, STRSUBSTNO('Dealer-%1 Zone-%2 Branch-%3', "Dealer Dimension Value", "Zone Dimension Value", Code));
                //--BSS.IT_8888.WL
                //--BSS.IT_6966.AP

                LineCount := 0;
                TempDate := YTDStartDate;
                WHILE (TempDate <= MTDStartDate) DO BEGIN
                    //++BSS.IT_5937.SR
                    /*
                      SalesInvoiceLine.RESET;
                      SalesInvoiceLine.SETCURRENTKEY("Item Type","Shortcut Dimension 2 Code","Responsibility Center","Posting Date",Retail);
                      SalesInvoiceLine.SETRANGE(Retail);
                      SalesInvoiceLine.SETRANGE("Item Type",SalesInvoiceLine."Item Type"::Tire);
                      SalesInvoiceLine.SETRANGE("Shortcut Dimension 2 Code","Global Dimension 2 Code");
                      SalesInvoiceLine.SETRANGE("Responsibility Center",Code);
                      SalesInvoiceLine.SETRANGE("Posting Date",TempDate,CALCDATE('<CM>',TempDate));
                      SalesInvoiceLine.CALCSUMS(Quantity);
                    */
                    DailyStatisticEntry.RESET;
                    DailyStatisticEntry.SETCURRENTKEY("Service Center Code", "Zone Code", "Dealer Code", "Posting Date",
                                                       "Position Group", "Customer Group");
                    DailyStatisticEntry.SETRANGE("Service Center Code", Code);

                    //++BSS.IT_6966.AP
                    //  DailyStatisticEntry.SETRANGE("Dealer Code","Global Dimension 2 Code");
                    DailyStatisticEntry.SETRANGE("Dealer Code", "Dealer Dimension Value");
                    //--BSS.IT_6966.AP

                    DailyStatisticEntry.SETRANGE("Posting Date", TempDate, CALCDATE('<CM>', TempDate));
                    DailyStatisticEntry.SETFILTER("Position Group", TireSetup."Position Group For Tire");
                    IF DailyStatisticEntry.FINDFIRST THEN BEGIN
                        DailyStatisticEntry.CALCSUMS("Sales Quantity Invoiced");
                        //--BSS.IT_5937.SR
                        //++BSS.IT_6966.AP
                        //    IF PerfBuffer.GET("Global Dimension 2 Code",Code,DATE2DMY(TempDate,2),DATE2DMY(TempDate,3),
                        //                      CALCDATE('<-CM>',TempDate)) THEN BEGIN
                        IF PerfBuffer.GET("Dealer Dimension Value", Code, DATE2DMY(TempDate, 2), DATE2DMY(TempDate, 3),
                                          CALCDATE('<-CM>', TempDate)) THEN BEGIN
                            //--BSS.IT_6966.AP
                            PerfBuffer."No. of Tyres Sold" += DailyStatisticEntry."Sales Quantity Invoiced";
                            PerfBuffer.MODIFY(TRUE);
                        END ELSE BEGIN
                            PerfBuffer.INIT;

                            //++BSS.IT_6966.AP
                            //      PerfBuffer."Dealer Code" := "Global Dimension 2 Code";
                            //      PerfBuffer."Zone Code" := "Global Dimension 1 Code";
                            PerfBuffer."Dealer Code" := "Dealer Dimension Value";
                            PerfBuffer."Zone Code" := "Zone Dimension Value";
                            //--BSS.IT_6966.AP

                            PerfBuffer."Responsibility center" := Code;
                            PerfBuffer.Month := DATE2DMY(TempDate, 2);
                            PerfBuffer.Year := DATE2DMY(TempDate, 3);
                            PerfBuffer."No. of Tyres Sold" := DailyStatisticEntry."Sales Quantity Invoiced";
                            PerfBuffer."Month Start Date" := CALCDATE('<-CM>', TempDate);
                            PerfBuffer."Month End Date" := CALCDATE('<CM>', TempDate);
                            PerfBuffer.INSERT;
                        END;
                    END;

                    //++BSS.IT_5937.SR
                    /*
                      SalesInvoiceLine.SETRANGE("Posting Date",CALCDATE('<-1Y>',TempDate),CALCDATE('<-1Y>',CALCDATE('<CM>',TempDate)));
                      SalesInvoiceLine.CALCSUMS(Quantity);
                    */
                    DailyStatisticEntry.SETRANGE("Posting Date", CALCDATE('<-1Y>', TempDate), CALCDATE('<-1Y>', CALCDATE('<CM>', TempDate)));
                    IF DailyStatisticEntry.FINDFIRST THEN BEGIN
                        DailyStatisticEntry.CALCSUMS("Sales Quantity Invoiced");
                        //--BSS.IT_5937.SR

                        //++BSS.IT_6966.AP
                        //    IF PerfBuffer.GET("Global Dimension 2 Code",Code,DATE2DMY(CALCDATE('<-1Y>',TempDate),2),
                        IF PerfBuffer.GET("Dealer Dimension Value", Code, DATE2DMY(CALCDATE('<-1Y>', TempDate), 2),
                                          DATE2DMY(CALCDATE('<-1Y>', TempDate), 3), CALCDATE('<-1Y>', CALCDATE('<-CM>', TempDate)))
                        //--BSS.IT_6966.AP
                        THEN BEGIN
                            PerfBuffer."No. of Tyres Sold" += DailyStatisticEntry."Sales Quantity Invoiced";
                            PerfBuffer.MODIFY(TRUE);
                        END ELSE BEGIN
                            PerfBuffer.INIT;

                            //++BSS.IT_6966.AP
                            //      PerfBuffer."Dealer Code" := "Global Dimension 2 Code";
                            //      PerfBuffer."Zone Code" := "Global Dimension 1 Code";
                            PerfBuffer."Dealer Code" := "Dealer Dimension Value";
                            PerfBuffer."Zone Code" := "Zone Dimension Value";
                            //--BSS.IT_6966.AP

                            PerfBuffer."Responsibility center" := Code;
                            PerfBuffer.Month := DATE2DMY(CALCDATE('<-1Y>', TempDate), 2);
                            PerfBuffer.Year := DATE2DMY(CALCDATE('<-1Y>', TempDate), 3);
                            PerfBuffer."No. of Tyres Sold" := DailyStatisticEntry."Sales Quantity Invoiced";
                            PerfBuffer."Month Start Date" := CALCDATE('<-1Y>', CALCDATE('<-CM>', TempDate));
                            PerfBuffer."Month End Date" := CALCDATE('<-1Y>', CALCDATE('<CM>', TempDate));
                            PerfBuffer.INSERT;
                        END;
                    END;


                    LineCount += 1;
                    //++BSS.IT_8888.WL
                    IF GUIALLOWED THEN
                        Window.UPDATE(3, LineCount);
                    //--BSS.IT_8888.WL

                    /*
                      SalesInvoiceLine.SETRANGE(Retail,TRUE);
                      SalesInvoiceLine.CALCSUMS(Quantity);
                    */
                    CLEAR(RetailFilter);
                    CustomerGroup.RESET;
                    CustomerGroup.SETCURRENTKEY(Retail);
                    CustomerGroup.SETRANGE(Retail, TRUE);
                    IF CustomerGroup.FINDSET THEN
                        REPEAT
                            IF RetailFilter <> '' THEN
                                RetailFilter := RetailFilter + '|' + CustomerGroup."Customer Group Code"
                            ELSE
                                RetailFilter := CustomerGroup."Customer Group Code";
                        UNTIL CustomerGroup.NEXT = 0;
                    DailyStatisticEntry.SETFILTER("Customer Group", RetailFilter);
                    IF DailyStatisticEntry.FINDFIRST THEN BEGIN
                        DailyStatisticEntry.CALCSUMS("Sales Quantity Invoiced");
                        //--BSS.IT_5937.SR

                        //++BSS.IT_6966.AP
                        //    IF PerfBuffer.GET("Global Dimension 2 Code",Code,DATE2DMY(CALCDATE('<-1Y>',TempDate),2),
                        IF PerfBuffer.GET("Dealer Dimension Value", Code, DATE2DMY(CALCDATE('<-1Y>', TempDate), 2),
                                          //--BSS.IT_6966.AP
                                          DATE2DMY(CALCDATE('<-1Y>', TempDate), 3), CALCDATE('<-1Y>', CALCDATE('<-CM>', TempDate)))
                        THEN BEGIN
                            PerfBuffer."No. of Tyres Sold Retail" += DailyStatisticEntry."Sales Quantity Invoiced";
                            PerfBuffer.MODIFY(TRUE);
                        END ELSE BEGIN
                            PerfBuffer.INIT;

                            //++BSS.IT_6966.AP
                            //      PerfBuffer."Dealer Code" := "Global Dimension 2 Code";
                            //      PerfBuffer."Zone Code" := "Global Dimension 1 Code";
                            PerfBuffer."Dealer Code" := "Dealer Dimension Value";
                            PerfBuffer."Zone Code" := "Zone Dimension Value";
                            //--BSS.IT_6966.AP

                            PerfBuffer.Month := DATE2DMY(CALCDATE('<-1Y>', TempDate), 2);
                            PerfBuffer.Year := DATE2DMY(CALCDATE('<-1Y>', TempDate), 3);
                            PerfBuffer."Responsibility center" := Code;
                            PerfBuffer."No. of Tyres Sold Retail" := DailyStatisticEntry."Sales Quantity Invoiced";
                            PerfBuffer."Month Start Date" := CALCDATE('<-1Y>', CALCDATE('<-CM>', TempDate));
                            PerfBuffer."Month End Date" := CALCDATE('<-1Y>', CALCDATE('<CM>', TempDate));
                            PerfBuffer.INSERT;
                        END;
                    END;
                    //++BSS.IT_5937.SR
                    /*
                      SalesInvoiceLine.SETRANGE("Posting Date",TempDate,CALCDATE('<CM>',TempDate));
                      SalesInvoiceLine.CALCSUMS(Quantity);
                    */
                    DailyStatisticEntry.SETRANGE("Posting Date", TempDate, CALCDATE('<CM>', TempDate));
                    IF DailyStatisticEntry.FINDFIRST THEN BEGIN
                        DailyStatisticEntry.CALCSUMS("Sales Quantity Invoiced");
                        //--BSS.IT_5937.SR

                        //++BSS.IT_6966.AP
                        //    IF PerfBuffer.GET("Global Dimension 2 Code",Code,DATE2DMY(TempDate,2),DATE2DMY(TempDate,3),
                        IF PerfBuffer.GET("Dealer Dimension Value", Code, DATE2DMY(TempDate, 2), DATE2DMY(TempDate, 3),
                                         //--BSS.IT_6966.AP
                                         CALCDATE('<-CM>', TempDate)) THEN BEGIN
                            PerfBuffer."No. of Tyres Sold Retail" += DailyStatisticEntry."Sales Quantity Invoiced";
                            PerfBuffer.MODIFY(TRUE);
                        END ELSE BEGIN
                            PerfBuffer.INIT;

                            //++BSS.IT_6966.AP
                            //      PerfBuffer."Dealer Code" := "Global Dimension 2 Code";
                            //      PerfBuffer."Zone Code" := "Global Dimension 1 Code";
                            PerfBuffer."Dealer Code" := "Dealer Dimension Value";
                            PerfBuffer."Zone Code" := "Zone Dimension Value";
                            //--BSS.IT_6966.AP

                            PerfBuffer.Month := DATE2DMY(TempDate, 2);
                            PerfBuffer.Year := DATE2DMY(TempDate, 3);
                            PerfBuffer."Responsibility center" := Code;
                            PerfBuffer."No. of Tyres Sold Retail" := DailyStatisticEntry."Sales Quantity Invoiced";
                            PerfBuffer."Month Start Date" := CALCDATE('<-CM>', TempDate);
                            PerfBuffer."Month End Date" := CALCDATE('<CM>', TempDate);
                            PerfBuffer.INSERT;
                        END;
                    END;
                    //++BSS.IT_8888.WL
                    IF GUIALLOWED THEN
                        Window.UPDATE(4, LineCount);
                    //--BSS.IT_8888.WL

                    //++BSS.IT_5937.SR
                    DailyStatisticEntry.RESET;
                    DailyStatisticEntry.SETCURRENTKEY("Service Center Code", "Zone Code", "Dealer Code", "Posting Date",
                                                       "Position Group", "Customer Group");
                    DailyStatisticEntry.SETRANGE("Service Center Code", Code);
                    //++BSS.IT_6966.AP
                    //  DailyStatisticEntry.SETRANGE("Dealer Code","Global Dimension 2 Code");
                    DailyStatisticEntry.SETRANGE("Dealer Code", "Dealer Dimension Value");
                    //--BSS.IT_6966.AP
                    DailyStatisticEntry.SETRANGE("Posting Date", TempDate, CALCDATE('<CM>', TempDate));
                    DailyStatisticEntry.SETFILTER("Position Group", TireSetup."Position group of Balancing");
                    IF DailyStatisticEntry.FINDFIRST THEN BEGIN
                        DailyStatisticEntry.CALCSUMS("Sales Quantity Invoiced");

                        //++BSS.IT_6966.AP
                        //    IF PerfBuffer.GET("Global Dimension 2 Code",Code,DATE2DMY(TempDate,2),DATE2DMY(TempDate,3),
                        IF PerfBuffer.GET("Dealer Dimension Value", Code, DATE2DMY(TempDate, 2), DATE2DMY(TempDate, 3),
                                          //--BSS.IT_6966.AP
                                          CALCDATE('<-CM>', TempDate)) THEN BEGIN
                            PerfBuffer."No. of Balancing" += DailyStatisticEntry."Sales Quantity Invoiced";
                            PerfBuffer.MODIFY(TRUE);
                        END ELSE BEGIN
                            PerfBuffer.INIT;

                            //++BSS.IT_6966.AP
                            //      PerfBuffer."Dealer Code" := "Global Dimension 2 Code";
                            //      PerfBuffer."Zone Code" := "Global Dimension 1 Code";
                            PerfBuffer."Dealer Code" := "Dealer Dimension Value";
                            PerfBuffer."Zone Code" := "Zone Dimension Value";
                            //--BSS.IT_6966.AP

                            PerfBuffer."Responsibility center" := Code;
                            PerfBuffer.Month := DATE2DMY(TempDate, 2);
                            PerfBuffer.Year := DATE2DMY(TempDate, 3);
                            PerfBuffer."No. of Balancing" := DailyStatisticEntry."Sales Quantity Invoiced";
                            PerfBuffer."Month Start Date" := CALCDATE('<-CM>', TempDate);
                            PerfBuffer."Month End Date" := CALCDATE('<CM>', TempDate);
                            PerfBuffer.INSERT;
                        END;
                    END;

                    DailyStatisticEntry.SETRANGE("Posting Date", CALCDATE('<-1Y>', TempDate), CALCDATE('<-1Y>', CALCDATE('<CM>', TempDate)));
                    IF DailyStatisticEntry.FINDFIRST THEN BEGIN
                        DailyStatisticEntry.CALCSUMS("Sales Quantity Invoiced");
                        //++BSS.IT_6966.AP
                        //    IF PerfBuffer.GET("Global Dimension 2 Code",Code,DATE2DMY(CALCDATE('<-1Y>',TempDate),2),
                        IF PerfBuffer.GET("Dealer Dimension Value", Code, DATE2DMY(CALCDATE('<-1Y>', TempDate), 2),
                                          //--BSS.IT_6966.AP
                                          DATE2DMY(CALCDATE('<-1Y>', TempDate), 3), CALCDATE('<-1Y>', CALCDATE('<-CM>', TempDate)))
                        THEN BEGIN
                            PerfBuffer."No. of Balancing" += DailyStatisticEntry."Sales Quantity Invoiced";
                            PerfBuffer.MODIFY(TRUE);
                        END ELSE BEGIN
                            PerfBuffer.INIT;

                            //++BSS.IT_6966.AP
                            //      PerfBuffer."Dealer Code" := "Global Dimension 2 Code";
                            //      PerfBuffer."Zone Code" := "Global Dimension 1 Code";
                            PerfBuffer."Dealer Code" := "Dealer Dimension Value";
                            PerfBuffer."Zone Code" := "Zone Dimension Value";
                            //--BSS.IT_6966.AP

                            PerfBuffer."Responsibility center" := Code;
                            PerfBuffer.Month := DATE2DMY(CALCDATE('<-1Y>', TempDate), 2);
                            PerfBuffer.Year := DATE2DMY(CALCDATE('<-1Y>', TempDate), 3);
                            PerfBuffer."No. of Balancing" := DailyStatisticEntry."Sales Quantity Invoiced";
                            PerfBuffer."Month Start Date" := CALCDATE('<-1Y>', CALCDATE('<-CM>', TempDate));
                            PerfBuffer."Month End Date" := CALCDATE('<-1Y>', CALCDATE('<CM>', TempDate));
                            PerfBuffer.INSERT;
                        END;
                    END;

                    DailyStatisticEntry.SETFILTER("Position Group", TireSetup."Position group of Alignments");
                    IF DailyStatisticEntry.FINDFIRST THEN BEGIN
                        DailyStatisticEntry.CALCSUMS("Sales Quantity Invoiced");

                        //++BSS.IT_6966.AP
                        //    IF PerfBuffer.GET("Global Dimension 2 Code",Code,DATE2DMY(CALCDATE('<-1Y>',TempDate),2),
                        IF PerfBuffer.GET("Dealer Dimension Value", Code, DATE2DMY(CALCDATE('<-1Y>', TempDate), 2),
                                          //--BSS.IT_6966.AP
                                          DATE2DMY(CALCDATE('<-1Y>', TempDate), 3), CALCDATE('<-1Y>', CALCDATE('<-CM>', TempDate)))
                        THEN BEGIN
                            PerfBuffer."No. of Aligment" += DailyStatisticEntry."Sales Quantity Invoiced";
                            PerfBuffer.MODIFY(TRUE);
                        END ELSE BEGIN
                            PerfBuffer.INIT;

                            //++BSS.IT_6966.AP
                            //      PerfBuffer."Dealer Code" := "Global Dimension 2 Code";
                            //      PerfBuffer."Zone Code" := "Global Dimension 1 Code";
                            PerfBuffer."Dealer Code" := "Dealer Dimension Value";
                            PerfBuffer."Zone Code" := "Zone Dimension Value";
                            //--BSS.IT_6966.AP

                            PerfBuffer."Responsibility center" := Code;
                            PerfBuffer.Month := DATE2DMY(CALCDATE('<-1Y<', TempDate), 2);
                            PerfBuffer.Year := DATE2DMY(CALCDATE('<-1Y>', TempDate), 3);
                            PerfBuffer."No. of Aligment" := DailyStatisticEntry."Sales Quantity Invoiced";
                            PerfBuffer."Month Start Date" := CALCDATE('<-1Y>', CALCDATE('<-CM>', TempDate));
                            PerfBuffer."Month End Date" := CALCDATE('<-1Y>', CALCDATE('<CM>', TempDate));
                            PerfBuffer.INSERT;
                        END;
                    END;

                    DailyStatisticEntry.SETRANGE("Posting Date", TempDate, CALCDATE('<CM>', TempDate));
                    IF DailyStatisticEntry.FINDFIRST THEN BEGIN
                        DailyStatisticEntry.CALCSUMS("Sales Quantity Invoiced");

                        //++BSS.IT_6966.AP
                        //    IF PerfBuffer.GET("Global Dimension 2 Code",Code,DATE2DMY(TempDate,2),DATE2DMY(TempDate,3),
                        IF PerfBuffer.GET("Dealer Dimension Value", Code, DATE2DMY(TempDate, 2), DATE2DMY(TempDate, 3),
                                          //--BSS.IT_6966.AP
                                          CALCDATE('<-CM>', TempDate)) THEN BEGIN
                            PerfBuffer."No. of Aligment" += DailyStatisticEntry."Sales Quantity Invoiced";
                            PerfBuffer.MODIFY(TRUE);
                        END ELSE BEGIN
                            PerfBuffer.INIT;

                            //++BSS.IT_6966.AP
                            //      PerfBuffer."Dealer Code" := "Global Dimension 2 Code";
                            //      PerfBuffer."Zone Code" := "Global Dimension 1 Code";
                            PerfBuffer."Dealer Code" := "Dealer Dimension Value";
                            PerfBuffer."Zone Code" := "Zone Dimension Value";
                            //--BSS.IT_6966.AP

                            PerfBuffer."Responsibility center" := Code;
                            PerfBuffer.Month := DATE2DMY(TempDate, 2);
                            PerfBuffer.Year := DATE2DMY(TempDate, 3);
                            PerfBuffer."No. of Aligment" := DailyStatisticEntry."Sales Quantity Invoiced";
                            PerfBuffer."Month Start Date" := CALCDATE('<-CM>', TempDate);
                            PerfBuffer."Month End Date" := CALCDATE('<CM>', TempDate);
                            PerfBuffer.INSERT;
                        END;
                    END;
                    //++BSS.IT_8888.WL
                    IF GUIALLOWED THEN
                        Window.UPDATE(9, LineCount);
                    //--BSS.IT_8888.WL

                    //++BSS.IT_5937.SR
                    /*
                      SalesHeader.RESET;
                      SalesHeader.SETCURRENTKEY("Document Type","No.");
                      SalesHeader.SETRANGE("Document Type",SalesHeader."Document Type"::Quote);
                      SalesHeader.SETRANGE("Shortcut Dimension 2 Code","Global Dimension 2 Code");
                      SalesHeader.SETRANGE("Responsibility Center",Code);
                      SalesHeader.SETRANGE("Order Date",TempDate,CALCDATE('<CM>',TempDate));
                    */
                    SalesInvoiceHeader.RESET;

                    //++BSS.IT_6966.AP
                    //  SalesInvoiceHeader.SETRANGE("Shortcut Dimension 2 Code","Global Dimension 2 Code");
                    SalesInvoiceHeader.SETRANGE("Shortcut Dimension 2 Code", "Dealer Dimension Value");
                    //--BSS.IT_6966.AP

                    SalesInvoiceHeader.SETRANGE("Responsibility Center", Code);
                    SalesInvoiceHeader.SETRANGE("Posting Date", TempDate, CALCDATE('<CM>', TempDate));
                    SalesInvoiceHeader.SETFILTER("Quote No.", '<> %1', '');
                    //--BSS.IT_5937.SR

                    //++BSS.IT_6966.AP
                    //  IF PerfBuffer.GET("Global Dimension 2 Code",Code,DATE2DMY(TempDate,2),DATE2DMY(TempDate,3),
                    IF PerfBuffer.GET("Dealer Dimension Value", Code, DATE2DMY(TempDate, 2), DATE2DMY(TempDate, 3),
                                     //--BSS.IT_6966.AP
                                     CALCDATE('<-CM>', TempDate)) THEN BEGIN
                        PerfBuffer."No. of Quotation" += SalesInvoiceHeader.COUNT;
                        PerfBuffer.MODIFY(TRUE);
                    END ELSE BEGIN
                        PerfBuffer.INIT;

                        //++BSS.IT_6966.AP
                        //      PerfBuffer."Dealer Code" := "Global Dimension 2 Code";
                        //      PerfBuffer."Zone Code" := "Global Dimension 1 Code";
                        PerfBuffer."Dealer Code" := "Dealer Dimension Value";
                        PerfBuffer."Zone Code" := "Zone Dimension Value";
                        //--BSS.IT_6966.AP

                        PerfBuffer."Responsibility center" := Code;
                        PerfBuffer.Month := DATE2DMY(TempDate, 2);
                        PerfBuffer.Year := DATE2DMY(TempDate, 3);
                        PerfBuffer."No. of Quotation" := SalesInvoiceHeader.COUNT;
                        PerfBuffer."Month Start Date" := CALCDATE('<-CM>', TempDate);
                        PerfBuffer."Month End Date" := CALCDATE('<CM>', TempDate);
                        PerfBuffer.INSERT;
                    END;
                    //++BSS.IT_5937.SR
                    //  SalesHeader.SETRANGE("Order Date",CALCDATE('<-1Y>',TempDate),CALCDATE('<-1Y>',CALCDATE('<CM>',TempDate)));
                    SalesInvoiceHeader.SETRANGE("Posting Date", CALCDATE('<-1Y>', TempDate), CALCDATE('<-1Y>', CALCDATE('<CM>', TempDate)));
                    //--BSS.IT_5937.SR

                    //++BSS.IT_6966.AP
                    //  IF PerfBuffer.GET("Global Dimension 2 Code",Code,DATE2DMY(CALCDATE('<-1Y>',TempDate),2),
                    IF PerfBuffer.GET("Dealer Dimension Value", Code, DATE2DMY(CALCDATE('<-1Y>', TempDate), 2),
                                      //--BSS.IT_6966.AP
                                      DATE2DMY(CALCDATE('<-1Y>', TempDate), 3), CALCDATE('<-1Y>', CALCDATE('<-CM>', TempDate)))
                    THEN BEGIN
                        PerfBuffer."No. of Quotation" += SalesInvoiceHeader.COUNT;
                        PerfBuffer.MODIFY(TRUE);
                    END ELSE BEGIN
                        PerfBuffer.INIT;

                        //++BSS.IT_6966.AP
                        //      PerfBuffer."Dealer Code" := "Global Dimension 2 Code";
                        //      PerfBuffer."Zone Code" := "Global Dimension 1 Code";
                        PerfBuffer."Dealer Code" := "Dealer Dimension Value";
                        PerfBuffer."Zone Code" := "Zone Dimension Value";
                        //--BSS.IT_6966.AP

                        PerfBuffer."Responsibility center" := Code;
                        PerfBuffer.Month := DATE2DMY(CALCDATE('<-1Y>', TempDate), 2);
                        PerfBuffer.Year := DATE2DMY(CALCDATE('<-1Y>', TempDate), 3);
                        PerfBuffer."No. of Quotation" := SalesInvoiceHeader.COUNT;
                        PerfBuffer."Month Start Date" := CALCDATE('<-1Y>', CALCDATE('<-CM>', TempDate));
                        PerfBuffer."Month End Date" := CALCDATE('<-1Y>', CALCDATE('<CM>', TempDate));
                        PerfBuffer.INSERT;
                    END;
                    //++BSS.IT_8888.WL
                    IF GUIALLOWED THEN
                        Window.UPDATE(5, LineCount);
                    //--BSS.IT_8888.WL

                    SalesInvoiceHeader.RESET;

                    //++BSS.IT_6966.AP
                    //  SalesInvoiceHeader.SETRANGE("Shortcut Dimension 2 Code","Global Dimension 2 Code");
                    SalesInvoiceHeader.SETRANGE("Shortcut Dimension 2 Code", "Dealer Dimension Value");
                    //--BSS.IT_6966.AP
                    SalesInvoiceHeader.SETRANGE("Responsibility Center", Code);
                    SalesInvoiceHeader.SETRANGE("Posting Date", TempDate, CALCDATE('<CM>', TempDate));

                    //++BSS.IT_6966.AP
                    //  IF PerfBuffer.GET("Global Dimension 2 Code",Code,DATE2DMY(TempDate,2),DATE2DMY(TempDate,3),
                    IF PerfBuffer.GET("Dealer Dimension Value", Code, DATE2DMY(TempDate, 2), DATE2DMY(TempDate, 3),
                                     //--BSS.IT_6966.AP
                                     CALCDATE('<-CM>', TempDate)) THEN BEGIN
                        PerfBuffer."No. of Invoice" += SalesInvoiceHeader.COUNT;
                        PerfBuffer.MODIFY(TRUE);
                    END ELSE BEGIN
                        PerfBuffer.INIT;

                        //++BSS.IT_6966.AP
                        //      PerfBuffer."Dealer Code" := "Global Dimension 2 Code";
                        //      PerfBuffer."Zone Code" := "Global Dimension 1 Code";
                        PerfBuffer."Dealer Code" := "Dealer Dimension Value";
                        PerfBuffer."Zone Code" := "Zone Dimension Value";
                        //--BSS.IT_6966.AP

                        PerfBuffer."Responsibility center" := Code;
                        PerfBuffer.Month := DATE2DMY(TempDate, 2);
                        PerfBuffer.Year := DATE2DMY(TempDate, 3);
                        PerfBuffer."No. of Invoice" := SalesInvoiceHeader.COUNT;
                        PerfBuffer."Month Start Date" := CALCDATE('<-CM>', TempDate);
                        PerfBuffer."Month End Date" := CALCDATE('<CM>', TempDate);
                        PerfBuffer.INSERT;
                    END;
                    SalesInvoiceHeader.SETRANGE("Posting Date", CALCDATE('<-1Y>', TempDate), CALCDATE('<-1Y>', CALCDATE('<CM>', TempDate)));

                    //++BSS.IT_6966.AP
                    //  IF PerfBuffer.GET("Global Dimension 2 Code",Code,DATE2DMY(CALCDATE('<-1Y>',TempDate),2),
                    IF PerfBuffer.GET("Dealer Dimension Value", Code, DATE2DMY(CALCDATE('<-1Y>', TempDate), 2),
                                      //--BSS.IT_6966.AP

                                      DATE2DMY(CALCDATE('<-1Y>', TempDate), 3), CALCDATE('<-1Y>', CALCDATE('<-CM>', TempDate)))
                    THEN BEGIN
                        PerfBuffer."No. of Invoice" += SalesInvoiceHeader.COUNT;
                        PerfBuffer.MODIFY(TRUE);
                    END ELSE BEGIN
                        PerfBuffer.INIT;

                        //++BSS.IT_6966.AP
                        //      PerfBuffer."Dealer Code" := "Global Dimension 2 Code";
                        //      PerfBuffer."Zone Code" := "Global Dimension 1 Code";
                        PerfBuffer."Dealer Code" := "Dealer Dimension Value";
                        PerfBuffer."Zone Code" := "Zone Dimension Value";
                        //--BSS.IT_6966.AP

                        PerfBuffer."Responsibility center" := Code;
                        PerfBuffer.Month := DATE2DMY(CALCDATE('<-1Y>', TempDate), 2);
                        PerfBuffer.Year := DATE2DMY(CALCDATE('<-1Y>', TempDate), 3);
                        PerfBuffer."No. of Invoice" := SalesInvoiceHeader.COUNT;
                        PerfBuffer."Month Start Date" := CALCDATE('<-1Y>', CALCDATE('<-CM>', TempDate));
                        PerfBuffer."Month End Date" := CALCDATE('<-1Y>', CALCDATE('<CM>', TempDate));
                        PerfBuffer.INSERT;
                    END;
                    //++BSS.IT_8888.WL
                    IF GUIALLOWED THEN
                        Window.UPDATE(6, LineCount);
                    //--BSS.IT_8888.WL

                    SalesInvoiceHeader.SETRANGE("Posting Date", TempDate, CALCDATE('<CM>', TempDate));
                    IF SalesInvoiceHeader.FINDSET THEN
                        REPEAT
                            SalesInvoiceLine.RESET;
                            SalesInvoiceLine.SETRANGE("Document No.", SalesInvoiceHeader."No.");
                            SalesInvoiceLine.SETFILTER("Item Type", '<> %1 & <> %2', SalesInvoiceLine."Item Type"::" ",
                                                        SalesInvoiceLine."Item Type"::Tire);
                            IF NOT SalesInvoiceLine.ISEMPTY THEN BEGIN
                                SalesInvoiceLine.SETFILTER("Item Type", '%1', SalesInvoiceLine."Item Type"::Tire);
                                IF SalesInvoiceLine.FINDFIRST THEN BEGIN

                                    //++BSS.IT_6966.AP
                                    //        IF PerfBuffer.GET("Global Dimension 2 Code",Code,DATE2DMY(TempDate,2),DATE2DMY(TempDate,3),
                                    IF PerfBuffer.GET("Dealer Dimension Value", Code, DATE2DMY(TempDate, 2), DATE2DMY(TempDate, 3),
                                                     //--BSS.IT_6966.AP
                                                     CALCDATE('<-CM>', TempDate)) THEN BEGIN
                                        PerfBuffer."No. of Cross Selling Invoice" += 1;
                                        PerfBuffer.MODIFY(TRUE);
                                    END ELSE BEGIN
                                        PerfBuffer.INIT;

                                        //++BSS.IT_6966.AP
                                        //      PerfBuffer."Dealer Code" := "Global Dimension 2 Code";
                                        //      PerfBuffer."Zone Code" := "Global Dimension 1 Code";
                                        PerfBuffer."Dealer Code" := "Dealer Dimension Value";
                                        PerfBuffer."Zone Code" := "Zone Dimension Value";
                                        //--BSS.IT_6966.AP

                                        PerfBuffer."Responsibility center" := Code;
                                        PerfBuffer.Month := DATE2DMY(TempDate, 2);
                                        PerfBuffer.Year := DATE2DMY(TempDate, 3);
                                        PerfBuffer."No. of Cross Selling Invoice" := 1;
                                        PerfBuffer."Month Start Date" := CALCDATE('<-CM<', TempDate);
                                        PerfBuffer."Month End Date" := CALCDATE('<CM>', TempDate);
                                        PerfBuffer.INSERT;
                                    END;
                                END;
                            END;
                        UNTIL SalesInvoiceHeader.NEXT = 0;
                    SalesInvoiceHeader.SETRANGE("Posting Date", CALCDATE('<-1Y>', TempDate), CALCDATE('<-1Y>', CALCDATE('<CM>', TempDate)));
                    IF SalesInvoiceHeader.FINDSET THEN BEGIN
                        SalesInvoiceLine.RESET;
                        SalesInvoiceLine.SETRANGE("Document No.", SalesInvoiceHeader."No.");
                        SalesInvoiceLine.SETFILTER("Item Type", '<> %1 & <> %2', SalesInvoiceLine."Item Type"::" ",
                                                    SalesInvoiceLine."Item Type"::Tire);
                        IF NOT SalesInvoiceLine.ISEMPTY THEN BEGIN
                            SalesInvoiceLine.SETFILTER("Item Type", '%1', SalesInvoiceLine."Item Type"::Tire);
                            IF SalesInvoiceLine.FINDFIRST THEN BEGIN

                                //++BSS.IT_6966.AP
                                //        IF PerfBuffer.GET("Global Dimension 2 Code",Code,DATE2DMY(CALCDATE('<-1Y>',TempDate),2),
                                IF PerfBuffer.GET("Dealer Dimension Value", Code, DATE2DMY(CALCDATE('<-1Y>', TempDate), 2),
                                                  //--BSS.IT_6966.AP
                                                  DATE2DMY(CALCDATE('<-1Y>', CALCDATE('<CM>', TempDate)), 3), CALCDATE('<-1Y>', CALCDATE('<-CM>', TempDate)))
                                THEN BEGIN
                                    PerfBuffer."No. of Cross Selling Invoice" += 1;
                                    PerfBuffer.MODIFY(TRUE);
                                END ELSE BEGIN
                                    PerfBuffer.INIT;

                                    //++BSS.IT_6966.AP
                                    //      PerfBuffer."Dealer Code" := "Global Dimension 2 Code";
                                    //      PerfBuffer."Zone Code" := "Global Dimension 1 Code";
                                    PerfBuffer."Dealer Code" := "Dealer Dimension Value";
                                    PerfBuffer."Zone Code" := "Zone Dimension Value";
                                    //--BSS.IT_6966.AP

                                    PerfBuffer."Responsibility center" := Code;
                                    PerfBuffer.Month := DATE2DMY(CALCDATE('<-1Y>', TempDate), 2);
                                    PerfBuffer.Year := DATE2DMY(CALCDATE('<-1Y>', CALCDATE('<CM>', TempDate)), 3);
                                    PerfBuffer."No. of Cross Selling Invoice" := 1;
                                    PerfBuffer."Month Start Date" := CALCDATE('<-1Y>', CALCDATE('<-CM>', TempDate));
                                    PerfBuffer."Month End Date" := CALCDATE('<-1Y>', CALCDATE('<CM>', TempDate));
                                    PerfBuffer.INSERT;
                                END;
                            END;
                        END;
                    END;

                    //++BSS.IT_6000.SR
                    SalesInvoiceHeader.RESET;

                    //++BSS.IT_6966.AP
                    //  SalesInvoiceHeader.SETRANGE("Shortcut Dimension 2 Code","Global Dimension 2 Code");
                    SalesInvoiceHeader.SETRANGE("Shortcut Dimension 2 Code", "Dealer Dimension Value");
                    //--BSS.IT_6966.AP

                    SalesInvoiceHeader.SETRANGE("Responsibility Center", Code);
                    SalesInvoiceHeader.SETRANGE("Posting Date", TempDate, CALCDATE('<CM>', TempDate));
                    IF SalesInvoiceHeader.FINDSET THEN
                        REPEAT
                            NoOfTireSoldwithSer := 0;
                            SalesInvoiceLine.RESET;
                            SalesInvoiceLine.SETRANGE("Document No.", SalesInvoiceHeader."No.");
                            SalesInvoiceLine.SETRANGE(Type, SalesInvoiceLine.Type::Resource);
                            IF SalesInvoiceLine.FINDSET THEN
                                REPEAT
                                    IF NoOfTireSoldwithSer = 0 THEN BEGIN
                                        Service.RESET;
                                        Service.SETRANGE("No.", SalesInvoiceLine."No.");
                                        Service.SETFILTER("Position Group Code", TireSetup."Position Group For Tire RelSer");
                                        IF Service.FINDFIRST THEN BEGIN
                                            SalesInvoiceLine1.RESET;
                                            SalesInvoiceLine1.SETRANGE("Document No.", SalesInvoiceHeader."No.");
                                            SalesInvoiceLine1.SETRANGE(Type, SalesInvoiceLine1.Type::Item);
                                            IF SalesInvoiceLine1.FINDSET THEN
                                                REPEAT
                                                    Item.RESET;
                                                    Item.SETRANGE("No.", SalesInvoiceLine1."No.");
                                                    Item.SETFILTER("Position Group Code", TireSetup."Position Group For Tire");
                                                    IF Item.FINDFIRST THEN
                                                        NoOfTireSoldwithSer += SalesInvoiceLine1.Quantity;
                                                UNTIL SalesInvoiceLine1.NEXT = 0;
                                        END;
                                    END;
                                UNTIL SalesInvoiceLine.NEXT = 0;
                            IF NoOfTireSoldwithSer <> 0 THEN BEGIN

                                //++BSS.IT_6966.AP
                                //      IF PerfBuffer.GET("Global Dimension 2 Code",Code,DATE2DMY(TempDate,2),DATE2DMY(TempDate,3),
                                IF PerfBuffer.GET("Dealer Dimension Value", Code, DATE2DMY(TempDate, 2), DATE2DMY(TempDate, 3),
                                                 //--BSS.IT_6966.AP
                                                 CALCDATE('<-CM>', TempDate)) THEN BEGIN
                                    PerfBuffer."No. of Tyres Sold with rel ser" += NoOfTireSoldwithSer;
                                    PerfBuffer.MODIFY(TRUE);
                                END ELSE BEGIN
                                    PerfBuffer.INIT;

                                    //++BSS.IT_6966.AP
                                    //      PerfBuffer."Dealer Code" := "Global Dimension 2 Code";
                                    //      PerfBuffer."Zone Code" := "Global Dimension 1 Code";
                                    PerfBuffer."Dealer Code" := "Dealer Dimension Value";
                                    PerfBuffer."Zone Code" := "Zone Dimension Value";
                                    //--BSS.IT_6966.AP

                                    PerfBuffer."Responsibility center" := Code;
                                    PerfBuffer.Month := DATE2DMY(TempDate, 2);
                                    PerfBuffer.Year := DATE2DMY(TempDate, 3);
                                    PerfBuffer."No. of Tyres Sold with rel ser" := NoOfTireSoldwithSer;
                                    PerfBuffer."Month Start Date" := CALCDATE('<-CM>', TempDate);
                                    PerfBuffer."Month End Date" := CALCDATE('<CM>', TempDate);
                                    PerfBuffer.INSERT;
                                END;
                            END;
                        UNTIL SalesInvoiceHeader.NEXT = 0;

                    SalesCrMemoHdr.RESET;

                    //++BSS.IT_6966.AP
                    //  SalesCrMemoHdr.SETRANGE("Shortcut Dimension 2 Code","Global Dimension 2 Code");
                    SalesCrMemoHdr.SETRANGE("Shortcut Dimension 2 Code", "Dealer Dimension Value");
                    //--BSS.IT_6966.AP

                    SalesCrMemoHdr.SETRANGE("Responsibility Center", Code);
                    SalesCrMemoHdr.SETRANGE("Posting Date", TempDate, CALCDATE('<CM>', TempDate));
                    IF SalesCrMemoHdr.FINDSET THEN
                        REPEAT
                            NoOfTirereturnedwithSer := 0;
                            SalesCrMemoLine.RESET;
                            SalesCrMemoLine.SETRANGE("Document No.", SalesCrMemoHdr."No.");
                            SalesCrMemoLine.SETRANGE(Type, SalesCrMemoLine.Type::Resource);
                            IF SalesCrMemoLine.FINDSET THEN
                                REPEAT
                                    IF NoOfTirereturnedwithSer = 0 THEN BEGIN
                                        Service.RESET;
                                        Service.SETRANGE("No.", SalesCrMemoLine."No.");
                                        Service.SETFILTER("Position Group Code", TireSetup."Position Group For Tire RelSer");
                                        IF Service.FINDFIRST THEN BEGIN
                                            SalesCrMemoLine1.RESET;
                                            SalesCrMemoLine1.SETRANGE("Document No.", SalesCrMemoHdr."No.");
                                            SalesCrMemoLine1.SETRANGE(Type, SalesCrMemoLine1.Type::Item);
                                            IF SalesCrMemoLine1.FINDSET THEN
                                                REPEAT
                                                    Item.RESET;
                                                    Item.SETRANGE("No.", SalesCrMemoLine1."No.");
                                                    Item.SETFILTER("Position Group Code", TireSetup."Position Group For Tire");
                                                    IF Item.FINDFIRST THEN
                                                        NoOfTirereturnedwithSer += SalesCrMemoLine1.Quantity;
                                                UNTIL SalesCrMemoLine1.NEXT = 0;
                                        END;
                                    END;
                                UNTIL SalesCrMemoLine.NEXT = 0;
                            IF NoOfTirereturnedwithSer <> 0 THEN BEGIN

                                //++BSS.IT_6966.AP
                                //      IF PerfBuffer.GET("Global Dimension 2 Code",Code,DATE2DMY(TempDate,2),DATE2DMY(TempDate,3),
                                IF PerfBuffer.GET("Dealer Dimension Value", Code, DATE2DMY(TempDate, 2), DATE2DMY(TempDate, 3),
                                                 //--BSS.IT_6966.AP
                                                 CALCDATE('<-CM>', TempDate)) THEN BEGIN
                                    PerfBuffer."No. of Tyres Sold with rel ser" -= NoOfTirereturnedwithSer;
                                    PerfBuffer.MODIFY(TRUE);
                                END ELSE BEGIN
                                    PerfBuffer.INIT;

                                    //++BSS.IT_6966.AP
                                    //      PerfBuffer."Dealer Code" := "Global Dimension 2 Code";
                                    //      PerfBuffer."Zone Code" := "Global Dimension 1 Code";
                                    PerfBuffer."Dealer Code" := "Dealer Dimension Value";
                                    PerfBuffer."Zone Code" := "Zone Dimension Value";
                                    //--BSS.IT_6966.AP

                                    PerfBuffer."Responsibility center" := Code;
                                    PerfBuffer.Month := DATE2DMY(TempDate, 2);
                                    PerfBuffer.Year := DATE2DMY(TempDate, 3);
                                    PerfBuffer."No. of Tyres Sold with rel ser" := -NoOfTirereturnedwithSer;
                                    PerfBuffer."Month Start Date" := CALCDATE('<-CM>', TempDate);
                                    PerfBuffer."Month End Date" := CALCDATE('<CM>', TempDate);
                                    PerfBuffer.INSERT;
                                END;
                            END;
                        UNTIL SalesCrMemoHdr.NEXT = 0;

                    SalesInvoiceHeader.SETRANGE("Posting Date", CALCDATE('<-1Y>', TempDate), CALCDATE('<-1Y>', CALCDATE('<CM>', TempDate)));
                    IF SalesInvoiceHeader.FINDSET THEN
                        REPEAT
                            NoOfTireSoldwithSer := 0;
                            SalesInvoiceLine.RESET;
                            SalesInvoiceLine.SETRANGE("Document No.", SalesInvoiceHeader."No.");
                            SalesInvoiceLine.SETRANGE(Type, SalesInvoiceLine.Type::Resource);
                            IF SalesInvoiceLine.FINDSET THEN
                                REPEAT
                                    IF NoOfTireSoldwithSer = 0 THEN BEGIN
                                        Service.RESET;
                                        Service.SETRANGE("No.", SalesInvoiceLine."No.");
                                        Service.SETFILTER("Position Group Code", TireSetup."Position Group For Tire RelSer");
                                        IF Service.FINDFIRST THEN BEGIN
                                            SalesInvoiceLine1.RESET;
                                            SalesInvoiceLine1.SETRANGE("Document No.", SalesInvoiceHeader."No.");
                                            SalesInvoiceLine1.SETRANGE(Type, SalesInvoiceLine1.Type::Item);
                                            IF SalesInvoiceLine1.FINDSET THEN
                                                REPEAT
                                                    Item.RESET;
                                                    Item.SETRANGE("No.", SalesInvoiceLine1."No.");
                                                    Item.SETFILTER("Position Group Code", TireSetup."Position Group For Tire");
                                                    IF Item.FINDFIRST THEN
                                                        NoOfTireSoldwithSer += SalesInvoiceLine1.Quantity;
                                                UNTIL SalesInvoiceLine1.NEXT = 0;
                                        END;
                                    END;
                                UNTIL SalesInvoiceLine.NEXT = 0;
                            IF NoOfTireSoldwithSer <> 0 THEN BEGIN

                                //++BSS.IT_6966.AP
                                //      IF PerfBuffer.GET("Global Dimension 2 Code",Code,DATE2DMY(CALCDATE('<-1Y>',TempDate),2),
                                IF PerfBuffer.GET("Dealer Dimension Value", Code, DATE2DMY(CALCDATE('<-1Y>', TempDate), 2),
                                                  //--BSS.IT_6966.AP
                                                  DATE2DMY(CALCDATE('<-1Y>', TempDate), 3), CALCDATE('<-1Y>', CALCDATE('<-CM>', TempDate))) THEN BEGIN
                                    PerfBuffer."No. of Tyres Sold with rel ser" += NoOfTireSoldwithSer;
                                    PerfBuffer.MODIFY(TRUE);
                                END ELSE BEGIN
                                    PerfBuffer.INIT;

                                    //++BSS.IT_6966.AP
                                    //      PerfBuffer."Dealer Code" := "Global Dimension 2 Code";
                                    //      PerfBuffer."Zone Code" := "Global Dimension 1 Code";
                                    PerfBuffer."Dealer Code" := "Dealer Dimension Value";
                                    PerfBuffer."Zone Code" := "Zone Dimension Value";
                                    //--BSS.IT_6966.AP

                                    PerfBuffer."Responsibility center" := Code;
                                    PerfBuffer.Month := DATE2DMY(CALCDATE('<-1Y>', TempDate), 2);
                                    PerfBuffer.Year := DATE2DMY(CALCDATE('<-1Y>', CALCDATE('<CM>', TempDate)), 3);
                                    PerfBuffer."No. of Tyres Sold with rel ser" := NoOfTireSoldwithSer;
                                    PerfBuffer."Month Start Date" := CALCDATE('<-1Y>', CALCDATE('<-CM>', TempDate));
                                    PerfBuffer."Month End Date" := CALCDATE('<-1Y>', CALCDATE('<CM>', TempDate));
                                    PerfBuffer.INSERT;
                                END;
                            END;
                        UNTIL SalesInvoiceHeader.NEXT = 0;

                    SalesCrMemoHdr.SETRANGE("Posting Date", CALCDATE('<-1Y>', TempDate), CALCDATE('<-1Y>', CALCDATE('<CM>', TempDate)));
                    IF SalesCrMemoHdr.FINDSET THEN
                        REPEAT
                            NoOfTirereturnedwithSer := 0;
                            SalesCrMemoLine.RESET;
                            SalesCrMemoLine.SETRANGE("Document No.", SalesCrMemoHdr."No.");
                            SalesCrMemoLine.SETRANGE(Type, SalesCrMemoLine.Type::Resource);
                            IF SalesCrMemoLine.FINDSET THEN
                                REPEAT
                                    IF NoOfTirereturnedwithSer = 0 THEN BEGIN
                                        Service.RESET;
                                        Service.SETRANGE("No.", SalesCrMemoLine."No.");
                                        Service.SETFILTER("Position Group Code", TireSetup."Position Group For Tire RelSer");
                                        IF Service.FINDFIRST THEN BEGIN
                                            SalesCrMemoLine1.RESET;
                                            SalesCrMemoLine1.SETRANGE("Document No.", SalesCrMemoHdr."No.");
                                            SalesCrMemoLine1.SETRANGE(Type, SalesCrMemoLine1.Type::Item);
                                            IF SalesCrMemoLine1.FINDSET THEN
                                                REPEAT
                                                    Item.RESET;
                                                    Item.SETRANGE("No.", SalesCrMemoLine1."No.");
                                                    Item.SETFILTER("Position Group Code", TireSetup."Position Group For Tire");
                                                    IF Item.FINDFIRST THEN
                                                        NoOfTirereturnedwithSer += SalesCrMemoLine1.Quantity;
                                                UNTIL SalesCrMemoLine1.NEXT = 0;
                                        END;
                                    END;
                                UNTIL SalesCrMemoLine.NEXT = 0;
                            IF NoOfTirereturnedwithSer <> 0 THEN BEGIN

                                //++BSS.IT_6966.AP
                                //      IF PerfBuffer.GET("Global Dimension 2 Code",Code,DATE2DMY(CALCDATE('<-1Y>',TempDate),2),
                                IF PerfBuffer.GET("Dealer Dimension Value", Code, DATE2DMY(CALCDATE('<-1Y>', TempDate), 2),
                                                  //--BSS.IT_6966.AP
                                                  DATE2DMY(CALCDATE('<-1Y>', TempDate), 3), CALCDATE('<-1Y>', CALCDATE('<-CM>', TempDate))) THEN BEGIN
                                    PerfBuffer."No. of Tyres Sold with rel ser" -= NoOfTirereturnedwithSer;
                                    PerfBuffer.MODIFY(TRUE);
                                END ELSE BEGIN
                                    PerfBuffer.INIT;

                                    //++BSS.IT_6966.AP
                                    //      PerfBuffer."Dealer Code" := "Global Dimension 2 Code";
                                    //      PerfBuffer."Zone Code" := "Global Dimension 1 Code";
                                    PerfBuffer."Dealer Code" := "Dealer Dimension Value";
                                    PerfBuffer."Zone Code" := "Zone Dimension Value";
                                    //--BSS.IT_6966.AP

                                    PerfBuffer."Responsibility center" := Code;
                                    PerfBuffer.Month := DATE2DMY(CALCDATE('<-1Y>', TempDate), 2);
                                    PerfBuffer.Year := DATE2DMY(CALCDATE('<-1Y>', CALCDATE('<CM>', TempDate)), 3);
                                    PerfBuffer."No. of Tyres Sold with rel ser" := -NoOfTirereturnedwithSer;
                                    PerfBuffer."Month Start Date" := CALCDATE('<-1Y>', CALCDATE('<-CM>', TempDate));
                                    PerfBuffer."Month End Date" := CALCDATE('<-1Y>', CALCDATE('<CM>', TempDate));
                                    PerfBuffer.INSERT;
                                END;
                            END;
                        UNTIL SalesCrMemoHdr.NEXT = 0;
                    //--BSS.IT_6000.SR

                    //++BSS.IT_6009.SR
                    NoOfTireSoldwithSer := 0;
                    SalesInvoiceHeader.RESET;

                    //++BSS.IT_6966.AP
                    //  SalesInvoiceHeader.SETRANGE("Shortcut Dimension 2 Code","Global Dimension 2 Code");
                    SalesInvoiceHeader.SETRANGE("Shortcut Dimension 2 Code", "Dealer Dimension Value");
                    //--BSS.IT_6966.AP

                    SalesInvoiceHeader.SETRANGE("Responsibility Center", Code);
                    SalesInvoiceHeader.SETRANGE("Posting Date", TempDate, CALCDATE('<CM>', TempDate));
                    IF SalesInvoiceHeader.FINDSET THEN
                        REPEAT
                            SalesInvoiceLine.RESET;
                            SalesInvoiceLine.SETRANGE("Document No.", SalesInvoiceHeader."No.");
                            SalesInvoiceLine.SETRANGE(Type, SalesInvoiceLine.Type::Resource);
                            IF NOT SalesInvoiceLine.ISEMPTY THEN BEGIN
                                SalesInvoiceHeader.CALCFIELDS(Amount);
                                NoOfTireSoldwithSer += SalesInvoiceHeader.Amount;
                            END;
                        UNTIL SalesInvoiceHeader.NEXT = 0;
                    IF NoOfTireSoldwithSer <> 0 THEN BEGIN

                        //++BSS.IT_6966.AP
                        //    IF PerfBuffer.GET("Global Dimension 2 Code",Code,DATE2DMY(TempDate,2),DATE2DMY(TempDate,3),
                        IF PerfBuffer.GET("Dealer Dimension Value", Code, DATE2DMY(TempDate, 2), DATE2DMY(TempDate, 3),
                                         //--BSS.IT_6966.AP
                                         CALCDATE('<-CM>', TempDate)) THEN BEGIN
                            PerfBuffer."Turnover of invoices with ser" += NoOfTireSoldwithSer;
                            PerfBuffer.MODIFY(TRUE);
                        END ELSE BEGIN
                            PerfBuffer.INIT;

                            //++BSS.IT_6966.AP
                            //      PerfBuffer."Dealer Code" := "Global Dimension 2 Code";
                            //      PerfBuffer."Zone Code" := "Global Dimension 1 Code";
                            PerfBuffer."Dealer Code" := "Dealer Dimension Value";
                            PerfBuffer."Zone Code" := "Zone Dimension Value";
                            //--BSS.IT_6966.AP

                            PerfBuffer."Responsibility center" := Code;
                            PerfBuffer.Month := DATE2DMY(TempDate, 2);
                            PerfBuffer.Year := DATE2DMY(TempDate, 3);
                            PerfBuffer."Turnover of invoices with ser" := NoOfTireSoldwithSer;
                            PerfBuffer."Month Start Date" := CALCDATE('<-CM>', TempDate);
                            PerfBuffer."Month End Date" := CALCDATE('<CM>', TempDate);
                            PerfBuffer.INSERT;
                        END;
                    END;

                    NoOfTirereturnedwithSer := 0;
                    SalesCrMemoHdr.RESET;

                    //++BSS_IT_6966.AP
                    //  SalesCrMemoHdr.SETRANGE("Shortcut Dimension 2 Code","Global Dimension 2 Code");
                    SalesCrMemoHdr.SETRANGE("Shortcut Dimension 2 Code", "Dealer Dimension Value");
                    //--BSS_IT_6966.AP

                    SalesCrMemoHdr.SETRANGE("Responsibility Center", Code);
                    SalesCrMemoHdr.SETRANGE("Posting Date", TempDate, CALCDATE('<CM>', TempDate));
                    IF SalesCrMemoHdr.FINDSET THEN
                        REPEAT
                            SalesCrMemoLine.RESET;
                            SalesCrMemoLine.SETRANGE("Document No.", SalesCrMemoHdr."No.");
                            SalesCrMemoLine.SETRANGE(Type, SalesCrMemoLine.Type::Resource);
                            IF NOT SalesCrMemoLine.ISEMPTY THEN BEGIN
                                SalesCrMemoHdr.CALCFIELDS(Amount);
                                NoOfTirereturnedwithSer += SalesCrMemoHdr.Amount;
                            END;
                        UNTIL SalesCrMemoHdr.NEXT = 0;
                    IF NoOfTirereturnedwithSer <> 0 THEN BEGIN

                        //++BSS.IT_6966.AP
                        //    IF PerfBuffer.GET("Global Dimension 2 Code",Code,DATE2DMY(TempDate,2),DATE2DMY(TempDate,3),
                        IF PerfBuffer.GET("Dealer Dimension Value", Code, DATE2DMY(TempDate, 2), DATE2DMY(TempDate, 3),
                                         //--BSS.IT_6966.AP
                                         CALCDATE('<-CM>', TempDate)) THEN BEGIN
                            PerfBuffer."Turnover of invoices with ser" -= NoOfTirereturnedwithSer;
                            PerfBuffer.MODIFY(TRUE);
                        END ELSE BEGIN
                            PerfBuffer.INIT;

                            //++BSS.IT_6966.AP
                            //      PerfBuffer."Dealer Code" := "Global Dimension 2 Code";
                            //      PerfBuffer."Zone Code" := "Global Dimension 1 Code";
                            PerfBuffer."Dealer Code" := "Dealer Dimension Value";
                            PerfBuffer."Zone Code" := "Zone Dimension Value";
                            //--BSS.IT_6966.AP

                            PerfBuffer."Responsibility center" := Code;
                            PerfBuffer.Month := DATE2DMY(TempDate, 2);
                            PerfBuffer.Year := DATE2DMY(TempDate, 3);
                            PerfBuffer."Turnover of invoices with ser" := -NoOfTirereturnedwithSer;
                            PerfBuffer."Month Start Date" := CALCDATE('<-CM>', TempDate);
                            PerfBuffer."Month End Date" := CALCDATE('<CM>', TempDate);
                            PerfBuffer.INSERT;
                        END;
                    END;

                    NoOfTireSoldwithSer := 0;
                    SalesInvoiceHeader.SETRANGE("Posting Date", CALCDATE('<-1Y>', TempDate), CALCDATE('<-1Y>', CALCDATE('<CM>', TempDate)));
                    IF SalesInvoiceHeader.FINDSET THEN
                        REPEAT
                            SalesInvoiceLine.RESET;
                            SalesInvoiceLine.SETRANGE("Document No.", SalesInvoiceHeader."No.");
                            SalesInvoiceLine.SETRANGE(Type, SalesInvoiceLine.Type::Resource);
                            IF NOT SalesInvoiceLine.ISEMPTY THEN BEGIN
                                SalesInvoiceHeader.CALCFIELDS(Amount);
                                NoOfTireSoldwithSer += SalesInvoiceHeader.Amount;
                            END;
                        UNTIL SalesInvoiceHeader.NEXT = 0;
                    IF NoOfTireSoldwithSer <> 0 THEN BEGIN

                        //++BSS.IT_6966.AP
                        //    IF PerfBuffer.GET("Global Dimension 2 Code",Code,DATE2DMY(CALCDATE('<-1Y>',TempDate),2),
                        IF PerfBuffer.GET("Dealer Dimension Value", Code, DATE2DMY(CALCDATE('<-1Y>', TempDate), 2),
                                          //--BSS.IT_6966.AP
                                          DATE2DMY(CALCDATE('<-1Y>', TempDate), 3), CALCDATE('<-1Y>', CALCDATE('<-CM>', TempDate))) THEN BEGIN
                            PerfBuffer."Turnover of invoices with ser" += NoOfTireSoldwithSer;
                            PerfBuffer.MODIFY(TRUE);
                        END ELSE BEGIN
                            PerfBuffer.INIT;

                            //++BSS.IT_6966.AP
                            //      PerfBuffer."Dealer Code" := "Global Dimension 2 Code";
                            //      PerfBuffer."Zone Code" := "Global Dimension 1 Code";
                            PerfBuffer."Dealer Code" := "Dealer Dimension Value";
                            PerfBuffer."Zone Code" := "Zone Dimension Value";
                            //--BSS.IT_6966.AP

                            PerfBuffer."Responsibility center" := Code;
                            PerfBuffer.Month := DATE2DMY(CALCDATE('<-1Y>', TempDate), 2);
                            PerfBuffer.Year := DATE2DMY(CALCDATE('<-1Y>', CALCDATE('<CM>', TempDate)), 3);
                            PerfBuffer."Turnover of invoices with ser" := NoOfTireSoldwithSer;
                            PerfBuffer."Month Start Date" := CALCDATE('<-1Y>', CALCDATE('<-CM>', TempDate));
                            PerfBuffer."Month End Date" := CALCDATE('<-1Y>', CALCDATE('<CM>', TempDate));
                            PerfBuffer.INSERT;
                        END;
                    END;

                    NoOfTirereturnedwithSer := 0;
                    SalesCrMemoHdr.SETRANGE("Posting Date", CALCDATE('<-1Y>', TempDate), CALCDATE('<-1Y>', CALCDATE('<CM>', TempDate)));
                    IF SalesCrMemoHdr.FINDSET THEN
                        REPEAT
                            SalesCrMemoLine.RESET;
                            SalesCrMemoLine.SETRANGE("Document No.", SalesCrMemoHdr."No.");
                            SalesCrMemoLine.SETRANGE(Type, SalesCrMemoLine.Type::Resource);
                            IF NOT SalesCrMemoLine.ISEMPTY THEN BEGIN
                                SalesCrMemoHdr.CALCFIELDS(Amount);
                                NoOfTirereturnedwithSer += SalesCrMemoHdr.Amount;
                            END;
                        UNTIL SalesCrMemoHdr.NEXT = 0;
                    IF NoOfTirereturnedwithSer <> 0 THEN BEGIN

                        //++BSS.IT_6966.AP
                        //    IF PerfBuffer.GET("Global Dimension 2 Code",Code,DATE2DMY(CALCDATE('<-1Y>',TempDate),2),
                        IF PerfBuffer.GET("Dealer Dimension Value", Code, DATE2DMY(CALCDATE('<-1Y>', TempDate), 2),
                                          //--BSS.IT_6966.AP
                                          DATE2DMY(CALCDATE('<-1Y>', TempDate), 3), CALCDATE('<-1Y>', CALCDATE('<-CM>', TempDate))) THEN BEGIN
                            PerfBuffer."Turnover of invoices with ser" -= NoOfTirereturnedwithSer;
                            PerfBuffer.MODIFY(TRUE);
                        END ELSE BEGIN
                            PerfBuffer.INIT;

                            //++BSS.IT_6966.AP
                            //      PerfBuffer."Dealer Code" := "Global Dimension 2 Code";
                            //      PerfBuffer."Zone Code" := "Global Dimension 1 Code";
                            PerfBuffer."Dealer Code" := "Dealer Dimension Value";
                            PerfBuffer."Zone Code" := "Zone Dimension Value";
                            //--BSS.IT_6966.AP

                            PerfBuffer."Responsibility center" := Code;
                            PerfBuffer.Month := DATE2DMY(CALCDATE('<-1Y>', TempDate), 2);
                            PerfBuffer.Year := DATE2DMY(CALCDATE('<-1Y>', CALCDATE('<CM>', TempDate)), 3);
                            PerfBuffer."Turnover of invoices with ser" := -NoOfTirereturnedwithSer;
                            PerfBuffer."Month Start Date" := CALCDATE('<-1Y>', CALCDATE('<-CM>', TempDate));
                            PerfBuffer."Month End Date" := CALCDATE('<-1Y>', CALCDATE('<CM>', TempDate));
                            PerfBuffer.INSERT;
                        END;
                    END;
                    //--BSS.IT_6009.SR
                    //++BSS.IT_8888.WL
                    IF GUIALLOWED THEN
                        Window.UPDATE(7, LineCount);
                    //--BSS.IT_8888.WL
                    DailyStatisticEntry.RESET;
                    DailyStatisticEntry.SETCURRENTKEY("Posting Date", "Service Center Code", "Zone Code", "Dealer Code",
                                                      "Source Type");
                    DailyStatisticEntry.SETRANGE("Service Center Code", Code);

                    //++BSS.IT_6966.AP
                    //  DailyStatisticEntry.SETRANGE("Dealer Code","Global Dimension 2 Code");
                    DailyStatisticEntry.SETRANGE("Dealer Code", "Dealer Dimension Value");
                    //++BSS.IT_6966.AP
                    DailyStatisticEntry.SETRANGE("Posting Date", TempDate, CALCDATE('<CM>', TempDate));
                    IF DailyStatisticEntry.FINDFIRST THEN BEGIN
                        DailyStatisticEntry.CALCSUMS("Sales Amount");

                        //++BSS.IT_6966.AP
                        //    IF PerfBuffer.GET("Global Dimension 2 Code",Code,DATE2DMY(TempDate,2),DATE2DMY(TempDate,3),
                        IF PerfBuffer.GET("Dealer Dimension Value", Code, DATE2DMY(TempDate, 2), DATE2DMY(TempDate, 3),
                                         //--BSS.IT_6966.AP
                                         CALCDATE('<-CM>', TempDate)) THEN BEGIN
                            PerfBuffer."Total Turnover" += DailyStatisticEntry."Sales Amount";
                            PerfBuffer.MODIFY(TRUE);
                        END ELSE BEGIN
                            PerfBuffer.INIT;

                            //++BSS.IT_6966.AP
                            //      PerfBuffer."Dealer Code" := "Global Dimension 2 Code";
                            //      PerfBuffer."Zone Code" := "Global Dimension 1 Code";
                            PerfBuffer."Dealer Code" := "Dealer Dimension Value";
                            PerfBuffer."Zone Code" := "Zone Dimension Value";
                            //--BSS.IT_6966.AP

                            PerfBuffer."Responsibility center" := Code;
                            PerfBuffer.Month := DATE2DMY(TempDate, 2);
                            PerfBuffer.Year := DATE2DMY(TempDate, 3);
                            PerfBuffer."Total Turnover" := DailyStatisticEntry."Sales Amount";
                            PerfBuffer."Month Start Date" := CALCDATE('<-CM>', TempDate);
                            PerfBuffer."Month End Date" := CALCDATE('<CM>', TempDate);
                            PerfBuffer.INSERT;
                        END;
                    END;
                    DailyStatisticEntry.SETRANGE("Posting Date", CALCDATE('<-1Y>', TempDate), CALCDATE('<-1Y>', CALCDATE('<CM>', TempDate)));
                    IF DailyStatisticEntry.FINDFIRST THEN BEGIN
                        DailyStatisticEntry.CALCSUMS("Sales Amount");

                        //++BSS.IT_6966.AP
                        //    IF PerfBuffer.GET("Global Dimension 2 Code",Code,DATE2DMY(CALCDATE('<-1Y>',TempDate),2),
                        IF PerfBuffer.GET("Dealer Dimension Value", Code, DATE2DMY(CALCDATE('<-1Y>', TempDate), 2),
                                          //--BSS.IT_6966.AP
                                          DATE2DMY(CALCDATE('<-1Y>', TempDate), 3), CALCDATE('<-1Y>', CALCDATE('<-CM>', TempDate)))
                        THEN BEGIN
                            PerfBuffer."Total Turnover" += DailyStatisticEntry."Sales Amount";
                            PerfBuffer.MODIFY(TRUE);
                        END ELSE BEGIN
                            PerfBuffer.INIT;

                            //++BSS.IT_6966.AP
                            //      PerfBuffer."Dealer Code" := "Global Dimension 2 Code";
                            //      PerfBuffer."Zone Code" := "Global Dimension 1 Code";
                            PerfBuffer."Dealer Code" := "Dealer Dimension Value";
                            PerfBuffer."Zone Code" := "Zone Dimension Value";
                            //--BSS.IT_6966.AP

                            PerfBuffer."Responsibility center" := Code;
                            PerfBuffer.Month := DATE2DMY(CALCDATE('<-1Y>', TempDate), 2);
                            PerfBuffer.Year := DATE2DMY(CALCDATE('<-1Y>', TempDate), 3);
                            PerfBuffer."Total Turnover" := DailyStatisticEntry."Sales Amount";
                            PerfBuffer."Month Start Date" := CALCDATE('<-1Y>', CALCDATE('<-CM>', TempDate));
                            PerfBuffer."Month End Date" := CALCDATE('<-1Y>', CALCDATE('<CM>', TempDate));
                            PerfBuffer.INSERT;
                        END;
                    END;
                    //++BSS.IT_8888.WL
                    IF GUIALLOWED THEN
                        Window.UPDATE(2, LineCount);
                    //--BSS.IT_8888.WL
                    DailyStatisticEntry.SETRANGE("Source Type", DailyStatisticEntry."Source Type"::"Res. Ledger Entry");
                    IF DailyStatisticEntry.FINDFIRST THEN BEGIN
                        DailyStatisticEntry.CALCSUMS("Sales Amount");

                        //++BSS.IT_6966.AP
                        //    IF PerfBuffer.GET("Global Dimension 2 Code",Code,DATE2DMY(CALCDATE('<-1Y>',TempDate),2),
                        IF PerfBuffer.GET("Dealer Dimension Value", Code, DATE2DMY(CALCDATE('<-1Y>', TempDate), 2),
                                          //--BSS.IT_6966.AP
                                          DATE2DMY(CALCDATE('<-1Y>', TempDate), 3), CALCDATE('<-1Y>', CALCDATE('<-CM>', TempDate)))
                        THEN BEGIN
                            PerfBuffer."Total services Revenue" += DailyStatisticEntry."Sales Amount";
                            PerfBuffer.MODIFY(TRUE);
                        END ELSE BEGIN
                            PerfBuffer.INIT;

                            //++BSS.IT_6966.AP
                            //      PerfBuffer."Dealer Code" := "Global Dimension 2 Code";
                            //      PerfBuffer."Zone Code" := "Global Dimension 1 Code";
                            PerfBuffer."Dealer Code" := "Dealer Dimension Value";
                            PerfBuffer."Zone Code" := "Zone Dimension Value";
                            //--BSS.IT_6966.AP

                            PerfBuffer.Month := DATE2DMY(CALCDATE('<-1Y>', TempDate), 2);
                            PerfBuffer.Year := DATE2DMY(CALCDATE('<-1Y>', TempDate), 3);
                            PerfBuffer."Responsibility center" := Code;
                            PerfBuffer."Total services Revenue" := DailyStatisticEntry."Sales Amount";
                            PerfBuffer."Month Start Date" := CALCDATE('<-1Y>', CALCDATE('<-CM>', TempDate));
                            PerfBuffer."Month End Date" := CALCDATE('<-1Y>', CALCDATE('<CM>', TempDate));
                            PerfBuffer.INSERT;
                        END;
                    END;
                    DailyStatisticEntry.SETRANGE("Posting Date", TempDate, CALCDATE('<CM>', TempDate));
                    IF DailyStatisticEntry.FINDFIRST THEN BEGIN
                        DailyStatisticEntry.CALCSUMS("Sales Amount");

                        //++BSS.IT_6966.AP
                        //    IF PerfBuffer.GET("Global Dimension 2 Code",Code,DATE2DMY(TempDate,2),DATE2DMY(TempDate,3),
                        IF PerfBuffer.GET("Dealer Dimension Value", Code, DATE2DMY(TempDate, 2), DATE2DMY(TempDate, 3),
                                         //--BSS.IT_6966.AP
                                         CALCDATE('<-CM>', TempDate)) THEN BEGIN
                            PerfBuffer."Total services Revenue" += DailyStatisticEntry."Sales Amount";
                            PerfBuffer.MODIFY(TRUE);
                        END ELSE BEGIN
                            PerfBuffer.INIT;

                            //++BSS.IT_6966.AP
                            //      PerfBuffer."Dealer Code" := "Global Dimension 2 Code";
                            //      PerfBuffer."Zone Code" := "Global Dimension 1 Code";
                            PerfBuffer."Dealer Code" := "Dealer Dimension Value";
                            PerfBuffer."Zone Code" := "Zone Dimension Value";
                            //--BSS.IT_6966.AP

                            PerfBuffer.Month := DATE2DMY(TempDate, 2);
                            PerfBuffer.Year := DATE2DMY(TempDate, 3);
                            PerfBuffer."Responsibility center" := Code;
                            PerfBuffer."Total services Revenue" := DailyStatisticEntry."Sales Amount";
                            PerfBuffer."Month Start Date" := CALCDATE('<-CM>', TempDate);
                            PerfBuffer."Month End Date" := CALCDATE('<CM>', TempDate);
                            PerfBuffer.INSERT;
                        END;
                    END;
                    //++BSS.IT_8888.WL
                    IF GUIALLOWED THEN
                        Window.UPDATE(8, LineCount);
                    //--BSS.IT_8888.WL

                    //++BSS.IT_6008.SR
                    CLEAR(FirstSBnumber);
                    CLEAR(LastSBnumber);
                    NoOfSB := 0;
                    SalesInvoiceHeader.RESET;
                    // Start 112816
                    //  SalesInvoiceHeader.SETCURRENTKEY("Responsibility Center","Shortcut Dimension 2 Code","Shopping Basket No.");
                    SalesInvoiceHeader.SETCURRENTKEY("Service Center", "Shortcut Dimension 2 Code", "Shopping Basket No.");
                    // Stop 112816
                    //++BSS.IT_6966.AP
                    //  SalesInvoiceHeader.SETRANGE("Shortcut Dimension 2 Code","Global Dimension 2 Code");
                    SalesInvoiceHeader.SETRANGE("Shortcut Dimension 2 Code", "Dealer Dimension Value");
                    //--BSS.IT_6966.AP
                    // Start 112816
                    //  SalesInvoiceHeader.SETRANGE("Responsibility Center",Code);
                    SalesInvoiceHeader.SETRANGE("Service Center", Code);
                    // Stop 112816
                    SalesInvoiceHeader.SETRANGE("Posting Date", TempDate, CALCDATE('<CM>', TempDate));
                    SalesInvoiceHeader.SETFILTER("Shopping Basket No.", '<> %1', '');
                    IF SalesInvoiceHeader.FINDFIRST THEN
                        FirstSBnumber := SalesInvoiceHeader."Shopping Basket No.";
                    IF SalesInvoiceHeader.FINDLAST THEN
                        LastSBnumber := SalesInvoiceHeader."Shopping Basket No.";

                    IF (FirstSBnumber <> '') AND (LastSBnumber <> '') THEN BEGIN
                        IF (FirstSBnumber = LastSBnumber) THEN
                            NoOfSB := 1
                        ELSE BEGIN
                            NoOfSB := 1;
                            WHILE (FirstSBnumber <> LastSBnumber) DO BEGIN
                                NoOfSB += 1;
                                FirstSBnumber := INCSTR(FirstSBnumber);
                            END;
                        END;
                    END;

                    //++BSS.IT_6966.AP
                    //  IF PerfBuffer.GET("Global Dimension 2 Code",Code,DATE2DMY(TempDate,2),DATE2DMY(TempDate,3),
                    IF PerfBuffer.GET("Dealer Dimension Value", Code, DATE2DMY(TempDate, 2), DATE2DMY(TempDate, 3),
                                     //--BSS.IT_6966.AP
                                     CALCDATE('<-CM>', TempDate)) THEN BEGIN
                        PerfBuffer."No. of SB" := NoOfSB;
                        PerfBuffer."No. of SB converted" := SalesInvoiceHeader.COUNT;
                        PerfBuffer.MODIFY(TRUE);
                    END ELSE BEGIN
                        PerfBuffer.INIT;

                        //++BSS.IT_6966.AP
                        //      PerfBuffer."Dealer Code" := "Global Dimension 2 Code";
                        //      PerfBuffer."Zone Code" := "Global Dimension 1 Code";
                        PerfBuffer."Dealer Code" := "Dealer Dimension Value";
                        PerfBuffer."Zone Code" := "Zone Dimension Value";
                        //--BSS.IT_6966.AP

                        PerfBuffer."Responsibility center" := Code;
                        PerfBuffer.Month := DATE2DMY(TempDate, 2);
                        PerfBuffer.Year := DATE2DMY(TempDate, 3);
                        PerfBuffer."No. of SB" := NoOfSB;
                        PerfBuffer."No. of SB converted" := SalesInvoiceHeader.COUNT;
                        PerfBuffer."Month Start Date" := CALCDATE('<-CM>', TempDate);
                        PerfBuffer."Month End Date" := CALCDATE('<CM>', TempDate);
                        PerfBuffer.INSERT;
                    END;
                    SalesInvoiceHeader.SETRANGE("Posting Date", CALCDATE('<-1Y>', TempDate), CALCDATE('<-1Y>', CALCDATE('<CM>', TempDate)));
                    CLEAR(FirstSBnumber);
                    CLEAR(LastSBnumber);
                    NoOfSB := 0;
                    IF SalesInvoiceHeader.FINDFIRST THEN
                        FirstSBnumber := SalesInvoiceHeader."Shopping Basket No.";
                    IF SalesInvoiceHeader.FINDLAST THEN
                        LastSBnumber := SalesInvoiceHeader."Shopping Basket No.";

                    IF (FirstSBnumber <> '') AND (LastSBnumber <> '') THEN BEGIN
                        IF (FirstSBnumber = LastSBnumber) THEN
                            NoOfSB := 1
                        ELSE BEGIN
                            NoOfSB := 1;
                            WHILE (FirstSBnumber <> LastSBnumber) DO BEGIN
                                NoOfSB += 1;
                                FirstSBnumber := INCSTR(FirstSBnumber);
                            END;
                        END;
                    END;

                    //++BSS.IT_6966.AP
                    //  IF PerfBuffer.GET("Global Dimension 2 Code",Code,DATE2DMY(CALCDATE('<-1Y>',TempDate),2),
                    IF PerfBuffer.GET("Dealer Dimension Value", Code, DATE2DMY(CALCDATE('<-1Y>', TempDate), 2),
                                      //--BSS.IT_6966.AP
                                      DATE2DMY(CALCDATE('<-1Y>', TempDate), 3), CALCDATE('<-1Y>', CALCDATE('<-CM>', TempDate)))
                    THEN BEGIN
                        PerfBuffer."No. of SB" := NoOfSB;
                        PerfBuffer."No. of SB converted" := SalesInvoiceHeader.COUNT;
                        PerfBuffer.MODIFY(TRUE);
                    END ELSE BEGIN
                        PerfBuffer.INIT;

                        //++BSS.IT_6966.AP
                        //      PerfBuffer."Dealer Code" := "Global Dimension 2 Code";
                        //      PerfBuffer."Zone Code" := "Global Dimension 1 Code";
                        PerfBuffer."Dealer Code" := "Dealer Dimension Value";
                        PerfBuffer."Zone Code" := "Zone Dimension Value";
                        //--BSS.IT_6966.AP

                        PerfBuffer."Responsibility center" := Code;
                        PerfBuffer.Month := DATE2DMY(CALCDATE('<-1Y>', TempDate), 2);
                        PerfBuffer.Year := DATE2DMY(CALCDATE('<-1Y>', TempDate), 3);
                        PerfBuffer."No. of SB" := NoOfSB;
                        PerfBuffer."No. of SB converted" := SalesInvoiceHeader.COUNT;
                        PerfBuffer."Month Start Date" := CALCDATE('<-1Y>', CALCDATE('<-CM>', TempDate));
                        PerfBuffer."Month End Date" := CALCDATE('<-1Y>', CALCDATE('<CM>', TempDate));
                        PerfBuffer.INSERT;
                    END;
                    //++BSS.IT_8888.WL
                    IF GUIALLOWED THEN
                        Window.UPDATE(10, LineCount);
                    //--BSS.IT_8888.WL
                    //--BSS.IT_6008.SR

                    //++BSS.IT_6010.SR
                    DailyStatisticEntry.RESET;
                    DailyStatisticEntry.SETCURRENTKEY("Posting Date", "Service Center Code", "Zone Code", "Dealer Code",
                                                      "Payment Type Code");
                    DailyStatisticEntry.SETRANGE("Service Center Code", Code);

                    //++BSS.IT_6966.AP
                    //  DailyStatisticEntry.SETRANGE("Dealer Code","Global Dimension 2 Code");
                    DailyStatisticEntry.SETRANGE("Dealer Code", "Dealer Dimension Value");
                    //--BSS.IT_6966.AP

                    DailyStatisticEntry.SETRANGE("Posting Date", TempDate, CALCDATE('<CM>', TempDate));
                    DailyStatisticEntry.SETFILTER("Payment Type Code", PMFilter);
                    IF DailyStatisticEntry.FINDFIRST THEN BEGIN
                        DailyStatisticEntry.CALCSUMS("Sales Amount");

                        //++BSS.IT_6966.AP
                        //    IF PerfBuffer.GET("Global Dimension 2 Code",Code,DATE2DMY(TempDate,2),DATE2DMY(TempDate,3),
                        IF PerfBuffer.GET("Dealer Dimension Value", Code, DATE2DMY(TempDate, 2), DATE2DMY(TempDate, 3),
                                         //--BSS.IT_6966.AP
                                         CALCDATE('<-CM>', TempDate)) THEN BEGIN
                            PerfBuffer."Total Cash Sales" := DailyStatisticEntry."Sales Amount";
                            PerfBuffer.MODIFY(TRUE);
                        END ELSE BEGIN
                            PerfBuffer.INIT;

                            //++BSS.IT_6966.AP
                            //      PerfBuffer."Dealer Code" := "Global Dimension 2 Code";
                            //      PerfBuffer."Zone Code" := "Global Dimension 1 Code";
                            PerfBuffer."Dealer Code" := "Dealer Dimension Value";
                            PerfBuffer."Zone Code" := "Zone Dimension Value";
                            //--BSS.IT_6966.AP

                            PerfBuffer."Responsibility center" := Code;
                            PerfBuffer.Month := DATE2DMY(TempDate, 2);
                            PerfBuffer.Year := DATE2DMY(TempDate, 3);
                            PerfBuffer."Total Cash Sales" := DailyStatisticEntry."Sales Amount";
                            PerfBuffer."Month Start Date" := CALCDATE('<-CM>', TempDate);
                            PerfBuffer."Month End Date" := CALCDATE('<CM>', TempDate);
                            PerfBuffer.INSERT;
                        END;
                    END;

                    DailyStatisticEntry.SETRANGE("Posting Date", CALCDATE('<-1Y>', TempDate), CALCDATE('<-1Y>', CALCDATE('<CM>', TempDate)));
                    IF DailyStatisticEntry.FINDFIRST THEN BEGIN
                        DailyStatisticEntry.CALCSUMS("Sales Amount");

                        //++BSS.IT_6966.AP
                        //    IF PerfBuffer.GET("Global Dimension 2 Code",Code,DATE2DMY(CALCDATE('<-1Y>',TempDate),2),
                        IF PerfBuffer.GET("Dealer Dimension Value", Code, DATE2DMY(CALCDATE('<-1Y>', TempDate), 2),
                          //--BSS.IT_6966.AP
                          DATE2DMY(CALCDATE('<-1Y>', TempDate), 3), CALCDATE('<-1Y>', CALCDATE('<-CM>', TempDate)))
                        THEN BEGIN
                            PerfBuffer."Total Cash Sales" := DailyStatisticEntry."Sales Amount";
                            PerfBuffer.MODIFY(TRUE);
                        END ELSE BEGIN
                            PerfBuffer.INIT;

                            //++BSS.IT_6966.AP
                            //      PerfBuffer."Dealer Code" := "Global Dimension 2 Code";
                            //      PerfBuffer."Zone Code" := "Global Dimension 1 Code";
                            PerfBuffer."Dealer Code" := "Dealer Dimension Value";
                            PerfBuffer."Zone Code" := "Zone Dimension Value";
                            //--BSS.IT_6966.AP

                            PerfBuffer."Responsibility center" := Code;
                            PerfBuffer.Month := DATE2DMY(CALCDATE('<-1Y>', TempDate), 2);
                            PerfBuffer.Year := DATE2DMY(CALCDATE('<-1Y>', TempDate), 3);
                            PerfBuffer."Total Cash Sales" := DailyStatisticEntry."Sales Amount";
                            PerfBuffer."Month Start Date" := CALCDATE('<-1Y>', CALCDATE('<-CM>', TempDate));
                            PerfBuffer."Month End Date" := CALCDATE('<-1Y>', CALCDATE('<CM>', TempDate));
                            PerfBuffer.INSERT;
                        END;
                    END;
                    //--BSS.IT_6010.SR
                    LineCount += 1;
                    TempDate := CALCDATE('<1M>', TempDate);
                END;

                LineCount := 0;
                TempDate := MTDStartDate;

                //++BSS.IT_6966.AP
                //IF PerfBuffer.GET("Global Dimension 2 Code",Code,DATE2DMY(TempDate,2),DATE2DMY(TempDate,3),
                IF PerfBuffer.GET("Dealer Dimension Value", Code, DATE2DMY(TempDate, 2), DATE2DMY(TempDate, 3),
                //--BSS.IT_6966.AP
                                 CALCDATE('<-CM>', TempDate)) THEN BEGIN
                    //++BSS.IT_5937.SR
                    /*
                    ResponsibilityCenter.RESET;
                    ResponsibilityCenter.SETRANGE("Global Dimension 2 Code","Global Dimension 2 Code");
                    IF ResponsibilityCenter.FINDSET THEN
                    REPEAT
                      PerfBuffer."No. of Bays":= ResponsibilityCenter."No. of Bays";
                    UNTIL ResponsibilityCenter.NEXT = 0;

                    PositionGroup.RESET;
                    PositionGroup.SETFILTER(Code,TireSetup."Position group of Balancing");
                    PerfBuffer."No. of Balancing" := PositionGroup.COUNT;

                    PositionGroup.SETFILTER(Code,TireSetup."Position group of Alignments");
                    PerfBuffer."No. of Aligment" := PositionGroup.COUNT;
                    */
                    PerfBuffer."No. of Bays" := "No. of Bays";
                    //--BSS.IT_5937.SR

                    "Salesperson/Purchaser".RESET;
                    "Salesperson/Purchaser".SETRANGE("Service Center", Code);
                    "Salesperson/Purchaser".SETRANGE(Retired, FALSE);
                    //++BSS.IT_6021.SR
                    //"Salesperson/Purchaser".SETRANGE("Is Fitter",TRUE);
                    //--BSS.IT_6021.SR
                    PerfBuffer."No. of Employee" := "Salesperson/Purchaser".COUNT;
                    PerfBuffer.MODIFY(TRUE);
                END ELSE BEGIN
                    PerfBuffer.INIT;

                    //++BSS.IT_6966.AP
                    //      PerfBuffer."Dealer Code" := "Global Dimension 2 Code";
                    //      PerfBuffer."Zone Code" := "Global Dimension 1 Code";
                    PerfBuffer."Dealer Code" := "Dealer Dimension Value";
                    PerfBuffer."Zone Code" := "Zone Dimension Value";
                    //--BSS.IT_6966.AP

                    PerfBuffer."Responsibility center" := Code;
                    PerfBuffer.Month := DATE2DMY(TempDate, 2);
                    PerfBuffer.Year := DATE2DMY(TempDate, 3);
                    //++BSS.IT_5937.SR
                    /*
                    ResponsibilityCenter.RESET;
                    ResponsibilityCenter.SETRANGE("Global Dimension 2 Code","Global Dimension 2 Code");
                    IF ResponsibilityCenter.FINDSET THEN
                    REPEAT
                      PerfBuffer."No. of Bays":= ResponsibilityCenter."No. of Bays";
                    UNTIL ResponsibilityCenter.NEXT = 0;

                    PositionGroup.RESET;
                    PositionGroup.SETFILTER(Code,TireSetup."Position group of Balancing");
                    PerfBuffer."No. of Balancing" := PositionGroup.COUNT;

                    PositionGroup.SETFILTER(Code,TireSetup."Position group of Alignments");
                    PerfBuffer."No. of Aligment" := PositionGroup.COUNT;
                    */
                    PerfBuffer."No. of Bays" := "No. of Bays";
                    //--BSS.IT_5937.SR

                    "Salesperson/Purchaser".RESET;
                    "Salesperson/Purchaser".SETRANGE("Service Center", Code);
                    "Salesperson/Purchaser".SETRANGE(Retired, FALSE);
                    //++BSS.IT_6021.SR
                    //"Salesperson/Purchaser".SETRANGE("Is Fitter",TRUE);
                    //--BSS.IT_6021.SR
                    PerfBuffer."No. of Employee" := "Salesperson/Purchaser".COUNT;
                    PerfBuffer."Month Start Date" := CALCDATE('<-CM>', TempDate);
                    PerfBuffer."Month End Date" := CALCDATE('<CM>', TempDate);
                    PerfBuffer.INSERT;
                END;
                //++BSS.IT_8888.WL
                IF GUIALLOWED THEN
                    Window.UPDATE(9, LineCount);
                //--BSS.IT_8888.WL
                LineCount += 1;

                //++BSS.IT_5981.SR
                TempDate := YTDStartDate;
                WHILE (TempDate < MTDStartDate) DO BEGIN

                    //++BSS.IT_6966.AP
                    //  IF PerfBuffer.GET("Global Dimension 2 Code",Code,DATE2DMY(TempDate,2),DATE2DMY(TempDate,3),
                    IF PerfBuffer.GET("Dealer Dimension Value", Code, DATE2DMY(TempDate, 2), DATE2DMY(TempDate, 3),
                                     //--BSS.IT_6966.AP
                                     CALCDATE('<-CM>', TempDate)) THEN BEGIN
                        IF PerfBuffer."No. of Bays" = 0 THEN
                            PerfBuffer."No. of Bays" := "No. of Bays";
                        IF PerfBuffer."No. of Employee" = 0 THEN BEGIN
                            "Salesperson/Purchaser".RESET;
                            "Salesperson/Purchaser".SETRANGE("Service Center", Code);
                            "Salesperson/Purchaser".SETRANGE(Retired, FALSE);
                            PerfBuffer."No. of Employee" := "Salesperson/Purchaser".COUNT;
                            PerfBuffer.MODIFY(TRUE);
                        END;
                    END;
                    TempDate := CALCDATE('<1M>', TempDate);
                END;
                //--BSS.IT_5981.SR

            end;

            trigger OnPreDataItem()
            begin
                //++BSS.IT_6010.SR
                CLEAR(PMFilter);
                PaymentMethod.RESET;
                PaymentMethod.SETRANGE(PaymentMethod."Cash Payment", TRUE);
                IF PaymentMethod.FINDSET THEN
                    REPEAT
                        IF PMFilter <> '' THEN
                            PMFilter := PMFilter + '|' + PaymentMethod.Code
                        ELSE
                            PMFilter := PaymentMethod.Code;
                    UNTIL PaymentMethod.NEXT = 0;
                //--BSS.IT_6010.SR
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(AsOnDate; AsOnDate)
                {
                    Caption = 'As on Date';
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

    trigger OnInitReport()
    begin
        IF CheckZoneAndDealerDimension() THEN
            CurrReport.QUIT;
        //--BSS.IT_6966.AP

        AsOnDate := TODAY;

        //++TWN.01.08-LL
        MUTFuncs.AddUsageTrackingEntry('MUT_6410');
    end;

    trigger OnPreReport()
    begin
        CalculateDate;
        //++BSS.IT_6010.SR
        REPORT.RUN(1017260, FALSE);
        //--BSS.IT_6010.SR
    end;

    var
        AsOnDate: Date;
        YTDStartDate: Date;
        YTDEndDate: Date;
        YTDMin1StartDate: Date;
        YTDMin1EndDate: Date;
        MTDStartDate: Date;
        MTDEndDate: Date;
        MTDMin1StartDate: Date;
        MTDMin1EndDate: Date;
        AccountingYear: Option "Calendar Year","Financial Year";
        CalenderYear: Boolean;
        FinancialYear: Boolean;
        Year: Integer;
        AccountingPeriod: Record "Accounting Period";
        FYDate: Integer;
        FYMonth: Integer;
        "Salesperson/Purchaser": Record "Salesperson/Purchaser";
        ItemAdditionalAttributes: Record "Item Additional Attributes";
        Item: Record Item;
        SalesHeader: Record "Sales Header";
        SalesInvoiceHeader: Record "Sales Invoice Header";
        ResponsibilityCenter: Record "Service Center";
        TireSetup: Record "Fastfit Setup - Reporting";
        PositionGroup: Record "Position Group";
        SalesInvoiceLine: Record "Sales Invoice Line";
        SalesInvoiceLine1: Record "Sales Invoice Line";
        InvoiceCount: Integer;
        DailyStatisticEntry: Record "Daily Statistic Entry";
        CompanyInfo: Record "Company Information";
        FormatAddr: Codeunit "Format Address";
        CompanyAddr: array[8] of Text[50];
        UserRec: Record User;
        Filters: Text[150];
        TempDate: Date;
        PerfBuffer: Record "TWN Performance Buffer";
        TempBalancing: Code[200];
        TempAligment: Code[200];
        Window: Dialog;
        LineCount: Integer;
        RetailFilter: Code[200];
        CustomerGroup: Record "Customer Group";
        FirstSBnumber: Code[20];
        LastSBnumber: Code[20];
        NoOfSB: Integer;
        PMFilter: Code[200];
        PaymentMethod: Record "Payment Method";
        Service: Record Resource;
        NoOfTireSoldwithSer: Decimal;
        NoOfTirereturnedwithSer: Decimal;
        SalesCrMemoHdr: Record "Sales Cr.Memo Header";
        SalesCrMemoLine: Record "Sales Cr.Memo Line";
        SalesCrMemoLine1: Record "Sales Cr.Memo Line";
        MUTFuncs: Codeunit "Usage Tracking";
        C_BSS_INF001: Label 'Updating Total Turnover              #2######\';
        C_BSS_INF002: Label 'Updating No. of Tyre Sold            #3######\';
        C_BSS_INF003: Label 'Updating No. of Tyre Sold (Retail)   #4######\';
        C_BSS_INF004: Label 'Updating No. of Quotation            #5######\';
        C_BSS_INF005: Label 'Updating No. of Invoice              #6######\';
        C_BSS_INF006: Label 'Updating No. of Cross Selling Invoice#7######\';
        C_BSS_INF007: Label 'Updating Total Services Revenue      #8######\';
        C_BSS_INF008: Label 'Updating No. of Misc.                #9######\';
        C_BSS_INF009: Label 'Updating No. of Shopping Basket      #10#####';
        C_BSS_ERR001: Label 'Following RC(s) have no Zone or Dealer Dimension:\\%1';

    [Scope('OnPrem')]
    procedure CalculateDate()
    begin
        Year := DATE2DMY(AsOnDate, 3);
        MTDStartDate := DMY2DATE(1, DATE2DMY(AsOnDate, 2), DATE2DMY(AsOnDate, 3));
        MTDEndDate := CALCDATE('<CM>', AsOnDate);

        MTDMin1StartDate := CALCDATE('<-1Y>', MTDStartDate);
        MTDMin1EndDate := CALCDATE('<-1Y>', MTDEndDate);

        YTDEndDate := CALCDATE('<CM>', AsOnDate);
        YTDMin1EndDate := CALCDATE('<-1Y>', YTDEndDate);

        IF AccountingYear = AccountingYear::"Calendar Year" THEN BEGIN
            YTDStartDate := DMY2DATE(1, 1, DATE2DMY(AsOnDate, 3));
            YTDMin1StartDate := CALCDATE('<-1Y>', YTDStartDate);
        END ELSE BEGIN
            AccountingPeriod.RESET;
            AccountingPeriod.SETRANGE("New Fiscal Year", TRUE);
            IF AccountingPeriod.FINDFIRST THEN BEGIN
                FYDate := DATE2DMY(AccountingPeriod."Starting Date", 1);
                FYMonth := DATE2DMY(AccountingPeriod."Starting Date", 2);
            END;

            IF DATE2DMY(AsOnDate, 2) >= FYMonth THEN
                YTDStartDate := DMY2DATE(FYDate, FYMonth, Year)
            ELSE
                YTDStartDate := DMY2DATE(FYDate, FYMonth, Year - 1);

            YTDMin1StartDate := CALCDATE('<-1Y>', YTDStartDate);
        END;
    end;

    [Scope('OnPrem')]
    procedure CalculateDate1()
    begin
        TempDate := YTDStartDate;
        WHILE (TempDate <= MTDStartDate) DO BEGIN

            //++BSS.IT_6966.AP
            //  IF PerfBuffer.GET("Responsibility Center1"."Global Dimension 2 Code",
            IF PerfBuffer.GET("Responsibility Center1"."Dealer Dimension Value",
                              //--BSS.IT_6966.AP
                              "Responsibility Center1".Code, DATE2DMY(TempDate, 2),
                              DATE2DMY(TempDate, 3), CALCDATE('<-CM>', TempDate)) THEN BEGIN
                PerfBuffer."No. of Tyres Sold" := 0;
                PerfBuffer."No. of Tyres Sold Retail" := 0;
                PerfBuffer."No. of Quotation" := 0;
                PerfBuffer."No. of Invoice" := 0;
                PerfBuffer."No. of Cross Selling Invoice" := 0;
                PerfBuffer."Total Turnover" := 0;
                //++BSS.IT_6010.SR
                PerfBuffer."Total Cash Sales" := 0;
                //--BSS.IT_6010.SR
                //++BSS.IT_6000.SR
                PerfBuffer."No. of Tyres Sold with rel ser" := 0;
                //--BSS.IT_6000.SR
                //++BSS.IT_6009.SR
                PerfBuffer."Turnover of invoices with ser" := 0;
                //--BSS.IT_6009.SR
                PerfBuffer."Total services Revenue" := 0;
                PerfBuffer."No. of Balancing" := 0;
                PerfBuffer."No. of Aligment" := 0;
                //++BSS.IT_6008.SR
                PerfBuffer."No. of SB" := 0;
                PerfBuffer."No. of SB converted" := 0;
                //--BSS.IT_6008.SR
                PerfBuffer.MODIFY(TRUE);
            END;

            //++BSS.IT_6966.AP
            //  IF PerfBuffer.GET("Responsibility Center1"."Global Dimension 2 Code",
            IF PerfBuffer.GET("Responsibility Center1"."Dealer Dimension Value",
                              //--BSS.IT_6966.AP
                              "Responsibility Center1".Code, DATE2DMY(CALCDATE('<-1Y>', TempDate), 2),
                               DATE2DMY(CALCDATE('<-1Y>', TempDate), 3), CALCDATE('<-1Y>', CALCDATE('<-CM>', TempDate))) THEN BEGIN
                PerfBuffer."No. of Tyres Sold" := 0;
                PerfBuffer."No. of Tyres Sold Retail" := 0;
                PerfBuffer."No. of Quotation" := 0;
                PerfBuffer."No. of Invoice" := 0;
                PerfBuffer."No. of Cross Selling Invoice" := 0;
                PerfBuffer."Total Turnover" := 0;
                //++BSS.IT_6010.SR
                PerfBuffer."Total Cash Sales" := 0;
                //--BSS.IT_6010.SR
                //++BSS.IT_6000.SR
                PerfBuffer."No. of Tyres Sold with rel ser" := 0;
                //--BSS.IT_6000.SR
                //++BSS.IT_6009.SR
                PerfBuffer."Turnover of invoices with ser" := 0;
                //--BSS.IT_6009.SR
                PerfBuffer."Total services Revenue" := 0;
                PerfBuffer."No. of Balancing" := 0;
                PerfBuffer."No. of Aligment" := 0;
                //++BSS.IT_6008.SR
                PerfBuffer."No. of SB" := 0;
                PerfBuffer."No. of SB converted" := 0;
                //--BSS.IT_6008.SR
                PerfBuffer.MODIFY(TRUE);
            END;
            TempDate := CALCDATE('<1M>', TempDate);
        END;
    end;

    [Scope('OnPrem')]
    procedure CheckZoneAndDealerDimension() HasBeenError: Boolean
    var
        RespCenterL: Record "Service Center";
        ErrorText: Text[1024];
    begin
        //++BSS.IT_6966.AP

        RespCenterL.FINDFIRST;
        REPEAT

            IF (RespCenterL."Zone Dimension" = '') OR
               (RespCenterL."Zone Dimension Value" = '') OR
               (RespCenterL."Dealer Dimension" = '') OR
               (RespCenterL."Dealer Dimension Value" = '') THEN BEGIN
                ErrorText += RespCenterL.Code + ' ';
                HasBeenError := TRUE;
            END;

        UNTIL RespCenterL.NEXT = 0;

        IF HasBeenError THEN
            ERROR(C_BSS_ERR001, ErrorText);

        EXIT(HasBeenError);
        //--BSS.IT_6966.AP
    end;

    local procedure GetStringNumber(StringToP: Text) NewStringR: Text
    var
        StringLenL: Integer;
        IL: Integer;
        NeedStopL: Boolean;
    begin
        NeedStopL := FALSE;
        NewStringR := '';
        StringLenL := STRLEN(StringToP);
        FOR IL := 1 TO StringLenL DO BEGIN
            IF (NOT NeedStopL) THEN BEGIN
                IF (COPYSTR(StringToP, StringLenL - IL + 1, 1) IN ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9']) THEN
                    NewStringR := COPYSTR(StringToP, StringLenL - IL + 1, 1) + NewStringR
                ELSE
                    NeedStopL := TRUE;
            END;
        END;
        EXIT(NewStringR);
    end;
}

