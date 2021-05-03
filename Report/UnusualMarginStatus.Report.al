report 1044863 "Unusual Margin Status"
{
    // +--------------------------------------------------------------+
    // | ?2011 ff. Begusch Software Systeme                          |
    // +--------------------------------------------------------------+
    // | PURPOSE: additions for BSS.tire                              |
    // +--------------------------------------------------------------+
    // 
    // VERSION  ID      WHO    DATE        DESCRIPTION
    // 050111   IT_6231 SS     2011-03-08  INITIAL RELEASE
    // 050111   IT_6335 SP     2011-04-11  layout change
    // 
    // +--------------------------------------------------------------+
    // | ?2012 ff. Begusch Software Systeme                          |
    // +--------------------------------------------------------------+
    // | PURPOSE: MARS                                                |
    // +--------------------------------------------------------------+
    // 
    // MARS_R3.00.00 IT_6977 AP     2012-05-29  added MUT call
    // 
    // --------------------------------------------------------------+
    // | @ 2013 Tectura Taiwan Limited                                |
    // +--------------------------------------------------------------+
    // | PURPOSE: MARS_TWN                                            |
    // |                                                              |
    // | REMARK :                                                     |
    // +--------------------------------------------------------------+
    // 
    // VERSION   ID          WHO    DATE        DESCRIPTION
    // TWN.01.22 RGS_TWN-555 BH     2015-04-22  Layout Change and Date format.
    DefaultLayout = RDLC;
    RDLCLayout = './Report/UnusualMarginStatus.rdlc';

    Caption = 'Unusual Margin Status';

    dataset
    {
        dataitem("Sales Invoice Line"; "Sales Invoice Line")
        {
            DataItemTableView = WHERE(Type = FILTER(Item | Resource),
                                      Quantity = FILTER(<> 0));
            RequestFilterFields = "Responsibility Center";
            column(FORMAT_TODAY_0___Year4___Month_2___Day_2___; FORMAT(TODAY, 0, '<Year4>/<Month,2>/<Day,2>'))
            {
            }
            column(COMPANYNAME; COMPANYNAME)
            {
            }
            column(CurrReport_PAGENO; CurrReport.PAGENO)
            {
            }
            column(USERID; USERID)
            {
            }
            column(Sales_Invoice_Line__Document_No__; "Document No.")
            {
            }
            column(Sales_Invoice_Line__Line_No__; "Line No.")
            {
            }
            column(Sales_Invoice_Line_Type; Type)
            {
            }
            column(Sales_Invoice_Line__No__; "No.")
            {
            }
            column(Sales_Invoice_Line_Description; Description)
            {
            }
            column(Sales_Invoice_Line__Posting_Date_; "Posting Date")
            {
            }
            column(Sales_Invoice_Line__Unit_Cost_; "Unit Cost")
            {
            }
            column(Sales_Invoice_Line__Amount__Sales_Invoice_Line__Quantity; "Sales Invoice Line".Amount / "Sales Invoice Line".Quantity)
            {
            }
            column(ProfitPerc; ProfitPerc)
            {
            }
            column(Sales_Invoice_Line__Description_2_; "Description 2")
            {
            }
            column(Sales_Invoice_LineCaption; Sales_Invoice_LineCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Sales_Invoice_Line__Document_No__Caption; FIELDCAPTION("Document No."))
            {
            }
            column(Sales_Invoice_Line__Line_No__Caption; FIELDCAPTION("Line No."))
            {
            }
            column(Sales_Invoice_Line_TypeCaption; FIELDCAPTION(Type))
            {
            }
            column(Sales_Invoice_Line__No__Caption; FIELDCAPTION("No."))
            {
            }
            column(Sales_Invoice_Line_DescriptionCaption; FIELDCAPTION(Description))
            {
            }
            column(Sales_Invoice_Line__Posting_Date_Caption; FIELDCAPTION("Posting Date"))
            {
            }
            column(Sales_Invoice_Line__Unit_Cost_Caption; FIELDCAPTION("Unit Cost"))
            {
            }
            column(Unit_PriceCaption; Unit_PriceCaptionLbl)
            {
            }
            column(Profit_Caption; Profit_CaptionLbl)
            {
            }
            column(Sales_Invoice_Line_Responsibility_Center; "Responsibility Center")
            {
            }

            trigger OnAfterGetRecord()
            begin
                Profit := 0;
                ProfitPerc := 0;

                Profit := Amount - ("Unit Cost" * Quantity);

                IF (Profit <> 0) AND (Amount <> 0) THEN
                    ProfitPerc := (Profit * 100) / Amount;

                IF (ProfitPerc > Percentage) OR ("Unit Cost" = 0) THEN
                    CurrReport.SKIP;
            end;
        }
    }

    requestpage
    {

        layout
        {
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
        //++BSS.IT_6977.AP
        MUTFuncs.AddUsageTrackingEntry('MUT_6300');
        //--BSS.IT_6977.AP
    end;

    var
        Percentage: Decimal;
        ProfitPerc: Decimal;
        Profit: Decimal;
        MUTFuncs: Codeunit "Usage Tracking";
        Sales_Invoice_LineCaptionLbl: Label 'Sales Invoice Line';
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        Unit_PriceCaptionLbl: Label 'Unit Price';
        Profit_CaptionLbl: Label 'Profit%';
}

