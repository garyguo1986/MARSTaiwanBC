codeunit 50011 "Fix Zone Data"
{
    Permissions = TableData 32 = rimd;

    trigger OnRun()
    begin
        FixZoneData();
        FixZoneData2();
        MESSAGE('Done');
    end;

    [Scope('OnPrem')]
    procedure FixZoneData()
    var
        ServiceCenterL: Record "Service Center";
        ItemL: Record Item;
        Item2L: Record Item;
        DefaultDimL: Record "Default Dimension";
        ItemLedgEntryL: Record "Item Ledger Entry";
        ItemLedgEntry2L: Record "Item Ledger Entry";
        TempDimSetEntryL: Record "Dimension Set Entry" temporary;
        DimValueL: Record "Dimension Value";
        GLSetupL: Record "General Ledger Setup";
        ItemJnlLineL: Record "Item Journal Line";
        ItemJnlLine2L: Record "Item Journal Line";
        DimMgtL: Codeunit DimensionManagement;
        DimSetIdL: Integer;
    begin
        ServiceCenterL.RESET;
        ServiceCenterL.SETFILTER("Global Dimension 1 Code", '<>%1', '');
        ServiceCenterL.FINDFIRST;

        GLSetupL.GET;

        //Fix Item
        ItemL.RESET;
        IF ItemL.FINDSET(TRUE, TRUE) THEN
            REPEAT
                IF STRPOS(ItemL."No.", '/000/') = 0 THEN BEGIN
                    IF ItemL."Global Dimension 1 Code" = '' THEN BEGIN
                        Item2L := ItemL;
                        Item2L."Global Dimension 1 Code" := ServiceCenterL."Global Dimension 1 Code";
                        Item2L.MODIFY;
                        IF DefaultDimL.GET(DATABASE::Item, ItemL."No.", GLSetupL."Global Dimension 1 Code")
                        THEN BEGIN
                            DefaultDimL.VALIDATE("Dimension Value Code", ServiceCenterL."Global Dimension 1 Code");
                            DefaultDimL.MODIFY;
                        END ELSE BEGIN
                            DefaultDimL.INIT;
                            DefaultDimL.VALIDATE("Table ID", DATABASE::Item);
                            DefaultDimL.VALIDATE("No.", ItemL."No.");
                            DefaultDimL.VALIDATE("Dimension Code", GLSetupL."Global Dimension 1 Code");
                            DefaultDimL.VALIDATE("Dimension Value Code", ServiceCenterL."Global Dimension 1 Code");
                            DefaultDimL.INSERT;
                        END;
                    END ELSE
                        IF NOT DefaultDimL.GET(DATABASE::Item, ItemL."No.", GLSetupL."Global Dimension 1 Code") THEN BEGIN
                            DefaultDimL.INIT;
                            DefaultDimL.VALIDATE("Table ID", DATABASE::Item);
                            DefaultDimL.VALIDATE("No.", ItemL."No.");
                            DefaultDimL.VALIDATE("Dimension Code", GLSetupL."Global Dimension 1 Code");
                            DefaultDimL.VALIDATE("Dimension Value Code", ItemL."Global Dimension 1 Code");
                            DefaultDimL.INSERT;
                        END;
                    COMMIT;
                END;
            UNTIL ItemL.NEXT = 0;

        //Fix Item Ledg Entry
        ItemLedgEntryL.RESET;
        ItemLedgEntryL.SETCURRENTKEY("Item No.", "Entry Type", "Variant Code", "Drop Shipment", "Global Dimension 1 Code");
        ItemLedgEntryL.SETRANGE("Global Dimension 1 Code", '');
        IF ItemLedgEntryL.FINDSET(TRUE, TRUE) THEN
            REPEAT
                IF ItemL.GET(ItemLedgEntryL."Item No.") THEN BEGIN
                    IF STRPOS(ItemL."No.", '/000/') = 0 THEN BEGIN
                        ItemLedgEntry2L := ItemLedgEntryL;
                        ItemLedgEntry2L."Global Dimension 1 Code" := ServiceCenterL."Global Dimension 1 Code";
                        ItemLedgEntry2L.MODIFY;

                        DimMgtL.GetDimensionSet(TempDimSetEntryL, ItemLedgEntry2L."Dimension Set ID");

                        TempDimSetEntryL.INIT;
                        TempDimSetEntryL."Dimension Code" := GLSetupL."Global Dimension 1 Code";
                        TempDimSetEntryL."Dimension Value Code" := ServiceCenterL."Global Dimension 1 Code";
                        DimValueL.GET(TempDimSetEntryL."Dimension Code", TempDimSetEntryL."Dimension Value Code");
                        TempDimSetEntryL."Dimension Value ID" := DimValueL."Dimension Value ID";
                        TempDimSetEntryL.INSERT;

                        DimSetIdL := DimMgtL.GetDimensionSetID(TempDimSetEntryL);

                        IF DimSetIdL <> 0 THEN BEGIN
                            ItemLedgEntry2L."Dimension Set ID" := DimSetIdL;
                            ItemLedgEntry2L.MODIFY;
                        END;
                        COMMIT;
                    END;
                END;
            UNTIL ItemLedgEntryL.NEXT = 0;

        //Fix Item Jnl Line
        ItemJnlLineL.RESET;
        ItemJnlLineL.SETFILTER("Item No.", '<>%1', '');
        ItemJnlLineL.SETRANGE("Shortcut Dimension 1 Code", '');
        IF ItemJnlLineL.FINDSET(TRUE, TRUE) THEN
            REPEAT
                ItemL.GET(ItemJnlLineL."Item No.");
                IF STRPOS(ItemL."No.", '/000/') = 0 THEN BEGIN
                    ItemJnlLine2L := ItemJnlLineL;
                    ItemJnlLine2L.VALIDATE("Shortcut Dimension 1 Code", ServiceCenterL."Global Dimension 1 Code");
                    ItemJnlLine2L.MODIFY;
                    COMMIT;
                END;
            UNTIL ItemJnlLineL.NEXT = 0;


    end;

    [Scope('OnPrem')]
    procedure FixZoneData2()
    var
        ServiceCenterL: Record "Service Center";
        ItemL: Record Item;
        Item2L: Record Item;
        DefaultDimL: Record "Default Dimension";
        ItemLedgEntryL: Record "Item Ledger Entry";
        ItemLedgEntry2L: Record "Item Ledger Entry";
        TempDimSetEntryL: Record "Dimension Set Entry" temporary;
        DimValueL: Record "Dimension Value";
        GLSetupL: Record "General Ledger Setup";
        ItemJnlLineL: Record "Item Journal Line";
        ItemJnlLine2L: Record "Item Journal Line";
        DimMgtL: Codeunit DimensionManagement;
        DimSetIdL: Integer;
        CompanyL: Record Company;
    begin
        GLSetupL.GET;

        //Fix Item Ledg Entry
        ItemLedgEntryL.RESET;
        ItemLedgEntryL.SETCURRENTKEY("Item No.", "Entry Type", "Variant Code", "Drop Shipment", "Global Dimension 1 Code");
        ItemLedgEntryL.SETRANGE("Global Dimension 1 Code", '');
        IF ItemLedgEntryL.FINDSET(TRUE, TRUE) THEN
            REPEAT
                IF ItemL.GET(ItemLedgEntryL."Item No.") THEN BEGIN
                    IF (STRPOS(ItemL."No.", '/000/') <> 0) AND (ItemL."Global Dimension 1 Code" <> '') THEN BEGIN
                        ItemLedgEntry2L := ItemLedgEntryL;
                        ItemLedgEntry2L."Global Dimension 1 Code" := ItemL."Global Dimension 1 Code";
                        ItemLedgEntry2L.MODIFY;

                        DimMgtL.GetDimensionSet(TempDimSetEntryL, ItemLedgEntry2L."Dimension Set ID");

                        TempDimSetEntryL.INIT;
                        TempDimSetEntryL."Dimension Code" := GLSetupL."Global Dimension 1 Code";
                        TempDimSetEntryL."Dimension Value Code" := ItemL."Global Dimension 1 Code";
                        DimValueL.GET(TempDimSetEntryL."Dimension Code", TempDimSetEntryL."Dimension Value Code");
                        TempDimSetEntryL."Dimension Value ID" := DimValueL."Dimension Value ID";
                        TempDimSetEntryL.INSERT;

                        DimSetIdL := DimMgtL.GetDimensionSetID(TempDimSetEntryL);

                        IF DimSetIdL <> 0 THEN BEGIN
                            ItemLedgEntry2L."Dimension Set ID" := DimSetIdL;
                            ItemLedgEntry2L.MODIFY;
                        END;
                        COMMIT;
                    END;
                END;
            UNTIL ItemLedgEntryL.NEXT = 0;

        //Fix Item Jnl Line
        ItemJnlLineL.RESET;
        ItemJnlLineL.SETFILTER("Item No.", '<>%1', '');
        ItemJnlLineL.SETRANGE("Shortcut Dimension 1 Code", '');
        IF ItemJnlLineL.FINDSET(TRUE, TRUE) THEN
            REPEAT
                ItemL.GET(ItemJnlLineL."Item No.");
                IF (STRPOS(ItemL."No.", '/000/') <> 0) AND (ItemL."Global Dimension 1 Code" <> '') THEN BEGIN
                    ItemJnlLine2L := ItemJnlLineL;
                    ItemJnlLine2L.VALIDATE("Shortcut Dimension 1 Code", ItemL."Global Dimension 1 Code");
                    ItemJnlLine2L.MODIFY;
                    COMMIT;
                END;
            UNTIL ItemJnlLineL.NEXT = 0;
    end;
}

