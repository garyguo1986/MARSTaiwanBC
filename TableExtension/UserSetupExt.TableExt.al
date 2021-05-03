tableextension 1073873 "User Setup Ext" extends "User Setup"
{

    // +--------------------------------------------------------------+
    // | @ 2017 incadea Taiwan Limited                                |
    // +--------------------------------------------------------------+
    // | PURPOSE: MARS_TWN                                            |
    // |                                                              |
    // | REMARK :                                                     |
    // +--------------------------------------------------------------+

    // VERSION     ID          WHO    DATE        DESCRIPTION
    // TWN.01.01   RGS_TWN-459 AH     2017-06-02  Add New Field 50000 "Zone Code"

    // +--------------------------------------------------------------+
    // | @ 2020 incadea China Limited                                 |
    // +--------------------------------------------------------------+
    // | PURPOSE: MARS_TWN                                            |
    // |                                                              |
    // | REMARK :                                                     |
    // +--------------------------------------------------------------+

    // VERSION       ID            WHO    DATE        DESCRIPTION
    // RGS_TWN-872   122137        GG     2020-10-13  New field "Not Block Item Manufacturer"    

    fields
    {
        field(50000; "Zone Code"; Code[20])
        {
            Caption = 'Zone Code';
            Description = 'TWN.01.01';
            DataClassification = ToBeClassified;
            trigger OnLookup()
            var
                textL: Text[250];
            begin
                textL := '';
                IF LookUpZoneFilter(textL) THEN
                    "Zone Code" := textL;
            end;
        }
        field(50001; "Not Block Item Manufacturer"; Boolean)
        {
            Caption = 'Not Block Item Manufacturer';
            Description = '122137';
            DataClassification = ToBeClassified;
        }
    }
    procedure LookUpZoneFilter(var Text: Text[250]): Boolean
    var
        DimensionValue: Record "Dimension Value";
        SCL: Record "Service Center";
        DimensionValueList: Page "Dimension Value List";
        GeneralFunctions: Codeunit "General Functions";
        RCCodeL: Code[20];
    begin
        //++Inc.TWN-459.AH
        RCCodeL := GeneralFunctions.GetSCCode();
        SCL.GET(RCCodeL);

        DimensionValue.RESET;
        DimensionValue.SETRANGE("Dimension Code", SCL."Zone Dimension");
        DimensionValueList.LOOKUPMODE(TRUE);
        DimensionValueList.SETTABLEVIEW(DimensionValue);
        IF DimensionValueList.RUNMODAL = ACTION::LookupOK THEN BEGIN
            DimensionValueList.GETRECORD(DimensionValue);
            Text += DimensionValueList.GetSelectionFilter;
            EXIT(TRUE);
        END ELSE
            EXIT(FALSE);
        //--Inc.TWN-459.AH
    end;
}
