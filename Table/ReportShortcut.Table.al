table 1044861 "Report Shortcut"
{
    // +--------------------------------------------------------------+
    // | @ 2017 incadea Taiwan Limited                                |
    // +--------------------------------------------------------------+
    // | PURPOSE: MARS_TWN                                            |
    // |                                                              |
    // | REMARK :                                                     |
    // +--------------------------------------------------------------+
    // 
    // VERSION       ID          WHO    DATE        DESCRIPTION
    // TWN.01.04     RGS_TWN-617 NN     2017-05-02  INITIAL RELEASE

    DataPerCompany = false;

    fields
    {
        field(1; "Report Area"; Option)
        {
            OptionMembers = Sales,Purchase,Inventory,Finance,Management,Marketing;
        }
        field(2; "Report ID"; Integer)
        {
        }
        field(3; "Report Name"; Text[50])
        {
            CalcFormula = Lookup(AllObjWithCaption."Object Caption" WHERE("Object Type" = CONST(Report),
                                                                           "Object ID" = FIELD("Report ID")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(4; Description; Text[50])
        {
        }
    }

    keys
    {
        key(Key1; "Report Area", "Report ID")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

