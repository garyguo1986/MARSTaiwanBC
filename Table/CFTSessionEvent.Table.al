table 1044889 "CFT Session Event"
{
    // +--------------------------------------------------------------
    // | ?2015 Incadea China Software System                          |
    // +--------------------------------------------------------------+
    // | PURPOSE: Local Customization                                 |
    // |                                                              |
    // | REMARK :                                                     |
    // +--------------------------------------------------------------+
    // 
    // VERSION       ID       WHO    DATE        DESCRIPTION
    // RGS_CFT-169   68824    QX     2016-11-14  Create Sales Order from CFT
    // RGS_CFT-123   67775    QX     2016-11-14  CFT Customer Update API
    // RGS_CFT-129   68025    QX     2016-11-14  Create New Vehicle API
    // RGS_CHN-1540  120360 QX    2019-08-06  Added field Interface Type

    Caption = 'CFT Session Event';
    DataPerCompany = false;

    fields
    {
        field(1; "User ID"; Text[132])
        {
            Caption = 'User ID';
        }
        field(2; "Server Instance ID"; Integer)
        {
            Caption = 'Server Instance ID';
            TableRelation = "Server Instance"."Server Instance ID";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(3; "Session ID"; Integer)
        {
            Caption = 'Session ID';
        }
        field(4; "Service Center Code"; Code[10])
        {
        }
        field(5; "Event Datetime"; DateTime)
        {
            Caption = 'Event Datetime';
        }
        field(6; "Event Type"; Option)
        {
            OptionMembers = " ","Order",Customer,Vehicle;
        }
        field(7; "Return Code"; Code[30])
        {
        }
        field(8; "Interface Type"; Option)
        {
            OptionMembers = " ",OCT;
        }
    }

    keys
    {
        key(Key1; "User ID", "Server Instance ID", "Session ID")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        InitDefaultValues;
    end;

    var
        SalesHeader: Record "Sales Header";
        C_MIL_ERR001: Label 'Service Center Code %1 is invalid.';
        MARSAppSetup: Record "Fastfit Setup - Application";
        TMDateTime: DateTime;
        Timeout: Duration;
        C_MIL_TIMEOUT: Label '12';
        CFTSession: Record "CFT Session Event";

    local procedure InitDefaultValues()
    begin
        "User ID" := USERID;
        "Server Instance ID" := SERVICEINSTANCEID;
        "Session ID" := SESSIONID;
        "Event Datetime" := CURRENTDATETIME;
    end;

    [Scope('OnPrem')]
    procedure CreateDocument()
    begin
        CASE "Event Type" OF
            "Event Type"::Order:
                BEGIN
                    SalesHeader."Document Type" := SalesHeader."Document Type"::Order;
                    SalesHeader."No." := '';
                    SalesHeader.INSERT(TRUE);
                    "Return Code" := SalesHeader."No.";
                    MODIFY;
                END;
        END;
    end;

    [Scope('OnPrem')]
    procedure RegisterServiceCenter(ServiceCenterCode: Code[10])
    var
        ServiceCenter: Record "Service Center";
    begin
        // The function is used for sales work flow, If the function is actived in sales please merge code following
        /*
        IF CURRENTCLIENTTYPE <> CLIENTTYPE::OData THEN
          EXIT;
        
        IF NOT ServiceCenter.GET(ServiceCenterCode) THEN
          ERROR(C_MIL_ERR001,ServiceCenterCode);
        
        IF GET(USERID,SERVICEINSTANCEID,SESSIONID) THEN BEGIN
          "Service Center Code" := ServiceCenterCode;
          MODIFY;
        END ELSE BEGIN
          INIT;
          InitDefaultValues;
          "Service Center Code" := ServiceCenterCode;
          INSERT;
        END;
        
        MARSAppSetup.GET;
        IF MARSAppSetup."CFT Workdate" <> TODAY THEN BEGIN
          MARSAppSetup."CFT Workdate" := TODAY;
          MARSAppSetup.MODIFY;
          EVALUATE(Timeout,C_MIL_TIMEOUT);
          TMDateTime := CURRENTDATETIME - Timeout;
          CFTSession.SETFILTER("Event Datetime",'<=%1',TMDateTime);
          CFTSession.DELETEALL;
        END;
        */

    end;

    [Scope('OnPrem')]
    procedure GetCFTServiceCenter(): Code[10]
    begin
        IF GET(USERID, SERVICEINSTANCEID, SESSIONID) THEN
            EXIT("Service Center Code")
        ELSE
            EXIT('');
    end;

    [Scope('OnPrem')]
    procedure GetInterfaceType(): Integer
    begin
        IF GET(USERID, SERVICEINSTANCEID, SESSIONID) THEN
            EXIT("Interface Type")
        ELSE
            EXIT(-1);
    end;
}

