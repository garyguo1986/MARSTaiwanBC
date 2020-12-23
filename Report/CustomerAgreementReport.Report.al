report 50017 "Customer Agreement Report"
{
    // 
    // +--------------------------------------------------------------+
    // | @ 2017 incadea Taiwan Limited                                |
    // +--------------------------------------------------------------+
    // | PURPOSE: MARS_TWN                                            |
    // |                                                              |
    // | REMARK :                                                     |
    // +--------------------------------------------------------------+
    // 
    // VERSION     ID          WHO    DATE        DESCRIPTION
    // TWN.01.03   RGS_TWN-327 AH     2017-04-20  INITIAL RELEASE
    DefaultLayout = RDLC;
    RDLCLayout = './Report/CustomerAgreementReport.rdlc';


    dataset
    {
        dataitem("Customer Agreement Detail"; "Customer Agreement Detail")
        {
            column(MSG000; MSG000)
            {
            }
            column(txtContent; txtContent)
            {
            }

            trigger OnAfterGetRecord()
            begin
                txtContent := STRSUBSTNO(Content, CompanyInfo.Name + CompanyInfo."Name 2");
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

    trigger OnPreReport()
    begin
        CLEAR(CompanyInfo);
        CompanyInfo.GET;
    end;

    var
        txtContent: Text[200];
        CompanyInfo: Record "Company Information";
        MSG000: Label 'CUSTOMER AGREEMENT';
}

