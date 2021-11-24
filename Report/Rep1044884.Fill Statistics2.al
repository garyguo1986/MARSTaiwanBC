report 1044884 "Fill Statistics2"
{
    //Copy the report from 1017260
    Caption = 'Fill Statistics';
    UsageCategory = ReportsAndAnalysis;
    Permissions = TableData "Sales Invoice Header" = rm,
                  TableData "Res. Ledger Entry" = rm,
                  TableData "Value Entry" = rm,
                  TableData "Pre. Res. Ledger Entry" = rm,
                  TableData "Daily Statistic Entry" = rimd,
                  TableData "Monthly Statistic Entry" = rimd;
    ProcessingOnly = true;

    dataset
    {
        dataitem(CheckSCValueEntry; "Value Entry")
        {
            DataItemTableView = SORTING("Daily Statistic Entry No.") ORDER(Ascending) WHERE("Service Center" = FILTER(''));

            trigger OnAfterGetRecord()
            var
                ServiceCenterL: Record "Service Center";
                ServiceCenterCodeL: Code[10];
                LocationL: Record Location;
                ValueEntryL: Record "Value Entry";
            begin
                //++BSS.IT_21595.CM

                if LocationL.Get("Location Code") then
                    if ServiceCenterL.Get(LocationL."Service Center") then
                        ServiceCenterCodeL := ServiceCenterL.Code;

                if ServiceCenterCodeL = '' then
                    ServiceCenterCodeL := GetServiceCenter("Document No.", "Item No.", "Global Dimension 1 Code", "Global Dimension 2 Code");

                if ServiceCenterCodeL <> '' then begin
                    ValueEntryL.Get("Entry No.");
                    ValueEntryL."Service Center" := ServiceCenterCodeL;
                    ValueEntryL.Modify;
                end;

                UpdateProgress(1);

                //--BSS.IT_21595.CM
            end;

            trigger OnPostDataItem()
            begin
                //++BSS.IT_21595.CM
                Commit;
                //--BSS.IT_21595.CM
            end;

            trigger OnPreDataItem()
            begin

                //++BSS.IT_21595.CM
                if not CheckServiceCenter then
                    CurrReport.Break;

                if GuiAllowed then
                    ProgressWindow.Open(C_BSS_INF010 + '\' +
                                      ' \' +
                                      C_BSS_INF003 + '\' +
                                      '@1@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\' +
                                      C_BSS_INF005 + '\' +
                                      '@2@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\' +
                                      C_BSS_INF004 + '\' +
                                      '@3@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\' +
                                      C_BSS_INF009 + '\' +
                                      '@4@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');

                Recs := Count;
                Progress := 1;
                //--BSS.IT_21595.CM
            end;
        }
        dataitem(CheckSCPreResLedgerEntry; "Pre. Res. Ledger Entry")
        {
            DataItemTableView = SORTING("Daily Statistic Entry No.") ORDER(Ascending) WHERE("Service Center" = FILTER(''));

            trigger OnAfterGetRecord()
            var
                ServiceCenterCodeL: Code[10];
                PreResLedgerEntryL: Record "Pre. Res. Ledger Entry";
            begin

                //++BSS.IT_21595.CM

                ServiceCenterCodeL := GetServiceCenter("Document No.", "Resource No.", '', '');

                if ServiceCenterCodeL <> '' then begin
                    PreResLedgerEntryL.Get("Entry No.");
                    PreResLedgerEntryL."Service Center" := ServiceCenterCodeL;
                    PreResLedgerEntryL.Modify;
                end;

                UpdateProgress(1);

                //--BSS.IT_21595.CM
            end;

            trigger OnPostDataItem()
            begin
                //++BSS.IT_21595.CM
                Commit;
                //--BSS.IT_21595.CM
            end;

            trigger OnPreDataItem()
            begin
                //++BSS.IT_21595.CM
                if not CheckServiceCenter then
                    CurrReport.Break;

                Recs := Count;
                Progress := 1;
                //--BSS.IT_21595.CM
            end;
        }
        dataitem(CheckSCResLedgerEntry; "Res. Ledger Entry")
        {
            DataItemTableView = SORTING("Daily Statistic Entry No.") ORDER(Ascending) WHERE("Service Center" = FILTER(''));

            trigger OnAfterGetRecord()
            var
                ServiceCenterCodeL: Code[10];
                ResLedgerEntryL: Record "Res. Ledger Entry";
            begin

                //++BSS.IT_21595.CM

                ServiceCenterCodeL := GetServiceCenter("Document No.", "Resource No.", "Global Dimension 1 Code", "Global Dimension 2 Code");

                if ServiceCenterCodeL <> '' then begin
                    ResLedgerEntryL.Get("Entry No.");
                    ResLedgerEntryL."Service Center" := ServiceCenterCodeL;
                    ResLedgerEntryL.Modify;
                end;

                UpdateProgress(1);

                //--BSS.IT_21595.CM
            end;

            trigger OnPostDataItem()
            begin
                //++BSS.IT_21595.CM
                Commit;
                //--BSS.IT_21595.CM
            end;

            trigger OnPreDataItem()
            begin
                //++BSS.IT_21595.CM
                if not CheckServiceCenter then
                    CurrReport.Break;

                Recs := Count;
                Progress := 1;
                //--BSS.IT_21595.CM
            end;
        }
        dataitem(CheckSCStatisticsGLEntry; "Statistics G/L Entry")
        {
            DataItemTableView = SORTING("Entry No.") WHERE("Service Center" = FILTER(''));

            trigger OnAfterGetRecord()
            var
                ServiceCenterCodeL: Code[10];
                StatisticsGLEntryL: Record "Statistics G/L Entry";
            begin

                //++BSS.IT_21595.CM

                ServiceCenterCodeL := GetServiceCenter("Document No.", '', "Global Dimension 1 Code", "Global Dimension 2 Code");

                if ServiceCenterCodeL <> '' then begin
                    StatisticsGLEntryL.Get("Entry No.");
                    StatisticsGLEntryL."Service Center" := ServiceCenterCodeL;
                    StatisticsGLEntryL.Modify;
                end;

                UpdateProgress(1);

                //--BSS.IT_21595.CM
            end;

            trigger OnPostDataItem()
            begin
                //++BSS.IT_21595.CM
                Commit;
                if CheckServiceCenter then
                    if GuiAllowed then
                        ProgressWindow.Close;
                //--BSS.IT_21595.CM
            end;

            trigger OnPreDataItem()
            var
                ReportingSetupL: Record "Fastfit Setup - Statistic";
            begin
                //++BSS.IT_21595.CM
                if not CheckServiceCenter then
                    CurrReport.Break;

                Recs := Count;
                Progress := 1;
                //--BSS.IT_21595.CM
            end;
        }
        dataitem("Value Entry"; "Value Entry")
        {
            DataItemTableView = SORTING("Daily Statistic Entry No.") ORDER(Ascending) WHERE("Daily Statistic Entry No." = CONST(0));

            trigger OnAfterGetRecord()
            begin
                if "Item Ledger Entry Type" <> "Item Ledger Entry Type"::Sale then begin
                    ValueEntry1.Get("Entry No.");
                    ValueEntry1."Daily Statistic Entry No." := -1;
                    ValueEntry1."Daily Statistic Transfer Date" := Today;
                    ValueEntry1.Modify;
                end
                else begin
                    Clear(Number);
                    PaymentMethodCode := FindPaymentMethodCode1("Document No.", "Posting Date");
                    if Item.Get("Item No.") then begin
                        DailyStatistic.Reset;
                        //++BSS.IT_3730.WL
                        //DailyStatistic.SETCURRENTKEY("Resp. Center Code","Source Type","Position Group",
                        //  "Manufacturer Code","Payment Type Code","Item Category","Product Group","Posting Date");
                        DailyStatistic.SetCurrentKey("Service Center Code", "Source Type", "Position Group",
              //++BSS.34782.SU
              //"Manufacturer Code", "Payment Type Code", "Item Category", "Product Group", "Posting Date",                          
              "Manufacturer Code", "Payment Type Code", "Item Category", "Posting Date",
                          //--BSS.34782.SU
                          "Customer Group", "Sell-To Customerno.", "Bill-To Customerno.", Salesperson, Salesrep);
                        //--BSS.IT_3730.WL
                        DailyStatistic.SetRange("Service Center Code", "Service Center");
                        DailyStatistic.SetRange("Source Type", Statistic."Source Type"::"Value Entry");
                        //++BSS.IT_21184.PW
                        DailyStatistic.SetRange("Payment Type Code", PaymentMethodCode);

                        if ("Variant Code" <> '') and ItemVariant.Get(Item."No.", "Variant Code") then begin
                            if ItemVariant."Position Group Code" <> '' then
                                DailyStatistic.SetRange("Position Group", ItemVariant."Position Group Code")
                            else
                                DailyStatistic.SetRange("Position Group", Item."Position Group Code");

                            if ItemVariant."Manufacturer Code" <> '' then
                                DailyStatistic.SetRange("Manufacturer Code", ItemVariant."Manufacturer Code")
                            else
                                DailyStatistic.SetRange("Manufacturer Code", Item."Manufacturer Code");

                            if ItemVariant."Item Category" <> '' then
                                DailyStatistic.SetRange("Item Category", ItemVariant."Item Category")
                            else
                                DailyStatistic.SetRange("Item Category", Item."Item Category Code");
                        end else begin
                            DailyStatistic.SetRange("Position Group", Item."Position Group Code");
                            DailyStatistic.SetRange("Manufacturer Code", Item."Manufacturer Code");
                            DailyStatistic.SetRange("Item Category", Item."Item Category Code");
                        end;

                        //DailyStatistic.SETRANGE("Position Group",Item."Position Group Code");
                        //DailyStatistic.SETRANGE("Manufacturer Code",Item."Manufacturer Code");
                        //DailyStatistic.SETRANGE("Payment Type Code",PaymentMethodCode);
                        //DailyStatistic.SETRANGE("Item Category",Item."Item Category Code");
                        //--BSS.IT_21184.PW

                        //++BSS.IT_3730.WL
                        TireSetupStatistic.FindFirst;
                        if TireSetupStatistic."Fill Daily Stat. Cust. Fields" then begin
                            if "Source Type" = "Source Type"::Customer then begin
                                if Customer.Get("Source No.") then begin
                                    DailyStatistic.SetRange("Customer Group", Customer."Customer Group");
                                    DailyStatistic.SetRange("Sell-To Customerno.", "Source No.");
                                end;
                            end;
                            if ItemLedgerEntry.Get("Item Ledger Entry No.") then begin
                                DailyStatistic.SetRange("Bill-To Customerno.", ItemLedgerEntry."Bill-to Customer No.");
                                DailyStatistic.SetRange(Salesperson, "Salespers./Purch. Code");
                                DailyStatistic.SetRange(Salesrep, ItemLedgerEntry."Representative Code");
                            end
                            else begin
                                Statistic.SetRange(Salesperson, "Salespers./Purch. Code");
                            end;
                        end;
                        //--BSS.IT_3730.WL
                        DailyStatistic.SetRange("Posting Date", "Posting Date");
                        //++BSS.IT_4230.MH
                        DailyStatistic.SetRange("Additional Data 1", AdditionalDataFunctions.GetFilterValueByValueEntry(1, "Value Entry"));
                        DailyStatistic.SetRange("Additional Data 2", AdditionalDataFunctions.GetFilterValueByValueEntry(2, "Value Entry"));
                        DailyStatistic.SetRange("Additional Data 3", AdditionalDataFunctions.GetFilterValueByValueEntry(3, "Value Entry"));
                        DailyStatistic.SetRange("Additional Data 4", AdditionalDataFunctions.GetFilterValueByValueEntry(4, "Value Entry"));
                        //--BSS.IT_4230.MH
                        //++BSS.IT_6556.SP
                        if TireSetupStatistic."Evaluate Item/Res./Acc. No." then begin
                            DailyStatistic.SetRange(Code, Item."No.");
                        end;
                        //--BSS.IT_6556.SP
                        if DailyStatistic.Find('-') then begin
                            Number := DailyStatistic."Entry No.";
                            NewRecord := false;
                        end
                        else begin
                            Number := FindNextDailyNumber;
                            DailyStatistic.Init;
                            DailyStatistic."Entry No." := Number;
                            DailyStatistic."Service Center Code" := "Service Center";
                            DailyStatistic."Source Type" := Statistic."Source Type"::"Value Entry";
                            //++BSS.IT_6061.SS
                            if ("Variant Code" <> '') and ItemVariant.Get(Item."No.", "Variant Code") then begin
                                //++BSS.IT_21184.PW
                                if ItemVariant."Manufacturer Code" = '' then
                                    DailyStatistic."Manufacturer Code" := Item."Manufacturer Code"
                                else
                                    //--BSS.IT_21184.PW
                                    DailyStatistic."Manufacturer Code" := ItemVariant."Manufacturer Code";

                                //++BSS.IT_21184.PW
                                if ItemVariant."Position Group Code" = '' then begin
                                    DailyStatistic."Main Group" := Item."Main Group Code";
                                    DailyStatistic."Sub Group" := Item."Sub Group Code";
                                    DailyStatistic."Position Group" := Item."Position Group Code";
                                end else begin
                                    //--BSS.IT_21184.PW
                                    DailyStatistic."Position Group" := ItemVariant."Position Group Code";
                                    DailyStatistic."Main Group" := ItemVariant."Main Group Code";
                                    DailyStatistic."Sub Group" := ItemVariant."Sub Group Code";
                                    //++BSS.IT_21184.PW
                                end;
                                //--BSS.IT_21184.PW

                                //++BSS.IT_21184.PW
                                if ItemVariant."Item Category" = '' then
                                    DailyStatistic."Item Category" := Item."Item Category Code"
                                else
                                    //--BSS.IT_21184.PW
                                    DailyStatistic."Item Category" := ItemVariant."Item Category";

                                //++BSS.IT_21184.PW
                            end else begin
                                //--BSS.IT_6061.SS
                                DailyStatistic."Position Group" := Item."Position Group Code";
                                //++BSS.IT_4230.MH
                                DailyStatistic."Manufacturer Code" := Item."Manufacturer Code";
                                DailyStatistic."Main Group" := Item."Main Group Code";
                                DailyStatistic."Sub Group" := Item."Sub Group Code";

                                DailyStatistic."Item Category" := Item."Item Category Code";
                                //++BSS.IT_6061.SS
                            end;
                            //--BSS.IT_6061.SS

                            DailyStatistic."Payment Type Code" := PaymentMethodCode;
                            AdditionalDataFunctions.CreateDailyDataByValueEntry("Value Entry", DailyStatistic);
                            //--BSS.IT_4230.MH
                            DailyStatistic."Posting Date" := "Posting Date";
                            //++BSS.IT_6556.SP
                            if TireSetupStatistic."Evaluate Item/Res./Acc. No." then begin
                                DailyStatistic.Code := Item."No.";
                            end;
                            //--BSS.IT_6556.SP

                            //++BSS.IT_20876.SG
                            UpdateZoneAndDealerDaily(DailyStatistic."Service Center Code", DailyStatistic);
                            //--BSS.IT_20876.SG

                            //++BSS.IT_3730.WL
                            if TireSetupStatistic."Fill Daily Stat. Cust. Fields" then begin

                                //++BSS.IT_8796.SS
                                /*
                                        IF "Source Type" = "Source Type"::Customer THEN BEGIN
                                          IF Customer.GET("Source No.") THEN BEGIN
                                            DailyStatistic."Customer Group" := Customer."Customer Group";
                                            DailyStatistic."Sell-To Customerno." := "Source No.";
                                          END;
                                        END;
                                */
                                //--BSS.IT_8796.SS
                                if ItemLedgerEntry.Get("Item Ledger Entry No.") then begin
                                    //++BSS.IT_8796.SS
                                    DailyStatistic."Sell-To Customerno." := ItemLedgerEntry."Source No.";
                                    if Customer.Get(ItemLedgerEntry."Source No.") then
                                        DailyStatistic."Customer Group" := Customer."Customer Group";
                                    //--BSS.IT_8796.SS
                                    DailyStatistic."Bill-To Customerno." := ItemLedgerEntry."Bill-to Customer No.";
                                    DailyStatistic.Salesrep := ItemLedgerEntry."Representative Code";
                                end;
                                DailyStatistic.Salesperson := "Salespers./Purch. Code";
                            end;
                            //--BSS.IT_3730.WL
                            //++BSS.TFS_11330.GS
                            if ItemLedgerEntry.Get("Item Ledger Entry No.") then begin
                                if Customer.Get(ItemLedgerEntry."Source No.") then begin
                                    DailyStatistic."Sell-to City" := Customer.City;
                                    DailyStatistic."Sell-to Post Code" := Customer."Post Code";
                                end;
                                if Customer.Get(ItemLedgerEntry."Bill-to Customer No.") then begin
                                    DailyStatistic."Bill-to City" := Customer.City;
                                    DailyStatistic."Bill-to Post Code" := Customer."Post Code";
                                end;
                            end;
                            DailyStatistic."Local Currency Code" := GLSetup."LCY Code";
                            //--BSS.TFS_11330.GS
                            NewRecord := true;
                        end;

                        //++BSS.IT_1683.SK
                        if not Consignment then
                            //--BSS.IT_1683.SK
                            DailyStatistic."Sales Quantity (Expected)" += ("Invoiced Quantity" - "Item Ledger Entry Quantity");

                        DailyStatistic."Sales Quantity Invoiced" -= "Invoiced Quantity";

                        //++BSS.IT_1683.SK
                        if not Consignment then
                            //--BSS.IT_1683.SK
                            DailyStatistic."Sales Amount (Expected)" += "Sales Amount (Expected)";

                        DailyStatistic."Sales Amount" += "Sales Amount (Actual)";

                        //++BSS.IT_1683.SK
                        if not Consignment then
                            //--BSS.IT_1683.SK
                            DailyStatistic."Cost Amount (Expected)" -= "Cost Amount (Expected)";

                        DailyStatistic."Cost Amount" -= "Cost Amount (Actual)";

                        //++BSS.IT_301_1.GT

                        //++BSS.IT_1683.SK
                        if not Consignment then
                            //--BSS.IT_1683.SK
                            DailyStatistic."Sales Bonus Amount (Expected)" -= "Bonus Amount (Expected)";

                        DailyStatistic."SalesValue (CB)" -= ("CB-Price" * "Invoiced Quantity");

                        //++BSS.IT_1683.SK
                        if not Consignment then
                            //--BSS.IT_1683.SK
                            DailyStatistic."SalesValue (CB) (Expected)" += (("Invoiced Quantity" - "Item Ledger Entry Quantity") * "CB-Price");

                        //++BSS.TFS_11330.GS
                        DailyStatistic."Discount Amount" -= "Discount Amount";
                        //--BSS.TFS_11330.GS

                        //--BSS.IT_301_1.GT

                        DailyStatistic."Printed On" := 0D;
                        if NewRecord then
                            DailyStatistic.Insert
                        else
                            DailyStatistic.Modify;

                        ValueEntry1.Get("Entry No.");
                        ValueEntry1."Daily Statistic Entry No." := Number;
                        ValueEntry1."Daily Statistic Transfer Date" := Today;
                        ValueEntry1.Modify;
                    end;
                end;

                //++BSS.IT_301.SK
                UpdateProgress(1);
                //--BSS.IT_301.SK

            end;

            trigger OnPostDataItem()
            begin
                //++BSS.IT_2848.AP
                Commit;
                //--BSS.IT_2848.AP
            end;

            trigger OnPreDataItem()
            begin

                //++BSS.IT_2768.AP
                if "Historic Data" then
                    CurrReport.Break;
                //--BSS.IT_2768.AP

                //++BSS.IT_301.SK
                //++BSS.IT_4995.MH
                if GuiAllowed then
                    //--BSS.IT_4995.MH
                    ProgressWindow.Open(C_BSS_INF001 + '\' +
                                    ' \' +
                                    C_BSS_INF003 + '\' +
                                    '@1@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\' +
                                    C_BSS_INF005 + '\' +
                                    '@2@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\' +
                                    C_BSS_INF004 + '\' +
                                    '@3@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\' +
                                    //++BSS.IT_3776.MH
                                    C_BSS_INF009 + '\' +
                                    '@4@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');
                //--BSS.IT_3776.MH

                if not DailyCreate then
                    CurrReport.Break;

                Recs := "Value Entry".Count;
                Progress := 1;
                //--BSS.IT_301.SK
            end;
        }
        dataitem("Pre. Res. Ledger Entry"; "Pre. Res. Ledger Entry")
        {
            DataItemTableView = SORTING("Daily Statistic Entry No.") ORDER(Ascending) WHERE("Daily Statistic Entry No." = CONST(0));

            trigger OnAfterGetRecord()
            begin
                if not DailyCreate then
                    CurrReport.Break;

                Clear(Number);
                PaymentMethodCode := FindPaymentMethodCode("Document No.", "Posting Date");
                //++BSS.IT_21389.AK
                //IF Resource.GET("Resource No.") THEN BEGIN
                //--BSS.IT_21389.AK
                DailyStatistic.Reset;
                //++BSS.IT_3730.WL
                //DailyStatistic.SETCURRENTKEY("Resp. Center Code","Source Type","Position Group",
                //  "Manufacturer Code","Payment Type Code","Item Category","Product Group","Posting Date");
                DailyStatistic.SetCurrentKey("Service Center Code", "Source Type", "Position Group",
                  //++BSS.34782.SU
                  //  "Manufacturer Code", "Payment Type Code", "Item Category", "Product Group", "Posting Date",
                  "Manufacturer Code", "Payment Type Code", "Item Category", "Posting Date",
                  //--BSS.34782.SU
                  "Customer Group", "Sell-To Customerno.", "Bill-To Customerno.", Salesperson, Salesrep);
                //--BSS.IT_3730.WL
                DailyStatistic.SetRange("Service Center Code", "Service Center");
                DailyStatistic.SetRange("Source Type", Statistic."Source Type"::"Pre. Res. Entry");
                //++BSS.IT_21389.AK
                //DailyStatistic.SETRANGE("Position Group",Resource."Position Group Code");
                //DailyStatistic.SETRANGE("Manufacturer Code",Resource."Manufacturer Code");
                DailyStatistic.SetRange("Position Group", "Position Group Code");
                DailyStatistic.SetRange("Manufacturer Code", "Manufacturer Code");
                //--BSS.IT_21389.AK
                DailyStatistic.SetRange("Payment Type Code", PaymentMethodCode);
                //++BSS.IT_21389.AK
                // DailyStatistic.SETRANGE("Item Category",Resource."Item Category Code");
                // DailyStatistic.SETRANGE("Product Group",Resource."Product Group Code");
                DailyStatistic.SetRange("Item Category", "Item Category Code");
                //++BSS.34782.SU
                //DailyStatistic.SetRange("Product Group", "Product Group Code");
                //--BSS.34782.SU
                //--BSS.IT_21389.AK
                //++BSS.IT_3730.WL
                TireSetupStatistic.FindFirst;
                if TireSetupStatistic."Fill Daily Stat. Cust. Fields" then begin
                    if Customer.Get("Sell-to Customer No.") then begin
                        DailyStatistic.SetRange("Customer Group", Customer."Customer Group");
                        DailyStatistic.SetRange("Sell-To Customerno.", "Sell-to Customer No.");
                    end;
                    DailyStatistic.SetRange("Bill-To Customerno.", "Bill-to Customer No.");
                    DailyStatistic.SetRange(Salesperson, "Salespers./Purch. Code");
                    DailyStatistic.SetRange(Salesrep, "Representative Code");
                end;
                //--BSS.IT_3730.WL
                //++BSS.IT_4230.MH
                DailyStatistic.SetRange("Additional Data 1",
                  AdditionalDataFunctions.GetFilterValueByPreResLedgerE(1, "Pre. Res. Ledger Entry"));
                DailyStatistic.SetRange("Additional Data 2",
                  AdditionalDataFunctions.GetFilterValueByPreResLedgerE(2, "Pre. Res. Ledger Entry"));
                DailyStatistic.SetRange("Additional Data 3",
                  AdditionalDataFunctions.GetFilterValueByPreResLedgerE(3, "Pre. Res. Ledger Entry"));
                DailyStatistic.SetRange("Additional Data 4",
                  AdditionalDataFunctions.GetFilterValueByPreResLedgerE(4, "Pre. Res. Ledger Entry"));
                //--BSS.IT_4230.MH
                //++BSS.IT_6556.SP
                if TireSetupStatistic."Evaluate Item/Res./Acc. No." then begin
                    //++BSS.IT_21389.AK
                    //    DailyStatistic.SETRANGE(Code, Resource."No.");
                    DailyStatistic.SetRange(Code, "Resource No.");
                    //--BSS.IT_21389.AK
                end;
                //--BSS.IT_6556.SP
                DailyStatistic.SetRange("Posting Date", "Posting Date");
                if DailyStatistic.Find('-') then begin
                    Number := DailyStatistic."Entry No.";
                    NewRecord := false;
                end
                else begin
                    Number := FindNextDailyNumber;
                    DailyStatistic.Init;
                    DailyStatistic."Entry No." := Number;
                    DailyStatistic."Service Center Code" := "Service Center";
                    DailyStatistic."Source Type" := Statistic."Source Type"::"Pre. Res. Entry";
                    //++BSS.IT_21389.AK
                    //  DailyStatistic."Position Group"    := Resource."Position Group Code";
                    DailyStatistic."Position Group" := "Position Group Code";
                    //--BSS.IT_21389.AK
                    //++BSS.IT_4230.MH
                    //++BSS.IT_21389.AK
                    //  DailyStatistic."Main Group" := Resource."Main Group Code";
                    //  DailyStatistic."Sub Group"    := Resource."Sub Group Code";
                    DailyStatistic."Main Group" := "Main Group Code";
                    DailyStatistic."Sub Group" := "Sub Group Code";
                    //--BSS.IT_21389.AK
                    AdditionalDataFunctions.CreateDailyDataByPreResLedgE("Pre. Res. Ledger Entry", DailyStatistic);
                    //--BSS.IT_4230.MH
                    //++BSS.IT_21389.AK
                    //  DailyStatistic."Manufacturer Code" := Resource."Manufacturer Code";
                    DailyStatistic."Manufacturer Code" := "Manufacturer Code";
                    //--BSS.IT_21389.AK
                    DailyStatistic."Payment Type Code" := PaymentMethodCode;
                    //++BSS.IT_21389.AK
                    //  DailyStatistic."Item Category" := Resource."Item Category Code";
                    //  DailyStatistic."Product Group" := Resource."Product Group Code";
                    DailyStatistic."Item Category" := "Item Category Code";
                    //++BSS.34782.SU
                    //DailyStatistic."Product Group" := "Product Group Code";
                    //--BSS.34782.SU
                    //--BSS.IT_21389.AK
                    //++BSS.IT_3730.WL
                    //++BSS.IT_6556.SP
                    if TireSetupStatistic."Evaluate Item/Res./Acc. No." then begin
                        //++BSS.IT_21389.AK
                        //    DailyStatistic.Code := Resource."No.";
                        DailyStatistic.Code := "Resource No.";
                        //++BSS.IT_21389.AK
                    end;
                    //--BSS.IT_6556.SP
                    if TireSetupStatistic."Fill Daily Stat. Cust. Fields" then begin
                        if Customer.Get("Sell-to Customer No.") then begin
                            DailyStatistic."Customer Group" := Customer."Customer Group";
                            DailyStatistic."Sell-To Customerno." := "Sell-to Customer No.";
                        end;
                        DailyStatistic."Bill-To Customerno." := "Bill-to Customer No.";
                        DailyStatistic.Salesperson := "Salespers./Purch. Code";
                        DailyStatistic.Salesrep := "Representative Code";
                    end;
                    //--BSS.IT_3730.WL
                    //++BSS.TFS_11330.GS
                    if Customer.Get("Sell-to Customer No.") then begin
                        DailyStatistic."Sell-to City" := Customer.City;
                        DailyStatistic."Sell-to Post Code" := Customer."Post Code";
                    end;
                    if Customer.Get("Bill-to Customer No.") then begin
                        DailyStatistic."Bill-to City" := Customer.City;
                        DailyStatistic."Bill-to Post Code" := Customer."Post Code";
                    end;
                    DailyStatistic."Local Currency Code" := GLSetup."LCY Code";
                    //--BSS.TFS_11330.GS
                    DailyStatistic."Posting Date" := "Posting Date";
                    NewRecord := true;
                end;
                DailyStatistic."Sales Quantity (Expected)" += "Sales Quantity (Expected)";
                //  DailyStatistic."Sales Quantity Invoiced" += ;
                DailyStatistic."Sales Amount (Expected)" += "Sales Amount (Expected) (LCY)";
                //  DailyStatistic."Sales Amount" :=;
                DailyStatistic."Cost Amount (Expected)" += "Cost Amount (Expected) (LCY)";
                //  DailyStatistic."Cost Amount" += ;
                DailyStatistic."Printed On" := 0D;

                //++BSS.IT_301_1.GT
                //    DailyStatistic."Sales Bonus Amount (Expected)" -= "Bonus Amount (Expected)";
                //    DailyStatistic."SalesValue (CB)" -= ("CB-Price" *  "Invoiced Quantity");
                DailyStatistic."SalesValue (CB) (Expected)" += ("Sales Quantity (Expected)" * "CB-Price");
                //--BSS.IT_301_1.GT

                //++BSS.IT_20876.SG
                UpdateZoneAndDealerDaily(DailyStatistic."Service Center Code", DailyStatistic);
                //--BSS.IT_20876.SG

                if NewRecord then
                    DailyStatistic.Insert
                else
                    DailyStatistic.Modify;

                PreResLedgerEntry1.Get("Entry No.");
                PreResLedgerEntry1."Daily Statistic Entry No." := Number;
                PreResLedgerEntry1."Daily Statistic Transfer Date" := Today;
                PreResLedgerEntry1.Modify;
                //++BSS.IT_21389.AK
                //END;
                //--BSS.IT_21389.AK

                //++BSS.IT_301.SK
                UpdateProgress(2);
                //--BSS.IT_301.SK
            end;

            trigger OnPostDataItem()
            begin
                //++BSS.IT_2848.AP
                Commit;
                //--BSS.IT_2848.AP
            end;

            trigger OnPreDataItem()
            begin
                //++BSS.IT_2768.AP
                if "Historic Data" then
                    CurrReport.Break;
                //--BSS.IT_2768.AP

                //++BSS.IT_301.SK
                Recs := "Pre. Res. Ledger Entry".Count;
                Progress := 1;
                //--BSS.IT_301.SK
            end;
        }
        dataitem("Res. Ledger Entry"; "Res. Ledger Entry")
        {
            DataItemTableView = SORTING("Daily Statistic Entry No.") ORDER(Ascending) WHERE("Daily Statistic Entry No." = CONST(0));

            trigger OnAfterGetRecord()
            begin
                if not DailyCreate then
                    CurrReport.Break;

                if "Entry Type" <> "Entry Type"::Sale then begin
                    ResLedgerEntry1.Get("Entry No.");
                    ResLedgerEntry1."Daily Statistic Entry No." := -1;
                    ResLedgerEntry1."Daily Statistic Transfer Date" := Today;
                    ResLedgerEntry1.Modify;
                end
                else begin
                    Clear(Number);
                    PaymentMethodCode := FindPaymentMethodCode1("Document No.", "Posting Date");
                    //++BSS.IT_21389.AK
                    //  IF Resource.GET("Resource No.") THEN BEGIN
                    //--BSS.IT_21389.AK
                    DailyStatistic.Reset;
                    //++BSS.IT_3730.WL
                    //DailyStatistic.SETCURRENTKEY("Resp. Center Code","Source Type","Position Group",
                    //  "Manufacturer Code","Payment Type Code","Item Category","Product Group","Posting Date");
                    DailyStatistic.SetCurrentKey("Service Center Code", "Source Type", "Position Group",
                      //++BSS.34782.SU
                      //  "Manufacturer Code", "Payment Type Code", "Item Category", "Product Group", "Posting Date",
                      "Manufacturer Code", "Payment Type Code", "Item Category", "Posting Date",
                      //--BSS.34782.SU
                      "Customer Group", "Sell-To Customerno.", "Bill-To Customerno.", Salesperson, Salesrep);
                    //--BSS.IT_3730.WL
                    DailyStatistic.SetRange("Service Center Code", "Service Center");
                    DailyStatistic.SetRange("Source Type", Statistic."Source Type"::"Res. Ledger Entry");
                    //++BSS.IT_21389.AK
                    //    DailyStatistic.SETRANGE("Position Group",Resource."Position Group Code");
                    //    DailyStatistic.SETRANGE("Manufacturer Code",Resource."Manufacturer Code");
                    DailyStatistic.SetRange("Position Group", "Position Group Code");
                    DailyStatistic.SetRange("Manufacturer Code", "Manufacturer Code");
                    //--BSS.IT_21389.AK

                    DailyStatistic.SetRange("Payment Type Code", PaymentMethodCode);
                    //++BSS.IT_21389.AK
                    //    DailyStatistic.SETRANGE("Item Category",Resource."Item Category Code");
                    //    DailyStatistic.SETRANGE("Product Group",Resource."Product Group Code");
                    DailyStatistic.SetRange("Item Category", "Item Category Code");
                    //++BSS.34782.SU
                    //DailyStatistic.SetRange("Product Group", "Product Group Code");
                    //--BSS.34782.SU
                    //--BSS.IT_21389.AK
                    //++BSS.IT_3730.WL
                    TireSetupStatistic.FindFirst;
                    if TireSetupStatistic."Fill Daily Stat. Cust. Fields" then begin
                        if "Source Type" = "Source Type"::Customer then begin
                            if Customer.Get("Source No.") then begin
                                DailyStatistic.SetRange("Customer Group", Customer."Customer Group");
                                DailyStatistic.SetRange("Sell-To Customerno.", "Source No.");
                            end;
                        end;
                        DailyStatistic.SetRange("Bill-To Customerno.", "Bill-to Customer No.");
                        DailyStatistic.SetRange(Salesperson, "Salespers./Purch. Code");
                        DailyStatistic.SetRange(Salesrep, "Representative Code");
                    end;
                    //--BSS.IT_3730.WL
                    //++BSS.IT_4230.MH
                    DailyStatistic.SetRange("Additional Data 1",
                      AdditionalDataFunctions.GetFilterValueByResLedgerE(1, "Res. Ledger Entry"));
                    DailyStatistic.SetRange("Additional Data 2",
                      AdditionalDataFunctions.GetFilterValueByResLedgerE(2, "Res. Ledger Entry"));
                    DailyStatistic.SetRange("Additional Data 3",
                      AdditionalDataFunctions.GetFilterValueByResLedgerE(3, "Res. Ledger Entry"));
                    DailyStatistic.SetRange("Additional Data 4",
                      AdditionalDataFunctions.GetFilterValueByResLedgerE(4, "Res. Ledger Entry"));
                    //--BSS.IT_4230.MH
                    //++BSS.IT_6556.SP
                    if TireSetupStatistic."Evaluate Item/Res./Acc. No." then begin
                        //++BSS.IT_21389.AK
                        //      DailyStatistic.SETRANGE(Code, Resource."No.");
                        DailyStatistic.SetRange(Code, "Resource No.");
                        //--BSS.IT_21389.AK
                    end;
                    //--BSS.IT_6556.SP
                    //++BSS.TFS_11330.GS
                    DailyStatistic.SetRange("Unit of Measure Code", "Unit of Measure Code");
                    //--BSS.TFS_11330.GS
                    DailyStatistic.SetRange("Posting Date", "Posting Date");
                    if DailyStatistic.Find('-') then begin
                        Number := DailyStatistic."Entry No.";
                        NewRecord := false;
                    end
                    else begin
                        Number := FindNextDailyNumber;
                        DailyStatistic.Init;
                        DailyStatistic."Entry No." := Number;
                        DailyStatistic."Service Center Code" := "Service Center";
                        DailyStatistic."Source Type" := Statistic."Source Type"::"Res. Ledger Entry";
                        //++BSS.IT_21389.AK
                        //      DailyStatistic."Position Group"    := Resource."Position Group Code";
                        DailyStatistic."Position Group" := "Position Group Code";
                        //--BSS.IT_21389.AK
                        //++BSS.IT_4230.MH
                        //++BSS.IT_21389.AK
                        //     DailyStatistic."Main Group" := Resource."Main Group Code";
                        //     DailyStatistic."Sub Group"    := Resource."Sub Group Code";
                        DailyStatistic."Main Group" := "Main Group Code";
                        DailyStatistic."Sub Group" := "Sub Group Code";
                        //--BSS.IT_21389.AK
                        AdditionalDataFunctions.CreateDailyDataByResLedgE("Res. Ledger Entry", DailyStatistic);
                        //--BSS.IT_4230.MH
                        //++BSS.IT_21389.AK
                        //      DailyStatistic."Manufacturer Code" := Resource."Manufacturer Code";
                        DailyStatistic."Manufacturer Code" := "Manufacturer Code";
                        //--BSS.IT_21389.AK
                        DailyStatistic."Payment Type Code" := PaymentMethodCode;
                        //++BSS.IT_21389.AK
                        //      DailyStatistic."Item Category" := Resource."Item Category Code";
                        //      DailyStatistic."Product Group" := Resource."Product Group Code";
                        DailyStatistic."Item Category" := "Item Category Code";
                        //++BSS.34782.SU
                        //DailyStatistic."Product Group" := "Product Group Code";
                        //--BSS.34782.SU
                        //--BSS.IT_21389.AK
                        DailyStatistic."Posting Date" := "Posting Date";
                        //++BSS.IT_3730.WL
                        //++BSS.IT_6556.SP
                        if TireSetupStatistic."Evaluate Item/Res./Acc. No." then begin
                            //++BSS.IT_21389.AK
                            //        DailyStatistic.Code := Resource."No.";
                            DailyStatistic.Code := "Resource No.";
                            //--BSS.IT_21389.AK
                        end;
                        //--BSS.IT_6556.SP
                        if TireSetupStatistic."Fill Daily Stat. Cust. Fields" then begin
                            if "Source Type" = "Source Type"::Customer then begin
                                if Customer.Get("Source No.") then begin
                                    DailyStatistic."Customer Group" := Customer."Customer Group";
                                    DailyStatistic."Sell-To Customerno." := "Source No.";
                                end;
                            end;
                            DailyStatistic."Bill-To Customerno." := "Bill-to Customer No.";
                            DailyStatistic.Salesrep := "Representative Code";
                            DailyStatistic.Salesperson := "Salespers./Purch. Code";
                        end;
                        //--BSS.IT_3730.WL
                        //++BSS.TFS_11330.GS
                        if "Source Type" = "Source Type"::Customer then
                            if Customer.Get("Source No.") then begin
                                DailyStatistic."Sell-to City" := Customer.City;
                                DailyStatistic."Sell-to Post Code" := Customer."Post Code";
                            end;
                        if Customer.Get("Bill-to Customer No.") then begin
                            DailyStatistic."Bill-to City" := Customer.City;
                            DailyStatistic."Bill-to Post Code" := Customer."Post Code";
                        end;
                        DailyStatistic."Local Currency Code" := GLSetup."LCY Code";
                        DailyStatistic."Unit of Measure Code" := "Unit of Measure Code";
                        //--BSS.TFS_11330.GS
                        NewRecord := true;
                    end;
                    DailyStatistic."Sales Quantity Invoiced" -= "Quantity (Base)";
                    DailyStatistic."Sales Amount" -= "Total Price";
                    DailyStatistic."Cost Amount" -= "Total Cost";


                    //++BSS.IT_301_1.GT
                    //  DailyStatistic."Sales Bonus Amount (Expected)"
                    DailyStatistic."SalesValue (CB)" -= ("CB-Price" * "Quantity (Base)");
                    //  DailyStatistic."SalesValue (CB) (Expected)" +=;
                    //--BSS.IT_301_1.GT

                    //++BSS.IT_20876.SG
                    UpdateZoneAndDealerDaily(DailyStatistic."Service Center Code", DailyStatistic);
                    //--BSS.IT_20876.SG

                    //++BSS.TFS_11330.GS
                    DailyStatistic."Discount Amount" -= (Quantity * "Unit Price" - "Total Price");
                    //--BSS.TFS_11330.GS

                    DailyStatistic."Printed On" := 0D;
                    if NewRecord then
                        DailyStatistic.Insert
                    else
                        DailyStatistic.Modify;

                    ResLedgerEntry1.Get("Entry No.");
                    ResLedgerEntry1."Daily Statistic Entry No." := Number;
                    ResLedgerEntry1."Daily Statistic Transfer Date" := Today;
                    ResLedgerEntry1.Modify;
                end;
                //++BSS.IT_21389.AK
                //END;
                //--BSS.IT_21389.AK

                //++BSS.IT_301.SK
                UpdateProgress(3);
                //--BSS.IT_301.SK
            end;

            trigger OnPostDataItem()
            begin
                //++BSS.IT_2768.AP
                if "Historic Data" then
                    CurrReport.Break;
                //--BSS.IT_2768.AP

                //++BSS.IT_3776.MH
                //++BSS.IT_301.SK
                //ProgressWindow.CLOSE;
                //--BSS.IT_301.SK
                //--BSS.IT_3776.MH

                //++BSS.IT_2848.AP
                Commit;
                //--BSS.IT_2848.AP
            end;

            trigger OnPreDataItem()
            begin
                //++BSS.IT_2768.AP
                if "Historic Data" then
                    CurrReport.Break;
                //--BSS.IT_2768.AP

                //++BSS.IT_301.SK
                Recs := "Res. Ledger Entry".Count;
                Progress := 1;
                //--BSS.IT_301.SK
            end;
        }
        dataitem("Statistics G/L Entry"; "Statistics G/L Entry")
        {
            DataItemTableView = SORTING("Entry No.");

            trigger OnAfterGetRecord()
            begin
                //++BSS.IT_3776.MH
                if "Daily Statistic Entry No." <> 0 then
                    CurrReport.Skip;

                Clear(Number);
                DailyStatistic.Reset;
                DailyStatistic.SetCurrentKey("Service Center Code", "Source Type", "Position Group",
                  //++BSS.34782.SU
                  //"Manufacturer Code", "Payment Type Code", "Item Category", "Product Group", "Posting Date",
                  "Manufacturer Code", "Payment Type Code", "Item Category", "Posting Date",
                  //--BSS.34782.SU
                  "Customer Group", "Sell-To Customerno.", "Bill-To Customerno.", Salesperson, Salesrep);
                DailyStatistic.SetRange("Service Center Code", "Service Center");
                DailyStatistic.SetRange("Source Type", DailyStatistic."Source Type"::"G/L Entry");
                DailyStatistic.SetRange("Position Group", "Position Group");
                DailyStatistic.SetRange("Manufacturer Code", "Manufacturer Code");
                DailyStatistic.SetRange("Payment Type Code", "Payment Method");
                DailyStatistic.SetRange("Item Category", "Item Category");
                //++BSS.34782.SU
                //DailyStatistic.SetRange("Product Group", "Product Group");
                //--BSS.34782.SU
                TireSetupStatistic.FindFirst;
                if TireSetupStatistic."Fill Daily Stat. Cust. Fields" then begin
                    DailyStatistic.SetRange("Customer Group", "Customer Group");
                    DailyStatistic.SetRange("Sell-To Customerno.", "Sell-To Customerno.");
                    DailyStatistic.SetRange("Bill-To Customerno.", "Bill-To Customerno.");
                    DailyStatistic.SetRange(Salesperson, Salesperson);
                    DailyStatistic.SetRange(Salesrep, "Representative Code");
                end;
                DailyStatistic.SetRange("Additional Data 1",
                  AdditionalDataFunctions.GetFilterValueByStatGLEntry(1, "Statistics G/L Entry"));
                DailyStatistic.SetRange("Additional Data 2",
                  AdditionalDataFunctions.GetFilterValueByStatGLEntry(2, "Statistics G/L Entry"));
                DailyStatistic.SetRange("Additional Data 3",
                  AdditionalDataFunctions.GetFilterValueByStatGLEntry(3, "Statistics G/L Entry"));
                DailyStatistic.SetRange("Additional Data 4",
                  AdditionalDataFunctions.GetFilterValueByStatGLEntry(4, "Statistics G/L Entry"));
                DailyStatistic.SetRange("Posting Date", "Posting Date");
                //++BSS.IT_6556.SP
                if TireSetupStatistic."Evaluate Item/Res./Acc. No." then begin
                    DailyStatistic.SetRange(Code, "G/L Account No.");
                end;
                //--BSS.IT_6556.SP

                if DailyStatistic.Find('-') then begin
                    Number := DailyStatistic."Entry No.";
                    NewRecord := false;
                end
                else begin
                    Number := FindNextDailyNumber;
                    DailyStatistic.Init;
                    DailyStatistic."Entry No." := Number;
                    DailyStatistic."Service Center Code" := "Service Center";
                    DailyStatistic."Source Type" := Statistic."Source Type"::"G/L Entry";
                    DailyStatistic."Position Group" := "Position Group";
                    DailyStatistic."Main Group" := "Main Group";
                    DailyStatistic."Sub Group" := "Sub Group";
                    AdditionalDataFunctions.CreateDailyDataByStatGLE("Statistics G/L Entry", DailyStatistic);
                    DailyStatistic."Manufacturer Code" := "Manufacturer Code";
                    DailyStatistic."Item Category" := "Item Category";
                    //++BSS.34782.SU
                    //DailyStatistic."Product Group" := "Product Group";
                    //--BSS.34782.SU
                    //++BSS.IT_6556.SP
                    if TireSetupStatistic."Evaluate Item/Res./Acc. No." then begin
                        DailyStatistic.Code := "G/L Account No.";
                    end;
                    //--BSS.IT_6556.SP
                    if TireSetupStatistic."Fill Daily Stat. Cust. Fields" then begin
                        DailyStatistic."Customer Group" := "Customer Group";
                        DailyStatistic."Sell-To Customerno." := "Sell-To Customerno.";
                        DailyStatistic."Bill-To Customerno." := "Bill-To Customerno.";
                        DailyStatistic.Salesperson := Salesperson;
                        DailyStatistic.Salesrep := "Representative Code";
                    end;
                    DailyStatistic."Posting Date" := "Posting Date";
                    DailyStatistic."Payment Type Code" := "Payment Method";
                    //++BSS.TFS_11330.GS
                    if Customer.Get("Sell-To Customerno.") then begin
                        DailyStatistic."Sell-to City" := Customer.City;
                        DailyStatistic."Sell-to Post Code" := Customer."Post Code";
                    end;
                    if Customer.Get("Bill-To Customerno.") then begin
                        DailyStatistic."Bill-to City" := Customer.City;
                        DailyStatistic."Bill-to Post Code" := Customer."Post Code";
                    end;
                    DailyStatistic."Local Currency Code" := GLSetup."LCY Code";
                    //--BSS.TFS_11330.GS
                    NewRecord := true;
                end;

                DailyStatistic."SalesValue (CB)" += "CB-Price" * Quantity;
                DailyStatistic."Sales Quantity Invoiced" += Quantity;
                DailyStatistic."Sales Amount" += Amount;
                DailyStatistic."Cost Amount" += "Cost Amount";
                DailyStatistic."Printed On" := 0D;

                //++BSS.IT_20876.SG
                UpdateZoneAndDealerDaily(DailyStatistic."Service Center Code", DailyStatistic);
                //--BSS.IT_20876.SG

                if NewRecord then
                    DailyStatistic.Insert
                else
                    DailyStatistic.Modify;

                "Daily Statistic Entry No." := Number;
                "Daily Statistic Transfer Date" := Today;
                Modify;

                UpdateProgress(4);
                //--BSS.IT_3776.MH
            end;

            trigger OnPostDataItem()
            begin
                //++BSS.IT_7929.CM
                if not "Historic Data" then
                    //--BSS.IT_7929.CM
                    //++BSS.IT_4995.MH
                    if GuiAllowed then
                        //--BSS.IT_4995.MH
                        //++BSS.IT_3776.MH
                        ProgressWindow.Close;
                //--BSS.IT_3776.MH
            end;

            trigger OnPreDataItem()
            var
                ReportingSetupL: Record "Fastfit Setup - Statistic";
            begin
                //++BSS.IT_3776.MH
                ReportingSetupL.Get;
                if not ReportingSetupL."Consider G/L Entries" then
                    CurrReport.Break;

                if "Historic Data" then
                    CurrReport.Break;

                if not DailyCreate then
                    CurrReport.Break;

                Recs := Count;
                Progress := 1;
                //--BSS.IT_3776.MH
            end;
        }
        dataitem("Monthly Value Entry"; "Value Entry")
        {
            DataItemTableView = SORTING("Statistic Entry No.") ORDER(Ascending) WHERE("Statistic Entry No." = CONST(0));

            trigger OnAfterGetRecord()
            begin
                if "Item Ledger Entry Type" <> "Item Ledger Entry Type"::Sale then begin
                    ValueEntry1.Get("Entry No.");
                    ValueEntry1."Statistic Entry No." := -1;
                    ValueEntry1."Statistic Transfer Date" := Today;
                    ValueEntry1.Modify;
                end
                else begin
                    //++BSS.27775.GV
                    PaymentMethodCode := FindPaymentMethodCode1("Document No.", "Posting Date");
                    //--BSS.27775.GV
                    Clear(Number);
                    if Item.Get("Item No.") then begin
                        Statistic.Reset;
                        Statistic.SetCurrentKey("Service Center", "Source Type", "Position Group",
              //++BSS.34782.SU
              //"Manufacturer Code", "Item Category", "Product Group", "Customer Group", "Sell-To Customerno.",
              "Manufacturer Code", "Item Category", "Customer Group", "Sell-To Customerno.",
                          //--BSS.34782.SU
                          "Bill-To Customerno.", Salesperson, Salesrep, "Posting Period");
                        Statistic.SetRange("Service Center", "Service Center");
                        Statistic.SetRange("Source Type", Statistic."Source Type"::"Value Entry");
                        //++BSS.IT_21184.PW
                        if ("Variant Code" <> '') and ItemVariant.Get(Item."No.", "Variant Code") then begin
                            if ItemVariant."Position Group Code" <> '' then
                                Statistic.SetRange("Position Group", ItemVariant."Position Group Code")
                            else
                                Statistic.SetRange("Position Group", Item."Position Group Code");

                            if ItemVariant."Manufacturer Code" <> '' then
                                Statistic.SetRange("Manufacturer Code", ItemVariant."Manufacturer Code")
                            else
                                Statistic.SetRange("Manufacturer Code", Item."Manufacturer Code");

                            if ItemVariant."Item Category" <> '' then
                                Statistic.SetRange("Item Category", ItemVariant."Item Category")
                            else
                                Statistic.SetRange("Item Category", Item."Item Category Code");
                        end else begin
                            Statistic.SetRange("Position Group", Item."Position Group Code");
                            Statistic.SetRange("Manufacturer Code", Item."Manufacturer Code");
                            Statistic.SetRange("Item Category", Item."Item Category Code");
                        end;

                        //Statistic.SETRANGE("Position Group",Item."Position Group Code");
                        //Statistic.SETRANGE("Manufacturer Code",Item."Manufacturer Code");
                        //Statistic.SETRANGE("Item Category",Item."Item Category Code");
                        //--BSS.IT_21184.PW

                        if "Source Type" = "Source Type"::Customer then begin
                            if Customer.Get("Source No.") then begin
                                Statistic.SetRange("Customer Group", Customer."Customer Group");
                                Statistic.SetRange("Sell-To Customerno.", "Source No.");
                            end;
                        end;
                        if ItemLedgerEntry.Get("Item Ledger Entry No.") then begin
                            Statistic.SetRange("Bill-To Customerno.", ItemLedgerEntry."Bill-to Customer No.");
                            Statistic.SetRange(Salesperson, "Salespers./Purch. Code");
                            Statistic.SetRange(Salesrep, ItemLedgerEntry."Representative Code");
                        end
                        else begin
                            Statistic.SetRange(Salesperson, "Salespers./Purch. Code");
                        end;
                        //++BSS.IT_4230.MH
                        Statistic.SetRange("Additional Data 1", AdditionalDataFunctions.GetFilterValueByValueEntry(1, "Monthly Value Entry"));
                        Statistic.SetRange("Additional Data 2", AdditionalDataFunctions.GetFilterValueByValueEntry(2, "Monthly Value Entry"));
                        Statistic.SetRange("Additional Data 3", AdditionalDataFunctions.GetFilterValueByValueEntry(3, "Monthly Value Entry"));
                        Statistic.SetRange("Additional Data 4", AdditionalDataFunctions.GetFilterValueByValueEntry(4, "Monthly Value Entry"));
                        //--BSS.IT_4230.MH
                        //++BSS.IT_6556.SP
                        TireSetupStatistic.FindFirst;
                        if TireSetupStatistic."Evaluate Item/Res./Acc. No." then begin
                            Statistic.SetRange(Code, Item."No.");
                        end;
                        //--BSS.IT_6556.SP
                        Statistic.SetRange("Posting Period", CalcDate('<+CM>', "Posting Date"));
                        if Statistic.Find('-') then begin
                            Number := Statistic."Entry No.";
                            NewRecord := false;
                        end
                        else begin
                            Number := FindNextNumber;
                            Statistic.Init;
                            Statistic."Entry No." := Number;
                            Statistic."Service Center" := "Service Center";
                            Statistic."Source Type" := Statistic."Source Type"::"Value Entry";
                            //++BSS.IT_6061.SS
                            if ("Variant Code" <> '') and ItemVariant.Get(Item."No.", "Variant Code") then begin
                                //++BSS.IT_21184.PW
                                if ItemVariant."Manufacturer Code" = '' then
                                    Statistic."Manufacturer Code" := Item."Manufacturer Code"
                                else
                                    //--BSS.IT_21184.PW
                                    Statistic."Manufacturer Code" := ItemVariant."Manufacturer Code";

                                //++BSS.IT_21184.PW
                                if ItemVariant."Position Group Code" = '' then begin
                                    Statistic."Main Group" := Item."Main Group Code";
                                    Statistic."Sub Group" := Item."Sub Group Code";
                                    Statistic."Position Group" := Item."Position Group Code";
                                end else begin
                                    //--BSS.IT_21184.PW
                                    Statistic."Position Group" := ItemVariant."Position Group Code";
                                    Statistic."Main Group" := ItemVariant."Main Group Code";
                                    Statistic."Sub Group" := ItemVariant."Sub Group Code";
                                    //++BSS.IT_21184.PW
                                end;
                                //--BSS.IT_21184.PW
                                //++BSS.IT_21184.PW
                                if ItemVariant."Item Category" = '' then
                                    Statistic."Item Category" := Item."Item Category Code"
                                else
                                    //--BSS.IT_21184.PW
                                    Statistic."Item Category" := ItemVariant."Item Category";

                            end else begin
                                Statistic."Manufacturer Code" := Item."Manufacturer Code";
                                Statistic."Position Group" := Item."Position Group Code";
                                Statistic."Item Category" := Item."Item Category Code";
                                //++BSS.IT_4230.MH
                                Statistic."Main Group" := Item."Main Group Code";
                                Statistic."Sub Group" := Item."Sub Group Code";
                            end;
                            //++BSS.27775.GV
                            Statistic."Payment Type Code" := PaymentMethodCode;
                            //--BSS.27775.GV
                            //--BSS.IT_6061.SS
                            AdditionalDataFunctions.CreateMonthlyDataByValueEntry("Monthly Value Entry", Statistic);
                            //--BSS.IT_4230.MH
                            //++BSS.IT_6556.SP
                            if TireSetupStatistic."Evaluate Item/Res./Acc. No." then begin
                                Statistic.Code := Item."No.";
                            end;
                            //--BSS.IT_6556.SP
                            //++BSS.IT_8796.SS
                            /*
                                  IF "Source Type" = "Source Type"::Customer THEN BEGIN
                                    IF Customer.GET("Source No.") THEN BEGIN
                                      Statistic."Customer Group" := Customer."Customer Group";
                                      Statistic."Sell-To Customerno." := "Source No.";
                                    END;
                                  END;
                            */
                            //--BSS.IT_8796.SS
                            if ItemLedgerEntry.Get("Item Ledger Entry No.") then begin
                                //++BSS.IT_8796.SS
                                Statistic."Sell-To Customerno." := ItemLedgerEntry."Source No.";
                                if Customer.Get(ItemLedgerEntry."Source No.") then
                                    Statistic."Customer Group" := Customer."Customer Group";
                                //--BSS.IT_8796.SS
                                Statistic."Bill-To Customerno." := ItemLedgerEntry."Bill-to Customer No.";
                                Statistic.Salesrep := ItemLedgerEntry."Representative Code";
                            end;
                            //++BSS.TFS_11330.GS
                            if ItemLedgerEntry.Get("Item Ledger Entry No.") then begin
                                if Customer.Get(ItemLedgerEntry."Source No.") then begin
                                    Statistic."Sell-to City" := Customer.City;
                                    Statistic."Sell-to Post Code" := Customer."Post Code";
                                end;
                                if Customer.Get(ItemLedgerEntry."Bill-to Customer No.") then begin
                                    Statistic."Bill-to City" := Customer.City;
                                    Statistic."Bill-to Post Code" := Customer."Post Code";
                                end;
                            end;
                            Statistic."Local Currency Code" := GLSetup."LCY Code";
                            //--BSS.TFS_11330.GS
                            Statistic.Salesperson := "Salespers./Purch. Code";

                            Statistic."Posting Period" := CalcDate('<+CM>', "Posting Date");
                            NewRecord := true;
                        end;

                        //++BSS.IT_301_1.GT

                        //++BSS.IT_1683.SK
                        if not Consignment then
                            //--BSS.IT_1683.SK
                            Statistic."Sales Quantity (Expected)" += ("Invoiced Quantity" - "Item Ledger Entry Quantity");

                        Statistic."SalesValue (CB)" -= ("CB-Price" * "Invoiced Quantity");

                        //++BSS.IT_1683.SK
                        if not Consignment then
                            //--BSS.IT_1683.SK
                            Statistic."SalesValue (CB) (Expected)" += (("Invoiced Quantity" - "Item Ledger Entry Quantity") * "CB-Price");

                        //--BSS.IT_301_1.GT

                        Statistic."Sales Quantity Invoiced" -= "Invoiced Quantity";

                        //++BSS.IT_1683.SK
                        if not Consignment then
                            //--BSS.IT_1683.SK
                            Statistic."Sales Amount (Expected)" += "Sales Amount (Expected)";

                        Statistic."Sales Amount" += "Sales Amount (Actual)";

                        //++BSS.IT_1683.SK
                        if not Consignment then
                            //--BSS.IT_1683.SK
                            Statistic."Sales Bonus Amount (Expected)" -= "Bonus Amount (Expected)";

                        //++BSS.IT_1683.SK
                        if not Consignment then
                            //--BSS.IT_1683.SK
                            Statistic."Cost Amount (Expected)" -= "Cost Amount (Expected)";

                        //++BSS.IT_20876.SG
                        UpdateZoneAndDealerMonthly(Statistic."Service Center", Statistic);
                        //--BS.IT_20876.SG

                        Statistic."Cost Amount" -= "Cost Amount (Actual)";

                        //++BSS.TFS_11330.GS
                        Statistic."Discount Amount" -= "Discount Amount";
                        //--BSS.TFS_11330.GS

                        if NewRecord then
                            Statistic.Insert
                        else
                            Statistic.Modify;

                        ValueEntry1.Get("Entry No.");
                        ValueEntry1."Statistic Entry No." := Number;
                        ValueEntry1."Statistic Transfer Date" := Today;
                        ValueEntry1.Modify;
                    end;
                end;

                //++BSS.IT_301.SK
                UpdateProgress(1);
                //--BSS.IT_301.SK

            end;

            trigger OnPostDataItem()
            begin
                //++BSS.IT_2848.AP
                Commit;
                //--BSS.IT_2848.AP
            end;

            trigger OnPreDataItem()
            begin
                //++BSS.IT_2768.AP
                if "Historic Data" then
                    CurrReport.Break;
                //--BSS.IT_2768.AP

                //++BSS.IT_4995.MH
                if GuiAllowed then
                    //--BSS.IT_4995.MH
                    //++BSS.IT_301.SK
                    ProgressWindow.Open(C_BSS_INF002 + '\' +
                                    ' \' +
                                    C_BSS_INF003 + '\' +
                                    '@1@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\' +
                                    C_BSS_INF005 + '\' +
                                    '@2@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\' +
                                    C_BSS_INF004 + '\' +
                                    '@3@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\' +
                                    //++BSS.IT_3776.MH
                                    C_BSS_INF009 + '\' +
                                    '@4@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');
                //--BSS.IT_3776.MH

                if not MonthlyCreate then
                    CurrReport.Break;

                Recs := "Monthly Value Entry".Count;
                Progress := 1;
                //--BSS.IT_301.SK
            end;
        }
        dataitem("Monthly Pre. Res. Ledger Entry"; "Pre. Res. Ledger Entry")
        {
            DataItemTableView = SORTING("Statistic Entry No.") ORDER(Ascending) WHERE("Statistic Entry No." = CONST(0));

            trigger OnAfterGetRecord()
            begin
                if not MonthlyCreate then
                    CurrReport.Break;
                //++BSS.27775.GV
                PaymentMethodCode := FindPaymentMethodCode1("Document No.", "Posting Date");
                //--BSS.27775.GV
                Clear(Number);
                //++BSS.IT_21389.AK
                //IF Resource.GET("Resource No.") THEN BEGIN
                //--BSS.IT_21389.AK
                Statistic.Reset;
                Statistic.SetCurrentKey("Service Center", "Source Type", "Position Group",
                  //++BSS.34782.SU
                  //"Manufacturer Code", "Item Category", "Product Group", "Customer Group", "Sell-To Customerno.",
                  "Manufacturer Code", "Item Category", "Customer Group", "Sell-To Customerno.",
                  //--BSS.34782.SU
                  "Bill-To Customerno.", Salesperson, Salesrep, "Posting Period");
                Statistic.SetRange("Service Center", "Service Center");
                Statistic.SetRange("Source Type", Statistic."Source Type"::"Pre. Res. Entry");
                //++BSS.IT_21389.AK
                //  Statistic.SETRANGE("Position Group",Resource."Position Group Code");
                //  Statistic.SETRANGE("Manufacturer Code",Resource."Manufacturer Code");
                //  Statistic.SETRANGE("Item Category",Resource."Item Category Code");
                //  Statistic.SETRANGE("Product Group",Resource."Product Group Code");
                Statistic.SetRange("Position Group", "Position Group Code");
                Statistic.SetRange("Manufacturer Code", "Manufacturer Code");
                Statistic.SetRange("Item Category", "Item Category Code");
                //++BSS.34782.SU
                //Statistic.SetRange("Product Group", "Product Group Code");
                //--BSS.34782.SU
                //--BSS.IT_21389.AK
                if Customer.Get("Sell-to Customer No.") then begin
                    Statistic.SetRange("Customer Group", Customer."Customer Group");
                    Statistic.SetRange("Sell-To Customerno.", "Sell-to Customer No.");
                end;
                Statistic.SetRange("Bill-To Customerno.", "Bill-to Customer No.");
                Statistic.SetRange(Salesperson, "Salespers./Purch. Code");
                Statistic.SetRange(Salesrep, "Representative Code");
                //++BSS.IT_4230.MH
                Statistic.SetRange("Additional Data 1",
                  AdditionalDataFunctions.GetFilterValueByPreResLedgerE(1, "Monthly Pre. Res. Ledger Entry"));
                Statistic.SetRange("Additional Data 2",
                  AdditionalDataFunctions.GetFilterValueByPreResLedgerE(2, "Monthly Pre. Res. Ledger Entry"));
                Statistic.SetRange("Additional Data 3",
                  AdditionalDataFunctions.GetFilterValueByPreResLedgerE(3, "Monthly Pre. Res. Ledger Entry"));
                Statistic.SetRange("Additional Data 4",
                  AdditionalDataFunctions.GetFilterValueByPreResLedgerE(4, "Monthly Pre. Res. Ledger Entry"));
                //--BSS.IT_4230.MH
                //++BSS.IT_6556.SP
                TireSetupStatistic.FindFirst;
                if TireSetupStatistic."Evaluate Item/Res./Acc. No." then begin
                    //++BSS.IT_21389.AK
                    Statistic.SetRange(Code, "Resource No.");
                    //--BSS.IT_21389.AK
                end;
                //--BSS.IT_6556.SP
                Statistic.SetRange("Posting Period", CalcDate('<+CM>', "Posting Date"));
                if Statistic.Find('-') then begin
                    Number := Statistic."Entry No.";
                    NewRecord := false;
                end
                else begin
                    Number := FindNextNumber;
                    Statistic.Init;
                    Statistic."Entry No." := Number;
                    Statistic."Service Center" := "Service Center";
                    Statistic."Source Type" := Statistic."Source Type"::"Pre. Res. Entry";
                    //++BSS.IT_21389.AK
                    //    Statistic."Position Group" := Resource."Position Group Code";
                    Statistic."Position Group" := "Position Group Code";
                    //--BSS.IT_21389.AK
                    //++BSS.IT_4230.MH
                    //++BSS.IT_21389.AK
                    //    Statistic."Main Group" := Resource."Main Group Code";
                    //    Statistic."Sub Group" := Resource."Sub Group Code";
                    Statistic."Main Group" := "Main Group Code";
                    Statistic."Sub Group" := "Sub Group Code";
                    //--BSS.IT_21389.AK
                    AdditionalDataFunctions.CreateMonthlyDataByPreResLedgE("Monthly Pre. Res. Ledger Entry", Statistic);
                    //--BSS.IT_4230.MH
                    //++BSS.IT_6556.SP
                    if TireSetupStatistic."Evaluate Item/Res./Acc. No." then begin
                        //++BSS.IT_21389.AK
                        //     Statistic.Code := Resource."No.";
                        Statistic.Code := "Resource No.";
                        //--BSS.IT_21389.AK
                    end;
                    //--BSS.IT_6556.SP
                    //++BSS.IT_21389.AK
                    //    Statistic."Manufacturer Code" := Resource."Manufacturer Code";
                    //    Statistic."Item Category" :=  Resource."Item Category Code";
                    //    Statistic."Product Group" := Resource."Product Group Code";
                    Statistic."Manufacturer Code" := "Manufacturer Code";
                    Statistic."Item Category" := "Item Category Code";
                    //++BSS.34782.SU
                    //Statistic."Product Group" := "Product Group Code";
                    //--BSS.34782.SU
                    //--BSS.IT_21389.AK
                    //++BSS.27775.GV
                    Statistic."Payment Type Code" := PaymentMethodCode;
                    //--BSS.27775.GV
                    if Customer.Get("Sell-to Customer No.") then begin
                        Statistic."Customer Group" := Customer."Customer Group";
                        Statistic."Sell-To Customerno." := "Sell-to Customer No.";
                    end;
                    Statistic."Bill-To Customerno." := "Bill-to Customer No.";
                    Statistic.Salesperson := "Salespers./Purch. Code";
                    Statistic.Salesrep := "Representative Code";
                    Statistic."Posting Period" := CalcDate('<+CM>', "Posting Date");
                    //++BSS.TFS_11330.GS
                    if Customer.Get("Sell-to Customer No.") then begin
                        Statistic."Sell-to City" := Customer.City;
                        Statistic."Sell-to Post Code" := Customer."Post Code";
                    end;
                    if Customer.Get("Bill-to Customer No.") then begin
                        Statistic."Bill-to City" := Customer.City;
                        Statistic."Bill-to Post Code" := Customer."Post Code";
                    end;
                    Statistic."Local Currency Code" := GLSetup."LCY Code";
                    //--BSS.TFS_11330.GS

                    NewRecord := true;
                end;

                Statistic."Sales Quantity (Expected)" += "Sales Quantity (Expected)";
                Statistic."Sales Amount (Expected)" += "Sales Amount (Expected) (LCY)";
                Statistic."Cost Amount (Expected)" += "Cost Amount (Expected) (LCY)";


                //++BSS.IT_301_1.GT
                //    Statistic."Sales Bonus Amount (Expected)" -= "Bonus Amount (Expected)";
                //    Statistic."SalesValue (CB)" -= ("CB-Price" *  "Invoiced Quantity");
                Statistic."SalesValue (CB) (Expected)" += ("Sales Quantity (Expected)" * "CB-Price");
                //--BSS.IT_301_1.GT

                //++BSS.IT_20876.SG
                UpdateZoneAndDealerMonthly(Statistic."Service Center", Statistic);
                //--BS.IT_20876.SG

                if NewRecord then
                    Statistic.Insert
                else
                    Statistic.Modify;

                PreResLedgerEntry1.Get("Entry No.");
                PreResLedgerEntry1."Statistic Entry No." := Number;
                PreResLedgerEntry1."Statistic Transfer Date" := Today;
                PreResLedgerEntry1.Modify;
                //++BSS.IT_21389.AK
                //END;
                //--BSS.IT_21389.AK

                //++BSS.IT_301.SK
                UpdateProgress(2);
                //--BSS.IT_301.SK
            end;

            trigger OnPostDataItem()
            begin
                //++BSS.IT_2848.AP
                Commit;
                //--BSS.IT_2848.AP
            end;

            trigger OnPreDataItem()
            begin
                //++BSS.IT_2768.AP
                if "Historic Data" then
                    CurrReport.Break;
                //--BSS.IT_2768.AP

                //++BSS.IT_301.SK
                Recs := "Monthly Pre. Res. Ledger Entry".Count;
                Progress := 1;
                //--BSS.IT_301.SK
            end;
        }
        dataitem("Monthly Res. Ledger Entry"; "Res. Ledger Entry")
        {
            DataItemTableView = SORTING("Statistic Entry No.") ORDER(Ascending) WHERE("Statistic Entry No." = CONST(0));

            trigger OnAfterGetRecord()
            begin
                if not MonthlyCreate then
                    CurrReport.Break;

                if "Entry Type" <> "Entry Type"::Sale then begin
                    ResLedgerEntry1.Get("Entry No.");
                    ResLedgerEntry1."Statistic Entry No." := -1;
                    ResLedgerEntry1."Statistic Transfer Date" := Today;
                    ResLedgerEntry1.Modify;
                end
                else begin
                    Clear(Number);
                    //++BSS.27775.GV
                    PaymentMethodCode := FindPaymentMethodCode1("Document No.", "Posting Date");
                    //--BSS.27775.GV
                    //++BSS.IT_21389.AK
                    //  IF Resource.GET("Resource No.") THEN BEGIN
                    //--BSS.IT_21389.AK
                    Statistic.Reset;
                    Statistic.SetCurrentKey("Service Center", "Source Type", "Position Group",
              //++BSS.34782.SU
              //"Manufacturer Code", "Item Category", "Product Group", "Customer Group", "Sell-To Customerno.",
              "Manufacturer Code", "Item Category", "Customer Group", "Sell-To Customerno.",
                      //--BSS.34782.SU
                      "Bill-To Customerno.", Salesperson, Salesrep, "Posting Period");
                    Statistic.SetRange("Service Center", "Service Center");
                    Statistic.SetRange("Source Type", Statistic."Source Type"::"Res. Ledger Entry");
                    //++BSS.IT_21389.AK
                    //    Statistic.SETRANGE("Position Group",Resource."Position Group Code");
                    //    Statistic.SETRANGE("Manufacturer Code",Resource."Manufacturer Code");
                    //    Statistic.SETRANGE("Item Category",Resource."Item Category Code");
                    //    Statistic.SETRANGE("Product Group",Resource."Product Group Code");
                    Statistic.SetRange("Position Group", "Position Group Code");
                    Statistic.SetRange("Manufacturer Code", "Manufacturer Code");
                    Statistic.SetRange("Item Category", "Item Category Code");
                    //++BSS.34782.SU
                    //Statistic.SetRange("Product Group", "Product Group Code");
                    //--BSS.34782.SU
                    //--BSS.IT_21389.AK
                    if "Source Type" = "Source Type"::Customer then begin
                        if Customer.Get("Source No.") then begin
                            Statistic.SetRange("Customer Group", Customer."Customer Group");
                            Statistic.SetRange("Sell-To Customerno.", "Source No.");
                        end;
                    end;
                    Statistic.SetRange("Bill-To Customerno.", "Bill-to Customer No.");
                    Statistic.SetRange(Salesperson, "Salespers./Purch. Code");
                    Statistic.SetRange(Salesrep, "Representative Code");
                    //++BSS.IT_4230.MH
                    Statistic.SetRange("Additional Data 1",
                      AdditionalDataFunctions.GetFilterValueByResLedgerE(1, "Monthly Res. Ledger Entry"));
                    Statistic.SetRange("Additional Data 2",
                      AdditionalDataFunctions.GetFilterValueByResLedgerE(2, "Monthly Res. Ledger Entry"));
                    Statistic.SetRange("Additional Data 3",
                      AdditionalDataFunctions.GetFilterValueByResLedgerE(3, "Monthly Res. Ledger Entry"));
                    Statistic.SetRange("Additional Data 4",
                      AdditionalDataFunctions.GetFilterValueByResLedgerE(4, "Monthly Res. Ledger Entry"));
                    //--BSS.IT_4230.MH
                    //++BSS.IT_6556.SP
                    TireSetupStatistic.FindFirst;
                    if TireSetupStatistic."Evaluate Item/Res./Acc. No." then begin
                        //++BSS.IT_21389.AK
                        //      Statistic.SETRANGE(Code, Resource."No.");
                        Statistic.SetRange(Code, "Resource No.");
                        //--BSS.IT_21389.AK
                    end;
                    //--BSS.IT_6556.SP
                    //++BSS.TFS_11330.GS
                    Statistic.SetRange("Unit of Measure Code", "Unit of Measure Code");
                    //--BSS.TFS_11330.GS
                    Statistic.SetRange("Posting Period", CalcDate('<+CM>', "Posting Date"));
                    if Statistic.Find('-') then begin
                        Number := Statistic."Entry No.";
                        NewRecord := false;
                    end
                    else begin
                        Number := FindNextNumber;
                        Statistic.Init;
                        Statistic."Entry No." := Number;
                        Statistic."Service Center" := "Service Center";
                        Statistic."Source Type" := Statistic."Source Type"::"Res. Ledger Entry";
                        //++BSS.IT_21389.AK
                        //      Statistic."Position Group" := Resource."Position Group Code";
                        Statistic."Position Group" := "Position Group Code";
                        //--BSS.IT_21389.AK
                        //++BSS.IT_4230.MH
                        //++BSS.IT_21389.AK
                        //      Statistic."Main Group" := Resource."Main Group Code";
                        //      Statistic."Sub Group" := Resource."Sub Group Code";
                        Statistic."Main Group" := "Main Group Code";
                        Statistic."Sub Group" := "Sub Group Code";
                        //--BSS.IT_21389.AK
                        AdditionalDataFunctions.CreateMonthlyDataByResLedgE("Monthly Res. Ledger Entry", Statistic);
                        //--BSS.IT_4230.MH
                        //++BSS.IT_6556.SP
                        if TireSetupStatistic."Evaluate Item/Res./Acc. No." then begin
                            //++BSS.IT_21389.AK
                            //        Statistic.Code := Resource."No.";
                            Statistic.Code := "Resource No.";
                            //--BSS.IT_21389.AK
                        end;
                        //--BSS.IT_6556.SP
                        //++BSS.IT_21389.AK
                        //      Statistic."Manufacturer Code" := Resource."Manufacturer Code";
                        //      Statistic."Item Category" :=  Resource."Item Category Code";
                        //      Statistic."Product Group" := Resource."Product Group Code";
                        Statistic."Manufacturer Code" := "Manufacturer Code";
                        Statistic."Item Category" := "Item Category Code";
                        //++BSS.34782.SU
                        //Statistic."Product Group" := "Product Group Code";
                        //--BSS.34782.SU
                        //--BSS.IT_21389.AK
                        //++BSS.27775.GV
                        Statistic."Payment Type Code" := PaymentMethodCode;
                        //--BSS.27775.GV
                        if "Source Type" = "Source Type"::Customer then begin
                            if Customer.Get("Source No.") then begin
                                Statistic."Customer Group" := Customer."Customer Group";
                                Statistic."Sell-To Customerno." := "Source No.";
                            end;
                        end;
                        Statistic."Bill-To Customerno." := "Bill-to Customer No.";
                        Statistic.Salesperson := "Salespers./Purch. Code";
                        Statistic.Salesrep := "Representative Code";
                        Statistic."Posting Period" := CalcDate('<+CM>', "Posting Date");
                        //++BSS.TFS_11330.GS
                        if "Source Type" = "Source Type"::Customer then
                            if Customer.Get("Source No.") then begin
                                Statistic."Sell-to City" := Customer.City;
                                Statistic."Sell-to Post Code" := Customer."Post Code";
                            end;
                        if Customer.Get("Bill-to Customer No.") then begin
                            Statistic."Bill-to City" := Customer.City;
                            Statistic."Bill-to Post Code" := Customer."Post Code";
                        end;
                        Statistic."Local Currency Code" := GLSetup."LCY Code";
                        Statistic."Unit of Measure Code" := "Unit of Measure Code";
                        //--BSS.TFS_11330.GS

                        NewRecord := true;
                    end;
                    Statistic."Sales Quantity Invoiced" -= "Quantity (Base)";
                    Statistic."Sales Amount" -= "Total Price";
                    Statistic."Cost Amount" -= "Total Cost";

                    //++BSS.IT_301_1.GT
                    // Statistic."Sales Bonus Amount (Expected)"
                    Statistic."SalesValue (CB)" -= ("CB-Price" * "Quantity (Base)");
                    // Statistic."SalesValue (CB) (Expected)" +=;
                    //--BSS.IT_301_1.GT

                    //++BSS.IT_20876.SG
                    UpdateZoneAndDealerMonthly(Statistic."Service Center", Statistic);
                    //--BS.IT_20876.SG

                    //++BSS.TFS_11330.GS
                    Statistic."Discount Amount" -= (Quantity * "Unit Price" - "Total Price");
                    //--BSS.TFS_11330.GS

                    if NewRecord then
                        Statistic.Insert
                    else
                        Statistic.Modify;

                    ResLedgerEntry1.Get("Entry No.");
                    ResLedgerEntry1."Statistic Entry No." := Number;
                    ResLedgerEntry1."Statistic Transfer Date" := Today;
                    ResLedgerEntry1.Modify;
                end;
                //++BSS.IT_21389.AK
                //END;
                //--BSS.IT_21389.AK

                //++BSS.IT_301.SK
                UpdateProgress(3);
                //--BSS.IT_301.SK
            end;

            trigger OnPostDataItem()
            begin
                //++BSS.IT_2768.AP
                if "Historic Data" then
                    CurrReport.Break;
                //--BSS.IT_2768.AP

                //++BSS.IT_3776.MH
                //++BSS.IT_301.SK
                //ProgressWindow.CLOSE;
                //--BSS.IT_301.SK
                //--BSS.IT_3776.MH
                //++BSS.IT_2848.AP
                Commit;
                //--BSS.IT_2848.AP
            end;

            trigger OnPreDataItem()
            begin
                //++BSS.IT_2768.AP
                if "Historic Data" then
                    CurrReport.Break;
                //--BSS.IT_2768.AP

                //++BSS.IT_301.SK
                Recs := "Monthly Res. Ledger Entry".Count;
                Progress := 1;
                //--BSS.IT_301.SK
            end;
        }
        dataitem("Monthly Statistics G/L Entry"; "Statistics G/L Entry")
        {
            DataItemTableView = SORTING("Entry No.");

            trigger OnAfterGetRecord()
            var
                GLAccount: Record "G/L Account";
            begin
                //++BSS.IT_3776.MH
                if "Statistic Entry No." <> 0 then
                    CurrReport.Skip;

                Clear(Number);
                Statistic.Reset;
                Statistic.SetCurrentKey("Service Center", "Source Type", "Position Group",
                  //++BSS.34782.SU
                  //"Manufacturer Code", "Item Category", "Product Group", "Customer Group", "Sell-To Customerno.",
                  "Manufacturer Code", "Item Category", "Customer Group", "Sell-To Customerno.",
                  //--BSS.34782.SU
                  "Bill-To Customerno.", Salesperson, Salesrep, "Posting Period");
                Statistic.SetRange("Service Center", "Service Center");
                Statistic.SetRange("Source Type", Statistic."Source Type"::"G/L Entry");
                Statistic.SetRange("Position Group", "Position Group");
                Statistic.SetRange("Manufacturer Code", "Manufacturer Code");
                Statistic.SetRange("Item Category", "Item Category");
                //++BSS.34782.SU
                //Statistic.SetRange("Product Group", "Product Group");
                //--BSS.34782.SU
                Statistic.SetRange("Customer Group", "Customer Group");
                Statistic.SetRange("Sell-To Customerno.", "Sell-To Customerno.");
                Statistic.SetRange("Bill-To Customerno.", "Bill-To Customerno.");
                Statistic.SetRange(Salesperson, Salesperson);
                Statistic.SetRange(Salesrep, "Representative Code");
                Statistic.SetRange("Additional Data 1",
                  AdditionalDataFunctions.GetFilterValueByStatGLEntry(1, "Monthly Statistics G/L Entry"));
                Statistic.SetRange("Additional Data 2",
                  AdditionalDataFunctions.GetFilterValueByStatGLEntry(2, "Monthly Statistics G/L Entry"));
                Statistic.SetRange("Additional Data 3",
                  AdditionalDataFunctions.GetFilterValueByStatGLEntry(3, "Monthly Statistics G/L Entry"));
                Statistic.SetRange("Additional Data 4",
                  AdditionalDataFunctions.GetFilterValueByStatGLEntry(4, "Monthly Statistics G/L Entry"));
                Statistic.SetRange("Posting Period", CalcDate('<+CM>', "Posting Date"));
                //++BSS.IT_6556.SP
                TireSetupStatistic.FindFirst;
                if TireSetupStatistic."Evaluate Item/Res./Acc. No." then begin
                    Statistic.SetRange(Code, "G/L Account No.");
                end;
                //--BSS.IT_6556.SP
                if Statistic.Find('-') then begin
                    Number := Statistic."Entry No.";
                    NewRecord := false;
                end
                else begin
                    Number := FindNextNumber;
                    Statistic.Init;
                    Statistic."Entry No." := Number;
                    Statistic."Service Center" := "Service Center";
                    Statistic."Source Type" := Statistic."Source Type"::"G/L Entry";
                    Statistic."Position Group" := "Position Group";
                    Statistic."Main Group" := "Main Group";
                    Statistic."Sub Group" := "Sub Group";
                    AdditionalDataFunctions.CreateMonthlyDataByStatGLE("Monthly Statistics G/L Entry", Statistic);
                    //++BSS.IT_6556.SP
                    if TireSetupStatistic."Evaluate Item/Res./Acc. No." then begin
                        Statistic.Code := "G/L Account No.";
                    end;
                    //--BSS.IT_6556.SP
                    Statistic."Manufacturer Code" := "Manufacturer Code";
                    //++BSS.27775.GV
                    Statistic."Payment Type Code" := "Payment Method";
                    //--BSS.27775.GV
                    Statistic."Item Category" := "Item Category";
                    //++BSS.34782.SU
                    //Statistic."Product Group" := "Product Group";
                    //--BSS.34782.SU
                    Statistic."Customer Group" := "Customer Group";
                    Statistic."Sell-To Customerno." := "Sell-To Customerno.";
                    Statistic."Bill-To Customerno." := "Bill-To Customerno.";
                    Statistic.Salesperson := Salesperson;
                    Statistic.Salesrep := "Representative Code";
                    Statistic."Posting Period" := CalcDate('<+CM>', "Posting Date");
                    //++BSS.TFS_11330.GS
                    if Customer.Get("Sell-To Customerno.") then begin
                        Statistic."Sell-to City" := Customer.City;
                        Statistic."Sell-to Post Code" := Customer."Post Code";
                    end;
                    if Customer.Get("Bill-To Customerno.") then begin
                        Statistic."Bill-to City" := Customer.City;
                        Statistic."Bill-to Post Code" := Customer."Post Code";
                    end;
                    Statistic."Local Currency Code" := GLSetup."LCY Code";
                    //--BSS.TFS_11330.GS
                    NewRecord := true;
                end;

                Statistic."SalesValue (CB)" += "CB-Price" * Quantity;
                Statistic."Sales Quantity Invoiced" += Quantity;
                Statistic."Sales Amount" += Amount;
                Statistic."Cost Amount" += "Cost Amount";

                //++BSS.IT_20876.SG
                UpdateZoneAndDealerMonthly(Statistic."Service Center", Statistic);
                //--BS.IT_20876.SG

                if NewRecord then
                    Statistic.Insert
                else
                    Statistic.Modify;

                "Statistic Entry No." := Number;
                "Statistic Transfer Date" := Today;
                Modify;

                UpdateProgress(4);
                //--BSS.IT_3776.MH
            end;

            trigger OnPostDataItem()
            begin
                //++BSS.IT_7929.CM
                if not "Historic Data" then
                    //--BSS.IT_7929.CM
                    //++BSS.IT_4995.MH
                    if GuiAllowed then
                        //--BSS.IT_4995.MH
                        //++BSS.IT_3776.MH
                        ProgressWindow.Close;
                //--BSS.IT_3776.MH
            end;

            trigger OnPreDataItem()
            var
                ReportingSetupL: Record "Fastfit Setup - Statistic";
            begin
                //++BSS.IT_3776.MH
                ReportingSetupL.Get;
                if not ReportingSetupL."Consider G/L Entries" then
                    CurrReport.Break;

                if "Historic Data" then
                    CurrReport.Break;

                if not MonthlyCreate then
                    CurrReport.Break;

                Recs := Count;
                Progress := 1;
                //--BSS.IT_3776.MH
            end;
        }
        dataitem("Daily Hist. Stat. Raw Data"; "Hist. Stat. Raw Data")
        {
            DataItemTableView = SORTING("Statistic Entry No.") ORDER(Ascending) WHERE("Daily Statistic Entry No." = CONST(0));

            trigger OnAfterGetRecord()
            var
                HistData1: Record "Hist. Stat. Raw Data";
            begin

                if "Daily Hist. Stat. Raw Data"."Entry Type" <> "Daily Hist. Stat. Raw Data"."Entry Type"::Sale then begin
                    HistData1.Get("Entry No.");
                    HistData1."Daily Statistic Entry No." := -1;
                    HistData1."Daily Statistic Transfer Date" := Today;
                    HistData1.Modify;
                end
                else begin
                    Clear(Number);
                    PaymentMethodCode := "Daily Hist. Stat. Raw Data"."Payment Type Code";

                    if "Daily Hist. Stat. Raw Data".Item then begin

                        // ---------------------------------------------------------
                        // items
                        // ---------------------------------------------------------
                        //++BSS.IT_21389.AK
                        //    IF ItemL.GET("Item No.") THEN BEGIN
                        //--BSS.IT_21389.AK
                        DailyStatistic.Reset;
                        //++BSS.IT_3730.WL
                        //DailyStatistic.SETCURRENTKEY("Resp. Center Code","Source Type","Position Group",
                        //  "Manufacturer Code","Payment Type Code","Item Category","Product Group","Posting Date");
                        DailyStatistic.SetCurrentKey("Service Center Code", "Source Type", "Position Group",
              //++BSS.34782.SU
              //"Manufacturer Code", "Payment Type Code", "Item Category", "Product Group", "Posting Date",			  
              "Manufacturer Code", "Payment Type Code", "Item Category", "Posting Date",
                          //--BSS.34782.SU
                          "Customer Group", "Sell-To Customerno.", "Bill-To Customerno.", Salesperson, Salesrep);
                        //--BSS.IT_3730.WL
                        DailyStatistic.SetRange("Service Center Code", "Service Center");
                        DailyStatistic.SetRange("Source Type", Statistic."Source Type"::"Value Entry");
                        //++BSS.IT_21389.AK
                        //      DailyStatistic.SETRANGE("Position Group",ItemL."Position Group Code");
                        //      DailyStatistic.SETRANGE("Manufacturer Code",ItemL."Manufacturer Code");
                        DailyStatistic.SetRange("Position Group", "Position Group Code");
                        DailyStatistic.SetRange("Manufacturer Code", "Manufacturer Code");
                        //--BSS.IT_21389.AK
                        DailyStatistic.SetRange("Payment Type Code", PaymentMethodCode);
                        //++BSS.IT_21389.AK
                        //      DailyStatistic.SETRANGE("Item Category",ItemL."Item Category Code");
                        //      DailyStatistic.SETRANGE("Product Group",ItemL."Product Group Code");
                        DailyStatistic.SetRange("Item Category", "Item Category Code");
                        //++BSS.34782.SU
                        //DailyStatistic.SetRange("Product Group", "Product Group Code");
                        //--BSS.34782.SU
                        //--BSS.IT_21389.AK
                        //++BSS.IT_3730.WL
                        //++BSS.IT_4230.MH
                        DailyStatistic.SetRange("Additional Data 1",
                          AdditionalDataFunctions.GetFilterValueByHistRawData(1, "Daily Hist. Stat. Raw Data"));
                        DailyStatistic.SetRange("Additional Data 2",
                          AdditionalDataFunctions.GetFilterValueByHistRawData(2, "Daily Hist. Stat. Raw Data"));
                        DailyStatistic.SetRange("Additional Data 3",
                          AdditionalDataFunctions.GetFilterValueByHistRawData(3, "Daily Hist. Stat. Raw Data"));
                        DailyStatistic.SetRange("Additional Data 4",
                          AdditionalDataFunctions.GetFilterValueByHistRawData(4, "Daily Hist. Stat. Raw Data"));
                        //--BSS.IT_4230.MH
                        TireSetupStatistic.FindFirst;
                        if TireSetupStatistic."Fill Daily Stat. Cust. Fields" then begin
                            if Customer.Get("Source No.") then begin
                                DailyStatistic.SetRange("Customer Group", Customer."Customer Group");
                                DailyStatistic.SetRange("Sell-To Customerno.", "Source No.");
                            end;
                            DailyStatistic.SetRange("Bill-To Customerno.", "Bill-to Customer No.");
                            DailyStatistic.SetRange(Salesperson, "Salespers./Purch. Code");
                            DailyStatistic.SetRange(Salesrep, "Representative Code");
                        end;
                        //--BSS.IT_3730.WL
                        DailyStatistic.SetRange("Posting Date", "Posting Date");
                        if DailyStatistic.Find('-') then begin
                            Number := DailyStatistic."Entry No.";
                            NewRecord := false;
                        end
                        else begin
                            Number := FindNextDailyNumber;
                            DailyStatistic.Init;
                            DailyStatistic."Entry No." := Number;
                            DailyStatistic."Service Center Code" := "Service Center";
                            DailyStatistic."Source Type" := Statistic."Source Type"::"Value Entry";
                            //++BSS.IT_21389.AK
                            //        DailyStatistic."Position Group"    := ItemL."Position Group Code";
                            DailyStatistic."Position Group" := "Position Group Code";
                            //--BSS.IT_21389.AK
                            //++BSS.IT_4230.MH
                            //++BSS.IT_21389.AK
                            //        DailyStatistic."Main Group" := ItemL."Main Group Code";
                            //        DailyStatistic."Sub Group" := ItemL."Sub Group Code";
                            DailyStatistic."Main Group" := "Main Group Code";
                            DailyStatistic."Sub Group" := "Sub Group Code";
                            //--BSS.IT_21389.AK
                            AdditionalDataFunctions.CreateDailyDataByHistRawData("Daily Hist. Stat. Raw Data", DailyStatistic);
                            //--BSS.IT_4230.MH
                            //++BSS.IT_21389.AK
                            //        DailyStatistic."Manufacturer Code" := ItemL."Manufacturer Code";
                            DailyStatistic."Manufacturer Code" := "Manufacturer Code";
                            //--BSS.IT_21389.AK
                            DailyStatistic."Payment Type Code" := PaymentMethodCode;
                            //++BSS.IT_21389.AK
                            //        DailyStatistic."Item Category" := ItemL."Item Category Code";
                            //        DailyStatistic."Product Group" := ItemL."Product Group Code";
                            DailyStatistic."Item Category" := "Item Category Code";
                            //++BSS.34782.SU
                            //DailyStatistic."Product Group" := "Product Group Code";
                            //--BSS.34782.SU
                            //--BSS.IT_21389.AK
                            DailyStatistic."Posting Date" := "Posting Date";
                            //++BSS.IT_3730.WL
                            if TireSetupStatistic."Fill Daily Stat. Cust. Fields" then begin
                                if Customer.Get("Source No.") then begin
                                    DailyStatistic."Customer Group" := Customer."Customer Group";
                                    DailyStatistic."Sell-To Customerno." := "Source No.";
                                end;
                                DailyStatistic."Bill-To Customerno." := "Bill-to Customer No.";
                                DailyStatistic.Salesrep := "Representative Code";
                                DailyStatistic.Salesperson := "Salespers./Purch. Code";
                            end;
                            //--BSS.IT_3730.WL
                            //++BSS.TFS_11330.GS
                            if Customer.Get("Source No.") then begin
                                DailyStatistic."Sell-to City" := Customer.City;
                                DailyStatistic."Sell-to Post Code" := Customer."Post Code";
                            end;
                            if Customer.Get("Bill-to Customer No.") then begin
                                DailyStatistic."Bill-to City" := Customer.City;
                                DailyStatistic."Bill-to Post Code" := Customer."Post Code";
                            end;
                            DailyStatistic."Local Currency Code" := GLSetup."LCY Code";
                            //--BSS.TFS_11330.GS
                            NewRecord := true;
                        end;

                        DailyStatistic."Sales Quantity Invoiced" -= Quantity;
                        DailyStatistic."Sales Amount" += "Sales Amount (Actual)";
                        DailyStatistic."Cost Amount" -= "Cost Amount (Actual)";

                        //++BSS.IT_20876.SG
                        UpdateZoneAndDealerDaily(DailyStatistic."Service Center Code", DailyStatistic);
                        //--BS.IT_20876.SG

                        DailyStatistic."Printed On" := 0D;
                        if NewRecord then
                            DailyStatistic.Insert
                        else
                            DailyStatistic.Modify;

                        HistData1.Get("Entry No.");
                        HistData1."Daily Statistic Entry No." := Number;
                        HistData1."Daily Statistic Transfer Date" := Today;
                        HistData1.Modify;
                        //++BSS.IT_21389.AK
                        //    END;
                        //--BSS.IT_21389.AK

                    end
                    else begin

                        // ---------------------------------------------------------
                        // resources
                        // ---------------------------------------------------------
                        //++BSS.IT_21389.AK
                        //    IF ResourceL.GET("Item No.") THEN BEGIN
                        //--BSS.IT_21389.AK
                        DailyStatistic.Reset;
                        //++BSS.IT_3730.WL
                        //DailyStatistic.SETCURRENTKEY("Resp. Center Code","Source Type","Position Group",
                        //  "Manufacturer Code","Payment Type Code","Item Category","Product Group","Posting Date");
                        DailyStatistic.SetCurrentKey("Service Center Code", "Source Type", "Position Group",
                          //++BSS.34782.SU  
                          //"Manufacturer Code", "Payment Type Code", "Item Category", "Product Group", "Posting Date",
                          "Manufacturer Code", "Payment Type Code", "Item Category", "Posting Date",
                          //--BSS.34782.SU  
                          "Customer Group", "Sell-To Customerno.", "Bill-To Customerno.", Salesperson, Salesrep);
                        //--BSS.IT_3730.WL
                        DailyStatistic.SetRange("Service Center Code", "Service Center");
                        DailyStatistic.SetRange("Source Type", Statistic."Source Type"::"Value Entry");
                        //++BSS.IT_21389.AK
                        //      DailyStatistic.SETRANGE("Position Group",ResourceL."Position Group Code");
                        //      DailyStatistic.SETRANGE("Manufacturer Code",ResourceL."Manufacturer Code");
                        DailyStatistic.SetRange("Position Group", "Position Group Code");
                        DailyStatistic.SetRange("Manufacturer Code", "Manufacturer Code");
                        //--BSS.IT_21389.AK
                        DailyStatistic.SetRange("Payment Type Code", PaymentMethodCode);
                        //++BSS.IT_21389.AK
                        //      DailyStatistic.SETRANGE("Item Category",ResourceL."Item Category Code");
                        //      DailyStatistic.SETRANGE("Product Group",ResourceL."Product Group Code");
                        DailyStatistic.SetRange("Item Category", "Item Category Code");
                        //++BSS.34782.SU
                        //DailyStatistic.SetRange("Product Group", "Product Group Code");
                        //--BSS.34782.SU
                        //--BSS.IT_21389.AK
                        //++BSS.IT_3730.WL
                        TireSetupStatistic.FindFirst;
                        if TireSetupStatistic."Fill Daily Stat. Cust. Fields" then begin
                            if Customer.Get("Source No.") then begin
                                DailyStatistic.SetRange("Customer Group", Customer."Customer Group");
                                DailyStatistic.SetRange("Sell-To Customerno.", "Source No.");
                            end;
                            DailyStatistic.SetRange("Bill-To Customerno.", "Bill-to Customer No.");
                            DailyStatistic.SetRange(Salesperson, "Salespers./Purch. Code");
                            DailyStatistic.SetRange(Salesrep, "Representative Code");
                        end;
                        //--BSS.IT_3730.WL
                        DailyStatistic.SetRange("Posting Date", "Posting Date");
                        if DailyStatistic.Find('-') then begin
                            Number := DailyStatistic."Entry No.";
                            NewRecord := false;
                        end
                        else begin
                            Number := FindNextDailyNumber;
                            DailyStatistic.Init;
                            DailyStatistic."Entry No." := Number;
                            DailyStatistic."Service Center Code" := "Service Center";
                            DailyStatistic."Source Type" := Statistic."Source Type"::"Value Entry";
                            //++BSS.IT_21389.AK
                            //        DailyStatistic."Position Group"    := ResourceL."Position Group Code";
                            DailyStatistic."Position Group" := "Position Group Code";
                            //--BSS.IT_21389.AK
                            //++BSS.IT_4230.MH
                            //++BSS.IT_21389.AK
                            //        DailyStatistic."Main Group" := ResourceL."Main Group Code";
                            //        DailyStatistic."Sub Group" := ResourceL."Sub Group Code";
                            DailyStatistic."Main Group" := "Main Group Code";
                            DailyStatistic."Sub Group" := "Sub Group Code";
                            //--BSS.IT_21389.AK
                            //--BSS.IT_4230.MH
                            //++BSS.IT_21389.AK
                            //        DailyStatistic."Manufacturer Code" := ResourceL."Manufacturer Code";
                            DailyStatistic."Manufacturer Code" := "Manufacturer Code";
                            //--BSS.IT_21389.AK
                            DailyStatistic."Payment Type Code" := PaymentMethodCode;
                            //++BSS.IT_21389.AK
                            //        DailyStatistic."Item Category" := ResourceL."Item Category Code";
                            //        DailyStatistic."Product Group" := ResourceL."Product Group Code";
                            DailyStatistic."Item Category" := "Item Category Code";
                            //++BSS.34782.SU
                            //DailyStatistic."Product Group" := "Product Group Code";
                            //--BSS.34782.SU
                            //--BSS.IT_21389.AK
                            DailyStatistic."Posting Date" := "Posting Date";
                            //++BSS.IT_3730.WL
                            if TireSetupStatistic."Fill Daily Stat. Cust. Fields" then begin
                                if Customer.Get("Source No.") then begin
                                    DailyStatistic."Customer Group" := Customer."Customer Group";
                                    DailyStatistic."Sell-To Customerno." := "Source No.";
                                end;
                                DailyStatistic."Bill-To Customerno." := "Bill-to Customer No.";
                                DailyStatistic.Salesrep := "Representative Code";
                                DailyStatistic.Salesperson := "Salespers./Purch. Code";
                            end;
                            //--BSS.IT_3730.WL
                            NewRecord := true;
                        end;

                        DailyStatistic."Sales Quantity Invoiced" -= Quantity;
                        DailyStatistic."Sales Amount" += "Sales Amount (Actual)";
                        DailyStatistic."Cost Amount" -= "Cost Amount (Actual)";

                        //++BSS.IT_20876.SG
                        UpdateZoneAndDealerDaily(DailyStatistic."Service Center Code", DailyStatistic);
                        //--BS.IT_20876.SG

                        DailyStatistic."Printed On" := 0D;
                        if NewRecord then
                            DailyStatistic.Insert
                        else
                            DailyStatistic.Modify;

                        HistData1.Get("Entry No.");
                        HistData1."Daily Statistic Entry No." := Number;
                        HistData1."Daily Statistic Transfer Date" := Today;
                        HistData1.Modify;
                    end;
                    //++BSS.IT_21389.AK
                    //  END;
                    //++BSS.IT_21389.AK

                end;

                // increase counter and update progress window
                // all 500 records

                Progress += 1;

                //++BSS.IT_4995.MH
                if GuiAllowed then begin
                    //--BSS.IT_4995.MH


                    if (Progress mod ModStep) = 0 then
                        ProgressWindow.Update(2, Round(Progress / Recs * 10000, 1));

                    //++BSS.IT_2848.AP
                    if (Progress mod CommitCounter) = 0 then
                        Commit;
                    //--BSS.IT_2848.AP

                    //--BSS.IT_2768.AP

                    //++BSS.IT_4995.MH
                end;
                //--BSS.IT_4995.MH
            end;

            trigger OnPostDataItem()
            begin
                //++BSS.IT_2768.AP
                if MonthlyCreate or (not "Historic Data") then
                    CurrReport.Break
                else
                    //++BSS.IT_4995.MH
                    if GuiAllowed then
                        //--BSS.IT_4995.MH
                        ProgressWindow.Close;
                //--BSS.IT_2768.AP

                //++BSS.IT_2848.AP
                Commit;
                //--BSS.IT_2848.AP
            end;

            trigger OnPreDataItem()
            begin
                //++BSS.IT_2768.AP
                if not (DailyCreate and ("Historic Data")) then
                    CurrReport.Break;

                // start window

                //++BSS.IT_4995.MH
                if GuiAllowed then
                    //--BSS.IT_4995.MH
                    ProgressWindow.Open(C_BSS_INF006 + '\' +
                                    '#1########## ' + C_BSS_INF008 + '\' +
                                    '@2@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');

                // count records (approximate !!!) and
                // update progress window

                Recs := Count;
                Progress := 0;
                ModStep := Round(Recs / 1000, 1);

                if ModStep = 0 then
                    ModStep := 2;

                //++BSS.IT_4995.MH
                if GuiAllowed then
                    //--BSS.IT_4995.MH
                    ProgressWindow.Update(1, Recs);

                //--BSS.IT_2768.AP
            end;
        }
        dataitem("Monthly Hist. Stat. Raw Data"; "Hist. Stat. Raw Data")
        {
            DataItemTableView = SORTING("Statistic Entry No.") ORDER(Ascending) WHERE("Statistic Entry No." = CONST(0));

            trigger OnAfterGetRecord()
            var
                HistData1: Record "Hist. Stat. Raw Data";
            begin

                //++BSS.IT_2768.AP

                if "Monthly Hist. Stat. Raw Data"."Entry Type" <>
                   "Monthly Hist. Stat. Raw Data"."Entry Type"::Sale then begin
                    HistData1.Get("Entry No.");
                    HistData1."Statistic Entry No." := -1;
                    HistData1."Statistic Transfer Date" := Today;
                    HistData1.Modify;
                end
                else begin
                    Clear(Number);
                    //++BSS.27775.GV
                    PaymentMethodCode := FindPaymentMethodCode1("Document No.", "Posting Date");
                    //--BSS.27775.GV

                    // ---------------------------------------------------------
                    // Items
                    // ---------------------------------------------------------

                    if "Monthly Hist. Stat. Raw Data".Item then begin // start IF item

                        //++BSS.IT_21389.AK
                        //    IF ItemL.GET("Item No.") THEN BEGIN
                        //--BSS.IT_21389.AK
                        Statistic.Reset;
                        Statistic.SetCurrentKey("Service Center", "Source Type", "Position Group",
                          //++BSS.34782.SU
                          //"Manufacturer Code", "Item Category", "Product Group", "Customer Group", "Sell-To Customerno.",
                          "Manufacturer Code", "Item Category", "Customer Group", "Sell-To Customerno.",
                          //--BSS.34782.SU
                          "Bill-To Customerno.", Salesperson, Salesrep, "Posting Period");
                        Statistic.SetRange("Service Center", "Service Center");
                        Statistic.SetRange("Source Type", Statistic."Source Type"::"Value Entry");
                        //++BSS.IT_21389.AK
                        //      Statistic.SETRANGE("Position Group",ItemL."Position Group Code");
                        //      Statistic.SETRANGE("Manufacturer Code",ItemL."Manufacturer Code");
                        //      Statistic.SETRANGE("Item Category",ItemL."Item Category Code");
                        //      Statistic.SETRANGE("Product Group",ItemL."Product Group Code");
                        Statistic.SetRange("Position Group", "Position Group Code");
                        Statistic.SetRange("Manufacturer Code", "Manufacturer Code");
                        Statistic.SetRange("Item Category", "Item Category Code");
                        //++BSS.34782.SU
                        //Statistic.SetRange("Product Group", "Product Group Code");
                        //--BSS.34782.SU
                        //--BSS.IT_21389.AK
                        //++BSS.IT_3730.WL
                        //IF "Source Type" = "Source Type"::Customer THEN BEGIN
                        if Customer.Get("Source No.") then begin
                            Statistic.SetRange("Customer Group", Customer."Customer Group");
                            Statistic.SetRange("Sell-To Customerno.", "Source No.");
                        end;
                        //END;
                        //--BSS.IT_3730.WL

                        //++BSS.IT_2768.AP
                        //Statistic.SETRANGE("Bill-To Customerno.",ItemLedgerEntry."Bill-to Customer No.");
                        Statistic.SetRange("Bill-To Customerno.", "Bill-to Customer No.");
                        //--BSS.IT_2768.AP
                        Statistic.SetRange(Salesperson, "Salespers./Purch. Code");
                        //++BSS.IT_2768.AP
                        //Statistic.SETRANGE(ItemLedgerEntry.Salesrep,"Representative Code");
                        Statistic.SetRange(Salesrep, "Representative Code");
                        //--BSS.IT_2768.AP
                        //++BSS.IT_4230.MH
                        Statistic.SetRange("Additional Data 1",
                          AdditionalDataFunctions.GetFilterValueByHistRawData(1, "Monthly Hist. Stat. Raw Data"));
                        Statistic.SetRange("Additional Data 2",
                          AdditionalDataFunctions.GetFilterValueByHistRawData(2, "Monthly Hist. Stat. Raw Data"));
                        Statistic.SetRange("Additional Data 3",
                          AdditionalDataFunctions.GetFilterValueByHistRawData(3, "Monthly Hist. Stat. Raw Data"));
                        Statistic.SetRange("Additional Data 4",
                          AdditionalDataFunctions.GetFilterValueByHistRawData(4, "Monthly Hist. Stat. Raw Data"));
                        //--BSS.IT_4230.MH
                        Statistic.SetRange("Posting Period", CalcDate('<+CM>', "Posting Date"));

                        if Statistic.Find('-') then begin
                            Number := Statistic."Entry No.";
                            NewRecord := false;
                        end
                        else begin
                            Number := FindNextNumber;
                            Statistic.Init;
                            Statistic."Entry No." := Number;
                            Statistic."Service Center" := "Service Center";
                            Statistic."Source Type" := Statistic."Source Type"::"Value Entry";
                            //++BSS.IT_21389.AK
                            //        Statistic."Position Group" := ItemL."Position Group Code";
                            Statistic."Position Group" := "Position Group Code";
                            //--BSS.IT_21389.AK
                            //++BSS.IT_4230.MH
                            //++BSS.IT_21389.AK
                            //        Statistic."Main Group" := ItemL."Main Group Code";
                            //        Statistic."Sub Group" := ItemL."Sub Group Code";
                            Statistic."Main Group" := "Main Group Code";
                            Statistic."Sub Group" := "Sub Group Code";
                            //--BSS.IT_21389.AK
                            AdditionalDataFunctions.CreateMonthlyDataByHistRawData("Monthly Hist. Stat. Raw Data", Statistic);
                            //--BSS.IT_4230.MH
                            //++BSS.IT_21389.AK
                            //        Statistic."Manufacturer Code" := ItemL."Manufacturer Code";
                            //        Statistic."Item Category" := ItemL."Item Category Code";
                            //        Statistic."Product Group" := ItemL."Product Group Code";
                            Statistic."Manufacturer Code" := "Manufacturer Code";
                            Statistic."Item Category" := "Item Category Code";
                            //++BSS.34782.SU
                            //Statistic."Product Group" := "Product Group Code";
                            //--BSS.34782.SU
                            //--BSS.IT_21389.AK
                            //++BSS.27775.GV
                            Statistic."Payment Type Code" := PaymentMethodCode;
                            //--BSS.27775.GV
                            //++BSS.IT_3730.WL
                            //IF "Source Type" = "Source Type"::Customer THEN BEGIN
                            if Customer.Get("Source No.") then begin
                                Statistic."Customer Group" := Customer."Customer Group";
                                Statistic."Sell-To Customerno." := "Source No.";
                            end;
                            //END;
                            //--BSS.IT_3730.WL

                            Statistic."Bill-To Customerno." := "Bill-to Customer No.";
                            Statistic.Salesrep := "Representative Code";

                            Statistic.Salesperson := "Salespers./Purch. Code";

                            Statistic."Posting Period" := CalcDate('<+CM>', "Posting Date");
                            //++BSS.TFS_11330.GS
                            if Customer.Get("Source No.") then begin
                                Statistic."Sell-to City" := Customer.City;
                                Statistic."Sell-to Post Code" := Customer."Post Code";
                            end;
                            if Customer.Get("Bill-to Customer No.") then begin
                                Statistic."Bill-to City" := Customer.City;
                                Statistic."Bill-to Post Code" := Customer."Post Code";
                            end;
                            Statistic."Local Currency Code" := GLSetup."LCY Code";
                            //--BSS.TFS_11330.GS
                            NewRecord := true;
                        end;

                        //++BSS.IT_2768.AP
                        Statistic."SalesValue (CB)" -= ("CB-Price" * Quantity);
                        Statistic."Sales Quantity Invoiced" -= Quantity;
                        Statistic."Sales Amount" += "Sales Amount (Actual)";
                        Statistic."Cost Amount (Expected)" -= "Cost Amount (Expected)";
                        //--BSS.IT_2768.AP

                        Statistic."Cost Amount" -= "Cost Amount (Actual)";

                        //++BSS.IT_20876.SG
                        UpdateZoneAndDealerMonthly(Statistic."Service Center", Statistic);
                        //--BS.IT_20876.SG

                        if NewRecord then
                            Statistic.Insert
                        else
                            Statistic.Modify;

                        HistData1.Get("Entry No.");
                        HistData1."Statistic Entry No." := Number;
                        HistData1."Statistic Transfer Date" := Today;
                        HistData1.Modify;
                        //++BSS.IT_21389.AK
                        //    END
                        //--BSS.IT_21389.AK
                    end // end IF item
                    else begin

                        // ---------------------------------------------------------
                        // resources
                        // ---------------------------------------------------------

                        //++BSS.IT_21389.AK
                        //    IF ResourceL.GET("Item No.") THEN BEGIN
                        //--BSS.IT_21389.AK
                        Statistic.Reset;
                        Statistic.SetCurrentKey("Service Center", "Source Type", "Position Group",
                          //++BSS.34782.SU
                          //"Manufacturer Code", "Item Category", "Product Group", "Customer Group", "Sell-To Customerno.",
                          "Manufacturer Code", "Item Category", "Customer Group", "Sell-To Customerno.",
                          //--BSS.34782.SU
                          "Bill-To Customerno.", Salesperson, Salesrep, "Posting Period");
                        Statistic.SetRange("Service Center", "Service Center");
                        Statistic.SetRange("Source Type", Statistic."Source Type"::"Value Entry");
                        //++BSS.IT_21389.AK
                        //      Statistic.SETRANGE("Position Group",ResourceL."Position Group Code");
                        //      Statistic.SETRANGE("Manufacturer Code",ResourceL."Manufacturer Code");
                        //      Statistic.SETRANGE("Item Category",ResourceL."Item Category Code");
                        //      Statistic.SETRANGE("Product Group",ResourceL."Product Group Code");
                        Statistic.SetRange("Position Group", "Position Group Code");
                        Statistic.SetRange("Manufacturer Code", "Manufacturer Code");
                        Statistic.SetRange("Item Category", "Item Category Code");
                        //++BSS.34782.SU
                        //Statistic.SetRange("Product Group", "Product Group Code");
                        //--BSS.34782.SU
                        //--BSS.IT_21389.AK
                        //++BSS.IT_3730.WL
                        //IF "Source Type" = "Source Type"::Customer THEN BEGIN
                        if Customer.Get("Source No.") then begin
                            Statistic.SetRange("Customer Group", Customer."Customer Group");
                            Statistic.SetRange("Sell-To Customerno.", "Source No.");
                        end;
                        //END;
                        //--BSS.IT_3730.WL

                        //++BSS.IT_2768.AP
                        //Statistic.SETRANGE("Bill-To Customerno.",ItemLedgerEntry."Bill-to Customer No.");
                        Statistic.SetRange("Bill-To Customerno.", "Bill-to Customer No.");
                        //--BSS.IT_2768.AP
                        Statistic.SetRange(Salesperson, "Salespers./Purch. Code");
                        //++BSS.IT_2768.AP
                        //Statistic.SETRANGE(ItemLedgerEntry.Salesrep,"Representative Code");
                        Statistic.SetRange(Salesrep, "Representative Code");
                        //--BSS.IT_2768.AP
                        Statistic.SetRange("Posting Period", CalcDate('<+CM>', "Posting Date"));

                        if Statistic.Find('-') then begin
                            Number := Statistic."Entry No.";
                            NewRecord := false;
                        end
                        else begin
                            Number := FindNextNumber;
                            Statistic.Init;
                            Statistic."Entry No." := Number;
                            Statistic."Service Center" := "Service Center";
                            Statistic."Source Type" := Statistic."Source Type"::"Value Entry";
                            //++BSS.IT_21389.AK
                            //        Statistic."Position Group" := ResourceL."Position Group Code";
                            Statistic."Position Group" := "Position Group Code";
                            //--BSS.IT_21389.AK
                            //++BSS.IT_4230.MH
                            //++BSS.IT_21389.AK
                            //        Statistic."Main Group" := ResourceL."Main Group Code";
                            //        Statistic."Sub Group" := ResourceL."Sub Group Code";
                            Statistic."Main Group" := "Main Group Code";
                            Statistic."Sub Group" := "Sub Group Code";
                            //--BSS.IT_21389.AK
                            //--BSS.IT_4230.MH
                            //++BSS.IT_21389.AK
                            //        Statistic."Manufacturer Code" := ResourceL."Manufacturer Code";
                            //        Statistic."Item Category" := ResourceL."Item Category Code";
                            //        Statistic."Product Group" := ResourceL."Product Group Code";
                            Statistic."Manufacturer Code" := "Manufacturer Code";
                            Statistic."Item Category" := "Item Category Code";
                            //++BSS.34782.SU
                            //Statistic."Product Group" := "Product Group Code";
                            //--BSS.34782.SU
                            //--BSS.IT_21389.AK
                            //++BSS.27775.GV
                            Statistic."Payment Type Code" := PaymentMethodCode;
                            //--BSS.27775.GV
                            //++BSS.IT_3730.WL
                            //IF "Source Type" = "Source Type"::Customer THEN BEGIN
                            if Customer.Get("Source No.") then begin
                                Statistic."Customer Group" := Customer."Customer Group";
                                Statistic."Sell-To Customerno." := "Source No.";
                            end;
                            //END;
                            //--BSS.IT_3730.WL

                            Statistic."Bill-To Customerno." := "Bill-to Customer No.";
                            Statistic.Salesrep := "Representative Code";

                            Statistic.Salesperson := "Salespers./Purch. Code";

                            Statistic."Posting Period" := CalcDate('<+CM>', "Posting Date");
                            NewRecord := true;
                        end;

                        //++BSS.IT_2768.AP
                        Statistic."SalesValue (CB)" -= ("CB-Price" * Quantity);
                        Statistic."Sales Quantity Invoiced" -= Quantity;
                        Statistic."Sales Amount" += "Sales Amount (Actual)";
                        Statistic."Cost Amount (Expected)" -= "Cost Amount (Expected)";
                        //--BSS.IT_2768.AP

                        Statistic."Cost Amount" -= "Cost Amount (Actual)";

                        //++BSS.IT_20876.SG
                        UpdateZoneAndDealerMonthly(Statistic."Service Center", Statistic);
                        //--BS.IT_20876.SG

                        if NewRecord then
                            Statistic.Insert
                        else
                            Statistic.Modify;

                        HistData1.Get("Entry No.");
                        HistData1."Statistic Entry No." := Number;
                        HistData1."Statistic Transfer Date" := Today;
                        HistData1.Modify;
                    end;
                    //++BSS.IT_21389.AK
                    //  END;
                    //--BSS.IT_21389.AK

                end;

                // increase counter and update progress window
                // all 500 records

                Progress += 1;

                //++BSS.IT_4995.MH
                if GuiAllowed then begin
                    //--BSS.IT_4995.MH

                    if (Progress mod ModStep) = 0 then
                        ProgressWindow.Update(2, Round(Progress / Recs * 10000, 1));

                    //++BSS.IT_2848.AP
                    if (Progress mod CommitCounter) = 0 then
                        Commit;
                    //--BSS.IT_2848.AP

                    //--BSS.IT_2768.AP
                    //++BSS.IT_4995.MH
                end;
                //--BSS.IT_4995.MH
            end;

            trigger OnPostDataItem()
            begin
                //++BSS.IT_2768.AP
                if DailyCreate or (not "Historic Data") then
                    CurrReport.Break
                else
                    //++BSS.IT_4995.MH
                    if GuiAllowed then
                        //--BSS.IT_4995.MH
                        ProgressWindow.Close;
                //--BSS.IT_2768.AP

                //++BSS.IT_2848.AP
                Commit;
                //--BSS.IT_2848.AP
            end;

            trigger OnPreDataItem()
            begin
                //++BSS.IT_2768.AP
                if not (MonthlyCreate and ("Historic Data")) then
                    CurrReport.Break;

                // start window

                //++BSS.IT_4995.MH
                if GuiAllowed then
                    //--BSS.IT_4995.MH
                    ProgressWindow.Open(C_BSS_INF007 + '\' +
                                    '#1########## ' + C_BSS_INF008 + '\' +
                                    '@2@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');

                // count records (approximate !!!) and
                // update progress window

                Recs := Count;
                Progress := 0;
                ModStep := Round(Recs / 1000, 1);

                if ModStep = 0 then
                    ModStep := 2;

                //++BSS.IT_4995.MH
                if GuiAllowed then
                    //--BSS.IT_4995.MH
                    ProgressWindow.Update(1, Recs);

                //--BSS.IT_2768.AP
            end;
        }
        dataitem("Sales Invoice Header"; "Sales Invoice Header")
        {
            DataItemTableView = SORTING("No.") ORDER(Ascending);

            trigger OnAfterGetRecord()
            var
                SalesInvoiceHeader1: Record "Sales Invoice Header";
                VehicleStatisticEntry: Record "Vehicle Statistic Entry";
                Vehicle: Record Vehicle;
            begin
                //++BSS.TFS_11330.GS
                if "Veh. Statistic Entry No." <> 0 then
                    CurrReport.Skip;

                if "Vehicle No." = '' then begin
                    SalesInvoiceHeader1.Get("No.");
                    SalesInvoiceHeader1."Veh. Statistic Entry No." := -1;
                    SalesInvoiceHeader1."Veh. Statistic Transfer Date" := Today;
                    SalesInvoiceHeader1.Modify;
                end
                else begin
                    CalcFields("Vehicle Manufacturer", "Vehicle Model", "Vehicle Variant");
                    VehicleStatisticEntry.Init;
                    VehicleStatisticEntry."Entry No." := FindNextVehNumber;
                    VehicleStatisticEntry."Service Center Code" := "Service Center";
                    VehicleStatisticEntry."Posting Date" := "Posting Date";
                    VehicleStatisticEntry."Sales Invoice No." := "No.";
                    VehicleStatisticEntry."Vehicle Manufacturer" := "Vehicle Manufacturer";
                    VehicleStatisticEntry."Vehicle Model" := "Vehicle Model";
                    VehicleStatisticEntry."Vehicle Variant" := "Vehicle Variant";
                    VehicleStatisticEntry.Mileage := Mileage;
                    if Vehicle.Get("Vehicle No.") then begin
                        VehicleStatisticEntry."Registration Date" := Vehicle."Registration Date";
                        if VehicleStatisticEntry."Posting Date" > VehicleStatisticEntry."Registration Date" then
                            VehicleStatisticEntry."Age (Years)" := GetAgeYears(VehicleStatisticEntry."Posting Date", VehicleStatisticEntry."Registration Date");
                    end;
                    VehicleStatisticEntry."Turnover Parts" := GetTurnoverParts("Sales Invoice Header");
                    VehicleStatisticEntry."Turnover Services" := GetTurnoverServices("Sales Invoice Header");
                    VehicleStatisticEntry."Turnover Misc." := GetTurnoverMisc("Sales Invoice Header");
                    VehicleStatisticEntry."Service Reminder" := "Notif. Reminder Sent";

                    UpdateZoneAndDealerVehicle(VehicleStatisticEntry."Service Center Code", VehicleStatisticEntry);
                    VehicleStatisticEntry.Insert;

                    SalesInvoiceHeader1.Get("No.");
                    SalesInvoiceHeader1."Veh. Statistic Entry No." := VehicleStatisticEntry."Entry No.";
                    SalesInvoiceHeader1."Veh. Statistic Transfer Date" := Today;
                    SalesInvoiceHeader1.Modify;
                end;
                //--BSS.TFS_11330.GS
            end;

            trigger OnPostDataItem()
            begin
                //++BSS.TFS_11330.GS
                Commit;
                //--BSS.TFS_11330.GS
            end;

            trigger OnPreDataItem()
            begin
                //++BSS.TFS_11330.GS
                if not FastfitSetupStatistic."Create Veh. Statistic Entries" then
                    CurrReport.Break;
                //--BSS.TFS_11330.GS
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(DailyCreate; DailyCreate)
                    {
                        Caption = 'Create Daily Statistics';
                    }
                    field(MonthlyCreate; MonthlyCreate)
                    {
                        Caption = 'Create Monthly Statistics';
                    }
                    field(CheckServiceCenter; CheckServiceCenter)
                    {
                        Caption = 'Service Center Check';
                    }
                    field("Historic Data"; "Historic Data")
                    {
                        Caption = 'Historic Data';
                    }
                    field(DailyCompleteClear; DailyCompleteClear)
                    {
                        Caption = 'Delete Daily Statistics';
                        Visible = false;
                    }
                    field(MonthlyCompleteClear; MonthlyCompleteClear)
                    {
                        Caption = 'Delete Statistics';
                        Visible = false;
                    }
                    field(UpdatePerformanceBufferP; UpdatePerformanceBufferP)
                    {
                        Caption = 'Update Performance Buffer';
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

    trigger OnInitReport()
    begin
        //++BSS.IT_20876.SG
        if CheckZoneAndDealerDimension() then
            CurrReport.Quit;
        //--BSS.IT_20876.SG

        //++BSS.IT_2768.AP
        DailyCompleteClear := false;
        MonthlyCompleteClear := false;
        //--BSS.IT_2768.AP

        //++BSS.IT_2940.SK
        DailyCreate := true;
        MonthlyCreate := true;
        //--BSS.IT_2940.SK

        //++BSS.IT_2848.AP
        CommitCounter := 10000;
        //--BSS.IT_2848.AP

        //++BSS.TFS_11330.GS
        UpdatePerformanceBufferP := true;
        FastfitSetupStatistic.Get;
        //--BSS.TFS_11330.GS
    end;

    trigger OnPreReport()
    begin
        //++RGS_TWN-756.QX
        IF CURRENTCLIENTTYPE = CLIENTTYPE::Management THEN BEGIN
            DailyCreate := TRUE;
            MonthlyCreate := TRUE;
            UpdatePerformanceBufferP := false;
        END;
        OnBeforePreReport(DailyCreate, MonthlyCreate, CheckServiceCenter, "Historic Data", UpdatePerformanceBufferP);
        //--RGS_TWN-756.QX
        //++BSS.IT_2768.AP
        /* removed °2768
        IF DailyCompleteClear THEN BEGIN
         PreResLedgerEntry1.RESET;
         PreResLedgerEntry1.SETCURRENTKEY("Daily Statistic Entry No.");
         PreResLedgerEntry1.SETFILTER("Daily Statistic Entry No.",'<>%1',0);
         PreResLedgerEntry1.MODIFYALL("Daily Statistic Entry No.",0);
         PreResLedgerEntry1.MODIFYALL("Daily Statistic Transfer Date",0D);
        
         ValueEntry1.RESET;
         ValueEntry1.SETCURRENTKEY("Daily Statistic Entry No.");
         ValueEntry1.SETFILTER("Daily Statistic Entry No.",'<>%1',0);
         ValueEntry1.MODIFYALL("Daily Statistic Entry No.",0);
         ValueEntry1.MODIFYALL("Daily Statistic Transfer Date",0D);
        
         ResLedgerEntry1.RESET;
         ResLedgerEntry1.SETCURRENTKEY("Daily Statistic Entry No.");
         ResLedgerEntry1.SETFILTER("Daily Statistic Entry No.",'<>%1',0);
         ResLedgerEntry1.MODIFYALL("Daily Statistic Entry No.",0);
         ResLedgerEntry1.MODIFYALL("Daily Statistic Transfer Date",0D);
        
        
         DailyStatistic.RESET;
         DailyStatistic.DELETEALL;
         COMMIT;
        END;
        
        IF MonthlyCompleteClear THEN BEGIN
         PreResLedgerEntry1.RESET;
         PreResLedgerEntry1.SETCURRENTKEY("Statistic Entry No.");
         PreResLedgerEntry1.SETFILTER("Statistic Entry No.",'<>%1',0);
         PreResLedgerEntry1.MODIFYALL("Statistic Entry No.",0);
         PreResLedgerEntry1.MODIFYALL("Statistic Transfer Date",0D);
        
         ValueEntry1.RESET;
         ValueEntry1.SETCURRENTKEY("Statistic Entry No.");
         ValueEntry1.SETFILTER("Statistic Entry No.",'<>%1',0);
         ValueEntry1.MODIFYALL("Statistic Entry No.",0);
         ValueEntry1.MODIFYALL("Statistic Transfer Date",0D);
        
         ResLedgerEntry1.RESET;
         ResLedgerEntry1.SETCURRENTKEY("Statistic Entry No.");
         ResLedgerEntry1.SETFILTER("Statistic Entry No.",'<>%1',0);
         ResLedgerEntry1.MODIFYALL("Statistic Entry No.",0);
         ResLedgerEntry1.MODIFYALL("Statistic Transfer Date",0D);
        
         Statistic.RESET;
         Statistic.DELETEALL;
         COMMIT;
        END;
        */
        //--BSS.IT_2768.AP

        //++BSS.TFS_11330.GS
        if UpdatePerformanceBufferP then begin
            UpdatePerformanceBufferReport.UseRequestPage := false;
            UpdatePerformanceBufferReport.RunModal;
        end;
        GLSetup.Get;
        //--BSS.TFS_11330.GS

    end;

    var
        ResLedgerEntry1: Record "Res. Ledger Entry";
        PreResLedgerEntry1: Record "Pre. Res. Ledger Entry";
        ValueEntry1: Record "Value Entry";
        DailyStatistic: Record "Daily Statistic Entry";
        Statistic: Record "Monthly Statistic Entry";
        Item: Record Item;
        Customer: Record Customer;
        ItemLedgerEntry: Record "Item Ledger Entry";
        TireSetupStatistic: Record "Fastfit Setup - Statistic";
        PaymentMethodCode: Code[10];
        Number: Integer;
        DailyCompleteClear: Boolean;
        MonthlyCompleteClear: Boolean;
        DailyCreate: Boolean;
        MonthlyCreate: Boolean;
        NewRecord: Boolean;
        ProgressWindow: Dialog;
        C_BSS_INF001: Label 'Create Daily Statistics';
        C_BSS_INF002: Label 'Create Monthly Statistics';
        C_BSS_INF003: Label 'Check Value Entries';
        C_BSS_INF004: Label 'Check Resource Entries';
        C_BSS_INF005: Label 'Check Pre Resource Entries';
        Recs: Integer;
        Progress: Integer;
        "Historic Data": Boolean;
        ModStep: Integer;
        CommitCounter: Integer;
        C_BSS_INF006: Label 'Create historical Daily Statistics';
        C_BSS_INF007: Label 'Create historical Monthly Statistics';
        C_BSS_INF008: Label 'records';
        C_BSS_INF009: Label 'Check G/L Entries';
        AdditionalDataFunctions: Codeunit "Statistic Fill Additional Data";
        ItemVariant: Record "Item Variant";
        C_BSS_INF010: Label 'Check Service Center';

        C_BSS_ERR001: Label 'Following SC(s) have no Zone or Dealer Dimension:\\%1';
        CheckServiceCenter: Boolean;
        UpdatePerformanceBufferP: Boolean;
        UpdatePerformanceBufferReport: Report "Update Performance Buffer";
        GLSetup: Record "General Ledger Setup";
        FastfitSetupStatistic: Record "Fastfit Setup - Statistic";

    [Scope('OnPrem')]
    procedure FindNextDailyNumber() Number: Integer
    var
        lo_DailyStatistic: Record "Daily Statistic Entry";
    begin
        lo_DailyStatistic.Reset;
        if lo_DailyStatistic.Find('+') then
            Number := lo_DailyStatistic."Entry No." + 1
        else
            Number := 1;
    end;

    [Scope('OnPrem')]
    procedure FindNextNumber() Number: Integer
    var
        lo_Statistic: Record "Monthly Statistic Entry";
    begin
        lo_Statistic.Reset;
        if lo_Statistic.Find('+') then
            Number := lo_Statistic."Entry No." + 1
        else
            Number := 1;
    end;

    [Scope('OnPrem')]
    procedure FindPaymentMethodCode("DocNo.": Code[20]; PostDate: Date) PayMethodCode: Code[10]
    var
        lo_SalesInvoiceHeader: Record "Sales Invoice Header";
        lo_SalesCrMemoHeader: Record "Sales Cr.Memo Header";
        lo_SalesShipmentHeader: Record "Sales Shipment Header";
    begin
        Clear(PayMethodCode);
        lo_SalesShipmentHeader.Reset;
        lo_SalesShipmentHeader.SetCurrentKey("Order No.");
        lo_SalesShipmentHeader.SetRange("Order No.", "DocNo.");
        lo_SalesShipmentHeader.SetRange("Posting Date", PostDate);
        if lo_SalesShipmentHeader.Find('-') then begin
            PayMethodCode := lo_SalesShipmentHeader."Payment Method Code";
        end
        else begin
            lo_SalesInvoiceHeader.Reset;
            lo_SalesInvoiceHeader.SetCurrentKey("Order No.");
            lo_SalesInvoiceHeader.SetRange("Order No.", "DocNo.");
            lo_SalesInvoiceHeader.SetRange("Posting Date", PostDate);
            if lo_SalesInvoiceHeader.Find('-') then begin
                PayMethodCode := lo_SalesInvoiceHeader."Payment Method Code";
            end
            else begin
                lo_SalesCrMemoHeader.Reset;
                lo_SalesCrMemoHeader.SetCurrentKey("Pre-Assigned No.");
                lo_SalesCrMemoHeader.SetRange("Pre-Assigned No.", "DocNo.");
                lo_SalesCrMemoHeader.SetRange("Posting Date", PostDate);
                if lo_SalesCrMemoHeader.Find('-') then begin
                    PayMethodCode := lo_SalesCrMemoHeader."Payment Method Code";
                end;
            end;
        end;
    end;

    [Scope('OnPrem')]
    procedure FindPaymentMethodCode1("DocNo.": Code[20]; PostDate: Date) PayMethodCode: Code[10]
    var
        lo_SalesInvoiceHeader: Record "Sales Invoice Header";
        lo_SalesCrMemoHeader: Record "Sales Cr.Memo Header";
        lo_SalesShipmentHeader: Record "Sales Shipment Header";
    begin
        Clear(PayMethodCode);
        lo_SalesShipmentHeader.Reset;
        lo_SalesShipmentHeader.SetRange("No.", "DocNo.");
        lo_SalesShipmentHeader.SetRange("Posting Date", PostDate);
        if lo_SalesShipmentHeader.Find('-') then begin
            PayMethodCode := lo_SalesShipmentHeader."Payment Method Code";
        end
        else begin
            lo_SalesInvoiceHeader.Reset;
            lo_SalesInvoiceHeader.SetRange("No.", "DocNo.");
            lo_SalesInvoiceHeader.SetRange("Posting Date", PostDate);
            if lo_SalesInvoiceHeader.Find('-') then begin
                PayMethodCode := lo_SalesInvoiceHeader."Payment Method Code";
            end
            else begin
                lo_SalesCrMemoHeader.Reset;
                lo_SalesCrMemoHeader.SetRange("No.", "DocNo.");
                lo_SalesCrMemoHeader.SetRange("Posting Date", PostDate);
                if lo_SalesCrMemoHeader.Find('-') then begin
                    PayMethodCode := lo_SalesCrMemoHeader."Payment Method Code";
                end;
            end;
        end;
    end;

    [Scope('OnPrem')]
    procedure UpdateProgress(LineNo: Integer)
    var
        Step: Integer;
    begin
        //++BSS.IT_4995.MH
        if GuiAllowed then begin
            //--BSS.IT_4995.MH

            //++BSS.IT_301.SK
            Progress += 1;

            Step := Round(Recs / 10000, 1);
            if Step = 0 then
                Step := 1;

            if Recs = 0 then
                ProgressWindow.Update(LineNo, Round(10000, 1))
            else
                if (Progress mod Step = 0) then
                    ProgressWindow.Update(LineNo, Round(Progress / Recs * 10000, 1));
            //--BSS.IT_301.SK

            //++BSS.IT_2848.AP
            if (Progress mod CommitCounter) = 0 then
                Commit;
            //--BSS.IT_2848.AP
            //++BSS.IT_4995.MH
        end;
        //--BSS.IT_4995.MH
    end;

    local procedure GetServiceCenter(DocumentNoP: Code[20]; ItemResourceNoP: Code[20]; GlobalDimensionCode1P: Code[20]; GlobalDimensionCode2P: Code[20]): Code[10]
    var
        ServiceCenterL: Record "Service Center";
        ServiceCenterCodeL: Code[10];
    begin
        //++BSS.IT_21595.CM

        if ServiceCenterL.Get(GlobalDimensionCode1P) then
            exit(ServiceCenterL.Code);

        if ServiceCenterL.Get(GlobalDimensionCode2P) then
            exit(ServiceCenterL.Code);

        ServiceCenterCodeL := GetServiceCenterFromPostedDocuments(DocumentNoP, ItemResourceNoP);
        if ServiceCenterCodeL <> '' then
            exit(ServiceCenterCodeL);

        ServiceCenterCodeL := GetServiceCenterFromUnpostedDocuments(DocumentNoP, ItemResourceNoP);
        if ServiceCenterCodeL <> '' then
            exit(ServiceCenterCodeL);

        //--BSS.IT_21595.CM
    end;

    local procedure GetServiceCenterFromPostedDocuments(DocumentNoP: Code[20]; ItemResourceNoP: Code[20]): Code[10]
    var
        ServiceCenterL: Record "Service Center";
        LocationL: Record Location;
        SalesInvoiceHeaderL: Record "Sales Invoice Header";
        SalesInvoiceLineL: Record "Sales Invoice Line";
        SalesCrMemoHeaderL: Record "Sales Cr.Memo Header";
        SalesCrMemoLineL: Record "Sales Cr.Memo Line";
        PurchaseInvoiceHeaderL: Record "Purch. Inv. Header";
        PurchaseInvoiceLineL: Record "Purch. Inv. Line";
        PurchaseCrMemoHeaderL: Record "Purch. Cr. Memo Hdr.";
        PurchaseCrMemoLineL: Record "Purch. Cr. Memo Line";
    begin
        //++BSS.IT_21595.CM
        if SalesInvoiceHeaderL.Get(DocumentNoP) then begin

            SalesInvoiceLineL.SetRange("Document No.", DocumentNoP);
            SalesInvoiceLineL.SetRange("No.", ItemResourceNoP);
            if SalesInvoiceLineL.FindFirst then begin
                if ServiceCenterL.Get(SalesInvoiceLineL."Service Center") then
                    exit(ServiceCenterL.Code);

                if LocationL.Get(SalesInvoiceLineL."Location Code") then
                    if ServiceCenterL.Get(LocationL."Service Center") then
                        exit(ServiceCenterL.Code);
            end;

            if ServiceCenterL.Get(SalesInvoiceHeaderL."Service Center") then
                exit(ServiceCenterL.Code);

            if LocationL.Get(SalesInvoiceHeaderL."Location Code") then
                if ServiceCenterL.Get(LocationL."Service Center") then
                    exit(ServiceCenterL.Code);

        end;

        if SalesCrMemoHeaderL.Get(DocumentNoP) then begin

            SalesCrMemoLineL.SetRange("Document No.", DocumentNoP);
            SalesCrMemoLineL.SetRange("No.", ItemResourceNoP);
            if SalesCrMemoLineL.FindFirst then begin
                if ServiceCenterL.Get(SalesCrMemoLineL."Service Center") then
                    exit(ServiceCenterL.Code);

                if LocationL.Get(SalesCrMemoLineL."Location Code") then
                    if ServiceCenterL.Get(LocationL."Service Center") then
                        exit(ServiceCenterL.Code);
            end;

            if ServiceCenterL.Get(SalesCrMemoHeaderL."Service Center") then
                exit(ServiceCenterL.Code);

            if LocationL.Get(SalesCrMemoHeaderL."Location Code") then
                if ServiceCenterL.Get(LocationL."Service Center") then
                    exit(ServiceCenterL.Code);

        end;

        if PurchaseInvoiceHeaderL.Get(DocumentNoP) then begin

            PurchaseInvoiceLineL.SetRange("Document No.", DocumentNoP);
            PurchaseInvoiceLineL.SetRange("No.", ItemResourceNoP);
            if PurchaseInvoiceLineL.FindFirst then begin
                if ServiceCenterL.Get(PurchaseInvoiceLineL."Service Center") then
                    exit(ServiceCenterL.Code);

                if LocationL.Get(PurchaseInvoiceLineL."Location Code") then
                    if ServiceCenterL.Get(LocationL."Service Center") then
                        exit(ServiceCenterL.Code);
            end;

            if ServiceCenterL.Get(PurchaseInvoiceHeaderL."Service Center") then
                exit(ServiceCenterL.Code);

            if LocationL.Get(PurchaseInvoiceHeaderL."Location Code") then
                if ServiceCenterL.Get(LocationL."Service Center") then
                    exit(ServiceCenterL.Code);

        end;

        if PurchaseCrMemoHeaderL.Get(DocumentNoP) then begin

            PurchaseCrMemoLineL.SetRange("Document No.", DocumentNoP);
            PurchaseCrMemoLineL.SetRange("No.", ItemResourceNoP);
            if PurchaseCrMemoLineL.FindFirst then begin
                if ServiceCenterL.Get(PurchaseCrMemoLineL."Service Center") then
                    exit(ServiceCenterL.Code);

                if LocationL.Get(PurchaseCrMemoLineL."Location Code") then
                    if ServiceCenterL.Get(LocationL."Service Center") then
                        exit(ServiceCenterL.Code);
            end;

            if ServiceCenterL.Get(PurchaseCrMemoHeaderL."Service Center") then
                exit(ServiceCenterL.Code);

            if LocationL.Get(PurchaseCrMemoHeaderL."Location Code") then
                if ServiceCenterL.Get(LocationL."Service Center") then
                    exit(ServiceCenterL.Code);

        end;
        //--BSS.IT_21595.CM
    end;

    local procedure GetServiceCenterFromUnpostedDocuments(DocumentNoP: Code[20]; ItemResourceNoP: Code[20]): Code[10]
    var
        ServiceCenterL: Record "Service Center";
        LocationL: Record Location;
        SalesHeaderL: Record "Sales Header";
        SalesLineL: Record "Sales Line";
        PurchaseHeaderL: Record "Purchase Header";
        PurchaseLineL: Record "Purchase Line";
    begin
        //++BSS.IT_21595.CM
        SalesHeaderL.SetRange("No.", DocumentNoP);
        if SalesHeaderL.FindFirst then begin

            SalesLineL.SetRange("Document No.", DocumentNoP);
            SalesLineL.SetRange("No.", ItemResourceNoP);
            if SalesLineL.FindFirst then begin
                if ServiceCenterL.Get(SalesLineL."Service Center") then
                    exit(ServiceCenterL.Code);

                if LocationL.Get(SalesLineL."Location Code") then
                    if ServiceCenterL.Get(LocationL."Service Center") then
                        exit(ServiceCenterL.Code);
            end;

            if ServiceCenterL.Get(SalesHeaderL."Service Center") then
                exit(ServiceCenterL.Code);

            if LocationL.Get(SalesHeaderL."Location Code") then
                if ServiceCenterL.Get(LocationL."Service Center") then
                    exit(ServiceCenterL.Code);

        end;

        PurchaseHeaderL.SetRange("No.", DocumentNoP);
        if PurchaseHeaderL.FindFirst then begin

            PurchaseLineL.SetRange("Document No.", DocumentNoP);
            PurchaseLineL.SetRange("No.", ItemResourceNoP);
            if PurchaseLineL.FindFirst then begin
                if ServiceCenterL.Get(PurchaseLineL."Service Center") then
                    exit(ServiceCenterL.Code);

                if LocationL.Get(PurchaseLineL."Location Code") then
                    if ServiceCenterL.Get(LocationL."Service Center") then
                        exit(ServiceCenterL.Code);
            end;

            if ServiceCenterL.Get(PurchaseHeaderL."Service Center") then
                exit(ServiceCenterL.Code);

            if LocationL.Get(PurchaseHeaderL."Location Code") then
                if ServiceCenterL.Get(LocationL."Service Center") then
                    exit(ServiceCenterL.Code);

        end;
        //--BSS.IT_21595.CM
    end;

    local procedure ___MARS___()
    begin
    end;

    [Scope('OnPrem')]
    procedure UpdateZoneAndDealerDaily(ServCenterCodeP: Code[20]; var DailyStatEntryP: Record "Daily Statistic Entry")
    var
        ServCenterL: Record "Service Center";
    begin
        //++BSS.IT_20876.SG
        ServCenterL.Get(ServCenterCodeP);
        DailyStatEntryP."Zone Code" := ServCenterL."Zone Dimension Value";
        DailyStatEntryP."Dealer Code" := ServCenterL."Dealer Dimension Value";
        //--BSS.IT_20876.SG
    end;

    [Scope('OnPrem')]
    procedure UpdateZoneAndDealerMonthly(ServCenterCodeP: Code[20]; var MonthlyStatEntryP: Record "Monthly Statistic Entry")
    var
        ServCenterL: Record "Service Center";
    begin
        //++BSS.IT_20876.SG
        ServCenterL.Get(ServCenterCodeP);
        MonthlyStatEntryP."Zone Code" := ServCenterL."Zone Dimension Value";
        MonthlyStatEntryP."Dealer Code" := ServCenterL."Dealer Dimension Value";
        //--BSS.IT_20876.SG
    end;

    [Scope('OnPrem')]
    procedure CheckZoneAndDealerDimension() HasBeenError: Boolean
    var
        ServCenterL: Record "Service Center";
        ErrorText: Text[1024];
    begin
        //++BSS.IT_20876.SG
        ServCenterL.SetRange("Central Maintenance", false);
        ServCenterL.FindFirst;
        repeat

            if (ServCenterL."Zone Dimension" = '') or
               (ServCenterL."Zone Dimension Value" = '') or
               (ServCenterL."Dealer Dimension" = '') or
               (ServCenterL."Dealer Dimension Value" = '') then begin
                ErrorText += ServCenterL.Code + ' ';
                HasBeenError := true;
            end;

        until ServCenterL.Next = 0;

        if HasBeenError then
            Error(C_BSS_ERR001, ErrorText);

        exit(HasBeenError);
        //--BSS.IT_20876.SG
    end;

    [Scope('OnPrem')]
    procedure FindNextVehNumber() Number: Integer
    var
        VehicleStatisticEntryL: Record "Vehicle Statistic Entry";
    begin
        //++BSS.TFS_11330.GS
        VehicleStatisticEntryL.Reset;
        if VehicleStatisticEntryL.FindLast then
            Number := VehicleStatisticEntryL."Entry No." + 1
        else
            Number := 1;
        //--BSS.TFS_11330.GS
    end;

    [Scope('OnPrem')]
    procedure UpdateZoneAndDealerVehicle(ServCenterCodeP: Code[20]; var VehicleStatisticEntryP: Record "Vehicle Statistic Entry")
    var
        ServCenterL: Record "Service Center";
    begin
        //++BSS.TFS_11330.GS
        ServCenterL.Get(ServCenterCodeP);
        VehicleStatisticEntryP."Zone Code" := ServCenterL."Zone Dimension Value";
        VehicleStatisticEntryP."Dealer Code" := ServCenterL."Dealer Dimension Value";
        //--BSS.TFS_11330.GS
    end;

    local procedure GetTurnoverParts(SIH: Record "Sales Invoice Header") TotalR: Decimal
    var
        ValueEntryL: Record "Value Entry";
    begin
        //++BSS.TFS_11330.GS
        ValueEntryL.Reset;
        ValueEntryL.SetCurrentKey("Document No.", "Posting Date");
        ValueEntryL.SetRange("Document No.", SIH."No.");
        ValueEntryL.SetRange("Posting Date", SIH."Posting Date");
        if ValueEntryL.FindSet then
            repeat
                TotalR += ValueEntryL."Sales Amount (Actual)";
            until ValueEntryL.Next = 0;
        //--BSS.TFS_11330.GS
    end;

    local procedure GetTurnoverServices(SIH: Record "Sales Invoice Header") TotalR: Decimal
    var
        ResLedgerEntryL: Record "Res. Ledger Entry";
    begin
        //++BSS.TFS_11330.GS
        ResLedgerEntryL.Reset;
        ResLedgerEntryL.SetCurrentKey("Document No.", "Posting Date");
        ResLedgerEntryL.SetRange("Document No.", SIH."No.");
        ResLedgerEntryL.SetRange("Posting Date", SIH."Posting Date");
        if ResLedgerEntryL.FindSet then
            repeat
                TotalR += -ResLedgerEntryL."Total Price";
            until ResLedgerEntryL.Next = 0;
        //--BSS.TFS_11330.GS
    end;

    local procedure GetTurnoverMisc(SIH: Record "Sales Invoice Header") TotalR: Decimal
    var
        GLEntryL: Record "G/L Entry";
    begin
        //++BSS.TFS_11330.GS
        GLEntryL.Reset;
        GLEntryL.SetCurrentKey("Document No.", "Posting Date");
        GLEntryL.SetRange("Document No.", SIH."No.");
        GLEntryL.SetRange("Posting Date", SIH."Posting Date");
        if GLEntryL.FindSet then
            repeat
                TotalR += -GLEntryL.Amount;
            until GLEntryL.Next = 0;
        //--BSS.TFS_11330.GS
    end;

    local procedure GetAgeYears(PostingDate: Date; RegDate: Date) Age: Integer
    begin
        //++BSS.TFS_11330.GS
        //++BSS.TFS_22705.SG
        if RegDate = 0D then
            exit(0);
        //--BSS.TFS_22705.SG

        if PostingDate < RegDate then
            exit(0);

        RegDate := CalcDate('<+1Y>', RegDate);

        while RegDate <= PostingDate do begin
            Age += 1;
            if Age = 1000 then
                exit(Age);
            RegDate := CalcDate('<+1Y>', RegDate);
        end;

        exit(Age);
        //--BSS.TFS_11330.GS
    end;

    [IntegrationEvent(true, false)]
    local procedure OnBeforePreReport(var DailyCreateP: Boolean;
        var MonthlyCreateP: Boolean;
        var CheckServiceCenterP: Boolean;
        var HistoricDataP: Boolean;
        var UpdatePerformanceBufferP: Boolean)
    begin
    end;
}

