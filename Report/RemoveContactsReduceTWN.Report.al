report 1044867 "Remove Contacts - Reduce (TWN)"
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
    // 050109   IT_5551 MH     2010-03-05  licence permission check for vehicle and depot
    // 060000   IT_6272 AK     2011-05-02  merged to NAV 2009R2
    // 
    // 070002 IT_20001 1CF 2013-07-01 Upgraded to NAV 7
    // 
    // +----------------------------------------------+
    // | Copyright (c) incadea China                  |
    // +----------------------------------------------+
    // TFS          ID             WHO   DATE        DESCRIPTION
    // 111127                      SY    2018-02-09  Add  DataItem Sales Invoice Header
    // 111127                      DY    2018-02-23  Change Default Filter field
    // 112168       MARS_TWN-6450  GG    2018-03-12  Add new filter "Personal Data Status" for dataitem Contact
    // 114096       MARS_TWN_6567  GG    2018-05-09  Remove some dataitems and add new dataitem "Sales Invoice Line"
    // RGS_TWN-888   122187	       QX	 2020-12-21  Copied from report 5197

    Caption = 'Remove Contacts - Reduce';
    ProcessingOnly = true;

    dataset
    {
        dataitem("Segment Header"; "Segment Header")
        {
            DataItemTableView = SORTING("No.");

            trigger OnPreDataItem()
            begin
                CurrReport.BREAK;
            end;
        }
        dataitem(Contact; Contact)
        {
            DataItemTableView = SORTING("No.");
            RequestFilterFields = "Personal Data Status", "Mobile Phone No.", "Date of Last Interaction", "Salesperson Code", "VAT Registration No.", "Date of Birth", "Post Code";

            trigger OnPreDataItem()
            begin
                CurrReport.BREAK;
            end;
        }
        dataitem(Vehicle; Vehicle)
        {

            trigger OnPreDataItem()
            begin
                CurrReport.BREAK;
            end;
        }
        dataitem("Sales Invoice Header"; "Sales Invoice Header")
        {
            DataItemTableView = SORTING("No.");
            RequestFilterFields = "No.", "Posting Date", "Bill-to Contact No.";

            trigger OnPreDataItem()
            begin
                // Start 111127
                CurrReport.BREAK;
                // Stop 111127
            end;
        }
        dataitem("Sales Invoice Line"; "Sales Invoice Line")
        {
            DataItemTableView = SORTING("Document No.", "Line No.")
                                ORDER(Ascending);
            RequestFilterFields = "Main Group Code", Type, "No.";

            trigger OnPreDataItem()
            begin
                // Start 114096
                CurrReport.BREAK;
                // Stop 114096
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group("Option")
                {
                    Caption = 'Options';
                    field(EntireCompanies; EntireCompanies)
                    {
                        Caption = 'Entire Companies';
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

    trigger OnPreReport()
    begin
        CLEAR(ReduceRefineSegment);
        ReduceRefineSegment.SETTABLEVIEW("Segment Header");
        ReduceRefineSegment.SETTABLEVIEW(Contact);
        // Start 114096
        //ReduceRefineSegment.SETTABLEVIEW("Contact Profile Answer");
        //ReduceRefineSegment.SETTABLEVIEW("Contact Mailing Group");
        //ReduceRefineSegment.SETTABLEVIEW("Interaction Log Entry");
        //ReduceRefineSegment.SETTABLEVIEW("Contact Job Responsibility");
        //ReduceRefineSegment.SETTABLEVIEW("Contact Industry Group");
        //ReduceRefineSegment.SETTABLEVIEW("Contact Business Relation");
        //ReduceRefineSegment.SETTABLEVIEW("Value Entry");
        // Stop 114096


        //++BSS.IT_1349.SK
        ReduceRefineSegment.SETTABLEVIEW(Vehicle);
        // Start 114096
        //ReduceRefineSegment.SETTABLEVIEW(Depot);
        // Stop 114096
        //--BSS.IT_1349.SK

        //Start 111127
        ReduceRefineSegment.SETTABLEVIEW("Sales Invoice Header");
        //Stop 111127
        // Start 114096
        ReduceRefineSegment.SETTABLEVIEW("Sales Invoice Line");
        // Stop 114096

        ReduceRefineSegment.SetOptions(REPORT::"Remove Contacts - Reduce", EntireCompanies);

        //++BSS.IT_1330.AK
        ReduceRefineSegment.SetAddOptions(CompanyOfContact);
        //--BSS.IT_1330.AK

        ReduceRefineSegment.RUNMODAL;
    end;

    var
        ReduceRefineSegment: Report "Remove Contacts (TWN)";
        EntireCompanies: Boolean;
        CompanyOfContact: Boolean;
        LicPermission: Record "License Permission";

    [Scope('OnPrem')]
    procedure SetOptions(OptionEntireCompanies: Boolean)
    begin
        EntireCompanies := OptionEntireCompanies;
    end;

    [Scope('OnPrem')]
    procedure SetAddOptions(OptionCompanyOfContact: Boolean)
    begin
        CompanyOfContact := OptionCompanyOfContact;
    end;
}

