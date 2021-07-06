codeunit 1044864 "TW Sales Flow Event Handler"
{
    // +--------------------------------------------------------------+
    // | @ 2019 incadea Taiwan Limited                                |
    // +--------------------------------------------------------------+
    // | PURPOSE: MARS_TWN                                            |
    // |                                                              |
    // | REMARK :                                                     |
    // +--------------------------------------------------------------+

    // VERSION       ID            WHO    DATE        DESCRIPTION
    // 120527        RGS_TWN-847   GG     2019-09-09  New Object
    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnBeforeValidateEvent', 'VAT Registration No.', true, true)]
    local procedure TableSalesHeader_OnBeforeValidateVATRegistrationNoSub(var Rec: Record "Sales Header"; var xRec: Record "Sales Header"; CurrFieldNo: Integer)
    var
        GLSetupL: Record "General Ledger Setup";
        CustomerL: Record Customer;
    begin
        if CurrFieldNo <> Rec.FieldNo("VAT Registration No.") then
            exit;

        GLSetupL.GetRecordOnce();
        case GLSetupL."Bill-to/Sell-to VAT Calc." of
            GLSetupL."Bill-to/Sell-to VAT Calc."::"Bill-to/Pay-to No.":
                if not CustomerL.get(Rec."Bill-to Customer No.") then
                    exit;
            GLSetupL."Bill-to/Sell-to VAT Calc."::"Sell-to/Buy-from No.":
                if not CustomerL.get(Rec."Sell-to Customer No.") then
                    exit;
        end;

        if CustomerL."Central Maintenance" then
            xRec."VAT Registration No." := Rec."VAT Registration No.";
    end;

    [EventSubscriber(ObjectType::Page, Page::"Shopping Basket", 'OnBeforeActionEvent', 'Cre&ate Invoice and Post', true, false)]
    local procedure PageShoppingBasket_InvoiceAndPost_OnBeforeAction(var Rec: Record "Sales Header")
    begin
        // Start 120527 
        IF NOT IsSalesOrderExtendAlertAmt(Rec) THEN
            EXIT;
        IF CONFIRM(C_TWN_001) THEN
            EXIT;

        ERROR('');
        // Stop 120527 
    end;

    [EventSubscriber(ObjectType::Page, Page::"Sales Order", 'OnBeforeActionEvent', 'Cre&ate Invoice and Post', true, false)]
    local procedure PageSalesOrder_InvoiceAndPost_OnBeforeAction(var Rec: Record "Sales Header")
    begin
        // Start 120527 
        IF NOT IsSalesOrderExtendAlertAmt(Rec) THEN
            EXIT;
        IF CONFIRM(C_TWN_001) THEN
            EXIT;

        ERROR('');
        // Stop 120527 
    end;

    local procedure IsSalesOrderExtendAlertAmt(VAR SalesHeaderP: Record "Sales Header"): Boolean
    var
        SalesReceivablesSetupL: Record "Sales & Receivables Setup";
        SalesLineL: Record "Sales Line";
        TotalSalesHeaderL: Record "Sales Header";
        TotalSalesLineL: Record "Sales Line";
        DocumentTotalsL: Codeunit "Document Totals";
        RefreshMessageEnableL: Boolean;
        ControlStyleL: Text;
        RefreshMessageTextL: Text;
        InvDiscAmountEditableL: Boolean;
        CurrPageEditableL: Boolean;
        VATAmountL: Decimal;
    begin
        // Start 120527
        SalesReceivablesSetupL.GET;
        IF SalesReceivablesSetupL."Sales Alert Amount" <= 0 THEN
            EXIT(FALSE);

        SalesLineL.RESET;
        SalesLineL.SETRANGE("Document Type", SalesHeaderP."Document Type");
        SalesLineL.SETRANGE("Document No.", SalesHeaderP."No.");
        IF NOT SalesLineL.FINDLAST THEN
            EXIT(FALSE);

        CLEAR(DocumentTotalsL);
        DocumentTotalsL.SalesUpdateTotalsControls(
          SalesLineL,
          TotalSalesHeaderL,
          TotalSalesLineL,
          RefreshMessageEnableL,
          ControlStyleL,
          RefreshMessageTextL,
          InvDiscAmountEditableL,
          CurrPageEditableL,
          VATAmountL
          );

        EXIT(TotalSalesLineL."Amount Including VAT" >= SalesReceivablesSetupL."Sales Alert Amount");
        // Stop 120527
    end;

    var
        C_TWN_001: Label 'Sales Total Amount Include VAT is very high, Please Make sure the amount is correct or not!';
}
