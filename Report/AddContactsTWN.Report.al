report 1044870 "Add Contacts (TWN)"
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
    // 040000   COR001  SK     2005-02-29  added vehicle and tire depot
    // 040000   IT_1330 AK     2005-06-22  add. field  "Company of Contact" in request options form allows
    //                                     that only the company contact is added
    // 040000   IT_1349 SK     2005-06-22  log criterias from vehicle and depot
    // 040200   IT_2865 SK     2006-09-29  merged to SP2
    // 050100   IT_4208 SK     2008-06-19  merged to NAV 5.0 SP1
    // 050109   IT_5551 MH     2010-03-05  licence permission check for vehicle and depot
    // 050110   IT_5551bMH     2010-08-31  bugfix for IT_5551
    // 060000   IT_6272 AK     2011-05-02  merged to NAV 2009R2
    // 060100   IT_6529 SS     2011-07-27  check for last LineNo. in Segmnet Line Table.
    // 060100   IT_6637 SS     2011-10-31  Added segmenting contacts over vehicle and depot
    // 
    // 070002 IT_20001 1CF 2013-07-01  Upgraded to NAV 7
    // 070008   IT_20002 1CF   2013-11-08  Added parameter to function MARKEDONLY
    // 080200   IT_20478 SS    2015-04-10  correction for Vehicle Filter
    // 081200   IT_20913 SG    2016-02-22  Merged to NAV 2016 CU04
    // 083000   IT_21249 MH    2017-01-27  changed all occurences of "Depot" to "Tire Hotel"
    // 084010   IT_21567 CM    2017-09-27  added mode to run this report as check only
    // 
    // +----------------------------------------------+
    // | Copyright (c) incadea China                  |
    // +----------------------------------------------+
    // TFS          ID             WHO    DATE        DESCRIPTION
    // 111127                      SY     2018-02-09  Add  DataItem Sales Invoice Header
    // 111127                      DY     2018-02-23  Change Default Filter field
    // 112168       MARS_TWN-6450  GG     2018-03-12  Add new filter "Personal Data Status"
    // 114096       MARS_TWN-6567  GG     2018-05-09  Remove some dataitems and add new dataitem "Sales Invoice Line"
    // 115402       MARS_TWN-6798  GG     2018-07-16  Merge standard function to release contact fix bug on sales order
    // RGS_TWN-888   122187	       QX	  2020-12-21  Copied from report 5198

    Caption = 'Add Contacts';
    ProcessingOnly = true;

    dataset
    {
        dataitem("Segment Header"; "Segment Header")
        {
            DataItemTableView = SORTING("No.");
        }
        dataitem(Contact; Contact)
        {
            DataItemTableView = SORTING("No.");
            RequestFilterFields = "Personal Data Status", "Mobile Phone No.", "Date of Last Interaction", "Salesperson Code", "VAT Registration No.", "Date of Birth", "Post Code";
            dataitem(Vehicle; Vehicle)
            {

                trigger OnAfterGetRecord()
                begin
                    //++BSS.IT_20478.SS
                    VehicleTempG.TransferFields(Vehicle);
                    VehicleTempG.Insert;
                    //--BSS.IT.20478.SS

                    //++BSS.COR001.SK
                    ContactOK := true;
                    //++BSS.IT_6637.SS
                    if VehicleG.Get(Vehicle."Vehicle No.") then
                        VehicleG.Mark(true);
                    //old code
                    //CurrReport.BREAK;
                    //--BSS.IT_6637.SS

                    //--BSS.COR001.SK
                end;

                trigger OnPreDataItem()
                begin
                    //++BSS.IT_5551.MH
                    LicPermission.Get(LicPermission."Object Type"::Table, DATABASE::Vehicle);
                    if LicPermission."Execute Permission" <> LicPermission."Execute Permission"::Yes then
                        CurrReport.Break;

                    //++BSS.IT_5551b.MH
                    //Vehicle.SETCURRENTKEY("Contact No.");
                    //Vehicle.SETRANGE("Contact No.", Contact."No.");
                    //--BSS.IT_5551.MH
                    //--BSS.IT_5551b.MH

                    //++BSS.COR001.SK
                    if ContactOK and (GetFilters <> '') then
                        ContactOK := false
                    else
                        CurrReport.Break;
                    //--BSS.COR001.SK

                    //++BSS.IT_5551b.MH
                    Vehicle.SetCurrentKey("Contact No.");
                    Vehicle.SetRange("Contact No.", Contact."No.");
                    //--BSS.IT_5551b.MH
                end;
            }
            dataitem("Sales Invoice Header"; "Sales Invoice Header")
            {
                DataItemLink = "Sell-to Contact No." = FIELD("No.");
                DataItemTableView = SORTING("No.");
                RequestFilterFields = "No.", "Posting Date", "Bill-to Contact No.";

                trigger OnAfterGetRecord()
                begin
                    //Start 111127
                    ContactOK := true;
                    CurrReport.Break;
                    //Stop 111127
                end;

                trigger OnPreDataItem()
                begin
                    //Start 111127
                    if ContactOK and (GetFilters <> '') then
                        ContactOK := false
                    else
                        CurrReport.Break;
                    //Stop 111127
                end;
            }
            dataitem("Sales Invoice Line"; "Sales Invoice Line")
            {
                DataItemLink = "Sell-to Contact No." = FIELD("No.");
                DataItemTableView = SORTING("Document No.", "Line No.") ORDER(Ascending);
                RequestFilterFields = "Main Group Code", Type, "No.";

                trigger OnAfterGetRecord()
                begin
                    //Start 114096
                    ContactOK := true;
                    CurrReport.Break;
                    //Stop 114096
                end;

                trigger OnPreDataItem()
                begin
                    //Start 114096
                    if ContactOK and (GetFilters <> '') then
                        ContactOK := false
                    else
                        CurrReport.Break;
                    //Stop 114096
                end;
            }
            dataitem("Integer"; "Integer")
            {
                DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));

                trigger OnAfterGetRecord()
                begin
                    if ContactOK then
                        InsertContact(Contact);
                end;
            }

            trigger OnAfterGetRecord()
            begin
                RecordNo := RecordNo + 1;
                if RecordNo = 1 then begin
                    Window.Open(Text000);
                    NoOfRecords := Count;
                    OldTime := Time;
                end;
                NewTime := Time;
                if (NewTime - OldTime > 100) or (NewTime < OldTime) then begin
                    NewProgress := Round(RecordNo / NoOfRecords * 100, 1);
                    if NewProgress <> OldProgress then begin
                        Window.Update(1, NewProgress * 100);
                        OldProgress := NewProgress;
                    end;
                    OldTime := Time;
                end;

                ContactOK := true;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(AllowExistingContact; AllowExistingContact)
                    {
                        Caption = 'Allow Existing Contacts';
                    }
                    field(ExpandCompanies; ExpandCompanies)
                    {
                        Caption = 'Expand Companies';
                    }
                    field(AllowCoRepdByContPerson; AllowCoRepdByContPerson)
                    {
                        Caption = 'Allow Related Companies';
                        MultiLine = true;
                    }
                    field(IgnoreExclusion; IgnoreExclusion)
                    {
                        Caption = 'Ignore Exclusion';
                    }
                    field(CompanyOfContact; CompanyOfContact)
                    {
                        Caption = 'Company of Contact';
                    }
                }
            }
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
        if ExpandCompanies then
            AddPeople;

        //++BSS.IT_1330.KA
        if CompanyOfContact then begin
            AddCompany;
            DeletePeople;
        end;
        //--BSS.IT_1330.KA

        if not AllowCoRepdByContPerson then
            DeleteCompanies;

        //++BSS.IT_21567.CM
        if not CheckOnly then
            //--BSS.IT_21567.CM
            UpdateSegLines;
    end;

    trigger OnPreReport()
    begin
        // Start 114096
        //ItemFilters := "Value Entry".HASFILTER;
        // Stop 114096

        //++BSS.IT_21567.CM
        if CheckOnly then
            CurrReport.Break;
        //--BSS.IT_21567.CM

        //++BSS.IT_1330.AK
        SegCriteriaManagement.SetAddCriteriaAction(CompanyOfContact);
        //--BSS.IT_1330.AK

        SegCriteriaManagement.InsertCriteriaAction(
          "Segment Header".GetFilter("No."), REPORT::"Add Contacts",
          AllowExistingContact, ExpandCompanies, AllowCoRepdByContPerson, IgnoreExclusion, false);
        SegCriteriaManagement.InsertCriteriaFilter(
          "Segment Header".GetFilter("No."), DATABASE::Contact,
          Contact.GetFilters, Contact.GetView(false));
        // Start 114096
        //SegCriteriaManagement.InsertCriteriaFilter(
        //  "Segment Header".GETFILTER("No."),DATABASE::"Contact Profile Answer",
        //  "Contact Profile Answer".GETFILTERS,"Contact Profile Answer".GETVIEW(FALSE));
        //SegCriteriaManagement.InsertCriteriaFilter(
        //  "Segment Header".GETFILTER("No."),DATABASE::"Contact Mailing Group",
        //  "Contact Mailing Group".GETFILTERS,"Contact Mailing Group".GETVIEW(FALSE));
        //SegCriteriaManagement.InsertCriteriaFilter(
        //  "Segment Header".GETFILTER("No."),DATABASE::"Interaction Log Entry",
        //  "Interaction Log Entry".GETFILTERS,"Interaction Log Entry".GETVIEW(FALSE));
        //SegCriteriaManagement.InsertCriteriaFilter(
        //  "Segment Header".GETFILTER("No."),DATABASE::"Contact Job Responsibility","Contact Job Responsibility".GETFILTERS,
        //  "Contact Job Responsibility".GETVIEW(FALSE));
        //SegCriteriaManagement.InsertCriteriaFilter(
        //  "Segment Header".GETFILTER("No."),DATABASE::"Contact Industry Group",
        //  "Contact Industry Group".GETFILTERS,"Contact Industry Group".GETVIEW(FALSE));
        //SegCriteriaManagement.InsertCriteriaFilter(
        //  "Segment Header".GETFILTER("No."),DATABASE::"Contact Business Relation",
        //  "Contact Business Relation".GETFILTERS,"Contact Business Relation".GETVIEW(FALSE));
        //SegCriteriaManagement.InsertCriteriaFilter(
        //  "Segment Header".GETFILTER("No."),DATABASE::"Value Entry",
        //  "Value Entry".GETFILTERS,"Value Entry".GETVIEW(FALSE));
        // Stop 114096

        //++BSS.IT_5551.MH
        LicPermission.Get(LicPermission."Object Type"::Table, DATABASE::Vehicle);
        if LicPermission."Execute Permission" = LicPermission."Execute Permission"::Yes then
            //--BSS.IT_5551.MH
            //++BSS.IT_1349.SK
            SegCriteriaManagement.InsertCriteriaFilter(
            "Segment Header".GetFilter("No."), DATABASE::Vehicle,
            Vehicle.GetFilters, Vehicle.GetView(false));
        //++BSS.IT_5551.MH
        LicPermission.Get(LicPermission."Object Type"::Table, DATABASE::"Tire Hotel");
        if LicPermission."Execute Permission" = LicPermission."Execute Permission"::Yes then
            //--BSS.IT_5551.MH
            // Start 114096
            //  SegCriteriaManagement.InsertCriteriaFilter(
            //    "Segment Header".GETFILTER("No."),DATABASE::Depot,
            //    Depot.GETFILTERS,Depot.GETVIEW(FALSE));
            // Stop 114096
            //--BSS.IT_1349.SK

            //Start 111127
            SegCriteriaManagement.InsertCriteriaFilter(
          "Segment Header".GetFilter("No."), DATABASE::"Sales Invoice Header",
          "Sales Invoice Header".GetFilters, "Sales Invoice Header".GetView(false));
        //Stop 111127
        //Start 114096
        SegCriteriaManagement.InsertCriteriaFilter(
          "Segment Header".GetFilter("No."), DATABASE::"Sales Shipment Line",
          "Sales Invoice Line".GetFilters, "Sales Invoice Line".GetView(false));
        //Stop 114096
    end;

    var
        Text000: Label 'Inserting contacts @1@@@@@@@@@@@@@';
        TempCont: Record Contact temporary;
        TempCont2: Record Contact temporary;
        Cont: Record Contact;
        SegLine: Record "Segment Line";
        SegmentHistoryMgt: Codeunit SegHistoryManagement;
        SegCriteriaManagement: Codeunit SegCriteriaManagement;
        NextLineNo: Integer;
        ItemFilters: Boolean;
        ContactOK: Boolean;
        AllowExistingContact: Boolean;
        ExpandCompanies: Boolean;
        AllowCoRepdByContPerson: Boolean;
        IgnoreExclusion: Boolean;
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
        VehicleG: Record Vehicle;
        VehicleTempG: Record Vehicle temporary;
        CheckOnly: Boolean;

    [Scope('OnPrem')]
    procedure SetOptions(OptionAllowExistingContact: Boolean; OptionExpandCompanies: Boolean; OptionAllowCoRepdByContPerson: Boolean; OptionIgnoreExclusion: Boolean)
    begin
        AllowExistingContact := OptionAllowExistingContact;
        ExpandCompanies := OptionExpandCompanies;
        AllowCoRepdByContPerson := OptionAllowCoRepdByContPerson;
        IgnoreExclusion := OptionIgnoreExclusion;
    end;

    local procedure InsertContact(var CheckedCont: Record Contact)
    begin
        TempCont := CheckedCont;
        if TempCont.Insert then;
    end;

    local procedure AddPeople()
    begin
        TempCont.Reset;
        if TempCont.Find('-') then
            repeat
                if TempCont."Company No." <> '' then begin
                    Cont.SetCurrentKey("Company No.");
                    Cont.SetRange("Company No.", TempCont."Company No.");
                    if Cont.Find('-') then
                        repeat
                            TempCont2 := Cont;
                            if TempCont2.Insert then;
                        until Cont.Next = 0
                end else begin
                    TempCont2 := TempCont;
                    TempCont2.Insert;
                end;
            until TempCont.Next = 0;

        TempCont.DeleteAll;
        if TempCont2.Find('-') then
            repeat
                TempCont := TempCont2;
                TempCont.Insert;
            until TempCont2.Next = 0;
        TempCont2.DeleteAll;
    end;

    local procedure DeleteCompanies()
    begin
        TempCont.Reset;
        TempCont.SetCurrentKey("Company No.");
        TempCont.SetRange(Type, TempCont.Type::Company);
        if TempCont.Find('-') then
            repeat
                TempCont.SetRange("Company No.", TempCont."Company No.");
                TempCont.SetRange(Type, TempCont.Type::Person);
                if TempCont.Count > 0 then
                    TempCont.Delete;
                TempCont.SetRange("Company No.");
                TempCont.SetRange(Type, TempCont.Type::Company);
            until TempCont.Next = 0;
    end;

    local procedure UpdateSegLines()
    begin
        SegLine.SetRange("Segment No.", "Segment Header"."No.");
        if SegLine.FindLast then
            NextLineNo := SegLine."Line No." + 10000
        else
            NextLineNo := 10000;

        //-
        //++BSS.IT_20002.1CF
        //VehicleG.MARKEDONLY;
        VehicleG.MarkedOnly(true);
        //--BSS.IT_20002.1CF
        if VehicleG.Count <> 0 then
            SegLine.SetVehicle(VehicleG);
        //--BSS.IT_6637.SS


        TempCont.Reset;
        TempCont.SetCurrentKey("Company Name", "Company No.", Type, Name);
        if not IgnoreExclusion then
            TempCont.SetRange("Exclude from Segment", false);
        if TempCont.Find('-') then
            repeat
                ContactOK := true;
                if not AllowExistingContact then begin
                    SegLine.SetCurrentKey("Contact No.", "Segment No.");
                    SegLine.SetRange("Contact No.", TempCont."No.");
                    SegLine.SetRange("Segment No.", "Segment Header"."No.");
                    if SegLine.FindFirst then
                        ContactOK := false;
                end;

                if ContactOK then begin
                    SegLine.Init;
                    SegLine."Line No." := NextLineNo;
                    SegLine.Validate("Segment No.", "Segment Header"."No.");
                    SegLine.Validate("Contact No.", TempCont."No.");
                    //++BSS.IT_20478.SS
                    if (Vehicle.GetFilters <> '') then begin
                        VehicleTempG.Reset;
                        VehicleTempG.SetFilter("Contact No.", '%1', TempCont."No.");
                        if VehicleTempG.FindFirst then
                            SegLine."Licence-Plate No." := VehicleTempG."Licence-Plate No.";
                    end;
                    //--BSS.IT_20478.SS
                    SegLine.Insert(true);
                    SegmentHistoryMgt.InsertLine(
                      SegLine."Segment No.", SegLine."Contact No.", SegLine."Line No.");

                    //++BSS.IT_6529.SS
                    SegLine.SetRange("Segment No.", "Segment Header"."No.");
                    SegLine.FindLast;
                    //--BSS.IT_6529.SS
                    NextLineNo := SegLine."Line No." + 10000;
                end;
            until TempCont.Next = 0;

        //++BSS.IT_6637.SS
        VehicleG.Reset;
        SegLine.SetVehicle(VehicleG);
        //--BSS.IT_6637.SS
    end;

    local procedure FindContInPostDocuments(ContactNo: Code[20]; ValueEntry: Record "Value Entry"): Boolean
    var
        SalesShptHeader: Record "Sales Shipment Header";
        SalesInvHeader: Record "Sales Invoice Header";
        ReturnRcptHeader: Record "Return Receipt Header";
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
        PurchRcptHeader: Record "Purch. Rcpt. Header";
        PurchInvHeader: Record "Purch. Inv. Header";
        ReturnShptHeader: Record "Return Shipment Header";
        PurchCrMemoHeader: Record "Purch. Cr. Memo Hdr.";
    begin
        with ValueEntry do
            case "Source Type" of
                "Source Type"::Customer:
                    begin
                        if SalesInvHeader.ReadPermission then
                            if SalesInvHeader.Get("Document No.") then
                                if (SalesInvHeader."Sell-to Contact No." = ContactNo) or
                                   (SalesInvHeader."Bill-to Contact No." = ContactNo)
                                then
                                    exit(true);
                        if SalesShptHeader.ReadPermission then
                            if SalesShptHeader.Get("Document No.") then
                                if (SalesShptHeader."Sell-to Contact No." = ContactNo) or
                                   (SalesShptHeader."Bill-to Contact No." = ContactNo)
                                then
                                    exit(true);
                        if SalesCrMemoHeader.ReadPermission then
                            if SalesCrMemoHeader.Get("Document No.") then
                                if (SalesCrMemoHeader."Sell-to Contact No." = ContactNo) or
                                   (SalesCrMemoHeader."Bill-to Contact No." = ContactNo)
                                then
                                    exit(true);
                        if ReturnRcptHeader.ReadPermission then
                            if ReturnRcptHeader.Get("Document No.") then
                                if (ReturnRcptHeader."Sell-to Contact No." = ContactNo) or
                                   (ReturnRcptHeader."Bill-to Contact No." = ContactNo)
                                then
                                    exit(true);
                    end;
                "Source Type"::Vendor:
                    begin
                        if PurchInvHeader.ReadPermission then
                            if PurchInvHeader.Get("Document No.") then
                                if (PurchInvHeader."Buy-from Contact No." = ContactNo) or
                                   (PurchInvHeader."Pay-to Contact No." = ContactNo)
                                then
                                    exit(true);
                        if ReturnShptHeader.ReadPermission then
                            if ReturnShptHeader.Get("Document No.") then
                                if (ReturnShptHeader."Buy-from Contact No." = ContactNo) or
                                   (ReturnShptHeader."Pay-to Contact No." = ContactNo)
                                then
                                    exit(true);
                        if PurchCrMemoHeader.ReadPermission then
                            if PurchCrMemoHeader.Get("Document No.") then
                                if (PurchCrMemoHeader."Buy-from Contact No." = ContactNo) or
                                   (PurchCrMemoHeader."Pay-to Contact No." = ContactNo)
                                then
                                    exit(true);
                        if PurchRcptHeader.ReadPermission then
                            if PurchRcptHeader.Get("Document No.") then
                                if (PurchRcptHeader."Buy-from Contact No." = ContactNo) or
                                   (PurchRcptHeader."Pay-to Contact No." = ContactNo)
                                then
                                    exit(true);
                    end;
            end;
    end;

    [Scope('OnPrem')]
    procedure _BSS_()
    begin
    end;

    [Scope('OnPrem')]
    procedure AddCompany()
    begin
        TempCont.Reset;
        TempCont.SetCurrentKey("Company No.");
        TempCont.SetRange(Type, TempCont.Type::Person);
        if TempCont.Find('-') then
            repeat
                TempCont.SetRange("Company No.", TempCont."Company No.");
                TempCont.SetRange(Type, TempCont.Type::Company);
                if TempCont.Count = 0 then
                    if Cont.Get(TempCont."Company No.") then
                        InsertContact(Cont);

                TempCont.SetRange("Company No.");
                TempCont.SetRange(Type, TempCont.Type::Person);

            until TempCont.Next = 0;
    end;

    [Scope('OnPrem')]
    procedure DeletePeople()
    begin
        TempCont.Reset;
        TempCont.SetCurrentKey("Company No.");
        TempCont.SetRange(Type, TempCont.Type::Company);
        if TempCont.Find('-') then
            repeat
                TempCont.SetRange("Company No.", TempCont."Company No.");
                TempCont.SetRange(Type, TempCont.Type::Person);
                if TempCont.Count > 0 then
                    TempCont.DeleteAll;

                TempCont.SetRange("Company No.");
                TempCont.SetRange(Type, TempCont.Type::Company);
            until TempCont.Next = 0;
    end;

    [Scope('OnPrem')]
    procedure SetAddOptions(OptionCompanyOfContact: Boolean)
    begin
        CompanyOfContact := OptionCompanyOfContact;
    end;

    [Scope('OnPrem')]
    procedure SetCheckOnly(ToSetP: Boolean)
    begin
        //++BSS.IT_21567.CM
        CheckOnly := ToSetP;
        //--BSS.IT_21567.C
    end;

    [Scope('OnPrem')]
    procedure GetContactsFound(var TempContactP: Record Contact)
    begin
        //++BSS.IT_21567.CM
        TempCont.Reset;
        if TempCont.FindSet then
            repeat
                TempContactP.Init;
                TempContactP.TransferFields(TempCont);
                TempContactP.Insert;
            until TempCont.Next = 0;
        //--BSS.IT_21567.CM
    end;
}

