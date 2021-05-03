pageextension 1073889 "Service Center List Ext" extends "Service Center List"
{
    // +--------------------------------------------------------------+
    // | @ 2017 incadea Taiwan Limited                                |
    // +--------------------------------------------------------------+
    // | PURPOSE: MARS_TWN                                            |
    // |                                                              |
    // +--------------------------------------------------------------+

    // VERSION       ID          WHO    DATE        DESCRIPTION
    // RGS_TWN-INC01             NN     2017-06-06  Added function: GetSelectionFilter()
    // TWN.01.01     RGS_TWN-459 AH     2017-08-03  Add "No. of Bays" to General Tab    
    layout
    {
        addafter("Location Code")
        {
            field("Return Order Location Code"; "Return Order Location Code")
            {
                ApplicationArea = All;
            }
        }
        addafter("Geo-Localization Lat.")
        {
            field("No. of Bays"; "No. of Bays")
            {
                ApplicationArea = All;
            }
        }
    }
    procedure GetSelectionFilter(): Code[80]
    var
        DimVal: Record "Service Center";
        FirstDimVal: Code[20];
        LastDimVal: Code[20];
        SelectionFilter: Code[250];
        DimValCount: Integer;
        More: Boolean;
    begin
        CurrPage.SETSELECTIONFILTER(DimVal);
        DimValCount := DimVal.COUNT;
        IF DimValCount > 0 THEN BEGIN
            DimVal.FIND('-');
            WHILE DimValCount > 0 DO BEGIN
                DimValCount := DimValCount - 1;
                DimVal.MARKEDONLY(FALSE);
                FirstDimVal := DimVal.Code;
                LastDimVal := FirstDimVal;
                More := (DimValCount > 0);
                WHILE More DO
                    IF DimVal.NEXT = 0 THEN
                        More := FALSE
                    ELSE
                        IF NOT DimVal.MARK THEN
                            More := FALSE
                        ELSE BEGIN
                            LastDimVal := DimVal.Code;
                            DimValCount := DimValCount - 1;
                            IF DimValCount = 0 THEN
                                More := FALSE;
                        END;
                IF SelectionFilter <> '' THEN
                    SelectionFilter := SelectionFilter + '|';
                IF FirstDimVal = LastDimVal THEN
                    SelectionFilter := SelectionFilter + FirstDimVal
                ELSE
                    SelectionFilter := SelectionFilter + FirstDimVal + '..' + LastDimVal;
                IF DimValCount > 0 THEN BEGIN
                    DimVal.MARKEDONLY(TRUE);
                    DimVal.NEXT;
                END;
            END;
        END;
        EXIT(SelectionFilter);
    end;
}
