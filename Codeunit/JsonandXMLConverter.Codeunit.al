codeunit 50010 "Json and XML Converter"
{
    // +--------------------------------------------------------------
    // | ?2015 Incadea China Software System                          |
    // +--------------------------------------------------------------+
    // | PURPOSE: Local Customization                                 |
    // |                                                              |
    // | REMARK :                                                     |
    // +--------------------------------------------------------------+

    // VERSION       ID       WHO    DATE        DESCRIPTION
    // RGS_TWN-874   122010   GG     2020-08-28  New object copy from MARS CN    

    procedure Json2XML(var jsonStreamP: DotNet SystemIOStream; var xmlDocP: DotNet SystemXmlXmlDocument)
    var
        xmlElementL: DotNet SystemXmlXmlElement;
        iEnumL: dotnet SystemCollectionsIEnumerator;
    begin
        jsonReader := jsonFactory.CreateJsonReader(jsonStreamP, ReaderQuotas.Max);
        xmlDocP := xmlDocP.XmlDocument();
        xmlDocP.Load(jsonReader);

        xmlElementL := xmlDocP.DocumentElement();
        iEnumL := xmlDocP.GetEnumerator();
        RemoveAllAttributes(iEnumL);
    end;

    procedure BigTextJson2XML(var jsonBigTextP: BigText; var xmlDocP: DotNet SystemXmlXmlDocument)
    var
        xmlElementL: DotNet SystemXmlXmlElement;
        iEnumL: dotnet SystemCollectionsIEnumerator;
        jsonInStreamL: InStream;
        jsonOutStreamL: OutStream;
        TempBlobL: Codeunit "Temp Blob";
    begin
        TempBlobL.CreateOutStream(jsonOutStreamL, TextEncoding::UTF8);
        jsonBigTextP.Write(jsonOutStreamL);
        TempBlobL.CreateInStream(jsonInStreamL, TextEncoding::UTF8);
        jsonReader := jsonFactory.CreateJsonReader(jsonInStreamL, ReaderQuotas.Max);
        xmlDocP := xmlDocP.XmlDocument();
        xmlDocP.Load(jsonReader);

        xmlElementL := xmlDocP.DocumentElement();
        iEnumL := xmlDocP.GetEnumerator();
        RemoveAllAttributes(iEnumL);
    end;

    procedure XML2Json(var xmlInStreamP: Instream; var jsonOutStreamP: OutStream)
    var
        XDocL: DotNet SystemXmlLinqXDocument;
    begin
        xmlWriter := jsonFactory.CreateJsonWriter(jsonOutStreamP);
        XDocL := XDocL.XDocument();
        XDocL := XDocL.Load(xmlInStreamP);
        XDocL.WriteTo(xmlWriter);
        xmlWriter.Flush();
        xmlWriter.Dispose();
    end;

    local procedure RemoveAllAttributes(var iEnumP: Dotnet SystemCollectionsIEnumerator)
    var
        xmlAttrL: DotNet SystemXmlXmlAttributeCollection;
        xmlNodeListL: DotNet SystemXmlXmlNodeList;
        ChildiEnumL: DotNet SystemCollectionsIEnumerator;
        xmlNodeL: DotNet SystemXmlXmlNode;
    begin
        WHILE iEnumP.MoveNext DO BEGIN
            xmlNodeL := iEnumP.Current();
            xmlAttrL := xmlNodeL.Attributes();
            IF NOT ISNULL(xmlAttrL) THEN
                xmlAttrL.RemoveAll();
            IF xmlNodeL.HasChildNodes() THEN BEGIN
                xmlNodeListL := xmlNodeL.ChildNodes();
                ChildiEnumL := xmlNodeListL.GetEnumerator();
                RemoveAllAttributes(ChildiEnumL);
            END;
        END;
    end;

    procedure JsonStream2XML(var jsonStreamP: Dotnet SystemIOStream; var xmlDocP: Dotnet SystemXmlXmlDocument)
    var
        xmlElementL: DotNet SystemXmlXmlElement;
        iEnumL: DotNet SystemCollectionsIEnumerator;
        jsonReaderL: DotNet SystemXmlXmlDictoryReader;
        ReaderQuotasL: DotNet SystemXmlXmlDictionaryReaderQuotas;
    begin
        //++MIL1.00.119052.QX
        jsonReaderL := jsonFactory.CreateJsonReader(jsonStreamP, ReaderQuotasL.Max);
        xmlDocP := xmlDocP.XmlDocument();
        xmlDocP.Load(jsonReaderL);

        xmlElementL := xmlDocP.DocumentElement();
        iEnumL := xmlDocP.GetEnumerator();
        RemoveAllAttributes(iEnumL);

        //--MIL1.00.119052.QX
    end;

    procedure XML2JsonStream(var xmlStreamP: DotNet SystemIOMemoryStream; var jsonStreamP: DotNet SystemIOMemoryStream)
    var
        XDocL: DotNet SystemXmlLinqXDocument;
        xmlWriterL: DotNet SystemXmlXmlDictionaryWriter;
    begin
        //++MIL1.00.119052.QX
        xmlWriterL := jsonFactory.CreateJsonWriter(jsonStreamP);
        XDocL := XDocL.XDocument();
        XDocL := XDocL.Load(xmlStreamP);

        XDocL.WriteTo(xmlWriterL);
        xmlWriterL.Flush();

        jsonStreamP.Position := 0;
        //--MIL1.00.119052.QX
    end;

    procedure LoadJson2XML(var RequestP: BigText; var xmlStreamP: Dotnet SystemIOMemoryStream)
    var
        xmlDocL: DotNet SystemXmlXmlDocument;
    begin
        //++MIL1.00.001.120360.QX
        xmlStreamP := xmlStreamP.MemoryStream();
        RequestP.WRITE(xmlStreamP);
        xmlStreamP.Flush;
        xmlStreamP.Position := 0;

        xmlDocL := xmlDocL.XmlDocument();

        Json2XML(xmlStreamP, xmlDocL);

        xmlStreamP := xmlStreamP.MemoryStream();
        xmlDocL.Save(xmlStreamP);
        //--MIL1.00.001.120360.QX
    end;

    procedure LoadJson2TempBlob(var RequestP: BigText; var TempBlobP: Codeunit "Temp Blob")
    var
        xmlDocL: DotNet SystemXmlXmlDocument;
        xmlOutStreamL: OutStream;
    begin
        //++MIL1.00.001.120360.QX
        BigTextJson2XML(RequestP, xmlDocL);

        TempBlobP.CreateOutStream(xmlOutStreamL, TextEncoding::UTF8);

        xmlDocL.Save(xmlOutStreamL);
        //--MIL1.00.001.120360.QX
    end;

    procedure AddNode(var xmlDocP: DotNet SystemXmlXmlDocument; var ParentNodeP: DotNet SystemXmlXmlNode; ElementNameP: Text; NodeTextP: Text; TypeAttributeP: Text)
    var
        xmlNodeL: DotNet SystemXmlXmlNode;
    begin
        //++MIL1.00.001.120360.QX
        IF ISNULL(xmlDocP) THEN
            xmlDocP := xmlDocP.XmlDocument();

        IF ISNULL(ParentNodeP) THEN BEGIN
            ParentNodeP := xmlDocP.CreateElement(ElementNameP);
            AddTypeAttribute(xmlDocP, ParentNodeP, TypeAttributeP);
            xmlDocP.AppendChild(ParentNodeP);
        END ELSE BEGIN
            xmlNodeL := xmlDocP.CreateElement(ElementNameP);
            IF NodeTextP <> '' THEN
                xmlNodeL.InnerText := NodeTextP;
            AddTypeAttribute(xmlDocP, xmlNodeL, TypeAttributeP);
            ParentNodeP.AppendChild(xmlNodeL);
        END;
        //--MIL1.00.001.120360.QX
    end;

    local procedure AddTypeAttribute(var xmlDocP: Dotnet SystemXmlXmlDocument; var xmlNodeP: Dotnet SystemXmlXmlNode; TypeAttributeP: Text)
    var
        xmlAttrL: DotNet SystemXmlXmlAttribute;
        xmlAttrColtL: DotNet SystemXmlXmlAttributeCollection;
    begin
        //++MIL1.00.001.120360.QX
        IF TypeAttributeP = '' THEN
            EXIT;

        xmlAttrL := xmlDocP.CreateAttribute('type');
        xmlAttrL.Value := TypeAttributeP;
        xmlAttrColtL := xmlNodeP.Attributes;
        xmlAttrColtL.Append(xmlAttrL);
        //--MIL1.00.001.120360.QX
    end;

    procedure XML2JsonBigText(var xmlDocP: DotNet XmlDocument; var jsonOutText: BigText)
    var
        xmlWriterL: DotNet SystemXmlXmlDictionaryWriter;
        jsonOutStreamL: DotNet SystemIOMemoryStream;
    begin
        //++MIL1.00.001.120360.QX
        jsonOutStreamL := jsonOutStreamL.MemoryStream();
        xmlWriterL := jsonFactory.CreateJsonWriter(jsonOutStreamL);
        xmlDocP.WriteTo(xmlWriterL);
        xmlWriterL.Flush();
        jsonOutStreamL.Position := 0;
        jsonOutText.READ(jsonOutStreamL);
        //--MIL1.00.001.120360.QX
    end;

    var
        jsonFactory: DotNet SystemRuntimeSerializationJsonJsonReaderWriterFactory;
        ReaderQuotas: DotNet SystemXmlXmlDictionaryReaderQuotas;
        jsonReader: DotNet SystemXmlXmlDictoryReader;
        xmlWriter: dotnet SystemXmlXmlDictionaryWriter;
}
