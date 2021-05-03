table 1044890 "Replication Company Old"
{
    Caption = 'Replication Company';
    DataPerCompany = false;
    //ObsoleteState = Removed;
    //ObsoleteReason = 'Replaced by another feature (Data Distribution)';

    fields
    {
        field(1; Name; Text[100])
        {
            Caption = 'Name';
        }
        field(2; "Tenant ID"; Text[128])
        {
            Caption = 'Tenant ID';
        }
        field(3; "Database Name"; Text[250])
        {
            Caption = 'Database Name';
        }
        field(4; "Server Name"; Text[250])
        {
            Caption = 'Server Name';
        }
        field(5; Master; Boolean)
        {
            Caption = 'Master';
        }
        field(6; Staging; Boolean)
        {
            Caption = 'Staging';
        }
        field(7; Reporting; Boolean)
        {
            Caption = 'Reporting';
        }
        field(8; "Synchronization (Master Data)"; Boolean)
        {
            Caption = 'Synchronization (Master Data)';
        }
        field(9; "Synchronization (Reporting)"; Boolean)
        {
            Caption = 'Synchronization (Reporting)';
        }
        field(10; "Selected for Initialization"; Boolean)
        {
            Caption = 'Selected for Initialization';
        }
        field(11; "Last Company Refresh"; DateTime)
        {
            Caption = 'Last Company Refresh';
        }
        // field(20; "Log Entries (Master Data)"; Integer)
        // {
        //     CalcFormula = Count(vi_IFF_Repl_LogView WHERE(direction = CONST('S2D'),
        //                                                    dealer_company = FIELD(Name),
        //                                                    starttime = FIELD("Date Filter")));
        //     Caption = 'Log Entries (Master Data)';
        //     Editable = false;
        //     FieldClass = FlowField;
        // }
        // field(21; "Log Entries (Reporting)"; Integer)
        // {
        //     CalcFormula = Count(vi_IFF_Repl_LogView WHERE(direction = CONST('D2S'),
        //                                                    dealer_company = FIELD(Name),
        //                                                    starttime = FIELD("Date Filter")));
        //     Caption = 'Log Entries (Reporting)';
        //     Editable = false;
        //     FieldClass = FlowField;
        // }
        // field(22; "Date Filter"; DateTime)
        // {
        //     Caption = 'Date Filter';
        //     FieldClass = FlowFilter;
        // }
    }

    keys
    {
        key(Key1; Name, "Tenant ID")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        if Name = '' then
            Error('');
    end;
}

