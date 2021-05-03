pageextension 1073870 "Customer Card Ext" extends "Customer Card"
{
    // +--------------------------------------------------------------+
    // | @ 2017 incadea Taiwan Limited                                |
    // +--------------------------------------------------------------+
    // | PURPOSE: MARS_TWN                                            |
    // |                                                              |
    // +--------------------------------------------------------------+

    // VERSION      ID           WHO    DATE        DESCRIPTION
    // RGS_TWN-342               AH     2017-05-19  Show "Bill-to Company Name" Field on Invoice tab
    // RGS_TWN-342               AH     2017-05-19  Disable Editable "Bill-to Company Name" When "Central Maintenance" is True
    // TWN.01.01    RGS_TWN-425  NN     2017-06-01  Added PageAction - Report TWN Daily Sales Register
    // TWN.01.05    RGS_TWN-532  AH     2017-09-04  AssistEdit Properity of No. set to False
    // RGS_TWN-7889  121697   	  QX	   2020-05-25  Create a pop out window to alert can't modify customer card 
    layout
    {
        modify("No.")
        {
            AssistEdit = false;
        }
        addafter("VAT Registration No.")
        {
            field("Bill-to Company Name"; "Bill-to Company Name")
            {
                Editable = VATRegistrationNoEditableG;
            }
        }

    }
    actions
    {
        addafter("Report Customer - Balance to Date")
        {
            action("TWN Daily Sales Register")
            {
                Caption = 'TWN Daily Sales Register';
                Image = Report;
                Promoted = true;
                PromotedCategory = Report;
                trigger OnAction()
                var
                    SalesInvHeaderL: Record "Sales Invoice Header";
                    TWNDailySalesReportL: Report "TWN Daily Sales Register";
                begin
                    //++Inc.TWN-425.NN
                    CLEAR(SalesInvHeaderL);
                    SalesInvHeaderL.SETFILTER("Posting Date", '%1..%2', DMY2DATE(1, 1, 2013), TODAY);
                    SalesInvHeaderL.SETRANGE("Sell-to Customer No.", "No.");
                    TWNDailySalesReportL.SETTABLEVIEW(SalesInvHeaderL);
                    TWNDailySalesReportL.RUN;
                    //--Inc.TWN-425.NN
                end;
            }
        }
    }
    trigger OnOpenPage()
    begin
        VATRegistrationNoEditableG := NOT Rec."Central Maintenance";
    end;

    [IntegrationEvent(false, false)]
    local procedure OnResetMaintenance(Customer: Record Customer)
    begin
        //++TWN1.00.001.121697.QX
        //--TWN1.00.001.121697.QX
    end;

    var
        VATRegistrationNoEditableG: Boolean;
}
