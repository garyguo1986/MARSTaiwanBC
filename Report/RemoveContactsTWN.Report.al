report 1044869 "Remove Contacts (TWN)"
{
    // +--------------------------------------------------------------+
    // | ?2005 ff. Begusch Software Systeme                          |
    // +--------------------------------------------------------------+
    // | PURPOSE: bss.tire additionals                                |
    // |                                                              |
    // | REMARK :                                                     |
    // +--------------------------------------------------------------+
    // 
    // VERSION  ID      WHO    DATE        DESCRIPTION
    // 040000   IT_1349 SK     2005-06-22  log criterias from vehicle and depot
    // 040000   IT_1330 AK     2005-06-29  remove company of contact
    // 050100   IT_4208 SK     2008-06-19  merged to NAV 5.0 SP1
    // 050109   IT_5551 MH     2010-03-05  changes for licence permission check for vehicle and depot
    // 050110   IT_5551bMH     2010-08-31  bugfix for IT_5551
    // 060000   IT_6272 AK     2011-05-02  merged to NAV 2009R2
    // 
    // 070002 IT_20001 1CF 2013-07-01 Upgraded to NAV 7
    // 081200   IT_20913 SG    2016-02-22  Merged to NAV 2016 CU04
    // +----------------------------------------------+
    // | Copyright (c) incadea China                  |
    // +----------------------------------------------+
    // TFS          ID             WHO   DATE        DESCRIPTION
    // 111127                      SY    2018-02-09  Add  DataItem Sales Invoice Header
    // 114096       MARS_TWN_6567  GG    2018-05-09  Add new dataitem "Sales Invoice Line"
    // RGS_TWN-888   122187	       QX	   2020-12-21  Copied from report 5186

    Caption = 'Remove Contacts';
    ProcessingOnly = true;
    UseRequestPage = false;

    dataset
    {
        dataitem("Segment Header"; "Segment Header")
        {
            DataItemTableView = SORTING("No.");
            dataitem("Segment Line"; "Segment Line")
            {
                DataItemLink = "Segment No." = FIELD("No.");
                DataItemTableView = SORTING("Segment No.", "Line No.");
                dataitem(Contact; Contact)
                {
                    DataItemTableView = SORTING("No.");
                    RequestFilterFields = "No.", "Search Name", Type, "Salesperson Code", "Post Code", "Country/Region Code", "Territory Code";
                    dataitem("Contact Profile Answer"; "Contact Profile Answer")
                    {
                        DataItemLink = "Contact No." = FIELD("No.");
                        RequestFilterHeading = 'Profile';

                        trigger OnAfterGetRecord()
                        begin
                            ContactOK := TRUE;
                            CurrReport.BREAK;
                        end;

                        trigger OnPreDataItem()
                        begin
                            IF ContactOK AND (GETFILTERS <> '') THEN
                                ContactOK := FALSE
                            ELSE
                                CurrReport.BREAK;
                        end;
                    }
                    dataitem("Contact Mailing Group"; "Contact Mailing Group")
                    {
                        DataItemLink = "Contact No." = FIELD("No.");
                        DataItemTableView = SORTING("Contact No.", "Mailing Group Code");
                        RequestFilterFields = "Mailing Group Code";
                        RequestFilterHeading = 'Mailing Group';

                        trigger OnAfterGetRecord()
                        begin
                            ContactOK := TRUE;
                            CurrReport.BREAK;
                        end;

                        trigger OnPreDataItem()
                        begin
                            IF ContactOK AND (GETFILTERS <> '') THEN
                                ContactOK := FALSE
                            ELSE
                                CurrReport.BREAK;
                        end;
                    }
                    dataitem("Interaction Log Entry"; "Interaction Log Entry")
                    {
                        DataItemLink = "Contact Company No." = FIELD("Company No."),
                                       "Contact No." = FIELD("No.");
                        DataItemTableView = SORTING("Contact Company No.", "Contact No.", Date);
                        RequestFilterFields = Date, "Segment No.", "Campaign No.", Evaluation, "Interaction Template Code", "Salesperson Code";

                        trigger OnAfterGetRecord()
                        begin
                            ContactOK := TRUE;
                            CurrReport.BREAK;
                        end;

                        trigger OnPreDataItem()
                        begin
                            IF ContactOK AND (GETFILTERS <> '') THEN
                                ContactOK := FALSE
                            ELSE
                                CurrReport.BREAK;
                        end;
                    }
                    dataitem("Contact Job Responsibility"; "Contact Job Responsibility")
                    {
                        DataItemLink = "Contact No." = FIELD("No.");
                        DataItemTableView = SORTING("Contact No.", "Job Responsibility Code");
                        RequestFilterFields = "Job Responsibility Code";
                        RequestFilterHeading = 'Job Responsibility';

                        trigger OnAfterGetRecord()
                        begin
                            ContactOK := TRUE;
                            CurrReport.BREAK;
                        end;

                        trigger OnPreDataItem()
                        begin
                            IF ContactOK AND (GETFILTERS <> '') THEN
                                ContactOK := FALSE
                            ELSE
                                CurrReport.BREAK;
                        end;
                    }
                    dataitem("Contact Industry Group"; "Contact Industry Group")
                    {
                        DataItemLink = "Contact No." = FIELD("Company No.");
                        DataItemTableView = SORTING("Contact No.", "Industry Group Code");
                        RequestFilterFields = "Industry Group Code";
                        RequestFilterHeading = 'Industry Group';

                        trigger OnAfterGetRecord()
                        begin
                            ContactOK := TRUE;
                            CurrReport.BREAK;
                        end;

                        trigger OnPreDataItem()
                        begin
                            IF ContactOK AND (GETFILTERS <> '') THEN
                                ContactOK := FALSE
                            ELSE
                                CurrReport.BREAK;
                        end;
                    }
                    dataitem("Contact Business Relation"; "Contact Business Relation")
                    {
                        DataItemLink = "Contact No." = FIELD("Company No.");
                        DataItemTableView = SORTING("Contact No.", "Business Relation Code");
                        RequestFilterFields = "Business Relation Code";
                        RequestFilterHeading = 'Business Relation';
                        dataitem("Value Entry"; "Value Entry")
                        {
                            DataItemTableView = SORTING("Source Type", "Source No.", "Item No.", "Posting Date");
                            RequestFilterFields = "Item No.", "Variant Code", "Posting Date", "Inventory Posting Group";

                            trigger OnAfterGetRecord()
                            begin
                                ContactOK := TRUE;
                                CurrReport.BREAK;
                            end;

                            trigger OnPreDataItem()
                            begin
                                IF SkipItemLedgerEntry THEN
                                    CurrReport.BREAK;

                                CASE "Contact Business Relation"."Link to Table" OF
                                    "Contact Business Relation"."Link to Table"::Customer:
                                        BEGIN
                                            SETRANGE("Source Type", "Source Type"::Customer);
                                            SETRANGE("Source No.", "Contact Business Relation"."No.");
                                        END;
                                    "Contact Business Relation"."Link to Table"::Vendor:
                                        BEGIN
                                            SETRANGE("Source Type", "Source Type"::Vendor);
                                            SETRANGE("Source No.", "Contact Business Relation"."No.");
                                        END
                                    ELSE
                                        CurrReport.BREAK;
                                END;
                            end;
                        }

                        trigger OnAfterGetRecord()
                        begin
                            SkipItemLedgerEntry := FALSE;
                            IF NOT ItemFilters THEN BEGIN
                                ContactOK := TRUE;
                                SkipItemLedgerEntry := TRUE;
                                CurrReport.BREAK;
                            END;
                        end;

                        trigger OnPreDataItem()
                        begin
                            IF ContactOK AND ((GETFILTERS <> '') OR ItemFilters) THEN
                                ContactOK := FALSE
                            ELSE
                                CurrReport.BREAK;
                        end;
                    }
                    dataitem(Vehicle; Vehicle)
                    {

                        trigger OnAfterGetRecord()
                        begin
                            ContactOK := TRUE;
                            CurrReport.BREAK;
                        end;

                        trigger OnPreDataItem()
                        begin
                            //++BSS.IT_5551.MH
                            LicPermission.GET(LicPermission."Object Type"::Table, DATABASE::Vehicle);
                            IF LicPermission."Execute Permission" <> LicPermission."Execute Permission"::Yes THEN
                                CurrReport.BREAK;
                            //--BSS.IT_5551.MH

                            IF ContactOK AND (GETFILTERS <> '') THEN
                                ContactOK := FALSE
                            ELSE
                                CurrReport.BREAK;

                            //++BSS.IT_5551b.MH
                            Vehicle.SETCURRENTKEY("Contact No.");
                            Vehicle.SETRANGE("Contact No.", Contact."No.");
                            //--BSS.IT_5551b.MH
                        end;
                    }
                    dataitem("Tire Hotel"; "Tire Hotel")
                    {

                        trigger OnAfterGetRecord()
                        begin
                            ContactOK := TRUE;
                            CurrReport.BREAK;
                        end;

                        trigger OnPreDataItem()
                        begin
                            //++BSS.IT_5551.MH
                            LicPermission.GET(LicPermission."Object Type"::Table, DATABASE::"Tire Hotel");
                            IF LicPermission."Execute Permission" <> LicPermission."Execute Permission"::Yes THEN
                                CurrReport.BREAK;
                            //--BSS.IT_5551.MH

                            IF ContactOK AND (GETFILTERS <> '') THEN
                                ContactOK := FALSE
                            ELSE
                                CurrReport.BREAK;

                            //++BSS.IT_5551b.MH
                            "Tire Hotel".SETCURRENTKEY("Contact No.");
                            "Tire Hotel".SETRANGE("Contact No.", Contact."No.");
                            //--BSS.IT_5551b.MH
                        end;
                    }
                    dataitem("Sales Invoice Header"; "Sales Invoice Header")
                    {
                        DataItemLink = "Sell-to Contact No." = FIELD("No.");

                        trigger OnAfterGetRecord()
                        begin
                            //Start 111127
                            ContactOK := TRUE;
                            CurrReport.BREAK;
                            //Stop 111127
                        end;

                        trigger OnPreDataItem()
                        begin
                            //Start 111127
                            IF ContactOK AND (GETFILTERS <> '') THEN
                                ContactOK := FALSE
                            ELSE
                                CurrReport.BREAK;
                            //Stop 111127
                        end;
                    }
                    dataitem("Sales Invoice Line"; "Sales Invoice Line")
                    {
                        DataItemLink = "Sell-to Contact No." = FIELD("No.");

                        trigger OnAfterGetRecord()
                        begin
                            //Start 114096
                            ContactOK := TRUE;
                            CurrReport.BREAK;
                            //Stop 114096
                        end;

                        trigger OnPreDataItem()
                        begin
                            //Start 114096
                            IF ContactOK AND (GETFILTERS <> '') THEN
                                ContactOK := FALSE
                            ELSE
                                CurrReport.BREAK;
                            //Stop 114096
                        end;
                    }
                    dataitem(Integer; Integer)
                    {
                        DataItemTableView = SORTING(Number)
                                            WHERE(Number = CONST(1));

                        trigger OnAfterGetRecord()
                        begin
                            IF ContactOK THEN
                                InsertContact(Contact);
                        end;
                    }

                    trigger OnAfterGetRecord()
                    begin
                        IF EntireCompanies THEN BEGIN
                            IF TempCheckCont.GET("No.") THEN
                                CurrReport.SKIP;
                            TempCheckCont := Contact;
                            TempCheckCont.INSERT;
                        END;

                        ContactOK := TRUE;
                    end;

                    trigger OnPreDataItem()
                    begin
                        FILTERGROUP(4);
                        SETRANGE("Company No.", "Segment Line"."Contact Company No.");
                        IF NOT EntireCompanies THEN
                            SETRANGE("No.", "Segment Line"."Contact No.");
                        FILTERGROUP(0);
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    RecordNo := RecordNo + 1;
                    IF RecordNo = 1 THEN BEGIN
                        OldTime := TIME;
                        CASE MainReportNo OF
                            REPORT::"Remove Contacts - Reduce":
                                Window.OPEN(Text000);
                            REPORT::"Remove Contacts - Refine":
                                Window.OPEN(Text001);
                        END;
                        NoOfRecords := COUNT;
                    END;
                    NewTime := TIME;
                    IF (NewTime - OldTime > 100) OR (NewTime < OldTime) THEN BEGIN
                        NewProgress := ROUND(RecordNo / NoOfRecords * 100, 1);
                        IF NewProgress <> OldProgress THEN BEGIN
                            Window.UPDATE(1, NewProgress * 100);
                            OldProgress := NewProgress;
                        END;
                        OldTime := TIME;
                    END;
                end;
            }
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPostReport()
    begin
        IF EntireCompanies THEN
            AddPeople;

        //++BSS.IT_1330.AK
        IF CompanyOfContact THEN
            AddCompany;
        //--BSS.IT_1330.AK

        UpdateSegLines;
    end;

    trigger OnPreReport()
    begin
        ItemFilters := "Value Entry".HASFILTER;

        //++BSS.IT_1330.AK
        SegCriteriaManagement.SetAddCriteriaAction(CompanyOfContact);
        //--BSS.IT_1330.AK

        SegCriteriaManagement.InsertCriteriaAction(
          "Segment Header".GETFILTER("No."), MainReportNo,
          FALSE, FALSE, FALSE, FALSE, EntireCompanies);
        SegCriteriaManagement.InsertCriteriaFilter(
          "Segment Header".GETFILTER("No."), DATABASE::Contact,
          Contact.GETFILTERS, Contact.GETVIEW(FALSE));
        SegCriteriaManagement.InsertCriteriaFilter(
          "Segment Header".GETFILTER("No."), DATABASE::"Contact Profile Answer",
          "Contact Profile Answer".GETFILTERS, "Contact Profile Answer".GETVIEW(FALSE));
        SegCriteriaManagement.InsertCriteriaFilter(
          "Segment Header".GETFILTER("No."), DATABASE::"Contact Mailing Group",
          "Contact Mailing Group".GETFILTERS, "Contact Mailing Group".GETVIEW(FALSE));
        SegCriteriaManagement.InsertCriteriaFilter(
          "Segment Header".GETFILTER("No."), DATABASE::"Interaction Log Entry",
          "Interaction Log Entry".GETFILTERS, "Interaction Log Entry".GETVIEW(FALSE));
        SegCriteriaManagement.InsertCriteriaFilter(
          "Segment Header".GETFILTER("No."), DATABASE::"Contact Job Responsibility", "Contact Job Responsibility".GETFILTERS,
          "Contact Job Responsibility".GETVIEW(FALSE));
        SegCriteriaManagement.InsertCriteriaFilter(
          "Segment Header".GETFILTER("No."), DATABASE::"Contact Industry Group",
          "Contact Industry Group".GETFILTERS, "Contact Industry Group".GETVIEW(FALSE));
        SegCriteriaManagement.InsertCriteriaFilter(
          "Segment Header".GETFILTER("No."), DATABASE::"Contact Business Relation",
          "Contact Business Relation".GETFILTERS, "Contact Business Relation".GETVIEW(FALSE));
        SegCriteriaManagement.InsertCriteriaFilter(
          "Segment Header".GETFILTER("No."), DATABASE::"Value Entry",
          "Value Entry".GETFILTERS, "Value Entry".GETVIEW(FALSE));


        //++BSS.IT_5551.MH
        LicPermission.GET(LicPermission."Object Type"::Table, DATABASE::Vehicle);
        IF LicPermission."Execute Permission" = LicPermission."Execute Permission"::Yes THEN
            //--BSS.IT_5551.MH
            //++BSS.IT_1349.SK
            SegCriteriaManagement.InsertCriteriaFilter(
          "Segment Header".GETFILTER("No."), DATABASE::Vehicle,
          Vehicle.GETFILTERS, Vehicle.GETVIEW(FALSE));
        //++BSS.IT_5551.MH
        LicPermission.GET(LicPermission."Object Type"::Table, DATABASE::"Tire Hotel");
        IF LicPermission."Execute Permission" = LicPermission."Execute Permission"::Yes THEN
            //--BSS.IT_5551.MH
            SegCriteriaManagement.InsertCriteriaFilter(
          "Segment Header".GETFILTER("No."), DATABASE::"Tire Hotel",
          "Tire Hotel".GETFILTERS, "Tire Hotel".GETVIEW(FALSE));
        //--BSS.IT_1349.SK

        //Start 111127
        SegCriteriaManagement.InsertCriteriaFilter(
          "Segment Header".GETFILTER("No."), DATABASE::"Sales Invoice Header",
          "Sales Invoice Header".GETFILTERS, "Sales Invoice Header".GETVIEW(FALSE));
        //Stop 111127
        // Start 114096
        SegCriteriaManagement.InsertCriteriaFilter(
          "Segment Header".GETFILTER("No."), DATABASE::"Sales Invoice Line",
          "Sales Invoice Line".GETFILTERS, "Sales Invoice Line".GETVIEW(FALSE));
        // Stop 114096
    end;

    var
        Text000: Label 'Reducing Contacts @1@@@@@@@@@@@@@';
        Text001: Label 'Refining Contacts @1@@@@@@@@@@@@@';
        TempCont: Record Contact temporary;
        TempCont2: Record Contact temporary;
        TempCheckCont: Record Contact temporary;
        Cont: Record Contact;
        SegLine: Record "Segment Line";
        SegmentHistoryMgt: Codeunit SegHistoryManagement;
        SegCriteriaManagement: Codeunit SegCriteriaManagement;
        MainReportNo: Integer;
        ItemFilters: Boolean;
        ContactOK: Boolean;
        EntireCompanies: Boolean;
        SkipItemLedgerEntry: Boolean;
        Window: Dialog;
        NoOfRecords: Integer;
        RecordNo: Integer;
        OldTime: Time;
        NewTime: Time;
        OldProgress: Integer;
        NewProgress: Integer;
        CompanyOfContact: Boolean;
        LicPermission: Record "License Permission";

    [Scope('OnPrem')]
    procedure SetOptions(CalledFromReportNo: Integer; OptionEntireCompanies: Boolean)
    begin
        MainReportNo := CalledFromReportNo;
        EntireCompanies := OptionEntireCompanies;
    end;

    local procedure InsertContact(var CheckedCont: Record Contact)
    begin
        TempCont := CheckedCont;
        IF TempCont.INSERT THEN;
    end;

    local procedure AddPeople()
    begin
        TempCont.RESET;
        IF TempCont.FIND('-') THEN
            REPEAT
                IF TempCont."Company No." <> '' THEN BEGIN
                    Cont.SETCURRENTKEY("Company No.");
                    Cont.SETRANGE("Company No.", TempCont."Company No.");
                    IF Cont.FIND('-') THEN
                        REPEAT
                            TempCont2 := Cont;
                            IF TempCont2.INSERT THEN;
                        UNTIL Cont.NEXT = 0
                END ELSE BEGIN
                    TempCont2 := TempCont;
                    TempCont2.INSERT;
                END;
            UNTIL TempCont.NEXT = 0;

        TempCont.DELETEALL;
        IF TempCont2.FIND('-') THEN
            REPEAT
                TempCont := TempCont2;
                TempCont.INSERT;
            UNTIL TempCont2.NEXT = 0;
        TempCont2.DELETEALL;
    end;

    local procedure UpdateSegLines()
    begin
        SegLine.RESET;
        SegLine.SETRANGE("Segment No.", "Segment Header"."No.");
        IF SegLine.FIND('-') THEN
            REPEAT
                CASE MainReportNo OF
                    REPORT::"Remove Contacts - Reduce":
                        IF TempCont.GET(SegLine."Contact No.") THEN BEGIN
                            SegLine.DELETE(TRUE);
                            SegmentHistoryMgt.DeleteLine(
                              SegLine."Segment No.", SegLine."Contact No.", SegLine."Line No.");
                        END;
                    REPORT::"Remove Contacts - Refine":
                        IF NOT TempCont.GET(SegLine."Contact No.") THEN BEGIN
                            SegLine.DELETE(TRUE);
                            SegmentHistoryMgt.DeleteLine(
                              SegLine."Segment No.", SegLine."Contact No.", SegLine."Line No.");
                        END;
                END;
            UNTIL SegLine.NEXT = 0;
    end;

    [Scope('OnPrem')]
    procedure SetAddOptions(OptionCompanyOfContact: Boolean)
    begin
        CompanyOfContact := OptionCompanyOfContact;
        IF CompanyOfContact THEN
            EntireCompanies := TRUE;
    end;

    [Scope('OnPrem')]
    procedure AddCompany()
    begin
        TempCont.RESET;
        TempCont.SETCURRENTKEY("Company No.");
        TempCont.SETRANGE(Type, TempCont.Type::Person);
        IF TempCont.FIND('-') THEN
            REPEAT
                TempCont.SETRANGE("Company No.", TempCont."Company No.");
                TempCont.SETRANGE(Type, TempCont.Type::Company);
                IF TempCont.COUNT = 0 THEN
                    IF Cont.GET(TempCont."Company No.") THEN
                        InsertContact(Cont);

                TempCont.SETRANGE("Company No.");
                TempCont.SETRANGE(Type, TempCont.Type::Person);

            UNTIL TempCont.NEXT = 0;
    end;
}

