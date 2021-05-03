report 1044865 "Data Export - Sales History"
{
    // +--------------------------------------------------------------+
    // | @ 2013 Tectura Taiwan Limited                                |
    // +--------------------------------------------------------------+
    // | PURPOSE: MARS_TWN                                            |
    // |                                                              |
    // | REMARK :                                                     |
    // +--------------------------------------------------------------+
    // 
    // VERSION   ID             WHO    DATE        DESCRIPTION
    // TWN.01.06 201405-01      LL     2014-05-16  INITIAL RELEASE
    // TWN.01.12 RGS_TWN-453    LL     2014-07-15  Add a Contact Card's field "Correspondence Type" to Sales History Data Exporting
    //                                             Function, and this field value will display at the last column
    // +--------------------------------------------------------------+
    // | @ 2017 incadea Taiwan Limited                                |
    // +--------------------------------------------------------------+
    // | PURPOSE: MARS_TWN                                            |
    // |                                                              |
    // | REMARK :                                                     |
    // +--------------------------------------------------------------+
    // 
    // VERSION     ID          WHO    DATE        DESCRIPTION
    // TWN.01.01   RGS_TWN-401 AH     2017-05-17  INITIAL RELEASE

    ProcessingOnly = true;

    dataset
    {
        dataitem("Sales Invoice Header"; "Sales Invoice Header")
        {
            DataItemTableView = SORTING("No.");
            RequestFilterFields = "Posting Date";

            trigger OnAfterGetRecord()
            begin
                intCount += 1;
                window.UPDATE(1, intCount);

                // check the bill-to contact, sell-to contact filter
                bolOK := TRUE;
                IF "Bill-to Contact No." <> '' THEN BEGIN
                    CLEAR(recContact);
                    recContact.SETRANGE("No.", "Bill-to Contact No.");
                    recContact.SETFILTER("Personal Data Status", filBillToPDS);
                    recContact.SETFILTER("Personal Data Agreement Date", filBillToPDAD);
                    IF NOT recContact.FIND('-') THEN bolOK := FALSE;
                END;

                IF "Sell-to Contact No." <> '' THEN BEGIN
                    CLEAR(recContact);
                    recContact.SETRANGE("No.", "Sell-to Contact No.");
                    recContact.SETFILTER("Personal Data Status", filSellToPDS);
                    recContact.SETFILTER("Personal Data Agreement Date", filSellToPDAD);
                    IF NOT recContact.FIND('-') THEN bolOK := FALSE;
                END;
                // end of check

                IF bolOK THEN BEGIN
                    intExcelRowNo += 1;
                    EnterCell(intExcelRowNo, 1, FORMAT("Sales Invoice Header"."No."), FALSE);
                    EnterCell(intExcelRowNo, 2, FORMAT("Sales Invoice Header"."Posting Date"), FALSE);
                    EnterCell(intExcelRowNo, 3, FORMAT("Sales Invoice Header"."Vehicle No."), FALSE);
                    EnterCell(intExcelRowNo, 4, FORMAT("Sales Invoice Header"."Licence-Plate No."), FALSE);

                    EnterCell(intExcelRowNo, 5, FORMAT("Sales Invoice Header"."Bill-to Contact No."), FALSE);

                    CLEAR(recBillContact);
                    IF recBillContact.GET("Bill-to Contact No.") THEN;
                    EnterCell(intExcelRowNo, 6, FORMAT(recBillContact.Name), FALSE);
                    EnterCell(intExcelRowNo, 7, FORMAT(recBillContact."Name 2"), FALSE);

                    EnterCell(intExcelRowNo, 8, FORMAT("Sales Invoice Header"."Sell-to Contact No."), FALSE);

                    CLEAR(recSellContact);
                    IF recSellContact.GET("Sell-to Contact No.") THEN;
                    EnterCell(intExcelRowNo, 9, FORMAT(recSellContact.Name), FALSE);
                    EnterCell(intExcelRowNo, 10, FORMAT(recSellContact."Name 2"), FALSE);
                    EnterCell(intExcelRowNo, 11, FORMAT("Sales Invoice Header"."Responsibility Center"), FALSE);
                    EnterCell(intExcelRowNo, 12, FORMAT('''' + recBillContact."Phone No."), FALSE);
                    EnterCell(intExcelRowNo, 13, FORMAT('''' + recBillContact."Phone No. 2"), FALSE);
                    EnterCell(intExcelRowNo, 14, FORMAT('''' + recBillContact."Mobile Phone No."), FALSE);
                    EnterCell(intExcelRowNo, 15, FORMAT('''' + recBillContact."Mobile Phone No. 2"), FALSE);

                    EnterCell(intExcelRowNo, 16, FORMAT('''' + recBillContact."Fax No."), FALSE);
                    EnterCell(intExcelRowNo, 17, FORMAT('''' + recBillContact."Fax No. 2"), FALSE);
                    EnterCell(intExcelRowNo, 18, FORMAT(recBillContact."Personal Data Status"), FALSE);
                    EnterCell(intExcelRowNo, 19, FORMAT(recBillContact."Personal Data Agreement Date"), FALSE);

                    EnterCell(intExcelRowNo, 20, FORMAT('''' + recSellContact."Phone No."), FALSE);
                    EnterCell(intExcelRowNo, 21, FORMAT('''' + recSellContact."Phone No. 2"), FALSE);
                    EnterCell(intExcelRowNo, 22, FORMAT('''' + recSellContact."Mobile Phone No."), FALSE);
                    EnterCell(intExcelRowNo, 23, FORMAT('''' + recSellContact."Mobile Phone No. 2"), FALSE);
                    EnterCell(intExcelRowNo, 24, FORMAT('''' + recSellContact."Fax No."), FALSE);
                    EnterCell(intExcelRowNo, 25, FORMAT('''' + recSellContact."Fax No. 2"), FALSE);
                    EnterCell(intExcelRowNo, 26, FORMAT(recSellContact."Personal Data Status"), FALSE);
                    EnterCell(intExcelRowNo, 27, FORMAT(recSellContact."Personal Data Agreement Date"), FALSE);
                    EnterCell(intExcelRowNo, 28, FORMAT(recSellContact."Correspondence Type"), FALSE);
                END;
            end;

            trigger OnPostDataItem()
            begin
                TmpExcelBuffer.OnlyCreateBook('Data Port', '', COMPANYNAME, USERID, FALSE);
                TmpExcelBuffer.OnlyOpenExcel;
                TmpExcelBuffer.GiveUserControl;
                window.CLOSE;
            end;

            trigger OnPreDataItem()
            begin
                window.OPEN('處理資料  #1########## /  #2##########');
                window.UPDATE(1, 0);
                window.UPDATE(2, COUNT);
                intCount := 0;
                intExcelRowNo := 6;

                TmpExcelBuffer.DELETEALL;
                CLEAR(TmpExcelBuffer);

                EnterCell(1, 5, 'Sales History', TRUE);

                EnterCell(2, 1, '公司名稱:', TRUE);
                EnterCell(2, 2, COMPANYNAME, TRUE);
                EnterCell(3, 1, '列印日期:', TRUE);
                EnterCell(3, 2, FORMAT(TODAY), TRUE);
                EnterCell(4, 1, '過慮條件:', TRUE);
                EnterCell(4, 2, "Sales Invoice Header".GETFILTER("Posting Date"), TRUE);

                EnterCell(6, 1, InvoiceNo, TRUE);
                EnterCell(6, 2, "Sales Invoice Header".FIELDCAPTION("Posting Date"), TRUE);
                EnterCell(6, 3, "Sales Invoice Header".FIELDCAPTION("Vehicle No."), TRUE);
                EnterCell(6, 4, "Sales Invoice Header".FIELDCAPTION("Licence-Plate No."), TRUE);

                EnterCell(6, 5, "Sales Invoice Header".FIELDCAPTION("Bill-to Contact No."), TRUE);

                EnterCell(6, 6, "Bill-Name", TRUE);
                EnterCell(6, 7, "Bill-Name2", TRUE);

                EnterCell(6, 8, "Sales Invoice Header".FIELDCAPTION("Sell-to Contact No."), TRUE);

                EnterCell(6, 9, "Sell-Name", TRUE);
                EnterCell(6, 10, "Sell-Name2", TRUE);
                EnterCell(6, 11, "Sales Invoice Header".FIELDCAPTION("Responsibility Center"), TRUE);
                EnterCell(6, 12, "Bill-PhoneNo", TRUE);
                EnterCell(6, 13, "Bill-PhoneNo2", TRUE);
                EnterCell(6, 14, "Bill-MobilePhoneNo", TRUE);
                EnterCell(6, 15, "Bill-MobilePhoneNo2", TRUE);

                EnterCell(6, 16, "Bill-FaxNo", TRUE);
                EnterCell(6, 17, "Bill-FaxNo2", TRUE);
                EnterCell(6, 18, "Bill-PDS", TRUE);
                EnterCell(6, 19, "Bill-PDAD", TRUE);

                EnterCell(6, 20, "Sell-PhoneNo", TRUE);
                EnterCell(6, 21, "Sell-PhoneNo2", TRUE);
                EnterCell(6, 22, "Sell-MobilePhoneNo", TRUE);
                EnterCell(6, 23, "Sell-MobilePhoneNo2", TRUE);
                EnterCell(6, 24, "Sell-FaxNo", TRUE);
                EnterCell(6, 25, "Sell-FaxNo2", TRUE);
                EnterCell(6, 26, "Sell-PDS", TRUE);
                EnterCell(6, 27, "Sell-PDAD", TRUE);
                EnterCell(6, 28, recSellContact.FIELDCAPTION("Correspondence Type"), TRUE);
            end;
        }
        dataitem("Bill-to Contact"; Contact)
        {
            DataItemTableView = SORTING("No.")
                                WHERE("No." = CONST(''));
            RequestFilterFields = "Personal Data Status", "Personal Data Agreement Date";
            RequestFilterHeading = 'Bill-to Contact';
        }
        dataitem("Sell-to Contact"; Contact)
        {
            DataItemTableView = SORTING("No.")
                                WHERE("No." = CONST(''));
            RequestFilterFields = "Personal Data Status", "Personal Data Agreement Date";
            RequestFilterHeading = 'Sell-to Contact';
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

    trigger OnPreReport()
    begin
        IF "Sales Invoice Header".GETFILTER("Posting Date") = '' THEN
            ERROR('Please set the Filter: %1', "Sales Invoice Header".FIELDCAPTION("Posting Date"));

        filBillToPDS := "Bill-to Contact".GETFILTER("Personal Data Status");
        filBillToPDAD := "Bill-to Contact".GETFILTER("Personal Data Agreement Date");

        filSellToPDS := "Sell-to Contact".GETFILTER("Personal Data Status");
        filSellToPDAD := "Sell-to Contact".GETFILTER("Personal Data Agreement Date");
    end;

    var
        TmpExcelBuffer: Record "Excel Buffer" temporary;
        recBillContact: Record Contact;
        recSellContact: Record Contact;
        intExcelRowNo: Integer;
        window: Dialog;
        intCount: Integer;
        filBillToPDS: Text[100];
        filBillToPDAD: Text[100];
        filSellToPDS: Text[100];
        filSellToPDAD: Text[100];
        recContact: Record Contact;
        bolOK: Boolean;
        InvoiceNo: Label 'Invoice No.';
        "Bill-Name": Label 'Bill-to Name';
        "Bill-Name2": Label 'Bill-to Name 2';
        "Bill-PhoneNo": Label 'Bill-to Phone No.';
        "Bill-PhoneNo2": Label 'Bill-to Phone No. 2';
        "Bill-MobilePhoneNo": Label 'Bill-to Mobile Phone No.';
        "Bill-MobilePhoneNo2": Label 'Bill-to Mobile Phone No. 2';
        "Bill-FaxNo": Label 'Bill-to Fax No.';
        "Bill-FaxNo2": Label 'Bill-to Fax No. 2';
        "Bill-PDS": Label 'Bill-to Personal Data Status';
        "Bill-PDAD": Label 'Bill-to Personal Data Agreement Date';
        "Sell-Name": Label 'Sell-to Name';
        "Sell-Name2": Label 'Sell-to Name 2';
        "Sell-PhoneNo": Label 'Sell-to Phone No.';
        "Sell-PhoneNo2": Label 'Sell-to Phone No. 2';
        "Sell-MobilePhoneNo": Label 'Sell-to Mobile Phone No.';
        "Sell-MobilePhoneNo2": Label 'Sell-to Mobile Phone No. 2';
        "Sell-FaxNo": Label 'Sell-to Fax No.';
        "Sell-FaxNo2": Label 'Sell-to Fax No. 2';
        "Sell-PDS": Label 'Sell-to Personal Data Status';
        "Sell-PDAD": Label 'Sell-to Personal Data Agreement Date';

    [Scope('OnPrem')]
    procedure EnterCell(p_RowNo: Integer; p_ColumnNo: Integer; p_CellValue: Text[250]; p_Bold: Boolean)
    begin
        TmpExcelBuffer.INIT;
        TmpExcelBuffer.VALIDATE("Row No.", p_RowNo);
        TmpExcelBuffer.VALIDATE("Column No.", p_ColumnNo);
        TmpExcelBuffer.VALIDATE("Cell Value as Text", p_CellValue);
        TmpExcelBuffer.VALIDATE(Bold, p_Bold);
        TmpExcelBuffer.INSERT;
    end;
}

