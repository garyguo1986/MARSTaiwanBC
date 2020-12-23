report 50003 "Customer- Note Receivable List"
{
    // +--------------------------------------------------------------+
    // | @ 2017 Tectura Taiwan Limited                                |
    // +--------------------------------------------------------------+
    // | PURPOSE: MARS_TWN                                            |
    // |                                                              |
    // | REMARK :                                                     |
    // +--------------------------------------------------------------+

    // VERSION       ID            WHO    DATE        DESCRIPTION
    // TWN.01.09     RGS_TWN-INC01 NN     2017-04-25  INITIAL RELEASE    
    Caption = 'Customer- Note Receivable List';
    DefaultLayout = RDLC;
    RDLCLayout = 'ReportLayout\report50003.rdl';
    UsageCategory = ReportsAndAnalysis;
    dataset
    {
        dataitem(Customer; Customer)
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.";
            PrintOnlyIfDetail = true;
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
            column(TODAY; FORMAT(TODAY, 0, '<Year4>/<Month,2>/<Day,2>'))
            {
            }
            column(Customer_Customer_Name; Name)
            {
            }
            column(Customer_Customer__No__; "No.")
            {
            }
            column(STRSUBSTNO_SubTotal_CaptionLbl_Customer_Name_; STRSUBSTNO(SubTotal_CaptionLbl, Customer.Name))
            {
            }
            column(PrintDate_Caption; PrintDate_CaptionLbl)
            {
            }
            column(PageNo_Caption; PageNo_CaptionLbl)
            {
            }
            column(AmountCaption; Amount_CaptionLbl)
            {
            }
            column(CustName_Caption; CustName_CaptionLbl)
            {
            }
            column(StatusCaption; Status_CaptionLbl)
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
                DataItemLinkReference = Customer;
                DataItemTableView = sorting("Document No.", "Posting Date") order(ascending) where("Bal. Account Type" = const(Customer), "Note Type" = filter(NR));
                DataItemLink = "Bal. Account No." = field("No.");
                RequestFilterFields = "Check Date";
                column(LCYAmount; -LCYAmount)
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
                trigger OnPreDataItem()
                begin
                    //CurrReport.CREATETOTALS(SubAmount);
                end;

                trigger OnAfterGetRecord()
                begin
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

                    SubAmount := LCYAmount;
                    TotalAmount += LCYAmount;
                end;
            }
            trigger OnPreDataItem()
            begin
                //CurrReport.CREATETOTALS(TotalAmount);
            end;

            trigger OnAfterGetRecord()
            begin
                //TotalAmount := SubAmount;
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
        CheckFilter.COPY("Check Ledger Entry");
        CompanyInfo.GET;
    end;

    var
        CompanyInfo: Record "Company Information";
        CheckStatusBuf: Record "Check Ledger Entry buffer";
        CurrExchRate: Record "Currency Exchange Rate";
        CheckFilter: Record "Check Ledger Entry";
        SubAmount: Decimal;
        TotalAmount: Decimal;
        ExchRate: Decimal;
        LCYAmount: Decimal;
        StatusStr: Text[30];
        CurrencyCode: Code[20];
        ReportTitle_CaptionLbl: Label 'Customer - Note Receivable List';
        SubTotal_CaptionLbl: Label '%1 Sub Total :';
        PrintDate_CaptionLbl: Label 'Print Date :';
        PageNo_CaptionLbl: Label 'Page No : ';
        Amount_CaptionLbl: Label 'Amount';
        CustName_CaptionLbl: Label 'Customer Name';
        Status_CaptionLbl: Label 'Status';
        CheckNo_CaptionLbl: Label 'Check No.';
        ExpectedCashDate_CaptionLbl: Label 'Expected Cash Date';
        PostingDate_CaptionLbl: Label 'Posting Date';
        Total_CaptionLbl: Label 'Total : ';
}
