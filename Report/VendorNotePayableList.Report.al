report 50000 "Vendor - Note Payable List"
{
    // +--------------------------------------------------------------+
    // | @ 2017 incadea Taiwan Limited                                |
    // +--------------------------------------------------------------+
    // | PURPOSE: MARS_TWN                                            |
    // |                                                              |
    // | REMARK :                                                     |
    // +--------------------------------------------------------------+

    // VERSION       ID            WHO    DATE        DESCRIPTION
    // TWN.01.09     RGS_TWN-INC01 NN     2017-04-24  INITIAL RELEASE    
    Caption = 'Vendor - Note Payable List';
    DefaultLayout = RDLC;
    RDLCLayout = 'ReportLayout\report50000.rdl';
    UsageCategory = ReportsAndAnalysis;
    dataset
    {
        dataitem(Vendor; Vendor)
        {
            DataItemTableView = sorting("No.");
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.";
            column(CompanyInfo_Name; CompanyInfo.Name)
            {
            }
            column(CompanyInfo_Address; CompanyInfo.Address + CompanyInfo."Address 2")
            {
            }
            column(TEL____CompanyInfo__Phone_No_______FAX____CompanyInfo__Fax_No__; 'TEL: ' + CompanyInfo."Phone No." + '   FAX: ' + CompanyInfo."Fax No.")
            {
            }
            column(ReportTitle_CaptionLbl; ReportTitle_CaptionLbl)
            {
            }
            //column(CurrReport_PAGENO; CurrReport.PAGENO)
            //{
            //}
            column(PrintDate; FORMAT(TODAY, 0, '<Year4>/<Month,2>/<Day,2>'))
            {
            }
            column(VendorName; Name)
            {
            }
            column(Vendor_Vendor__No__; "No.")
            {
            }
            column(STRSUBSTNO_SubTotal_CaptionLbl_Vendor_Name_; STRSUBSTNO(SubTotal_CaptionLbl, Vendor.Name))
            {
            }
            column(PrintDate_Caption; PrintDate_CaptionLbl)
            {
            }
            column(PageNo_CaptionLbl; PageNo_CaptionLbl)
            {
            }
            column(AmountCaption; AmountCaptionLbl)
            {
            }
            column(VendorNameCaption; VendorNameCaptionLbl)
            {
            }
            column(StatusCaption; StatusCaptionLbl)
            {
            }
            column(CheckNo_Caption; CheckNo_CaptionLbl)
            {
            }
            column(ExpectedCashDate_Caption; ExpectedCashDate_CaptionLbl)
            {
            }
            column(PostingDate_Caption; PostingDate_CaptionLbl)
            {
            }
            column(Total_Caption; Total_CaptionLbl)
            {
            }
            dataitem("Check Ledger Entry"; "Check Ledger Entry")
            {
                RequestFilterFields = "Check Date";
                DataItemLinkReference = Vendor;
                DataItemLink = "Bal. Account No." = field("No.");
                DataItemTableView = sorting("Document No.", "Posting Date") order(ascending) where("Bal. Account Type" = const(Vendor), "Note Type" = filter(NP));
                column(LCYAmount; LCYAmount)
                {
                    AutoFormatType = 1;
                }
                column(Check_Ledger_Entry__Check_Date_; FORMAT("Check Date", 0, '<Year4>/<Month,2>/<Day,2>'))
                {
                }
                column(Check_Ledger_Entry__Check_No__; "Check No.")
                {
                }
                column(StatusStr; StatusStr)
                {
                }
                column(Check_Ledger_Entry__Posting_Date_; FORMAT("Posting Date", 0, '<Year4>/<Month,2>/<Day,2>'))
                {
                }
                column(Check_Ledger_Entry_Entry_No_; "Entry No.")
                {
                }
                column(Check_Ledger_Entry_Bal__Account_No_; "Bal. Account No.")
                {
                }
                trigger OnAfterGetRecord()
                begin
                    //StatusStr := FORMAT("Entry Status");

                    WITH CheckStatusBuf DO BEGIN
                        SETFILTER("Check No. Filter", "Check No.");
                        SETFILTER("Posting Date Filter", CheckFilter.GETFILTER("Check Date"));
                        CALCFIELDS("Currency Date", "Currency Code", "Currency Rate", "Point Entry No.",
                                   "Point Entry Status", "Point Sub Status");
                        CurrencyCode := "Currency Code";
                        ExchRate := CurrExchRate.ExchangeAmtFCYToLCY("Currency Date", CurrencyCode, 1, "Currency Rate");
                        LCYAmount := Amount * ExchRate;
                        StatusStr := FORMAT("Point Entry Status");
                        IF "Point Sub Status" <> 0 THEN
                            StatusStr := FORMAT("Point Sub Status")
                    END;
                end;
            }
        }
    }

    requestpage
    {
        layout
        {
            area(content)
            {
                group(GroupName)
                {
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

    trigger OnInitReport()
    begin
        CompanyInfo.GET;
        CheckFilter.COPY("Check Ledger Entry");
    end;

    var
        CompanyInfo: Record "Company Information";
        CheckStatusBuf: Record "Check Ledger Entry buffer";
        CurrExchRate: Record "Currency Exchange Rate";
        CheckFilter: Record "Check Ledger Entry";
        ExchRate: Decimal;
        LCYAmount: Decimal;
        StatusStr: Text[30];
        CurrencyCode: Code[20];
        SubTotal_CaptionLbl: Label '%1 Sub Total :';
        PrintDate_CaptionLbl: Label 'Print Date :';
        PageNo_CaptionLbl: Label 'Page No : ';
        AmountCaptionLbl: Label 'Amount';
        VendorNameCaptionLbl: Label 'Vendor Name';
        StatusCaptionLbl: Label 'Status';
        CheckNo_CaptionLbl: Label 'Check No.';
        ExpectedCashDate_CaptionLbl: Label 'Expected Cash Date';
        PostingDate_CaptionLbl: Label 'Posting Date';
        Total_CaptionLbl: Label 'Total : ';
        ReportTitle_CaptionLbl: Label 'Vendor - Note Payable List';
}
