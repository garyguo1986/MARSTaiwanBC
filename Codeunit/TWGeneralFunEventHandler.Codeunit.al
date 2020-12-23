codeunit 1044863 "TW General Fun Event Handler"
{

    // +--------------------------------------------------------------+
    // | @ 2019 incadea Taiwan Limited                                |
    // +--------------------------------------------------------------+
    // | PURPOSE: MARS_TWN                                            |
    // |                                                              |
    // | REMARK :                                                     |
    // +--------------------------------------------------------------+

    // VERSION       ID            WHO    DATE        DESCRIPTION
    // 120526        RGS_TWN-827   GG     2019-09-05  New Object
    // 121697        RGS_TWN-7889  QX     2020-05-25  Create a pop out window to alert can't modify customer card
    // 122137        RGS_TWN-872   GG     2020-10-13  add new function PageItemCard_InsertNewItemInsideEventSub

    [EventSubscriber(ObjectType::Page, Page::"Contact Search Results", 'OnBeforeActionEvent', 'Create New Sales Order', true, true)]
    local procedure PageContactSearchResult_CreateSalesOrder_OnBeforeAction(var Rec: Record "Contact Search Result")
    begin
        ;
        // Start 120526
        IF Rec.Type <> Rec.Type::Contact THEN
            EXIT;
        IF CONFIRM(C_TWN_001) THEN
            EXIT;

        ERROR('');
        // Stop 120526
    end;

    [EventSubscriber(ObjectType::Page, Page::"Contact Search Results", 'OnBeforeActionEvent', 'Create New Shopping Basket', true, true)]
    local procedure PageContactSearchResult_CreateShopBasketOrder_OnBeforeAction(var Rec: Record "Contact Search Result")
    begin
        // Start 120526
        IF Rec.Type <> Rec.Type::Contact THEN
            EXIT;
        IF CONFIRM(C_TWN_001) THEN
            EXIT;

        ERROR('');
        // Stop 120526
    end;

    [EventSubscriber(ObjectType::Page, Page::"Customer Card", 'OnModifyRecordEvent', '', true, true)]
    local procedure PageCustomerCard_BeforeModifyEvent(var AllowModify: Boolean; var Rec: Record Customer; var xRec: Record Customer)
    begin
        //++TWN1.00.001.121697.QX
        CheckCustomerEditability(Rec);
        //--TWN1.00.001.121697.QX
    end;

    [EventSubscriber(ObjectType::Page, Page::"Customer Card", 'OnBeforeActionEvent', 'Block', true, false)]
    local procedure PageCustomerCard_OnBeforeBlockActionEvent(var Rec: Record Customer)
    begin
        //++TWN1.00.001.121697.GG
        CheckCustomerEditability(Rec);
        //--TWN1.00.001.121697.GG
    end;

    [EventSubscriber(ObjectType::Page, Page::"Item Card", 'OnBeforeInsertNewItem', '', true, false)]
    local procedure PageItemCard_InsertNewItemInsideEventSub(var ItemP: Record Item; var ItemDefaultP: Record "Item Default")
    var
        UserSetupL: Record "User Setup";
        ManufacturerL: Record Manufacturer;
        IsUserCanCreationL: Boolean;
    begin
        //++TWN1.00.001.122137.GG
        IsUserCanCreationL := FALSE;
        IF UserSetupL.GET(USERID) THEN
            IF UserSetupL."Not Block Item Manufacturer" THEN
                IsUserCanCreationL := TRUE;
        IF IsUserCanCreationL THEN
            EXIT;

        IF ItemDefaultP."Manufacturer No." = '' THEN
            EXIT;

        ManufacturerL.RESET;
        ManufacturerL.SETRANGE(Code, ItemDefaultP."Manufacturer No.");
        ManufacturerL.SETRANGE("Limit Creation", TRUE);
        IF (NOT ManufacturerL.ISEMPTY) THEN BEGIN
            MESSAGE(C_TWN_002);
            ERROR('');
        END;
        //--TWN1.00.001.122137.GG
    end;

    [EventSubscriber(ObjectType::Page, Page::"Dimension Value List", 'OnBeforeGetSelectionFilter', '', false, false)]
    local procedure GetSelectionFilterFromDimValueList(var DimVal: Record "Dimension Value"; var FilterText: Text; var IsTrigger: Boolean)
    var
        FirstDimVal: Code[20];
        LastDimVal: Code[20];
        SelectionFilter: Code[250];
        DimValCount: Integer;
        More: Boolean;
    begin
        // Start RGS_TWN-INC01
        //EXIT(SelectionFilterManagement.GetSelectionFilterForDimensionValue(DimVal));

        DimValCount := DimVal.COUNT;
        IF DimValCount > 0 THEN BEGIN
            DimVal.FIND('-');
            WHILE DimValCount > 0 DO BEGIN
                DimValCount := DimValCount - 1;
                DimVal.MARKEDONLY(FALSE);
                FirstDimVal := DimVal.Code;
                LastDimVal := FirstDimVal;
                More := (DimValCount > 0);
                WHILE More DO
                    IF DimVal.NEXT = 0 THEN
                        More := FALSE
                    ELSE
                        IF NOT DimVal.MARK THEN
                            More := FALSE
                        ELSE BEGIN
                            LastDimVal := DimVal.Code;
                            DimValCount := DimValCount - 1;
                            IF DimValCount = 0 THEN
                                More := FALSE;
                        END;
                IF SelectionFilter <> '' THEN
                    SelectionFilter := SelectionFilter + '|';
                IF FirstDimVal = LastDimVal THEN
                    SelectionFilter := SelectionFilter + FirstDimVal
                ELSE
                    SelectionFilter := SelectionFilter + FirstDimVal + '..' + LastDimVal;
                IF DimValCount > 0 THEN BEGIN
                    DimVal.MARKEDONLY(TRUE);
                    DimVal.NEXT;
                END;
            END;
        END;

        //EXIT(SelectionFilter);
        FilterText := SelectionFilter;
        IsTrigger := true;
        // Stop RGS_TWN-INC01
    end;

    local procedure CheckCustomerEditability(CustP: Record Customer)
    var
        SalesSetupL: Record "Sales & Receivables Setup";
        CustL: Record Customer;
    begin
        //++TWN1.00.001.121697.QX
        SalesSetupL.GET;
        IF SalesSetupL."No Modify Customer" = '' THEN
            EXIT;

        CustL.FILTERGROUP(0);
        CustL.SETFILTER("No.", SalesSetupL."No Modify Customer");
        CustL.FILTERGROUP(2);

        CustL.SETRANGE("No.", CustP."No.");
        IF CustL.COUNT > 0 THEN
            ERROR(C_TWN_ERR001, CustP."No.");
        //--TWN1.00.001.121697.QX

    end;

    var
        C_TWN_001: Label 'Contact lack Vehicle Card Information, Order will lack Vehicle Information.';
        C_TWN_002: Label 'You can not create item with this manufacurer!';
        C_TWN_ERR001: Label 'Current customer %1 card can''t be modified';
}
