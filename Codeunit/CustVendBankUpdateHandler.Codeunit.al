codeunit 1073871 "CustVendBank-Update Handler"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"CustVendBank-Update", 'OnAfterUpdateCustomer', '', true, true)]
    local procedure OnAfterUpdateCustomer_ClearVATRegNo(var Customer: Record Customer; Contact: Record Contact)
    begin
        if Customer."Central Maintenance" then
            Contact."VAT Registration No." := '';
    end;
}
