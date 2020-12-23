pageextension 1044863 pageextension1044863 extends "Sales Order"
{
    // #1..135
    // 070003嚙?0001 1CF嚙?-07-15  Upgraded to NAV 7
    // #137..230
    // 
    // +--------------------------------------------------------------+
    // | @ 2017 incadea Taiwan Limited                                |
    // +--------------------------------------------------------------+
    // | PURPOSE: MARS_TWN                                            |
    // |                                                              |
    // +--------------------------------------------------------------+
    // 
    // VERSION       ID          WHO    DATE        DESCRIPTION
    // RGS_TWN-561   TWN_R03_T01 NN     2017-04-20  Add "Final Check Name"
    // TWN.01.03     RGS_TWN-327 AH     2017-04-20  Add New Action "Customer Agreement"
    // TWN.01.09     RGW_TWN-524 NN     2017-05-04  Show "Campaign No." on page.
    // TWN.01.03     RGS_TWN-327 AH     2017-05-19  Add Field  Personal Data Status, Personal Data Agreement on General Group
    // RGS_TWN-342               AH     2017-05-19  Add Field VAT Registration No., Bill-to Company Name on General Group
    // RGS_TWN-342               AH     2017-05-19  Remove VAT Registration No. From Foreign Trade
    Caption = 'Sales Order';
    PromotedActionCategories = 'New,Process,Report,Approve,Release,Posting,Prepare,Invoice,Request Approval,Vehicle/TireHotel';
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
        addafter("Salesperson Code 2")
        {
            field("Final Check Name"; "Final Check Name")
            {
            }
        }
    }
    actions
    {
        addafter("Item Account")
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
                    //++Inc.TWN-327.AH
                    IF ("Sell-to Contact No." <> '') THEN BEGIN
                        CLEAR(AgreementL);
                        AgreementL.SetContact("Sell-to Contact No.");
                        AgreementL.RUNMODAL;
                    END;
                    //--Inc.TWN-327.AH
                end;
            }
        }
    }
}

