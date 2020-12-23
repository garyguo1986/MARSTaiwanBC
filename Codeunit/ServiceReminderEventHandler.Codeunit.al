codeunit 1044865 "Service Reminder Event Handler"
{

    // +--------------------------------------------------------------+
    // | @ 2019 incadea Taiwan Limited                                |
    // +--------------------------------------------------------------+
    // | PURPOSE: MARS_TWN                                            |
    // |                                                              |
    // | REMARK :                                                     |
    // +--------------------------------------------------------------+

    // VERSION       ID            WHO    DATE        DESCRIPTION
    // 121389	     MARS_TWN_6770  GG     2020-02-28  New object to create event handler function

    [EventSubscriber(ObjectType::Table, Database::"Notification Sending Header", 'OnAfterInsertEvent', '', true, false)]
    local procedure TableNotificationSendingHeader_OnAfterInsert(RunTrigger: Boolean; var Rec: Record "Notification Sending Header")
    var
        ServiceCenterL: Record "Service Center";
        ServiceCenterCodeL: Code[20];
    begin
        IF (NOT RunTrigger) THEN
            EXIT;

        ServiceCenterCodeL := GetServiceCenterFromNotiSendHeader(Rec);
        IF (ServiceCenterCodeL <> '') THEN BEGIN
            Rec.VALIDATE("Service Center", ServiceCenterCodeL);
            IF ServiceCenterL.GET(Rec."Service Center") THEN BEGIN
                Rec."Dealer Code" := ServiceCenterL."Dealer Dimension Value";
                Rec."Zone Code" := ServiceCenterL."Zone Dimension Value";
            END;
            Rec.MODIFY;
        END;
    end;

    local procedure GetServiceCenterFromNotiSendHeader(VAR NotiSendHeaderP: Record "Notification Sending Header"): Code[20]
    var
        SalesHeaderArchiveL: Record "Sales Header Archive";
        PurchaseHeaderArchiveL: Record "Purchase Header Archive";
    begin
        CASE NotiSendHeaderP."Notification Source" OF
            //NotiSendHeaderP."Notification Source"::"Direct Sending":
            NotiSendHeaderP."Notification Source"::"Service Reminder":
                EXIT(GetServiceCenterFromServiceReminder(NotiSendHeaderP));
            NotiSendHeaderP."Notification Source"::"Customer Sales Visit":
                EXIT(GetServiceCenterFromSalesInvoice(NotiSendHeaderP));
            NotiSendHeaderP."Notification Source"::"Sales Quote":
                EXIT(GetServiceCenterFromArchSalesOrder(NotiSendHeaderP, SalesHeaderArchiveL."Document Type"::Quote));
            NotiSendHeaderP."Notification Source"::"Sales Order":
                EXIT(GetServiceCenterFromArchSalesOrder(NotiSendHeaderP, SalesHeaderArchiveL."Document Type"::Order));
            NotiSendHeaderP."Notification Source"::"Posted Invoice":
                EXIT(GetServiceCenterFromSalesInvoice(NotiSendHeaderP));
            NotiSendHeaderP."Notification Source"::"Posted Credit Memo":
                EXIT(GetServiceCenterFromSalesCreditMemo(NotiSendHeaderP));
            NotiSendHeaderP."Notification Source"::Segment:
                EXIT(GetServiceCenterFromSegment(NotiSendHeaderP));
            NotiSendHeaderP."Notification Source"::"Car Ready":
                EXIT(GetServiceCenterFromArchSalesOrder(NotiSendHeaderP, SalesHeaderArchiveL."Document Type"::Order));
            NotiSendHeaderP."Notification Source"::"Posted Shipment":
                EXIT(GetServiceCenterFromPostedShipment(NotiSendHeaderP));
            NotiSendHeaderP."Notification Source"::"Sales Return Order":
                EXIT(GetServiceCenterFromArchSalesOrder(NotiSendHeaderP, SalesHeaderArchiveL."Document Type"::"Return Order"));
            NotiSendHeaderP."Notification Source"::"Posted Return Receipt":
                EXIT(GetServiceCenterFromReturnRcpt(NotiSendHeaderP));
            NotiSendHeaderP."Notification Source"::"Preliminary Invoice":
                EXIT(GetServiceCenterFromSalesInvoice(NotiSendHeaderP));
            NotiSendHeaderP."Notification Source"::"Preliminary Credit Memo":
                EXIT(GetServiceCenterFromSalesCreditMemo(NotiSendHeaderP));
            NotiSendHeaderP."Notification Source"::"Purchase Order":
                EXIT(GetServiceCenterFromArchPurchOrder(NotiSendHeaderP, PurchaseHeaderArchiveL."Document Type"::Order));
            NotiSendHeaderP."Notification Source"::"Posted Purchase Return Shipment":
                EXIT(GetServiceCenterFromReturnShipment(NotiSendHeaderP));
            NotiSendHeaderP."Notification Source"::"Issued Reminder":
                EXIT(GetServiceCenterFromIssuedReminder(NotiSendHeaderP));
        END;
    end;

    local procedure GetServiceCenterFromServiceReminder(VAR NotiSendHeaderP: Record "Notification Sending Header"): Code[20]
    var
        ServiceDueEntryL: Record "Service Due Entry";
        SalesHeaderL: Record "Sales Header";
        ArchSalesHeaderL: Record "Sales Header Archive";
        SalesInvoiceHeaderL: Record "Sales Invoice Header";
        SalesCrMemoHeaderL: Record "Sales Cr.Memo Header";
    begin
        IF NOT ServiceDueEntryL.GET(NotiSendHeaderP."Notification Source No.") THEN
            EXIT;

        CASE ServiceDueEntryL."Coming from Vehicle Check Type" OF
            ServiceDueEntryL."Coming from Vehicle Check Type"::Basket:
                BEGIN
                    IF SalesHeaderL.GET(SalesHeaderL."Document Type"::Basket, ServiceDueEntryL."Coming from Vehicle Check No.") THEN
                        EXIT(SalesHeaderL."Service Center");
                END;
            ServiceDueEntryL."Coming from Vehicle Check Type"::"Blanket Order":
                BEGIN
                    ArchSalesHeaderL.RESET;
                    ArchSalesHeaderL.SETRANGE("Document Type", ArchSalesHeaderL."Document Type"::"Blanket Order");
                    ArchSalesHeaderL.SETRANGE("No.", ServiceDueEntryL."Coming from Vehicle Check No.");
                    IF ArchSalesHeaderL.FINDLAST THEN
                        EXIT(ArchSalesHeaderL."Service Center");
                END;
            ServiceDueEntryL."Coming from Vehicle Check Type"::"Credit Memo":
                BEGIN
                    IF SalesCrMemoHeaderL.GET(ServiceDueEntryL."Coming from Vehicle Check No.") THEN
                        EXIT(SalesCrMemoHeaderL."Service Center");
                END;
            ServiceDueEntryL."Coming from Vehicle Check Type"::Invoice:
                BEGIN
                    IF SalesInvoiceHeaderL.GET(ServiceDueEntryL."Coming from Vehicle Check No.") THEN
                        EXIT(SalesInvoiceHeaderL."Service Center");
                END;
            ServiceDueEntryL."Coming from Vehicle Check Type"::Quote:
                BEGIN
                    ArchSalesHeaderL.RESET;
                    ArchSalesHeaderL.SETRANGE("Document Type", ArchSalesHeaderL."Document Type"::Quote);
                    ArchSalesHeaderL.SETRANGE("No.", ServiceDueEntryL."Coming from Vehicle Check No.");
                    IF ArchSalesHeaderL.FINDLAST THEN
                        EXIT(ArchSalesHeaderL."Service Center");
                END;
            ServiceDueEntryL."Coming from Vehicle Check Type"::Order:
                BEGIN
                    ArchSalesHeaderL.RESET;
                    ArchSalesHeaderL.SETRANGE("Document Type", ArchSalesHeaderL."Document Type"::Order);
                    ArchSalesHeaderL.SETRANGE("No.", ServiceDueEntryL."Coming from Vehicle Check No.");
                    IF ArchSalesHeaderL.FINDLAST THEN
                        EXIT(ArchSalesHeaderL."Service Center");
                END;
            ServiceDueEntryL."Coming from Vehicle Check Type"::"Return Order":
                BEGIN
                    ArchSalesHeaderL.RESET;
                    ArchSalesHeaderL.SETRANGE("Document Type", ArchSalesHeaderL."Document Type"::"Return Order");
                    ArchSalesHeaderL.SETRANGE("No.", ServiceDueEntryL."Coming from Vehicle Check No.");
                    IF ArchSalesHeaderL.FINDLAST THEN
                        EXIT(ArchSalesHeaderL."Service Center");
                END;
        END;
    end;

    local procedure GetServiceCenterFromSalesInvoice(VAR NotiSendHeaderP: Record "Notification Sending Header"): Code[20]
    var
        SalesInvoiceHeaderL: Record "Sales Invoice Header";
    begin
        IF SalesInvoiceHeaderL.GET(NotiSendHeaderP."Notification Source No.") THEN
            EXIT(SalesInvoiceHeaderL."Service Center");
    end;

    local procedure GetServiceCenterFromSalesCreditMemo(VAR NotiSendHeaderP: Record "Notification Sending Header"): Code[20]
    var
        SalesCrMemoHeaderL: Record "Sales Cr.Memo Header";
    begin
        IF SalesCrMemoHeaderL.GET(NotiSendHeaderP."Notification Source No.") THEN
            EXIT(SalesCrMemoHeaderL."Service Center");
    end;

    local procedure GetServiceCenterFromArchSalesOrder(VAR NotiSendHeaderP: Record "Notification Sending Header"; DocumentTypeP: Integer): Code[20]
    var
        ArchSalesHeaderL: Record "Sales Header Archive";
    begin
        ArchSalesHeaderL.RESET;
        ArchSalesHeaderL.SETRANGE("Document Type", DocumentTypeP);
        ArchSalesHeaderL.SETRANGE("No.", NotiSendHeaderP."Notification Source No.");
        IF ArchSalesHeaderL.FINDLAST THEN
            EXIT(ArchSalesHeaderL."Service Center");
    end;

    local procedure GetServiceCenterFromSegment(VAR NotiSendHeaderP: Record "Notification Sending Header"): Code[20]

    begin
        exit;
    end;

    local procedure GetServiceCenterFromPostedShipment(VAR NotiSendHeaderP: Record "Notification Sending Header"): Code[20]
    var
        SalesShipmentHeaderL: Record "Sales Shipment Header";
    begin
        IF SalesShipmentHeaderL.GET(NotiSendHeaderP."Notification Source No.") THEN
            EXIT(SalesShipmentHeaderL."Service Center");
    end;

    local procedure GetServiceCenterFromReturnRcpt(VAR NotiSendHeaderP: Record "Notification Sending Header"): Code[20]
    var
        ReturnReceiptHeaderL: Record "Return Receipt Header";
    begin
        IF ReturnReceiptHeaderL.GET(NotiSendHeaderP."Notification Source No.") THEN
            EXIT(ReturnReceiptHeaderL."Service Center");
    end;

    local procedure GetServiceCenterFromReturnShipment(VAR NotiSendHeaderP: Record "Notification Sending Header"): Code[20]
    var
        ReturnShipmentHeaderL: Record "Return Shipment Header";
    begin
        IF ReturnShipmentHeaderL.GET(NotiSendHeaderP."Notification Source No.") THEN
            EXIT(ReturnShipmentHeaderL."Service Center");
    end;

    local procedure GetServiceCenterFromArchPurchOrder(VAR NotiSendHeaderP: Record "Notification Sending Header"; DocumentTypeP: Integer): Code[20]
    var
        PurchaseHeaderArchiveL: Record "Purchase Header Archive";
    begin
        PurchaseHeaderArchiveL.RESET;
        PurchaseHeaderArchiveL.SETRANGE("Document Type", DocumentTypeP);
        PurchaseHeaderArchiveL.SETRANGE("No.", NotiSendHeaderP."Notification Source No.");
        IF PurchaseHeaderArchiveL.FINDLAST THEN
            EXIT(PurchaseHeaderArchiveL."Service Center");
    end;

    local procedure GetServiceCenterFromIssuedReminder(VAR NotiSendHeaderP: Record "Notification Sending Header"): Code[20]
    var
        IssuedReminderHeaderL: Record "Issued Reminder Header";
    begin
        IF IssuedReminderHeaderL.GET(NotiSendHeaderP."Notification Source No.") THEN
            EXIT(IssuedReminderHeaderL."Service Center");
    end;
}
