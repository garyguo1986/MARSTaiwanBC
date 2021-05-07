// +--------------------------------------------------------------
// | ?2020 Incadea China Software System                          |
// +--------------------------------------------------------------+
// | PURPOSE: Local Customization                                 |
// |                                                              |
// | REMARK :                                                     |
// +--------------------------------------------------------------+
// 
// VERSION       ID       WHO    DATE        DESCRIPTION
// RGS_TWN-888   122187	  QX	 2020-12-17  Create Object
// RGS_TWN-888   122187	  GG	 2021-05-06  Fix bug of validation line no. is sales line before no. have value
codeunit 1044866 "BC Upgrade Management"
{
    var
        C_INC_001: Label 'The notifications has been sent.';
        C_INC_002: Label 'sending failed, please refer to notification errors.';
        C_INC_003: label 'You can not show the document because of permission.';
        TWN_SMS_ERR_001: Label '%1 must have a value.';

    [Scope('OnPrem')]
    procedure SalesHeader_OnCampaignNoLookup(var SenderP: Record "Sales Header")
    var
        CampaignL: Record Campaign;
        TempCampaignL: Record Campaign temporary;
        CompaignListL: Page "Campaign List";
    begin
        //++Inc.RGS_TWN-524.NN
        Clear(CampaignL);
        Clear(TempCampaignL);
        CampaignL.Reset;
        TempCampaignL.DeleteAll;
        CampaignL.SetCurrentKey("No.");
        if CampaignL.Find('-') then begin
            repeat
                if CheckInPeriod(SenderP."Document Date", CampaignL."Starting Date", CampaignL."Ending Date") then begin
                    TempCampaignL.Init;
                    TempCampaignL.Copy(CampaignL);
                    TempCampaignL.Insert;
                end;
            until CampaignL.Next = 0;
        end;

        if PAGE.RunModal(PAGE::"Campaign List", TempCampaignL) = ACTION::LookupOK then
            SenderP.Validate("Campaign No.", TempCampaignL."No.");
        //--Inc.RGS_TWN-524.NN

    end;

    [Scope('OnPrem')]
    local procedure CheckInPeriod(CheckDateP: Date; PeriodStartP: Date; PeriodEndP: Date): Boolean;
    begin
        //++Inc.RGS_TWN-524.NN
        if CheckDateP = 0D then exit(true);

        if ((PeriodStartP = 0D) and (PeriodEndP = 0D)) then exit(true);

        if ((PeriodStartP <> 0D) and (PeriodEndP = 0D)) then
            if CheckDateP >= PeriodStartP then exit(true);

        if ((PeriodStartP = 0D) and (PeriodEndP <> 0D)) then
            if CheckDateP <= PeriodEndP then exit(true);

        if ((PeriodStartP <> 0D) and (PeriodEndP <> 0D)) then
            if ((CheckDateP >= PeriodStartP) and (CheckDateP <= PeriodEndP)) then exit(true);

        exit(false);
        //--Inc.RGS_TWN-524.NN
    end;

    [Scope('OnPrem')]
    [TryFunction]
    procedure TryTable(RecVariantP: Variant; TableIDP: Integer)
    var
        ItemJnlLineL: Record "Item Journal Line";
    begin
        if not RecVariantP.IsRecord() then
            Error('');
        case TableIDP of
            database::"Item Journal Line":
                ItemJnlLineL := RecVariantP;
            else
                Error('');
        end;
    end;

    [Scope('OnPrem')]
    procedure MatchcodeSearch_NumberDrilldown(ItemNoP: Code[20])
    var
        ItemL: Record Item;
        ItemCardL: Page "Item Card";
    begin
        //Start 121698
        CLEAR(ItemL);
        CLEAR(ItemCardL);
        IF ItemL.GET(ItemNoP) THEN BEGIN
            ItemCardL.SETTABLEVIEW(ItemL);
            ItemCardL.SETRECORD(ItemL);
            ItemCardL.RUNMODAL;
        END;
        //Stop 121698

    end;

    [Scope('OnPrem')]
    procedure ShoppingBasket_OnBeforeCreateInvoiceAndPost(SalesHeaderP: Record "Sales Header")
    var
        ItemL: Record Item;
        CheckSalesLinesL: Record "Sales Line";
        ItemTrackingMgtL: Codeunit "Item Tracking Management";
        ItemJnlLineL: Record "Item Journal Line";
        SNRequiredL: Boolean;
        SNInfoRequiredL: Boolean;
        LotRequiredL: Boolean;
        LotInfoRequiredL: Boolean;
        ItemTrackingRecL: Record "Item Tracking Code";
        ReservationEntryL: Record "Reservation Entry";
        LotCountL: Decimal;
        SerialNoRequiredErr: Label 'Serial Number is required for Item %1.';
        LotNoRequiredErr: Label 'ENU=Lot Number is required for Item %1.';

    begin
        //++Inc.TWN-631.AH
        CheckSalesLinesL.Reset;
        CheckSalesLinesL.SetRange("Document Type", SalesHeaderP."Document Type");
        CheckSalesLinesL.SetRange("Document No.", SalesHeaderP."No.");
        CheckSalesLinesL.SetRange(Type, CheckSalesLinesL.Type::Item);
        if CheckSalesLinesL.Find('-') then
            repeat
                ItemL.Get(CheckSalesLinesL."No.");
                Clear(ItemTrackingRecL);
                if ItemTrackingRecL.Get(ItemL."Item Tracking Code") then;

                if SalesHeaderP."Internal Order" then
                    ItemJnlLineL."Entry Type" := ItemJnlLineL."Entry Type"::"Negative Adjmt."
                else
                    ItemJnlLineL."Entry Type" := ItemJnlLineL."Entry Type"::Sale;

                ItemJnlLineL."Item No." := CheckSalesLinesL."No.";
                ItemJnlLineL."Quantity (Base)" := CheckSalesLinesL."Qty. to Ship";
                ItemTrackingMgtL.GetItemTrackingSettings(
                  ItemTrackingRecL, ItemJnlLineL."Entry Type", ItemJnlLineL.Signed(ItemJnlLineL."Quantity (Base)") > 0,
                  SNRequiredL, LotRequiredL, SNInfoRequiredL, LotInfoRequiredL);

                if SNRequiredL or LotRequiredL then begin
                    ReservationEntryL.Reset;
                    ReservationEntryL.SetRange("Source ID", CheckSalesLinesL."Document No.");
                    ReservationEntryL.SetRange("Source Ref. No.", CheckSalesLinesL."Line No.");
                    ReservationEntryL.SetRange("Source Type", DATABASE::"Sales Line");
                    ReservationEntryL.SetRange("Source Subtype", 10);
                    ReservationEntryL.SetRange("Source Batch Name", '');
                    ReservationEntryL.SetRange("Source Prod. Order Line", 0);
                    ReservationEntryL.SetFilter("Qty. to Handle (Base)", '<>0');
                    if SNRequiredL then begin
                        ReservationEntryL.SetFilter("Serial No.", '<>%1', '');
                        ReservationEntryL.SetFilter("Lot No.", '=%1', '');
                        if -ReservationEntryL.Count <> CheckSalesLinesL.Quantity then
                            Error(SerialNoRequiredErr, ItemJnlLineL."Item No.");
                    end;
                    if LotRequiredL then begin
                        Clear(LotCountL);
                        ReservationEntryL.SetFilter("Serial No.", '=%1', '');
                        ReservationEntryL.SetFilter("Lot No.", '<>%1', '');
                        if ReservationEntryL.Find('-') then
                            repeat
                                LotCountL += -ReservationEntryL."Qty. to Handle (Base)";
                            until ReservationEntryL.Next = 0;
                        if LotCountL <> CheckSalesLinesL.Quantity then
                            Error(LotNoRequiredErr, ItemJnlLineL."Item No.");
                    end;
                end;
            until CheckSalesLinesL.Next = 0;
        //--Inc.TWN-631.AH
    end;

    [Scope('OnPrem')]
    procedure SalesHeader_SpecialSalespersonLookup
        (
            var SenderP: Record "Sales Header";
            SalespersonCodeP: Code[20];
            IsSalespersonP: Boolean;
            IsRepresentativeP: Boolean;
            IsFitterP: Boolean;
            IsFinalCheckNameP: Boolean;
            var IsSpecialSalespersonLookupP: Boolean;
            var ReturnSalespersonCodeP: Code[20]
        )
    VAR
        SalespersonRec: Record "Salesperson/Purchaser";
        TireSetupL: Record "Fastfit Setup - General";
        //   ApplMgtL: Codeunit ApplicationManagement;
        ApplMgtL: Codeunit "Service Center Management";
    begin
        IsSpecialSalespersonLookupP := true;
        //++BSS.IT_2610.WL
        //++BSS.IT_4405.MH
        // Start RGS_TWN-561
        TireSetupL.Get;
        if (IsSalespersonP and not TireSetupL."No SC Check for Sales Person") or
           (IsRepresentativeP and not TireSetupL."No SC Check for Representative") or
           (IsFitterP and not TireSetupL."No SC Check for Fitter") or
           // Start RGS_TWN-561
           (IsFinalCheckNameP and not TireSetupL."No SC Check for Fin Chk Name") then
            // Stop RGS_TWN-561
            //--BSS.IT_4405.MH
            SalespersonRec.SetFilter("Service Center", SenderP."Service Center" + '|''''')
        // Start 115762
        else begin
            SalespersonRec.FilterGroup(2);
            SalespersonRec.SetFilter("Service Center", ApplMgtL.GetSCVisibilityFilter(1));
            SalespersonRec.FilterGroup(0);
        end;
        // Stop 115762

        if IsSalespersonP then
            SalespersonRec.SetRange("Is Salesperson", true)
        else
            if IsRepresentativeP then
                SalespersonRec.SetRange("Is Representative", true)
            else
                if IsFitterP then
                    SalespersonRec.SetRange("Is Fitter", true)
                // Start RGS_TWN-561
                else
                    if IsFinalCheckNameP then
                        SalespersonRec.SetRange("Is Salesperson", true);
        // Stop RGS_TWN-561

        //++BSS.IT_3273.AP
        SalespersonRec.SetRange(Retired, false);
        //--BSS.IT_3273.AP

        //++BSS.IT_3081.WL
        if SalespersonRec.Get(SalespersonCodeP) then;
        //--BSS.IT_3081.WL
        if PAGE.RunModal(0, SalespersonRec) = ACTION::LookupOK then
            // exit(SalespersonRec.Code);
            ReturnSalespersonCodeP := SalespersonRec.Code;
        //ELSE
        //EXIT('');
        //--BSS.IT_2610.WL
    end;

    [Scope('OnPrem')]
    procedure SalesHeader_SpecialSalespersonValidate
        (
            var SenderP: Record "Sales Header";
            SalespersonCodeP: Code[20];
            IsSalespersonP: Boolean;
            IsRepresentativeP: Boolean;
            IsFitterP: Boolean;
            IsFinalCheckNameP: Boolean;
            var IsSpecialSalespersonValidationP: Boolean;
            var IsValidP: Boolean
        )
    var
        SalespersonRec: Record "Salesperson/Purchaser";
        TireSetupL: Record "Fastfit Setup - General";
    begin
        IsSpecialSalespersonValidationP := true;
        //++BSS.IT_2610.WL
        if SalespersonCodeP <> '' then begin

            //++BSS.IT_4405.MH
            TireSetupL.Get;
            if (IsSalespersonP and not TireSetupL."No SC Check for Sales Person") or
               (IsRepresentativeP and not TireSetupL."No SC Check for Representative") or
               (IsFitterP and not TireSetupL."No SC Check for Fitter") or
               // Start RGS_TWN-561
               (IsFinalCheckNameP and not TireSetupL."No SC Check for Fin Chk Name") then
                // Stop RGS_TWN-561
                //--BSS.IT_4405.MH
                SalespersonRec.SetFilter("Service Center", SenderP."Service Center" + '|''''');

            if IsSalespersonP then
                SalespersonRec.SetRange("Is Salesperson", true)
            else
                if IsRepresentativeP then
                    SalespersonRec.SetRange("Is Representative", true)
                else
                    if IsFitterP then
                        SalespersonRec.SetRange("Is Fitter", true)
                    // Start RGS_TWN-561
                    else
                        if IsFinalCheckNameP then
                            SalespersonRec.SetRange("Is Salesperson", true);
            // Stop RGS_TWN-561

            if SalespersonRec.FindFirst then
                repeat
                    if SalespersonRec.Code = SalespersonCodeP then begin
                        // exit(true);
                        IsValidP := true;
                        exit;
                    end;
                until SalespersonRec.Next = 0;

            // exit(false);
            IsValidP := false;
        end else
            //exit(true);
            IsValidP := true;
        //--BSS.IT_2610.WL
    end;

    [Scope('OnPrem')]
    procedure SalesLine_AfterValidateNo(var Rec: Record "Sales Line"; var xRec: Record "Sales Line"; CurrFieldNoP: Integer)
    var
        Item: Record Item;
        Res: Record Resource;
        Customer: Record Customer;
        CustomerGroup: Record "Customer Group";
    begin
        case Rec.Type of
            Rec.Type::Item:
                begin
                    //++TWN1.00.122187.GG
                    //Item.get(Rec."No.");
                    Clear(Item);
                    if not Item.Get(Rec."No.") then
                        exit;
                    //--TWN1.00.122187.GG
                    // Start 112159
                    Rec."Main Group Code" := Item."Main Group Code";
                    // Stop 112159
                end;
            Rec.Type::Resource:
                begin
                    //++TWN1.00.122187.GG
                    //Res.get(Rec."No.");
                    Clear(Res);
                    if not Res.Get(Rec."No.") then
                        exit;
                    //--TWN1.00.122187.GG                    
                    //++Inc.TWN-459.AH
                    //++TWN1.00.122187.QX
                    // "Item Type" := Item."Item Type";
                    //--TWN1.00.122187.QX
                    Customer.RESET;
                    Customer.GET(Rec."Sell-to Customer No.");
                    CustomerGroup.RESET;
                    CustomerGroup.SETRANGE("Customer Group Code", Customer."Customer Group");
                    IF CustomerGroup.FINDFIRST THEN
                        Rec.Retail := CustomerGroup.Retail;
                    //--Inc.TWN-459.AH

                    // Start 112159                    
                    Rec."Main Group Code" := Res."Main Group Code";
                    // Stop 112159
                end;
        end;
    end;

    [Scope('OnPrem')]
    procedure ContactSearch_OtherSearchResult(var SearchResultP: Record "Contact Search Result"; SearchNameP: Record "Contact Search Name"; UsageP: Option " ",Purchase,Sales)
    var
        ContactL: Record Contact;
        VehicleL: Record Vehicle;
        TireHotelL: Record "Tire Hotel";
    begin
        case SearchNameP.Type of
            SearchNameP.Type::Contact:
                if ContactL.GET(SearchResultP."No.") then begin
                    //Start RGS_TWN-519
                    SearchResultP."Mobile Phone No." := ContactL."Mobile Phone No.";
                    SearchResultP."VAT Registration No." := ContactL."VAT Registration No.";
                    //Stop RGS_TWN-519
                end;
            SearchNameP.Type::Vehicle:
                if UsageP <> UsageP::Purchase then begin
                    if VehicleL.GET(SearchResultP."No.") then begin
                        //++TWN1.00.001.121696.QX
                        SearchResultP."Registration Date" := VehicleL."Registration Date";
                        //--TWN1.00.001.121696.QX
                        if ContactL.GET(VehicleL."Contact No.") then begin
                            //Start RGS_TWN-519
                            SearchResultP."Mobile Phone No." := ContactL."Mobile Phone No.";
                            SearchResultP."VAT Registration No." := ContactL."VAT Registration No.";
                            //Stop RGS_TWN-519
                        end;
                    end;
                end;
            SearchNameP.Type::"Tire Hotel":
                if UsageP <> UsageP::Purchase then begin
                    if TireHotelL.GET(SearchResultP."No.") then begin
                        //++TWN1.00.001.121696.QX
                        if VehicleL.GET(TireHotelL."Vehicle No.") then
                            SearchResultP."Registration Date" := VehicleL."Registration Date"
                        else
                            SearchResultP."Registration Date" := TireHotelL."Registration Date";
                        //--TWN1.00.001.121696.QX
                    end;
                end;
        end;
    end;

    [Scope('OnPrem')]
    procedure SendNotifications_OnAfterPostReport(IsFailedP: Boolean)
    var
        MUTFunctionsL: Codeunit "Usage Tracking";
    begin
        // Start 119434
        IF GUIALLOWED THEN
            //  OnPostReportEvent;
            MUTFunctionsL.AddUsageTrackingEntry('MUT_6500');
        // Stop  119434
        //Start 112952
        IF IsFailedP THEN
            MESSAGE(C_INC_002)
        ELSE
            //Stop 112952
            // Start 112169
            MESSAGE(C_INC_001);
        // Stop 112169
    end;

    [Scope('OnPrem')]
    procedure SendNotifications_OnBeforeSendNotification(var NotificationSendingHeaderP: Record "Notification Sending Header"; SingleNotificationP: Boolean; var SkipP: Boolean)
    begin
        skipP := IsNoteNeedSend(NotificationSendingHeaderP, SingleNotificationP);
    end;

    [Scope('OnPrem')]
    //++TWN1.00.122187.QX
    // LOCAL PROCEDURE IsNoteNeedSend(VAR NotificationSendingHeaderP: Record "Notification Sending Header"): Boolean;
    LOCAL PROCEDURE IsNoteNeedSend(VAR NotificationSendingHeaderP: Record "Notification Sending Header"; SingleNotificationP: Boolean): Boolean;
    //--TWN1.00.122187.QX
    VAR
        CurrDateTimeL: DateTime;
        NoteDateTimeL: DateTime;
    BEGIN
        // Start 112169
        CurrDateTimeL := CREATEDATETIME(TODAY, TIME);
        NoteDateTimeL := CREATEDATETIME(NotificationSendingHeaderP."Notif. Date to send", NotificationSendingHeaderP."Notif. Time to send");
        IF (NoteDateTimeL > CurrDateTimeL) AND (NOT SingleNotificationP) THEN
            EXIT(FALSE);

        //++MARS_TWN-6783.GG
        IF (NotificationSendingHeaderP."Hold Status" = NotificationSendingHeaderP."Hold Status"::"On Hold") THEN
            EXIT(FALSE);
        //--MARS_TWN-6783.GG

        EXIT(TRUE);
        // Stop 112169
    END;

    [Scope('OnPrem')]
    procedure SendNotifications_OnBeforeSendSMSNotification
    (
        var NotificationSendingHeaderP: Record "Notification Sending Header";
        var IsSpecialSMSNotificationP: Boolean;
        var IsFailToSendP: Boolean;
        var NotArchivedP: Boolean;
        var ErrorTypeP: Integer
    )
    var
        EmailItemL: Record "Email Item" temporary;
        OutStreamL: OutStream;
        NotifSendingLineL: Record "Notification Sending Line";
        LinesWrittenL: Integer;
        //ErrorTypeL@1000000004 : Integer;
        SMTPSetupL: Record 409;
        txtSubjectL: Text[200];
        WordWrittenL: Integer;
        ErrNotificationSendingHeaderL: Record "Notification Sending Header";
        BodyTextL: Text;

    begin
        IsSpecialSMSNotificationP := true;
        NotArchivedP := false;
        IsFailToSendP := false;

        //++ Inc.TWN-605.AH
        //++TWN1.00.122187.QX
        // IF "Notification Sending Header"."Contact Mobile Phone No." = '' THEN BEGIN
        //     //ErrNotificationSendingHeaderL.GET("Notification Sending Header"."Notification No.","Notification Sending Header".Type);
        //     //ErrNotificationSendingHeaderL."Error Message" := SYSTEM.STRSUBSTNO(TWN_SMS_ERR_001,"Notification Sending Header".FIELDCAPTION("Contact Mobile Phone No."));
        //     //ErrNotificationSendingHeaderL.RENAME("Notification Sending Header"."Notification No.","Notification Sending Header".Type::Error);
        //     ErrNotificationSendingHeaderL.TRANSFERFIELDS("Notification Sending Header");
        //     ErrNotificationSendingHeaderL.Type := "Notification Sending Header".Type::Error;
        //     ErrNotificationSendingHeaderL."Error Message" := SYSTEM.STRSUBSTNO(TWN_SMS_ERR_001, "Notification Sending Header".FIELDCAPTION("Contact Mobile Phone No."));
        //     IF ErrNotificationSendingHeaderL.INSERT THEN BEGIN
        //         "Notification Sending Header".DELETE;
        //     END;

        //     EXIT;
        // END;
        if NotificationSendingHeaderP."Contact Mobile Phone No." = '' then begin
            NotArchivedP := true;
            ErrorTypeP := 1044860;
            exit;
        end;
        //--TWN1.00.122187.QX

        SMTPSetupL.GET;
        //++TWN1.00.122187.QX
        // EmailItemL.Init;
        EmailItemL.Initialize;
        //--TWN1.00.122187.QX
        EmailItemL."From Name" := SMTPSetupL."Sender Name";
        EmailItemL."From Address" := SMTPSetupL."Sender Address";
        EmailItemL."Send to" := SMTPSetupL."SMS Mail Address";
        txtSubjectL := '<' + CorrectPhoneNo(NotificationSendingHeaderP."Contact Mobile Phone No.") + '>';
        EmailItemL.Subject := GetMD5Hash(txtSubjectL + 'd+EQZYQc') + '@SMS to ' + txtSubjectL;

        // Start 113202
        //EmailItemL.Body.CREATEOUTSTREAM(OutStreamL);

        //NotifSendingLineL.SETRANGE(Type , "Notification Sending Header".Type);
        //NotifSendingLineL.SETRANGE("Notification No." , "Notification Sending Header"."Notification No.");
        //IF NotifSendingLineL.FINDSET THEN
        //  REPEAT
        //    IF LinesWrittenL = 0 THEN BEGIN
        //      NotifSendingLineL.Text := COPYSTR(NotifSendingLineL.Text,1,140);
        //      OutStreamL.WRITETEXT(NotifSendingLineL.Text);
        //      WordWrittenL += STRLEN(NotifSendingLineL.Text);
        //    END ELSE BEGIN
        //      IF STRLEN(NotifSendingLineL.Text) + WordWrittenL+1 <= 140 THEN BEGIN
        //        OutStreamL.WRITETEXT(' ' + NotifSendingLineL.Text);
        //        WordWrittenL += STRLEN(NotifSendingLineL.Text)+1;
        //      END ELSE BEGIN
        //        NotifSendingLineL.Text := COPYSTR(NotifSendingLineL.Text,1,140-(WordWrittenL+1));
        //        OutStreamL.WRITETEXT(NotifSendingLineL.Text);
        //        WordWrittenL += STRLEN(NotifSendingLineL.Text);
        //      END;
        //    END;

        //    LinesWrittenL += 1;
        //  UNTIL (NotifSendingLineL.NEXT = 0) OR (WordWrittenL = 140);
        BodyTextL := '';
        NotifSendingLineL.SETRANGE(Type, NotificationSendingHeaderP.Type);
        NotifSendingLineL.SETRANGE("Notification No.", NotificationSendingHeaderP."Notification No.");
        IF NotifSendingLineL.FINDSET THEN
            REPEAT
                BodyTextL := BodyTextL + NotifSendingLineL.Text;
            UNTIL (NotifSendingLineL.NEXT = 0);
        BodyTextL := COPYSTR(BodyTextL, 1, 140);
        EmailItemL.SetBodyText(BodyTextL);
        EmailItemL.INSERT(TRUE);
        // Stop 113202

        //++TWN1.00.122187.QX
        // ErrorTypeL := EmailItemL.Send(TRUE);
        // IF ErrorTypeL <= 0 THEN
        //     ArchiveNotificationEntry()
        // ELSE BEGIN
        //     //Start 112952
        //     IsFailToSendG := TRUE;
        //     //Stop 112952
        //     CreateErrorLog(ErrorTypeL);
        // END;
        EmailItemL.Send(true);
        ErrorTypeP := EmailItemL.GetErrorType();
        if ErrorTypeP > 0 then begin
            IsFailToSendP := true;
            NotArchivedP := true;
        end;
        //--TWN1.00.122187.QX

        //-- Inc.TWN-605.AH

    end;

    [Scope('OnPrem')]
    PROCEDURE CorrectPhoneNo(LedgerPhoneNo: Text[30]) NewPhnoeNo: Text[30];
    VAR
        TestChar: Text[1];
    BEGIN
        //Inc.TWN-605.AH
        CLEAR(NewPhnoeNo);
        REPEAT
            TestChar := COPYSTR(LedgerPhoneNo, 1, 1);
            LedgerPhoneNo := COPYSTR(LedgerPhoneNo, 2);
            IF (TestChar >= '0') AND (TestChar <= '9') THEN
                NewPhnoeNo := NewPhnoeNo + TestChar;
        UNTIL (STRLEN(LedgerPhoneNo) = 0);
    END;

    [Scope('OnPrem')]
    LOCAL PROCEDURE GetMD5Hash(ToEncryptionStr: Text[1024]): Text[1024];
    VAR
        //++TWN1.00.122187.QX
        // TempBlob: Record Tempblob temporary;
        TempBlob: Codeunit "Temp Blob";
        //--TWN1.00.122187.QX
        SInStream: InStream;
        SOutStream: OutStream;
        DotNETMD5: DotNet SystemSecurityCryptographyMD5;
        BTCon: DotNet SystemBitConverter;
        HashKey: Text[1024];
        TxtUt8EnCoding: DotNet SystemTextUTF8Encoding;
        TxtEnCoder: DotNet SystemTextEncoding;
    BEGIN
        //Inc.TWN-605.AH
        //Automation
        //CREATE(autMD5,TRUE,TRUE);
        //EXIT(autMD5.CalculateMD5(ToEncryptionStr));

        //dotNet Web 4.0.0
        //++TWN1.00.122187.QX
        // TempBlob.Blob.CREATEOUTSTREAM(SOutStream);
        TempBlob.CreateOutStream(SOutStream);
        //--TWN1.00.122187.QX
        SOutStream.WRITETEXT(ToEncryptionStr);
        DotNETMD5 := DotNETMD5.Create();
        //HashKey:= BTCon.ToString(DotNETMD5.ComputeHash(SOutStream));
        TxtUt8EnCoding := TxtEnCoder.UTF8();
        HashKey := BTCon.ToString(DotNETMD5.ComputeHash(TxtUt8EnCoding.GetBytes(ToEncryptionStr)));
        HashKey := DELCHR(LOWERCASE(HashKey), '=', '-');
        EXIT(HashKey);
    END;


    [Scope('OnPrem')]
    procedure SendNotifications_OnCreateErrorLog(var NotificationSendingHeaderP: Record "Notification Sending Header"; ErrorTypeP: Integer)
    begin
        case ErrorTypeP of
            1044860:
                NotificationSendingHeaderP."Error Message" := STRSUBSTNO(TWN_SMS_ERR_001, NotificationSendingHeaderP.FIELDCAPTION("Contact Mobile Phone No."))
        end;
    end;

    [Scope('OnPrem')]
    PROCEDURE CheckUserRCPermission(SalesHistoryViewP: Record "Sales History View");
    VAR
        TireSetupL: Record "Fastfit Setup - General";
        TireSetupUserL: Record "Fastfit Setup - User";
        SalesHeaderL: Record "Sales Header";
        SalesHeaderArchiveL: Record "Sales Header Archive";
        SalesShipmentHeaderL: Record "Sales Shipment Header";
        SalesInvoiceHeaderL: Record "Sales Invoice Header";
        ReturnReceiptHeaderL: Record "Return Receipt Header";
        SalesCrMemoHeaderL: Record "Sales Cr.Memo Header";
        SalesQuoteL: Page "Sales Quote";
        SalesOrderL: Page "Sales Order";
        SalesInvoiceL: Page "Sales Invoice";
        SalesCreditMemoL: Page "Sales Credit Memo";
        BlanketSalesOrderL: Page "Blanket Sales Order";
        SalesReturnOrderL: Page "Sales Return Order";
        PostedSalesShipmentL: Page "Posted Sales Shipment";
        PostedSalesInvoiceL: Page "Posted Sales Invoice";
        PostedReturnReceiptL: Page "Posted Return Receipt";
        PostedSalesCreditMemoL: Page "Posted Sales Credit Memo";
        ShoppingBasketL: Page "Shopping Basket";
        SalesOrderArchiveL: Page "Sales Order Archive";
        SalesQuoteArchiveL: Page "Sales Quote Archive";
        UserMgtL: Codeunit "User Setup Management";
        ApplMgtL: Codeunit "Service Center Management";
        SCMgtL: Codeunit "Service Center Management";
    BEGIN
        //++MARS_TWN-7106_117890_GG
        //Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order,Posted Shipment,Posted Invoice,Posted Return Receipt,Posted Credit Memo,Basket,Archived Quote,Archived Order
        CASE SalesHistoryViewP."Document Type" OF
            0:
                BEGIN
                    SalesHeaderL.RESET;
                    SalesHeaderL.SETFILTER("Service Center", ApplMgtL.GetSCVisibilityFilter(1));
                    SalesHeaderL.SETRANGE("Document Type", SalesHistoryViewP."Document Type");
                    SalesHeaderL.SETRANGE("No.", SalesHistoryViewP."Document No.");
                    IF SalesHeaderL.ISEMPTY THEN
                        ERROR(C_INC_003);
                END;
            1:
                BEGIN
                    SalesHeaderL.RESET;
                    SalesHeaderL.SETFILTER("Service Center", ApplMgtL.GetSCVisibilityFilter(1));
                    SalesHeaderL.SETRANGE("Date Filter", 0D, WORKDATE - 1);
                    TireSetupUserL.GET(USERID);
                    IF TireSetupUserL."Hide Sales Documents" THEN
                        SalesHeaderL.SETRANGE("Hide Document", FALSE)
                    ELSE
                        SalesHeaderL.SETRANGE("Hide Document");
                    SalesHeaderL.SETRANGE("Document Type", SalesHistoryViewP."Document Type");
                    SalesHeaderL.SETRANGE("No.", SalesHistoryViewP."Document No.");
                    IF SalesHeaderL.ISEMPTY THEN
                        ERROR(C_INC_003);
                END;
            2:
                BEGIN
                    SalesHeaderL.RESET;
                    SalesHeaderL.SETFILTER("Service Center", ApplMgtL.GetSCVisibilityFilter(1));
                    SalesHeaderL.SETRANGE("Document Type", SalesHistoryViewP."Document Type");
                    SalesHeaderL.SETRANGE("No.", SalesHistoryViewP."Document No.");
                    IF SalesHeaderL.ISEMPTY THEN
                        ERROR(C_INC_003);
                END;
            3:
                BEGIN
                    SalesHeaderL.RESET;
                    SalesHeaderL.SETFILTER("Service Center", ApplMgtL.GetSCVisibilityFilter(1));
                    SalesHeaderL.SETRANGE("Document Type", SalesHistoryViewP."Document Type");
                    SalesHeaderL.SETRANGE("No.", SalesHistoryViewP."Document No.");
                    IF SalesHeaderL.ISEMPTY THEN
                        ERROR(C_INC_003);
                END;
            4:
                BEGIN
                    SalesHeaderL.RESET;
                    IF UserMgtL.GetSalesFilter <> '' THEN BEGIN
                        SalesHeaderL.SETRANGE("Responsibility Center", UserMgtL.GetSalesFilter);
                    END;
                    IF SCMgtL.GetSalesFilter <> '' THEN BEGIN
                        SalesHeaderL.SETRANGE("Service Center", SCMgtL.GetSalesFilter);
                    END;
                    SalesHeaderL.SETRANGE("Document Type", SalesHistoryViewP."Document Type");
                    SalesHeaderL.SETRANGE("No.", SalesHistoryViewP."Document No.");
                    IF SalesHeaderL.ISEMPTY THEN
                        ERROR(C_INC_003);
                END;
            5:
                BEGIN
                    SalesHeaderL.RESET;
                    IF UserMgtL.GetSalesFilter <> '' THEN BEGIN
                        SalesHeaderL.SETFILTER("Service Center", ApplMgtL.GetSCVisibilityFilter(1));
                    END;
                    SalesHeaderL.SETRANGE("Document Type", SalesHistoryViewP."Document Type");
                    SalesHeaderL.SETRANGE("No.", SalesHistoryViewP."Document No.");
                    IF SalesHeaderL.ISEMPTY THEN
                        ERROR(C_INC_003);
                END;
            6:
                BEGIN
                    SalesShipmentHeaderL.RESET;
                    SalesShipmentHeaderL.SetSecurityFilterOnRespCenter;
                    SalesShipmentHeaderL.SETFILTER("Service Center", ApplMgtL.GetSCVisibilityFilter(0));
                    SalesShipmentHeaderL.SETRANGE("No.", SalesHistoryViewP."Document No.");
                    IF SalesShipmentHeaderL.ISEMPTY THEN
                        ERROR(C_INC_003);
                END;
            7:
                BEGIN
                    SalesInvoiceHeaderL.RESET;
                    SalesInvoiceHeaderL.SetSecurityFilterOnRespCenter;
                    IF ApplMgtL.GetSCVisibilityFilter(0) <> '' THEN BEGIN
                        SalesInvoiceHeaderL.SETFILTER("SC Codes Lines Filter", ApplMgtL.GetSCVisibilityFilter(0));
                        SalesInvoiceHeaderL.CALCFIELDS("SC Codes Lines");
                        SalesInvoiceHeaderL.SETRANGE("SC Codes Lines", TRUE);
                    END;
                    SalesInvoiceHeaderL.SETRANGE("No.", SalesHistoryViewP."Document No.");
                    IF SalesInvoiceHeaderL.ISEMPTY THEN
                        ERROR(C_INC_003);
                END;
            8:
                BEGIN
                    ReturnReceiptHeaderL.RESET;
                    ReturnReceiptHeaderL.SetSecurityFilterOnRespCenter;
                    ReturnReceiptHeaderL.SETFILTER("Service Center", ApplMgtL.GetSCVisibilityFilter(0));
                    ReturnReceiptHeaderL.SETRANGE("No.", SalesHistoryViewP."Document No.");
                    IF ReturnReceiptHeaderL.ISEMPTY THEN
                        ERROR(C_INC_003);
                END;
            9:
                BEGIN
                    SalesCrMemoHeaderL.RESET;
                    SalesCrMemoHeaderL.SetSecurityFilterOnRespCenter;
                    IF ApplMgtL.GetSCVisibilityFilter(0) <> '' THEN BEGIN
                        SalesCrMemoHeaderL.SETFILTER("SC Codes Lines Filter", ApplMgtL.GetSCVisibilityFilter(0));
                        SalesCrMemoHeaderL.CALCFIELDS("SC Codes Lines");
                        SalesCrMemoHeaderL.SETRANGE("SC Codes Lines", TRUE);
                    END;
                    SalesCrMemoHeaderL.SETRANGE("No.", SalesHistoryViewP."Document No.");
                    IF SalesCrMemoHeaderL.ISEMPTY THEN
                        ERROR(C_INC_003);
                END;
            10:
                BEGIN
                    SalesHeaderL.RESET;
                    SalesHeaderL.SETFILTER("Service Center", ApplMgtL.GetSCVisibilityFilter(1));
                    TireSetupL.GetSetup;
                    IF NOT TireSetupL."Other Shopping Baskets visible" THEN BEGIN
                        SalesHeaderL.SETRANGE("User ID", USERID);
                    END;
                    SalesHeaderL.SETRANGE("Document Type", SalesHistoryViewP."Document Type");
                    SalesHeaderL.SETRANGE("No.", SalesHistoryViewP."Document No.");
                    IF SalesHeaderL.ISEMPTY THEN
                        ERROR(C_INC_003);
                END;
            11:
                BEGIN
                END;
            12:
                BEGIN
                END;
        END;
        //--MARS_TWN-7106_117890_GG
    END;

}
