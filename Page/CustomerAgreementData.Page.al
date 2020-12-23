page 50021 "Customer Agreement Data"
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
    // TWN.01.03   RGS_TWN-327 AH     2017-07-18  INITIAL RELEASE

    AutoSplitKey = true;
    Caption = 'Customer Agreement Data';
    PageType = List;
    SourceTable = "Customer Agreement Detail";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Entry No."; "Entry No.")
                {
                    Caption = 'Entry No.';
                }
                field(Content; Content)
                {
                    Caption = 'Content';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    var
        CustAgreementDetialL: Record "Customer Agreement Detail";
    begin
        IF CustAgreementDetialL.FIND('+') THEN;
        "Entry No." := CustAgreementDetialL."Entry No." + 10000;
    end;

    trigger OnOpenPage()
    var
        CompanyL: Record Company;
    begin
        CLEAR(CompanyL);
        IF CompanyL.GET(COMPANYNAME) THEN BEGIN
            //IF CompanyL."Master (Replication)" THEN
            //   CurrPage.EDITABLE := TRUE
            //ELSE
            //   CurrPage.EDITABLE := FALSE;
        END;
    end;
}

