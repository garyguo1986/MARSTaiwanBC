codeunit 1044883 "TW Update Item Tracking Code"
{
    trigger OnRun()
    begin
        CASE ActionOptionsG OF
            ActionOptionsG::GetBuffer:
                GetItemTrackingCodeBuffer(TempExcelBufferG, TempItemG);
            ActionOptionsG::Import:
                ImportItemTrackingCode(TempItemG);
            ActionOptionsG::GetTenantBuffer:
                GetTenantBufferToTable(TempExcelBufferG);
            ActionOptionsG::GetItemBuffer:
                GetItemTrackingCodeBufferToTable(TempExcelBufferG);
            ActionOptionsG::ImportBufferToItem:
                ImportItemTrackinBufferToItem(TempItemDOTEntryG);
        END;
    end;

    local procedure GetItemTrackingCodeBuffer(var ExcelBufferP: Record "Excel Buffer" temporary; var TempItemP: Record Item temporary)
    var
        RowLengthL: Integer;
        ColLengthL: Integer;
        RowCurL: Integer;
    begin
        IF TempItemP.ISTEMPORARY THEN BEGIN
            TempItemP.RESET;
            TempItemP.DELETEALL;
        END;

        ColLengthL := 2;
        ExcelBufferP.RESET;
        IF ExcelBufferP.FINDLAST THEN
            RowLengthL := ExcelBufferP."Row No.";

        FOR RowCurL := 1 TO RowLengthL DO BEGIN
            ExcelBufferP.RESET;
            ExcelBufferP.SETRANGE("Row No.", RowCurL);
            ExcelBufferP.SETRANGE("Column No.", 1, ColLengthL);
            IF ExcelBufferP.FINDFIRST THEN BEGIN
                TempItemP.INIT;
                REPEAT
                    IF ExcelBufferP."Column No." = 1 THEN
                        TempItemP."No." := ExcelBufferP."Cell Value as Text";
                    IF ExcelBufferP."Column No." = 2 THEN
                        TempItemP."Item Tracking Code" := ExcelBufferP."Cell Value as Text";
                UNTIL ExcelBufferP.NEXT = 0;
                TempItemP.INSERT;
                IF TempItemP."No." = '' THEN
                    TempItemP.DELETE;
            END;
        END;

    end;

    local procedure ImportItemTrackingCode(var TempItemP: Record Item temporary)
    var
        ItemL: Record Item;
    begin
        IF TempItemP.ISEMPTY THEN
            EXIT;

        ItemL.GET(TempItemP."No.");
        ItemL.VALIDATE("Item Tracking Code", TempItemP."Item Tracking Code");
        ItemL.MODIFY(TRUE);
    end;

    local procedure GetTenantBufferToTable(var ExcelBufferP: Record "Excel Buffer")
    var
        ItemDOTEntryL: Record "Item DOT Entry";
        RowLengthL: Integer;
        ColLengthL: Integer;
        RowCurL: Integer;
        NewTenant: Text[128];
        IsActiveL: Boolean;
    begin
        /*
        ItemDOTEntryL.RESET;
        ItemDOTEntryL.SETRANGE(Type, ItemDOTEntryL.Type::Tenant);
        ItemDOTEntryL.MODIFYALL(Active, FALSE);

        ColLengthL := 2;
        ExcelBufferP.RESET;
        IF ExcelBufferP.FINDLAST THEN
            RowLengthL := ExcelBufferP."Row No.";

        FOR RowCurL := 1 TO RowLengthL DO BEGIN
            NewTenant := '';
            IsActiveL := FALSE;
            ExcelBufferP.RESET;
            ExcelBufferP.SETRANGE("Row No.", RowCurL);
            ExcelBufferP.SETRANGE("Column No.", 1);
            IF ExcelBufferP.FINDFIRST THEN BEGIN
                NewTenant := ExcelBufferP."Cell Value as Text";
                ReplicationCompanyL.RESET;
                ReplicationCompanyL.SETRANGE("Tenant ID", NewTenant);
                ReplicationCompanyL.FINDFIRST;
                IF NOT ItemDOTEntryL.GET(ItemDOTEntryL.Type::Tenant, NewTenant, '', 0D) THEN BEGIN
                    ItemDOTEntryL.INIT;
                    ItemDOTEntryL.Type := ItemDOTEntryL.Type::Tenant;
                    ItemDOTEntryL.Tenant := NewTenant;
                    ItemDOTEntryL."Item No." := '';
                    ItemDOTEntryL."Upload Date" := 0D;
                    ItemDOTEntryL."Central Maintenance" := TRUE;
                    ItemDOTEntryL.INSERT(TRUE);
                END;
            END;
            ExcelBufferP.SETRANGE("Column No.", 2);
            IF ExcelBufferP.FINDFIRST THEN BEGIN
                IsActiveL := (ExcelBufferP."Cell Value as Text" = '1');
                IF (NOT IsActiveL) THEN
                    IsActiveL := (UPPERCASE(ExcelBufferP."Cell Value as Text") = 'YES');
                IF ItemDOTEntryL.GET(ItemDOTEntryL.Type::Tenant, NewTenant, '', 0D) THEN BEGIN
                    ItemDOTEntryL.VALIDATE(Active, IsActiveL);
                    ItemDOTEntryL.MODIFY(TRUE);
                END;
            END;
        END;
        */
    end;

    local procedure GetItemTrackingCodeBufferToTable(var ExcelBufferP: Record "Excel Buffer")
    var
        ItemL: Record Item;
        ItemDOTEntryL: Record "Item DOT Entry";
        RowLengthL: Integer;
        ColLengthL: Integer;
        RowCurL: Integer;
        ItemNoL: Code[20];
        ItemTrackingCodeL: Code[20];
    begin
        ColLengthL := 2;
        ExcelBufferP.RESET;
        IF ExcelBufferP.FINDLAST THEN
            RowLengthL := ExcelBufferP."Row No.";

        FOR RowCurL := 1 TO RowLengthL DO BEGIN
            ItemNoL := '';
            ItemTrackingCodeL := '';
            ExcelBufferP.RESET;
            ExcelBufferP.SETRANGE("Row No.", RowCurL);
            ExcelBufferP.SETRANGE("Column No.", 1, ColLengthL);
            IF ExcelBufferP.FINDFIRST THEN BEGIN
                REPEAT
                    IF ExcelBufferP."Column No." = 1 THEN BEGIN
                        ItemNoL := ExcelBufferP."Cell Value as Text";
                        ItemL.GET(ItemNoL);
                    END;
                    IF ExcelBufferP."Column No." = 2 THEN
                        ItemTrackingCodeL := ExcelBufferP."Cell Value as Text";
                UNTIL ExcelBufferP.NEXT = 0;
            END;

            IF (ItemNoL <> '') THEN BEGIN
                IF ItemDOTEntryL.GET(ItemDOTEntryL.Type::Item, '', ItemNoL, TODAY) THEN
                    ItemDOTEntryL.DELETE(TRUE);
                ItemDOTEntryL.INIT;
                ItemDOTEntryL.Type := ItemDOTEntryL.Type::Item;
                ItemDOTEntryL.Tenant := '';
                ItemDOTEntryL."Item No." := ItemNoL;
                ItemDOTEntryL."Item Tracking Code" := ItemTrackingCodeL;
                ItemDOTEntryL."Central Maintenance" := TRUE;
                ItemDOTEntryL.INSERT(TRUE);
            END;
        END;
    end;

    local procedure ImportItemTrackinBufferToItem(var TempItemDOTEntryP: Record "Item DOT Entry" temporary)
    var
        ItemL: Record Item;
    begin
        IF TempItemDOTEntryP.ISEMPTY THEN
            EXIT;

        ItemL.GET(TempItemDOTEntryP."Item No.");
        ItemL.VALIDATE("Item Tracking Code", TempItemDOTEntryP."Item Tracking Code");
        ItemL.MODIFY(TRUE);

    end;

    procedure SetAction(ActionOptionsP: Option " ","GetBuffer","Import","GetTenantBuffer","GetItemBuffer","ImportBufferToItem")
    begin
        ActionOptionsG := ActionOptionsP;
    end;

    procedure SetExcelBuffer(var TempExcelBufferP: Record "Excel Buffer" temporary)
    begin
        IF TempExcelBufferG.ISTEMPORARY THEN BEGIN
            TempExcelBufferG.RESET;
            TempExcelBufferG.DELETEALL;
        END;

        TempExcelBufferP.RESET;
        IF TempExcelBufferP.FINDFIRST THEN
            REPEAT
                TempExcelBufferG.INIT;
                TempExcelBufferG := TempExcelBufferP;
                TempExcelBufferG.INSERT;
            UNTIL TempExcelBufferP.NEXT = 0;
    end;

    procedure SetSingleItemBuffer(var TempItemP: Record Item temporary)
    begin
        IF NOT TempItemG.ISTEMPORARY THEN
            EXIT;

        TempItemG.RESET;
        TempItemG.DELETEALL;

        TempItemG.INIT;
        TempItemG := TempItemP;
        TempItemG.INSERT;
    end;

    procedure SetItemTrackingBuffer(var TempItemDOTEntryP: Record "Item DOT Entry" TEMPORARY)
    begin
        IF NOT TempItemDOTEntryG.ISTEMPORARY THEN
            EXIT;

        TempItemDOTEntryG.RESET;
        TempItemDOTEntryG.DELETEALL;

        TempItemDOTEntryG.INIT;
        TempItemDOTEntryG := TempItemDOTEntryP;
        TempItemDOTEntryG.INSERT;
    end;

    procedure GetItemBuffer(var TempItemP: Record Item temporary)
    begin
        IF NOT TempItemP.ISEMPTY THEN
            EXIT;

        TempItemP.RESET;
        TempItemP.DELETEALL;

        TempItemG.RESET;
        IF TempItemG.FINDFIRST THEN
            REPEAT
                TempItemP.INIT;
                TempItemP := TempItemG;
                TempItemP.INSERT;
            UNTIL TempItemG.NEXT = 0;
    end;

    var
        TempExcelBufferG: Record "Excel Buffer" temporary;
        TempItemG: Record Item temporary;
        TempItemDOTEntryG: Record "Item DOT Entry";
        ActionOptionsG: Option " ","GetBuffer","Import","GetTenantBuffer","GetItemBuffer","ImportBufferToItem";
}
