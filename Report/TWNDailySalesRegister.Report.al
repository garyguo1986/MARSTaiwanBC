report 50046 "TWN Daily Sales Register"
{
    // +--------------------------------------------------------------+
    // | @ 2017 incadea Taiwan Limited                                |
    // +--------------------------------------------------------------+
    // | PURPOSE: MARS_TWN                                            |
    // |                                                              |
    // | REMARK :                                                     |
    // +--------------------------------------------------------------+
    // 
    // VERSION     ID          WHO    DATE        DESCRIPTION
    // TWN.01.01   RGS_TWN-425 NN     2017-05-29  Upgrade from r3
    // +----------------------------------------------+
    // | Copyright (c) incadea China                  |
    // +----------------------------------------------+
    // TFS          ID             WHO    DATE        DESCRIPTION
    // 112159       MARS_TWN-6293  GG     2018-03-05  Adjust the data source order and change layout
    // 115496                      GG     2018-07-20  Fix size of picture in layout
    // 115765       RGS_TWN-801    GG     2018-08-06  Add new column "Balance" and "Payment Methods" area
    // 117884       MARS_TWN-6454  GG     2019-01-08  Add translation for payment and sorting the payment summary
    // 120528       RGS_TWN-846    GG     2019-09-10  Add SI and SCM comments
    // 120844       RGS_TWN-836    GG     2019-10-28  Classify and sort the payment method
    // 121696       RGS_TWN-7885   QX     2020-05-25  Add a field in 50046 TWN Daily Sales Register report and contact search
    // 122187       RGS_TWN-888    QX     2020-12-14  Key "Pmt. Corr. for Sales Inv. No.", Correction is not available
    DefaultLayout = RDLC;
    RDLCLayout = './Report/TWNDailySalesRegister.rdlc';

    Caption = 'TWN Daily Sales Register';

    dataset
    {
        dataitem(Integer1; Integer)
        {
            DataItemTableView = SORTING(Number)
                                ORDER(Ascending)
                                WHERE(Number = CONST(1));
            column(USERID; USERID)
            {
            }
            column(CompanyInfo_Picture; CompanyInfo.Picture)
            {
            }
            column(CompanyInfo_Name_____CompanyInfo__Name_2_; CompanyInfo.Name + ' ' + CompanyInfo."Name 2")
            {
            }
            column(FORMAT_TODAY_0___Year4___Month_2___Day_2___; FORMAT(TODAY, 0, '<Year,2>/<Month,2>/<Day,2>'))
            {
            }
            column(ReportTitle_Caption_COPYSTR_CurrReport_OBJECTID_FALSE__8_____; ReportTitle_CaptionLbl + '(' + COPYSTR(CurrReport.OBJECTID(FALSE), 8) + ')')
            {
            }
            column(PageCaption; PageCaptionLbl)
            {
            }
            column(CurrReport_PAGENO; CurrReport.PAGENO)
            {
            }
            column(PrintSummary; PrintSummary)
            {
            }
            column(FilterString; FilterString)
            {
            }
            column(NetTotal_Caption; NetTotal_CaptionLbl)
            {
            }
            column(PostingDate_Caption; PostingDate_CaptionLbl)
            {
            }
            column(InvoiceNo_Caption; InvoiceNo_CaptionLbl)
            {
            }
            column(CustName_Caption; CustName_CaptionLbl)
            {
            }
            column(LicenceNo_Caption; LicenceNo_CaptionLbl)
            {
            }
            column(RegistrationDate_CaptionLbl; RegistrationDate_CaptionLbl)
            {
            }
            column(Mileage_CaptionLbl; Mileage_CaptionLbl)
            {
            }
            column(PaymentMethod_Caption; PaymentMethod_CaptionLbl)
            {
            }
            column(Description_Caption; Description_CaptionLbl)
            {
            }
            column(Quantity_Caption; Quantity_CaptionLbl)
            {
            }
            column(UnitPrice_Caption; UnitPrice_CaptionLbl)
            {
            }
            column(LineDiscountAmtCaption; LineDiscountAmtCaptionLbl)
            {
            }
            column(AmtInclVAT_Caption; AmtInclVAT_CaptionLbl)
            {
            }
            column(C_INC_BalanceCaption; C_INC_BalanceCaption)
            {
            }
            column(ShowBalanceG; ShowBalanceG)
            {
            }
            dataitem("Sales Invoice Header"; "Sales Invoice Header")
            {
                DataItemTableView = SORTING("No.")
                                    ORDER(Ascending);
                PrintOnlyIfDetail = true;
                RequestFilterFields = "Service Center", "Posting Date", "Sell-to Customer No.", "Bill-to Customer No.", "Sell-to Contact No.", "Bill-to Contact No.", "Vehicle No.", "Campaign No.", "Licence-Plate No.";
                column(PrintSalesSection; PrintSalesSection)
                {
                }
                column(SalesCaption; SalesCaptionLbl)
                {
                }
                column(SalesReturnCaption; SalesReturnCaptionLbl)
                {
                }
                column(CancellationCaption; CancellationCaptionLbl)
                {
                }
                column(SalesInvHeader_PostingDate; FORMAT("Posting Date", 0, '<Year,2>/<Month,2>/<Day,2>'))
                {
                }
                column(SalesInvHeader_CustName; varCustName)
                {
                }
                column(SalesInvHeader_LicencePlateNo_; "Licence-Plate No.")
                {
                }
                column(SalesInvHeader_RegistrationDate; FORMAT(RegDateG, 0, '<Year,2>/<Month,2>/<Day,2>'))
                {
                }
                column(SalesInvHeader_Mileage; Mileage)
                {
                }
                column(SalesInvHeader_PaymentMethod; varPaymentMethodCHT)
                {
                }
                column(SalesInvHeader_No_; "No.")
                {
                }
                column(SICommentsG; SICommentsG)
                {
                }
                dataitem("Sales Invoice Line"; "Sales Invoice Line")
                {
                    DataItemLink = "Document No." = FIELD("No.");
                    DataItemTableView = SORTING("Document No.", "Line No.")
                                        ORDER(Ascending);
                    PrintOnlyIfDetail = false;
                    RequestFilterFields = Type, "No.", "Item Category Code", "Main Group Code";
                    column(SalesInvoiceLine_Desc; Desc)
                    {
                    }
                    column(Total_Caption__________Sales_Invoice_Header___No__; Total_CaptionLbl + ' ' + "Sales Invoice Header"."No.")
                    {
                    }
                    column(SalesInvLine_UnitPrice; "Unit Price")
                    {
                        AutoFormatType = 2;
                    }
                    column(Sales_Invoice_Line_Quantity; Quantity)
                    {
                        DecimalPlaces = 0 : 5;
                    }
                    column(Sales_Invoice_Line__Line_Discount_Amount_; "Line Discount Amount")
                    {
                        AutoFormatType = 1;
                    }
                    column(Sales_Invoice_Line__Amount_Including_VAT_; "Amount Including VAT")
                    {
                        AutoFormatType = 1;
                    }
                    column(GrandTotal4Sales_Caption; GrandTotal4Sales_CaptionLbl)
                    {
                    }
                    column(GrandTota4SalesReturn_Caption; GrandTota4SalesReturn_CaptionLbl)
                    {
                    }
                    column(TotalCancellation_Caption; TotalCancellation_CaptionLbl)
                    {
                    }
                    column(TotalBalanceG_SalesInvLine; TotalBalanceG)
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        IF (Type = Type::"G/L Account") THEN BEGIN
                            IF ("No." = '161504') THEN
                                Desc := 'Round off Amount'
                            ELSE
                                Desc := Description + ' ' + "Description 2";
                        END ELSE
                            Desc := Description + ' ' + "Description 2";
                        // Start 115765
                        TotalIncomeG += "Sales Invoice Line"."Amount Including VAT";
                        // Stop 115765
                    end;

                    trigger OnPostDataItem()
                    begin
                        // Start 115765
                        InsertPaymentMethod(varPaymentMethod, TotalIncomeG, TotalBalanceG, TRUE);
                        // Stop 115765
                    end;

                    trigger OnPreDataItem()
                    begin
                        Desc := '';
                    end;
                }

                trigger OnAfterGetRecord()
                var
                    PstCRTransLineL: Record "Post. Cash Reg. Transact. Line";
                    MofPmtBufferL: Record "Cash Register Means of Payment" temporary;
                    //++TWN1.00.122187.QX
                    // PstCrHeaderL: Record "Posted Cash Register Header";
                    QPostedCashHeaderL: Query "Pmt. Corr. for Ssales Inv. No.";
                    //--TWN1.00.122187.QX

                    PstCrLineL: Record "Posted Cash Register Line";
                begin
                    PrintSalesSection := TRUE;
                    PaymentMode := '';
                    //Start 120844
                    varPaymentMethodCHT := '';
                    //Stop 120844
                    PostedCashRegLine.RESET;
                    PostedCashRegLine.SETRANGE("Document No.", "Cash Register Receipt");
                    IF PostedCashRegLine.FIND('-') THEN BEGIN
                        PaymentMode := PostedCashRegLine."Means of Payment Code";
                        REPEAT
                            IF PaymentMode <> PostedCashRegLine."Means of Payment Code" THEN
                                PaymentMode := PaymentMode + ',' + PostedCashRegLine."Means of Payment Code";

                            IF NOT MofPmtBufferL.GET(PostedCashRegLine."Means of Payment Code") THEN BEGIN
                                MofPmtBufferL.Code := PostedCashRegLine."Means of Payment Code";
                                MofPmtBufferL.INSERT;
                            END;
                        UNTIL PostedCashRegLine.NEXT = 0;
                    END ELSE
                        PaymentMode := '';

                    //++TWN1.00.122187.QX
                    // PstCrHeaderL.RESET;
                    // PstCrHeaderL.SETCURRENTKEY("Pmt. Corr. for Sales Inv. No.", Correction);
                    // PstCrHeaderL.SETRANGE("Pmt. Corr. for Sales Inv. No.", "No.");
                    // PstCrHeaderL.SETRANGE(Correction, FALSE);
                    // IF PstCrHeaderL.FINDLAST THEN BEGIN
                    Clear(QPostedCashHeaderL);
                    QPostedCashHeaderL.SetRange(Pmt_Corr_for_Sales_Inv_No, "No.");
                    QPostedCashHeaderL.SetRange(Correction, false);
                    QPostedCashHeaderL.Open();
                    IF QPostedCashHeaderL.Read() THEN BEGIN
                        //--TWN1.00.122187.QX                        
                        MofPmtBufferL.RESET;
                        MofPmtBufferL.DELETEALL;
                        PstCrLineL.RESET;
                        //++TWN1.00.122187.QX
                        // PstCrLineL.SETRANGE("Document No.", PstCrHeaderL."No.");
                        PstCrLineL.SETRANGE("Document No.", QPostedCashHeaderL.No);
                        //--TWN1.00.122187.QX
                        IF PstCrLineL.FINDSET THEN
                            REPEAT
                                IF NOT MofPmtBufferL.GET(PstCrLineL."Means of Payment Code") THEN BEGIN
                                    MofPmtBufferL.Code := PstCrLineL."Means of Payment Code";
                                    MofPmtBufferL.INSERT;
                                END;
                            UNTIL PstCrLineL.NEXT = 0;
                        PaymentMode := '';
                        IF MofPmtBufferL.FINDSET THEN
                            REPEAT
                                PaymentMode := PaymentMode + MofPmtBufferL.Code + ',';
                            UNTIL MofPmtBufferL.NEXT = 0;
                        PaymentMode := DELCHR(PaymentMode, '>', ',');
                    END;

                    IF PaymentMode = '' THEN
                        PaymentMode := 'CREDIT';
                    IF "Payment Method Code" = 'CASH' THEN BEGIN
                        CustName := "Sell-to Contact";
                        IF CustName = '' THEN
                            CustName := "Sell-to Customer Name";
                    END
                    ELSE
                        CustName := "Sell-to Customer Name";

                    varCustName := CustName;
                    varPaymentMethod := PaymentMode;
                    varPaymentMethodCHT := GetPaymentTranslate(varPaymentMethod);
                    // Start 115765
                    TotalIncomeG := 0;
                    TotalBalanceG := 0;
                    CustLedgerEntryG.RESET;
                    CustLedgerEntryG.SETRANGE("Customer No.", "Sales Invoice Header"."Bill-to Customer No.");
                    CustLedgerEntryG.SETRANGE("Document No.", "Sales Invoice Header"."No.");
                    IF CustLedgerEntryG.FINDFIRST THEN BEGIN
                        CustLedgerEntryG.CALCFIELDS("Remaining Amount");
                        TotalBalanceG := CustLedgerEntryG."Remaining Amount";
                    END;
                    // Stop 115765
                    // Start 120528
                    GetSIComments("Sales Invoice Header");
                    // stop 120528

                    //++TWN1.00.006.121696.QX
                    IF VehicleG.GET("Sales Invoice Header"."Vehicle No.") THEN
                        RegDateG := VehicleG."Registration Date"
                    ELSE
                        RegDateG := 0D;
                    //--TWN1.00.006.121696.QX
                end;
            }
            dataitem("Sales Cr.Memo Header"; "Sales Cr.Memo Header")
            {
                DataItemTableView = SORTING("No.")
                                    ORDER(Ascending);
                PrintOnlyIfDetail = true;
                column(PrintSalesReturnSection; PrintSalesReturnSection)
                {
                }
                column(Sales_Cr_Memo_Header_PostingDate; FORMAT("Posting Date", 0, '<Year,2>/<Month,2>/<Day,2>'))
                {
                }
                column(Sales_Cr_Memo_Header_CustName; varCustName)
                {
                }
                column(Sales_Cr_Memo_Header_LicencePlateNo_; "Licence-Plate No.")
                {
                }
                column(Sales_Cr_Memo_Header_RegistrationDate; FORMAT(RegDateG, 0, '<Year,2>/<Month,2>/<Day,2>'))
                {
                }
                column(Sales_Cr_Memo_Header_Mileage; Mileage)
                {
                }
                column(Sales_Cr_Memo_Header_PaymentMethod; varPaymentMethodCHT)
                {
                }
                column(Sales_Cr_Memo_Header_No_; "No.")
                {
                }
                column(SCMCommentsG; SCMCommentsG)
                {
                }
                dataitem("Sales Cr.Memo Line"; "Sales Cr.Memo Line")
                {
                    DataItemLink = "Document No." = FIELD("No.");
                    DataItemTableView = SORTING("Document No.", "Line No.")
                                        ORDER(Ascending)
                                        WHERE(Type = FILTER(<> ' '));
                    PrintOnlyIfDetail = false;
                    column(SalesCrMemoLine_Desc; Desc)
                    {
                    }
                    column(CrNoDate_Caption_________ApplyInvDesc; CrNoDate_CaptionLbl + ' ' + ApplyInvDesc)
                    {
                    }
                    column(Sales_Cr_Memo_Line_Quantity; Quantity)
                    {
                        DecimalPlaces = 0 : 5;
                    }
                    column(Sales_Cr_Memo_Line_UnitPrice; "Unit Price")
                    {
                        AutoFormatType = 2;
                    }
                    column(Sales_Cr_Memo_Line__Line_Discount_Amount_; "Line Discount Amount")
                    {
                        AutoFormatType = 1;
                    }
                    column(Sales_Cr_Memo_Line__Amount_Including_VAT_; "Amount Including VAT")
                    {
                        AutoFormatType = 1;
                    }
                    column(Total_CaptionLbl__________Sales_Cr_Memo_Header___No__; Total_CaptionLbl + ' ' + "Sales Cr.Memo Header"."No.")
                    {
                    }
                    column(TotalBalanceG_SalesCrMemoLine; TotalBalanceG)
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        IF (Type = Type::"G/L Account") THEN BEGIN
                            IF ("No." = '161504') THEN
                                Desc := 'Round off Amount'
                            ELSE
                                Desc := Description + ' ' + "Description 2";
                        END ELSE
                            Desc := Description + ' ' + "Description 2";
                        // Start 115765
                        TotalIncomeG += "Sales Cr.Memo Line"."Amount Including VAT";
                        // Stop 115765
                    end;

                    trigger OnPostDataItem()
                    begin
                        // Start 115765
                        InsertPaymentMethod(varPaymentMethod, TotalIncomeG, TotalBalanceG, FALSE);
                        // Stop 115765
                    end;

                    trigger OnPreDataItem()
                    begin
                        Desc := '';
                        IF (FltType = '') THEN BEGIN
                            SETFILTER(Type, '<>''''');
                        END ELSE BEGIN
                            SETFILTER(Type, FltType);
                        END;
                        SETFILTER("No.", FltNo);
                        SETFILTER("Item Category Code", FltItemCategoryCode);
                        SETFILTER("Main Group Code", FltMainGroupCode);
                    end;
                }

                trigger OnAfterGetRecord()
                var
                    SalesCrMemoLine11: Record "Sales Cr.Memo Line";
                begin
                    PrintSalesReturnSection := TRUE;
                    PaymentMode := '';
                    PostedCashRegLine.RESET;
                    PostedCashRegLine.SETRANGE("Document No.", "Cash Register Receipt");
                    IF PostedCashRegLine.FIND('-') THEN BEGIN
                        PaymentMode := PostedCashRegLine."Means of Payment Code";
                        REPEAT
                            IF PaymentMode <> PostedCashRegLine."Means of Payment Code" THEN
                                PaymentMode := PaymentMode + ',' + PostedCashRegLine."Means of Payment Code";
                        UNTIL PostedCashRegLine.NEXT = 0
                    END ELSE
                        PaymentMode := '';

                    IF PaymentMode = '' THEN
                        PaymentMode := 'CREDIT';
                    IF "Payment Method Code" = 'CASH' THEN BEGIN
                        CustName := "Sell-to Contact";
                        IF CustName = '' THEN
                            CustName := "Sell-to Customer Name";
                    END
                    ELSE
                        CustName := "Sell-to Customer Name";

                    SalesCrMemoLine.RESET;
                    SalesCrMemoLine.SETRANGE(SalesCrMemoLine."Document No.", "No.");
                    SalesCrMemoLine.SETRANGE(Type, 0);
                    IF SalesCrMemoLine.FINDFIRST THEN
                        ApplyInvDesc := SalesCrMemoLine.Description
                    ELSE
                        ApplyInvDesc := '';

                    varCustName := CustName;
                    varPaymentMethod := PaymentMode;
                    varPaymentMethodCHT := GetPaymentTranslate(varPaymentMethod);
                    // Start 115765
                    TotalIncomeG := 0;
                    TotalBalanceG := 0;
                    CustLedgerEntryG.RESET;
                    CustLedgerEntryG.SETRANGE("Customer No.", "Sales Cr.Memo Header"."Bill-to Customer No.");
                    CustLedgerEntryG.SETRANGE("Document No.", "Sales Cr.Memo Header"."No.");
                    IF CustLedgerEntryG.FINDFIRST THEN BEGIN
                        CustLedgerEntryG.CALCFIELDS("Remaining Amount");
                        TotalBalanceG := -CustLedgerEntryG."Remaining Amount";
                    END;
                    // Stop 115765
                    // Start 120528
                    GetSCMComments("Sales Cr.Memo Header");
                    // stop 120528

                    //++TWN1.00.006.121696.QX
                    IF VehicleG.GET("Sales Cr.Memo Header"."Vehicle No.") THEN
                        RegDateG := VehicleG."Registration Date"
                    ELSE
                        RegDateG := 0D;
                    //--TWN1.00.006.121696.QX
                end;

                trigger OnPreDataItem()
                begin
                    SETRANGE("Posting Date", StartDate, EndDate);
                    SETFILTER("Service Center", FltServiceCenter);
                    SETFILTER("Sell-to Customer No.", FltSellToCustomerNo);
                    SETFILTER("Bill-to Customer No.", FltBillToCustomerNo);
                    SETFILTER("Sell-to Contact No.", FltSellToContactNo);
                    SETFILTER("Bill-to Contact No.", FltBillToContactNo);
                    SETFILTER("Vehicle No.", FltVehicleNo);
                    SETFILTER("Campaign No.", FltCampaignNo);
                    SETFILTER("Licence-Plate No.", FltLicensePlateNo);
                end;
            }
            dataitem("Sales Cr.Memo Header1"; "Sales Cr.Memo Header")
            {
                DataItemTableView = SORTING("No.")
                                    ORDER(Ascending)
                                    WHERE("Sales Cancellation" = CONST(true),
                                          "No." = CONST('123'));
                PrintOnlyIfDetail = true;
                column(PrintCancellationSection; PrintCancellationSection)
                {
                }
                column(Sales_Cr_Memo_Header1_No_; "No.")
                {
                }
                column(Sales_Cr_Memo_Header1_PostingDate; FORMAT("Posting Date", 0, '<Year,2>/<Month,2>/<Day,2>'))
                {
                }
                column(Sales_Cr_Memo_Header1_CustName; varCustName)
                {
                }
                column(Sales_Cr_Memo_Header1_LicencePlateNo_; "Licence-Plate No.")
                {
                }
                column(Sales_Cr_Memo_Header1_RegistrationDate; FORMAT(RegDateG, 0, '<Year,2>/<Month,2>/<Day,2>'))
                {
                }
                column(Sales_Cr_Memo_Header1_Mileage; Mileage)
                {
                }
                column(Sales_Cr_Memo_Header1_PaymentMethod; varPaymentMethodCHT)
                {
                }
                column(SCMCommentsG1; SCMCommentsG)
                {
                }
                dataitem("Sales Cr.Memo Line1"; "Sales Cr.Memo Line")
                {
                    DataItemLink = "Document No." = FIELD("No.");
                    DataItemTableView = SORTING("Document No.", "Line No.")
                                        ORDER(Ascending)
                                        WHERE(Type = FILTER(<> ' '));
                    PrintOnlyIfDetail = false;
                    column(Sales_Cr_Memo_Line1_Quantity; Quantity)
                    {
                        DecimalPlaces = 0 : 5;
                    }
                    column(Sales_Cr_Memo_Line1_UnitPrice; "Unit Price")
                    {
                        AutoFormatType = 2;
                    }
                    column(Sales_Cr_Memo_Line1__Line_Discount_Amount_; "Line Discount Amount")
                    {
                        AutoFormatType = 1;
                    }
                    column(Sales_Cr_Memo_Line1__Amount_Including_VAT_; "Amount Including VAT")
                    {
                        AutoFormatType = 1;
                    }
                    column(Total_Caption__________Sales_Cr_Memo_Header1___No__; Total_CaptionLbl + ' ' + "Sales Cr.Memo Header1"."No.")
                    {
                    }
                    column(CancellationAgainst_Caption________ApplyInvDesc; CancellationAgainst_CaptionLbl + ' ' + ApplyInvDesc)
                    {
                    }
                    column(Cancellation_Desc; Desc)
                    {
                    }
                    column(TotalBalanceG_SalesCrMemoLine1; TotalBalanceG)
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        IF (Type = Type::"G/L Account") THEN BEGIN
                            IF ("No." = '161504') THEN
                                Desc := 'Round off Amount'
                            ELSE
                                Desc := Description + ' ' + "Description 2";
                        END ELSE
                            Desc := Description + ' ' + "Description 2";
                        // Start 115765
                        TotalIncomeG += "Sales Cr.Memo Line1"."Amount Including VAT";
                        // Stop 115765
                    end;

                    trigger OnPostDataItem()
                    begin
                        // Start 115765
                        InsertPaymentMethod(varPaymentMethod, TotalIncomeG, TotalBalanceG, FALSE);
                        // Stop 115765
                    end;

                    trigger OnPreDataItem()
                    begin
                        Desc := '';
                        /*
                        IF (FltType = '') THEN BEGIN
                          SETFILTER(Type,'<>''''');
                        END ELSE BEGIN
                          SETFILTER(Type, FltType);
                        END;
                        */
                        SETFILTER("No.", FltNo);
                        SETFILTER("Item Category Code", FltItemCategoryCode);
                        SETFILTER("Main Group Code", FltMainGroupCode);

                    end;
                }

                trigger OnAfterGetRecord()
                var
                    SalesCrMemoLine11: Record "Sales Cr.Memo Line";
                begin
                    PrintCancellationSection := TRUE;
                    PaymentMode := '';
                    PostedCashRegLine.RESET;
                    PostedCashRegLine.SETRANGE("Document No.", "Cash Register Receipt");
                    IF PostedCashRegLine.FIND('-') THEN BEGIN
                        PaymentMode := PostedCashRegLine."Means of Payment Code";
                        REPEAT
                            IF PaymentMode <> PostedCashRegLine."Means of Payment Code" THEN
                                PaymentMode := PaymentMode + ',' + PostedCashRegLine."Means of Payment Code";
                        UNTIL PostedCashRegLine.NEXT = 0
                    END ELSE
                        PaymentMode := '';

                    IF PaymentMode = '' THEN
                        PaymentMode := 'CREDIT';
                    IF "Payment Method Code" = 'CASH' THEN BEGIN
                        CustName := "Sell-to Contact";
                        IF CustName = '' THEN
                            CustName := "Sell-to Customer Name";
                    END
                    ELSE
                        CustName := "Sell-to Customer Name";

                    SalesCrMemoLine.RESET;
                    SalesCrMemoLine.SETRANGE(SalesCrMemoLine."Document No.", "No.");
                    SalesCrMemoLine.SETRANGE(Type, 0);
                    IF SalesCrMemoLine.FINDFIRST THEN
                        ApplyInvDesc := SalesCrMemoLine.Description
                    ELSE
                        ApplyInvDesc := '';

                    varCustName := CustName;
                    varPaymentMethod := PaymentMode;
                    varPaymentMethodCHT := GetPaymentTranslate(varPaymentMethod);
                    // Start 115765
                    TotalIncomeG := 0;
                    TotalBalanceG := 0;
                    CustLedgerEntryG.RESET;
                    CustLedgerEntryG.SETRANGE("Customer No.", "Sales Cr.Memo Header1"."Bill-to Customer No.");
                    CustLedgerEntryG.SETRANGE("Document No.", "Sales Cr.Memo Header1"."No.");
                    IF CustLedgerEntryG.FINDFIRST THEN BEGIN
                        CustLedgerEntryG.CALCFIELDS("Remaining Amount");
                        TotalBalanceG := -CustLedgerEntryG."Remaining Amount";
                    END;
                    // Stop 115765
                    // Start 120528
                    GetSCMComments("Sales Cr.Memo Header1");
                    // stop 120528

                    //++TWN1.00.006.121696.QX
                    IF VehicleG.GET("Sales Cr.Memo Header1"."Vehicle No.") THEN
                        RegDateG := VehicleG."Registration Date"
                    ELSE
                        RegDateG := 0D;
                    //--TWN1.00.006.121696.QX
                end;

                trigger OnPreDataItem()
                begin
                    SETRANGE("Posting Date", StartDate, EndDate);
                    SETFILTER("Service Center", FltServiceCenter);
                    SETFILTER("Sell-to Customer No.", FltSellToCustomerNo);
                    SETFILTER("Bill-to Customer No.", FltBillToCustomerNo);
                    SETFILTER("Sell-to Contact No.", FltSellToContactNo);
                    SETFILTER("Bill-to Contact No.", FltBillToContactNo);
                    SETFILTER("Vehicle No.", FltVehicleNo);
                    SETFILTER("Campaign No.", FltCampaignNo);
                    SETFILTER("Licence-Plate No.", FltLicensePlateNo);
                end;
            }

            trigger OnPreDataItem()
            begin
                CompanyInfo.GET;
                CompanyInfo.CALCFIELDS(CompanyInfo.Picture);

                IF ServiceCenter.GET(UserMgt.GetSalesFilter()) THEN BEGIN
                    FormatAddr.ServCenter(CompanyAddr, ServiceCenter);

                    CompanyInfo.Name := ServiceCenter.Name;
                    CompanyInfo."Name 2" := ServiceCenter."Name 2";
                    CompanyInfo.Address := ServiceCenter.Address;
                    CompanyInfo."Address 2" := ServiceCenter."Address 2";
                    CompanyInfo.City := ServiceCenter.City;
                    CompanyInfo."Post Code" := ServiceCenter."Post Code";
                    CompanyInfo.County := ServiceCenter.County;
                    CompanyInfo."Country/Region Code" := ServiceCenter."Country/Region Code";

                    CompanyInfo."Phone No." := ServiceCenter."Phone No.";
                    CompanyInfo."Fax No." := ServiceCenter."Fax No.";
                END ELSE BEGIN
                    FormatAddr.Company(CompanyAddr, CompanyInfo);
                END;
            end;
        }
        dataitem(PaymentMethods; Integer)
        {
            column(Total_CaptionLbl; Total_CaptionLbl)
            {
            }
            column(C_INC_PaymentMethodLbl; C_INC_PaymentMethodLbl)
            {
            }
            column(C_INC_DocumentCountLbl; C_INC_DocumentCountLbl)
            {
            }
            column(C_INC_IncomeLbl; C_INC_IncomeLbl)
            {
            }
            column(C_INC_BalanceLbl; C_INC_BalanceLbl)
            {
            }
            column(Number_PaymentMethods; PaymentMethods.Number)
            {
            }
            column(SortingEntryNo_PaymentMethods; TempPaymentMethods2G."Entry No.")
            {
            }
            column(Code_PaymentMethods; TempPaymentMethods2G.Description)
            {
            }
            column(DocumentCount__PaymentMethods; TempPaymentMethods2G."Attached to Line No.")
            {
            }
            column(Income__PaymentMethods; TempPaymentMethods2G."Original Amount")
            {
            }
            column(Balance__PaymentMethods; TempPaymentMethods2G."Remaining Amount")
            {
            }

            trigger OnAfterGetRecord()
            begin
                IF Number <> 1 THEN
                    TempPaymentMethods2G.NEXT;
            end;

            trigger OnPreDataItem()
            var
                NewEntryNoL: Integer;
                NewDescriptionL: Text;
            begin
                TempPaymentMethods2G.RESET;
                TempPaymentMethods2G.DELETEALL;
                TempPaymentMethodsG.RESET;
                IF TempPaymentMethodsG.FINDFIRST THEN
                    REPEAT
                        // Start 120844
                        NewEntryNoL := GetPaymentSorting(TempPaymentMethodsG.Description);
                        NewDescriptionL := GetPaymentTranslate(TempPaymentMethodsG.Description);
                        TempPaymentMethods2G.RESET;
                        TempPaymentMethods2G.SETRANGE(Description, NewDescriptionL);
                        IF TempPaymentMethods2G.FINDFIRST THEN BEGIN
                            TempPaymentMethods2G."Entry No." := NewEntryNoL;
                            TempPaymentMethods2G."Attached to Line No." := TempPaymentMethods2G."Attached to Line No." + TempPaymentMethodsG."Attached to Line No.";
                            TempPaymentMethods2G."Original Amount" := TempPaymentMethods2G."Original Amount" + TempPaymentMethodsG."Original Amount";
                            TempPaymentMethods2G."Remaining Amount" := TempPaymentMethods2G."Remaining Amount" + TempPaymentMethods2G."Remaining Amount";
                            TempPaymentMethods2G.MODIFY;
                        END ELSE BEGIN
                            TempPaymentMethods2G.INIT;
                            TempPaymentMethods2G := TempPaymentMethodsG;
                            TempPaymentMethods2G."Entry No." := NewEntryNoL;
                            TempPaymentMethods2G.Description := NewDescriptionL;
                            TempPaymentMethods2G.INSERT;
                        END;
                    //TempPaymentMethodsG."Entry No." := GetPaymentSorting(TempPaymentMethodsG.Description);
                    //TempPaymentMethodsG.Description := GetPaymentTranslate(TempPaymentMethodsG.Description);
                    //TempPaymentMethodsG.MODIFY;
                    // Stop 120844
                    UNTIL TempPaymentMethodsG.NEXT = 0;
                TempPaymentMethods2G.RESET;
                IF TempPaymentMethods2G.FINDFIRST THEN
                    ;
                SETRANGE(Number, 1, TempPaymentMethods2G.COUNT);
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
                group(Options)
                {
                    Caption = '選項';
                    field(PrintSummary; PrintSummary)
                    {
                        Caption = 'Print Summary';
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
        MUTFuncs.AddUsageTrackingEntry('MUT_6010');
    end;

    trigger OnPostReport()
    begin
        /*
        TempPaymentMethodsG.RESET;
        IF TempPaymentMethodsG.FINDFIRST THEN
          REPEAT
            MESSAGE(TempPaymentMethodsG."Finance Charge Memo No." +
              TempPaymentMethodsG.Description + '|'+
              FORMAT(TempPaymentMethodsG."Attached to Line No.") + '|' +
              FORMAT(TempPaymentMethodsG."Original Amount") + '|' +
              FORMAT(TempPaymentMethodsG."Remaining Amount")
              );
          UNTIL TempPaymentMethodsG.NEXT = 0;
        */

    end;

    trigger OnPreReport()
    begin
        StartDate := "Sales Invoice Header".GETRANGEMIN("Posting Date");
        EndDate := "Sales Invoice Header".GETRANGEMAX("Posting Date");

        FltServiceCenter := "Sales Invoice Header".GETFILTER("Service Center");
        FltSellToCustomerNo := "Sales Invoice Header".GETFILTER("Sell-to Customer No.");
        FltBillToCustomerNo := "Sales Invoice Header".GETFILTER("Bill-to Customer No.");
        FltSellToContactNo := "Sales Invoice Header".GETFILTER("Sell-to Contact No.");
        FltBillToContactNo := "Sales Invoice Header".GETFILTER("Bill-to Contact No.");
        FltVehicleNo := "Sales Invoice Header".GETFILTER("Vehicle No.");
        FltCampaignNo := "Sales Invoice Header".GETFILTER("Campaign No.");
        FltLicensePlateNo := "Sales Invoice Header".GETFILTER("Licence-Plate No.");
        FltType := "Sales Invoice Line".GETFILTER(Type);
        FltNo := "Sales Invoice Line".GETFILTER("No.");
        FltItemCategoryCode := "Sales Invoice Line".GETFILTER("Item Category Code");
        FltMainGroupCode := "Sales Invoice Line".GETFILTER("Main Group Code");

        ItemCategory := "Sales Invoice Line".GETFILTER("Item Category Code");

        FilterString := "Sales Invoice Header".GETFILTERS + ' ' + "Sales Invoice Line".GETFILTERS;

        PrintSalesSection := FALSE;
        PrintSalesReturnSection := FALSE;
        PrintCancellationSection := FALSE;

        // Start 115765
        TempPaymentMethodsG.RESET;
        TempPaymentMethodsG.DELETEALL;
        ShowBalanceG := TRUE;
        // Stop 115765
    end;

    var
        ReportTitle_CaptionLbl: Label 'Daily Sales Register';
        CompanyName_CaptionLbl: Label 'Company Name';
        LineDiscountAmtCaptionLbl: Label 'Total Discount Amount';
        TaxAmountCaptionLbl: Label 'Tax Amount';
        AmtInclVAT_CaptionLbl: Label 'Amount Including VAT';
        InvoiceNoDate_CaptionLbl: Label 'Invoice No./Date';
        Total_CaptionLbl: Label 'Total';
        CrNoDate_CaptionLbl: Label 'Credit Memo No./Date';
        CancellationAgainst_CaptionLbl: Label 'Cancellation against';
        GrandTota4SalesReturn_CaptionLbl: Label 'Grand Total for Sales Return';
        TotalCancellation_CaptionLbl: Label 'Total Cancellation';
        NetTotal_CaptionLbl: Label 'Net Total';
        PageCaptionLbl: Label 'Page';
        SalesCaptionLbl: Label 'Sales';
        SalesReturnCaptionLbl: Label 'Sales Return';
        CancellationCaptionLbl: Label 'Cancellation';
        GrandTotal4Sales_CaptionLbl: Label 'Grand Total for Sales:';
        PostingDate_CaptionLbl: Label 'Date';
        InvoiceNo_CaptionLbl: Label 'Invoice No.';
        CustName_CaptionLbl: Label 'Name';
        LicenceNo_CaptionLbl: Label 'Licence No.';
        RegistrationDate_CaptionLbl: Label 'Registration Date';
        Mileage_CaptionLbl: Label 'Mileage';
        PaymentMethod_CaptionLbl: Label 'Payment Method';
        Description_CaptionLbl: Label 'Description';
        Quantity_CaptionLbl: Label 'Quantity';
        UnitPrice_CaptionLbl: Label 'Unit Price';
        TempPaymentMethodsG: Record "Finance Charge Memo Line" temporary;
        TempPaymentMethods2G: Record "Finance Charge Memo Line" temporary;
        PrintSummary: Boolean;
        StartDate: Date;
        EndDate: Date;
        varCustName: Text[100];
        varPaymentMethod: Text[100];
        varPaymentMethodCHT: Text[100];
        CompanyInfo: Record "Company Information";
        ServiceCenter: Record "Service Center";
        FormatAddr: Codeunit "Format Address";
        CompanyAddr: array[8] of Text[50];
        UserMgt: Codeunit "User Setup Management";
        MUTFuncs: Codeunit "Usage Tracking";
        PostedCashRegLine: Record "Posted Cash Register Line";
        PaymentMode: Text[100];
        CustName: Text[50];
        Desc: Text[100];
        UnitPrice: Decimal;
        BalanceG: Decimal;
        TotalIncomeG: Decimal;
        TotalBalanceG: Decimal;
        FltServiceCenter: Code[1024];
        FltSellToCustomerNo: Code[1024];
        FltBillToCustomerNo: Code[1024];
        FltSellToContactNo: Code[1024];
        FltBillToContactNo: Code[1024];
        FltVehicleNo: Code[1024];
        FltCampaignNo: Code[1024];
        FltLicensePlateNo: Code[1024];
        FltType: Code[1024];
        FltNo: Code[1024];
        FltItemCategoryCode: Code[1024];
        FltMainGroupCode: Code[1024];
        FilterString: Text[1024];
        PrintSalesSection: Boolean;
        PrintSalesReturnSection: Boolean;
        PrintCancellationSection: Boolean;
        SalesCrMemoLine: Record "Sales Cr.Memo Line";
        CustLedgerEntryG: Record "Cust. Ledger Entry";
        ItemCategory: Code[1024];
        ApplyInvDesc: Text[50];
        BooExcFromPage: Boolean;
        ShowBalanceG: Boolean;
        C_INC_BalanceCaption: Label 'Balance';
        C_INC_PaymentMethodLbl: Label 'Payment Method';
        C_INC_DocumentCountLbl: Label 'Document Count';
        C_INC_IncomeLbl: Label 'Income';
        C_INC_BalanceLbl: Label 'Balance';
        C_INC_OtherPaymentLbl: Label 'OTHER';
        C_INC_Bank: Label 'BANK';
        C_INC_CASH: Label 'CASH';
        "C_INC_CASH-M": Label 'CASH-M';
        C_INC_CHECK: Label 'CHECK';
        C_INC_CREDITCARD: Label 'CREDITCARD';
        C_INC_CREDIT: Label 'CREDIT';
        SICommentsG: Text;
        SCMCommentsG: Text;
        C_INC_CHEQUE: Label 'CHEQUE';
        C_INC_Comment: Label '...';
        RegDateG: Date;
        VehicleG: Record Vehicle;

    [Scope('OnPrem')]
    procedure SetReportAttribute()
    begin
        BooExcFromPage := TRUE;
    end;

    local procedure InsertPaymentMethod(PaymentMethodP: Text[100]; IncomeP: Decimal; BalanceP: Decimal; DirectionP: Boolean)
    var
        InvOrCreditL: Integer;
        LineNoL: Integer;
    begin
        // Start 115765
        IF DirectionP THEN
            InvOrCreditL := 1
        ELSE
            InvOrCreditL := -1;

        TempPaymentMethodsG.RESET;
        IF TempPaymentMethodsG.FINDLAST THEN
            LineNoL := TempPaymentMethodsG."Line No." + 10000
        ELSE
            LineNoL := 10000;

        IF (STRPOS(PaymentMethodP, ',') > 0) THEN BEGIN
            TempPaymentMethodsG.RESET;
            TempPaymentMethodsG.SETRANGE(Description, C_INC_OtherPaymentLbl);
            IF NOT TempPaymentMethodsG.FINDFIRST THEN BEGIN
                TempPaymentMethodsG.INIT;
                TempPaymentMethodsG."Finance Charge Memo No." := '';
                TempPaymentMethodsG."Line No." := LineNoL;
                TempPaymentMethodsG.Description := C_INC_OtherPaymentLbl;
                TempPaymentMethodsG."Attached to Line No." := 1 * InvOrCreditL; //Total Document Count
                TempPaymentMethodsG."Original Amount" := IncomeP * InvOrCreditL; // Income
                TempPaymentMethodsG."Remaining Amount" := BalanceP * InvOrCreditL; // Balance
                TempPaymentMethodsG.INSERT;
            END ELSE BEGIN
                TempPaymentMethodsG."Attached to Line No." += 1 * InvOrCreditL; //Total Document Count
                TempPaymentMethodsG."Original Amount" += IncomeP * InvOrCreditL; // Income
                TempPaymentMethodsG."Remaining Amount" += BalanceP * InvOrCreditL; // Balance
                TempPaymentMethodsG.MODIFY;
            END;
        END ELSE BEGIN
            TempPaymentMethodsG.RESET;
            TempPaymentMethodsG.SETRANGE(Description, PaymentMethodP);
            IF NOT TempPaymentMethodsG.FINDFIRST THEN BEGIN
                TempPaymentMethodsG.INIT;
                TempPaymentMethodsG."Finance Charge Memo No." := '';
                TempPaymentMethodsG."Line No." := LineNoL;
                TempPaymentMethodsG.Description := PaymentMethodP;
                TempPaymentMethodsG."Attached to Line No." := 1 * InvOrCreditL; //Total Document Count
                TempPaymentMethodsG."Original Amount" := IncomeP * InvOrCreditL; // Income
                TempPaymentMethodsG."Remaining Amount" := BalanceP * InvOrCreditL; // Balance
                TempPaymentMethodsG.INSERT;
            END ELSE BEGIN
                TempPaymentMethodsG."Attached to Line No." += 1 * InvOrCreditL; //Total Document Count
                TempPaymentMethodsG."Original Amount" += IncomeP * InvOrCreditL; // Income
                TempPaymentMethodsG."Remaining Amount" += BalanceP * InvOrCreditL; // Balance
                TempPaymentMethodsG.MODIFY;
            END;
        END;
        // Stop 115765
    end;

    local procedure GetPaymentTranslate(PaymentMethodP: Text[100]): Text
    begin
        // Start 120844
        IF STRPOS(PaymentMethodP, ',') >= 1 THEN
            EXIT(C_INC_OtherPaymentLbl);
        IF STRPOS(PaymentMethodP, 'CREDITCARD') >= 1 THEN
            EXIT(C_INC_CREDITCARD);
        IF STRPOS(PaymentMethodP, 'CREDIT CARD') >= 1 THEN
            EXIT(C_INC_CREDITCARD);
        IF STRPOS(PaymentMethodP, 'CREIDTCARD') >= 1 THEN
            EXIT(C_INC_CREDITCARD);
        IF STRPOS(PaymentMethodP, 'CREIDT CARD') >= 1 THEN
            EXIT(C_INC_CREDITCARD);
        IF STRPOS(PaymentMethodP, 'CASH') >= 1 THEN
            EXIT(C_INC_CASH);
        IF STRPOS(PaymentMethodP, 'CASH-M') >= 1 THEN
            EXIT("C_INC_CASH-M");
        IF STRPOS(PaymentMethodP, 'BANK') >= 1 THEN
            EXIT(C_INC_Bank);
        IF STRPOS(PaymentMethodP, 'CHECK') >= 1 THEN
            EXIT(C_INC_CHECK);
        IF STRPOS(PaymentMethodP, 'CREDIT') >= 1 THEN
            EXIT(C_INC_CREDIT);
        IF STRPOS(PaymentMethodP, 'CREIDT') >= 1 THEN
            EXIT(C_INC_CREDIT);
        IF STRPOS(PaymentMethodP, 'CHEQUE') >= 1 THEN
            EXIT(C_INC_CHEQUE);

        // Stop 120844
        EXIT(C_INC_OtherPaymentLbl);
    end;

    local procedure GetPaymentSorting(PaymentMethodP: Text[100]): Integer
    begin
        // 120844
        IF STRPOS(PaymentMethodP, ',') >= 1 THEN
            EXIT(100);
        IF STRPOS(PaymentMethodP, 'CREDITCARD') >= 1 THEN
            EXIT(2);
        IF STRPOS(PaymentMethodP, 'CREDIT CARD') >= 1 THEN
            EXIT(2);
        IF STRPOS(PaymentMethodP, 'CREIDTCARD') >= 1 THEN
            EXIT(2);
        IF STRPOS(PaymentMethodP, 'CREIDT CARD') >= 1 THEN
            EXIT(2);
        IF STRPOS(PaymentMethodP, 'CASH') >= 1 THEN
            EXIT(3);
        IF STRPOS(PaymentMethodP, 'CASH-M') >= 1 THEN
            EXIT(4);
        IF STRPOS(PaymentMethodP, 'BANK') >= 1 THEN
            EXIT(5);
        IF STRPOS(PaymentMethodP, 'CHECK') >= 1 THEN
            EXIT(6);
        IF STRPOS(PaymentMethodP, 'CREDIT') >= 1 THEN
            EXIT(1);
        IF STRPOS(PaymentMethodP, 'CREIDT') >= 1 THEN
            EXIT(1);
        IF STRPOS(PaymentMethodP, 'CHEQUE') >= 1 THEN
            EXIT(7);

        // Stop 120844
        EXIT(100);
    end;

    local procedure GetSIComments(var SalesInvoiceHeaderP: Record "Sales Invoice Header")
    var
        SalesCommentLineL: Record "Sales Comment Line";
    begin
        // Start 120528
        SICommentsG := '';
        SalesCommentLineL.RESET;
        SalesCommentLineL.SETRANGE("Document Type", SalesCommentLineL."Document Type"::"Posted Invoice");
        SalesCommentLineL.SETRANGE("No.", SalesInvoiceHeaderP."No.");
        SalesCommentLineL.SETFILTER(Comment, '<>%1', '');
        IF SalesCommentLineL.FINDFIRST THEN
            REPEAT
                IF SICommentsG = '' THEN
                    SICommentsG := SalesCommentLineL.Comment
                ELSE
                    SICommentsG := SICommentsG + ' ' + SalesCommentLineL.Comment;
            UNTIL SalesCommentLineL.NEXT = 0;
        IF STRLEN(SICommentsG) > 33 THEN
            SICommentsG := COPYSTR(SICommentsG, 1, 33) + C_INC_Comment;
        // stop 120528
    end;

    local procedure GetSCMComments(var SalesCrMemoHeaderP: Record "Sales Cr.Memo Header")
    var
        SalesCommentLineL: Record "Sales Comment Line";
    begin
        // Start 120528
        SCMCommentsG := '';
        SalesCommentLineL.RESET;
        SalesCommentLineL.SETRANGE("Document Type", SalesCommentLineL."Document Type"::"Posted Credit Memo");
        SalesCommentLineL.SETRANGE("No.", SalesCrMemoHeaderP."No.");
        SalesCommentLineL.SETFILTER(Comment, '<>%1', '');
        IF SalesCommentLineL.FINDFIRST THEN
            REPEAT
                IF SCMCommentsG = '' THEN
                    SCMCommentsG := SalesCommentLineL.Comment
                ELSE
                    SCMCommentsG := SCMCommentsG + ' ' + SalesCommentLineL.Comment;
            UNTIL SalesCommentLineL.NEXT = 0;
        IF STRLEN(SCMCommentsG) > 33 THEN
            SCMCommentsG := COPYSTR(SCMCommentsG, 1, 33) + C_INC_Comment;
        // stop 120528
    end;
}

