pageextension 1073874 "Purchase Order Subform Ext" extends "Purchase Order Subform"
{
    // +--------------------------------------------------------------+
    // | @ 2017 incadea Taiwan Limited                                |
    // +--------------------------------------------------------------+
    // | PURPOSE: MARS_TWN                                            |
    // |                                                              |
    // | REMARK :                                                     |
    // +--------------------------------------------------------------+

    // VERSION       ID          WHO    DATE        DESCRIPTION
    // TWN.01.01     RGS_TWN-631 AH     2017-05-23  Add Item Tracking Line Action in MARSActionsLine ActionGroup.

    // +----------------------------------------------+
    // | Copyright (c) incadea China                  |
    // +----------------------------------------------+
    // TFS          ID             WHO    DATE        DESCRIPTION
    // 115321       MARS_TWN-6765  GG     2018-10-16  Remove default value for "Line No." visiable property and adjust Type and "Line No." position
    // RGS_TWN-874   122010        GG     2020-08-28  Block oct qty to receive (RGS_CHN-1540  120360)

    layout
    {
        modify(Type)
        {
            Editable = NotEditRetreadFieldsG and NonOCTOrderG;
        }
        modify("Line No.")
        {
            Editable = false;
        }
        modify("No.")
        {
            Editable = NotEditRetreadFieldsG and NonOCTOrderG;
        }
        modify(Description)
        {
            Editable = NotEditRetreadFieldsG and NonOCTOrderG;
        }
        modify("Description 2")
        {
            Editable = NotEditRetreadFieldsG and NonOCTOrderG;
        }
        modify("Price Locked")
        {
            Editable = NonOCTOrderG;
        }
        modify("Condition Locked")
        {
            Editable = NonOCTOrderG;
        }
        modify("Location Code")
        {
            Editable = NonOCTOrderG;
        }
        modify(Quantity)
        {
            Editable = NotEditRetreadFieldsG and NonOCTOrderG;
        }
        modify("Unit of Measure Code")
        {
            Editable = NonOCTOrderG;
        }
        modify("Unit of Measure")
        {
            Editable = NonOCTOrderG;
        }
        // modify("Direct Unit Cost")
        // {
        //     Editable = NonOCTOrderG;
        // }
        modify("Alternative Condition Table")
        {
            Editable = NonOCTOrderG;
        }
        modify("Indirect Cost %")
        {
            Editable = NonOCTOrderG;
        }
        modify("CB-Price")
        {
            Editable = NonOCTOrderG;
        }
        modify("Unit Price (LCY)")
        {
            Editable = NonOCTOrderG;
        }
        modify("Line Amount")
        {
            Editable = NonOCTOrderG;
        }
        modify("Line Discount %")
        {
            Editable = NonOCTOrderG;
        }
        modify("Line Discount Amount")
        {
            Editable = NonOCTOrderG;
        }
        modify("Prepayment %")
        {
            Editable = NonOCTOrderG;
        }
        modify("Qty. to Invoice")
        {
            Editable = NonOCTOrderG;
        }
        modify("Requested Receipt Date")
        {
            Editable = NonOCTOrderG;
        }
        modify("Promised Receipt Date")
        {
            Editable = NonOCTOrderG;
        }
        modify("Planned Receipt Date")
        {
            Editable = NonOCTOrderG;
        }
        modify("Expected Receipt Date")
        {
            Editable = NonOCTOrderG;
        }
        modify("Order Date")
        {
            Editable = NonOCTOrderG;
        }
        modify("Lead Time Calculation")
        {
            Editable = NonOCTOrderG;
        }
        modify("Deferral Code")
        {
            Editable = NonOCTOrderG;
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        //++MIL1.00.001.120868.QX
        Clear(PurchaseHeaderG);
        if PurchaseHeaderG.Get("Document Type", "Document No.") then;
        NotEditRetreadFieldsG := NOT (("Retread Order No." <> '') AND (Type = Type::Item));
        NonOCTOrderG := PurchaseHeaderG."OCT Order No." = '';
        //--MIL1.00.001.120868.QX
    end;

    var
        PurchaseHeaderG: Record "Purchase Header";
        NotEditRetreadFieldsG: Boolean;
        NonOCTOrderG: Boolean;
}
