report 50021 "Check Receipt"
{
    // +--------------------------------------------------------------+
    // | @ 2017 incadea Taiwan Limited                                |
    // +--------------------------------------------------------------+
    // | PURPOSE: MARS_TWN                                            |
    // |                                                              |
    // | REMARK :                                                     |
    // +--------------------------------------------------------------+

    // VERSION       ID                  WHO    DATE        DESCRIPTION
    // TWN.01.09     RGS_TWN-INC01_NPNR  AH     2017-06-05  INITIAL RELEASE    
    Caption = 'Check Receipt';
    DefaultLayout = RDLC;
    RDLCLayout = 'ReportLayout\report50021.rdl';
    UsageCategory = ReportsAndAnalysis;
    dataset
    {
        dataitem("Gen. Journal Line"; "Gen. Journal Line")
        {
            trigger OnAfterGetRecord()
            begin
                CLEAR(tempGenJournalLine);
                CLEAR(tempGenJournalLine2);
                tempGenJournalLine.RESET;
                tempGenJournalLine2.RESET;

                tempGenJournalLine2.COPY("Gen. Journal Line");
                tempGenJournalLine2.INSERT;


                tempGenJournalLine.SETFILTER(tempGenJournalLine."Journal Template Name", "Gen. Journal Line"."Journal Template Name");
                tempGenJournalLine.SETFILTER(tempGenJournalLine."Journal Batch Name", "Gen. Journal Line"."Journal Batch Name");
                tempGenJournalLine.SETFILTER(tempGenJournalLine."Document No.", "Gen. Journal Line"."Document No.");

                IF NOT tempGenJournalLine.FIND('-') THEN BEGIN
                    IF ("Gen. Journal Line"."Account Type" = "Gen. Journal Line"."Account Type"::"Bank Account") OR
                       ("Gen. Journal Line"."Bal. Account Type" = "Gen. Journal Line"."Bal. Account Type"::"Bank Account") THEN BEGIN
                        tempGenJournalLine.COPY("Gen. Journal Line");
                        tempGenJournalLine.INSERT;
                    END;
                END;
            end;
        }
        dataitem(Integer; Integer)
        {
            column(CompanyName; recCompanyInfo.Name)
            {
            }
            column(TitleName; FORMAT(TEXT001))
            {
            }
            column(PrintDateLb; PrintDateLb)
            {
            }
            column(PrintDate; TODAY)
            {
            }
            column(ReceiptNoLb; ReceiptNoLb)
            {
            }
            column(PostedNoteLb; PostedNoteLb)
            {
            }
            column(ReceivingSignatureLb; ReceivingSignatureLb)
            {
            }
            column(PayeeLb; PayeeLb)
            {
            }
            column(PayeeName; vendorName)
            {
            }
            column(CheckNoLb; CheckNoLb)
            {
            }
            column(CheckNo; tempGenJournalLine."Document No.")
            {
            }
            column(PostingDateLb; PostingDateLb)
            {
            }
            column(PostingDate; tempGenJournalLine."Posting Date")
            {
            }
            column(DateOfMaturityLb; DateOfMaturityLb)
            {
            }
            column(DateOfMaturity; tempGenJournalLine."Due Date")
            {
            }
            column(BankNameLb; BankNameLb)
            {
            }
            column(bankName; bankName)
            {
            }
            column(AmountLb; AmountLb)
            {
            }
            column(Amount; ABS(tempGenJournalLine.Amount))
            {
            }
            column(DescriptionLb; DescriptionLb)
            {
            }
            column(Description; tempGenJournalLine.Description)
            {
            }
            trigger OnPreDataItem()
            begin
                CLEAR(tempGenJournalLine);
                SETFILTER(Number, '%1..%2', 1, tempGenJournalLine.COUNT);
            end;

            trigger OnAfterGetRecord()
            var
                recVendor: Record Vendor;
                recBank: Record "Bank Account";
            begin
                CLEAR(vendorName);
                CLEAR(recVendor);
                CLEAR(bankName);
                CLEAR(currencyCode);
                CLEAR(recBank);
                recVendor.RESET;
                recBank.RESET;

                tempGenJournalLine.NEXT;

                currencyCode := tempGenJournalLine."Currency Code";

                CLEAR(tempGenJournalLine2);
                tempGenJournalLine2.RESET;
                tempGenJournalLine2.SETFILTER(tempGenJournalLine2."Journal Template Name", tempGenJournalLine."Journal Template Name");
                tempGenJournalLine2.SETFILTER(tempGenJournalLine2."Journal Batch Name", tempGenJournalLine."Journal Batch Name");
                tempGenJournalLine2.SETFILTER(tempGenJournalLine2."Document No.", tempGenJournalLine."Document No.");
                tempGenJournalLine2.SETFILTER(tempGenJournalLine2."Account Type", FORMAT(tempGenJournalLine2."Account Type"::Vendor));
                IF tempGenJournalLine2.FIND('-') THEN BEGIN
                    IF recVendor.GET(tempGenJournalLine2."Account No.") THEN BEGIN
                        vendorName := recVendor.Name;
                    END;
                END;

                CLEAR(tempGenJournalLine2);
                tempGenJournalLine2.RESET;
                tempGenJournalLine2.SETFILTER(tempGenJournalLine2."Journal Template Name", tempGenJournalLine."Journal Template Name");
                tempGenJournalLine2.SETFILTER(tempGenJournalLine2."Journal Batch Name", tempGenJournalLine."Journal Batch Name");
                tempGenJournalLine2.SETFILTER(tempGenJournalLine2."Document No.", tempGenJournalLine."Document No.");
                tempGenJournalLine2.SETFILTER(tempGenJournalLine2."Account Type", FORMAT(tempGenJournalLine2."Account Type"::"Bank Account"));
                IF tempGenJournalLine2.FIND('-') THEN BEGIN
                    IF recBank.GET(tempGenJournalLine2."Account No.") THEN BEGIN
                        bankName := recBank.Name;
                    END;
                END;

                IF bankName = '' THEN BEGIN
                    CLEAR(tempGenJournalLine2);
                    tempGenJournalLine2.RESET;
                    tempGenJournalLine2.SETFILTER(tempGenJournalLine2."Journal Template Name", tempGenJournalLine."Journal Template Name");
                    tempGenJournalLine2.SETFILTER(tempGenJournalLine2."Journal Batch Name", tempGenJournalLine."Journal Batch Name");
                    tempGenJournalLine2.SETFILTER(tempGenJournalLine2."Document No.", tempGenJournalLine."Document No.");
                    tempGenJournalLine2.SETFILTER(tempGenJournalLine2."Bal. Account Type",
                                                  FORMAT(tempGenJournalLine2."Bal. Account Type"::"Bank Account"));
                    IF tempGenJournalLine2.FIND('-') THEN BEGIN
                        IF recBank.GET(tempGenJournalLine2."Bal. Account No.") THEN BEGIN
                            bankName := recBank.Name;
                        END;
                    END;
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
        recCompanyInfo.GET;
    end;

    var
        recCompanyInfo: Record "Company Information";
        tempGenJournalLine: Record "Gen. Journal Line";
        vendorName: Text[50];
        currencyCode: Code[10];
        tempGenJournalLine2: Record "Gen. Journal Line";
        bankName: Text[50];
        TEXT001: Label 'Check Receipt';
        PrintDateLb: Label 'Print Date:';
        ReceiptNoLb: Label 'Check Receipt No.:';
        PostedNoteLb: Label 'Posted to Note';
        ReceivingSignatureLb: Label 'Receiving Signature';
        PayeeLb: Label 'Payee:';
        CheckNoLb: Label 'Check No.:';
        PostingDateLb: Label 'Posting Date:';
        DateOfMaturityLb: Label 'Date of Maturity:';
        BankNameLb: Label 'Bank Name:';
        AmountLb: Label 'Amount:';
        DescriptionLb: Label 'Description:';
}
