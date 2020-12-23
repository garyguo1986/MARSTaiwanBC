codeunit 1073870 "CU User Setup Management Hdr."
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"User Setup Management", 'OnBeforeCheckRespCenter2', '', true, false)]
    /// <summary> 
    /// Description for SkipCheckPurchaseHeaderResponsibilityCenter.
    /// </summary>
    /// <param name="DocType">Parameter of type Option Sales,Purchase,Service.</param>
    /// <param name="AccRespCenter">Parameter of type Code[10].</param>
    /// <param name="UserCode">Parameter of type Code[50].</param>
    /// <param name="IsHandled">Parameter of type Boolean.</param>
    /// <param name="Result">Parameter of type Boolean.</param>
    local procedure SkipCheckPurchaseHeaderResponsibilityCenter(DocType: Option Sales,Purchase,Service; AccRespCenter: Code[10]; UserCode: Code[50]; var IsHandled: Boolean; var Result: Boolean)
    begin
        if (DocType = DocType::Purchase) then begin
            if (CurrentClientType in [ClientType::OData, ClientType::ODataV4, ClientType::SOAP]) then begin
                IsHandled := true;
                Result := true;
            end;
        end;
    end;
}
