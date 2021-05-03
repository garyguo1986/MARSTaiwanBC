codeunit 1045257 "OCT to MARS Web Services"
{
    // +--------------------------------------------------------------
    // |  2019 Incadea China Software System                          |
    // +--------------------------------------------------------------+
    // | PURPOSE: Local Customization                                 |
    // |                                                              |
    // | REMARK :                                                     |
    // +--------------------------------------------------------------+
    // 
    // VERSION       ID          WHO    DATE        DESCRIPTION
    // RGS_TWN-874   122010      GG     2020-08-28  New object copy from mars cn


    trigger OnRun()
    begin

    end;

    var
        JsonXMLConverterG: Codeunit "Json and XML Converter";
        xmlStreamG: DotNet MemoryStream;
        xmlDocG: DotNet XmlDocument;
        rootNodeG: DotNet XmlNode;

    procedure PurchaseOrder(var OCTRequest: BigText; var MARSResponse: BigText)
    var
        OCTPOL: XMLport "OCT PO";
        TempBlobL: Codeunit "Temp Blob";
        OCTInSL: InStream;
    begin

        JsonXMLConverterG.LoadJson2TempBlob(OCTRequest, TempBlobL);

        TempBlobL.CreateInStream(OCTInSL, TEXTENCODING::UTF8);

        OCTPOL.SETSOURCE(OCTInSL);
        OCTPOL.IMPORT;

        xmlDocG := xmlDocG.XmlDocument();
        JsonXMLConverterG.AddNode(xmlDocG, rootNodeG, 'root', '', 'object');
        JsonXMLConverterG.AddNode(xmlDocG, rootNodeG, 'poNo', OCTPOL.GetPONo, 'string');

        JsonXMLConverterG.XML2JsonBigText(xmlDocG, MARSResponse);
    end;
}

