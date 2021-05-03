pageextension 1073882 "Extended Text Lines Ext" extends "Extended Text Lines"
{
    // +--------------------------------------------------------------+
    // | @ 2017 incadea Taiwan Limited                                |
    // +--------------------------------------------------------------+
    // | PURPOSE: MARS_TWN                                            |
    // |                                                              |
    // | REMARK :                                                     |
    // +--------------------------------------------------------------+
    // | TWN Customization                                            |
    // +--------------------------------------------------------------+

    // VERSION     ID          WHO    DATE        DESCRIPTION
    // TWN.01.01   RGS_TWN-414 AH     2017-04-21  add labels and textbox on bottom of page
    //                                            add code on OnInsertRecord, OnModifyRecord, OnDeleteRecord trigger, add UpdateCount trigger
    layout
    {
        addlast(content)
        {
            group("Control1000000006")
            {
                grid("Control1000000008")
                {
                    Enabled = false;
                    Editable = false;
                    GridLayout = Columns;
                    group("Control1000000009")
                    {
                        Enabled = false;
                        Editable = false;
                        field(RemindStr001G; RemindStr001G)
                        {
                            Enabled = false;
                            Editable = false;
                            ShowCaption = false;
                            //Title = true;
                            Style = Unfavorable;
                            StyleExpr = true;
                        }
                        field(RemindStr002G; STRSUBSTNO(RemindStr002G, TotalCharsG))
                        {
                            ShowCaption = false;
                            Style = Unfavorable;
                            StyleExpr = true;
                        }
                    }
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        //++Inc.TWN-414.AH
        CalcuTextLength(0);
        //--Inc.TWN-414.AH
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        //++Inc.TWN-414.AH
        CalcuTextLength(1);
        //--Inc.TWN-414.AH
    end;

    trigger OnModifyRecord(): Boolean
    begin
        //++Inc.TWN-414.AH
        CalcuTextLength(2);
        //--Inc.TWN-414.AH
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        //++Inc.TWN-414.AH
        CalcuTextLength(3);
        //--Inc.TWN-414.AH
    end;

    procedure CalcuTextLength(ActionP: Option "Get","New","Modify","Delete")
    begin
        //++Inc.TWN-414.AH
        //New,Modify,Delete         
        CLEAR(ExtTextLinesG);
        CLEAR(CountG);
        ExtTextLinesG.SETRANGE("Table Name", "Table Name");
        ExtTextLinesG.SETRANGE("No.", "No.");
        ExtTextLinesG.SETRANGE("Language Code", "Language Code");
        ExtTextLinesG.SETRANGE("Text No.", "Text No.");
        IF ExtTextLinesG.FIND('-') THEN BEGIN
            REPEAT
                CountG += SingleSTRLEN(ExtTextLinesG.Text);
            UNTIL ExtTextLinesG.NEXT = 0;
            CountG += ExtTextLinesG.COUNT - 1;
        END;

        CASE ActionP OF
            ActionP::New:
                BEGIN
                    CountG := CountG + SingleSTRLEN(Text);
                    CountG := CountG + ExtTextLinesG.COUNT; //process space
                END;

            ActionP::Modify:
                BEGIN
                    CountG := CountG - SingleSTRLEN(xRec.Text) + SingleSTRLEN(Rec.Text);
                    CountG := CountG + ExtTextLinesG.COUNT - 1; //process space
                END;

            ActionP::Delete:
                BEGIN
                    CountG := CountG - SingleSTRLEN(Text);
                    CountG := CountG - (ExtTextLinesG.COUNT - 2); //process space
                END;
        END;

        TotalCharsG := CountG;
        IF ActionP <> 0 THEN
            IF CountG > 67 THEN
                MESSAGE(RemindStr003G);

        //--Inc.TWN-414.AH
    end;

    procedure SingleSTRLEN(txtInputP: Text[1024]): Integer
    var
        intLenL: Integer;
        intLoopIL: Integer;
        intMoreL: Integer;
    begin
        //++Inc.TWN-414.AH
        //all characters's length is 1.
        intLenL := 0;
        intMoreL := 0;
        FOR intLoopIL := 1 TO STRLEN(txtInputP) DO BEGIN
            intLenL += 1;
            //check double bytes
            //IF txtInputP[intLoopIL] >= 127 THEN intLoopIL += 1;

            //check "%6", %6 is equal length 7.
            IF txtInputP[intLoopIL] = 37 THEN //check "%"
                IF txtInputP[intLoopIL + 1] = 54 THEN //check "6"
                BEGIN
                    //intLoopIL += 1;
                    intMoreL += 5;
                END;
        END;
        intLenL += intMoreL;
        EXIT(intLenL);
        //--Inc.TWN-414.AH 
    end;

    var
        [InDataSet]
        TotalCharsG: Integer;
        ExtTextLinesG: Record "Extended Text Line";
        CountG: Integer;
        TextEditorMgmt: Codeunit "Text Editor Mgmt.";
        RemindStr001G: Label 'Note:  Max. no. of Chinese characters per line is 25';
        RemindStr002G: Label 'Total no. of Chinese characters in Extended Text: %1';
        RemindStr003G: Label 'The SMS is limited to 67 Chinese characters, and over 67 characters will be sent as another SMS!';
}
