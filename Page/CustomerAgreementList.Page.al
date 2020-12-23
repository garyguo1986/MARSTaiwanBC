page 50020 "Customer Agreement List"
{
    // +--------------------------------------------------------------+
    // | @ 2017 incadea Taiwan Limited                                |
    // +--------------------------------------------------------------+
    // | PURPOSE: MARS_TWN                                            |
    // |                                                              |
    // | REMARK :                                                     |
    // +--------------------------------------------------------------+
    // 
    // VERSION     ID          WHO    DATE        DESCRIPTION
    // TWN.01.03   RGS_TWN-327 AH     2017-04-20  Maintain Customer Agreement Detail Content
    // TWN.01.03   RGS_TWN-327 AH     2017-04-20  Connect Print/Update function
    // TWN.01.03   RGS_TWN-327 AH     2017-04-20  If user agree, send SMS
    // TWN.01.03   RGS_TWN-327 AH     2017-04-20  change user selection message
    // 119434      RGS_TWN-837 WP     2019-05-15  Add publisher OnPostReportEvent

    AutoSplitKey = true;
    Caption = 'Customer Agreement List';
    Editable = false;
    PageType = ListPlus;
    RefreshOnActivate = true;
    SourceTable = "Customer Agreement Detail";
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            group("Customer Agreement List")
            {
                Caption = 'Customer Agreement List';
                //The GridLayout property is only supported on controls of type Grid
                //GridLayout = Columns;
                field("No.";
                ContactInfo."No.")
                {
                    Caption = 'Contact No.';
                    Editable = false;
                }
                field("Personal Data Status"; FORMAT(ContactInfo."Personal Data Status"))
                {
                    Caption = 'Personal Data Status';
                    Editable = false;
                }
                field("Personal Data Agreement Date";
                ContactInfo."Personal Data Agreement Date")
                {
                    Caption = 'Personal Data Agreement Date';
                    Editable = false;
                }
            }
            repeater(Group)
            {
                Editable = false;
                field("Entry No."; "Entry No.")
                {
                    Caption = 'Entry No.';
                    Visible = false;
                }
                field(Content; Content)
                {
                    Caption = 'Content';
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action("Print Agreement")
            {
                Caption = 'Print Agreement';
                Image = Print;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;

                trigger OnAction()
                var
                    PrintAgreement: Codeunit "Customer Agreement Function";
                begin
                    //++Inc.TWN-327.AH
                    CLEAR(PrintAgreement);
                    PrintAgreement.PrintAgreementDetail(ContactInfo."No.", ContactInfo."Personal Data Status");
                    //--Inc.TWN-327.AH
                end;
            }
            action("Agreement Confirm")
            {
                Caption = 'Agreement Confirm';
                Image = Confirm;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = ShowActionG;

                trigger OnAction()
                var
                    UpdateAgreement: Codeunit "Customer Agreement Function";
                    Selection: Integer;
                    SelectionText: Option ,"accept this agreement.","decline this agreement.","not available.";
                    cuSMSMgtL: Codeunit "Notification Functions";
                    LMSG001: Label '&1  Yes,&2  No,&3  N/A';
                    LMSG002: Label 'Contact %1 ';
                    LMSG_YES: Label 'Contact %1 accept this agreement.';
                    LMSG_NO: Label 'Contact %1 decline this agreement.';
                    LMSG_NA: Label 'Contact %1 not available.';
                begin
                    //++Inc.TWN-327.AH
                    CLEAR(Selection);
                    Selection := STRMENU(LMSG001, 1);
                    IF (Selection > 0) THEN BEGIN
                        SelectionText := Selection;
                        CLEAR(UpdateAgreement);
                        UpdateAgreement.UpdateContactAgreement(ContactInfo."No.", Selection);
                        //++Inc.TWN-327.AH
                        // MESSAGE(LMSG002+FORMAT(SelectionText),ContactInfo."No.");
                        IF Selection = 1 THEN
                            ContactInfo.TESTFIELD("Mobile Phone No.");

                        CASE Selection OF
                            1:
                                MESSAGE(LMSG_YES, ContactInfo."No.");
                            2:
                                MESSAGE(LMSG_NO, ContactInfo."No.");
                            3:
                                MESSAGE(LMSG_NA, ContactInfo."No.");
                        END;
                        //--Inc.TWN-327.AH

                        //++Inc.TWN-327.AH
                        IF Selection = 1 THEN BEGIN
                            CLEAR(cuSMSMgtL);
                            ContactInfo.TESTFIELD("Mobile Phone No.");
                            cuSMSMgtL.DC_CustomerAgreement(ContactInfo."No.", ContactInfo."No.");
                        END;
                        //--Inc.TWN-327.AH
                        // Start 119434
                        OnActionAgreementConfirmEvent(Selection);
                        // Stop  119434

                        CurrPage.CLOSE;
                    END;
                    //--Inc.TWN-327.AH
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        FlashForm;

        CLEAR(CompanyInfo);
        CompanyInfo.GET;

        CLEAR(CustAgreementDetail);
        IF CustAgreementDetail.FIND('-') THEN BEGIN
            REPEAT
                Rec.INIT;
                Rec.COPY(CustAgreementDetail);
                Rec.Content := STRSUBSTNO(Rec.Content, CompanyInfo.Name + CompanyInfo."Name 2");
                Rec.INSERT;
            UNTIL CustAgreementDetail.NEXT = 0;
        END;
    end;

    var
        ContactInfo: Record Contact;
        CustAgreementDetail: Record "Customer Agreement Detail";
        CompanyInfo: Record "Company Information";
        [InDataSet]
        ShowActionG: Boolean;

    [Scope('OnPrem')]
    procedure SetContact(ContactNo: Code[20])
    begin
        IF (ContactNo <> '') THEN BEGIN
            IF (NOT ContactInfo.GET(ContactNo)) THEN CLEAR(ContactInfo);
        END ELSE BEGIN
            CLEAR(ContactInfo);
        END;
    end;

    [Scope('OnPrem')]
    procedure FlashForm()
    begin
        IF (ContactInfo."No." = '') THEN BEGIN
            ShowActionG := FALSE;
        END ELSE BEGIN
            ShowActionG := TRUE;
        END;
    end;

    [IntegrationEvent(TRUE, TRUE)]
    local procedure OnActionAgreementConfirmEvent(SelectionOptP: Integer)
    begin
    end;
}

