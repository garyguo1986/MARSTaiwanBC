table 50009 "Translation Data"
{

    fields
    {
        field(1; "Primary Key"; Code[250])
        {
            Caption = 'Primary Key';
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(3; "Language Code"; Code[20])
        {
            Caption = 'Language Code';
        }
        field(21; "Object Type"; Option)
        {
            Caption = 'Object Type';
            OptionCaption = ' ,Table,Page,Report,Codeunit,Query,XMLPort,MenuSuite';
            OptionMembers = " ","Table","Page","Report","Codeunit","Query","XMLPort",MenuSuite;
        }
        field(22; "Object ID"; Integer)
        {
            Caption = 'Object ID';
        }
        field(23; "Object Name"; Text[100])
        {
            Caption = 'Object Name';
        }
        field(50; "Inner Text 1"; Text[250])
        {
            Caption = 'Inner Text 1';
        }
        field(51; "Inner Text 2"; Text[250])
        {
            Caption = 'Inner Text 2';
        }
        field(101; "Text 1"; Text[250])
        {
            Caption = 'Text 1';
        }
        field(102; "Text 2"; Text[250])
        {
            Caption = 'Text 2';
        }
        field(103; "Text 3"; Text[250])
        {
            Caption = 'Text 3';
        }
        field(104; "Text 4"; Text[250])
        {
            Caption = 'Text 4';
        }
        field(105; "Text 5"; Text[250])
        {
            Caption = 'Text 5';
        }
        field(201; "Modify Flag"; Boolean)
        {
            Caption = 'Modify Flag';
        }
        field(202; "Merge Flag"; Boolean)
        {
            Caption = 'Merge Flag';
        }
        field(203; Flag; Boolean)
        {
            Caption = 'Flag';
        }
    }

    keys
    {
        key(Key1; "Primary Key", "Line No.")
        {
            Clustered = true;
        }
        key(Key2; "Object Type", "Object ID")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnModify()
    begin
        "Modify Flag" := TRUE;
    end;

    [Scope('OnPrem')]
    procedure InsertData(var TempDataP: Record "Translation Data" temporary; LanguagePostionP: Integer)
    begin
        INIT;
        Rec := TempDataP;
        CASE LanguagePostionP OF
            0:
                "Text 1" := TempDataP."Text 1";
            1:
                "Text 1" := TempDataP."Text 1";
            2:
                "Text 2" := TempDataP."Text 1";
            3:
                "Text 3" := TempDataP."Text 1";
            4:
                "Text 4" := TempDataP."Text 1";
            5:
                "Text 5" := TempDataP."Text 1";
        END;
        INSERT;
    end;

    [Scope('OnPrem')]
    procedure CreateTempDate(TextP: Text; LanguageCodeP: Code[20]; var TempDataP: Record "Translation Data" temporary)
    var
        ObjectL: Record Object;
        LanguageCodePositionL: Integer;
        LanguagePositionL: Integer;
        TotalLengthL: Integer;
        TranslationLinesL: Integer;
        IL: Integer;
        ObjectTypeL: Integer;
        ObjectIDL: Integer;
        KeyCodeL: Code[250];
        InnerTextL: Text;
        TranslationTextL: Text;
        TranslationArrayL: array[20] of Text;
        ObjectInfoL: Text;
        ObjectNameL: Text;
    begin
        LanguageCodePositionL := STRPOS(TextP, LanguageCodeP);
        LanguagePositionL := LanguageCodePositionL + STRLEN(LanguageCodeP);
        TotalLengthL := STRLEN(TextP);

        KeyCodeL := COPYSTR(TextP, 1, LanguageCodePositionL - 1);
        TranslationTextL := COPYSTR(TextP, LanguagePositionL, TotalLengthL - LanguageCodePositionL);
        LanguagePositionL := STRPOS(TranslationTextL, ':');
        InnerTextL := COPYSTR(TranslationTextL, 1, LanguagePositionL);
        TranslationTextL := COPYSTR(TranslationTextL, LanguagePositionL + 1, STRLEN(TranslationTextL) - LanguagePositionL + 1);

        ObjectInfoL := COPYSTR(KeyCodeL, 1, STRPOS(KeyCodeL, '-'));
        ExactObjectInfo(ObjectInfoL, ObjectTypeL, ObjectIDL);
        ObjectNameL := '';
        ObjectL.RESET;
        CASE ObjectTypeL OF
            1:
                ObjectL.SETRANGE(Type, ObjectL.Type::Table);
            2:
                ObjectL.SETRANGE(Type, ObjectL.Type::Page);
            3:
                ObjectL.SETRANGE(Type, ObjectL.Type::Report);
            4:
                ObjectL.SETRANGE(Type, ObjectL.Type::Codeunit);
            5:
                ObjectL.SETRANGE(Type, ObjectL.Type::Query);
            6:
                ObjectL.SETRANGE(Type, ObjectL.Type::XMLport);
            7:
                ObjectL.SETRANGE(Type, ObjectL.Type::MenuSuite);
        END;
        ObjectL.SETRANGE(ObjectL.ID, ObjectIDL);
        IF ObjectL.FINDFIRST THEN
            ObjectNameL := ObjectL.Name;

        TranslationLinesL := GetTextArray(TranslationTextL, TranslationArrayL);
        FOR IL := 1 TO TranslationLinesL DO BEGIN
            TempDataP.INIT;
            TempDataP."Primary Key" := KeyCodeL;
            TempDataP."Language Code" := LanguageCodeP;
            TempDataP."Line No." := IL;
            TempDataP."Object Type" := ObjectTypeL;
            TempDataP."Object ID" := ObjectIDL;
            TempDataP."Object Name" := ObjectNameL;
            TempDataP."Inner Text 1" := InnerTextL;
            TempDataP."Text 1" := TranslationArrayL[IL];
            TempDataP.INSERT;
        END;
        //MESSAGE(FORMAT(LanguageCodePositionL)+'-'+FORMAT(LanguagePositionL));
        //MESSAGE(COPYSTR(TextP,1,LanguageCodePositionL)+'--'+LanguageCodeP+'--'+;
    end;

    [Scope('OnPrem')]
    procedure ExactObjectInfo(ObjectInfoP: Text; var ObjectTypeP: Integer; var ObjectIDP: Integer)
    var
        ObjectTypeTextL: Text;
        ObjectIDTextL: Text;
    begin
        IF ObjectInfoP <= '' THEN
            EXIT;

        ObjectTypeTextL := COPYSTR(ObjectInfoP, 1, 1);
        ObjectIDTextL := COPYSTR(ObjectInfoP, 2, STRLEN(ObjectInfoP) - 2);
        //MESSAGE(ObjectTypeTextL+'-'+ObjectIDTextL);
        // ,Table,Page,Report,Codeunit,Query,XMLPort,MenuSuite
        CASE ObjectTypeTextL OF
            'T':
                ObjectTypeP := 1;
            'N':
                ObjectTypeP := 2;
            'R':
                ObjectTypeP := 3;
            'C':
                ObjectTypeP := 4;
            'Q':
                ObjectTypeP := 5;
            'X':
                ObjectTypeP := 6;
            'M':
                ObjectTypeP := 7;
        END;
        EVALUATE(ObjectIDP, ObjectIDTextL)
    end;

    [Scope('OnPrem')]
    procedure GetTextArray(TextP: Text; var TextArrayP: array[20] of Text): Integer
    var
        IL: Integer;
        TotalArrayL: Integer;
        ArrayLengthL: Integer;
    begin
        ArrayLengthL := 250;
        TotalArrayL := ROUND(STRLEN(TextP) / ArrayLengthL, 1, '>');
        IF TotalArrayL > ARRAYLEN(TextArrayP) THEN
            TotalArrayL := ARRAYLEN(TextArrayP);
        FOR IL := 1 TO TotalArrayL DO BEGIN
            TextArrayP[IL] := COPYSTR(TextP, (IL - 1) * ArrayLengthL + 1, ArrayLengthL);
        END;

        EXIT(TotalArrayL);
    end;

    [Scope('OnPrem')]
    procedure ContainLanguageCode(TextP: Text; var LanguageCodeP: Code[50]): Integer
    begin
        IF STRPOS(TextP, 'A1033') > 0 THEN BEGIN
            LanguageCodeP := 'A1033';
            EXIT(1);
        END;
        IF STRPOS(TextP, 'A1028') > 0 THEN BEGIN
            LanguageCodeP := 'A1028';
            EXIT(2);
        END;

        EXIT(0);
    end;
}

