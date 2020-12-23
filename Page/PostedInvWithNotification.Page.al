page 1044863 "Posted Inv. With Notification"
{
    // +----------------------------------------------+
    // | Copyright (c) incadea China                  |
    // +----------------------------------------------+
    // TFS          ID             WHO    DATE        DESCRIPTION
    // 117247       MARS_TWN-6901  GG     2018-11-05  New object to show posted sales invoice have notification sent
    // 119897       RGS_TWN-843    WP     2019-07-04  Performance Modify
    // 121695       RGS_TWN-7876   QX   2020-05-25  Translate Chinese
    // 121695       RGS_TWN-7876   GG   2020-06-10  Add caption extension for this page
    // RGS_TWN-888   122187	       QX	  2020-12-23  Field "Vehicle Check Status" was removed

    Caption = 'Posted Inv. With Notification';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Worksheet;
    SourceTable = "Sales Invoice Header";
    SourceTableTemporary = true;
    SourceTableView = SORTING("Posting Date")
                      ORDER(Descending);

    layout
    {
        area(content)
        {
            field(StartDateG; StartDateG)
            {
                Caption = 'Start Date';
                Description = '121695';
            }
            field(EndDateG; EndDateG)
            {
                Caption = 'End Date';
                Description = '121695';
            }
            repeater(Group)
            {
                Editable = false;
                field("No."; "No.")
                {
                    Visible = false;
                }
                field("Posting Date"; "Posting Date")
                {
                    Caption = 'Transaction Date';
                }
                field("Service Center"; "Service Center")
                {
                }
                field("Sell-to Address 2"; "Sell-to Address 2")
                {
                    Caption = 'Service Center Name';
                }
                field("Licence-Plate No."; "Licence-Plate No.")
                {
                    Caption = 'Plate No.';
                }
                field("Sell-to Contact"; "Sell-to Contact")
                {
                    Caption = 'Contact Name';
                }
                field("Amount Including VAT"; "Amount Including VAT")
                {
                    Caption = 'Sales Amount';
                    DrillDown = false;
                }
                field("First Arrangement Date"; "First Arrangement Date")
                {
                    Caption = 'SMS Send out Date';
                }
                field("Overpayment Amount"; "Overpayment Amount")
                {
                    Caption = 'Sales Amount by Additional Sales';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Query")
            {
                Caption = 'Query';
                Description = '121695';
                Image = Find;
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    // Start 119897
                    GetAllPostedInvWithNotificationSent2;
                    CurrPage.UPDATE(FALSE);
                    // Stop  119897
                end;
            }
            action("Export CSV")
            {
                Caption = 'Export CSV';
                Description = '121695';
                Image = ExportFile;
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    ExportCSV;
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        // Start 119897
        /*
        ServiceCenterNameG := '';
        IF ServiceCenterG.GET("Service Center") THEN
          ServiceCenterNameG := ServiceCenterG.Name;
        SMSSendoutDateG := 0D;
        ArchivedNotificationHeaderG.RESET;
        ArchivedNotificationHeaderG.SETRANGE("Notif. Date Sent",StartDateG,EndDateG);
        ArchivedNotificationHeaderG.SETRANGE("Contact No.","Sell-to Contact No.");
        ArchivedNotificationHeaderG.SETFILTER("Notification Source",'%1|%2',ArchivedNotificationHeaderG."Notification Source"::Segment,ArchivedNotificationHeaderG."Notification Source"::"Service Reminder");
        IF ArchivedNotificationHeaderG.FINDFIRST THEN
          SMSSendoutDateG := ArchivedNotificationHeaderG."Notif. Date Sent";
        
        SalesAmountByAddSalesG := 0;
        SalesInvoiceLineG.RESET;
        SalesInvoiceLineG.SETRANGE("Document No.","No.");
        SalesInvoiceLineG.SETRANGE("Additional Sale",TRUE);
        IF SalesInvoiceLineG.FINDFIRST THEN
          REPEAT
            SalesAmountByAddSalesG += SalesInvoiceLineG."Amount Including VAT";
          UNTIL SalesInvoiceLineG.NEXT = 0;
        */
        // Stop  119897

    end;

    trigger OnOpenPage()
    begin
        // Start 119897
        //SetCubeType(1);
        NotificationInvoiceFilters(ServiceCenterFilterG, StartDateG, EndDateG, CalculateDateG);
        // Stop  119897
        // Start 121695
        CurrPage.CAPTION := CurrPage.CAPTION + C_Text102;
        // Stop 121695
    end;

    var
        ServiceCenterG: Record "Service Center";
        ArchivedNotificationHeaderG: Record "Archived Notification Header";
        SalesInvoiceLineG: Record "Sales Invoice Line";
        ServiceCenterNameG: Text[50];
        SMSSendoutDateG: Date;
        ServiceCenterFilterG: Text;
        CalculateDateG: Date;
        StartDateG: Date;
        EndDateG: Date;
        CubeTypeG: Option " ",PostedInvWithNotification,PostedInvWithVehicleCheck;
        SalesAmountByAddSalesG: Decimal;
        [InDataSet]
        IsSMSSendoutDateVisiableG: Boolean;
        [InDataSet]
        IsSalesAmountbyAddSalesVisiableG: Boolean;
        ExptInvedWithNotificationG: XMLport "Expt. Inved. With Notification";
        C_Text100: Label 'Save to';
        C_Text101: Label 'Export succusful.';
        C_Text102: Label '(Please input start date and end date)';

    [Scope('OnPrem')]
    procedure CalculatePostedInvWithNotificationSent() TotalSICountR: Integer
    var
        PostedInvWithNotificationL: Query "Posted Inv. With Notification";
        ServiceCenterFilterL: Text;
        CalculateDateL: Date;
        StartDateL: Date;
        EndDateL: Date;
    begin
        //++MIL1.00.001.117247.GG
        TotalSICountR := 0;

        NotificationInvoiceFilters(ServiceCenterFilterL, StartDateL, EndDateL, CalculateDateL);

        CLEAR(PostedInvWithNotificationL);
        PostedInvWithNotificationL.SETFILTER(Sell_to_Contact_No, '<>%1', '');
        PostedInvWithNotificationL.SETFILTER(Service_Center, ServiceCenterFilterL);
        PostedInvWithNotificationL.SETFILTER(Posting_Date, '%1..%2', StartDateL, CalculateDateL);
        PostedInvWithNotificationL.SETFILTER(Notif_Date_Sent, '%1..%2', StartDateL, EndDateL);
        PostedInvWithNotificationL.OPEN;
        WHILE PostedInvWithNotificationL.READ DO BEGIN
            TotalSICountR += 1;
        END;

        EXIT(TotalSICountR);
        //--MIL1.00.001.117247.GG
    end;

    [Scope('OnPrem')]
    procedure CalculatePostedInvWithVehicleCheck() TotalSICountR: Integer
    var
        SalesInvoiceHeaderL: Record "Sales Invoice Header";
        ServiceCenterFilterL: Text;
        CalculateDateL: Date;
        StartDateL: Date;
        EndDateL: Date;
    begin
        //++MIL1.00.001.117247.GG
        TotalSICountR := 0;

        VehicleCheckInvoiceFilters(ServiceCenterFilterL, StartDateL, EndDateL, CalculateDateL);
        SalesInvoiceHeaderL.RESET;
        SalesInvoiceHeaderL.SETRANGE("Posting Date", StartDateL, EndDateL);
        //++TWN1.00.122187.QX
        // SalesInvoiceHeaderL.SETRANGE("Vehicle Check Status", SalesInvoiceHeaderL."Vehicle Check Status"::Done);
        //--TWN1.00.122187.QX

        TotalSICountR := SalesInvoiceHeaderL.COUNT;
        //--MIL1.00.001.117247.GG
    end;

    local procedure NotificationInvoiceFilters(var ServiceCenterFilterP: Text; var StartDateFilterP: Date; var EndDateFilterP: Date; var CurrDateFilterP: Date)
    var
        UserServCenterL: Record "User/Serv. Center";
        CalculateMonthFirstDateL: Date;
    begin
        //++MIL1.00.001.117247.GG
        ServiceCenterFilterP := '';
        UserServCenterL.RESET;
        UserServCenterL.SETRANGE("User ID", USERID);
        UserServCenterL.SETFILTER("Service Center", '<>%1', '');
        IF UserServCenterL.FINDFIRST THEN
            REPEAT
                IF ServiceCenterFilterP = '' THEN
                    ServiceCenterFilterP := UserServCenterL."Service Center"
                ELSE
                    ServiceCenterFilterP := ServiceCenterFilterP + '|' + UserServCenterL."Service Center";
            UNTIL UserServCenterL.NEXT = 0;

        CurrDateFilterP := WORKDATE;
        CalculateMonthFirstDateL := DMY2DATE(1, DATE2DMY(CurrDateFilterP, 2), DATE2DMY(CurrDateFilterP, 3));
        StartDateFilterP := CALCDATE('<-2M>', CalculateMonthFirstDateL);
        EndDateFilterP := CalculateMonthFirstDateL - 1;
        //--MIL1.00.001.117247.GG
    end;

    local procedure VehicleCheckInvoiceFilters(var ServiceCenterFilterP: Text; var StartDateFilterP: Date; var EndDateFilterP: Date; var CurrDateFilterP: Date)
    var
        UserServCenterL: Record "User/Serv. Center";
        CalculateMonthFirstDateL: Date;
    begin
        //++MIL1.00.001.117247.GG
        ServiceCenterFilterP := '';
        UserServCenterL.RESET;
        UserServCenterL.SETRANGE("User ID", USERID);
        UserServCenterL.SETFILTER("Service Center", '<>%1', '');
        IF UserServCenterL.FINDFIRST THEN
            REPEAT
                IF ServiceCenterFilterP = '' THEN
                    ServiceCenterFilterP := UserServCenterL."Service Center"
                ELSE
                    ServiceCenterFilterP := ServiceCenterFilterP + '|' + UserServCenterL."Service Center";
            UNTIL UserServCenterL.NEXT = 0;

        CurrDateFilterP := WORKDATE;
        CalculateMonthFirstDateL := DMY2DATE(1, DATE2DMY(CurrDateFilterP, 2), DATE2DMY(CurrDateFilterP, 3));
        StartDateFilterP := CALCDATE('<-1M>', CalculateMonthFirstDateL);
        EndDateFilterP := CurrDateFilterP - 1;
        //--MIL1.00.001.117247.GG
    end;

    [Scope('OnPrem')]
    procedure GetAllPostedInvWithNotificationSent()
    var
        SalesInvoiceHeaderL: Record "Sales Invoice Header";
        PostedInvWithNotificationL: Query "Posted Inv. With Notification";
        ServiceCenterFilterL: Text;
        CalculateDateL: Date;
        StartDateL: Date;
        EndDateL: Date;
    begin
        //++MIL1.00.001.117247.GG
        NotificationInvoiceFilters(ServiceCenterFilterL, StartDateL, EndDateL, CalculateDateL);
        RESET;
        DELETEALL;

        CLEAR(PostedInvWithNotificationL);
        PostedInvWithNotificationL.SETFILTER(Sell_to_Contact_No, '<>%1', '');
        PostedInvWithNotificationL.SETFILTER(Service_Center, ServiceCenterFilterL);
        PostedInvWithNotificationL.SETFILTER(Posting_Date, '%1..%2', StartDateL, CalculateDateL);
        PostedInvWithNotificationL.SETFILTER(Notif_Date_Sent, '%1..%2', StartDateL, EndDateL);
        PostedInvWithNotificationL.OPEN;
        WHILE PostedInvWithNotificationL.READ DO BEGIN
            IF SalesInvoiceHeaderL.GET(PostedInvWithNotificationL.No) THEN BEGIN
                INIT;
                Rec := SalesInvoiceHeaderL;
                INSERT;
            END;
        END;
        //--MIL1.00.001.117247.GG
    end;

    [Scope('OnPrem')]
    procedure GetAllPostedInvWithVehicleCheck()
    var
        SalesInvoiceHeaderL: Record "Sales Invoice Header";
        ServiceCenterFilterL: Text;
        CalculateDateL: Date;
        StartDateL: Date;
        EndDateL: Date;
    begin
        //++MIL1.00.001.117247.GG
        VehicleCheckInvoiceFilters(ServiceCenterFilterL, StartDateL, EndDateL, CalculateDateL);
        RESET;
        DELETEALL;

        SalesInvoiceHeaderL.RESET;
        SalesInvoiceHeaderL.SETRANGE("Posting Date", StartDateL, EndDateL);
        //++TWN1.00.122187.QX        
        // SalesInvoiceHeaderL.SETRANGE("Vehicle Check Status", SalesInvoiceHeaderL."Vehicle Check Status"::Done);
        //--TWN1.00.122187.QX        
        IF SalesInvoiceHeaderL.FINDFIRST THEN
            REPEAT
                INIT;
                Rec := SalesInvoiceHeaderL;
                INSERT;
            UNTIL SalesInvoiceHeaderL.NEXT = 0;
        //--MIL1.00.001.117247.GG
    end;

    [Scope('OnPrem')]
    procedure SetCubeType(CubeTypeP: Integer)
    begin
        //++MIL1.00.001.117247.GG
        CubeTypeG := CubeTypeP;
        CASE CubeTypeG OF
            CubeTypeG::PostedInvWithNotification:
                BEGIN
                    GetAllPostedInvWithNotificationSent;
                    NotificationInvoiceFilters(ServiceCenterFilterG, StartDateG, EndDateG, CalculateDateG); //Used by OnAfterGetCurrRecord trigger
                END;
            CubeTypeG::PostedInvWithVehicleCheck:
                BEGIN
                    GetAllPostedInvWithVehicleCheck;
                END;
        END;

        CASE CubeTypeG OF
            CubeTypeG::PostedInvWithNotification:
                BEGIN
                    IsSMSSendoutDateVisiableG := TRUE;
                    IsSalesAmountbyAddSalesVisiableG := FALSE;
                END;
            CubeTypeG::PostedInvWithVehicleCheck:
                BEGIN
                    IsSMSSendoutDateVisiableG := FALSE;
                    IsSalesAmountbyAddSalesVisiableG := TRUE;
                END;
        END;
        SETCURRENTKEY("Posting Date");
        ASCENDING(FALSE);
        IF FINDFIRST THEN;
        //--MIL1.00.001.117247.GG
    end;

    [Scope('OnPrem')]
    procedure GetAllPostedInvWithNotificationSent2()
    var
        SalesInvHdrL: Record "Sales Invoice Header";
        SalesInvLineL: Record "Sales Invoice Line";
        ArchNotificationHdrL: Record "Archived Notification Header";
    begin
        // Start 119897
        ExptInvedWithNotificationG.SetParam(ServiceCenterFilterG, StartDateG, EndDateG, CalculateDateG, '');
        ExptInvedWithNotificationG.MakeDataSource(Rec);
        // Stop  119897
    end;

    local procedure ExportCSV()
    var
        FileMgtL: Codeunit "File Management";
        ClientFilePathL: Text;
        ServiceFilePathL: Text;
        FileL: File;
        OutstremL: OutStream;
    begin
        // Start 119897
        IF CURRENTCLIENTTYPE = CLIENTTYPE::Web THEN
            ServiceFilePathL := STRSUBSTNO('PostedInvNotification_%1-%2.csv', FORMAT(StartDateG, 0, '<year4><month,2>'), FORMAT(EndDateG, 0, '<year4><month,2>'))
        ELSE BEGIN
            ClientFilePathL := FileMgtL.SaveFileDialog(C_Text100,
                STRSUBSTNO('PostedInvNotification_%1-%2', FORMAT(StartDateG, 0, '<year4><month,2>'), FORMAT(EndDateG, 0, '<year4><month,2>')),
                'CSV files (*.csv)|*.csv');
            IF ClientFilePathL = '' THEN
                EXIT;
            ServiceFilePathL := FileMgtL.ServerTempFileName('.csv');
            IF FILE.EXISTS(ServiceFilePathL) THEN
                FILE.ERASE(ServiceFilePathL);
        END;

        FileL.CREATE(ServiceFilePathL);
        FileL.CREATEOUTSTREAM(OutstremL);
        ExptInvedWithNotificationG.SetParam(ServiceCenterFilterG, StartDateG, EndDateG, CalculateDateG, ServiceFilePathL);
        ExptInvedWithNotificationG.SETDESTINATION(OutstremL);
        ExptInvedWithNotificationG.EXPORT;
        FileL.CLOSE;
        IF CURRENTCLIENTTYPE = CLIENTTYPE::Web THEN
            FileMgtL.DownloadTempFile(ServiceFilePathL)
        ELSE BEGIN
            FileMgtL.DownloadToFile(ServiceFilePathL, ClientFilePathL);
            IF GUIALLOWED THEN
                MESSAGE(C_Text101);
        END;
        // Stop  119897
    end;
}

