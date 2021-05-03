tableextension 1044862 "Fastfit Setup - Reporting Ext" extends "Fastfit Setup - Reporting"
{
    // +--------------------------------------------------------------+
    // | ?2015 ff. Begusch Software Systeme                          |
    // #3..24
    // 
    // 
    // +--------------------------------------------------------------+
    // | @ 2017 incadea Taiwan Limited                                |
    // +--------------------------------------------------------------+
    // | PURPOSE: MARS_TWN                                            |
    // |                                                              |
    // +--------------------------------------------------------------+
    // 
    // VERSION       ID          WHO    DATE        DESCRIPTION
    // TWN.01.01     RGS_TWN-459 AH     2017-06-02  Add Fields 50000..50003
    // 
    // +--------------------------------------------------------------+
    // | @ 2019 incadea Taiwan Limited                                |
    // +--------------------------------------------------------------+
    // | PURPOSE: MARS_TWN                                            |
    // |                                                              |
    // | REMARK :                                                     |
    // +--------------------------------------------------------------+
    // 
    // VERSION       ID            WHO    DATE        DESCRIPTION
    // RGS_TWN-809   118849        GG     2019-03-13  Add new fields "Position Group For TurnOver" "Main Group For Tire" "Position Group For OilFilter" "Position Group For Oil"
    fields
    {
        field(50000; "Position group of Balancing"; Text[80])
        {
            Caption = 'Position group of Balancing';
            Description = 'TWN.01.01';
            //The property 'ValidateTableRelation' can only be set if the property 'TableRelation' is set
            //ValidateTableRelation = false;

            trigger OnLookup()
            var
                Text: Text[200];
            begin
                LookUpPositionFilter2(Text);
                IF Text <> '' THEN
                    VALIDATE("Position group of Balancing", Text);
            end;

            trigger OnValidate()
            begin
                PositionGroup.RESET;
                PositionGroup.SETFILTER(Code, "Position group of Balancing");
                IF NOT PositionGroup.FINDFIRST THEN
                    //++TWN1.00.122187.QX
                    //ERROR(C_BSS_ERR001, "Position group of Balancing");
                    ERROR(C_BSS_ERR0010, "Position group of Balancing");
                //TWN1.00.122187.QX
            end;
        }
        field(50001; "Position group of Alignments"; Text[80])
        {
            Caption = 'Position group of Alignments';
            Description = 'TWN.01.01';
            //The property 'ValidateTableRelation' can only be set if the property 'TableRelation' is set
            //ValidateTableRelation = false;

            trigger OnLookup()
            var
                Text: Text[200];
            begin
                LookUpPositionFilter2(Text);
                IF Text <> '' THEN
                    VALIDATE("Position group of Alignments", Text);
            end;

            trigger OnValidate()
            begin
                PositionGroup.RESET;
                PositionGroup.SETFILTER(Code, "Position group of Alignments");
                IF NOT PositionGroup.FINDFIRST THEN
                    //++TWN1.00.122187.QX
                    //ERROR(C_BSS_ERR001, "Position group of Alignments");
                    ERROR(C_BSS_ERR0010, "Position group of Alignments");
                //--TWN1.00.122187.QX
            end;
        }
        field(50002; "Position Group For Tire"; Code[50])
        {
            Caption = 'Position Group For Tire';
            Description = 'TWN.01.01';

            trigger OnLookup()
            var
                Text: Text[200];
            begin
                LookUpPositionFilter2(Text);
                IF Text <> '' THEN
                    VALIDATE("Position Group For Tire", Text);
            end;

            trigger OnValidate()
            begin
                PositionGroup.RESET;
                PositionGroup.SETFILTER(Code, "Position Group For Tire");
                IF NOT PositionGroup.FINDFIRST THEN
                    //++TWN1.00.122187.QX
                    //ERROR(C_BSS_ERR001, "Position Group For Tire");
                    ERROR(C_BSS_ERR0010, "Position Group For Tire");
                //--TWN1.00.122187.QX
            end;
        }
        field(50003; "Position Group For Tire RelSer"; Code[150])
        {
            Caption = 'Position Group For Tire Related Service';
            Description = 'TWN.01.01';

            trigger OnLookup()
            var
                Text: Text[200];
            begin
                LookUpPositionFilter2(Text);
                IF Text <> '' THEN
                    VALIDATE("Position Group For Tire RelSer", Text);
            end;

            trigger OnValidate()
            begin
                PositionGroup.RESET;
                PositionGroup.SETFILTER(Code, "Position Group For Tire RelSer");
                IF NOT PositionGroup.FINDFIRST THEN
                    //++TWN1.00.122187.QX
                    //ERROR(C_BSS_ERR001, "Position Group For Tire RelSer");
                    ERROR(C_BSS_ERR0010, "Position Group For Tire RelSer");
                //--TWN1.00.122187.QX
            end;
        }
        field(1044870; "Position Group For TurnOver"; Code[50])
        {
            Caption = 'Position Group For TurnOver';
            Description = '118849';
        }
        field(1044871; "Main Group For Tire"; Code[50])
        {
            Caption = 'Main Group For Tire';
            Description = '118849';
        }
        field(1044872; "Position Group For OilFilter"; Code[50])
        {
            Caption = 'Position Group For OilFilter';
            Description = '118849';
        }
        field(1044873; "Position Group For Oil"; Code[50])
        {
            Caption = 'Position Group For Oil';
            Description = '118849';
        }
        field(1044875; "Position Group For NonTire"; Code[50])
        {
            Caption = 'Position Group For NonTire';
            Description = '118849';
        }
    }

    procedure LookUpPositionFilter2(var Text: Text[200])
    var
        PositionGroup: Record "Position Group";
        PositionGroupList: Page "Position Group List";
    begin
        //++BSS.IT_5892.SR
        PositionGroupList.LOOKUPMODE(TRUE);
        PositionGroupList.SETTABLEVIEW(PositionGroup);
        IF PositionGroupList.RUNMODAL = ACTION::LookupOK THEN BEGIN
            PositionGroupList.GETRECORD(PositionGroup);
            Text += PositionGroupList.GetSelectionFilter;
        END;
        //--BSS.IT_5892.SR
    end;

    var
        PositionGroup: Record "Position Group";
        MainGroup: Record "Main Group";
        SubGroup: Record "Sub Group";
        //++TWN1.00.122187.QX
        //ProdGroup: Record "Product Group";
        ProdGroup: Record "Item Category";
        //.Code where("Parent Category" = Filter(<> ''));
        //--TWN1.00.122187.QX
        DailyStatisticEntry: Record "Daily Statistic Entry";

    var
        C_BSS_ERR002: Label 'Main Group with filter %1 is not found.';
        C_BSS_ERR003: Label 'Sub Group with filter %1 is not found.';
        C_BSS_ERR0010: Label 'The Character "%1" is not permitted.';
}

