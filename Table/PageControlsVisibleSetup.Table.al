table 1044882 "Page Controls Visible Setup"
{
    // +----------------------------------------------+
    // | Copyright (c) incadea China                  |
    // +----------------------------------------------+
    // TFS          ID             WHO    DATE        DESCRIPTION
    // 121390     MARS_TWN_7545  GG     2020-02-27  New object to control page fields visible or not

    Caption = 'Page Controls Visible Setup';

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';
        }
        field(104444301; P1044443_FieldNo; Boolean)
        {
            Caption = 'P1044443_FieldNo';
        }
        field(104444302; P1044443_FieldDescription; Boolean)
        {
            Caption = 'P1044443_FieldDescription';
        }
    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    [Scope('OnPrem')]
    procedure GetControlSetup(PageObjectIDP: Text; ControlIndexP: Integer): Boolean
    var
        PageControlsVisiableSetupL: Record "Page Controls Visible Setup";
        FieldL: Record Field;
        RecordRefL: RecordRef;
        FieldRefL: FieldRef;
        PageIDL: Integer;
    begin
        IF NOT PageControlsVisiableSetupL.GET THEN
            EXIT(FALSE);
        IF ControlIndexP >= 100 THEN
            EXIT(FALSE);
        PageIDL := GetIDByPageNumber(PageObjectIDP);
        IF (PageIDL = 0) THEN
            EXIT(FALSE);
        FieldL.RESET;
        FieldL.SETRANGE(TableNo, DATABASE::"Page Controls Visible Setup");
        FieldL.SETRANGE(Type, FieldL.Type::Boolean);
        FieldL.SETRANGE(Enabled, TRUE);
        FieldL.SETRANGE(Class, FieldL.Class::Normal);
        FieldL.SETRANGE("No.", PageIDL * 100 + ControlIndexP);
        IF NOT FieldL.FINDFIRST THEN
            EXIT(FALSE);

        CLEAR(RecordRefL);
        CLEAR(FieldRefL);
        RecordRefL.GETTABLE(PageControlsVisiableSetupL);
        FieldRefL := RecordRefL.FIELD(FieldL."No.");
        EXIT(FieldRefL.VALUE);
    end;

    [Scope('OnPrem')]
    procedure GetIDByPageNumber(PageObjectIDP: Text) PageIDR: Integer
    var
        NewPageNumberL: Text;
        IL: Integer;
    begin
        NewPageNumberL := '';
        FOR IL := 1 TO STRLEN(PageObjectIDP) DO BEGIN
            IF (COPYSTR(PageObjectIDP, IL, 1) IN ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9']) THEN
                NewPageNumberL := NewPageNumberL + COPYSTR(PageObjectIDP, IL, 1);
        END;
        IF NewPageNumberL = '' THEN
            NewPageNumberL := '0';

        EVALUATE(PageIDR, NewPageNumberL);
    end;

    [Scope('OnPrem')]
    procedure EnableAllControl()
    begin
        SetupAllControl(TRUE);
    end;

    [Scope('OnPrem')]
    procedure UnableAllControl()
    begin
        SetupAllControl(FALSE);
    end;

    local procedure SetupAllControl(EnableAllControlP: Boolean)
    var
        PageControlsVisiableSetupL: Record "Page Controls Visible Setup";
        FieldL: Record Field;
        RecordRefL: RecordRef;
        FieldRefL: FieldRef;
    begin
        IF NOT PageControlsVisiableSetupL.GET THEN
            EXIT;

        RecordRefL.GETTABLE(PageControlsVisiableSetupL);
        FieldL.RESET;
        FieldL.SETRANGE(TableNo, DATABASE::"Page Controls Visible Setup");
        FieldL.SETRANGE(Type, FieldL.Type::Boolean);
        FieldL.SETRANGE(Enabled, TRUE);
        FieldL.SETRANGE(Class, FieldL.Class::Normal);
        IF FieldL.FINDFIRST THEN
            REPEAT
                FieldRefL := RecordRefL.FIELD(FieldL."No.");
                FieldRefL.VALUE := EnableAllControlP;
                RecordRefL.MODIFY;
            UNTIL FieldL.NEXT = 0;
    end;
}

