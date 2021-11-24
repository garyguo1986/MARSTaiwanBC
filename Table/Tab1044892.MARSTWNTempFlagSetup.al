table 1044892 "MARS TWN Temp Flag Setup"
{
    Caption = 'MARS TWN Temp Flag Setup';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Code"; Code[10])
        {
            Caption = 'Code';
            DataClassification = ToBeClassified;
        }
        field(21; "Vehicle Check Status Fixed"; Boolean)
        {
            Caption = 'Vehicle Check Status Fix';
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; "Code")
        {
            Clustered = true;
        }
    }

}
