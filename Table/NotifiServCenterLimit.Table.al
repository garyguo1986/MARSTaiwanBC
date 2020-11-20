table 1044880 "Notifi. Serv. Center Limit"
{
    // +--------------------------------------------------------------
    // | ?2019 Incadea China Software System                          |
    // +--------------------------------------------------------------+
    // | PURPOSE: Local Customization                                 |
    // |                                                              |
    // | REMARK :                                                     |
    // +--------------------------------------------------------------+
    // VERSION     ID                  WHO    DATE        DESCRIPTION
    // 119387      RGS_TWN-839         WP     2019-05-08  Create by


    fields
    {
        field(1; "Company Name"; Text[30])
        {
            Caption = 'Name';
            TableRelation = Company;
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(2; "Tenant ID"; Text[128])
        {
            Caption = 'Tenant ID';
        }
        field(10; "Service Center"; Code[10])
        {
        }
    }

    keys
    {
        key(Key1; "Company Name", "Tenant ID", "Service Center")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

