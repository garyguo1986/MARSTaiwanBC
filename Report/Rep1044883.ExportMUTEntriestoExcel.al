report 1044883 "Export MUT Entries to Excel"
{
    // +--------------------------------------------------------------+
    // | @ 2019 incadea China Limited                                |
    // +--------------------------------------------------------------+
    // | PURPOSE: MARS_TWN                                            |
    // |                                                              |
    // | REMARK :                                                     |
    // +--------------------------------------------------------------+
    // 
    // VERSION      ID          WHO    DATE        DESCRIPTION
    // RGS_TWN-1004             GG     2021-08-02  Copy the report from 1044800 
    Caption = 'Export MUT Entries to Excel';
    ProcessingOnly = true;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Usage Tracking Entry"; "Usage Tracking Entry")
        {
            DataItemTableView = SORTING("Tenant ID", "Company Name", "Entry No.");
            RequestFilterFields = "Creation Date", "Tracking Function Code", "Service Center Code", "User ID";

            trigger OnAfterGetRecord()
            begin
                MakeExcelDataBody("Tenant ID", Format("Log Type"), "Reason Code", "Tracking Function Code", "Tracking Function Name",
                  "Company Name", "Company ID", "User ID", "Service Center Code", "Service Center Name", Format("Caller Object Type"),
                  Format("Caller Object ID"), "Technical Object Name", "Tracking Area Code", Format("Creation Date"),
                  Format("Creation Time"), Format("Creation DateTime"), Format("Day of Creation Month"), Format("Week of Creation Date"),
                  Format("Month of Creation Date"), Format("Year of Creation Date"), "Month/Year of Creation Date", Format("Day of Creation Week"),
                  //++BSS.TFS_14781.CM
                  //"Time Slot");
                  "Time Slot",
                  "Customer Tracking ID"
                  );
                //--BSS.TFS_14781.CM
            end;

            trigger OnPreDataItem()
            begin
                MakeExcelDataBodyBold(FieldCaption("Tenant ID"), FieldCaption("Log Type"), FieldCaption("Reason Code"),
                  FieldCaption("Tracking Function Code"), FieldCaption("Tracking Function Name"), FieldCaption("Company Name"),
                  FieldCaption("Company ID"), FieldCaption("User ID"), FieldCaption("Service Center Code"), FieldCaption("Service Center Name"),
                  FieldCaption("Caller Object Type"), FieldCaption("Caller Object ID"), FieldCaption("Technical Object Name"),
                  FieldCaption("Tracking Area Code"), FieldCaption("Creation Date"), FieldCaption("Creation Time"),
                  FieldCaption("Creation DateTime"), FieldCaption("Day of Creation Month"), FieldCaption("Week of Creation Date"),
                  FieldCaption("Month of Creation Date"), FieldCaption("Year of Creation Date"), FieldCaption("Month/Year of Creation Date"),
                  //++BSS.TFS_14781.CM
                  //FIELDCAPTION("Day of Creation Week") , FIELDCAPTION("Time Slot"));
                  FieldCaption("Day of Creation Week"), FieldCaption("Time Slot"),
                  FieldCaption("Customer Tracking ID")
                  );
                //--BSS.TFS_14781.CM
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPostReport()
    begin
        CreateExcelBook;
    end;

    trigger OnPreReport()
    begin
        CompanyInfo.Get;

        Filters := "Usage Tracking Entry".GetFilters;

        MakeExcelInfo;
    end;

    var
        CompanyInfo: Record "Company Information";
        ExcelBuf: Record "Excel Buffer" temporary;
        C_BSS_EXC001: Label 'Company Name';
        C_BSS_EXC002: Label 'Report Name';
        C_BSS_INF001: Label 'MUT Entries';
        Filters: Text;

    local procedure ___EXCEL___()
    begin
    end;

    local procedure MakeExcelInfo()
    begin
        //++BSS.IT_21698.1CF
        //ExcelBuf.SetUseInfoSheet;
        //ExcelBuf.AddInfoColumn(FORMAT(C_BSS_EXC001),FALSE,'',TRUE,FALSE,FALSE,'',1);
        //ExcelBuf.AddInfoColumn(COMPANYNAME,FALSE,'',TRUE,FALSE,FALSE,'',1);
        //ExcelBuf.NewRow;
        //ExcelBuf.NewRow;
        //ExcelBuf.AddInfoColumn(FORMAT(C_BSS_EXC002),FALSE,'',TRUE,FALSE,FALSE,'',1);
        //ExcelBuf.AddInfoColumn(FORMAT(C_BSS_INF001),FALSE,'',TRUE,FALSE,FALSE,'',1);
        //ExcelBuf.NewRow;
        //ExcelBuf.AddInfoColumn('Printed on',FALSE,'',TRUE,FALSE,FALSE,'',1);
        //ExcelBuf.AddInfoColumn(TODAY,FALSE,'',TRUE,FALSE,FALSE,'',1);
        //
        //
        //ExcelBuf.NewRow;
        //ExcelBuf.AddInfoColumn('Printed By',FALSE,'',TRUE,FALSE,FALSE,'',1);
        //ExcelBuf.AddInfoColumn(USERID, FALSE,'',FALSE,FALSE,FALSE,'',1);

        ExcelBuf.SetUseInfoSheet;
        ExcelBuf.AddInfoColumn(Format(C_BSS_EXC001), false, true, false, false, '', 1);
        ExcelBuf.AddInfoColumn(CompanyName, false, true, false, false, '', 1);
        ExcelBuf.NewRow;
        ExcelBuf.NewRow;
        ExcelBuf.AddInfoColumn(Format(C_BSS_EXC002), false, true, false, false, '', 1);
        ExcelBuf.AddInfoColumn(Format(C_BSS_INF001), false, true, false, false, '', 1);
        ExcelBuf.NewRow;
        ExcelBuf.AddInfoColumn('Printed on', false, true, false, false, '', 1);
        ExcelBuf.AddInfoColumn(Today, false, true, false, false, '', 1);


        ExcelBuf.NewRow;
        ExcelBuf.AddInfoColumn('Printed By', false, true, false, false, '', 1);
        ExcelBuf.AddInfoColumn(UserId, false, false, false, false, '', 1);
        //--BSS.IT_21698.1CF
        ExcelBuf.ClearNewRow;
        MakeExcelDataHeader;
    end;

    local procedure MakeExcelDataHeader()
    begin
        ExcelBuf.AddColumn(C_BSS_INF001 + '(' + CopyStr(CurrReport.ObjectId(false), 8) + ')', false, '', true, false, false, '', 1);
        ExcelBuf.AddColumn('', false, '', true, false, false, '', 1);
        ExcelBuf.AddColumn('', false, '', true, false, false, '', 1);
        ExcelBuf.AddColumn('', false, '', true, false, false, '', 1);
        ExcelBuf.AddColumn('', false, '', true, false, false, '', 1);
        //++BSS.TFS_14781.CM
        ExcelBuf.AddColumn('', false, '', true, false, false, '', 1);
        //--BSS.TFS_14781.CM
        ExcelBuf.AddColumn(Today, false, '', false, false, false, '', 1);
        ExcelBuf.AddColumn(Time, false, '', false, false, false, '', 1);
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn(CompanyInfo.Name + ' ' + CompanyInfo."Name 2", false, '', true, false, false, '', 1);
        ExcelBuf.AddColumn('', false, '', true, false, false, '', 1);
        ExcelBuf.AddColumn('', false, '', true, false, false, '', 1);
        ExcelBuf.AddColumn('', false, '', true, false, false, '', 1);
        ExcelBuf.AddColumn('', false, '', true, false, false, '', 1);
        ExcelBuf.AddColumn('', false, '', true, false, false, '', 1);
        ExcelBuf.AddColumn(UserId, false, '', false, false, false, '', 1);
        ExcelBuf.NewRow;
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn(Filters, false, '', false, false, false, '', 1);
        ExcelBuf.NewRow;
    end;

    local procedure CreateExcelBook()
    var
        FileNameL: Text;
    begin
        //++BSS.IT_20913.SG
        //ExcelBuf.CreateBookAndOpenExcel(C_BSS_INF001,C_BSS_INF001,COMPANYNAME,USERID);
        ExcelBuf.CreateBookAndOpenExcel(FileNameL, C_BSS_INF001, C_BSS_INF001, CompanyName, UserId);
        //--BSS.IT_20913.SG
    end;

    local procedure MakeExcelDataBody(par1: Text; par2: Text; par3: Text; par4: Text; par5: Text; par6: Text; par7: Text; par8: Text; par9: Text; par10: Text; par11: Text; par12: Text; par13: Text; par14: Text; par15: Text; par16: Text; par17: Text; par18: Text; par19: Text; par20: Text; par21: Text; par22: Text; par23: Text; par24: Text; par25: Text)
    var
        BlankFiller: Text[250];
    begin
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn(par1, false, '', false, false, false, '', 1);
        ExcelBuf.AddColumn(par2, false, '', false, false, false, '', 1);
        ExcelBuf.AddColumn(par3, false, '', false, false, false, '', 1);
        ExcelBuf.AddColumn(par4, false, '', false, false, false, '', 1);
        ExcelBuf.AddColumn(par5, false, '', false, false, false, '', 1);
        //++BSS.TFS_14781.CM
        //ExcelBuf.AddColumn(par25, false, '', false, false, false, '', 1);
        //--BSS.TFS_14781.CM
        ExcelBuf.AddColumn(par6, false, '', false, false, false, '', 1);
        ExcelBuf.AddColumn(par7, false, '', false, false, false, '', 1);
        ExcelBuf.AddColumn(par8, false, '', false, false, false, '', 1);
        ExcelBuf.AddColumn(par9, false, '', false, false, false, '', 1);
        ExcelBuf.AddColumn(par10, false, '', false, false, false, '', 1);
        ExcelBuf.AddColumn(par11, false, '', false, false, false, '', 1);
        ExcelBuf.AddColumn(par12, false, '', false, false, false, '', 0);
        ExcelBuf.AddColumn(par13, false, '', false, false, false, '', 1);
        ExcelBuf.AddColumn(par14, false, '', false, false, false, '', 1);

        ExcelBuf.AddColumn(par15, false, '', false, false, false, '', 1);
        ExcelBuf.AddColumn(par16, false, '', false, false, false, '', 1);
        ExcelBuf.AddColumn(par17, false, '', false, false, false, '', 1);
        ExcelBuf.AddColumn(par18, false, '', false, false, false, '', 0);
        ExcelBuf.AddColumn(par19, false, '', false, false, false, '', 0);
        ExcelBuf.AddColumn(par20, false, '', false, false, false, '', 0);
        ExcelBuf.AddColumn(par21, false, '', false, false, false, '', 0);
        ExcelBuf.AddColumn(par22, false, '', false, false, false, '', 1);
        ExcelBuf.AddColumn(par23, false, '', false, false, false, '', 0);
        ExcelBuf.AddColumn(par24, false, '', false, false, false, '', 1);
    end;

    local procedure MakeExcelDataBodyBold(par1: Text; par2: Text; par3: Text; par4: Text; par5: Text; par6: Text; par7: Text; par8: Text; par9: Text; par10: Text; par11: Text; par12: Text; par13: Text; par14: Text; par15: Text; par16: Text; par17: Text; par18: Text; par19: Text; par20: Text; par21: Text; par22: Text; par23: Text; par24: Text; par25: Text)
    var
        BlankFiller: Text[250];
    begin
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn(par1, false, '', true, false, false, '', 1);
        ExcelBuf.AddColumn(par2, false, '', true, false, false, '', 1);
        ExcelBuf.AddColumn(par3, false, '', true, false, false, '', 1);
        ExcelBuf.AddColumn(par4, false, '', true, false, false, '', 1);
        ExcelBuf.AddColumn(par5, false, '', true, false, false, '', 1);
        //++BSS.TFS_14781.CM
        //ExcelBuf.AddColumn(par25, false, '', true, false, false, '', 1);
        //--BSS.TFS_14781.CM
        ExcelBuf.AddColumn(par6, false, '', true, false, false, '', 1);
        ExcelBuf.AddColumn(par7, false, '', true, false, false, '', 1);
        ExcelBuf.AddColumn(par8, false, '', true, false, false, '', 1);
        ExcelBuf.AddColumn(par9, false, '', true, false, false, '', 1);
        ExcelBuf.AddColumn(par10, false, '', true, false, false, '', 1);
        ExcelBuf.AddColumn(par11, false, '', true, false, false, '', 1);
        ExcelBuf.AddColumn(par12, false, '', true, false, false, '', 1);
        ExcelBuf.AddColumn(par13, false, '', true, false, false, '', 1);
        ExcelBuf.AddColumn(par14, false, '', true, false, false, '', 1);

        ExcelBuf.AddColumn(par15, false, '', true, false, false, '', 1);
        ExcelBuf.AddColumn(par16, false, '', true, false, false, '', 1);
        ExcelBuf.AddColumn(par17, false, '', true, false, false, '', 1);
        ExcelBuf.AddColumn(par18, false, '', true, false, false, '', 1);
        ExcelBuf.AddColumn(par19, false, '', true, false, false, '', 1);
        ExcelBuf.AddColumn(par20, false, '', true, false, false, '', 1);
        ExcelBuf.AddColumn(par21, false, '', true, false, false, '', 1);
        ExcelBuf.AddColumn(par22, false, '', true, false, false, '', 1);
        ExcelBuf.AddColumn(par23, false, '', true, false, false, '', 1);
        ExcelBuf.AddColumn(par24, false, '', true, false, false, '', 1);
    end;
}

