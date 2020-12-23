pageextension 1044876 pageextension1044876 extends "Shopping Basket"
{
    // #1..151
    // 070005 IT_20002 1CF 2013-08-09  Added Sales Document Statistics FactBox
    // #153..156
    // 070007 IT_20002 1CF 2013-10-09  Fixed Posting an Invoice or Order
    // 071000   IT_20071 FT    2013-11-12  assigned icons to BSS Actions
    // 071000   IT_20079 SG    2013-11-19  added BSS-Shortcuts and Mnemonics
    // 070010 IT_20002 1CF 2013-12-02  Add filters to SalesHistSellTo FactBox
    // #161..243
    // 
    // +--------------------------------------------------------------+
    // | @ 2017 incadea Taiwan Limited                                |
    // +--------------------------------------------------------------+
    // | PURPOSE: MARS_TWN                                            |
    // |                                                              |
    // +--------------------------------------------------------------+
    // 
    // VERSION     ID          WHO    DATE        DESCRIPTION
    // RGS_TWN-561 TWN_R03_T01 NN     2017-04-20  Add "Final Check Name" General
    //                         NN     2017-05-23  Move filed: "Fitter Code1" from Fastfit tab to General tab.
    // TWN.01.03   RGS_TWN-327 TWN_R11_T06 AH     2017-04-20  Add New Action "Customer Agreement"
    // TWN.01.09   RGW_TWN-524 NN     2017-05-04  Show "Campaign No." on page.
    // TWN.01.03   RGS_TWN-327 AH     2017-05-18  Add Field Personal Data Status, Personal Data Agreement on General Group
    // RGS_TWN-342             AH     2017-05-19  Add Field VAT Registration No., Bill-to Company Name on General Group
    // RGS_TWN-342             AH     2017-05-19  Remove VAT Registration No. From Foreign Trade
    // TWN.01.01   RGS_TWN-631 AH     2017-07-14  Add Check Item Tracking before create invoice and post
    Caption = 'Shopping Basket';
    PromotedActionCategories = 'New,Process,Report,Vehicle/TireHotel,Shop. Basket,Posting';
    layout
    {
        addafter(BAHSale)
        {
            field("Personal Data Status"; "Personal Data Status")
            {
            }
            field("Personal Data Agreement Date"; "Personal Data Agreement Date")
            {
            }
            field("Bill-to Company Name"; "Bill-to Company Name")
            {
            }
        }
        addafter("Representative Code")
        {
            field("Campaign No."; "Campaign No.")
            {
            }
        }
        addafter("Salesperson Code 2")
        {
            field("Final Check Name"; "Final Check Name")
            {
            }
        }
    }
    actions
    {
        addafter("&Avail. Credit")
        {
            action(Agreement)
            {
                Caption = 'Agreement';
                Image = PrintDocument;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunPageMode = View;

                trigger OnAction()
                var
                    AgreementL: Page "Customer Agreement List";
                begin
                    //++TEC.TWN_R11_T06
                    IF ("Sell-to Contact No." <> '') THEN BEGIN
                        CLEAR(AgreementL);
                        AgreementL.SetContact("Sell-to Contact No.");
                        AgreementL.RUNMODAL;
                    END;
                    //--TEC.TWN_R11_T06
                end;
            }
        }
    }
}

