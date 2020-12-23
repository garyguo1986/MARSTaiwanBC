codeunit 50001 "Customer Agreement Function"
{
    // +--------------------------------------------------------------+
    // | @ 2017 incadea Taiwan Limited                                |
    // +--------------------------------------------------------------+
    // | PURPOSE: MARS_TWN                                            |
    // |                                                              |
    // | REMARK :                                                     |
    // +--------------------------------------------------------------+
    // 
    // VERSION     ID          WHO    DATE        DESCRIPTION
    // TWN.01.03   RGS_TWN-327 LL     2017-04-20  INITIAL RELEASE
    //                                2017-04-20  do not directly print agreement (PrintAgreementDetail)


    trigger OnRun()
    begin
    end;

    [Scope('OnPrem')]
    procedure PrintAgreementDetail("Contact ID": Code[20]; "Agreement Status": Option "None",Yes,No,"N/A")
    var
        PrintAgreement: Report "Customer Agreement Report";
    begin
        //++TEC.TWN_R11_T05.LL
        CLEAR(PrintAgreement);
        //PrintAgreement.USEREQUESTFORM(FALSE);
        PrintAgreement.RUNMODAL;
        //--TEC.TWN_R11_T05.LL
    end;

    [Scope('OnPrem')]
    procedure UpdateContactAgreement("Contact ID": Code[20]; "Agreement Status": Option "None",Yes,No,"N/A")
    var
        Contact: Record Contact;
        LMSG000: Label 'Contact %1 dose not exist!';
    begin
        //++TEC.TWN_R11_T05.LL
        CLEAR(Contact);
        IF Contact.GET("Contact ID") THEN BEGIN
            Contact.VALIDATE("Personal Data Status", "Agreement Status");
            Contact."Personal Data Agreement Date" := WORKDATE;
            Contact.MODIFY;
        END ELSE
            ERROR(LMSG000, "Contact ID");
        //--TEC.TWN_R11_T05.LL
    end;
}

