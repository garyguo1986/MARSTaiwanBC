pageextension 1044881 "Contact List Ext" extends "Contact List"
{
    actions
    {
        addafter("Co&mments")
        {
            action(Agreement)
            {
                Caption = 'Agreement';
                Image = PrintDocument;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunPageMode = View;

                trigger OnAction()
                var
                    AgreementL: Page "Customer Agreement List";
                begin
                    //++Inc.TWN-327.AH
                    IF ("No." <> '') THEN BEGIN
                        CLEAR(AgreementL);
                        AgreementL.SetContact("No.");
                        AgreementL.RUNMODAL;
                    END;
                    //--Inc.TWN-327.AH
                end;
            }
        }
    }
}

