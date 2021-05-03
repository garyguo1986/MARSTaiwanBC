codeunit 1044867 "TW General Single Instance"
{
    Subtype = Normal;
    SingleInstance = true;

    procedure SetAgreementServiceTypeMaster(ServiceTypeMasterP: Code[20])
    begin
        ServiceTypeMasterG := ServiceTypeMasterP;
    end;

    procedure GetAgreementServiceTypeMaster(var ServiceTypeMasterP: Code[20])
    begin
        ServiceTypeMasterP := ServiceTypeMasterG;
    end;

    var
        ServiceTypeMasterG: Code[20];
}
