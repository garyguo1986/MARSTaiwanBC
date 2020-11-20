table 1044867 "TW Performance Buffer"
{
    // +--------------------------------------------------------------+
    // | @ 2019 incadea Taiwan Limited                                |
    // +--------------------------------------------------------------+
    // | PURPOSE: MARS_TWN                                            |
    // |                                                              |
    // | REMARK :                                                     |
    // +--------------------------------------------------------------+
    // 
    // VERSION       ID            WHO    DATE        DESCRIPTION
    // RGS_TWN-809   118849        GG     2019-03-13  New Object
    // RGS_TWN-832   119384        WP     2019-05-10  Add fields "Profit Amt","Total Amt"

    Caption = 'TW Performance Buffer';

    fields
    {
        field(1; "Global Dimension Code 1"; Code[20])
        {
            Caption = 'Dealer Code';
        }
        field(2; "Global Dimension Code 2"; Code[20])
        {
            Caption = 'Zone Code';
        }
        field(3; "Service Center"; Code[10])
        {
            Caption = 'Responsibility center';
            TableRelation = "Service Center";
        }
        field(4; Year; Integer)
        {
            Caption = 'Year';
        }
        field(5; Month; Integer)
        {
            Caption = 'Month';
        }
        field(6; Day; Integer)
        {
            Caption = 'Day';
        }
        field(7; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }
        field(21; "No. of Bays"; Decimal)
        {
            Caption = 'No. of Bays';
            Description = '1-Integer';
        }
        field(22; "Turnover Total Amount"; Decimal)
        {
            Caption = 'Turnover Amount';
            Description = '2';
        }
        field(23; "Average Bays Output"; Decimal)
        {
            Caption = 'Average Bays Output';
            Description = '7';
        }
        field(24; "Turnover Resource Amount"; Decimal)
        {
            Caption = 'Turnover Resource Amount';
            Description = '5';
        }
        field(25; "Sales Invoice Count"; Decimal)
        {
            Caption = 'Sales Invoice Count';
            Description = '9-Integer';
        }
        field(26; "Sales Invoice Count Tyre"; Decimal)
        {
            Caption = 'Sales Invoice Count Tyre';
            Description = '10-Integer';
        }
        field(27; "Sales Invoice Count Oil Filter"; Decimal)
        {
            Caption = 'Sales Invoice Count Oil Filter';
            Description = '11-Integer';
        }
        field(28; "Sales Invoice Count Oil"; Decimal)
        {
            Caption = 'Sales Invoice Count Oil';
            Description = '12-Integer';
        }
        field(29; "Sales Invoice Count Oil Or Fil"; Decimal)
        {
            Caption = 'Sales Invoice Count Oil Or Fil';
            Description = '13-Integer';
        }
        field(30; "Sales Invoice Count Others"; Decimal)
        {
            Caption = 'Sales Invoice Count Others';
            Description = '14-Integer';
        }
        field(31; "Notification Order Count"; Decimal)
        {
            Caption = 'Notification Order Count';
            Description = '15-Integer';
        }
        field(32; "Notification Order Amount"; Decimal)
        {
            Caption = 'Notification Order Amount';
            Description = '16';
        }
        field(33; "Vehicle Check Order Count"; Decimal)
        {
            Caption = 'Vehicle Check Order Count';
            Description = '17-Integer';
        }
        field(34; "Vehicle Check Order Amount"; Decimal)
        {
            Caption = 'Vehicle Check Order Amount';
            Description = '18';
        }
        field(35; "Cross Sales Order Count"; Decimal)
        {
            Caption = 'Cross Sales Order Count';
            Description = '19-Integer';
        }
        field(36; "Cross Sales Order Amount"; Decimal)
        {
            Caption = 'Cross Sales Order Amount';
            Description = '20';
        }
        field(41; "Tyre Sales Quantity"; Decimal)
        {
            Caption = 'Tyre Sales Quantity';
            Description = '21-Integer';
        }
        field(51; "Resource Balance Quantity"; Decimal)
        {
            Caption = 'Resource Balance Quantity';
            Description = '22';
        }
        field(52; "Resource PC Quantity"; Decimal)
        {
            Caption = 'Resource PC Quantity';
            Description = '23';
        }
        field(61; "Average Salary Output"; Decimal)
        {
            Caption = 'Average Salary Output';
            Description = '8';
        }
        field(71; "Turnover Total Tyre Amount"; Decimal)
        {
            Caption = 'Turnover Total Tyre Amount';
            Description = '3';
        }
        field(72; "Turnover Total NonTyre Amount"; Decimal)
        {
            Caption = 'Turnover Total NonTyre Amount';
            Description = '4';
        }
        field(73; "Gross Profit"; Decimal)
        {
            Caption = 'Gross Profit';
            Description = '6';
        }
        field(74; "Profit Amt"; Decimal)
        {
            Description = '119384';
        }
        field(75; "Total Amt"; Decimal)
        {
            Description = '119384';
        }
    }

    keys
    {
        key(Key1; "Global Dimension Code 1", "Global Dimension Code 2", "Service Center", "Posting Date")
        {
            Clustered = true;
            SumIndexFields = "Turnover Total Amount", "Turnover Total Tyre Amount", "Turnover Total NonTyre Amount", "Turnover Resource Amount", "Sales Invoice Count", "Sales Invoice Count Tyre", "Sales Invoice Count Oil Filter", "Sales Invoice Count Oil", "Sales Invoice Count Oil Or Fil", "Sales Invoice Count Others", "Notification Order Count", "Notification Order Amount", "Vehicle Check Order Count", "Vehicle Check Order Amount", "Cross Sales Order Count", "Cross Sales Order Amount", "Tyre Sales Quantity", "Resource Balance Quantity", "Resource PC Quantity";
        }
    }

    fieldgroups
    {
    }
}

