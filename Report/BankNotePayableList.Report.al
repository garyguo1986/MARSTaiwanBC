report 50001 "Bank - Note Payable List"
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
    Caption = 'Bank - Note Payable List';
    DefaultLayout = RDLC;
    RDLCLayout = 'ReportLayout\report50001.rdl';
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
            column(PrintDate; FORMAT(TODAY, 0, '<Year4>/<Month,2>/<Day,2>'))
            {
            }
            column(PrintDate_Caption; PrintDate_CaptionLbl)
            {
            }
            column(PageNo_Caption; PageNo_CaptionLbl)
            {
            }
            column(BankAccName_Caption; BankAccName_CaptionLbl)
            {
            }
            column(PostingDate_Caption; PostingDate_CaptionLbl)
            {
            }
            column(ExpectedCashDate_Caption; ExpectedCashDate_CaptionLbl)
            {
            }
            column(CheckNo_Caption; CheckNo_CaptionLbl)
            {
            }
            column(CurrCode_Caption; CurrCode_CaptionLbl)
            {
            }
            column(ExchRate_Caption; ExchRate_CaptionLbl)
            {
            }
            column(Amount_Caption; Amount_CaptionLbl)
            {
            }
            column(AmountLCY_Caption; AmountLCY_CaptionLbl)
            {
            }
            column(StatusCaption; Status_CaptionLbl)
            {
            }
            column(Total_Caption; Total_CaptionLbl)
            {
            }
        }
        dataitem("Bank Account"; "Bank Account")
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.";
            PrintOnlyIfDetail = true;
            column(Bank_Account_Name; Name)
            {
            }
            column(Bank_Account_No_; "No.")
            {
            }
            column(STRSUBSTNO_SubTotal_CaptionLbl_Bank_Account__Name_; STRSUBSTNO(SubTotal_CaptionLbl, Name))
            {
            }
            dataitem("Check Ledger Entry"; "Check Ledger Entry")
            {
                DataItemTableView = sorting("Document No.", "Posting Date") order(ascending) where("Note Type" = filter(NP));
                DataItemLinkReference = "Bank Account";
                DataItemLink = "Bal. Account No." = field("No.");
                RequestFilterFields = "Check Date";
                column(Check_Ledger_Entry__Amount;
                Amount)
                {
                }
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
                column(CurrencyCode; CurrencyCode)
                {
                }
                column(ExchRate; ExchRate)
                {
                    AutoFormatType = 2;
                    AutoFormatExpression = CurrencyCode;
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
        CompanyInfo.Get();
        //CheckFilter.COPY("Check Ledger Entry");
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
        ReportTitle_CaptionLbl: Label 'Bank - Note Payable List';
        SubTotal_CaptionLbl: Label '%1 Sub Total :';
        PrintDate_CaptionLbl: Label 'Today';
        PageNo_CaptionLbl: Label 'Page No : ';
        AmountLCY_CaptionLbl: Label 'Amount (LCY)';
        BankAccName_CaptionLbl: Label 'Bank Account Name';
        Amount_CaptionLbl: Label 'Amount';
        Status_CaptionLbl: Label 'Status';
        CheckNo_CaptionLbl: Label 'Check No.';
        ExpectedCashDate_CaptionLbl: Label 'Expected Cash Date';
        PostingDate_CaptionLbl: Label 'Posting Date';
        CurrCode_CaptionLbl: Label 'Curr. Code';
        ExchRate_CaptionLbl: Label 'Exch. Rate';
        Total_CaptionLbl: Label 'Total : ';
        NextPage_CaptionLbl: Label 'Next Page';
}
