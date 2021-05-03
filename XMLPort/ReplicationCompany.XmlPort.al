xmlport 50000 "Replication Company"
{
    // +--------------------------------------------------------------
    // | ?2017 Incadea China Software System                          |
    // +--------------------------------------------------------------+
    // | PURPOSE: Local Customization                                 |
    // |                                                              |
    // | REMARK :                                                     |
    // +--------------------------------------------------------------+
    // VERSION     ID                  WHO    DATE        DESCRIPTION
    // TWN.01.00   RGS_TWN-756         QX     2017-11-21  Export Dealers' Company and Tenat
    // 119387      RGS_TWN-839         WP     2019-05-08  Add element ServCenters    

    Direction = Export;
    TextEncoding = WINDOWS;
    Format = VariableText;


    schema
    {
        textelement(Root)
        {
            tableelement(ReplicationCompany; "Replication Company Old")
            {
                fieldelement(companyName; ReplicationCompany.Name)
                {
                    MinOccurs = Once;
                }
                fieldelement(tenantID; ReplicationCompany."Tenant ID")
                {
                    MinOccurs = Once;
                }
                textelement(servCenters)
                {

                }
                trigger OnAfterGetRecord()
                begin
                    // Start 119387
                    ServCenterLimitG.RESET;
                    ServCenterLimitG.SETRANGE("Company Name", ReplicationCompany.Name);
                    ServCenterLimitG.SETRANGE("Tenant ID", ReplicationCompany."Tenant ID");
                    ServCenterLimitG.SETFILTER("Service Center", '>%1', '');
                    servCenters := '';
                    IF ServCenterLimitG.FINDSET THEN
                        REPEAT
                            servCenters += '|' + ServCenterLimitG."Service Center"
                        UNTIL ServCenterLimitG.NEXT = 0;
                    IF servCenters > '' THEN
                        servCenters := COPYSTR(servCenters, 2);
                    // Stop  119387
                end;
            }
        }
    }
    requestpage
    {
        layout
        {
            area(content)
            {
                group(GroupName)
                {
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

    trigger OnInitXmlPort()
    begin
        Separator[1] := 31;
        currXMLport.FIELDSEPARATOR(Separator);
    end;

    var
        Separator: Text;
        ServCenterLimitG: Record "Notifi. Serv. Center Limit";
}
