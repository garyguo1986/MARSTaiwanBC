report 50002 "Note Payable List"
{
    // +--------------------------------------------------------------+
    // | @ 2017 incadea Taiwan Limited                                |
    // +--------------------------------------------------------------+
    // | PURPOSE: MARS_TWN                                            |
    // |                                                              |
    // | REMARK :                                                     |
    // +--------------------------------------------------------------+

    // VERSION       ID            WHO    DATE        DESCRIPTION
    // TWN.01.09     RGS_TWN-INC01 NN     2017-04-25  INITIAL RELEASE    
    Caption = 'Note Payable List';
    DefaultLayout = RDLC;
    RDLCLayout = 'ReportLayout\report50002.rdl';
    UsageCategory = ReportsAndAnalysis;
    dataset
    {
        dataitem(ReportHeader; Integer)
        {
            DataItemTableView = sorting(Number) where(Number = const(1));
            column(CompanyInfo_Name; CompanyInfo.Name)
            {
            }
            column(CompanyInfo_Address___CompanyInfo__Address_2_; CompanyInfo.Address + CompanyInfo."Address 2")
            {
            }
            column(TEL____CompanyInfo__Phone_No_______FAX____CompanyInfo__Fax_No__; 'TEL: ' + CompanyInfo."Phone No." + '   FAX: ' + CompanyInfo."Fax No.")
            {
            }
            column(ReportTitle_Caption; ReportTitle_CaptionLbl)
            {
            }
            column(PrintDate_Caption; PrintDate_CaptionLbl)
            {
            }
            column(PageNo_Caption; PageNo_CaptionLbl)
            {
            }
            column(AmountCaption; AmountCaptionLbl)
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
            column(ExpectedCashDateFilter_Caption; ExpectedCashDateFilter_CaptionLbl)
            {
            }
            column(CheckNoFilter_Caption; CheckNoFilter_CaptionLbl)
            {
            }
            column(Total_Caption; Total_CaptionLbl)
            {
            }
            column(TODAY; FORMAT(TODAY, 0, '<Year4>/<Month,2>/<Day,2>'))
            {
            }
            column(Check_Ledger_Entry__GETFILTER__Check_Date__; "Check Ledger Entry".GETFILTER("Check Date"))
            {
            }
            column(Check_Ledger_Entry__GETFILTER__Check_No___; "Check Ledger Entry".GETFILTER("Check No."))
            {
            }
        }
        dataitem("Check Ledger Entry"; "Check Ledger Entry")
        {
            DataItemTableView = sorting("Document No.", "Posting Date") order(ascending) where("Note Type" = filter(NP));
            RequestFilterFields = "Check No.", "Check Date", "Bal. Account No.";
            column(Check_Ledger_Entry__Posting_Date_; FORMAT("Posting Date", 0, '<Year4>/<Month,2>/<Day,2>'))
            {
            }
            column(Check_Ledger_Entry__Check_Date_; FORMAT("Check Date", 0, '<Year4>/<Month,2>/<Day,2>'))
            {
            }
            column(Check_Ledger_Entry__Check_No__; "Check No.")
            {
            }
            column(LCYAmount; LCYAmount)
            {
                AutoFormatType = 1;
            }
            column(StatusStr; StatusStr)
            {
            }
            trigger OnPreDataItem()
            begin
                //CurrReport.CREATETOTALS(TotalAmount);
            end;

            trigger OnAfterGetRecord()
            begin
                //StatusStr := FORMAT("Entry Status") ;

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
        ReportTitle_CaptionLbl: Label 'Note Payable List';
        PrintDate_CaptionLbl: Label 'Print Date :';
        PageNo_CaptionLbl: Label 'Page No : ';
        AmountCaptionLbl: Label 'Amount';
        StatusCaptionLbl: Label 'Status';
        CheckNo_CaptionLbl: Label 'Check No.';
        ExpectedCashDate_CaptionLbl: Label 'Expected Cash Date';
        PostingDate_CaptionLbl: Label 'Posting Date';
        ExpectedCashDateFilter_CaptionLbl: Label 'Expected Cash Date Filter:';
        CheckNoFilter_CaptionLbl: Label 'Check No. Filter:';
        Total_CaptionLbl: Label 'Total : ';
}
