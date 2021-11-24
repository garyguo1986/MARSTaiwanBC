codeunit 1044870 "TWN App Upgrade Trigger"
{
    Subtype = Upgrade;
    trigger OnUpgradePerCompany()
    var
        MyAppInfoL: ModuleInfo;
        VersionL: Version;
    begin
        NavApp.GetCurrentModuleInfo(MyAppInfoL);
        VersionL := MyAppInfoL.AppVersion();

        UpgradeV1_0_0_17(VersionL);
    end;

    trigger OnUpgradePerDatabase()
    begin

    end;


    local procedure UpgradeV1_0_0_17(var VersionP: Version)
    var
        IsCurrentVersionL: Boolean;
        ReportSelectionsL: Record "Report Selections";
    begin
        IsCurrentVersionL := (VersionP.Major = 1) and (VersionP.Minor = 0) and (VersionP.Build = 0) and (VersionP.Revision = 17);
        if not IsCurrentVersionL then
            exit;

        ReportSelectionsL.Reset();
        ReportSelectionsL.SetRange(Usage, ReportSelectionsL.Usage::Inv1);
        ReportSelectionsL.SetRange("Report ID", Report::"Transfer Order");
        ReportSelectionsL.DeleteAll();

        //key(Key1; Usage, "Cash Register No.", Sequence)
        ReportSelectionsL.Reset();
        ReportSelectionsL.SetRange(Usage, ReportSelectionsL.Usage::Inv1);
        ReportSelectionsL.SetRange("Report ID", Report::"Transfer Order TW");
        if ReportSelectionsL.IsEmpty then begin
            ReportSelectionsL.Init();
            ReportSelectionsL.Validate(Usage, ReportSelectionsL.Usage::Inv1);
            ReportSelectionsL.Validate("Cash Register No.", '');
            ReportSelectionsL.Validate(Sequence, '1');
            ReportSelectionsL.Validate("Report ID", Report::"Transfer Order TW");
            ReportSelectionsL.Insert(true);
        end;
    end;
}
