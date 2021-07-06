table 1044881 "Item DOT Entry"
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
    // RGS_TWN-848   120846        GG     2019-11-18  New object
    // RGS_TWN-888   122187	       QX	  2020-10-26  Remove field Replication Filter because table Replication Filter was removed

    fields
    {
        field(1; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = ' ,Tenant,Item,Setup';
            OptionMembers = " ",Tenant,Item,Setup;
        }
        field(2; Tenant; Text[128])
        {
            Caption = 'Tenant';
        }
        field(3; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            TableRelation = IF (Type = FILTER(Item)) Item."No.";
            ValidateTableRelation = false;
        }
        field(21; "Item Description"; Text[100])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup(Item.Description WHERE("No." = FIELD("Item No.")));
            Caption = 'Item Description';
            Editable = false;
        }
        field(6500; "Item Tracking Code"; Code[10])
        {
            Caption = 'Item Tracking Code';
            TableRelation = "Item Tracking Code";
        }
        field(50000; Active; Boolean)
        {
            Caption = 'Active';
        }
        field(50001; "Upload DateTime"; DateTime)
        {
            Caption = 'Upload DateTime';
            Editable = false;
        }
        field(50002; "Upload Date"; Date)
        {
            Caption = 'Upload Date';
            Editable = false;
        }
        field(50003; "Upload Time"; Time)
        {
            Caption = 'Upload Time';
            Editable = false;
        }
        field(50005; "Last Update Date"; Date)
        {
            Caption = 'Last Update Date';
        }
        field(1017361; "Central Maintenance"; Boolean)
        {
            Caption = 'Central Maintenance';
        }
        field(1028275; "Deleted By HQ"; Boolean)
        {
            Caption = 'Deleted by HQ';
        }
        field(1028276; "Replication Date"; DateTime)
        {
            Caption = 'Replication Date';
            Editable = false;
        }
        field(1028277; "Repl. Post Run Finished"; Boolean)
        {
            Caption = 'Repl. Post Run Finished';
        }
        //++TWN1.00.122187.QX
        field(1028278; "Replication Filter"; Code[2])
        {
            Caption = 'Replication Filter';
            // TableRelation = "Replication Filter";
            Description = '122187';
            ObsoleteState = Removed;
            ObsoleteReason = 'Related table ''Replication Filter'' is removed.';
        }
        //--TWN1.00.122187.QX

        field(1059110; "Prevent Synchronization"; Boolean)
        {
            Caption = 'Prevent Synchronization';
        }
        field(1059111; "Prevent Replication"; Boolean)
        {
            Caption = 'Prevent Replication';
        }
    }

    keys
    {
        key(Key1; Type, Tenant, "Item No.", "Upload Date")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        IF (Type = Type::Item) AND ("Replication Date" < CREATEDATETIME(TODAY, 0T)) AND ("Replication Date" <> CREATEDATETIME(0D, 0T)) THEN
            ERROR(STRSUBSTNO(C_TWN_001, Rec."Item No."));
    end;

    trigger OnInsert()
    begin
        IF Type = Type::Item THEN BEGIN
            "Upload DateTime" := CURRENTDATETIME;
            "Upload Date" := TODAY;
            "Upload Time" := TIME;
        END ELSE BEGIN
            "Upload Date" := 0D;
            "Upload Time" := 0T;
            "Upload DateTime" := CREATEDATETIME(0D, 0T);
        END;
    end;

    var
        C_TWN_001: Label 'You can not delete the item %1 line because it has been replicated';
}

