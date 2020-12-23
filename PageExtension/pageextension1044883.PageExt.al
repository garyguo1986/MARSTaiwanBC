pageextension 1044883 pageextension1044883 extends "Contact Search Results"
{
    // +--------------------------------------------------------------+
    // | ?2005 ff. Begusch Software Systeme                          |
    // #3..74
    // 
    // +--------------------------------------------------------------+
    // | @ 2017 incadea Taiwan Limited                                |
    // +--------------------------------------------------------------+
    // | PURPOSE: MARS_TWN                                            |
    // |                                                              |
    // | REMARK :                                                     |
    // +--------------------------------------------------------------+
    // 
    // VERSION       ID          WHO    DATE        DESCRIPTION
    // RGS_TWN-519               AH     2017-05-24  Add two fields "Mobile Phone No.", "VAT Registration No." to Search Result tab.
    // RGS_TWN-7885  121696     QX   2020-05-25  Added a field Registration Date
    Caption = 'Contact Search Results';
    layout
    {
        addafter(City)
        {
            field("Mobile Phone No."; "Mobile Phone No.")
            {
                Caption = 'Mobile Phone No.';
            }
            field("VAT Registration No."; "VAT Registration No.")
            {
            }
        }
        addafter("Licence-Plate No.")
        {
            field("Registration Date"; "Registration Date")
            {
            }
        }
    }
    actions
    {
        addfirst(reporting)
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
                    SalesInvLineL: Record "Sales Invoice Line";
                    TWNDailySalesReportL: Report "TWN Daily Sales Register";
                begin
                    // Start RGS_TWN-425
                    CLEAR(SalesInvHeaderL);
                    SalesInvHeaderL.SETFILTER("Posting Date", '%1..%2', DMY2DATE(1, 1, 2013), TODAY);
                    IF Type = Type::Vehicle THEN
                        SalesInvHeaderL.SETRANGE("Vehicle No.", "Vehicle No.");
                    IF Type = Type::Contact THEN
                        SalesInvHeaderL.SETRANGE("Sell-to Contact No.", "No.");
                    TWNDailySalesReportL.SETTABLEVIEW(SalesInvHeaderL);
                    TWNDailySalesReportL.RUN;
                    // Stop RGS_TWN-425
                end;
            }
        }
    }
}

