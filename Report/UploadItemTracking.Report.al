report 1044880 "Upload Item Tracking"
{
    // +--------------------------------------------------------------+
    // | @ 2019 incadea Taiwan Limited                                |
    // +--------------------------------------------------------------+
    // | PURPOSE: MARS_TWN                                            |
    // |                                                              |
    // | REMARK :                                                     |
    // +--------------------------------------------------------------+

    // VERSION       ID            WHO    DATE        DESCRIPTION
    // RGS_TWN-848   120846        GG     2019-11-18  New object  

    Caption = 'Upload Item Tracking';
    ProcessingOnly = true;
    requestpage
    {
        layout
        {
            area(content)
            {
                field(FileName; FileNameG)
                {
                    Caption = 'File Name';
                    trigger OnAssistEdit()
                    var
                        FileMgtL: Codeunit "File Management";
                        ClientFileNameL: Text;
                        C_TP_INF001L: Label 'Item Tracking';
                        C_TP_INF002L: Label 'Excel Workbook (*.xls*)|*.xls*';
                        C_TP_INF003L: Label '*.*';
                    begin
                        FileNameG := FileMgtL.UploadFileWithFilter(C_TP_INF001L, ClientFileNameL, C_TP_INF002L, C_TP_INF003L);
                    end;
                }
            }
        }
        actions
        {
            area(processing)
            {
            }
        }
    }
    trigger OnInitReport()
    begin

    end;

    trigger OnPreReport()
    begin
        UpdateItemTrackingExcelG.ReadExcelToTable(FileNameG);
    end;

    trigger OnPostReport()
    begin

    end;

    var
        UpdateItemTrackingExcelG: Codeunit "TW Update Item Tracking Excel";
        FileNameG: Text;
        C_TWN_ERR001: Label 'Please select an excel file.';
        C_TWN_Text001: Label 'Success';
}
