codeunit 1044880 "Tracking Mgt. Event Handler"
{
    [EventSubscriber(ObjectType::Page, Page::"Posted Inv. With Notification", 'OnOpenPageEvent', '', false, false)]
    local procedure OnOpenPageFromPostedInvWithNotificationSub(var Rec: Record "Sales Invoice Header")
    begin
        MUTFunctionsG.AddUsageTrackingEntry('MUT_0100');
    end;

    [EventSubscriber(ObjectType::Page, Page::"Posted Inv. With Vehicle Check", 'OnOpenPageEvent', '', false, false)]
    local procedure OnOpenPageFromPostedInvWithVehicleCheckSub(var Rec: Record "Sales Invoice Header")
    begin
        MUTFunctionsG.AddUsageTrackingEntry('MUT_0101');
    end;

    [EventSubscriber(ObjectType::Page, Page::"Purchase Order", 'OnAfterActionEvent', 'PostAction', false, false)]
    local procedure OnActionFromPurchOrderPostSub(var Rec: Record "Purchase Header")
    begin
        MUTFunctionsG.AddUsageTrackingEntry('MUT_1100');
    end;

    [EventSubscriber(ObjectType::Page, Page::"Purchase Order List", 'OnAfterActionEvent', 'PostAndPrint', false, false)]
    local procedure OnActionFromPurchOrderPostAndPrintSub(var Rec: Record "Purchase Header")
    begin
        MUTFunctionsG.AddUsageTrackingEntry('MUT_1100');
    end;

    [EventSubscriber(ObjectType::Page, Page::"Purchase Order List", 'OnAfterActionEvent', 'Post', false, false)]
    local procedure OnActionFromPurchOrderListPostSub(var Rec: Record "Purchase Header")
    begin
        MUTFunctionsG.AddUsageTrackingEntry('MUT_1100');
    end;

    [EventSubscriber(ObjectType::Page, Page::"Purchase Order", 'OnAfterActionEvent', 'Post and &Print', false, false)]
    local procedure OnActionFromPurchOrderListPostAndPrintSub(var Rec: Record "Purchase Header")
    begin
        MUTFunctionsG.AddUsageTrackingEntry('MUT_1100');
    end;

    [EventSubscriber(ObjectType::Page, Page::"Shopping Basket", 'OnAfterActionEvent', 'Cre&ate Invoice and Post', false, false)]
    local procedure OnActionFromShoppingBasketInvPost(var Rec: Record "Sales Header")
    begin
        MUTFunctionsG.AddUsageTrackingEntry('MUT_2230');
    end;

    [EventSubscriber(ObjectType::Page, Page::"Shopping Basket", 'OnAfterActionEvent', 'Cr&eate Order and Ship', false, false)]
    local procedure OnActionFromShoppingBasketCreateOrderAndPrintSub(var Rec: Record "Sales Header")
    begin
        MUTFunctionsG.AddUsageTrackingEntry('MUT_2231');
    end;

    [EventSubscriber(ObjectType::Page, Page::"Shopping Basket", 'OnAfterActionEvent', 'VehCheck', false, false)]
    local procedure OnActionFromShoppingBasketVehCheckSub(var Rec: Record "Sales Header")
    begin
        MUTFunctionsG.AddUsageTrackingEntry('MUT_2232');
    end;

    [EventSubscriber(ObjectType::Page, Page::"Shopping Basket List", 'OnAfterActionEvent', 'VehCheck', false, false)]
    local procedure OnActionFromShoppingBasketListVehCheckSub(var Rec: Record "Sales Header")
    begin
        MUTFunctionsG.AddUsageTrackingEntry('MUT_2232');
    end;

    [EventSubscriber(ObjectType::Page, Page::"Sales Order", 'OnAfterActionEvent', 'Reserve Other Slot', false, false)]
    local procedure OnActionFromSalesOrderReservOtherSlotSub(var Rec: Record "Sales Header")
    begin
        MUTFunctionsG.AddUsageTrackingEntry('MUT_2430');
    end;

    [EventSubscriber(ObjectType::Page, Page::"Sales Order", 'OnAfterActionEvent', 'Cre&ate Invoice and Post', false, false)]
    local procedure OnActionFromSalesOrderCreateInvAndPostSub(var Rec: Record "Sales Header")
    begin
        MUTFunctionsG.AddUsageTrackingEntry('MUT_2431');
    end;

    [EventSubscriber(ObjectType::Page, Page::"Sales Order", 'OnAfterActionEvent', 'Post and &Print', false, false)]
    local procedure OnActionFromSalesOrderPostAndPrintSub(var Rec: Record "Sales Header")
    begin
        MUTFunctionsG.AddUsageTrackingEntry('MUT_2431');
    end;

    [EventSubscriber(ObjectType::Page, Page::"Sales Order", 'OnAfterActionEvent', 'VehCheck', false, false)]
    local procedure OnActionFromSalesOrderVehicleCheckSub(var Rec: Record "Sales Header")
    begin
        MUTFunctionsG.AddUsageTrackingEntry('MUT_2433');
    end;

    [EventSubscriber(ObjectType::Page, Page::"Sales Order List", 'OnAfterActionEvent', 'Cre&ate Invoice and Post', false, false)]
    local procedure OnActionFromSalesOrderListCreateInvAndPostSub(var Rec: Record "Sales Header")
    begin
        MUTFunctionsG.AddUsageTrackingEntry('MUT_2431');
    end;

    [EventSubscriber(ObjectType::Page, Page::"Sales Order List", 'OnAfterActionEvent', 'Post and &Print', false, false)]
    local procedure OnActionFromSalesOrderListPostAndPrintSub(var Rec: Record "Sales Header")
    begin
        MUTFunctionsG.AddUsageTrackingEntry('MUT_2431');
    end;

    [EventSubscriber(ObjectType::Page, Page::"Sales Order List", 'OnAfterActionEvent', 'VehCheck', false, false)]
    local procedure OnActionFromSalesOrderListVehicleCheckSub(var Rec: Record "Sales Header")
    begin
        MUTFunctionsG.AddUsageTrackingEntry('MUT_2433');
    end;

    [EventSubscriber(ObjectType::Page, Page::"Customer Agreement List", 'OnActionAgreementConfirmEvent', '', false, false)]
    local procedure OnActionFromCustAgreementConfirmOkSub(SelectionOptP: Integer)
    begin
        IF SelectionOptP = 1 THEN
            MUTFunctionsG.AddUsageTrackingEntry('MUT_5080');
    end;

    [EventSubscriber(ObjectType::Report, Report::"Send Notifications", 'OnPostReportEvent', '', false, false)]
    local procedure OnPostReportFromSendNotificationSub()
    begin
        MUTFunctionsG.AddUsageTrackingEntry('MUT_6500');
    end;

    [EventSubscriber(ObjectType::Report, Report::"Inventory - Sales Statistics", 'OnAfterPostReport', '', false, false)]
    local procedure OnPostReportFromInventorySalesStatisticSub()
    begin
        MUTFunctionsG.AddUsageTrackingEntry('MUT_6501');
    end;

    [EventSubscriber(ObjectType::Report, Report::"Tyre Brand Mix", 'OnAfterPostReport', '', false, false)]
    local procedure OnPostReportFromTyreBrandMixSub()
    begin
        MUTFunctionsG.AddUsageTrackingEntry('MUT_6502');
    end;

    [EventSubscriber(ObjectType::Report, Report::"Product Mix", 'OnAfterPostReport', '', false, false)]
    local procedure OnPostReportFromProductMixSub()
    begin
        MUTFunctionsG.AddUsageTrackingEntry('MUT_6503');
    end;

    [EventSubscriber(ObjectType::Report, Report::"Product & Services Mix", 'OnAfterPostReport', '', false, false)]
    local procedure OnPostReportFromProdServMixSub()
    begin
        MUTFunctionsG.AddUsageTrackingEntry('MUT_6504');
    end;

    [EventSubscriber(ObjectType::Report, Report::"Customer Value Analysis - List", 'OnAfterPostReport', '', false, false)]
    local procedure OnPostReportFromCustValueAnalysisSub()
    begin
        MUTFunctionsG.AddUsageTrackingEntry('MUT_6505');
    end;

    [EventSubscriber(ObjectType::Report, Report::"TW Performance Report", 'OnPostReportEvent', '', false, false)]
    local procedure OnPostReportFromPerformanceReportSub()
    begin
        MUTFunctionsG.AddUsageTrackingEntry('MUT_6506');
    end;

    [EventSubscriber(ObjectType::Page, Page::"Item Card", 'OnAfterActionEvent', 'Action86', false, false)]
    local procedure OnActionFromItemCardPurchPricesSub(var Rec: Record Item)
    begin
        MUTFunctionsG.AddUsageTrackingEntry('MUT_7100');
    end;

    [EventSubscriber(ObjectType::Page, Page::"Item Card", 'OnAfterActionEvent', 'Prices', false, false)]
    local procedure OnActionFromItemCardSalesPricesSub(var Rec: Record Item)
    begin
        MUTFunctionsG.AddUsageTrackingEntry('MUT_7101');
    end;

    var
        MUTFunctionsG: Codeunit "Usage Tracking";
}
