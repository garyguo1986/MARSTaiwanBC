report 1044864 "Data Export - Question"
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
    // TWN.01.01   RGS_TWN-401 AH     2017-05-17  INITIAL RELEASE

    ProcessingOnly = true;

    dataset
    {
        dataitem("Sales Invoice Header"; "Sales Invoice Header")
        {
            DataItemTableView = SORTING("Posting Date");
            RequestFilterFields = "Responsibility Center", "Posting Date", "Sell-to Customer No.", "Bill-to Customer No.", "Sell-to Contact No.", "Bill-to Contact No.", "Vehicle No.", "Licence-Plate No.";
            column(Sales_Invoice_Header__No__; "No.")
            {
            }
            column(Sales_Invoice_Header__No__Caption; FIELDCAPTION("No."))
            {
            }
            dataitem("Sales Invoice Line"; "Sales Invoice Line")
            {
                DataItemLink = "Document No." = FIELD("No.");
                DataItemTableView = SORTING("Document No.", "Line No.");

                trigger OnAfterGetRecord()
                begin
                    //++TWN.01.19
                    CLEAR(recContact);
                    booAllowShow := FALSE;
                    //IF recContact.GET("Sales Invoice Header"."Sell-to Contact No.") THEN
                    IF recContact.GET("Sales Invoice Line"."Sell-to Contact No.") THEN BEGIN
                        IF booNone THEN
                            IF recContact."Personal Data Status" = recContact."Personal Data Status"::None THEN booAllowShow := TRUE;
                        IF booYes THEN
                            IF recContact."Personal Data Status" = recContact."Personal Data Status"::Yes THEN booAllowShow := TRUE;
                        IF booNo THEN
                            IF recContact."Personal Data Status" = recContact."Personal Data Status"::No THEN booAllowShow := TRUE;
                        IF booNA THEN
                            IF recContact."Personal Data Status" = recContact."Personal Data Status"::"N/A" THEN booAllowShow := TRUE;
                    END;

                    IF NOT booAllowShow THEN EXIT;

                    tmpSalesInvLine.RESET;
                    tmpSalesInvLine.INIT;
                    tmpSalesInvLine.TRANSFERFIELDS("Sales Invoice Line");
                    tmpSalesInvLine.INSERT;
                    //--TWN.01.19
                end;
            }

            trigger OnAfterGetRecord()
            begin
                //++TWN.01.19
                CLEAR(recContact);
                booAllowShow := FALSE;
                IF recContact.GET("Sell-to Contact No.") THEN BEGIN
                    IF booNone THEN
                        IF recContact."Personal Data Status" = recContact."Personal Data Status"::None THEN booAllowShow := TRUE;
                    IF booYes THEN
                        IF recContact."Personal Data Status" = recContact."Personal Data Status"::Yes THEN booAllowShow := TRUE;
                    IF booNo THEN
                        IF recContact."Personal Data Status" = recContact."Personal Data Status"::No THEN booAllowShow := TRUE;
                    IF booNA THEN
                        IF recContact."Personal Data Status" = recContact."Personal Data Status"::"N/A" THEN booAllowShow := TRUE;
                END;
                IF NOT booAllowShow THEN EXIT;
                //--TWN.01.19

                intCount += 1;
                window.UPDATE(1, intCount);
                intExcelRowNo += 1;
                intExcelColNo := 0;

                intExcelColNo += 1;
                EnterCell(intExcelRowNo, intExcelColNo, FORMAT("No."), FALSE);
                intExcelColNo += 1;
                EnterCell(intExcelRowNo, intExcelColNo, FORMAT("Posting Date"), FALSE);
                intExcelColNo += 1;
                EnterCell(intExcelRowNo, intExcelColNo, FORMAT("Campaign No."), FALSE);
                intExcelColNo += 1;

                CLEAR(recSalesInvLine);
                CLEAR(decTemp);
                recSalesInvLine.SETRANGE("Document No.", "No.");
                IF recSalesInvLine.FIND('-') THEN BEGIN
                    REPEAT
                        decTemp += recSalesInvLine."Line Amount";
                    UNTIL recSalesInvLine.NEXT = 0;
                END;
                EnterCell(intExcelRowNo, intExcelColNo, FORMAT(decTemp), FALSE);
                intExcelColNo += 1;
                EnterCell(intExcelRowNo, intExcelColNo, FORMAT("Vehicle No."), FALSE);
                intExcelColNo += 1;
                EnterCell(intExcelRowNo, intExcelColNo, '''' + FORMAT("Licence-Plate No."), FALSE);
                intExcelColNo += 1;
                EnterCell(intExcelRowNo, intExcelColNo, FORMAT("Sell-to Contact No."), FALSE);
                intExcelColNo += 1;

                CLEAR(recContact);
                IF recContact.GET("Sell-to Contact No.") THEN BEGIN
                    CLEAR(tmpContact);
                    IF NOT tmpContact.GET("Sell-to Contact No.") THEN BEGIN
                        tmpContact.RESET;
                        tmpContact.INIT;
                        tmpContact.TRANSFERFIELDS(recContact);
                        tmpContact.INSERT;
                    END;
                END;

                EnterCell(intExcelRowNo, intExcelColNo, FORMAT(recContact.Name), FALSE);
                intExcelColNo += 1;
                EnterCell(intExcelRowNo, intExcelColNo, FORMAT(recContact."Name 2"), FALSE);
                intExcelColNo += 1;
                EnterCell(intExcelRowNo, intExcelColNo, FORMAT("Responsibility Center"), FALSE);
                intExcelColNo += 1;
                EnterCell(intExcelRowNo, intExcelColNo, '''' + FORMAT(recContact."Phone No."), FALSE);
                intExcelColNo += 1;
                EnterCell(intExcelRowNo, intExcelColNo, '''' + FORMAT(recContact."Mobile Phone No."), FALSE);
                intExcelColNo += 1;
                EnterCell(intExcelRowNo, intExcelColNo, '''' + FORMAT(recContact."Mobile Phone No. 2"), FALSE);
                intExcelColNo += 1;
                EnterCell(intExcelRowNo, intExcelColNo, '''' + FORMAT(recContact."Fax No."), FALSE);
                intExcelColNo += 1;
                EnterCell(intExcelRowNo, intExcelColNo, '''' + FORMAT(recContact."Fax No. 2"), FALSE);
                intExcelColNo += 1;
                EnterCell(intExcelRowNo, intExcelColNo, FORMAT(recContact."Post Code"), FALSE);
                intExcelColNo += 1;
                EnterCell(intExcelRowNo, intExcelColNo, FORMAT(recContact.City), FALSE);
                intExcelColNo += 1;
                EnterCell(intExcelRowNo, intExcelColNo, FORMAT(recContact."Date of Birth"), FALSE);
                intExcelColNo += 1;
                EnterCell(intExcelRowNo, intExcelColNo, FORMAT(recContact."Personal Data Status"), FALSE);
                intExcelColNo += 1;
                EnterCell(intExcelRowNo, intExcelColNo, FORMAT(recContact."Personal Data Agreement Date"), FALSE);
                intExcelColNo += 1;
                EnterCell(intExcelRowNo, intExcelColNo, FORMAT(recContact."Correspondence Type"), FALSE);
                intExcelColNo += 1;
                EnterCell(intExcelRowNo, intExcelColNo, FORMAT(recContact."Creation Date"), FALSE);
                intExcelColNo += 1;
                //++TWN.01.19
                EnterCell(intExcelRowNo, intExcelColNo, "Sales Invoice Header"."Credit Memo No.", FALSE);
                intExcelColNo += 1;
                //--TWN.01.19
            end;

            trigger OnPostDataItem()
            begin
                TmpExcelBuffer.OnlyCreateBook('Sales Invoice Header+Contact', '', COMPANYNAME, USERID, FALSE);
                window.CLOSE;
            end;

            trigger OnPreDataItem()
            var
                MSG001L: Label 'Order Amount';
            begin
                //++TWN.01.14
                /*
                IF cdeCampaign <> '' THEN
                   SETRANGE("Campaign No.", cdeCampaign);
                */
                IF cdeCampaign <> '' THEN
                    SETRANGE("Campaign No.", cdeCampaign)
                ELSE
                    SETFILTER("Campaign No.", '%1', '');
                //--TWN.01.14
                //++TWN.01.19
                IF booALLCampaign THEN
                    SETFILTER("Campaign No.", '%1', '*');
                //--TWN.01.19

                intExcelRowNo := 1;
                intExcelColNo := 0;
                CLEAR(TmpExcelBuffer);
                TmpExcelBuffer.DELETEALL;

                intExcelColNo += 1;
                EnterCell(1, intExcelColNo, FIELDCAPTION("No."), TRUE);
                intExcelColNo += 1;
                EnterCell(1, intExcelColNo, FIELDCAPTION("Posting Date"), TRUE);
                intExcelColNo += 1;
                EnterCell(1, intExcelColNo, FIELDCAPTION("Campaign No."), TRUE);
                intExcelColNo += 1;
                EnterCell(1, intExcelColNo, MSG001L, TRUE);
                intExcelColNo += 1;
                EnterCell(1, intExcelColNo, FIELDCAPTION("Vehicle No."), TRUE);
                intExcelColNo += 1;
                EnterCell(1, intExcelColNo, FIELDCAPTION("Licence-Plate No."), TRUE);
                intExcelColNo += 1;
                EnterCell(1, intExcelColNo, FIELDCAPTION("Sell-to Contact No."), TRUE);
                intExcelColNo += 1;
                EnterCell(1, intExcelColNo, recContact.FIELDCAPTION(Name), TRUE);
                intExcelColNo += 1;
                EnterCell(1, intExcelColNo, recContact.FIELDCAPTION("Name 2"), TRUE);
                intExcelColNo += 1;
                EnterCell(1, intExcelColNo, FIELDCAPTION("Responsibility Center"), TRUE);
                intExcelColNo += 1;
                EnterCell(1, intExcelColNo, recContact.FIELDCAPTION("Phone No."), TRUE);
                intExcelColNo += 1;
                EnterCell(1, intExcelColNo, recContact.FIELDCAPTION("Mobile Phone No."), TRUE);
                intExcelColNo += 1;
                EnterCell(1, intExcelColNo, recContact.FIELDCAPTION("Mobile Phone No. 2"), TRUE);
                intExcelColNo += 1;
                EnterCell(1, intExcelColNo, recContact.FIELDCAPTION("Fax No."), TRUE);
                intExcelColNo += 1;
                EnterCell(1, intExcelColNo, recContact.FIELDCAPTION("Fax No. 2"), TRUE);
                intExcelColNo += 1;
                EnterCell(1, intExcelColNo, recContact.FIELDCAPTION("Post Code"), TRUE);
                intExcelColNo += 1;
                EnterCell(1, intExcelColNo, recContact.FIELDCAPTION(City), TRUE);
                intExcelColNo += 1;
                EnterCell(1, intExcelColNo, recContact.FIELDCAPTION("Date of Birth"), TRUE);
                intExcelColNo += 1;
                EnterCell(1, intExcelColNo, recContact.FIELDCAPTION("Personal Data Status"), TRUE);
                intExcelColNo += 1;
                EnterCell(1, intExcelColNo, recContact.FIELDCAPTION("Personal Data Agreement Date"), TRUE);
                intExcelColNo += 1;
                EnterCell(1, intExcelColNo, recContact.FIELDCAPTION("Correspondence Type"), TRUE);
                intExcelColNo += 1;
                EnterCell(1, intExcelColNo, recContact.FIELDCAPTION("Creation Date"), TRUE);
                intExcelColNo += 1;
                //++TWN.01.19
                EnterCell(1, intExcelColNo, "Sales Invoice Header".FIELDCAPTION("Credit Memo No."), TRUE);
                intExcelColNo += 1;
                //--TWN.01.19

                //++TWN.01.19
                //window.OPEN('處理資料(Step 1/4)  #1########## /  #2##########');
                window.OPEN('處理資料(Step 1/6)  #1########## /  #2##########');
                //--TWN.01.19
                window.UPDATE(1, 0);
                window.UPDATE(2, COUNT);
                intCount := 0;

            end;
        }
        dataitem("<Invoice Line Sheet>"; Integer)
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
                intExcelColNo := 0;

                tmpSalesInvLine.NEXT;
                intExcelColNo += 1;
                EnterCell(intExcelRowNo, intExcelColNo, FORMAT(tmpSalesInvLine."Document No."), FALSE);
                intExcelColNo += 1;
                EnterCell(intExcelRowNo, intExcelColNo, FORMAT(tmpSalesInvLine."Line No."), FALSE);
                intExcelColNo += 1;
                EnterCell(intExcelRowNo, intExcelColNo, FORMAT(tmpSalesInvLine.Type), FALSE);
                intExcelColNo += 1;
                EnterCell(intExcelRowNo, intExcelColNo, FORMAT(tmpSalesInvLine."No."), FALSE);
                intExcelColNo += 1;
                EnterCell(intExcelRowNo, intExcelColNo, FORMAT(tmpSalesInvLine.Description), FALSE);
                intExcelColNo += 1;
                EnterCell(intExcelRowNo, intExcelColNo, FORMAT(tmpSalesInvLine."Description 2"), FALSE);
                intExcelColNo += 1;
                EnterCell(intExcelRowNo, intExcelColNo, FORMAT(tmpSalesInvLine.Quantity), FALSE);
                intExcelColNo += 1;

                CLEAR(decTemp);
                IF tmpSalesInvLine.Quantity <> 0 THEN decTemp := ROUND(tmpSalesInvLine."Line Amount" / tmpSalesInvLine.Quantity, 1.0);
                EnterCell(intExcelRowNo, intExcelColNo, FORMAT(decTemp), FALSE);
                intExcelColNo += 1;

                EnterCell(intExcelRowNo, intExcelColNo, FORMAT(tmpSalesInvLine."Line Amount"), FALSE);
                intExcelColNo += 1;
                EnterCell(intExcelRowNo, intExcelColNo, FORMAT(tmpSalesInvLine."Vehicle No."), FALSE);
                intExcelColNo += 1;
                EnterCell(intExcelRowNo, intExcelColNo, '''' + FORMAT(tmpSalesInvLine."Licence-Plate No. Short"), FALSE);
                intExcelColNo += 1;
                EnterCell(intExcelRowNo, intExcelColNo, FORMAT(tmpSalesInvLine."Sell-to Contact No."), FALSE);
                intExcelColNo += 1;

                CLEAR(recContact);
                IF recContact.GET(tmpSalesInvLine."Sell-to Contact No.") THEN;
                EnterCell(intExcelRowNo, intExcelColNo, FORMAT(recContact.Name), FALSE);
                intExcelColNo += 1;
                EnterCell(intExcelRowNo, intExcelColNo, FORMAT(recContact."Name 2"), FALSE);
                intExcelColNo += 1;
                EnterCell(intExcelRowNo, intExcelColNo, FORMAT(tmpSalesInvLine."Responsibility Center"), FALSE);
                intExcelColNo += 1;
                EnterCell(intExcelRowNo, intExcelColNo, '''' + FORMAT(recContact."Phone No."), FALSE);
                intExcelColNo += 1;
                EnterCell(intExcelRowNo, intExcelColNo, '''' + FORMAT(recContact."Mobile Phone No."), FALSE);
                intExcelColNo += 1;
                EnterCell(intExcelRowNo, intExcelColNo, '''' + FORMAT(recContact."Mobile Phone No. 2"), FALSE);
                intExcelColNo += 1;
                EnterCell(intExcelRowNo, intExcelColNo, '''' + FORMAT(recContact."Fax No."), FALSE);
                intExcelColNo += 1;
                EnterCell(intExcelRowNo, intExcelColNo, '''' + FORMAT(recContact."Fax No. 2"), FALSE);
                intExcelColNo += 1;
                EnterCell(intExcelRowNo, intExcelColNo, FORMAT(recContact."Post Code"), FALSE);
                intExcelColNo += 1;
                EnterCell(intExcelRowNo, intExcelColNo, FORMAT(recContact.City), FALSE);
                intExcelColNo += 1;
                EnterCell(intExcelRowNo, intExcelColNo, FORMAT(recContact."Date of Birth"), FALSE);
                intExcelColNo += 1;
                EnterCell(intExcelRowNo, intExcelColNo, FORMAT(recContact."Personal Data Status"), FALSE);
                intExcelColNo += 1;
                EnterCell(intExcelRowNo, intExcelColNo, FORMAT(recContact."Personal Data Agreement Date"), FALSE);
                intExcelColNo += 1;
                EnterCell(intExcelRowNo, intExcelColNo, FORMAT(recContact."Correspondence Type"), FALSE);
                intExcelColNo += 1;
                EnterCell(intExcelRowNo, intExcelColNo, FORMAT(recContact."Creation Date"), FALSE);
                intExcelColNo += 1;
                EnterCell(intExcelRowNo, intExcelColNo, '''' + FORMAT(tmpSalesInvLine."Fitter 1"), FALSE);
                intExcelColNo += 1;
                IF tmpSalesInvLine."Fitter 1" <> '' THEN
                    recSalesperson.GET(tmpSalesInvLine."Fitter 1");
                EnterCell(intExcelRowNo, intExcelColNo, recSalesperson.Name, FALSE);
                intExcelColNo += 1;
            end;

            trigger OnPostDataItem()
            begin
                TmpExcelBuffer.OnlyCreateBook('Sales Invoice Line+Contact', '', COMPANYNAME, USERID, TRUE);
                window.CLOSE;
            end;

            trigger OnPreDataItem()
            begin
                tmpSalesInvLine.RESET;
                SETRANGE(Number, 1, tmpSalesInvLine.COUNT);
                intExcelRowNo := 1;
                intExcelColNo := 0;

                TmpExcelBuffer.DELETEALL;
                COMMIT;

                intExcelColNo += 1;
                EnterCell(1, intExcelColNo, "Sales Invoice Line".FIELDCAPTION("Document No."), TRUE);
                intExcelColNo += 1;
                EnterCell(1, intExcelColNo, "Sales Invoice Line".FIELDCAPTION("Line No."), TRUE);
                intExcelColNo += 1;
                EnterCell(1, intExcelColNo, "Sales Invoice Line".FIELDCAPTION(Type), TRUE);
                intExcelColNo += 1;
                EnterCell(1, intExcelColNo, "Sales Invoice Line".FIELDCAPTION("No."), TRUE);
                intExcelColNo += 1;
                EnterCell(1, intExcelColNo, "Sales Invoice Line".FIELDCAPTION(Description), TRUE);
                intExcelColNo += 1;
                EnterCell(1, intExcelColNo, "Sales Invoice Line".FIELDCAPTION("Description 2"), TRUE);
                intExcelColNo += 1;
                EnterCell(1, intExcelColNo, "Sales Invoice Line".FIELDCAPTION(Quantity), TRUE);
                intExcelColNo += 1;
                //EnterCell(1, intExcelColNo, "Sales Invoice Line".FIELDCAPTION("Unit Price"), TRUE); intExcelColNo += 1;
                //EnterCell(1, intExcelColNo, "Sales Invoice Line".FIELDCAPTION("Line Amount"), TRUE); intExcelColNo += 1;
                EnterCell(1, intExcelColNo, UnitPriceCaption, TRUE);
                intExcelColNo += 1;
                EnterCell(1, intExcelColNo, LineAmountCaption, TRUE);
                intExcelColNo += 1;
                EnterCell(1, intExcelColNo, "Sales Invoice Line".FIELDCAPTION("Vehicle No."), TRUE);
                intExcelColNo += 1;
                EnterCell(1, intExcelColNo, "Sales Invoice Line".FIELDCAPTION("Licence-Plate No. Short"), TRUE);
                intExcelColNo += 1;
                EnterCell(1, intExcelColNo, "Sales Invoice Line".FIELDCAPTION("Sell-to Contact No."), TRUE);
                intExcelColNo += 1;
                EnterCell(1, intExcelColNo, recContact.FIELDCAPTION(Name), TRUE);
                intExcelColNo += 1;
                EnterCell(1, intExcelColNo, recContact.FIELDCAPTION("Name 2"), TRUE);
                intExcelColNo += 1;
                EnterCell(1, intExcelColNo, "Sales Invoice Line".FIELDCAPTION("Responsibility Center"), TRUE);
                intExcelColNo += 1;
                EnterCell(1, intExcelColNo, recContact.FIELDCAPTION("Phone No."), TRUE);
                intExcelColNo += 1;
                EnterCell(1, intExcelColNo, recContact.FIELDCAPTION("Mobile Phone No."), TRUE);
                intExcelColNo += 1;
                EnterCell(1, intExcelColNo, recContact.FIELDCAPTION("Mobile Phone No. 2"), TRUE);
                intExcelColNo += 1;
                EnterCell(1, intExcelColNo, recContact.FIELDCAPTION("Fax No."), TRUE);
                intExcelColNo += 1;
                EnterCell(1, intExcelColNo, recContact.FIELDCAPTION("Fax No. 2"), TRUE);
                intExcelColNo += 1;
                EnterCell(1, intExcelColNo, recContact.FIELDCAPTION("Post Code"), TRUE);
                intExcelColNo += 1;
                EnterCell(1, intExcelColNo, recContact.FIELDCAPTION(City), TRUE);
                intExcelColNo += 1;
                EnterCell(1, intExcelColNo, recContact.FIELDCAPTION("Date of Birth"), TRUE);
                intExcelColNo += 1;
                EnterCell(1, intExcelColNo, recContact.FIELDCAPTION("Personal Data Status"), TRUE);
                intExcelColNo += 1;
                EnterCell(1, intExcelColNo, recContact.FIELDCAPTION("Personal Data Agreement Date"), TRUE);
                intExcelColNo += 1;
                EnterCell(1, intExcelColNo, recContact.FIELDCAPTION("Correspondence Type"), TRUE);
                intExcelColNo += 1;
                EnterCell(1, intExcelColNo, recContact.FIELDCAPTION("Creation Date"), TRUE);
                intExcelColNo += 1;
                EnterCell(1, intExcelColNo, "Sales Invoice Line".FIELDCAPTION("Fitter 1"), TRUE);
                intExcelColNo += 1;
                EnterCell(1, intExcelColNo, recSalesperson.FIELDCAPTION(Name), TRUE);
                intExcelColNo += 1;
                //++TWN.01.19
                //window.OPEN('處理資料(Step 2/4)  #1########## /  #2##########');
                window.OPEN('處理資料(Step 2/6)  #1########## /  #2##########');
                //--TWN.01.19
                window.UPDATE(1, 0);
                window.UPDATE(2, tmpSalesInvLine.COUNT);
                intCount := 0;
                CLEAR(tmpSalesInvLine);
            end;
        }
        dataitem("<Answer Sheet>"; Integer)
        {
            DataItemTableView = SORTING(Number);

            trigger OnAfterGetRecord()
            begin
                intCount += 1;
                window.UPDATE(1, intCount);
                intExcelRowNo += 1;
                intExcelColNo := 0;

                tmpContact.NEXT;
                intExcelColNo += 1;
                EnterCell(intExcelRowNo, intExcelColNo, FORMAT(tmpContact."No."), FALSE);
                intExcelColNo += 1;
                EnterCell(intExcelRowNo, intExcelColNo, FORMAT(tmpContact.Name), FALSE);
                intExcelColNo += 1;
                EnterCell(intExcelRowNo, intExcelColNo, FORMAT(tmpContact."Name 2"), FALSE);
                intExcelColNo += 1;
                EnterCell(intExcelRowNo, intExcelColNo, '''' + FORMAT(tmpContact."Phone No."), FALSE);
                intExcelColNo += 1;
                EnterCell(intExcelRowNo, intExcelColNo, '''' + FORMAT(tmpContact."Mobile Phone No."), FALSE);
                intExcelColNo += 1;
                EnterCell(intExcelRowNo, intExcelColNo, '''' + FORMAT(tmpContact."Mobile Phone No. 2"), FALSE);
                intExcelColNo += 1;
                EnterCell(intExcelRowNo, intExcelColNo, '''' + FORMAT(tmpContact."Fax No."), FALSE);
                intExcelColNo += 1;
                EnterCell(intExcelRowNo, intExcelColNo, '''' + FORMAT(tmpContact."Fax No. 2"), FALSE);
                intExcelColNo += 1;
                EnterCell(intExcelRowNo, intExcelColNo, FORMAT(tmpContact."Post Code"), FALSE);
                intExcelColNo += 1;
                EnterCell(intExcelRowNo, intExcelColNo, FORMAT(tmpContact.City), FALSE);
                intExcelColNo += 1;
                EnterCell(intExcelRowNo, intExcelColNo, FORMAT(tmpContact."Date of Birth"), FALSE);
                intExcelColNo += 1;
                EnterCell(intExcelRowNo, intExcelColNo, FORMAT(tmpContact."Personal Data Status"), FALSE);
                intExcelColNo += 1;
                EnterCell(intExcelRowNo, intExcelColNo, FORMAT(tmpContact."Personal Data Agreement Date"), FALSE);
                intExcelColNo += 1;
                EnterCell(intExcelRowNo, intExcelColNo, FORMAT(tmpContact."Correspondence Type"), FALSE);
                intExcelColNo += 1;
                EnterCell(intExcelRowNo, intExcelColNo, FORMAT(tmpContact."Creation Date"), FALSE);
                intExcelColNo += 1;
                EnterCell(intExcelRowNo, intExcelColNo, FORMAT(cdeProfile), FALSE);
                intExcelColNo += 1;

                // get answer and put into right excel cell by using the tmpProfileLine."Wizard From Line No." as Column No
                CLEAR(recAnswer);
                recAnswer.SETRANGE("Contact No.", tmpContact."No.");
                recAnswer.SETRANGE(recAnswer."Profile Questionnaire Code", cdeProfile);
                IF recAnswer.FIND('-') THEN BEGIN
                    REPEAT
                        CLEAR(tmpProfileLine);
                        tmpProfileLine.SETRANGE("Profile Questionnaire Code", recAnswer."Profile Questionnaire Code");
                        tmpProfileLine.SETRANGE("Line No.", recAnswer."Line No.");
                        IF tmpProfileLine.FIND('-') THEN
                            EnterCell(intExcelRowNo, tmpProfileLine."Wizard From Line No.", 'Yes', FALSE);
                    UNTIL recAnswer.NEXT = 0;
                END;
            end;

            trigger OnPostDataItem()
            begin
                TmpExcelBuffer.OnlyCreateBook('Contact Profile Answer+Contact', '', COMPANYNAME, USERID, TRUE);
                window.CLOSE;
            end;

            trigger OnPreDataItem()
            var
                MSG001L: Label 'Profile Questionnaire Code';
            begin
                CLEAR(tmpContact);
                SETRANGE(Number, 1, tmpContact.COUNT);
                intExcelRowNo := 1;
                intExcelColNo := 0;

                TmpExcelBuffer.DELETEALL;
                COMMIT;

                intExcelColNo += 1;
                EnterCell(1, intExcelColNo, tmpContact.FIELDCAPTION("No."), TRUE);
                intExcelColNo += 1;
                EnterCell(1, intExcelColNo, tmpContact.FIELDCAPTION(Name), TRUE);
                intExcelColNo += 1;
                EnterCell(1, intExcelColNo, tmpContact.FIELDCAPTION("Name 2"), TRUE);
                intExcelColNo += 1;
                EnterCell(1, intExcelColNo, tmpContact.FIELDCAPTION("Phone No."), TRUE);
                intExcelColNo += 1;
                EnterCell(1, intExcelColNo, tmpContact.FIELDCAPTION("Mobile Phone No."), TRUE);
                intExcelColNo += 1;
                EnterCell(1, intExcelColNo, tmpContact.FIELDCAPTION("Mobile Phone No. 2"), TRUE);
                intExcelColNo += 1;
                EnterCell(1, intExcelColNo, tmpContact.FIELDCAPTION("Fax No."), TRUE);
                intExcelColNo += 1;
                EnterCell(1, intExcelColNo, tmpContact.FIELDCAPTION("Fax No. 2"), TRUE);
                intExcelColNo += 1;
                EnterCell(1, intExcelColNo, tmpContact.FIELDCAPTION("Post Code"), TRUE);
                intExcelColNo += 1;
                EnterCell(1, intExcelColNo, tmpContact.FIELDCAPTION(City), TRUE);
                intExcelColNo += 1;
                EnterCell(1, intExcelColNo, tmpContact.FIELDCAPTION("Date of Birth"), TRUE);
                intExcelColNo += 1;
                EnterCell(1, intExcelColNo, tmpContact.FIELDCAPTION("Personal Data Status"), TRUE);
                intExcelColNo += 1;
                EnterCell(1, intExcelColNo, tmpContact.FIELDCAPTION("Personal Data Agreement Date"), TRUE);
                intExcelColNo += 1;
                EnterCell(1, intExcelColNo, tmpContact.FIELDCAPTION("Correspondence Type"), TRUE);
                intExcelColNo += 1;
                EnterCell(1, intExcelColNo, tmpContact.FIELDCAPTION("Creation Date"), TRUE);
                intExcelColNo += 1;
                EnterCell(1, intExcelColNo, MSG001L, TRUE);
                intExcelColNo += 1;

                IF recProfileLine.FIND('-') THEN BEGIN
                    REPEAT
                        IF recProfileLine.Type = recProfileLine.Type::Question THEN BEGIN
                            EnterCell(1, intExcelColNo, FORMAT(recProfileLine.Description), TRUE);
                            intExcelColNo += 1;
                        END
                        ELSE BEGIN
                            EnterCell(1, intExcelColNo, FORMAT(recProfileLine.Description), FALSE);
                            intExcelColNo += 1;
                        END;

                        tmpProfileLine.RESET;
                        tmpProfileLine.INIT;
                        tmpProfileLine.TRANSFERFIELDS(recProfileLine);
                        tmpProfileLine."Wizard From Line No." := intExcelColNo - 1;
                        tmpProfileLine.INSERT;

                    UNTIL recProfileLine.NEXT = 0;
                END;
                //++TWN.01.19
                //window.OPEN('處理資料(Step 3/4)  #1########## /  #2##########');
                window.OPEN('處理資料(Step 3/6)  #1########## /  #2##########');
                //--TWN.01.19
                window.UPDATE(1, 0);
                window.UPDATE(2, tmpContact.COUNT);
                intCount := 0;
            end;
        }
        dataitem(Contact; Contact)
        {
            DataItemTableView = SORTING("No.");

            trigger OnAfterGetRecord()
            begin
                intCount += 1;
                window.UPDATE(1, intCount);

                // check if this contact has input asnwer
                CLEAR(recAnswer);
                recAnswer.SETRANGE("Contact No.", "No.");
                recAnswer.SETRANGE(recAnswer."Profile Questionnaire Code", cdeProfile);
                IF NOT recAnswer.FINDSET THEN EXIT;

                intExcelRowNo += 1;
                intExcelColNo := 0;

                intExcelColNo += 1;
                EnterCell(intExcelRowNo, intExcelColNo, FORMAT("No."), FALSE);
                intExcelColNo += 1;
                EnterCell(intExcelRowNo, intExcelColNo, FORMAT(Name), FALSE);
                intExcelColNo += 1;
                EnterCell(intExcelRowNo, intExcelColNo, FORMAT("Name 2"), FALSE);
                intExcelColNo += 1;
                EnterCell(intExcelRowNo, intExcelColNo, '''' + FORMAT("Phone No."), FALSE);
                intExcelColNo += 1;
                EnterCell(intExcelRowNo, intExcelColNo, '''' + FORMAT("Mobile Phone No."), FALSE);
                intExcelColNo += 1;
                EnterCell(intExcelRowNo, intExcelColNo, '''' + FORMAT("Mobile Phone No. 2"), FALSE);
                intExcelColNo += 1;
                EnterCell(intExcelRowNo, intExcelColNo, '''' + FORMAT("Fax No."), FALSE);
                intExcelColNo += 1;
                EnterCell(intExcelRowNo, intExcelColNo, '''' + FORMAT("Fax No. 2"), FALSE);
                intExcelColNo += 1;
                EnterCell(intExcelRowNo, intExcelColNo, FORMAT("Post Code"), FALSE);
                intExcelColNo += 1;
                EnterCell(intExcelRowNo, intExcelColNo, FORMAT(City), FALSE);
                intExcelColNo += 1;
                EnterCell(intExcelRowNo, intExcelColNo, FORMAT("Date of Birth"), FALSE);
                intExcelColNo += 1;
                EnterCell(intExcelRowNo, intExcelColNo, FORMAT("Personal Data Status"), FALSE);
                intExcelColNo += 1;
                EnterCell(intExcelRowNo, intExcelColNo, FORMAT("Personal Data Agreement Date"), FALSE);
                intExcelColNo += 1;
                EnterCell(intExcelRowNo, intExcelColNo, FORMAT("Correspondence Type"), FALSE);
                intExcelColNo += 1;
                EnterCell(intExcelRowNo, intExcelColNo, FORMAT("Creation Date"), FALSE);
                intExcelColNo += 1;
                EnterCell(intExcelRowNo, intExcelColNo, FORMAT(cdeProfile), FALSE);
                intExcelColNo += 1;

                // get answer and put into right excel cell by using the tmpProfileLine."Wizard From Line No." as Column No
                CLEAR(recAnswer);
                recAnswer.SETRANGE("Contact No.", "No.");
                recAnswer.SETRANGE(recAnswer."Profile Questionnaire Code", cdeProfile);
                IF recAnswer.FIND('-') THEN BEGIN
                    REPEAT
                        CLEAR(tmpProfileLine);
                        tmpProfileLine.SETRANGE("Profile Questionnaire Code", recAnswer."Profile Questionnaire Code");
                        tmpProfileLine.SETRANGE("Line No.", recAnswer."Line No.");
                        IF tmpProfileLine.FIND('-') THEN
                            EnterCell(intExcelRowNo, tmpProfileLine."Wizard From Line No.", 'Yes', FALSE);
                        UNTIL recAnswer.NEXT = 0;
                END;
                end;

            trigger OnPostDataItem()
            begin
                TmpExcelBuffer.OnlyCreateBook('Company Contact Profile Answer', '', COMPANYNAME, USERID, TRUE);
                window.CLOSE;
            end;

            trigger OnPreDataItem()
            var
                MSG001L: Label 'Profile Questionnaire Code';
            begin
                intExcelRowNo := 1;
                intExcelColNo := 0;

                TmpExcelBuffer.DELETEALL;
                COMMIT;

                intExcelColNo += 1;

                EnterCell(1, intExcelColNo, FIELDCAPTION("No."), TRUE);
                intExcelColNo += 1;
                EnterCell(1, intExcelColNo, FIELDCAPTION(Name), TRUE);
                intExcelColNo += 1;
                EnterCell(1, intExcelColNo, FIELDCAPTION("Name 2"), TRUE);
                intExcelColNo += 1;
                EnterCell(1, intExcelColNo, FIELDCAPTION("Phone No."), TRUE);
                intExcelColNo += 1;
                EnterCell(1, intExcelColNo, FIELDCAPTION("Mobile Phone No."), TRUE);
                intExcelColNo += 1;
                EnterCell(1, intExcelColNo, FIELDCAPTION("Mobile Phone No. 2"), TRUE);
                intExcelColNo += 1;
                EnterCell(1, intExcelColNo, FIELDCAPTION("Fax No."), TRUE);
                intExcelColNo += 1;
                EnterCell(1, intExcelColNo, FIELDCAPTION("Fax No. 2"), TRUE);
                intExcelColNo += 1;
                EnterCell(1, intExcelColNo, FIELDCAPTION("Post Code"), TRUE);
                intExcelColNo += 1;
                EnterCell(1, intExcelColNo, FIELDCAPTION(City), TRUE);
                intExcelColNo += 1;
                EnterCell(1, intExcelColNo, FIELDCAPTION("Date of Birth"), TRUE);
                intExcelColNo += 1;
                EnterCell(1, intExcelColNo, FIELDCAPTION("Personal Data Status"), TRUE);
                intExcelColNo += 1;
                EnterCell(1, intExcelColNo, FIELDCAPTION("Personal Data Agreement Date"), TRUE);
                intExcelColNo += 1;
                EnterCell(1, intExcelColNo, FIELDCAPTION("Correspondence Type"), TRUE);
                intExcelColNo += 1;
                EnterCell(1, intExcelColNo, FIELDCAPTION("Creation Date"), TRUE);
                intExcelColNo += 1;
                EnterCell(1, intExcelColNo, MSG001L, TRUE);
                intExcelColNo += 1;

                IF recProfileLine.FIND('-') THEN BEGIN
                    REPEAT
                        IF recProfileLine.Type = recProfileLine.Type::Question THEN BEGIN
                            EnterCell(1, intExcelColNo, FORMAT(recProfileLine.Description), TRUE);
                            intExcelColNo += 1;
                        END
                        ELSE BEGIN
                            EnterCell(1, intExcelColNo, FORMAT(recProfileLine.Description), FALSE);
                            intExcelColNo += 1;
                        END;

                    UNTIL recProfileLine.NEXT = 0;
                END;
                //++TWN.01.19
                //window.OPEN('處理資料(Step 4/4)  #1########## /  #2##########');
                window.OPEN('處理資料(Step 4/6)  #1########## /  #2##########');
                //--TWN.01.19
                window.UPDATE(1, 0);
                window.UPDATE(2, COUNT);
                intCount := 0;
            end;
        }
        dataitem("Sales Cr.Memo Header"; "Sales Cr.Memo Header")
        {
            DataItemTableView = SORTING("Posting Date");
            dataitem("Sales Cr.Memo Line"; "Sales Cr.Memo Line")
            {
                DataItemLink = "Document No." = FIELD("No.");
                DataItemTableView = SORTING("Document No.", "Line No.")
                                    ORDER(Ascending);

                trigger OnAfterGetRecord()
                begin
                    CLEAR(recContact);
                    booAllowShow := FALSE;
                    //IF recContact.GET("Sales Cr.Memo Header"."Sell-to Contact No.") THEN;
                    IF recContact.GET("Sales Cr.Memo Line"."Sell-to Contact No.") THEN BEGIN
                        IF booNone THEN
                            IF recContact."Personal Data Status" = recContact."Personal Data Status"::None THEN booAllowShow := TRUE;
                        IF booYes THEN
                            IF recContact."Personal Data Status" = recContact."Personal Data Status"::Yes THEN booAllowShow := TRUE;
                        IF booNo THEN
                            IF recContact."Personal Data Status" = recContact."Personal Data Status"::No THEN booAllowShow := TRUE;
                        IF booNA THEN
                            IF recContact."Personal Data Status" = recContact."Personal Data Status"::"N/A" THEN booAllowShow := TRUE;
                    END;
                    IF NOT booAllowShow THEN EXIT;

                    tmpSalesCrMemInvLine.RESET;
                    tmpSalesCrMemInvLine.INIT;
                    tmpSalesCrMemInvLine.TRANSFERFIELDS("Sales Cr.Memo Line");
                    tmpSalesCrMemInvLine.INSERT;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                //++TWN.01.19
                CLEAR(recContact);
                booAllowShow := FALSE;
                IF recContact.GET("Sell-to Contact No.") THEN BEGIN
                    IF booNone THEN
                        IF recContact."Personal Data Status" = recContact."Personal Data Status"::None THEN booAllowShow := TRUE;
                    IF booYes THEN
                        IF recContact."Personal Data Status" = recContact."Personal Data Status"::Yes THEN booAllowShow := TRUE;
                    IF booNo THEN
                        IF recContact."Personal Data Status" = recContact."Personal Data Status"::No THEN booAllowShow := TRUE;
                    IF booNA THEN
                        IF recContact."Personal Data Status" = recContact."Personal Data Status"::"N/A" THEN booAllowShow := TRUE;
                END;

                IF NOT booAllowShow THEN EXIT;


                intCount += 1;
                window.UPDATE(1, intCount);
                intExcelRowNo += 1;
                intExcelColNo := 0;

                intExcelColNo += 1;
                EnterCell(intExcelRowNo, intExcelColNo, FORMAT("No."), FALSE);
                intExcelColNo += 1;
                EnterCell(intExcelRowNo, intExcelColNo, FORMAT("Posting Date"), FALSE);
                intExcelColNo += 1;
                EnterCell(intExcelRowNo, intExcelColNo, FORMAT("Campaign No."), FALSE);
                intExcelColNo += 1;

                CLEAR(recSaleCrMemoLine);
                CLEAR(decTemp);
                recSaleCrMemoLine.SETRANGE("Document No.", "No.");
                IF recSaleCrMemoLine.FIND('-') THEN BEGIN
                    REPEAT
                        decTemp += recSaleCrMemoLine."Line Amount";
                    UNTIL recSaleCrMemoLine.NEXT = 0;
                END;

                EnterCell(intExcelRowNo, intExcelColNo, FORMAT(decTemp), FALSE);
                intExcelColNo += 1;
                EnterCell(intExcelRowNo, intExcelColNo, FORMAT("Vehicle No."), FALSE);
                intExcelColNo += 1;
                EnterCell(intExcelRowNo, intExcelColNo, '''' + FORMAT("Licence-Plate No."), FALSE);
                intExcelColNo += 1;
                EnterCell(intExcelRowNo, intExcelColNo, FORMAT("Sell-to Contact No."), FALSE);
                intExcelColNo += 1;


                CLEAR(recContact);
                IF recContact.GET("Sell-to Contact No.") THEN BEGIN
                    /*
                    CLEAR(tmpContact);
                    IF NOT tmpContact.GET("Sell-to Contact No.") THEN
                    BEGIN
                      tmpContact.RESET;
                      tmpContact.INIT;
                      tmpContact.TRANSFERFIELDS(recContact);
                      tmpContact.INSERT;
                    END;
                    */
                END;

                EnterCell(intExcelRowNo, intExcelColNo, FORMAT(recContact.Name), FALSE);
                intExcelColNo += 1;
                EnterCell(intExcelRowNo, intExcelColNo, FORMAT(recContact."Name 2"), FALSE);
                intExcelColNo += 1;
                EnterCell(intExcelRowNo, intExcelColNo, FORMAT("Responsibility Center"), FALSE);
                intExcelColNo += 1;
                EnterCell(intExcelRowNo, intExcelColNo, '''' + FORMAT(recContact."Phone No."), FALSE);
                intExcelColNo += 1;
                EnterCell(intExcelRowNo, intExcelColNo, '''' + FORMAT(recContact."Mobile Phone No."), FALSE);
                intExcelColNo += 1;
                EnterCell(intExcelRowNo, intExcelColNo, '''' + FORMAT(recContact."Mobile Phone No. 2"), FALSE);
                intExcelColNo += 1;
                EnterCell(intExcelRowNo, intExcelColNo, '''' + FORMAT(recContact."Fax No."), FALSE);
                intExcelColNo += 1;
                EnterCell(intExcelRowNo, intExcelColNo, '''' + FORMAT(recContact."Fax No. 2"), FALSE);
                intExcelColNo += 1;
                EnterCell(intExcelRowNo, intExcelColNo, FORMAT(recContact."Post Code"), FALSE);
                intExcelColNo += 1;
                EnterCell(intExcelRowNo, intExcelColNo, FORMAT(recContact.City), FALSE);
                intExcelColNo += 1;
                EnterCell(intExcelRowNo, intExcelColNo, FORMAT(recContact."Date of Birth"), FALSE);
                intExcelColNo += 1;
                EnterCell(intExcelRowNo, intExcelColNo, FORMAT(recContact."Personal Data Status"), FALSE);
                intExcelColNo += 1;
                EnterCell(intExcelRowNo, intExcelColNo, FORMAT(recContact."Personal Data Agreement Date"), FALSE);
                intExcelColNo += 1;
                EnterCell(intExcelRowNo, intExcelColNo, FORMAT(recContact."Correspondence Type"), FALSE);
                intExcelColNo += 1;
                EnterCell(intExcelRowNo, intExcelColNo, FORMAT(recContact."Creation Date"), FALSE);
                intExcelColNo += 1;
                //EnterCell(intExcelRowNo, intExcelColNo, "Credit Memo No.",FALSE); intExcelColNo += 1;

                //--TWN.01.19

            end;

            trigger OnPostDataItem()
            begin
                TmpExcelBuffer.OnlyCreateBook('Sales Cr Memo Header+Contact', '', COMPANYNAME, USERID, TRUE);
                window.CLOSE;
            end;

            trigger OnPreDataItem()
            var
                MSG001L: Label 'Order Amount';
            begin
                //++TWN.01.19
                IF cdeCampaign <> '' THEN
                    SETRANGE("Campaign No.", cdeCampaign)
                ELSE
                    SETFILTER("Campaign No.", '%1', '');

                IF booALLCampaign THEN
                    SETFILTER("Campaign No.", '%1', '*');

                SETFILTER("Responsibility Center", ResponsibilityCenter);
                SETFILTER("Posting Date", PostingDate);
                SETFILTER("Sell-to Customer No.", "Sell-toCustomerNo");
                SETFILTER("Bill-to Customer No.", "Bill-toCustomerNo");
                SETFILTER("Sell-to Contact No.", "Sell-toContactNo");
                SETFILTER("Bill-to Contact No.", "Bill-toContactNo");
                SETFILTER("Vehicle No.", VehicleNo);
                SETFILTER("Licence-Plate No.", "License-PlateNo");
                //SETFILTER("Campaign No.",CampaignNo);

                intExcelRowNo := 1;
                intExcelColNo := 0;

                TmpExcelBuffer.DELETEALL;
                COMMIT;

                intExcelColNo += 1;
                EnterCell(1, intExcelColNo, FIELDCAPTION("No."), TRUE);
                intExcelColNo += 1;
                EnterCell(1, intExcelColNo, FIELDCAPTION("Posting Date"), TRUE);
                intExcelColNo += 1;
                EnterCell(1, intExcelColNo, FIELDCAPTION("Campaign No."), TRUE);
                intExcelColNo += 1;
                EnterCell(1, intExcelColNo, MSG001L, TRUE);
                intExcelColNo += 1;
                EnterCell(1, intExcelColNo, FIELDCAPTION("Vehicle No."), TRUE);
                intExcelColNo += 1;
                EnterCell(1, intExcelColNo, FIELDCAPTION("Licence-Plate No."), TRUE);
                intExcelColNo += 1;
                EnterCell(1, intExcelColNo, FIELDCAPTION("Sell-to Contact No."), TRUE);
                intExcelColNo += 1;
                EnterCell(1, intExcelColNo, recContact.FIELDCAPTION(Name), TRUE);
                intExcelColNo += 1;
                EnterCell(1, intExcelColNo, recContact.FIELDCAPTION("Name 2"), TRUE);
                intExcelColNo += 1;
                EnterCell(1, intExcelColNo, FIELDCAPTION("Responsibility Center"), TRUE);
                intExcelColNo += 1;
                EnterCell(1, intExcelColNo, recContact.FIELDCAPTION("Phone No."), TRUE);
                intExcelColNo += 1;
                EnterCell(1, intExcelColNo, recContact.FIELDCAPTION("Mobile Phone No."), TRUE);
                intExcelColNo += 1;
                EnterCell(1, intExcelColNo, recContact.FIELDCAPTION("Mobile Phone No. 2"), TRUE);
                intExcelColNo += 1;
                EnterCell(1, intExcelColNo, recContact.FIELDCAPTION("Fax No."), TRUE);
                intExcelColNo += 1;
                EnterCell(1, intExcelColNo, recContact.FIELDCAPTION("Fax No. 2"), TRUE);
                intExcelColNo += 1;
                EnterCell(1, intExcelColNo, recContact.FIELDCAPTION("Post Code"), TRUE);
                intExcelColNo += 1;
                EnterCell(1, intExcelColNo, recContact.FIELDCAPTION(City), TRUE);
                intExcelColNo += 1;
                EnterCell(1, intExcelColNo, recContact.FIELDCAPTION("Date of Birth"), TRUE);
                intExcelColNo += 1;
                EnterCell(1, intExcelColNo, recContact.FIELDCAPTION("Personal Data Status"), TRUE);
                intExcelColNo += 1;
                EnterCell(1, intExcelColNo, recContact.FIELDCAPTION("Personal Data Agreement Date"), TRUE);
                intExcelColNo += 1;
                EnterCell(1, intExcelColNo, recContact.FIELDCAPTION("Correspondence Type"), TRUE);
                intExcelColNo += 1;
                EnterCell(1, intExcelColNo, recContact.FIELDCAPTION("Creation Date"), TRUE);
                intExcelColNo += 1;
                //EnterCell(1, intExcelColNo, FIELDCAPTION("Credit Memo No."), TRUE); intExcelColNo += 1;

                window.OPEN('處理資料(Step 5/6)  #1########## /  #2##########');
                window.UPDATE(1, 0);
                window.UPDATE(2, COUNT);
                intCount := 0;
                //--TWN.01.19
            end;
        }
        dataitem("<Sales Cr.Memo Line Sheet>"; Integer)
        {
            DataItemTableView = SORTING(Number);

            trigger OnAfterGetRecord()
            begin
                //++TWN.01.19
                tmpSalesCrMemInvLine.NEXT;
                intExcelRowNo += 1;
                intExcelColNo := 0;

                intExcelColNo += 1;

                EnterCell(intExcelRowNo, intExcelColNo, tmpSalesCrMemInvLine."Document No.", FALSE);
                intExcelColNo += 1;
                EnterCell(intExcelRowNo, intExcelColNo, FORMAT(tmpSalesCrMemInvLine."Line No."), FALSE);
                intExcelColNo += 1;
                //MESSAGE('%1',tmpSalesCrMemInvLine."Line No.");
                EnterCell(intExcelRowNo, intExcelColNo, FORMAT(tmpSalesCrMemInvLine.Type), FALSE);
                intExcelColNo += 1;
                EnterCell(intExcelRowNo, intExcelColNo, tmpSalesCrMemInvLine."No.", FALSE);
                intExcelColNo += 1;
                EnterCell(intExcelRowNo, intExcelColNo, tmpSalesCrMemInvLine.Description, FALSE);
                intExcelColNo += 1;
                EnterCell(intExcelRowNo, intExcelColNo, tmpSalesCrMemInvLine."Description 2", FALSE);
                intExcelColNo += 1;
                EnterCell(intExcelRowNo, intExcelColNo, FORMAT(tmpSalesCrMemInvLine.Quantity), FALSE);
                intExcelColNo += 1;
                //EnterCell(intExcelRowNo, intExcelColNo, FORMAT(tmpSalesCrMemInvLine."Unit Price"), FALSE); intExcelColNo += 1;

                CLEAR(decTemp);
                IF tmpSalesCrMemInvLine.Quantity <> 0 THEN
                    decTemp := ROUND(tmpSalesCrMemInvLine."Line Amount" / tmpSalesCrMemInvLine.Quantity, 1.0);
                EnterCell(intExcelRowNo, intExcelColNo, FORMAT(decTemp), FALSE);
                intExcelColNo += 1;

                EnterCell(intExcelRowNo, intExcelColNo, FORMAT(tmpSalesCrMemInvLine."Line Amount"), FALSE);
                intExcelColNo += 1;
                EnterCell(intExcelRowNo, intExcelColNo, FORMAT(tmpSalesCrMemInvLine."Vehicle No."), FALSE);
                intExcelColNo += 1;
                EnterCell(intExcelRowNo, intExcelColNo, FORMAT(tmpSalesCrMemInvLine."Licence-Plate No. Short"), FALSE);
                intExcelColNo += 1;

                CLEAR(recContact);
                IF recContact.GET(tmpSalesCrMemInvLine."Sell-to Contact No.") THEN;
                EnterCell(intExcelRowNo, intExcelColNo, FORMAT(tmpSalesCrMemInvLine."Sell-to Contact No."), FALSE);
                intExcelColNo += 1;

                EnterCell(intExcelRowNo, intExcelColNo, recContact.Name, FALSE);
                intExcelColNo += 1;
                EnterCell(intExcelRowNo, intExcelColNo, recContact."Name 2", FALSE);
                intExcelColNo += 1;
                EnterCell(intExcelRowNo, intExcelColNo, tmpSalesCrMemInvLine."Responsibility Center", FALSE);
                intExcelColNo += 1;
                EnterCell(intExcelRowNo, intExcelColNo, recContact."Phone No.", FALSE);
                intExcelColNo += 1;
                EnterCell(intExcelRowNo, intExcelColNo, recContact."Mobile Phone No.", FALSE);
                intExcelColNo += 1;
                EnterCell(intExcelRowNo, intExcelColNo, recContact."Mobile Phone No. 2", FALSE);
                intExcelColNo += 1;
                EnterCell(intExcelRowNo, intExcelColNo, recContact."Fax No.", FALSE);
                intExcelColNo += 1;
                EnterCell(intExcelRowNo, intExcelColNo, recContact."Fax No. 2", FALSE);
                intExcelColNo += 1;
                EnterCell(intExcelRowNo, intExcelColNo, recContact."Post Code", FALSE);
                intExcelColNo += 1;
                EnterCell(intExcelRowNo, intExcelColNo, recContact.City, FALSE);
                intExcelColNo += 1;
                EnterCell(intExcelRowNo, intExcelColNo, FORMAT(recContact."Date of Birth"), FALSE);
                intExcelColNo += 1;
                EnterCell(intExcelRowNo, intExcelColNo, FORMAT(recContact."Personal Data Status"), FALSE);
                intExcelColNo += 1;
                EnterCell(intExcelRowNo, intExcelColNo, FORMAT(recContact."Personal Data Agreement Date"), FALSE);
                intExcelColNo += 1;
                EnterCell(intExcelRowNo, intExcelColNo, FORMAT(recContact."Correspondence Type"), FALSE);
                intExcelColNo += 1;
                EnterCell(intExcelRowNo, intExcelColNo, FORMAT(recContact."Creation Date"), FALSE);
                intExcelColNo += 1;
                EnterCell(intExcelRowNo, intExcelColNo, '''' + FORMAT(tmpSalesCrMemInvLine."Fitter 1"), FALSE);
                intExcelColNo += 1;
                IF tmpSalesCrMemInvLine."Fitter 1" <> '' THEN
                    recSalesperson.GET(tmpSalesCrMemInvLine."Fitter 1");
                EnterCell(intExcelRowNo, intExcelColNo, recSalesperson.Name, FALSE);
                intExcelColNo += 1;

                //window.OPEN('處理資料(Step 6/6)  #1########## /  #2##########');
                window.UPDATE(1, intCount);
                intCount += 1;
                //--TWN.01.19
            end;

            trigger OnPostDataItem()
            begin
                TmpExcelBuffer.OnlyCreateBook('Sales Cr Memo Line+Contact', '', COMPANYNAME, USERID, TRUE);
                window.CLOSE;
            end;

            trigger OnPreDataItem()
            begin
                //Document No.,Line No.
                //tmpSalesCrMemInvLine.SETCURRENTKEY("Document No.","Line No.");
                tmpSalesCrMemInvLine.RESET;
                SETRANGE(Number, 1, tmpSalesCrMemInvLine.COUNT);

                intExcelRowNo := 1;
                intExcelColNo := 0;

                TmpExcelBuffer.DELETEALL;
                COMMIT;

                intExcelColNo += 1;
                EnterCell(1, intExcelColNo, "Sales Cr.Memo Line".FIELDCAPTION("Document No."), TRUE);
                intExcelColNo += 1;
                EnterCell(1, intExcelColNo, "Sales Cr.Memo Line".FIELDCAPTION("Line No."), TRUE);
                intExcelColNo += 1;
                EnterCell(1, intExcelColNo, "Sales Cr.Memo Line".FIELDCAPTION(Type), TRUE);
                intExcelColNo += 1;
                EnterCell(1, intExcelColNo, "Sales Cr.Memo Line".FIELDCAPTION("No."), TRUE);
                intExcelColNo += 1;
                EnterCell(1, intExcelColNo, "Sales Cr.Memo Line".FIELDCAPTION(Description), TRUE);
                intExcelColNo += 1;
                EnterCell(1, intExcelColNo, "Sales Cr.Memo Line".FIELDCAPTION("Description 2"), TRUE);
                intExcelColNo += 1;
                EnterCell(1, intExcelColNo, "Sales Cr.Memo Line".FIELDCAPTION(Quantity), TRUE);
                intExcelColNo += 1;
                //EnterCell(1, intExcelColNo, "Sales Cr.Memo Line".FIELDCAPTION("Unit Price"), TRUE); intExcelColNo += 1;
                //EnterCell(1, intExcelColNo, "Sales Cr.Memo Line".FIELDCAPTION("Line Amount"), TRUE); intExcelColNo += 1;
                EnterCell(1, intExcelColNo, UnitPriceCaption, TRUE);
                intExcelColNo += 1;
                EnterCell(1, intExcelColNo, LineAmountCaption, TRUE);
                intExcelColNo += 1;
                EnterCell(1, intExcelColNo, "Sales Cr.Memo Line".FIELDCAPTION("Vehicle No."), TRUE);
                intExcelColNo += 1;
                EnterCell(1, intExcelColNo, "Sales Cr.Memo Line".FIELDCAPTION("Licence-Plate No. Short"), TRUE);
                intExcelColNo += 1;
                EnterCell(1, intExcelColNo, "Sales Cr.Memo Line".FIELDCAPTION("Sell-to Contact No."), TRUE);
                intExcelColNo += 1;
                EnterCell(1, intExcelColNo, recContact.FIELDCAPTION(Name), TRUE);
                intExcelColNo += 1;
                EnterCell(1, intExcelColNo, recContact.FIELDCAPTION("Name 2"), TRUE);
                intExcelColNo += 1;
                EnterCell(1, intExcelColNo, "Sales Cr.Memo Line".FIELDCAPTION("Responsibility Center"), TRUE);
                intExcelColNo += 1;
                EnterCell(1, intExcelColNo, recContact.FIELDCAPTION("Phone No."), TRUE);
                intExcelColNo += 1;
                EnterCell(1, intExcelColNo, recContact.FIELDCAPTION("Mobile Phone No."), TRUE);
                intExcelColNo += 1;
                EnterCell(1, intExcelColNo, recContact.FIELDCAPTION("Mobile Phone No. 2"), TRUE);
                intExcelColNo += 1;
                EnterCell(1, intExcelColNo, recContact.FIELDCAPTION("Fax No."), TRUE);
                intExcelColNo += 1;
                EnterCell(1, intExcelColNo, recContact.FIELDCAPTION("Fax No. 2"), TRUE);
                intExcelColNo += 1;
                EnterCell(1, intExcelColNo, recContact.FIELDCAPTION("Post Code"), TRUE);
                intExcelColNo += 1;
                EnterCell(1, intExcelColNo, recContact.FIELDCAPTION(City), TRUE);
                intExcelColNo += 1;
                EnterCell(1, intExcelColNo, recContact.FIELDCAPTION("Date of Birth"), TRUE);
                intExcelColNo += 1;
                EnterCell(1, intExcelColNo, recContact.FIELDCAPTION("Personal Data Status"), TRUE);
                intExcelColNo += 1;
                EnterCell(1, intExcelColNo, recContact.FIELDCAPTION("Personal Data Agreement Date"), TRUE);
                intExcelColNo += 1;
                EnterCell(1, intExcelColNo, recContact.FIELDCAPTION("Correspondence Type"), TRUE);
                intExcelColNo += 1;
                EnterCell(1, intExcelColNo, recContact.FIELDCAPTION("Creation Date"), TRUE);
                intExcelColNo += 1;
                EnterCell(1, intExcelColNo, "Sales Cr.Memo Line".FIELDCAPTION("Fitter 1"), TRUE);
                intExcelColNo += 1;
                EnterCell(1, intExcelColNo, recSalesperson.FIELDCAPTION(Name), TRUE);
                intExcelColNo += 1;

                window.OPEN('處理資料(Step 6/6)  #1########## /  #2##########');
                window.UPDATE(1, 0);
                window.UPDATE(2, tmpSalesCrMemInvLine.COUNT);
                intCount := 0;
                CLEAR(tmpSalesCrMemInvLine);
                //--TWN.01.19
            end;
        }
    }

    requestpage
    {
        Caption = 'Contact';

        layout
        {
            area(content)
            {
                field(cdeCampaign; cdeCampaign)
                {
                    Caption = 'Campaign No.';
                    TableRelation = Campaign;
                }
                field(booALLCampaign; booALLCampaign)
                {
                    Caption = 'All Campaign No.';
                }
                field(cdeProfile; cdeProfile)
                {
                    Caption = 'Profile Questionnaire Code';
                    TableRelation = "Profile Questionnaire Header";
                }
                group("資料檔調查表代碼")
                {
                    Caption = 'Personal Data Status';
                    field(booNone; booNone)
                    {
                        Caption = 'None';
                    }
                    field(booYes; booYes)
                    {
                        Caption = 'Yes';
                    }
                    field(booNo; booNo)
                    {
                        Caption = 'No';
                    }
                    field(booNA; booNA)
                    {
                        Caption = 'N/A';
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

    trigger OnInitReport()
    begin
        //TWN.01.19 RGS_TWN-521.BH++
        booNone := TRUE;
        booYes := TRUE;
        booNo := TRUE;
        booNA := TRUE;
        //TWN.01.19 RGS_TWN-521.BH--
    end;

    trigger OnPostReport()
    begin
        TmpExcelBuffer.OnlyOpenExcel;
        TmpExcelBuffer.GiveUserControl;
    end;

    trigger OnPreReport()
    begin
        IF "Sales Invoice Header".GETFILTER("Posting Date") = '' THEN
            ERROR('Please set the Filter: %1', "Sales Invoice Header".FIELDCAPTION("Posting Date"));
        //++TWN.01.14
        /*
        IF (cdeCampaign = '') OR (cdeProfile = '') THEN
           ERROR('Please set the Campaign No. and Profile Questionnaire Code');
        */
        IF (cdeProfile = '') THEN
            ERROR('Please set the Profile Questionnaire Code');
        //--TWN.01.14

        //TWN.01.19.BH++
        IF "Sales Invoice Header".GETFILTER("Responsibility Center") <> '' THEN
            ResponsibilityCenter := "Sales Invoice Header".GETFILTER("Responsibility Center");

        IF "Sales Invoice Header".GETFILTER("Posting Date") <> '' THEN
            PostingDate := "Sales Invoice Header".GETFILTER("Posting Date");

        IF "Sales Invoice Header".GETFILTER("Sell-to Customer No.") <> '' THEN
            "Sell-toCustomerNo" := "Sales Invoice Header".GETFILTER("Sell-to Customer No.");

        IF "Sales Invoice Header".GETFILTER("Bill-to Customer No.") <> '' THEN
            "Bill-toCustomerNo" := "Sales Invoice Header".GETFILTER("Bill-to Customer No.");

        IF "Sales Invoice Header".GETFILTER("Sell-to Contact No.") <> '' THEN
            "Sell-toContactNo" := "Sales Invoice Header".GETFILTER("Sell-to Contact No.");

        IF "Sales Invoice Header".GETFILTER("Bill-to Contact No.") <> '' THEN
            "Bill-toContactNo" := "Sales Invoice Header".GETFILTER("Bill-to Contact No.");

        IF "Sales Invoice Header".GETFILTER("Sales Invoice Header"."Vehicle No.") <> '' THEN
            VehicleNo := "Sales Invoice Header".GETFILTER("Sales Invoice Header"."Vehicle No.");

        IF "Sales Invoice Header".GETFILTER("Sales Invoice Header"."Licence-Plate No.") <> '' THEN
            "License-PlateNo" := "Sales Invoice Header".GETFILTER("Sales Invoice Header"."Licence-Plate No.");

        IF "Sales Invoice Header".GETFILTER("Sales Invoice Header"."Campaign No.") <> '' THEN
            CampaignNo := "Sales Invoice Header".GETFILTER("Sales Invoice Header"."Campaign No.");
        //TWN.01.19.BH--


        CLEAR(recProfile);
        CLEAR(recProfileLine);
        recProfileLine.SETRANGE("Profile Questionnaire Code", cdeProfile);
        IF recProfileLine.FIND('-') THEN;

    end;

    var
        recItem: Record Item;
        TmpExcelBuffer: Record "Excel Buffer" temporary;
        recContact: Record Contact;
        recVehicle: Record Vehicle;
        intExcelRowNo: Integer;
        window: Dialog;
        intCount: Integer;
        cdeCampaign: Code[20];
        cdeProfile: Code[20];
        tmpSalesInvLine: Record "Sales Invoice Line" temporary;
        recSalesInvLine: Record "Sales Invoice Line";
        decTemp: Decimal;
        intExcelColNo: Integer;
        tmpContact: Record Contact temporary;
        recProfile: Record "Profile Questionnaire Header";
        recProfileLine: Record "Profile Questionnaire Line";
        tmpProfileLine: Record "Profile Questionnaire Line" temporary;
        recAnswer: Record "Contact Profile Answer";
        booNone: Boolean;
        booYes: Boolean;
        booNo: Boolean;
        booNA: Boolean;
        booALLCampaign: Boolean;
        recSaleCrMemoHeader: Record "Sales Cr.Memo Header";
        recSaleCrMemoLine: Record "Sales Cr.Memo Line";
        ResponsibilityCenter: Code[1024];
        PostingDate: Text[1024];
        "Sell-toCustomerNo": Code[1024];
        "Bill-toCustomerNo": Code[1024];
        "Sell-toContactNo": Code[1024];
        "Bill-toContactNo": Code[1024];
        VehicleNo: Code[1024];
        "License-PlateNo": Code[1024];
        CampaignNo: Code[1024];
        booAllowShow: Boolean;
        tmpSalesCrMemInvLine: Record "Sales Cr.Memo Line" temporary;
        recSalesperson: Record "Salesperson/Purchaser";
        UnitPriceCaption: Label 'Unit Price';
        LineAmountCaption: Label 'Line Amount';

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

