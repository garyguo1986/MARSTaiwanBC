report 50012 "Account Payable List"
{
    // +--------------------------------------------------------------+
    // | @ 2017 incadea Taiwan Limited                                |
    // +--------------------------------------------------------------+
    // | PURPOSE: MARS_TWN                                            |
    // |                                                              |
    // +--------------------------------------------------------------+

    // VERSION   ID          WHO    DATE        DESCRIPTION
    // RGS_TWN_333           NN     2017-04-22  Upgraded from R3
    // +----------------------------------------------+
    // | Copyright (c) incadea China                  |
    // +----------------------------------------------+
    // TFS          ID             WHO    DATE        DESCRIPTION
    // 112086       MARS_TWN-6222  GG     01.03.18    Change the logic of data filter    
    Caption = 'Account Payable List';
    DefaultLayout = RDLC;
    RDLCLayout = 'ReportLayout\report50012.rdl';
    UsageCategory = ReportsAndAnalysis;
    PreviewMode = Normal;

    dataset
    {
        dataitem(Vendor; Vendor)
        {
            DataItemTableView = sorting("Vendor Posting Group");
            RequestFilterFields = "No.", "Search Name", Blocked, "Date Filter";
            PrintOnlyIfDetail = true;
            column(CompanyInfo_Name; CompanyInfo.Name)
            {
            }
            column(MaxDate; PostingDataRangeTextG)
            {
            }
            column(Vendor__Vendor_Posting_Group_; "Vendor Posting Group")
            {
            }
            column(CurrencyTotalBuffer2__Total_Amount__LCY__; -CurrencyTotalBuffer2."Total Amount (LCY)")
            {
            }
            column(Account_Payable_ListCaption; Account_Payable_ListCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(As_of_Date_Caption; As_of_Date_CaptionLbl)
            {
            }
            column(VendLedgEntry3__Posting_Date_Caption; VendLedgEntry3.FIELDCAPTION("Posting Date"))
            {
            }
            column(VendLedgEntry3__Document_Type_Caption; VendLedgEntry3.FIELDCAPTION("Document Type"))
            {
            }
            column(VendLedgEntry3__Document_No__Caption; VendLedgEntry3.FIELDCAPTION("Document No."))
            {
            }
            column(Vendor_NameCaption; Vendor_NameCaptionLbl)
            {
            }
            column(Vendor_No_Caption; Vendor_No_CaptionLbl)
            {
            }
            column(Total_AmountCaption; Total_AmountCaptionLbl)
            {
            }
            column(External_Doc_No_Caption; External_Doc_No_CaptionLbl)
            {
            }
            column(Vendor_Posting_GroupCaption; Vendor_Posting_GroupCaptionLbl)
            {
            }
            column(Sub_TotalCaption; Sub_TotalCaptionLbl)
            {
            }
            column(Vendor_No_; "No.")
            {
            }
            column(ShowDetailAR; ShowDetailAR)
            {
            }
            dataitem(VendLedgEntry3; "Vendor Ledger Entry")
            {
                DataItemTableView = sorting("Entry No.");
                DataItemLinkReference = Vendor;
                DataItemLink = "Vendor No." = field("No.");
                column(VendLedgEntry3__Posting_Date_; "Posting Date")
                {
                }
                column(VendLedgEntry3__Document_Type_; "Document Type")
                {
                }
                column(VendLedgEntry3__Document_No__; "Document No.")
                {
                }
                column(Vendor_Name_Control1000000007; Vendor.Name)
                {
                }
                column(Vendor__No___Control1000000008; Vendor."No.")
                {
                }
                column(Vendor_Name; Vendor.Name)
                {
                }
                column(Vendor__No__; Vendor."No.")
                {
                }
                column(Remaining_Amt___LCY__; -"Remaining Amt. (LCY)")
                {
                }
                column(VendLedgEntry3__External_Document_No__; "External Document No.")
                {
                }
                column(VendLedgEntry3_Entry_No_; "Entry No.")
                {
                }
                column(TotalCaption; TotalCaptionLbl)
                {
                }
                column(Prepared_byCaption; Prepared_byCaptionLbl)
                {
                }
                column(Reviewed_byCaption; Reviewed_byCaptionLbl)
                {
                }
                column(Approved_byCaption; Approved_byCaptionLbl)
                {
                }
                trigger OnPreDataItem()
                begin
                    RESET;
                    DtldVendLedgEntry.SETCURRENTKEY("Vendor No.", "Posting Date", "Entry Type");
                    DtldVendLedgEntry.SETRANGE("Vendor No.", Vendor."No.");
                    DtldVendLedgEntry.SETRANGE("Posting Date", CALCDATE('<+1D>', MaxDate), 99991231D);
                    DtldVendLedgEntry.SETRANGE("Entry Type", DtldVendLedgEntry."Entry Type"::Application);
                    //IF NOT PrintUnappliedEntries  THEN
                    //  DtldVendLedgEntry.SETRANGE(Unapplied,FALSE);

                    IF DtldVendLedgEntry.FIND('-') THEN
                        REPEAT
                            "Entry No." := DtldVendLedgEntry."Vendor Ledger Entry No.";
                            // Start 112086
                            IF VendLedgEntryG.GET(DtldVendLedgEntry."Vendor Ledger Entry No.") THEN BEGIN
                                IF (VendLedgEntryG."Posting Date" >= MinDateG) AND (VendLedgEntryG."Posting Date" <= MaxDateG) THEN
                                    MARK(TRUE);
                            END;
                        //MARK(TRUE);
                        // Stop 112086
                        UNTIL DtldVendLedgEntry.NEXT = 0;

                    SETCURRENTKEY("Vendor No.", Open);
                    SETRANGE("Vendor No.", Vendor."No.");
                    SETRANGE(Open, TRUE);
                    // Start 112086
                    //SETRANGE("Posting Date",0D,MaxDate);
                    SETRANGE("Posting Date", MinDateG, MaxDateG);
                    // Stop 112086
                    IF FIND('-') THEN
                        REPEAT
                            MARK(TRUE);
                        UNTIL NEXT = 0;

                    SETCURRENTKEY("Entry No.");
                    SETRANGE(Open);
                    MARKEDONLY(TRUE);
                    SETRANGE("Date Filter", 0D, MaxDate);
                end;

                trigger OnAfterGetRecord()
                begin
                    CALCFIELDS("Original Amt. (LCY)", "Remaining Amt. (LCY)", "Original Amount", "Remaining Amount");
                    OriginalAmtLCY := "Original Amt. (LCY)";
                    RemainingAmtLCY := "Remaining Amt. (LCY)";

                    OriginalAmt := "Original Amount";
                    RemainingAmt := "Remaining Amount";
                    CurrencyCode := "Currency Code";

                    //CurrencyTotalBuffer.UpdateTotal(
                    //  CurrencyCode,
                    //  RemainingAmt,
                    //  RemainingAmtLCY,
                    //  Counter1);

                    //CurrencyTotalBuffer2.UpdateTotal(
                    //  '',
                    //  RemainingAmtLCY,
                    //  RemainingAmtLCY,
                    //  Counter2);

                    //TotalLCY += RemainingAmtLCY;
                end;
            }
            trigger OnPreDataItem()
            begin
                //CurrReport.NEWPAGEPERRECORD := PrintOnePrPage;
                IF Vendor.GETFILTER("Date Filter") = '' THEN
                    ERROR(Text001);
            end;

            trigger OnAfterGetRecord()
            begin
                MaxDate := GETRANGEMAX("Date Filter");
                SETRANGE("Date Filter", 0D, MaxDate);
                CALCFIELDS("Net Change (LCY)", "Net Change");

                IF (Vendor."Net Change (LCY)" = 0) AND (Vendor."Net Change" = 0)
                THEN
                    CurrReport.SKIP;
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
                    field("Show Detail Record"; ShowDetailAR)
                    {
                        Caption = 'Show Detail Record';
                    }
                }
            }
        }
        actions
        {
            area(processing)
            {
            }
        }
    }
    trigger OnPreReport()
    begin
        VendFilter := Vendor.GETFILTERS;
        VendDateFilter := Vendor.GETFILTER("Date Filter");
        CompanyInfo.GET;
        // Start 112086
        IF (Vendor.GETFILTER("Date Filter") = '') THEN
            ERROR(Text001);
        IF COPYSTR(Vendor.GETFILTER("Date Filter"), 1, 2) = '..' THEN
            MinDateG := 0D
        ELSE
            MinDateG := Vendor.GETRANGEMIN("Date Filter");
        MaxDateG := Vendor.GETRANGEMAX("Date Filter");
        IF (MinDateG <> 0D) AND (MinDateG <> MaxDateG) THEN
            PostingDataRangeTextG := FORMAT(MinDateG, 0, '<Year4>/<Month,2>/<Day,2>');
        IF (MinDateG <> MaxDateG) THEN
            PostingDataRangeTextG += '..';
        PostingDataRangeTextG += FORMAT(MaxDateG, 0, '<Year4>/<Month,2>/<Day,2>');
        // Stop 112086
    end;

    var
        DtldVendLedgEntry: Record "Detailed Vendor Ledg. Entry";
        CurrencyTotalBuffer: Record "Currency Total Buffer";
        CurrencyTotalBuffer2: Record "Currency Total Buffer";
        PrintOnePrPage: Boolean;
        VendFilter: Text[250];
        VendDateFilter: Text[30];
        MaxDate: Date;
        OriginalAmt: Decimal;
        Amt: Decimal;
        RemainingAmt: Decimal;
        Counter1: Integer;
        OK: Boolean;
        CurrencyCode: Code[10];
        PrintUnappliedEntries: Boolean;
        CompanyInfo: Record "Company Information";
        ShowDetailAR: Boolean;
        OriginalAmtLCY: Decimal;
        RemainingAmtLCY: Decimal;
        TotalLCY: Decimal;
        Counter2: Integer;
        AmtLCY: Decimal;
        VendLedgEntryG: Record "Vendor Ledger Entry";
        MinDateG: Date;
        MaxDateG: Date;
        PostingDataRangeTextG: Text;
        Text000: Label 'Balance on %1';
        Text001: Label 'Enter Date Filter!';
        Account_Payable_ListCaptionLbl: Label 'Account Payable List';
        CurrReport_PAGENOCaptionLbl: Label 'Page:';
        As_of_Date_CaptionLbl: Label 'Posting Date:';
        Vendor_NameCaptionLbl: Label 'Vendor Name';
        Vendor_No_CaptionLbl: Label 'Vendor No.';
        Total_AmountCaptionLbl: Label 'Total Amount';
        External_Doc_No_CaptionLbl: Label 'External Doc. No.';
        Vendor_Posting_GroupCaptionLbl: Label 'Vendor Posting Group';
        Sub_TotalCaptionLbl: Label 'Sub Total';
        TotalCaptionLbl: Label 'Total';
        Prepared_byCaptionLbl: Label 'Prepared by';
        Reviewed_byCaptionLbl: Label 'Reviewed by';
        Approved_byCaptionLbl: Label 'Approved by';
}
