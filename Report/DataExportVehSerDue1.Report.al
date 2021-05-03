report 1044866 "Data Export - Veh. Ser. Due 1"
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
    // TWN.01.06 201405-01      LL     2014-05-15  INITIAL RELEASE
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
        dataitem("Service Due Entry"; "Service Due Entry")
        {
            DataItemTableView = SORTING("Vehicle No.", "SMS Entry No.", "Next Service Due Date", "Service Code", "No.", "Tire Position")
                                WHERE("Tire Item" = CONST(true));
            RequestFilterFields = "Next Service Due Date";

            trigger OnAfterGetRecord()
            begin
                intCount += 1;
                window.UPDATE(1, intCount);

                CLEAR(recItem);
                IF recItem.GET("No.") THEN BEGIN
                    IF recItem."Manufacturer Code" <> 'MI' THEN BEGIN
                        CLEAR(tmpServiceDueEntry);
                        tmpServiceDueEntry.SETCURRENTKEY("Vehicle No.");
                        tmpServiceDueEntry.SETRANGE("Vehicle No.", "Vehicle No.");
                        tmpServiceDueEntry.SETFILTER("Posting Date", '<%1', "Posting Date");
                        IF tmpServiceDueEntry.FIND('-') THEN BEGIN
                            tmpServiceDueEntry.DELETEALL;
                            COMMIT;

                            CLEAR(tmpServiceDueEntry);
                            tmpServiceDueEntry.RESET;
                            tmpServiceDueEntry.INIT;
                            tmpServiceDueEntry.TRANSFERFIELDS("Service Due Entry");
                            tmpServiceDueEntry.INSERT;
                        END
                        ELSE BEGIN
                            tmpServiceDueEntry.RESET;
                            tmpServiceDueEntry.INIT;
                            tmpServiceDueEntry.TRANSFERFIELDS("Service Due Entry");
                            tmpServiceDueEntry.INSERT;
                        END;
                    END;
                END;
            end;

            trigger OnPostDataItem()
            begin
                window.CLOSE;
            end;

            trigger OnPreDataItem()
            begin
                window.OPEN('處理資料(Step 1/2)  #1########## /  #2##########');
                window.UPDATE(1, 0);
                window.UPDATE(2, COUNT);
                intCount := 0;
            end;
        }
        dataitem(Integer; Integer)
        {
            DataItemTableView = SORTING(Number);

            trigger OnAfterGetRecord()
            var
                DocNoL: Code[20];
                DocLineNoL: Integer;
            begin
                intCount += 1;
                window.UPDATE(1, intCount);

                intExcelRowNo += 1;
                tmpServiceDueEntry.NEXT;

                EnterCell(intExcelRowNo, 1, FORMAT(tmpServiceDueEntry."Next Service Due Date"), FALSE);
                EnterCell(intExcelRowNo, 2, FORMAT(tmpServiceDueEntry."Posting Date"), FALSE);
                EnterCell(intExcelRowNo, 3, FORMAT(tmpServiceDueEntry."No."), FALSE);
                EnterCell(intExcelRowNo, 4, FORMAT(tmpServiceDueEntry."Tire Position"), FALSE);
                EnterCell(intExcelRowNo, 5, FORMAT(tmpServiceDueEntry."Vehicle No."), FALSE);
                EnterCell(intExcelRowNo, 6, FORMAT(tmpServiceDueEntry."Bill-to Contact No."), FALSE);
                CLEAR(recContact);
                IF recContact.GET(tmpServiceDueEntry."Bill-to Contact No.") THEN;
                EnterCell(intExcelRowNo, 7, FORMAT(recContact.Name), FALSE);

                CLEAR(recVehicle);
                IF recVehicle.GET(tmpServiceDueEntry."Vehicle No.") THEN;
                EnterCell(intExcelRowNo, 8, FORMAT('''' + recVehicle."Licence-Plate No."), FALSE);

                EnterCell(intExcelRowNo, 9, FORMAT('''' + recContact."Phone No."), FALSE);
                EnterCell(intExcelRowNo, 10, FORMAT('''' + recContact."Phone No. 2"), FALSE);
                EnterCell(intExcelRowNo, 11, FORMAT('''' + recContact."Mobile Phone No."), FALSE);
                EnterCell(intExcelRowNo, 12, FORMAT('''' + recContact."Mobile Phone No. 2"), FALSE);
                EnterCell(intExcelRowNo, 13, FORMAT(recContact.Address), FALSE);
                EnterCell(intExcelRowNo, 14, FORMAT(recContact."Address 2"), FALSE);
                EnterCell(intExcelRowNo, 15, FORMAT(recContact."Personal Data Status"), FALSE);
                EnterCell(intExcelRowNo, 16, FORMAT(recContact."Personal Data Agreement Date"), FALSE);
                EnterCell(intExcelRowNo, 17, FORMAT(recVehicle."Vehicle Manufacturer"), FALSE);
                EnterCell(intExcelRowNo, 18, FORMAT(recVehicle."Vehicle Model"), FALSE);
                EnterCell(intExcelRowNo, 19, FORMAT(recVehicle."Vehicle Variant"), FALSE);

                CLEAR(recItem);
                IF recItem.GET(tmpServiceDueEntry."No.") THEN;
                EnterCell(intExcelRowNo, 20, FORMAT(recItem."Position Group Code"), FALSE);

                CLEAR(recPositionGroup);
                IF recPositionGroup.GET(recItem."Position Group Code") THEN;
                EnterCell(intExcelRowNo, 21, FORMAT(recPositionGroup.Description), FALSE);

                EnterCell(intExcelRowNo, 22, FORMAT(recItem."Manufacturer Code"), FALSE);
                recItem.CALCFIELDS("Manufacturer Name", "Manufacturer Token");
                EnterCell(intExcelRowNo, 23, FORMAT(recItem."Manufacturer Name"), FALSE);
                EnterCell(intExcelRowNo, 24, FORMAT(recItem."Manufacturer Token"), FALSE);
                /*
                CLEAR(DocNoL); CLEAR(DocLineNoL);
                IF GetVehicleCheckInfo(DocNoL, DocLineNoL) THEN
                BEGIN
                  EnterCell(intExcelRowNo, 25, FORMAT(DocNoL), FALSE);
                  EnterCell(intExcelRowNo, 26, FORMAT(DocLineNoL), FALSE);
                END;
                */

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
                CLEAR(tmpServiceDueEntry);
                SETRANGE(Number, 1, tmpServiceDueEntry.COUNT);
                intExcelRowNo := 6;

                TmpExcelBuffer.DELETEALL;
                CLEAR(TmpExcelBuffer);

                EnterCell(1, 5, 'Vehicle Service Due', TRUE);

                EnterCell(2, 1, '公司名稱:', TRUE);
                EnterCell(2, 2, COMPANYNAME, TRUE);
                EnterCell(3, 1, '列印日期:', TRUE);
                EnterCell(3, 2, FORMAT(TODAY), TRUE);
                EnterCell(4, 1, '過慮條件:', TRUE);
                EnterCell(4, 2, "Service Due Entry".GETFILTER("Next Service Due Date"), TRUE);

                EnterCell(6, 1, "Service Due Entry".FIELDCAPTION("Next Service Due Date"), TRUE);
                EnterCell(6, 2, "Service Due Entry".FIELDCAPTION("Posting Date"), TRUE);
                EnterCell(6, 3, "Service Due Entry".FIELDCAPTION("No."), TRUE);
                EnterCell(6, 4, "Service Due Entry".FIELDCAPTION("Tire Position"), TRUE);
                EnterCell(6, 5, "Service Due Entry".FIELDCAPTION("Vehicle No."), TRUE);
                EnterCell(6, 6, "Service Due Entry".FIELDCAPTION("Bill-to Contact No."), TRUE);
                EnterCell(6, 7, recContact.FIELDCAPTION(Name), TRUE);
                EnterCell(6, 8, recVehicle.FIELDCAPTION("Licence-Plate No."), TRUE);
                EnterCell(6, 9, recContact.FIELDCAPTION("Phone No."), TRUE);
                EnterCell(6, 10, recContact.FIELDCAPTION("Phone No. 2"), TRUE);
                EnterCell(6, 11, recContact.FIELDCAPTION("Mobile Phone No."), TRUE);
                EnterCell(6, 12, recContact.FIELDCAPTION("Mobile Phone No. 2"), TRUE);
                EnterCell(6, 13, recContact.FIELDCAPTION(Address), TRUE);
                EnterCell(6, 14, recContact.FIELDCAPTION("Address 2"), TRUE);
                EnterCell(6, 15, recContact.FIELDCAPTION("Personal Data Status"), TRUE);

                EnterCell(6, 16, recContact.FIELDCAPTION("Personal Data Agreement Date"), TRUE);
                EnterCell(6, 17, recVehicle.FIELDCAPTION("Vehicle Manufacturer"), TRUE);
                EnterCell(6, 18, recVehicle.FIELDCAPTION("Vehicle Model"), TRUE);
                EnterCell(6, 19, recVehicle.FIELDCAPTION("Vehicle Variant"), TRUE);
                EnterCell(6, 20, recItem.FIELDCAPTION("Position Group Code"), TRUE);
                EnterCell(6, 21, recPositionGroup.FIELDCAPTION(Description), TRUE);
                EnterCell(6, 22, recItem.FIELDCAPTION("Manufacturer Code"), TRUE);
                EnterCell(6, 23, recItem.FIELDCAPTION("Manufacturer Name"), TRUE);
                EnterCell(6, 24, recItem.FIELDCAPTION("Manufacturer Token"), TRUE);
                /*
                EnterCell(6, 25, recVehicleCheckInfoHeader.FIELDCAPTION("Posted Document No."), TRUE);
                EnterCell(6, 26, recVehicleCheckInfoLine.FIELDCAPTION("Line No."), TRUE);
                */
                window.OPEN('處理資料(Step 2/2)  #1########## /  #2##########');
                window.UPDATE(1, 0);
                window.UPDATE(2, COUNT);
                intCount := 0;

            end;
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
        IF "Service Due Entry".GETFILTER("Next Service Due Date") = '' THEN
            ERROR('Please set the Filter: %1', "Service Due Entry".FIELDCAPTION("Next Service Due Date"));
    end;

    var
        recItem: Record Item;
        tmpServiceDueEntry: Record "Service Due Entry" temporary;
        TmpExcelBuffer: Record "Excel Buffer" temporary;
        recContact: Record Contact;
        recVehicle: Record Vehicle;
        recPositionGroup: Record "Position Group";
        //++TWN1.00.122187.QX
        // "Vehicle Check Info Header" and "Vehicle Check Info Line" were removed
        // recVehicleCheckInfoHeader: Record "Vehicle Check Info Header";
        // recVehicleCheckInfoLine: Record "Vehicle Check Info Line";
        //--TWN1.00.122187.QX

        intExcelRowNo: Integer;
        window: Dialog;
        intCount: Integer;

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

    [Scope('OnPrem')]
    procedure GetVehicleCheckInfo(var DocNoP: Code[20]; var DocLineNoP: Integer) bolResult: Boolean
    begin
        bolResult := FALSE;
        //++TWN1.00.122187.QX
        // "Vehicle Check Info Header" and "Vehicle Check Info Line" were removed

        // CLEAR(recVehicleCheckInfoHeader);
        // recVehicleCheckInfoHeader.SETCURRENTKEY("Date Created");
        // recVehicleCheckInfoHeader.SETRANGE("Date Created",
        //                                     CREATEDATETIME(tmpServiceDueEntry."Posting Date", 0T),
        //                                     CREATEDATETIME(tmpServiceDueEntry."Posting Date", 235959.999T));
        // recVehicleCheckInfoHeader.SETRANGE("Vehicle No.", tmpServiceDueEntry."Vehicle No.");
        // IF recVehicleCheckInfoHeader.FIND('-') THEN BEGIN
        //     REPEAT
        //         CLEAR(recVehicleCheckInfoLine);
        //         recVehicleCheckInfoLine.SETRANGE("Document Type", recVehicleCheckInfoHeader."Document Type");
        //         recVehicleCheckInfoLine.SETRANGE("Document No.", recVehicleCheckInfoHeader."Document No.");
        //         recVehicleCheckInfoLine.SETRANGE("Line Type", recVehicleCheckInfoLine."Line Type"::Item);
        //         recVehicleCheckInfoLine.SETRANGE("No.", tmpServiceDueEntry."No.");
        //         recVehicleCheckInfoLine.SETRANGE("Tire Position", tmpServiceDueEntry."Tire Position");
        //         IF recVehicleCheckInfoLine.FIND('-') THEN BEGIN
        //             bolResult := TRUE;
        //             IF recVehicleCheckInfoHeader."Document No." > DocNoP THEN BEGIN
        //                 DocNoP := recVehicleCheckInfoHeader."Document No.";
        //                 DocLineNoP := recVehicleCheckInfoLine.Type;
        //             END;
        //         END;
        //     UNTIL recVehicleCheckInfoHeader.NEXT = 0;
        // END;

        //--TWN1.00.122187.QX
    end;
}

