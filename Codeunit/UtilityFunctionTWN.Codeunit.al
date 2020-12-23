codeunit 50004 "Utility Function TWN"
{
    // +--------------------------------------------------------------+
    // | @ 2013 Tectura Taiwan Limited                                |
    // +--------------------------------------------------------------+
    // | PURPOSE: MARS_TWN                                            |
    // |                                                              |
    // | REMARK :                                                     |
    // +--------------------------------------------------------------+
    // 
    // VERSION   ID          WHO    DATE        DESCRIPTION
    // TWN.01.07 RGS_TWN-395 LL     2014-06-05  Initial Release, add SplitString trigger
    // TWN.01.24 RGS_TWN-528 BH     2015-06-05  Add function BlockCotact to check contact's Block.


    trigger OnRun()
    begin
    end;

    [Scope('OnPrem')]
    procedure SplitString(InnerText: Text[250]; var CommentLine: Record "Comment Line"; LengthFactor: Integer): Integer
    var
        LineIndex: Decimal;
        Index: Integer;
        SingleChar: Char;
        LineNo: Integer;
    begin
        Clear(CommentLine);
        CommentLine.DeleteAll;

        Clear(LineNo);
        Clear(Index);
        if (StrLen(InnerText) > 0) then begin
            Clear(LineIndex);
            repeat
                Index := Index + 1;
                SingleChar := InnerText[Index];

                if (SingleChar >= 128) then begin
                    Index := Index + 1;
                    LineIndex := LineIndex + 2;
                end
                else begin
                    case SingleChar of
                        'W':
                            LineIndex := LineIndex + 1.75;
                        'M':
                            LineIndex := LineIndex + 1.67;
                        'm':
                            LineIndex := LineIndex + 1.57;
                        'w':
                            LineIndex := LineIndex + 1.43;
                        'N', 'O', 'Q', 'U':
                            LineIndex := LineIndex + 1.33;
                        'A', 'B', 'C', 'R', 'V':
                            LineIndex := LineIndex + 1.125;
                        'D', 'G', 'H':
                            LineIndex := LineIndex + 1.22;
                        'o':
                            LineIndex := LineIndex + 1.06;
                        'F', 'L', 'v', 'y':
                            LineIndex := LineIndex + 0.9;
                        'S', 'Z', 'c', 'g', 'h', 'k', 'n', 'x':
                            LineIndex := LineIndex + 0.875;
                        's':
                            LineIndex := LineIndex + 0.8;
                        'z':
                            LineIndex := LineIndex + 0.78;
                        'f', 'r', 't':
                            LineIndex := LineIndex + 0.67;
                        'I', 'J':
                            LineIndex := LineIndex + 0.5;
                        'i', 'j', 'l':
                            LineIndex := LineIndex + 0.45;
                        else
                            LineIndex := LineIndex + 1;
                    end
                end;

                if (LineIndex >= LengthFactor) then begin
                    LineNo := LineNo + 1;
                    Clear(CommentLine);
                    CommentLine.Init;
                    CommentLine."Line No." := LineNo;
                    CommentLine.Comment := CopyStr(InnerText, 1, Index);
                    CommentLine.Insert;

                    InnerText := CopyStr(InnerText, Index + 1);
                    Clear(Index);
                    Clear(LineIndex)
                end;
            until (Index = StrLen(InnerText));

            if (Index <> 0) then begin
                LineNo := LineNo + 1;
                Clear(CommentLine);
                CommentLine.Init;
                CommentLine."Line No." := LineNo;
                CommentLine.Comment := CopyStr(InnerText, 1, Index);
                CommentLine.Insert;
            end;
        end else begin
            exit(1);
        end;

        exit(CommentLine.Count);
    end;

    [Scope('OnPrem')]
    procedure ChkBlockedContact(ContactNo: Code[20]) Blocked: Boolean
    var
        recContactL: Record Contact;
    begin
        Clear(recContactL);
        Blocked := false;
        if ContactNo <> '' then
            if recContactL.Get(ContactNo) then
                Blocked := recContactL.Blocked;
    end;

    [Scope('OnPrem')]
    procedure ChkBlockedVehicle(VehicleNo: Code[20]) Blocked: Boolean
    var
        recVehicleL: Record Vehicle;
        recContactL: Record Contact;
    begin
        Clear(recVehicleL);
        Clear(recContactL);
        Blocked := false;

        if VehicleNo <> '' then
            if recVehicleL.Get(VehicleNo) then
                if recVehicleL."Contact No." <> '' then
                    if recContactL.Get(recVehicleL."Contact No.") then
                        Blocked := recContactL.Blocked;
    end;

    [Scope('OnPrem')]
    procedure BlockedVehicleFromContact(ContactNo: Code[20])
    var
        recVehicleL: Record Vehicle;
        recContactL: Record Contact;
    begin
        /*
        CLEAR(recVehicleL);
        CLEAR(recContactL);
        IF ContactNo <> '' THEN
          IF recContactL.GET(ContactNo) THEN
            IF  recContactL.Blocked = TRUE THEN
            BEGIN
              recVehicleL.SETCURRENTKEY("Contact No.","Customer No.");
              recVehicleL.SETRANGE("Contact No.",ContactNo);
              IF recVehicleL.FIND('-') THEN
                REPEAT
                  recVehicleL.Blocked := TRUE;
                  recVehicleL.MODIFY(TRUE);
                UNTIL recVehicleL.NEXT = 0;
            END;
         */

    end;
}

