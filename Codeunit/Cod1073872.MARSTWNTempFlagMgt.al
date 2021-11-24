codeunit 1073872 "MARS TWN Temp Flag Mgt"
{
    procedure FixVehicleCheckStatusForPerformaceReport()
    var
        FixVCStatusForPerReportL: Report "Fix VC Status for Perf. Report";
    begin
        Clear(FixVCStatusForPerReportL);
        FixVCStatusForPerReportL.UseRequestPage(false);
        FixVCStatusForPerReportL.RunModal();
    end;

    procedure IsVehicelCheckStatusFixed(): Boolean
    begin
        if not MARSTWNTempFlagSetupG.Get() then begin
            MARSTWNTempFlagSetupG.Init();
            MARSTWNTempFlagSetupG.Insert(true);
            exit(false);
        end;

        exit(MARSTWNTempFlagSetupG."Vehicle Check Status Fixed");
    end;

    procedure FlagVehicleCheckStatus()
    begin
        if not MARSTWNTempFlagSetupG.Get() then begin
            MARSTWNTempFlagSetupG.Init();
            MARSTWNTempFlagSetupG.Insert(true);
            MARSTWNTempFlagSetupG."Vehicle Check Status Fixed" := true;
            MARSTWNTempFlagSetupG.Modify(true);
        end else begin
            MARSTWNTempFlagSetupG."Vehicle Check Status Fixed" := true;
            MARSTWNTempFlagSetupG.Modify(true);
        end;
    end;

    var
        MARSTWNTempFlagSetupG: Record "MARS TWN Temp Flag Setup";
}
