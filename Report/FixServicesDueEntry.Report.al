report 50030 "Fix Services Due Entry"
{
    // +--------------------------------------------------------------+
    // | @ 2017 incadea Taiwan Limited                                |
    // +--------------------------------------------------------------+
    // | PURPOSE: MARS_TWN                                            |
    // |                                                              |
    // | REMARK :                                                     |
    // +--------------------------------------------------------------+
    // 
    // VERSION   ID          WHO    DATE        DESCRIPTION
    // RGS_TWN-558           NN     2017-05-23  INITIAL RELEASE
    DefaultLayout = RDLC;
    RDLCLayout = './Report/FixServicesDueEntry.rdlc';

    Caption = 'Fix Services Due Entry';

    dataset
    {
        dataitem("Service Due Entry"; "Service Due Entry")
        {
            DataItemTableView = SORTING("Entry No.");
            column(CompanyInfo_Name; CompanyInfo.Name)
            {
            }
            column(Fix_Services_Due_EntryCaption; Fix_Services_Due_EntryCaptionLbl)
            {
            }
            column(DateCaption; DateCaptionLbl)
            {
            }
            column(FORMAT_TODAY__0__4_; FORMAT(TODAY, 0, 4))
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(CurrReport_PAGENO; CurrReport.PAGENO)
            {
            }
            column(Filter_String_Caption; Filter_String_CaptionLbl)
            {
            }
            column(Filter_String; GETFILTERS)
            {
            }
            column(Posting_Date_____Next_Service_Due_Date_Caption; Posting_Date_____Next_Service_Due_Date_CaptionLbl)
            {
            }
            column(Entry_No_Caption; Entry_No_CaptionLbl)
            {
            }
            column(Entry_No; "Entry No.")
            {
            }
            column(arrEntryNo_1_; arrEntryNo[1])
            {
            }
            column(arrEntryNo_2_; arrEntryNo[2])
            {
            }
            column(arrEntryNo_3_; arrEntryNo[3])
            {
            }
            column(arrEntryNo_4_; arrEntryNo[4])
            {
            }
            column(arrEntryNo_5_; arrEntryNo[5])
            {
            }
            column(intColumnCount; intColumnCount)
            {
            }
            column(intMaxColumn; intMaxColumn)
            {
            }
            column(bolLastSection; bolLastSection)
            {
            }
            column(Total_Records_Modified_Caption; Total_Records_Modified_CaptionLbl)
            {
            }
            column(Total_Record_Modified; intModifiedCount)
            {
            }

            trigger OnAfterGetRecord()
            begin
                intRecCount += 1;
                IF intRecCount = COUNT THEN
                    bolLastSection := TRUE;

                IF intColumnCount = intMaxColumn THEN BEGIN
                    intColumnCount := 0;
                    CLEAR(arrEntryNo);
                END;

                IF "Posting Date" = "Next Service Due Date" THEN BEGIN
                    CLEAR("Next Service Due Date");
                    MODIFY;

                    intModifiedCount += 1;
                    intColumnCount += 1;
                    arrEntryNo[intColumnCount] := "Entry No.";
                END;
            end;

            trigger OnPreDataItem()
            begin
                intMaxColumn := 5;

                SETRANGE("SMS Entry No.", 0);
                SETRANGE("Services Type", '');
                SETRANGE("Service Type Description", '');
                SETRANGE("Service Description", '');
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
        CompanyInfo.GET;
    end;

    var
        CompanyInfo: Record "Company Information";
        arrEntryNo: array[5] of Integer;
        intModifiedCount: Integer;
        bolLastSection: Boolean;
        intColumnCount: Integer;
        intRecCount: Integer;
        intMaxColumn: Integer;
        Fix_Services_Due_EntryCaptionLbl: Label 'Fix Services Due Entry';
        CurrReport_PAGENOCaptionLbl: Label 'Page:';
        DateCaptionLbl: Label 'Date:';
        Entry_No_CaptionLbl: Label 'Entry No.';
        Filter_String_CaptionLbl: Label 'Filter String:';
        Posting_Date_____Next_Service_Due_Date_CaptionLbl: Label '"Posting Date" = "Next Service Due Date"';
        TO_BE_CONTINUED___CaptionLbl: Label '-- TO BE CONTINUED --';
        Total_Records_Modified_CaptionLbl: Label 'Total Records Modified:';
}

