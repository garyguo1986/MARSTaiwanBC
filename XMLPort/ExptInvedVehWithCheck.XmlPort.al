xmlport 1044864 "Expt Inved. Veh. With Check"
{
    // 119897       RGS_TWN-843    WP     2019-07-04  Performance Modify
    // RGS_TWN-888   122187	     QX	    2020-11-30  Field "Vehicle Check Status" is removed

    Direction = Export;
    //++TWN1.00.122187.QX
    //Encoding = UTF8;
    //--TWN1.00.122187.QX
    Format = VariableText;
    PreserveWhiteSpace = true;
    TextEncoding = UTF8;

    schema
    {
        textelement(Root)
        {
            tableelement(header; Integer)
            {
                MaxOccurs = Once;
                XmlName = 'Header';
                textelement(NoCap)
                {
                }
                textelement(PostingDateCap)
                {
                }
                textelement(ServiceCenterCap)
                {
                }
                textelement(ServCenterNameCap)
                {
                }
                textelement(PlateNoCap)
                {
                }
                textelement(ContactCap)
                {
                }
                textelement(SalesAmtCap)
                {
                }
                textelement(SMSOutDateCap)
                {
                }
                textelement(AdditionAmtCap)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    NoCap := C_CaptionNo;
                    PostingDateCap := C_CaptionPostingDate;
                    ServiceCenterCap := C_CaptionServiceCenter;
                    ServCenterNameCap := C_CaptionServiceCenterName;
                    PlateNoCap := C_CaptionPlateNo;
                    ContactCap := C_CaptionSellContact;
                    SalesAmtCap := C_CaptionAmountVAT;
                    SMSOutDateCap := C_CaptionSMSDate;
                    AdditionAmtCap := C_CaptionAdditionalAmt;
                end;
            }
            tableelement(Integer; Integer)
            {
                LinkTable = Header;
                XmlName = 'DataSource';
                textelement(invoiceno)
                {
                    XmlName = 'No.';
                }
                textelement(PostingDate)
                {
                }
                textelement(ServiceCenter)
                {
                }
                textelement(ServiceCenterName)
                {
                }
                textelement(PlateNo)
                {
                }
                textelement(ContactName)
                {
                }
                textelement(SalesAmount)
                {
                }
                textelement(SMSSendOutDate)
                {
                }
                textelement(SalesAmtByAddin)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    IF Integer.Number > 1 THEN
                        SalesInvHdrTempG.NEXT;
                    InvoiceNo := SalesInvHdrTempG."No.";
                    PostingDate := FORMAT(SalesInvHdrTempG."Posting Date", 0, '<year4>-<month,2>-<day,2>');
                    ServiceCenter := SalesInvHdrTempG."Service Center";
                    ServiceCenterName := SalesInvHdrTempG."Sell-to Address 2";
                    PlateNo := SalesInvHdrTempG."Licence-Plate No.";
                    ContactName := SalesInvHdrTempG."Sell-to Contact";
                    SalesInvHdrTempG.CALCFIELDS("Amount Including VAT");
                    SalesAmount := FORMAT(SalesInvHdrTempG."Amount Including VAT");
                    SMSSendOutDate := FORMAT(SalesInvHdrTempG."First Arrangement Date", 0, '<year4>-<month,2>-<day,2>');
                    SalesAmtByAddin := FORMAT(SalesInvHdrTempG."Overpayment Amount");
                end;

                trigger OnPreXmlItem()
                begin
                    SalesInvHdrTempG.RESET;
                    Integer.SETRANGE(Number, 1, SalesInvHdrTempG.COUNT);
                    IF SalesInvHdrTempG.FINDSET THEN;
                end;
            }
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

    trigger OnPreXmlPort()
    begin
        MakeDataSource(SalesInvHdrTempG);
        //IF ExportFilePathG='' THEN
        //  ERROR(C_Text1002);
        currXMLport.FILENAME := ExportFilePathG;
    end;

    var
        SalesInvHdrTempG: Record "Sales Invoice Header" temporary;
        ServiceCenterG: Record "Service Center";
        ServiceCenterFilterG: Text;
        StartDateFilterG: Date;
        EndDateFilterG: Date;
        CurrDateFilterG: Date;
        C_Text1001: Label 'must set Start Date!';
        ExportFilePathG: Text;
        C_Text1002: Label 'must set export File!';
        C_Text1003: Label 'Process... @1@@@@@@@@@@@@@@@@@@@@@@@@';
        C_CaptionNo: Label 'No.';
        C_CaptionPostingDate: Label 'Transaction Date';
        C_CaptionServiceCenter: Label 'Service Center';
        C_CaptionServiceCenterName: Label 'Service Center Name';
        C_CaptionPlateNo: Label 'Plate No.';
        C_CaptionSellContact: Label 'Contact Name';
        C_CaptionAmountVAT: Label 'Sales Amount';
        C_CaptionSMSDate: Label 'SMS Send out Date';
        C_CaptionAdditionalAmt: Label 'Sales Amount by Additional Sales';

    [Scope('OnPrem')]
    procedure MakeDataSource(var SalesInvHdrTempP: Record "Sales Invoice Header" temporary)
    var
        SalesInvHdrL: Record "Sales Invoice Header";
        SalesInvLineL: Record "Sales Invoice Line";
        ArchNotificationHdrL: Record "Archived Notification Header";
        WindowL: Dialog;
        TotalCountL: Integer;
        iL: Integer;
    begin
        IF StartDateFilterG = 0D THEN
            ERROR(C_Text1001);
        IF EndDateFilterG = 0D THEN
            EndDateFilterG := WORKDATE;
        SalesInvHdrTempP.RESET;
        SalesInvHdrTempP.DELETEALL;

        SalesInvHdrL.RESET;
        SalesInvHdrL.SETCURRENTKEY("Posting Date");
        ArchNotificationHdrL.SETCURRENTKEY("Contact No.", "Notif. Date Sent", "Notification Source");
        SalesInvHdrL.SETRANGE("Posting Date", StartDateFilterG, EndDateFilterG);
        //++TWN1.00.122187.QX
        // SalesInvHdrL.SETRANGE("Vehicle Check Status", SalesInvHdrL."Vehicle Check Status"::Done);
        //--TWN1.00.122187.QX
        TotalCountL := SalesInvHdrL.COUNT;
        WindowL.OPEN(C_Text1003);
        IF SalesInvHdrL.FINDFIRST THEN
            REPEAT
                IF (iL MOD 20) = 0 THEN
                    WindowL.UPDATE(1, ROUND(iL / TotalCountL * 10000, 1));
                iL += 1;
                SalesInvHdrTempP := SalesInvHdrL;

                ArchNotificationHdrL.SETRANGE("Contact No.", SalesInvHdrL."Sell-to Contact No.");
                ArchNotificationHdrL.SETRANGE("Notif. Date Sent", StartDateFilterG, EndDateFilterG);
                ArchNotificationHdrL.SETFILTER("Notification Source", '%1|%2', ArchNotificationHdrL."Notification Source"::Segment, ArchNotificationHdrL."Notification Source"::"Service Reminder");
                // SMSSendoutDateG
                IF ArchNotificationHdrL.FINDFIRST THEN
                    SalesInvHdrTempP."First Arrangement Date" := ArchNotificationHdrL."Notif. Date Sent"
                ELSE
                    SalesInvHdrTempP."First Arrangement Date" := 0D;

                // Service Center Name
                IF ServiceCenterG.Code <> SalesInvHdrL."Service Center" THEN
                    IF NOT ServiceCenterG.GET(SalesInvHdrL."Service Center") THEN
                        ServiceCenterG.INIT;
                SalesInvHdrTempP."Sell-to Address 2" := ServiceCenterG.Name;

                // SalesAmountByAddSalesG
                SalesInvLineL.SETRANGE("Document No.", SalesInvHdrL."No.");
                SalesInvLineL.SETRANGE("Additional Sale", TRUE);
                SalesInvLineL.CALCSUMS("Amount Including VAT");
                SalesInvHdrTempP."Overpayment Amount" := SalesInvLineL."Amount Including VAT";
                SalesInvHdrTempP.INSERT;
            UNTIL SalesInvHdrL.NEXT = 0;
        WindowL.CLOSE;
    end;

    [Scope('OnPrem')]
    procedure SetParam(var ServiceCenterFilterP: Text; var StartDateFilterP: Date; var EndDateFilterP: Date; var CurrDateFilterP: Date; ExportFilePathP: Text)
    begin
        ServiceCenterFilterG := ServiceCenterFilterP;
        StartDateFilterG := StartDateFilterP;
        EndDateFilterG := EndDateFilterP;
        CurrDateFilterG := CurrDateFilterP;
        ExportFilePathG := ExportFilePathP;
    end;
}

