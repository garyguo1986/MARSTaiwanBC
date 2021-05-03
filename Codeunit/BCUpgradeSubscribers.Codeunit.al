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
// RGS_TWN-8365  122779	  QX	 2021-04-06  Set Consent Data Line Values

codeunit 1044860 "BC Upgrade Subscribers"
{
    var
        BCUpgradeMgtG: Codeunit "BC Upgrade Management";

    [EventSubscriber(ObjectType::Table, Database::Contact, 'OnAfterValidateEvent', 'Central Maintenance', true, true)]
    local procedure Contact_AfterValidateCentralMaintenance(var Rec: Record Contact; var xRec: Record Contact; CurrFieldNo: Integer)
    begin
        //Start RGS_TWN-342
        IF Rec."Central Maintenance" THEN BEGIN
            Rec."Bill-to Company Name" := '';
        END;
        //Stop RGS_TWN-342
    end;

    [EventSubscriber(ObjectType::Table, Database::Customer, 'OnafterValidateEvent', 'Central Maintenance', true, true)]
    local procedure Customer_AfterValidateCentralMaintenance(var Rec: Record Customer; var xRec: Record Customer; CurrFieldNo: Integer)
    begin
        //Start RGS_TWN-342
        IF Rec."Central Maintenance" THEN
            Rec."Bill-to Company Name" := '';
        //Stop RGS_TWN-342
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnafterValidateEvent', 'Sell-to Customer No.', true, true)]
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
    local procedure SalesHeader_OnCampaignNoLookup(var Sender: Record "Sales Header")
    var
    begin
        BCUpgradeMgtG.SalesHeader_OnCampaignNoLookup(Sender);
    end;


    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnAfterUpdateBillToCust', '', true, true)]
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
    local procedure SalesLine_AfterValidateNo(var Rec: Record "Sales Line"; var xRec: Record "Sales Line"; CurrFieldNo: Integer)
    begin
        BCUpgradeMgtG.SalesLine_AfterValidateNo(Rec, xRec, CurrFieldNo);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Contact Search", 'OtherSearchResult', '', true, true)]
    local procedure ContactSearch_OtherSearchResult(var SearchResult: Record "Contact Search Result"; SearchName: Record "Contact Search Name"; Usage: Option " ",Purchase,Sales)
    begin
        BCUpgradeMgtG.ContactSearch_OtherSearchResult(SearchResult, SearchName, Usage);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnBeforeCheckSaleslinesWithZero', '', true, true)]
    local procedure SalesPost_OnBeforeCheckSaleslinesWithZero(SalesHeader: Record "Sales Header"; var ExitCheckSaleslinesWithZero: Boolean)
    begin
        // // Start 112162
        // IF SalesHeader."Check Flag" THEN
        //     EXIT(TRUE);
        // // Stop 112162
        ExitCheckSaleslinesWithZero := SalesHeader."Check Flag";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnConfirmation', '', true, true)]
    local procedure SalesPost_OnConfirmation(var SalesHeader: Record "Sales Header")
    begin
        // Start 112162
        SalesHeader."Check Flag" := TRUE;
        // Stop 112162
    end;

    //Start 115402
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Campaign Target Group Mgt", 'OnCheckCampaignCriteriaForContact', '', true, true)]
    local procedure CampaignTargetGroupMgt_OnCheckCampaignCriteriaForContact(var ExcludeTableView: Boolean)
    begin
        ExcludeTableView := true;
    end;
    //Stop 115402


    [EventSubscriber(ObjectType::Page, Page::"Item Card", 'OnBeforeOnOpenPage', '', true, true)]
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

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"DimensionManagement", 'FindMasterDBDeletedDim', '', true, true)]
    local procedure DimensionManagement_FindMasterDBDeletedDim(RecVariant: Variant; var ExcludeHQDeletedDim: Boolean)
    begin
        ExcludeHQDeletedDim := BCUpgradeMgtG.TryTable(RecVariant, Database::"Item Journal Line");
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"DimensionManagement", 'CheckMasterDBDeletedDim', '', true, true)]
    local procedure DimensionManagement_CheckMasterDBDeletedDim(var DefaultDim: Record "Default Dimension"; ExcludeHQDeletedDim: Boolean)
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
    local procedure NotificationFunctions_OnGetServiceTypeMaster(var ServiceTypeMasterFound: Boolean; var ServiceTypeMasterCode: Code[20])
    var
        MARSNotifSetupL: Record "Fastfit Setup - Notification";
        ServiceTypeMasterL: Record "Service Type Master";
        SingleInstanceL: Codeunit "TW General Single Instance";
    begin
        SingleInstanceL.SetAgreementServiceTypeMaster('');
        ServiceTypeMasterFound := MARSNotifSetupL.Get();
        if not ServiceTypeMasterFound then
            exit;
        ServiceTypeMasterCode := MARSNotifSetupL."Customer Agreement Text Code";
        ServiceTypeMasterFound := ServiceTypeMasterL.GET(ServiceTypeMasterCode);
        SingleInstanceL.SetAgreementServiceTypeMaster(ServiceTypeMasterCode);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Notification Functions", 'OnValidateSendSMS', '', true, true)]
    local procedure NotificationFunctions_OnValidateSendSMS(var NotifSendingHeader: Record "Notification Sending Header"; Contact: Record "Contact")
    begin
        if Contact."Personal Data Status" = Contact."Personal Data Status"::Yes then
            NotifSendingHeader.VALIDATE("Send SMS", TRUE);
    end;


    [EventSubscriber(ObjectType::Page, Page::"Resource Prices", 'OnNewRecordEvent', '', true, true)]
    local procedure ResourcePrices_OnNewRecord(var Rec: Record "Resource Price"; BelowxRec: Boolean; var xRec: Record "Resource Price")
    var
        SalesReceivableSetupL: Record "Sales & Receivables Setup";
    begin
        //Start RGS_TWN-566
        SalesReceivableSetupL.GET;
        Rec."Price Includes VAT" := SalesReceivableSetupL."Price Includes VAT";
        Rec."VAT Bus. Posting Gr. (Price)" := SalesReceivableSetupL."VAT Bus. Posting Gr. (Price)";
        //Stop RGS_TWN-566
    end;

    [EventSubscriber(ObjectType::Page, Page::"Contact Card", 'OnBeforeOpenPage', '', true, true)]
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
    local procedure ContactCard_OnAfterEnableFields(Contact: Record "Contact"; var VATRegistrationNoEnable: Boolean)
    begin
        //Start RGS_TWN-T30
        //   "VAT Registration No.Enable" := Type IN [Type::Company,Type::Person];
        VATRegistrationNoEnable := Contact.Type IN [Contact.Type::Company, Contact.Type::Person];
        //Stop RGS_TWN-T30
    end;

    [EventSubscriber(ObjectType::Page, Page::"Shopping Basket", 'OnBeforeCreateInvoiceAndPost', '', true, true)]
    local procedure ShoppingBasket_OnBeforeCreateInvoiceAndPost(SalesHeader: Record "Sales Header")
    begin
        BCUpgradeMgtG.ShoppingBasket_OnBeforeCreateInvoiceAndPost(SalesHeader);
    end;

    [EventSubscriber(ObjectType::Page, Page::"Items by SC", 'OnBeforeAfterGetCurrRecord', '', true, true)]
    local procedure ItemsbySC_OnBeforeAfterGetCurrRecord(var NotUpdateCurrPage: Boolean)
    begin
        NotUpdateCurrPage := true;
    end;


    [EventSubscriber(ObjectType::Page, Page::"Items by SC", 'OnInventoryDillDown', '', true, true)]
    local procedure ItemsbySC_OnInventoryDillDown(MatrixRecords: array[12] of Record "Service Center"; MatrixIndex: Integer; var ServiceCentrCode: Code[10])
    begin
        ServiceCentrCode := MatrixRecords[MatrixIndex].Code;
    end;


    [EventSubscriber(ObjectType::Page, Page::"Matchcode Search", 'OnDrillDownNo', '', true, true)]
    local procedure MatchcodeSearch_OnDrillDownNo(ItemNo: Code[20])
    begin
        BCUpgradeMgtG.MatchcodeSearch_NumberDrilldown(ItemNo);
    end;

    [EventSubscriber(ObjectType::Page, Page::"Matchcode Search", 'SetManufacturerItemMoVislble', '', true, true)]
    local procedure MatchcodeSearch_SetManufacturerItemMoVislble(var ManufacturerItemMoVislble: Boolean)
    begin
        ManufacturerItemMoVislble := true;
    end;

    [EventSubscriber(ObjectType::Page, Page::"Matchcode Search WebClient", 'OnDrillDownNo', '', true, true)]
    local procedure MatchcodeSearchWebClient_OnDrillDownNo(ItemNo: Code[20])
    begin
        BCUpgradeMgtG.MatchcodeSearch_NumberDrilldown(ItemNo);
    end;

    [EventSubscriber(ObjectType::Page, Page::"Matchcode Search WebClient", 'SetManufacturerItemNoVislble', '', true, true)]
    local procedure MatchcodeSearchWebClient_SetManufacturerItemMoVislble(var ManufacturerItemMoVislble: Boolean)
    begin
        ManufacturerItemMoVislble := true;
    end;


    [EventSubscriber(ObjectType::Page, Page::"Cash Reg. Statement Subform", 'OnRoundAmount', '', true, true)]
    local procedure CashRegStatementSubform_OnRoundAmount(var Amount: Decimal)
    var
        GLSetupL: Record "General Ledger Setup";
    begin
        Amount := ROUND(Amount, GLSetupL."Amount Rounding Precision");
    end;


    [EventSubscriber(ObjectType::Report, Report::"Send Notifications", 'OnSetServiceCenterFilter', '', true, true)]
    local procedure SendNotifications_OnSetServiceCenterFilter(var NotificationSendingHeader: Record "Notification Sending Header"; ServiceCenterFilterTxt: Text)
    begin
        // Start 119387
        IF ServiceCenterFilterTxt > '' THEN
            NotificationSendingHeader.SETFILTER("Service Center", ServiceCenterFilterTxt)
        ELSE
            NotificationSendingHeader.SETRANGE("Service Center", ServiceCenterFilterTxt)
        // Stop  119387
    end;

    [EventSubscriber(ObjectType::Report, Report::"Send Notifications", 'OnAfterPostReport', '', true, true)]
    local procedure SendNotifications_OnAfterPostReport(IsFailed: Boolean)
    begin
        BCUpgradeMgtG.SendNotifications_OnAfterPostReport(IsFailed);
    end;


    [EventSubscriber(ObjectType::Report, Report::"Send Notifications", 'OnBeforeSendNotification', '', true, true)]
    local procedure SendNotifications_OnBeforeSendNotification(var NotificationSendingHeader: Record "Notification Sending Header"; SingleNotification: Boolean; var Skip: Boolean)
    begin
        BCUpgradeMgtG.SendNotifications_OnBeforeSendNotification(NotificationSendingHeader, SingleNotification, Skip);
    end;

    [EventSubscriber(ObjectType::Report, Report::"Send Notifications", 'OnBeforeSendSMSNotification', '', true, true)]
    local procedure SendNotifications_OnBeforeSendSMSNotification
    (
        var NotificationSendingHeader: Record "Notification Sending Header";
        var IsSpecialSMSNotification: Boolean;
        var IsFailedToSend: Boolean;
        var NotArchived: Boolean;
        var ErrorType: Integer
    )
    begin
        BCUpgradeMgtG.SendNotifications_OnBeforeSendSMSNotification(NotificationSendingHeader, IsSpecialSMSNotification, IsFailedToSend, NotArchived, ErrorType);
    end;

    [EventSubscriber(ObjectType::Report, Report::"Send Notifications", 'OnCreateErrorLog', '', true, true)]
    local procedure SendNotifications_OnCreateErrorLog(var NotificationSendingHeader: Record "Notification Sending Header"; ErrorType: Integer)
    begin
        BCUpgradeMgtG.SendNotifications_OnCreateErrorLog(NotificationSendingHeader, ErrorType);
    end;

    [EventSubscriber(ObjectType::Page, Page::"Customer/ Vehicle History", 'OnBeforeActionEvent', 'Show Document', true, true)]
    local procedure CustVehicleHistory_OnBeforeShowDocument(var Rec: Record "Sales History View")
    begin
        BCUpgradeMgtG.CheckUserRCPermission(Rec);
    end;


    [EventSubscriber(ObjectType::Page, Page::"Notification Entries Fastfit", 'OnAfterOpenPage', '', true, true)]
    local procedure NotificationEntriesFastfit_OnAfterOpenPage(var NotificationSendingHeader: Record "Notification Sending Header")
    begin
        //++MARS_TWN-6783.GG
        NotificationSendingHeader.SetRange("Hold Status", NotificationSendingHeader."Hold Status"::" ");
        //--MARS_TWN-6783.GG
    end;


    [EventSubscriber(ObjectType::Page, Page::"Notification Entries Fastfit", 'OnAfterAfterGetRecord', '', true, true)]
    local procedure NotificationEntriesFastfit_OnAfterAfterGetRecord(Sender: Page "Notification Entries Fastfit")
    begin
        Sender.SetStyleText();
    end;

    //++TWN1.0.0.3.122779.QX
    [EventSubscriber(ObjectType::Table, Database::"Consent Data Line", 'OnAfterValidateEvent', 'Consent Level', true, true)]
    local procedure ConsentDataLine_OnAfterValidateEvent(VAR Rec: Record "Consent Data Line"; VAR xRec: Record "Consent Data Line")
    var
        FastfitSetupNotiL: Record "Fastfit Setup - Notification";
    begin
        FastfitSetupNotiL.Get();
        FastfitSetupNotiL.TestField("Disagreement Code");
        if Rec."Accepts E-Mail" or Rec."Accepts Phone Call" or Rec."Accepts SMS" then
            Rec.Validate("Customer Signed", Rec."Customer Signed"::"Accepted Consent")
        else begin
            Rec.Validate("Customer Signed", Rec."Customer Signed"::"Rejected Consent");
            Rec.Validate("Disagreement Code", FastfitSetupNotiL."Disagreement Code");
        end;
    end;
    //--TWN1.0.0.3.122779.QX

    [EventSubscriber(ObjectType::Table, Database::"Notification Sending Header", 'OnBeforeInsertEvent', '', true, true)]
    local procedure TableNotificationSendingHdr_OnBeforeInsertTriggerSub(var Rec: Record "Notification Sending Header"; RunTrigger: Boolean)
    var
        SingleInstanceL: Codeunit "TW General Single Instance";
        ServiceTypeMasterCodeL: Code[20];
    begin
        if not RunTrigger then
            exit;
        if Rec."Service Type Master" <> '' then
            exit;
        if (Rec."Notification Source" = Rec."Notification Source"::"Customer Sales Visit") and (UPPERCASE(Rec."Notification Source No.") = UPPERCASE('Customer Agreement')) then begin
            SingleInstanceL.GetAgreementServiceTypeMaster(ServiceTypeMasterCodeL);
            Rec."Service Type Master" := ServiceTypeMasterCodeL;
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Notification Sending Header", 'OnBeforeValidateEvent', 'Send E-Mail', true, true)]
    local procedure TableNotificationSendingHdr_OnBeforeValidateSendEmailSub(var Rec: Record "Notification Sending Header"; var xRec: Record "Notification Sending Header"; CurrFieldNo: Integer)
    var
        SingleInstanceL: Codeunit "TW General Single Instance";
        ServiceTypeMasterCodeL: Code[20];
    begin
        if Rec."Service Type Master" <> '' then
            exit;
        if (Rec."Notification Source" = Rec."Notification Source"::"Customer Sales Visit") and (UPPERCASE(Rec."Notification Source No.") = UPPERCASE('Customer Agreement')) then begin
            SingleInstanceL.GetAgreementServiceTypeMaster(ServiceTypeMasterCodeL);
            Rec."Service Type Master" := ServiceTypeMasterCodeL;
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Notification Sending Header", 'OnBeforeValidateEvent', 'Send SMS', true, true)]
    local procedure TableNotificationSendingHdr_OnBeforeValidateSendSMSSub(var Rec: Record "Notification Sending Header"; var xRec: Record "Notification Sending Header"; CurrFieldNo: Integer)
    var
        SingleInstanceL: Codeunit "TW General Single Instance";
        ServiceTypeMasterCodeL: Code[20];
    begin
        if Rec."Service Type Master" <> '' then
            exit;
        if (Rec."Notification Source" = Rec."Notification Source"::"Customer Sales Visit") and (UPPERCASE(Rec."Notification Source No.") = UPPERCASE('Customer Agreement')) then begin
            SingleInstanceL.GetAgreementServiceTypeMaster(ServiceTypeMasterCodeL);
            Rec."Service Type Master" := ServiceTypeMasterCodeL;
        end;
    end;
}
