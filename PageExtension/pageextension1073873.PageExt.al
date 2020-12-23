pageextension 1073873 pageextension1073873 extends "Purchase Order"
{
    // +--------------------------------------------------------------+
    // | @ 2020 incadea Taiwan Limited                                |
    // +--------------------------------------------------------------+
    // | PURPOSE: MARS_TWN                                            |
    // |                                                              |
    // | REMARK :                                                     |
    // +--------------------------------------------------------------+

    // VERSION       ID            WHO    DATE        DESCRIPTION
    // RGS_TWN-874   122010        GG     2020-08-28  Added field "OCT Order No." (RGS_CHN-1540  120360)    
    layout
    {
        modify("No.")
        {
            Editable = NonOCTOrderG;
        }
        modify(VendorSearchText)
        {
            Editable = NonOCTOrderG;
        }
        modify("Buy-from Vendor No.")
        {
            Editable = NonOCTOrderG;
        }
        modify("Buy-from Contact No.")
        {
            Editable = NonOCTOrderG;
        }
        modify("Buy-from Vendor Name")
        {
            Editable = NonOCTOrderG;
        }
        modify("Buy-from Vendor Name 2")
        {
            Editable = NonOCTOrderG;
        }
        modify("Buy-from Address")
        {
            Editable = NonOCTOrderG;
        }
        modify("Buy-from Address 2")
        {
            Editable = NonOCTOrderG;
        }
        modify("Buy-from Post Code")
        {
            Editable = NonOCTOrderG;
        }
        modify("Buy-from City")
        {
            Editable = NonOCTOrderG;
        }
        modify("Buy-from Contact")
        {
            Editable = NonOCTOrderG;
        }
        modify("Your Reference")
        {
            Editable = NonOCTOrderG;
        }
        modify("Document Date")
        {
            Editable = NonOCTOrderG;
        }
        modify("Quote No.")
        {
            Editable = NonOCTOrderG;
        }

        addafter("Quote No.")
        {
            field("OCT Order No."; "OCT Order No.")
            {
                ApplicationArea = All;
            }
        }
        modify("Vendor Order No.")
        {
            Editable = NonOCTOrderG;
        }
        modify("Vendor Shipment No.")
        {
            Editable = NonOCTOrderG;
        }
        modify("Vendor Shipment Date")
        {
            Editable = VendorShipmentDateEditableG and NonOCTOrderG;
        }
        modify("Vendor Invoice No.")
        {
            Editable = NonOCTOrderG;
        }
        modify("Order Address Code")
        {
            Editable = NonOCTOrderG;
        }
        modify("Purchaser Code")
        {
            Editable = NonOCTOrderG;
        }
        modify("Service Center")
        {
            Editable = NonOCTOrderG;
        }
        modify("Assigned User ID")
        {
            Editable = NonOCTOrderG;
        }
        modify("Sent to Vendor")
        {
            Editable = NonOCTOrderG;
        }
        modify("Date Sent to Vendor")
        {
            Editable = NonOCTOrderG;
        }
        modify("Pay-to Contact No.")
        {
            Editable = NonOCTOrderG;
        }
        modify("Pay-to Contact")
        {
            Editable = NonOCTOrderG;
        }
        modify("Pay-to Name")
        {
            Editable = NonOCTOrderG;
        }
        modify("Pay-to Address")
        {
            Editable = NonOCTOrderG;
        }
        modify("Pay-to Address 2")
        {
            Editable = NonOCTOrderG;
        }
        modify("Pay-to Post Code")
        {
            Editable = NonOCTOrderG;
        }
        modify("Pay-to City")
        {
            Editable = NonOCTOrderG;
        }
        modify("Alternative Condition Table")
        {
            Editable = NonOCTOrderG;
        }
        modify("Cash Payment Document Type")
        {
            Editable = NonOCTOrderG;
        }
        modify("Purchase Consignment")
        {
            Editable = NonOCTOrderG;
        }
        modify("Order Price Print Indicator")
        {
            Editable = NonOCTOrderG;
        }
        modify("Shortcut Dimension 1 Code")
        {
            Editable = NonOCTOrderG;
        }
        modify("Shortcut Dimension 2 Code")
        {
            Editable = NonOCTOrderG;
        }
        modify("Payment Terms Code")
        {
            Editable = NonOCTOrderG;
        }
        modify("Due Date")
        {
            Editable = NonOCTOrderG;
        }
        modify("Payment Discount %")
        {
            Editable = NonOCTOrderG;
        }
        modify("Pmt. Discount Date")
        {
            Editable = NonOCTOrderG;
        }
        modify("Payment Method Code")
        {
            Editable = NonOCTOrderG;
        }
        modify("Payment Reference")
        {
            Editable = NonOCTOrderG;
        }
        modify("Creditor No.")
        {
            Editable = NonOCTOrderG;
        }
        modify("On Hold")
        {
            Editable = NonOCTOrderG;
        }
        modify("Prices Including VAT")
        {
            Editable = NonOCTOrderG;
        }
        modify("VAT Bus. Posting Group")
        {
            Editable = NonOCTOrderG;
        }
        modify("Ship-to Name")
        {
            Editable = NonOCTOrderG;
        }
        modify("Ship-to Address")
        {
            Editable = NonOCTOrderG;
        }
        modify("Ship-to Address 2")
        {
            Editable = NonOCTOrderG;
        }
        modify("Ship-to Post Code")
        {
            Editable = NonOCTOrderG;
        }
        modify("Ship-to City")
        {
            Editable = NonOCTOrderG;
        }
        modify("Ship-to Contact")
        {
            Editable = NonOCTOrderG;
        }
        modify(Control99)
        {
            Editable = NonOCTOrderG;
        }
        modify(Control1000000011)
        {
            Editable = NonOCTOrderG;
        }
        modify("Currency Code")
        {
            Editable = NonOCTOrderG;
        }
        modify("Transaction Type")
        {
            Editable = NonOCTOrderG;
        }
        modify("Transaction Specification")
        {
            Editable = NonOCTOrderG;
        }
        modify("Transport Method")
        {
            Editable = NonOCTOrderG;
        }
        modify("Entry Point")
        {
            Editable = NonOCTOrderG;
        }
        modify("Area")
        {
            Editable = NonOCTOrderG;
        }
        modify("EDI Order Type")
        {
            Editable = NonOCTOrderG;
        }
        modify("EDI Lost Order Indicator")
        {
            Editable = NonOCTOrderG;
        }
    }
    trigger OnAfterGetCurrRecord()
    begin
        //++MIL1.00.001.120360.QX
        NonOCTOrderG := "OCT Order No." = '';
        if "EDI Order Created" then
            VendorShipmentDateEditableG := false
        else
            VendorShipmentDateEditableG := true;
        //--MIL1.00.001.120360.QX
    end;

    var
        NonOCTOrderG: Boolean;
        VendorShipmentDateEditableG: Boolean;
}
