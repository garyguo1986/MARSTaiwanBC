pageextension 1044875 pageextension1044875 extends "Contact Card"
{
    // +--------------------------------------------------------------+
    // | ?2005 ff. Begusch Software Systeme                          |
    // #3..76
    // 
    // +--------------------------------------------------------------+
    // | @ 2017 incadea Taiwan Limited                                |
    // +--------------------------------------------------------------+
    // | PURPOSE: MARS_TWN                                            |
    // |                                                              |
    // +--------------------------------------------------------------+
    // 
    // VERSION     ID          WHO    DATE        DESCRIPTION
    // TWN.01.03   RGS_TWN-327 AH     2017-04-21  Add fields: Personal Data Status, Personal Data Agreement on General Group
    // TWN.01.03   RGS_TWN-327 AH     2017-04-21  Add New Action "Customer Agreement"
    // TWN.01.05   RGS_TWN-629 NN     2017-04-22  Add "Phone No. 2"
    // RGS_TWN-426             NN     2017-04-22  Add "Mobile Phone No. 2" & "Date of Birth"
    // RGS_TWN-T30             AH     2017-05-19  Chage to allow "Person" and "Company" both able to insert VAT Registration No.
    // RGS_TWN-342             AH     2017-05-19  Show "Bill-to Company Name" Field on Foreign Trade tab
    // RGS_TWN-342             AH     2017-05-19  Disable Editable "Bill-to Company Name" When "Central Maintenance" is True
    // TWN.01.01   RGW_TWN-425 NN     2017-06-01  Added PageAction - Report TWN Daily Sales Register
    Caption = 'Contact Card';
    PromotedActionCategories = 'New,Process,Report,Manage,Dummy5,Dummy6,Dummy7,Dummy8,Contact,History';
    layout
    {
        addafter("Deleted by HQ")
        {
            field("Personal Data Status"; "Personal Data Status")
            {
            }
            field("Personal Data Agreement Date"; "Personal Data Agreement Date")
            {
            }
        }
        addafter("Fax No.")
        {
            field("Phone No. 2"; "Phone No. 2")
            {
            }
            field("Mobile Phone No. 2"; "Mobile Phone No. 2")
            {
            }
        }
        addafter("VAT Registration No.")
        {
            field("Bill-to Company Name"; "Bill-to Company Name")
            {
                Editable = BilltoCompanyNameEditableG;
            }
        }
    }
    actions
    {
        addafter(ContactCoverSheet)
        {
            action("TWN Daily Sales Register")
            {
                Caption = 'TWN Daily Sales Register';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";

                trigger OnAction()
                var
                    SalesInvHeaderL: Record "Sales Invoice Header";
                    TWNDailySalesReportL: Report "TWN Daily Sales Register";
                begin
                    //++Inc.TWN-425.NN
                    CLEAR(SalesInvHeaderL);
                    SalesInvHeaderL.SETFILTER("Posting Date", '%1..%2', DMY2DATE(1, 1, 2013), TODAY);
                    SalesInvHeaderL.SETRANGE("Sell-to Contact No.", "No.");
                    TWNDailySalesReportL.SETTABLEVIEW(SalesInvHeaderL);
                    TWNDailySalesReportL.RUN;
                    //--Inc.TWN-425.NN
                end;
            }
        }
    }

    var
        [InDataSet]
        BilltoCompanyNameEditableG: Boolean;

    procedure SetBilltoCompanyNameEditable(BilltoCompanyNameEditableP: Boolean)
    begin
        BilltoCompanyNameEditableG := BilltoCompanyNameEditableP;
    end;
}

