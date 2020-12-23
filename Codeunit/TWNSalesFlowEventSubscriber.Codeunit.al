codeunit 50002 "TWN Sales Flow EventSubscriber"
{
    // +----------------------------------------------+
    // | Copyright (c) incadea China                  |
    // +----------------------------------------------+
    // TFS          ID             WHO    DATE        DESCRIPTION
    // 112162       MARS_TWN-6441  GG     2018-03-12  Add new subscriber function for sales order release and reopen


    trigger OnRun()
    begin
    end;

    [EventSubscriber(ObjectType::Codeunit, 414, 'OnBeforeReleaseSalesDoc', '', false, false)]
    [Scope('OnPrem')]
    local procedure BeforeReleaseSalesDocSub(var SalesHeader: Record "Sales Header")
    var
        SalesHeaderL: Record "Sales Header";
        SalesLineL: Record "Sales Line";
    begin
        // Codeunit Release Sales Document
        // OnBeforeReleaseSalesDoc
        IF NOT SalesHeaderL.GET(SalesHeader."Document Type", SalesHeader."No.") THEN
            EXIT;

        SalesHeader.TESTFIELD("Service Center");

        SalesLineL.RESET;
        SalesLineL.SETRANGE("Document Type", SalesHeaderL."Document Type");
        SalesLineL.SETRANGE("Document No.", SalesHeaderL."No.");
        SalesLineL.SETRANGE(Type, SalesLineL.Type::"G/L Account", SalesLineL.Type::"Charge (Item)");
        IF SalesLineL.FINDFIRST THEN
            REPEAT
                SalesLineL.TESTFIELD("Service Center");
            UNTIL SalesLineL.NEXT = 0;
    end;

    [EventSubscriber(ObjectType::Codeunit, 414, 'OnAfterReleaseSalesDoc', '', false, false)]
    [Scope('OnPrem')]
    local procedure AfterReleaseSalesDocSub(var SalesHeader: Record "Sales Header")
    begin
        // Codeunit Release Sales Document
        // OnAfterReleaseSalesDoc
        SalesHeader."Check Flag" := TRUE;
        SalesHeader.MODIFY;
    end;

    [EventSubscriber(ObjectType::Codeunit, 414, 'OnAfterReopenSalesDoc', '', false, false)]
    [Scope('OnPrem')]
    local procedure AfterReopenSalesDocSub(var SalesHeader: Record "Sales Header")
    begin
        // Codeunit Release Sales Document
        // OnAfterReopenSalesDoc
        SalesHeader."Check Flag" := FALSE;
        SalesHeader.MODIFY;
    end;
}

