// +--------------------------------------------------------------
// | ?2020 Incadea China Software System                          |
// +--------------------------------------------------------------+
// | PURPOSE: Local Customization                                 |
// |                                                              |
// | REMARK :                                                     |
// +--------------------------------------------------------------+
// 
// VERSION       ID       WHO    DATE        DESCRIPTION
// RGS_TWN-888   122187	  QX	 2020-11-23  Create Object
// RGS_TWN-342            AH     2017-05-19  Clear "Bill-to Company Name" field when "Central Maintenance" is true
//                                           Set "Bill-to Company Name"
// TWN.01.09    RGS_TWN-524  NN     2017-04-24  Add a record filter to Compaign Lists when lookup "Campaign No.".
// RGS_TWN-519               AH     2017-05-24  Add two fields "Mobile Phone No.", "VAT Registration No.".
// RGS_TWN-7885  121696     QX   2020-05-25  Add a field in contact search
// 112162       MARS_TWN-6441  GG     2018-03-12  Change function CheckPostingAllowed and CheckSaleslinesWithZero
// 115402       MARS_TWN-6798  GG     2018-07-16  Bug fix about realase contact the action is missing
// RGS_TWN-511               AH     2017-05-19  Add <Main Group Code>, <Sub Group Code>, <Position Group Code> 's description on Page

codeunit 1044860 "BC Upgrade Subscribers"
{
    var
        BCUpgradeMgtG: Codeunit "BC Upgrade Management";

    [EventSubscriber(ObjectType::Table, Database::Contact, 'OnAfterValidateEvent', 'Central Maintenance', true, true)]
    [Scope('OnPrem')]
    local procedure Contact_AfterValidateCentralMaintenance(var Rec: Record Contact; var xRec: Record Contact; CurrFieldNo: Integer)
    begin
        //Start RGS_TWN-342
        IF Rec."Central Maintenance" THEN BEGIN
            Rec."Bill-to Company Name" := '';
        END;
        //Stop RGS_TWN-342
    end;

    [EventSubscriber(ObjectType::Table, Database::Customer, 'OnafterValidateEvent', 'Central Maintenance', true, true)]
    [Scope('OnPrem')]
    local procedure Customer_AfterValidateCentralMaintenance(var Rec: Record Customer; var xRec: Record Customer; CurrFieldNo: Integer)
    begin
        //Start RGS_TWN-342
        IF Rec."Central Maintenance" THEN
            Rec."Bill-to Company Name" := '';
        //Stop RGS_TWN-342
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnafterValidateEvent', 'Sell-to Customer No.', true, true)]
    [Scope('OnPrem')]
    local procedure SalesHeader_AfterValidateSelltoCustomerNo(var Rec: Record "Sales Header"; var xRec: Record "Sales Header"; CurrFieldNo: Integer)
    var
        CustL: Record Customer;
    begin
        CustL.get(Rec."Sell-to Customer No.");
        //Start RGS_TWN-342
        Rec."Bill-to Company Name" := CustL."Bill-to Company Name";
        //Stop RGS_TWN-342
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'SpecialSalespersonLookup', '', true, true)]
    [Scope('OnPrem')]
    local procedure SalesHeader_SpecialSalespersonLookup
    (
        var Sender: Record "Sales Header";
        SalespersonCode: Code[20];
        IsSalesperson: Boolean;
        IsRepresentative: Boolean;
        IsFitter: Boolean;
        IsFinalCheckName: Boolean;
        var IsSpecialSalespersonLookup: Boolean;
        var ReturnSalespersonCode: Code[20]
    )
    begin
        BCUpgradeMgtG.SalesHeader_SpecialSalespersonLookup(Sender, SalespersonCode, IsSalesperson, IsRepresentative, IsFitter, IsFinalCheckName, IsSpecialSalespersonLookup, ReturnSalespersonCode);
    end;


    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'SpecialSalespersonValidate', '', true, true)]
    [Scope('OnPrem')]
    local procedure SalesHeader_SpecialSalespersonValidate
    (
        var Sender: Record "Sales Header";
        SalespersonCode: Code[20];
        IsSalesperson: Boolean;
        IsRepresentative: Boolean;
        IsFitter: Boolean;
        IsFinalCheckName: Boolean;
        var IsSpecialSalespersonValidation: Boolean;
        var IsValid: Boolean
    )
    begin
        BCUpgradeMgtG.SalesHeader_SpecialSalespersonValidate(Sender, SalespersonCode, IsSalesperson, IsRepresentative, IsFitter, IsFinalCheckName, IsSpecialSalespersonValidation, IsValid);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnCampaignNoLookup', '', true, true)]
    [Scope('OnPrem')]
    local procedure SalesHeader_OnCampaignNoLookup(var Sender: Record "Sales Header")
    var
    begin
        BCUpgradeMgtG.SalesHeader_OnCampaignNoLookup(Sender);
    end;


    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnAfterUpdateBillToCust', '', true, true)]
    [Scope('OnPrem')]
    local procedure SalesHeader_OnAfterUpdateBillToCust(var SalesHeader: Record "Sales Header"; Contact: Record Contact)
    begin
        //Start RGS_TWN-342
        if Contact."Bill-to Company Name" <> '' then
            SalesHeader."Bill-to Company Name" := Contact."Bill-to Company Name";
        if Contact."VAT Registration No." <> '' then
            SalesHeader."VAT Registration No." := Contact."VAT Registration No.";
        //Stop RGS_TWN-342
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterValidateEvent', 'No.', true, true)]
    [Scope('OnPrem')]
    local procedure SalesLine_AfterValidateNo(var Rec: Record "Sales Line"; var xRec: Record "Sales Line"; CurrFieldNo: Integer)
    begin
        BCUpgradeMgtG.SalesLine_AfterValidateNo(Rec, xRec, CurrFieldNo);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Contact Search", 'OtherSearchResult', '', true, true)]
    [Scope('OnPrem')]
    local procedure ContactSearch_OtherSearchResult(var SearchResult: Record "Contact Search Result"; SearchName: Record "Contact Search Name"; Usage: Option " ",Purchase,Sales)
    begin
        BCUpgradeMgtG.ContactSearch_OtherSearchResult(SearchResult, SearchName, Usage);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnBeforeCheckSaleslinesWithZero', '', true, true)]
    [Scope('OnPrem')]
    local procedure SalesPost_OnBeforeCheckSaleslinesWithZero(SalesHeader: Record "Sales Header"; var ExitCheckSaleslinesWithZero: Boolean)
    begin
        // // Start 112162
        // IF SalesHeader."Check Flag" THEN
        //     EXIT(TRUE);
        // // Stop 112162
        ExitCheckSaleslinesWithZero := SalesHeader."Check Flag";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnConfirmation', '', true, true)]
    [Scope('OnPrem')]
    local procedure SalesPost_OnConfirmation(var SalesHeader: Record "Sales Header")
    begin
        // Start 112162
        SalesHeader."Check Flag" := TRUE;
        // Stop 112162
    end;

    //Start 115402
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Campaign Target Group Mgt", 'OnCheckCampaignCriteriaForContact', '', true, true)]
    [Scope('OnPrem')]
    local procedure CampaignTargetGroupMgt_OnCheckCampaignCriteriaForContact(var ExcludeTableView: Boolean)
    begin
        ExcludeTableView := true;
    end;
    //Stop 115402


    [EventSubscriber(ObjectType::Page, Page::"Item Card", 'OnBeforeOnOpenPage', '', true, true)]
    [Scope('OnPrem')]
    local procedure ItemCard_OnBeforeOnOpenPage(var Enable: Boolean)
    var
        UserL: Record User;
        AccessControlL: Record "Access Control";
    begin
        //Start 116129
        Enable := false;
        UserL.Reset;
        UserL.SetRange("User Name", UserId);
        if UserL.FindFirst then
            AccessControlL.Reset;
        AccessControlL.SetRange("User Security ID", UserL."User Security ID");
        if AccessControlL.FindFirst then
            if AccessControlL."Role ID" = 'TRSDEALER' then
                Enable := true;
        //Stop 116129
    end;

    [EventSubscriber(ObjectType::Page, Page::"Item Card", 'GetDescription', '', true, true)]
    [Scope('OnPrem')]
    local procedure ItemCard_GetDescription(Item: Record Item; var MainGroupDes: Text[30]; var SubGroupDes: Text[30]; var PositionGroupDes: Text[30])
    var
        MainGroupL: Record "Main Group";
        SubGroupL: Record "Sub Group";
        PositionGroupL: Record "Position Group";
    begin
        //++RGS_TWN-511.BH++

        Clear(MainGroupL);
        Clear(SubGroupL);
        Clear(PositionGroupL);

        MainGroupDes := '';
        SubGroupDes := '';
        PositionGroupDes := '';

        if Item."Main Group Code" <> '' then
            if MainGroupL.Get(Item."Main Group Code") then
                MainGroupDes := MainGroupL.Description;

        if Item."Sub Group Code" <> '' then
            if SubGroupL.Get(Item."Sub Group Code") then
                SubGroupDes := SubGroupL.Description;

        if Item."Position Group Code" <> '' then
            if PositionGroupL.Get(Item."Position Group Code") then
                PositionGroupDes := PositionGroupL.Description;
        //--RGS_TWN-511.BH--
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"DimensionManagement", 'FindHQDeletedDim', '', true, true)]
    [Scope('OnPrem')]
    local procedure DimensionManagement_FindHQDeletedDim(RecVariant: Variant; var ExcludeHQDeletedDim: Boolean)
    begin
        ExcludeHQDeletedDim := BCUpgradeMgtG.TryTable(RecVariant, Database::"Item Journal Line");
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"DimensionManagement", 'CheckHQDeletedDim', '', true, true)]
    [Scope('OnPrem')]
    local procedure DimensionManagement_CheckHQDeletedDim(var DefaultDim: Record "Default Dimension"; ExcludeHQDeletedDim: Boolean)
    begin
        // Start 112161
        //++TWN1.00.122187.QX
        //IF NotUseDeleteHQDimG THEN
        if ExcludeHQDeletedDim then
            //--TWN1.00.122187.QX
            DefaultDim.SETRANGE("Deleted by HQ", false);
        // Stop 112161
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Notification Functions", 'OnGetServiceTypeMaster', '', true, true)]
    [Scope('OnPrem')]
    local procedure NotificationFunctions_OnGetServiceTypeMasterAndActiveCRM(var ServiceTypeMasterFound: Boolean; var ServiceTypeMasterCode: Code[20])
    var
        MARSNotifSetupL: Record "Fastfit Setup - Notification";
        ServiceTypeMasterL: Record "Service Type Master";
    begin
        ServiceTypeMasterFound := MARSNotifSetupL.Get();
        if not ServiceTypeMasterFound then
            exit;
        ServiceTypeMasterCode := MARSNotifSetupL."Customer Agreement Text Code";
        ServiceTypeMasterFound := ServiceTypeMasterL.GET(ServiceTypeMasterCode);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Notification Functions", 'OnValidateSendSMS', '', true, true)]
    [Scope('OnPrem')]
    local procedure NotificationFunctions_OnValidateSendSMS(var NotifSendingHeader: Record "Notification Sending Header"; Contact: Record "Contact")
    begin
        if Contact."Personal Data Status" = Contact."Personal Data Status"::Yes then
            NotifSendingHeader.VALIDATE("Send SMS", TRUE);
    end;


    [EventSubscriber(ObjectType::Page, Page::"Resource Prices", 'OnAfterNewRecord', '', true, true)]
    [Scope('OnPrem')]
    local procedure ResourcePrices_OnAfterNewRecord(var ResourcePrice: Record "Resource Price")
    var
        SalesReceivableSetupL: Record "Sales & Receivables Setup";
    begin
        //Start RGS_TWN-566
        SalesReceivableSetupL.GET;
        ResourcePrice."Price Includes VAT" := SalesReceivableSetupL."Price Includes VAT";
        ResourcePrice."VAT Bus. Posting Gr. (Price)" := SalesReceivableSetupL."VAT Bus. Posting Gr. (Price)";
        //Stop RGS_TWN-566
    end;

    [EventSubscriber(ObjectType::Page, Page::"Contact Card", 'OnBeforeOpenPage', '', true, true)]
    [Scope('OnPrem')]
    local procedure ContactCard_OnBeforeOpenPage(var Sender: Page "Contact Card"; Contact: Record "Contact")
    begin
        //Start RGS_TWN-342
        //++TWN1.00.122187.QX
        //  VATRegistrationNoEditableG := NOT Rec."Central Maintenance" ;
        Sender.SetBilltoCompanyNameEditable(not Contact."Central Maintenance");
        //--TWN1.00.122187.QX
        //Stop RGS_TWN-342
    end;

    [EventSubscriber(ObjectType::Page, Page::"Contact Card", 'OnAfterEnableFields', '', true, true)]
    [Scope('OnPrem')]
    local procedure ContactCard_OnAfterEnableFields(Contact: Record "Contact"; var VATRegistrationNoEnable: Boolean)
    begin
        //Start RGS_TWN-T30
        //   "VAT Registration No.Enable" := Type IN [Type::Company,Type::Person];
        VATRegistrationNoEnable := Contact.Type IN [Contact.Type::Company, Contact.Type::Person];
        //Stop RGS_TWN-T30
    end;

    [EventSubscriber(ObjectType::Page, Page::"Shopping Basket", 'OnBeforeCreateInvoiceAndPost', '', true, true)]
    [Scope('OnPrem')]
    local procedure ShoppingBasket_OnBeforeCreateInvoiceAndPost(SalesHeader: Record "Sales Header")
    begin
        BCUpgradeMgtG.ShoppingBasket_OnBeforeCreateInvoiceAndPost(SalesHeader);
    end;

    [EventSubscriber(ObjectType::Page, Page::"Items by SC", 'OnBeforeAfterGetCurrRecord', '', true, true)]
    [Scope('OnPrem')]
    local procedure ItemsbySC_OnBeforeAfterGetCurrRecord(var NotUpdateCurrPage: Boolean)
    begin
        NotUpdateCurrPage := true;
    end;


    [EventSubscriber(ObjectType::Page, Page::"Items by SC", 'OnInventoryDillDown', '', true, true)]
    [Scope('OnPrem')]
    local procedure ItemsbySC_OnInventoryDillDown(MatrixRecords: array[12] of Record "Service Center"; MatrixIndex: Integer; var ServiceCentrCode: Code[10])
    begin
        ServiceCentrCode := MatrixRecords[MatrixIndex].Code;
    end;


    [EventSubscriber(ObjectType::Page, Page::"Matchcode Search", 'OnDrillDownNo', '', true, true)]
    [Scope('OnPrem')]
    local procedure MatchcodeSearch_OnDrillDownNo(ItemNo: Code[20])
    begin
        BCUpgradeMgtG.MatchcodeSearch_NumberDrilldown(ItemNo);
    end;

    [EventSubscriber(ObjectType::Page, Page::"Matchcode Search", 'SetManufacturerItemMoVislble', '', true, true)]
    [Scope('OnPrem')]
    local procedure MatchcodeSearch_SetManufacturerItemMoVislble(var ManufacturerItemMoVislble: Boolean)
    begin
        ManufacturerItemMoVislble := true;
    end;

    [EventSubscriber(ObjectType::Page, Page::"Matchcode Search WebClient", 'OnDrillDownNo', '', true, true)]
    [Scope('OnPrem')]
    local procedure MatchcodeSearchWebClient_OnDrillDownNo(ItemNo: Code[20])
    begin
        BCUpgradeMgtG.MatchcodeSearch_NumberDrilldown(ItemNo);
    end;

    [EventSubscriber(ObjectType::Page, Page::"Matchcode Search WebClient", 'SetManufacturerItemMoVislble', '', true, true)]
    [Scope('OnPrem')]
    local procedure MatchcodeSearchWebClient_SetManufacturerItemMoVislble(var ManufacturerItemMoVislble: Boolean)
    begin
        ManufacturerItemMoVislble := true;
    end;


    [EventSubscriber(ObjectType::Page, Page::"Cash Reg. Statement Subform", 'OnRoundAmount', '', true, true)]
    [Scope('OnPrem')]
    local procedure CashRegStatementSubform_OnRoundAmount(var Amount: Decimal)
    var
        GLSetupL: Record "General Ledger Setup";
    begin
        Amount := ROUND(Amount, GLSetupL."Amount Rounding Precision");
    end;

    [EventSubscriber(ObjectType::Report, Report::"Send Notifications", 'OnAfterPostReport', '', true, true)]
    [Scope('OnPrem')]
    local procedure SendNotifications_OnAfterPostReport(IsFailed: Boolean)
    begin
        BCUpgradeMgtG.SendNotifications_OnAfterPostReport(IsFailed);
    end;


    [EventSubscriber(ObjectType::Report, Report::"Send Notifications", 'OnBeforeSendNotification', '', true, true)]
    [Scope('OnPrem')]
    local procedure SendNotifications_OnBeforeSendNotification(var NotificationSendingHeader: Record "Notification Sending Header"; SingleNotification: Boolean; var Skip: Boolean)
    begin
        BCUpgradeMgtG.SendNotifications_OnBeforeSendNotification(NotificationSendingHeader, SingleNotification, Skip);
    end;

    [EventSubscriber(ObjectType::Report, Report::"Send Notifications", 'OnBeforeSendSMSNotification', '', true, true)]
    [Scope('OnPrem')]
    local procedure SendNotifications_OnBeforeSendSMSNotification
    (
        var NotificationSendingHeader: Record "Notification Sending Header";
        var IsSpecialSMSNotification: Boolean;
        var IsFailToSend: Boolean;
        var NotArchived: Boolean;
        var ErrorType: Integer
    )
    begin
        BCUpgradeMgtG.SendNotifications_OnBeforeSendSMSNotification(NotificationSendingHeader, IsSpecialSMSNotification, IsFailToSend, NotArchived, ErrorType);
    end;

    [EventSubscriber(ObjectType::Report, Report::"Send Notifications", 'OnCreateErrorLog', '', true, true)]
    [Scope('OnPrem')]
    local procedure SendNotifications_OnCreateErrorLog(var NotificationSendingHeader: Record "Notification Sending Header"; ErrorType: Integer)
    begin
        BCUpgradeMgtG.SendNotifications_OnCreateErrorLog(NotificationSendingHeader, ErrorType);
    end;

}
