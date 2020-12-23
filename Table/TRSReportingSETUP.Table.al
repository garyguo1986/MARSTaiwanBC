table 1044866 "TRS Reporting SETUP"
{
    // +--------------------------------------------------------------+
    // | @ 2017 incadea Taiwan Limited                                |
    // +--------------------------------------------------------------+
    // | PURPOSE: MARS_TWN                                            |
    // |                                                              |
    // +--------------------------------------------------------------+
    // 
    // VERSION       ID          WHO    DATE        DESCRIPTION
    // TWN.01.03     RGS_TWN-632 NN     2017-06-06  Upgrade from r3
    // RGS_TWN-888   122187	     QX	    2020-11-23  Product Group Table Removed

    Caption = 'MARS Reporting Setup';
    DataPerCompany = false;

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
        }
        field(10; "SOA Product Group Filter"; Text[80])
        {
            Caption = 'SOA Product Group Filter';
            //This property is currently not supported
            //TestTableRelation = false;
            //The property 'ValidateTableRelation' can only be set if the property 'TableRelation' is set
            //ValidateTableRelation = false;

            trigger OnLookup()
            var
                Text: Text[200];
            begin
                LookUpProdGroupFilter2(Text);
                IF Text <> '' THEN
                    VALIDATE("SOA Product Group Filter", Text);
            end;

            trigger OnValidate()
            begin
                ProdGroup.RESET;
                ProdGroup.SETFILTER(Code, "SOA Product Group Filter");
                IF NOT MainGroup.FINDFIRST THEN
                    ERROR(C_BSS_ERR002, "SOA Product Group Filter");
            end;
        }
        field(11; "Sales Track Main Group Filter"; Text[80])
        {
            Caption = 'Sales Track Main Group Filter';

            trigger OnLookup()
            var
                Text: Text[200];
            begin
                LookUpMainGroupFilter2(Text);
                IF Text <> '' THEN
                    VALIDATE("Sales Track Main Group Filter", Text);
            end;

            trigger OnValidate()
            begin
                MainGroup.RESET;
                MainGroup.SETFILTER(Code, "Sales Track Main Group Filter");
                IF NOT MainGroup.FINDFIRST THEN
                    ERROR(C_BSS_ERR002, "Sales Track Main Group Filter");
            end;
        }
        field(12; "Top 10 Main Group Filter"; Text[80])
        {
            Caption = 'Top 10 Main Group Filter';

            trigger OnLookup()
            var
                Text: Text[200];
            begin
                LookUpMainGroupFilter2(Text);
                IF Text <> '' THEN
                    VALIDATE("Top 10 Main Group Filter", Text);
            end;

            trigger OnValidate()
            begin
                MainGroup.RESET;
                MainGroup.SETFILTER(Code, "Top 10 Main Group Filter");
                IF NOT MainGroup.FINDFIRST THEN
                    ERROR(C_BSS_ERR002, "Top 10 Main Group Filter");
            end;
        }
        field(20; "Main Group Truck Tyres"; Code[10])
        {
            Caption = 'Main Group Truck Tyres';
            TableRelation = "Main Group";
        }
        field(21; "Main Group MPT Tyres"; Code[10])
        {
            Caption = 'Main Group MPT Tyres';
            TableRelation = "Main Group";
        }
        field(23; "Main Group EM Tyres"; Code[10])
        {
            Caption = 'Main Group EM Tyres';
            TableRelation = "Main Group";
        }
        field(24; "Main Group Industry Tyres"; Code[10])
        {
            Caption = 'Main Group Industry Tyres';
            TableRelation = "Main Group";
        }
        field(50000; "Statistic Analysis Templ. Code"; Code[20])
        {
            Caption = 'Statistic Analysis Templates Code';
            TableRelation = "Statistic Analysis Templ.".Code;
        }
        field(50001; "Dealer Report Code"; Code[20])
        {
            Caption = 'Statistic Analysis Templates Code 1';
            TableRelation = "Statistic Analysis Templ.".Code;
        }
        field(50002; "Dealer Report Code 2"; Code[20])
        {
            Caption = 'Statistic Analysis Templates Code 2';
            TableRelation = "Statistic Analysis Templ.".Code;
        }
        field(50003; "Statistic Analysis Templ. 2"; Code[20])
        {
            Caption = 'Statistic Analysis Templates Code2';
            TableRelation = "Statistic Analysis Templ.".Code;
        }
        field(50004; "Statistic Analysis Templ. 3"; Code[20])
        {
            Caption = 'Statistic Analysis Templates Code3';
            TableRelation = "Statistic Analysis Templ.".Code;
        }
        field(1017361; "Central Maintenance"; Boolean)
        {
            Caption = 'Central Maintenance';
        }
        field(1044510; "Brand Mix Template"; Code[20])
        {
            Caption = 'Brand Mix Template';
            TableRelation = "Analysis Line Template".Name;
        }
        field(1044511; "Product Mix Template"; Code[20])
        {
            Caption = 'Product Mix Template';
            TableRelation = "Analysis Line Template".Name;
        }
        field(1044512; "Product and Services Template"; Code[20])
        {
            Caption = 'Product and Services Template';
            TableRelation = "Analysis Line Template".Name;
        }
        field(1044513; "Position group of Balancing"; Text[80])
        {
            Caption = 'Position group of Balancing';
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
                    ERROR(C_BSS_ERR001, "Position group of Balancing");
            end;
        }
        field(1044514; "Position group of Alignments"; Text[80])
        {
            Caption = 'Position group of Alignments';
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
                    ERROR(C_BSS_ERR001, "Position group of Alignments");
            end;
        }
        field(1044515; "Main group PC Tyres"; Code[10])
        {
            Caption = 'Main group PC Tyres';
            TableRelation = "Main Group";
        }
        field(1044516; "Main group SUV Tyres"; Code[10])
        {
            Caption = 'Main group SUV Tyres';
            TableRelation = "Main Group";
        }
        field(1044517; "Main group LT Tyres"; Code[10])
        {
            Caption = 'Main group LT Tyres';
            TableRelation = "Main Group";
        }
        field(1044518; "Main group LCV Tyres"; Code[10])
        {
            Caption = 'Main group LCV Tyres';
            TableRelation = "Main Group";
        }
        field(1044519; "Main group TB Tyres"; Code[10])
        {
            Caption = 'Main group TB Tyres';
            TableRelation = "Main Group";
        }
        field(1044520; "Main group AGRI Tyres"; Code[10])
        {
            Caption = 'Main group AGRI Tyres';
            TableRelation = "Main Group";
        }
        field(1044521; "Main group 2-3  Wheeler"; Code[10])
        {
            Caption = 'Main group 2-3  Wheeler';
            TableRelation = "Main Group";
        }
        field(1044522; "Main group Used Tyres"; Code[10])
        {
            Caption = 'Main group Used Tyres';
            TableRelation = "Main Group";
        }
        field(1044523; "Main group Chasis Tyres"; Code[10])
        {
            Caption = 'Main group Chasis Tyres';
            TableRelation = "Main Group";
        }
        field(1044524; "Main group Rims"; Code[10])
        {
            Caption = 'Main group Rims';
            TableRelation = "Main Group";
        }
        field(1044525; "Main group Tubes"; Code[10])
        {
            Caption = 'Main group Tubes';
            TableRelation = "Main Group";
        }
        field(1044526; "Main group Flaps"; Code[10])
        {
            Caption = 'Main group Flaps';
            TableRelation = "Main Group";
        }
        field(1044527; "Main group Batteries"; Code[10])
        {
            Caption = 'Main group Batteries';
            TableRelation = "Main Group";
        }
        field(1044528; "Main group Lubes"; Code[10])
        {
            Caption = 'Main group Lubes';
            TableRelation = "Main Group";
        }
        field(1044529; "Main group Parts"; Code[50])
        {
            Caption = 'Main group Parts';

            trigger OnLookup()
            var
                Text: Text[200];
            begin
                LookUpMainGroupFilter2(Text);
                IF Text <> '' THEN
                    VALIDATE("Main group Parts", Text);
            end;

            trigger OnValidate()
            begin
                MainGroup.RESET;
                MainGroup.SETFILTER(Code, "Main group Parts");
                IF NOT MainGroup.FINDFIRST THEN
                    ERROR(C_BSS_ERR002, "Main group Parts");
            end;
        }
        field(1044530; "Main group Accessories"; Code[50])
        {
            Caption = 'Main group Accessories';

            trigger OnLookup()
            var
                Text: Text[200];
            begin
                LookUpMainGroupFilter2(Text);
                IF Text <> '' THEN
                    VALIDATE("Main group Accessories", Text);
            end;

            trigger OnValidate()
            begin
                MainGroup.RESET;
                MainGroup.SETFILTER(Code, "Main group Accessories");
                IF NOT MainGroup.FINDFIRST THEN
                    ERROR(C_BSS_ERR002, "Main group Accessories");
            end;
        }
        field(1044531; "Main group Services"; Code[50])
        {
            Caption = 'Main group Services';

            trigger OnLookup()
            var
                Text: Text[200];
            begin
                LookUpMainGroupFilter2(Text);
                IF Text <> '' THEN
                    VALIDATE("Main group Services", Text);
            end;

            trigger OnValidate()
            begin
                MainGroup.RESET;
                MainGroup.SETFILTER(Code, "Main group Services");
                IF NOT MainGroup.FINDFIRST THEN
                    ERROR(C_BSS_ERR002, "Main group Services");
            end;
        }
        field(1044532; "Main group Misc"; Code[50])
        {
            Caption = 'Main group Misc';

            trigger OnLookup()
            var
                Text: Text[200];
            begin
                LookUpMainGroupFilter2(Text);
                IF Text <> '' THEN
                    VALIDATE("Main group Misc", Text);
            end;

            trigger OnValidate()
            begin
                MainGroup.RESET;
                MainGroup.SETFILTER(Code, "Main group Misc");
                IF NOT MainGroup.FINDFIRST THEN
                    ERROR(C_BSS_ERR002, "Main group Misc");
            end;
        }
        field(1044533; "Main group Set Item"; Code[50])
        {
            Caption = 'Main group Set Item';

            trigger OnLookup()
            var
                Text: Text[200];
            begin
                LookUpMainGroupFilter2(Text);
                IF Text <> '' THEN
                    VALIDATE("Main group Set Item", Text);
            end;

            trigger OnValidate()
            begin
                MainGroup.RESET;
                MainGroup.SETFILTER(Code, "Main group Set Item");
                IF NOT MainGroup.FINDFIRST THEN
                    ERROR(C_BSS_ERR002, "Main group Set Item");
            end;
        }
        field(1044534; "Sub Group Tire Related"; Code[50])
        {
            Caption = 'Sub Group Tire Related';

            trigger OnLookup()
            var
                Text: Text[200];
            begin
                LookUpSubGroupFilter2(Text, "Main group Services");
                IF Text <> '' THEN
                    VALIDATE("Sub Group Tire Related", Text);
            end;

            trigger OnValidate()
            begin
                SubGroup.RESET;
                SubGroup.SETFILTER(Code, "Sub Group Tire Related");
                IF NOT SubGroup.FINDFIRST THEN
                    ERROR(C_BSS_ERR003, "Sub Group Tire Related");
            end;
        }
        field(1044535; "Sub Group Vehicle Related"; Code[50])
        {
            Caption = 'Sub Group Vehicle Related';

            trigger OnLookup()
            var
                Text: Text[200];
            begin
                LookUpSubGroupFilter2(Text, "Main group Services");
                IF Text <> '' THEN
                    VALIDATE("Sub Group Vehicle Related", Text);
            end;

            trigger OnValidate()
            begin
                SubGroup.RESET;
                SubGroup.SETFILTER(Code, "Sub Group Vehicle Related");
                IF NOT SubGroup.FINDFIRST THEN
                    ERROR(C_BSS_ERR003, "Sub Group Vehicle Related");
            end;
        }
        field(1044536; "Position Group For Car wash"; Code[80])
        {
            Caption = 'Position Group For Car wash';

            trigger OnLookup()
            var
                Text: Text[200];
            begin
                LookUpPositionFilter2(Text);
                IF Text <> '' THEN
                    VALIDATE("Position Group For Car wash", Text);
            end;

            trigger OnValidate()
            begin
                PositionGroup.RESET;
                PositionGroup.SETFILTER(Code, "Position Group For Car wash");
                IF NOT PositionGroup.FINDFIRST THEN
                    ERROR(C_BSS_ERR001, "Position Group For Car wash");
            end;
        }
        field(1044537; "Position Group For Balancing"; Code[80])
        {
            Caption = 'Position Group For Balancing';

            trigger OnLookup()
            var
                Text: Text[200];
            begin
                LookUpPositionFilter2(Text);
                IF Text <> '' THEN
                    VALIDATE("Position Group For Balancing", Text);
            end;

            trigger OnValidate()
            begin
                PositionGroup.RESET;
                PositionGroup.SETFILTER(Code, "Position Group For Balancing");
                IF NOT PositionGroup.FINDFIRST THEN
                    ERROR(C_BSS_ERR001, "Position Group For Balancing");
            end;
        }
        field(1044538; "Position Group For Alignment"; Code[80])
        {
            Caption = 'Position Group For Alignment';

            trigger OnLookup()
            var
                Text: Text[200];
            begin
                LookUpPositionFilter2(Text);
                IF Text <> '' THEN
                    VALIDATE("Position Group For Alignment", Text);
            end;

            trigger OnValidate()
            begin
                PositionGroup.RESET;
                PositionGroup.SETFILTER(Code, "Position Group For Alignment");
                IF NOT PositionGroup.FINDFIRST THEN
                    ERROR(C_BSS_ERR001, "Position Group For Alignment");
            end;
        }
        field(1044539; "Sub Group Boutique"; Code[50])
        {
            Caption = 'Sub Group Boutique';

            trigger OnLookup()
            var
                Text: Text[200];
            begin
                LookUpSubGroupFilter2(Text, "Main group Accessories");
                IF Text <> '' THEN
                    VALIDATE("Sub Group Boutique", Text);
            end;

            trigger OnValidate()
            begin
                SubGroup.RESET;
                SubGroup.SETFILTER(Code, "Sub Group Boutique");
                IF NOT SubGroup.FINDFIRST THEN
                    ERROR(C_BSS_ERR003, "Sub Group Boutique");
            end;
        }
        field(1044540; "Position Group T(QRST) Index"; Text[80])
        {
            Caption = 'Position Group T(QRST) Index';

            trigger OnLookup()
            var
                Text: Text[200];
            begin
                LookUpPositionFilter2(Text);
                IF Text <> '' THEN
                    VALIDATE("Position Group T(QRST) Index", Text);
            end;

            trigger OnValidate()
            begin
                PositionGroup.RESET;
                PositionGroup.SETFILTER(Code, "Position Group T(QRST) Index");
                IF NOT PositionGroup.FINDFIRST THEN
                    ERROR(C_BSS_ERR001, "Position Group T(QRST) Index");
            end;
        }
        field(1044541; "Position Group V Index"; Text[80])
        {
            Caption = 'Position Group V Index';

            trigger OnLookup()
            var
                Text: Text[200];
            begin
                LookUpPositionFilter2(Text);
                IF Text <> '' THEN
                    VALIDATE("Position Group V Index", Text);
            end;

            trigger OnValidate()
            begin
                PositionGroup.RESET;
                PositionGroup.SETFILTER(Code, "Position Group V Index");
                IF NOT PositionGroup.FINDFIRST THEN
                    ERROR(C_BSS_ERR001, "Position Group V Index");
            end;
        }
        field(1044542; "Position Group H Index"; Text[50])
        {
            Caption = 'Position Group H Index';

            trigger OnLookup()
            var
                Text: Text[200];
            begin
                LookUpPositionFilter2(Text);
                IF Text <> '' THEN
                    VALIDATE("Position Group H Index", Text);
            end;

            trigger OnValidate()
            begin
                PositionGroup.RESET;
                PositionGroup.SETFILTER(Code, "Position Group H Index");
                IF NOT PositionGroup.FINDFIRST THEN
                    ERROR(C_BSS_ERR001, "Position Group H Index");
            end;
        }
        field(1044543; "Position Group WZY Index"; Text[50])
        {
            Caption = 'Position Group WZY Index';

            trigger OnLookup()
            var
                Text: Text[200];
            begin
                LookUpPositionFilter2(Text);
                IF Text <> '' THEN
                    VALIDATE("Position Group WZY Index", Text);
            end;

            trigger OnValidate()
            begin
                PositionGroup.RESET;
                PositionGroup.SETFILTER(Code, "Position Group WZY Index");
                IF NOT PositionGroup.FINDFIRST THEN
                    ERROR(C_BSS_ERR001, "Position Group WZY Index");
            end;
        }
        field(1044544; "Position Group For Tire"; Code[50])
        {
            Caption = 'Position Group For Tire';

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
                    ERROR(C_BSS_ERR001, "Position Group For Tire");
            end;
        }
        field(1044545; "Product Group for PC Tire"; Code[10])
        {
            Caption = 'Product Group for PC Tire';
            //++TWN1.00.122187.QX
            // TableRelation = "Product Group".Code;
            TableRelation = "Item Category".Code where("Parent Category" = filter(<> ''));
            //--TWN1.00.122187.QX
        }
        field(1044546; "Product Group for SUV Tire"; Code[10])
        {
            Caption = 'Product Group for SUV Tire';
            //++TWN1.00.122187.QX
            // TableRelation = "Product Group".Code;
            TableRelation = "Item Category".Code where("Parent Category" = filter(<> ''));
            //--TWN1.00.122187.QX

        }
        field(1044547; "Product Group for LT Tire"; Code[10])
        {
            Caption = 'Product Group for LT Tire';
            //++TWN1.00.122187.QX
            // TableRelation = "Product Group".Code;
            TableRelation = "Item Category".Code where("Parent Category" = filter(<> ''));
            //--TWN1.00.122187.QX

        }
        field(1044548; "Product Group for 2-3 W Tire"; Code[10])
        {
            Caption = 'Product Group for 2-3 W Tire';
            //++TWN1.00.122187.QX
            // TableRelation = "Product Group".Code;
            TableRelation = "Item Category".Code where("Parent Category" = filter(<> ''));
            //--TWN1.00.122187.QX

        }
        field(1044549; "Item Category for Tire"; Code[10])
        {
            Caption = 'Item Category for Tire';
            TableRelation = "Item Category";
        }
        field(1044550; "ManufacturerCode1 for Michelin"; Code[10])
        {
            Caption = 'Manufacturer Code1 for Michelin';
            TableRelation = Manufacturer;
        }
        field(1044551; "ManufacturerCode2 for Michelin"; Code[10])
        {
            Caption = 'Manufacturer Code2 for Michelin';
            TableRelation = Manufacturer;
        }
        field(1044552; "Manufacturer Code for Service"; Code[10])
        {
            Caption = 'Manufacturer Code for Service';
            TableRelation = Manufacturer;
        }
        field(1044553; "Position Group For Tire RelSer"; Code[150])
        {
            Caption = 'Position Group For Tire Related Service';

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
                    ERROR(C_BSS_ERR001, "Position Group For Tire RelSer");
            end;
        }
        field(1044554; "Main group Others"; Code[150])
        {
            Caption = 'Main group Misc';

            trigger OnLookup()
            var
                Text: Text[200];
            begin
                LookUpMainGroupFilter2(Text);
                IF Text <> '' THEN
                    VALIDATE("Main group Others", Text);
            end;

            trigger OnValidate()
            begin
                MainGroup.RESET;
                MainGroup.SETFILTER(Code, "Main group Others");
                IF NOT MainGroup.FINDFIRST THEN
                    ERROR(C_BSS_ERR002, "Main group Others");
            end;
        }
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        C_BSS_ERR001: Label 'Position Group with filter %1 is not found.';
        PositionGroup: Record "Position Group";
        MainGroup: Record "Main Group";
        SubGroup: Record "Sub Group";
        C_BSS_ERR002: Label 'Main Group with filter %1 is not found.';
        C_BSS_ERR003: Label 'Sub Group with filter %1 is not found.';
        //++TWN1.00.122187.QX
        //ProdGroup: Record "Product Group";
        ProdGroup: Record "Item Category";
        //--TWN1.00.122187.QX
        DailyStatisticEntry: Record "Daily Statistic Entry";

    [Scope('OnPrem')]
    procedure LookUpPositionFilter2(var Text: Text[200])
    var
        PositionGroup: Record "Position Group";
        PositionGroupList: Page "Position Group List";
    begin
        PositionGroupList.LOOKUPMODE(TRUE);
        PositionGroupList.SETTABLEVIEW(PositionGroup);
        IF PositionGroupList.RUNMODAL = ACTION::LookupOK THEN BEGIN
            PositionGroupList.GETRECORD(PositionGroup);
            Text += PositionGroupList.GetSelectionFilter;
        END;
    end;

    [Scope('OnPrem')]
    procedure LookUpMainGroupFilter2(var Text: Text[250]): Boolean
    var
        MainGroup: Record "Main Group";
        MainGroupList: Page "Main Group List";
    begin
        MainGroupList.LOOKUPMODE(TRUE);
        MainGroupList.SETTABLEVIEW(MainGroup);
        IF MainGroupList.RUNMODAL = ACTION::LookupOK THEN BEGIN
            MainGroupList.GETRECORD(MainGroup);
            Text += MainGroupList.GetSelectionFilter;
        END;
    end;

    [Scope('OnPrem')]
    procedure LookUpSubGroupFilter2(var Text: Text[250]; MainGrpFilter: Code[200]): Boolean
    var
        SubGroup: Record "Sub Group";
        SubGroupList: Page "Sub Group List";
    begin
        SubGroupList.LOOKUPMODE(TRUE);
        IF MainGrpFilter <> '' THEN
            SubGroup.SETFILTER(SubGroup."Belongs To Main Groupcode", MainGrpFilter);
        SubGroupList.SETTABLEVIEW(SubGroup);
        IF SubGroupList.RUNMODAL = ACTION::LookupOK THEN BEGIN
            SubGroupList.GETRECORD(SubGroup);
            Text += SubGroupList.GetSelectionFilter;
        END;
    end;

    [Scope('OnPrem')]
    procedure LookUpProdGroupFilter2(var Text: Text[200]): Boolean
    var
        //++TWN1.00.122187.QX
        //ProdGroup: Record "Product Group";
        // ProdGroupList: Page "Product Groups";
        ProdGroup: Record "Item Category";
        ProdGroupList: Page "Item Categories";
    //--TWN1.00.122187.QX
    begin
        //++TWN1.00.122187.QX
        ProdGroup.SetFilter("Parent Category", '<>%1', '');
        //--TWN1.00.122187.QX
        ProdGroupList.LOOKUPMODE(TRUE);
        ProdGroupList.SETTABLEVIEW(ProdGroup);
        IF ProdGroupList.RUNMODAL = ACTION::LookupOK THEN BEGIN
            ProdGroupList.GETRECORD(ProdGroup);
            Text += ProdGroupList.GetSelectionFilter;
        END;
    end;

    [Scope('OnPrem')]
    procedure TRSFilterMainGroup(FilterFieldP: Text[250]; FilterStringP: Text[250]) Ok: Boolean
    begin
        MainGroup.SETFILTER(MainGroup.Code, FilterStringP);
        IF MainGroup.FINDSET THEN
            REPEAT
                IF FilterFieldP = MainGroup.Code THEN
                    Ok := TRUE;
            UNTIL (MainGroup.NEXT = 0) OR Ok;
    end;

    [Scope('OnPrem')]
    procedure TRSFilterSubGroup(FilterFieldP: Text[250]; FilterStringP: Text[250]) Ok: Boolean
    begin
        SubGroup.SETFILTER(SubGroup.Code, FilterStringP);
        IF SubGroup.FINDSET THEN
            REPEAT
                IF FilterFieldP = SubGroup.Code THEN
                    Ok := TRUE;
            UNTIL (SubGroup.NEXT = 0) OR Ok;
    end;
}


