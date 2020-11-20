table 50005 "TWN Performance Buffer"
{
    // +--------------------------------------------------------------+
    // | @ 2017 incadea Taiwan Limited                                |
    // +--------------------------------------------------------------+
    // | PURPOSE: MARS_TWN                                            |
    // |                                                              |
    // +--------------------------------------------------------------+
    // 
    // VERSION       ID          WHO    DATE        DESCRIPTION
    // TWN.01.01     RGS_TWN_459 AH     2017-06-02  Upgraded from R3
    // RGS_TWN-888   122187	     QX	    2020-10-26  Remove field Replication Filter because table Replication Filter was removed

    Caption = 'Performance Buffer';

    fields
    {
        field(1; "Dealer Code"; Code[20])
        {
            Caption = 'Dealer Code';
        }
        field(2; "Responsibility center"; Code[10])
        {
            Caption = 'Responsibility center';
            TableRelation = "Service Center";
        }
        field(3; Month; Integer)
        {
            Caption = 'Month';
        }
        field(4; Year; Integer)
        {
            Caption = 'Year';
        }
        field(5; "Total Turnover"; Decimal)
        {
            Caption = 'Total Turnover';
        }
        field(7; "No. of Tyres Sold"; Decimal)
        {
            Caption = 'No. of Tyres Sold';
        }
        field(8; "No. of Tyres Sold Retail"; Decimal)
        {
            Caption = 'No. of Tyres Sold Retail';
        }
        field(9; "No. of Quotation"; Decimal)
        {
            Caption = 'No. of Quotation Converted';
        }
        field(10; "No. of Invoice"; Decimal)
        {
            Caption = 'No. of Invoice';
        }
        field(11; "No. of Cross Selling Invoice"; Decimal)
        {
            Caption = 'No. of Cross Selling Invoice';
        }
        field(13; "Total services Revenue"; Decimal)
        {
            Caption = 'Total services Revenue';
        }
        field(14; "No. of Balancing"; Decimal)
        {
            Caption = 'No. of Balancing';
        }
        field(15; "No. of Aligment"; Decimal)
        {
            Caption = 'No. of Aligment';
        }
        field(16; "No. of Employee"; Integer)
        {
            Caption = 'No. of Employee';
        }
        field(17; "No. of Bays"; Integer)
        {
            Caption = 'No. of Bays';
        }
        field(18; "Month Start Date"; Date)
        {
            Caption = 'Posting Date';
        }
        field(19; "Month End Date"; Date)
        {
            Caption = 'Month End Date';
        }
        field(20; "Sync. Status"; Option)
        {
            Description = 'IT_5746';
            OptionCaption = 'Insert,Modify,Synchronized';
            OptionMembers = Insert,Modify,Synchronized;
        }
        field(21; "Sent Date/Time"; DateTime)
        {
            Description = 'IT_5746';
        }
        field(22; "Error Occurred"; Boolean)
        {
            Description = 'IT_5746';
        }
        field(23; "Zone Code"; Code[20])
        {
            Caption = 'Zone Code';
            Description = 'IT_5894';
        }
        field(24; "No. of SB"; Decimal)
        {
            Caption = 'No. of SB';
            Description = 'IT_6008';
        }
        field(25; "No. of SB converted"; Decimal)
        {
            Caption = 'No. of SB converted';
            Description = 'IT_6008';
        }
        field(26; "Total Cash Sales"; Decimal)
        {
            Caption = 'No. of Cash Sales';
            Description = 'IT_6010';
        }
        field(27; "No. of Tyres Sold with rel ser"; Decimal)
        {
            Caption = 'No. of Tyres Sold with rel ser';
            Description = 'IT_6000';
        }
        field(28; "Turnover of invoices with ser"; Decimal)
        {
            Description = 'IT_6009';
        }
        field(1017361; "Central Maintenance"; Boolean)
        {
            Caption = 'Central Maintenance';
            Description = 'IT_7558';
        }
        field(1028275; "Deleted By HQ"; Boolean)
        {
            Caption = 'Deleted by HQ';
            Description = 'IT_7558';
        }
        field(1028276; "Replication Date"; DateTime)
        {
            Caption = 'Replication Date';
            Description = 'IT_7558';
            Editable = false;
        }
        field(1028277; "Repl. Post Run Finished"; Boolean)
        {
            Caption = 'Repl. Post Run Finished';
            Description = 'IT_7558';
        }

        //++TWN1.00.122187.QX
        field(1028278; "Replication Filter"; Code[2])
        {
            Caption = 'Replication Filter';
            Description = 'IT_7558';
            // TableRelation = "Replication Filter";
            ObsoleteState = Removed;
            ObsoleteReason = 'Related table ''Replication Filter'' is removed.';
        }
        //--TWN1.00.122187.QX
    }

    keys
    {
        key(Key1; "Dealer Code", "Responsibility center", Month, Year, "Month Start Date")
        {
            Clustered = true;
            SumIndexFields = "No. of Tyres Sold", "No. of Tyres Sold Retail", "No. of Quotation", "No. of Invoice", "No. of Cross Selling Invoice", "Total Turnover", "Total services Revenue", "No. of Balancing", "No. of Aligment", "No. of SB", "No. of SB converted", "Total Cash Sales", "No. of Tyres Sold with rel ser", "Turnover of invoices with ser";
        }
        key(Key2; "Month Start Date")
        {
            SumIndexFields = "No. of Tyres Sold", "No. of Tyres Sold Retail", "No. of Quotation", "No. of Invoice", "No. of Cross Selling Invoice", "Total Turnover", "Total services Revenue", "No. of Balancing", "No. of Aligment", "No. of SB", "No. of SB converted", "Total Cash Sales", "No. of Tyres Sold with rel ser", "Turnover of invoices with ser";
        }
        key(Key3; "Sync. Status", "Error Occurred")
        {
        }
        key(Key4; "Dealer Code", "Zone Code", "Responsibility center", Month, Year, "Month Start Date")
        {
            SumIndexFields = "No. of Tyres Sold", "No. of Tyres Sold Retail", "No. of Quotation", "No. of Invoice", "No. of Cross Selling Invoice", "Total Turnover", "Total services Revenue", "No. of Balancing", "No. of Aligment", "No. of SB", "No. of SB converted", "Total Cash Sales", "No. of Tyres Sold with rel ser", "Turnover of invoices with ser";
        }
    }

    fieldgroups
    {
    }
}

