page 1044888 "Segment Header Tenant"
{
    // +--------------------------------------------------------------+
    // | @ 2020 incadea Taiwan Limited                                |
    // +--------------------------------------------------------------+
    // | PURPOSE: MARS_TWN                                            |
    // |                                                              |
    // | REMARK :                                                     |
    // +--------------------------------------------------------------+
    // 
    // VERSION       ID            WHO    DATE        DESCRIPTION
    // RGS_AGL-3620  121528        GG     2020-06-03  New object

    Caption = 'Segment Header Tenant';
    PageType = CardPart;
    ShowFilter = false;
    SourceTable = "Segment Header Extension";

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Tenant ID"; "Tenant ID")
                {

                    trigger OnLookup(var Text: Text): Boolean
                    var
                    // ReplicationCompanyL: Record 1059124;
                    // ReplicationCompaniesDealerL: Page 1059125;
                    begin
                        // CLEAR(ReplicationCompaniesDealerL);
                        // ReplicationCompanyL.RESET;
                        // ReplicationCompaniesDealerL.LOOKUPMODE := TRUE;
                        // ReplicationCompaniesDealerL.SETRECORD(ReplicationCompanyL);
                        // ReplicationCompaniesDealerL.SETTABLEVIEW(ReplicationCompanyL);
                        // IF ReplicationCompaniesDealerL.RUNMODAL = ACTION::LookupOK THEN BEGIN
                        //     ReplicationCompaniesDealerL.GETRECORD(ReplicationCompanyL);
                        //     "Tenant ID" := ReplicationCompanyL."Tenant ID";
                    end;
                }
            }
        }
    }

    actions
    {
    }
}

