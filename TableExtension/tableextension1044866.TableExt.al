tableextension 1044866 tableextension1044866 extends "Contact Search Result"
{
    // +--------------------------------------------------------------+
    // | ?2005 ff. Begusch Software Systeme                          |
    // #3..20
    // 070000 IT_20000 1CF 2013-05-21  Merged to NAV 7: Add new field Country, "Country/Region Code"
    // #22..26
    // 
    // 
    // +--------------------------------------------------------------+
    // | @ 2017 incadea Taiwan Limited                                |
    // +--------------------------------------------------------------+
    // | PURPOSE: MARS_TWN                                            |
    // |                                                              |
    // | REMARK :                                                     |
    // +--------------------------------------------------------------+
    // 
    // VERSION       ID          WHO    DATE        DESCRIPTION
    // RGS_TWN-519               AH     2017-05-24  Add two fields "Mobile Phone No.", "VAT Registration No.".
    // RGS_TWN-7885  121696     QX   2020-05-25  Added a field Registration Date
    fields
    {
        field(1044860; "Mobile Phone No."; Text[30])
        {
            Caption = 'Mobile Phone No.';
            Description = 'RGS_TWN-519';
        }
        field(1044861; "VAT Registration No."; Text[30])
        {
            Caption = 'VAT Registration No.';
            Description = 'RGS_TWN-519';
        }
        field(1044862; "Registration Date"; Date)
        {
            Caption = 'Registration Date';
            Description = '121696';
        }
    }

    var
        Depot: Record "Tire Hotel";
}

