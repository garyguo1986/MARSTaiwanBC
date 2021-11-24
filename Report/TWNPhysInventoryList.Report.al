report 1044885 "TWN Phys. Inventory List"
{
    // +--------------------------------------------------------------+
    // | � 2013 ff. Begusch Software Systeme                          |
    // +--------------------------------------------------------------+
    // | PURPOSE: Fastfit                                             |
    // +--------------------------------------------------------------+
    // 
    // VERSION  ID       WHO    DATE        DESCRIPTION
    // 070100   IT_20050 FT     2013-08-12  added Description 2
    // 070100   IT_20067 FT     2013-09-11  merged Rollup 5
    // 071000   IT_20078 FT     2013-10-26  merged to NAV 7.1
    // 080200   IT_20517 AK     2015-05-08  Merged to NAV 8CU6
    // 
    // 081100   IT_20531 SG     2015-05-26  Merged with BSS.tire 08.02.00
    // 081100   IT_20603 SG     2015-07-13  changed the layout
    // 081200   IT_20913 SG     2016-02-22  Merged to NAV 2016 CU04
    // 084010   IT_21584 CM     2017-10-03  changed "Manufacturer Item No." and "Manufacturer Code" to be taken from "Item Journal Line" instead of "Item"
    // 091000  TFS_14781 CM     2018-10-30  Added event function "OnAfterPostReport()"
    // 
    // +--------------------------------------------------------------+
    // | �� 2016 Incadea.fastfit                                       |
    // +--------------------------------------------------------------+
    // | PURPOSE: MKL_MI                                              |
    // +--------------------------------------------------------------+
    // 
    // VERSION    ID       WHO    DATE        DESCRIPTION
    // MI_01.00   IT_20995 PW     2016-05-19  dynamic caption/values change with boolean PrintUOI
    // 090000     IT_21698 1CF    2018-03-28  Merged to NAV 2018 CU02
    // 
    // FEATURE ID   DATE       WHO   ID      DESCRIPTION
    // AP.0028966   17.06.19   KH    29504   Increased the length of 'Item No' and 'Bins' to avoid values getting truncated,increased length of 'Bin' field in the layout,
    //                                       Changed fields lengths to accomodate 'Item No' properly without truncation, Decreased the right margin of layout to fix printing
    //                                       one blank page after every page
    // AP.0037886  22.10.19    GV    38194   Upgrade to NAVBC140 CU05
    // AP.0041510  24.02.20    HI    41510   Removed the text UOI from caption Qty.(Phys.Inv.) UOI
    // AP.0044742  02.06.20    SY    45023   Merge of SLA: 41510
    // AP.0044854  12.06.20    SU	 40897   Merge of Code Base 15.6
    // RGS_TWN-1007 17.08.21   QX    123234  Copied from Report 722

    DefaultLayout = RDLC;
    RDLCLayout = './Report/TWNPhysInventoryList.rdlc';

    ApplicationArea = Warehouse;
    Caption = 'Physical Inventory List';
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem(PageLoop; "Integer")
        {
            DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));
            column(CompanyName; COMPANYPROPERTY.DisplayName)
            {
            }
            column(ShowLotSN; ShowLotSN)
            {
            }
            column(CaptionFilter_ItemJnlBatch; "Item Journal Batch".TableCaption + ': ' + ItemJnlBatchFilter)
            {
            }
            column(ItemJnlBatchFilter; ItemJnlBatchFilter)
            {
            }
            column(CaptionFilter_ItemJnlLine; "Item Journal Line".TableCaption + ': ' + ItemJnlLineFilter)
            {
            }
            column(ItemJnlLineFilter; ItemJnlLineFilter)
            {
            }
            column(ShowQtyCalculated; ShowQtyCalculated)
            {
            }
            column(Note1; Note1Lbl)
            {
            }
            column(SummaryPerItem; SummaryPerItemLbl)
            {
            }
            column(ShowNote; ShowNote)
            {
            }
            column(PhysInventoryListCaption; PhysInventoryListCaptionLbl)
            {
            }
            column(CurrReportPageNoCaption; CurrReportPageNoCaptionLbl)
            {
            }
            column(ItemJnlLinePostDtCaption; ItemJnlLinePostDtCaptionLbl)
            {
            }
            column(GetShorDimCodeCaption1; CaptionClassTranslate('1,1,1'))
            {
            }
            column(GetShorDimCodeCaption2; CaptionClassTranslate('1,1,2'))
            {
            }
            column(QtyPhysInventoryCaption; PhysInvCapt)
            {
            }
            column(QtyCalculatedCaption; QtyCalcCapt)
            {
            }
            column(PhyInvCaption; PhyInvCaptionLbl)
            {
            }
            dataitem("Item Journal Batch"; "Item Journal Batch")
            {
                RequestFilterFields = "Journal Template Name", Name;
                column(TemplateName_ItemJnlBatch; "Journal Template Name")
                {
                }
                column(Name_ItemJournalBatch; Name)
                {
                }
                dataitem("Item Journal Line"; "Item Journal Line")
                {
                    DataItemLink = "Journal Template Name" = FIELD("Journal Template Name"), "Journal Batch Name" = FIELD(Name);
                    DataItemTableView = SORTING("Journal Template Name", "Journal Batch Name", "Line No.");
                    RequestFilterFields = "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code", "Location Code", "Bin Code";
                    column(PostingDt_ItemJournalLine; Format("Posting Date"))
                    {
                    }
                    column(DocNo_ItemJournalLine; "Document No.")
                    {
                        IncludeCaption = true;
                    }
                    column(ItemNo_ItemJournalLine; "Item No.")
                    {
                        IncludeCaption = true;
                    }
                    //++TWN1.00.123234.QX
                    // column(Desc_ItemJournalLine; Description + '  ' + "Description 2")
                    // {
                    // }
                    column(Desc_ItemJournalLine; Description)
                    {
                    }
                    column(Desc2_ItemJournalLine; "Description 2")
                    {
                    }
                    //--TWN1.00.123234.QX
                    column(ShotcutDim1Code_ItemJnlLin; "Shortcut Dimension 1 Code")
                    {
                    }
                    column(ShotcutDim2Code_ItemJnlLin; "Shortcut Dimension 2 Code")
                    {
                    }
                    column(LocCode_ItemJournalLine; "Location Code")
                    {
                        IncludeCaption = true;
                    }
                    column(QtyCalculated_ItemJnlLin; QtcCalc)
                    {
                    }
                    column(BinCode_ItemJournalLine; "Bin Code")
                    {
                        IncludeCaption = true;
                    }
                    column(Note; Note)
                    {
                    }
                    column(ShowSummary; ShowSummary)
                    {
                    }
                    column(LineNo_ItemJournalLine; "Line No.")
                    {
                    }
                    column(DescriptionCaptionLbl; DescriptionCaptionLbl)
                    {
                    }
                    //++TWN1.00.123234.QX
                    column(Description2CaptionLbl; Description2CaptionLbl)
                    {
                    }
                    //--TWN1.00.123234.QX
                    column(EANNoCaptionLbl; EANNoCaptionLbl)
                    {
                    }
                    column(ManufacturerItemCaptionLbl; ManufacturerItemCaptionLbl)
                    {
                    }
                    column(Item_EANNo; Item."EAN No.")
                    {
                        IncludeCaption = true;
                    }
                    column(Item_ManufacturerItemNo; "Manufacturer Item No.")
                    {
                        IncludeCaption = true;
                    }
                    column(Item_Brand; "Manufacturer Code")
                    {
                    }
                    dataitem(ItemTrackingSpecification; "Integer")
                    {
                        DataItemTableView = SORTING(Number);
                        column(LotNoCaption; GetLotNoCaption)
                        {
                        }
                        column(SerialNoCaption; GetSerialNoCaption)
                        {
                        }
                        column(QuantityBaseCaption; GetQuantityBaseCaption)
                        {
                        }
                        column(ReservEntryBufferLotNo; ReservEntryBuffer."Lot No.")
                        {
                        }
                        column(ReservEntryBufferSerialNo; ReservEntryBuffer."Serial No.")
                        {
                        }
                        column(ReservEntryBufferQtyBase; ReservEntryBuffer."Quantity (Base)")
                        {
                            DecimalPlaces = 0 : 0;
                        }
                        column(SummaryperItemCaption; SummaryperItemCaptionLbl)
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin
                            if Number = 1 then
                                ReservEntryBuffer.FindSet
                            else
                                ReservEntryBuffer.Next;
                        end;

                        trigger OnPreDataItem()
                        begin
                            ReservEntryBuffer.SetCurrentKey("Source ID", "Source Ref. No.", "Source Type", "Source Subtype", "Source Batch Name");
                            ReservEntryBuffer.SetRange("Source ID", "Item Journal Line"."Journal Template Name");
                            ReservEntryBuffer.SetRange("Source Ref. No.", "Item Journal Line"."Line No.");
                            ReservEntryBuffer.SetRange("Source Type", DATABASE::"Item Journal Line");
                            ReservEntryBuffer.SetFilter("Source Subtype", '=%1', ReservEntryBuffer."Source Subtype"::"0");
                            ReservEntryBuffer.SetRange("Source Batch Name", "Item Journal Line"."Journal Batch Name");

                            if ReservEntryBuffer.IsEmpty then
                                CurrReport.Break;
                            SetRange(Number, 1, ReservEntryBuffer.Count);

                            GetLotNoCaption := ReservEntryBuffer.FieldCaption("Lot No.");
                            GetSerialNoCaption := ReservEntryBuffer.FieldCaption("Serial No.");
                            GetQuantityBaseCaption := ReservEntryBuffer.FieldCaption("Quantity (Base)");
                        end;
                    }

                    trigger OnAfterGetRecord()
                    begin
                        if ShowLotSN then begin
                            Note := '';
                            ShowSummary := false;
                            if "Bin Code" <> '' then
                                if not WhseTrckg("Item No.") then begin
                                    Note := NoteTxt;
                                    ShowSummary := true;
                                end;
                            Clear(ReservEntryBuffer);
                        end;

                        //++BSS.IT_20603.SG
                        if Item.Get("Item Journal Line"."Item No.") then
                            Item.CalcFields("EAN No.");
                        //--BSS.IT_20603.SG

                        //++BSS.IT_20995.PW
                        if PrintUOI then
                            QtcCalc := "Item Journal Line"."Qty. (Calculated) UOI"
                        else
                            QtcCalc := "Item Journal Line"."Qty. (Calculated)";
                        //--BSS.IT_20995.PW
                    end;

                    trigger OnPreDataItem()
                    begin
                        //++BSS.IT_20603.SG
                        case MARSSorting of
                            0:
                                SetCurrentKey("Manufacturer Code", Diameter, Width, "Aspect Ratio", Speedindex);
                            1:
                                SetCurrentKey("Manufacturer Code", "Tread Patterncode/Modelcode", Diameter, Width, "Aspect Ratio");
                            2:
                                SetCurrentKey(Diameter, Width, "Aspect Ratio", Speedindex);
                            3:
                                SetCurrentKey("Main Group Code", "Sub Group Code", "Position Group Code");
                        end;
                        //--BSS.IT_20603.SG
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    if ItemJournalTemplate.Get("Journal Template Name") then
                        if ItemJournalTemplate.Type <> ItemJournalTemplate.Type::"Phys. Inventory" then
                            CurrReport.Skip;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                //++BSS.IT_20995.PW
                if PrintUOI then begin
                    PhysInvCapt := "Item Journal Line".FieldCaption("Item Journal Line"."Qty. (Phys. Inventory) UOI");
                    QtyCalcCapt := "Item Journal Line".FieldCaption("Item Journal Line"."Qty. (Calculated) UOI");
                end else begin
                    PhysInvCapt := "Item Journal Line".FieldCaption("Item Journal Line"."Qty. (Phys. Inventory)");
                    QtyCalcCapt := "Item Journal Line".FieldCaption("Item Journal Line"."Qty. (Calculated)");
                end;
                //--BSS.IT_20995.PW
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(ShowCalculatedQty; ShowQtyCalculated)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Show Qty. (Calculated)';
                        ToolTip = 'Specifies if you want the report to show the calculated quantity of the items.';
                    }
                    field("Print in UOI Values"; PrintUOI)
                    {
                        Caption = 'Print in UOI values';
                    }
                    field(ShowSerialLotNumber; ShowLotSN)
                    {
                        ApplicationArea = ItemTracking;
                        Caption = 'Show Serial/Lot Number';
                        ToolTip = 'Specifies if you want the report to show lot and serial numbers.';
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
        //++BSS.IT_20995.PW
        PrintUOI := true;
        //--BSS.IT_20995.PW
    end;

    trigger OnPreReport()
    begin
        ItemJnlLineFilter := "Item Journal Line".GetFilters;
        ItemJnlBatchFilter := "Item Journal Batch".GetFilters;
        if ShowLotSN then begin
            ShowNote := false;
            ItemJnlLine.CopyFilters("Item Journal Line");
            "Item Journal Batch".CopyFilter("Journal Template Name", ItemJnlLine."Journal Template Name");
            "Item Journal Batch".CopyFilter(Name, ItemJnlLine."Journal Batch Name");
            CreateSNLotEntries(ItemJnlLine);
        end;

        //++BSS.IT_20603.SG
        if TireSetup.Get then
            Item.SetFilter("Barcode Type EAN", TireSetup."Barcode Type EAN");
        //--BSS.IT_20603.SG

        //++BSS.TFS_14781.CM
        OnAfterPostReport();
        //--BSS.TFS_14781.CM
    end;

    var
        ItemJournalTemplate: Record "Item Journal Template";
        ItemJnlLine: Record "Item Journal Line";
        ItemTrackingCode: Record "Item Tracking Code";
        ReservEntryBuffer: Record "Reservation Entry" temporary;
        ItemJnlLineFilter: Text;
        ItemJnlBatchFilter: Text;
        Note: Text[1];
        ShowQtyCalculated: Boolean;
        ShowLotSN: Boolean;
        ShowNote: Boolean;
        ShowSummary: Boolean;
        NoteTxt: Label '*', Locked = true;
        EntryNo: Integer;
        GetLotNoCaption: Text[80];
        GetSerialNoCaption: Text[80];
        GetQuantityBaseCaption: Text[80];
        Note1Lbl: Label '*Note:';
        SummaryPerItemLbl: Label 'Your system is set up to use Bin Mandatory and not SN/Lot Warehouse Tracking. Therefore, you will not see serial/lot numbers by bin but merely as a summary per item.';
        PhysInventoryListCaptionLbl: Label 'Phys. Inventory List';
        CurrReportPageNoCaptionLbl: Label 'Page';
        ItemJnlLinePostDtCaptionLbl: Label 'Posting Date';
        SummaryperItemCaptionLbl: Label 'Summary per Item *';

        DescriptionCaptionLbl: Label 'Description';
        Description2CaptionLbl: Label 'Description 2';
        _MARS_: Integer;
        TireSetup: Record "Fastfit Setup - General";
        Item: Record Item;
        EANNoCaptionLbl: Label 'EAN No.';
        ManufacturerItemCaptionLbl: Label 'Manufacturer Item No.';
        MARSSorting: Option Sorting1,Sorting2,Sorting3,Sorting4;
        PrintUOI: Boolean;
        QtcCalc: Decimal;
        PhysInvCapt: Text;
        QtyCalcCapt: Text;
        PhyInvCaptionLbl: Label 'Qty.(Phys. Inv.)';

    procedure Initialize(ShowQtyCalculated2: Boolean)
    begin
        ShowQtyCalculated := ShowQtyCalculated2;
    end;

    local procedure CreateSNLotEntries(var ItemJnlLine: Record "Item Journal Line")
    begin
        EntryNo := 0;
        if ItemJnlLine.FindSet then
            repeat
                if ItemJnlLine."Bin Code" <> '' then begin
                    if WhseTrckg(ItemJnlLine."Item No.") then
                        PickSNLotFromWhseEntry(ItemJnlLine."Item No.",
                          ItemJnlLine."Variant Code", ItemJnlLine."Location Code", ItemJnlLine."Bin Code", ItemJnlLine."Unit of Measure Code")
                    else begin
                        CreateSummary(ItemJnlLine);
                        ShowNote := true;
                    end;
                end
                else begin
                    if DirectedPutAwayAndPick(ItemJnlLine."Location Code") then
                        CreateSummary(ItemJnlLine)
                    else
                        PickSNLotFromILEntry(ItemJnlLine."Item No.", ItemJnlLine."Variant Code", ItemJnlLine."Location Code");
                end;
            until ItemJnlLine.Next = 0;
    end;

    local procedure PickSNLotFromILEntry(ItemNo: Code[20]; VariantCode: Code[10]; LocationCode: Code[10])
    var
        ItemLedgEntry: Record "Item Ledger Entry";
    begin
        ItemLedgEntry.SetCurrentKey("Item No.", Open, "Variant Code", "Location Code");
        ItemLedgEntry.SetRange("Item No.", ItemNo);
        if ItemJnlLine."Qty. (Phys. Inventory)" = 0 then  // Item Not on Inventory, show old SN/Lot
            ItemLedgEntry.SetRange(Open, false)
        else
            ItemLedgEntry.SetRange(Open, true);
        ItemLedgEntry.SetRange("Variant Code", VariantCode);
        ItemLedgEntry.SetRange("Location Code", LocationCode);
        ItemLedgEntry.SetFilter("Item Tracking", '<>%1', ItemLedgEntry."Item Tracking"::None);

        if ItemLedgEntry.FindSet then
            repeat
                CreateReservEntry(ItemJnlLine, ItemLedgEntry."Remaining Quantity",
                  ItemLedgEntry."Serial No.", ItemLedgEntry."Lot No.", ItemLedgEntry."Item Tracking");
            until ItemLedgEntry.Next = 0;
    end;

    local procedure PickSNLotFromWhseEntry(ItemNo: Code[20]; VariantCode: Code[10]; LocationCode: Code[10]; BinCode: Code[20]; UnitOM: Code[10])
    var
        WhseEntry: Record "Warehouse Entry";
        ItemTrackg: Option "None","Lot No.","Lot and Serial No.","Serial No.";
    begin
        WhseEntry.SetCurrentKey(
          "Item No.", "Bin Code", "Location Code", "Variant Code", "Unit of Measure Code",
          "Lot No.", "Serial No.", "Entry Type");
        WhseEntry.SetRange("Item No.", ItemNo);
        WhseEntry.SetRange("Bin Code", BinCode);
        WhseEntry.SetRange("Location Code", LocationCode);
        WhseEntry.SetRange("Variant Code", VariantCode);
        WhseEntry.SetRange("Unit of Measure Code", UnitOM);

        if WhseEntry.FindSet then
            repeat
                if (WhseEntry."Lot No." <> '') and (WhseEntry."Serial No." <> '') then
                    CreateReservEntry(ItemJnlLine, WhseEntry."Qty. (Base)",
                      WhseEntry."Serial No.", WhseEntry."Lot No.", ItemTrackg::"Lot and Serial No.")
                else begin
                    if WhseEntry."Lot No." <> '' then
                        CreateReservEntry(ItemJnlLine, WhseEntry."Qty. (Base)",
                          WhseEntry."Serial No.", WhseEntry."Lot No.", ItemTrackg::"Lot No.");
                    if WhseEntry."Serial No." <> '' then
                        CreateReservEntry(ItemJnlLine, WhseEntry."Qty. (Base)",
                          WhseEntry."Serial No.", WhseEntry."Lot No.", ItemTrackg::"Serial No.");
                end;
            until WhseEntry.Next = 0;
    end;

    local procedure CreateReservEntry(ItemJournalLine: Record "Item Journal Line"; Qty: Decimal; SerialNo: Code[50]; LotNo: Code[50]; ItemTracking: Option "None","Lot No.","Lot and Serial No.","Serial No.")
    var
        FoundRec: Boolean;
    begin
        ReservEntryBuffer.SetCurrentKey(
          "Item No.", "Variant Code", "Location Code", "Item Tracking", "Reservation Status", "Lot No.", "Serial No.");
        ReservEntryBuffer.SetRange("Item No.", ItemJournalLine."Item No.");
        ReservEntryBuffer.SetRange("Variant Code", ItemJournalLine."Variant Code");
        ReservEntryBuffer.SetRange("Location Code", ItemJournalLine."Location Code");
        ReservEntryBuffer.SetRange("Reservation Status", ReservEntryBuffer."Reservation Status"::Prospect);
        ReservEntryBuffer.SetRange("Item Tracking", ItemTracking);
        ReservEntryBuffer.SetRange("Serial No.", SerialNo);
        ReservEntryBuffer.SetRange("Lot No.", LotNo);

        if ReservEntryBuffer.FindSet then begin
            repeat
                if (ReservEntryBuffer."Source Ref. No." = ItemJournalLine."Line No.") and
                   (ReservEntryBuffer."Source ID" = ItemJournalLine."Journal Template Name") and
                   (ReservEntryBuffer."Source Batch Name" = ItemJournalLine."Journal Batch Name")
                then
                    FoundRec := true;
            until (ReservEntryBuffer.Next = 0) or FoundRec;
        end;

        if not FoundRec then begin
            EntryNo += 1;
            ReservEntryBuffer."Entry No." := EntryNo;
            ReservEntryBuffer."Item No." := ItemJournalLine."Item No.";
            ReservEntryBuffer."Location Code" := ItemJournalLine."Location Code";
            ReservEntryBuffer."Quantity (Base)" := Qty;
            ReservEntryBuffer."Variant Code" := ItemJournalLine."Variant Code";
            ReservEntryBuffer."Reservation Status" := ReservEntryBuffer."Reservation Status"::Prospect;
            ReservEntryBuffer."Creation Date" := WorkDate;
            ReservEntryBuffer."Source Type" := DATABASE::"Item Journal Line";
            ReservEntryBuffer."Source ID" := ItemJournalLine."Journal Template Name";
            ReservEntryBuffer."Source Batch Name" := ItemJournalLine."Journal Batch Name";
            ReservEntryBuffer."Source Ref. No." := ItemJournalLine."Line No.";
            ReservEntryBuffer."Qty. per Unit of Measure" := ItemJournalLine."Qty. per Unit of Measure";
            ReservEntryBuffer."Serial No." := SerialNo;
            ReservEntryBuffer."Lot No." := LotNo;
            ReservEntryBuffer."Item Tracking" := ItemTracking;
            ReservEntryBuffer.Insert;
        end
        else begin
            ReservEntryBuffer."Quantity (Base)" += Qty;
            ReservEntryBuffer.Modify;
        end;
    end;

    local procedure WhseTrckg(ItemNo: Code[20]): Boolean
    var
        Item: Record Item;
        SNRequired: Boolean;
        LNRequired: Boolean;
    begin
        SNRequired := false;
        LNRequired := false;
        Item.Get(ItemNo);
        if Item."Item Tracking Code" <> '' then begin
            ItemTrackingCode.Get(Item."Item Tracking Code");
            SNRequired := ItemTrackingCode."SN Warehouse Tracking";
            LNRequired := ItemTrackingCode."Lot Warehouse Tracking";
        end;

        exit(SNRequired or LNRequired);
    end;

    local procedure DirectedPutAwayAndPick(LocationCode: Code[10]): Boolean
    var
        Location: Record Location;
    begin
        if LocationCode = '' then
            exit(false);
        Location.Get(LocationCode);
        exit(Location."Directed Put-away and Pick");
    end;

    local procedure CreateSummary(var ItemJnlLine1: Record "Item Journal Line")
    var
        ItemJnlLine2: Record "Item Journal Line";
        ItemNo: Code[20];
        VariantCode: Code[10];
        LocationCode: Code[10];
        NewGroup: Boolean;
    begin
        // Create SN/Lot entry only for the last journal line in the group
        ItemNo := ItemJnlLine1."Item No.";
        VariantCode := ItemJnlLine1."Variant Code";
        LocationCode := ItemJnlLine1."Location Code";
        NewGroup := false;
        ItemJnlLine2 := ItemJnlLine1;
        repeat
            if (ItemNo <> ItemJnlLine1."Item No.") or
               (VariantCode <> ItemJnlLine1."Variant Code") or
               (LocationCode <> ItemJnlLine1."Location Code")
            then
                NewGroup := true
            else
                ItemJnlLine2 := ItemJnlLine1;
        until (ItemJnlLine1.Next = 0) or NewGroup;
        ItemJnlLine1 := ItemJnlLine2;
        PickSNLotFromILEntry(ItemJnlLine1."Item No.", ItemJnlLine1."Variant Code", ItemJnlLine1."Location Code");
    end;

    local procedure ___MARS___()
    begin
    end;

    [Scope('OnPrem')]
    procedure SetSorting(SetSortingP: Integer)
    begin
        //++BSS.IT_20603.SG
        MARSSorting := SetSortingP;
        //--BSS.IT_20603.SG
    end;

    local procedure __EVENTS__()
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterPostReport()
    begin
    end;
}

