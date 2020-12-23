pageextension 1044882 pageextension1044882 extends "Fast Contact Creation"
{
    // +--------------------------------------------------------------+
    // | ?2005 ff. Begusch Software Systeme                          |
    // #3..42
    // 
    // +--------------------------------------------------------------+
    // | @ 2017 incadea Taiwan Limited                                |
    // +--------------------------------------------------------------+
    // | PURPOSE: MARS_TWN                                            |
    // |                                                              |
    // +--------------------------------------------------------------+
    // 
    // VERSION      ID           WHO    DATE        DESCRIPTION
    // RGS_TWN-426               NN     2017-04-22  Added "Mobile Phone No. 2" & "Date of Birth"
    // RGS_TWN-342               AH     2017-05-19  Add Varible BillToComanyNameG and VATRegistrationNumG
    Caption = 'Fast Contact Creation';
    layout
    {
        addafter(ContactMobPhone)
        {
            field(ContactMobPhone2; ContactMobPhone2)
            {
                Caption = 'Mobile Phone No. 2';

                trigger OnValidate()
                begin
                    GetTempContact(TempContact);
                    // Start RGS_TWN-426
                    TempContact.VALIDATE("Mobile Phone No. 2", ContactMobPhone2);
                    // Stop RGS_TWN-426
                    SetTempContact(TempContact);
                end;
            }
        }
        addafter(ContactAddressHandling)
        {
            field(VATRegistrationNumG; VATRegistrationNumG)
            {
                Caption = 'VAT Registration No.';

                trigger OnValidate()
                begin
                    GetTempContact(TempContact);
                    //Start RGS_TWN-342
                    TempContact.VALIDATE("VAT Registration No.", VATRegistrationNumG);
                    //Stop RGS_TWN-342
                    SetTempContact(TempContact);
                end;
            }
            field(BillToComanyNameG; BillToComanyNameG)
            {
                Caption = 'Bill-to Company Name';

                trigger OnValidate()
                begin
                    GetTempContact(TempContact);
                    //Start RGS_TWN-342
                    TempContact.VALIDATE("Bill-to Company Name", BillToComanyNameG);
                    //Stop RGS_TWN-342
                    SetTempContact(TempContact);
                end;
            }
        }
    }

    var
        ContactMobPhone2: Text[50];
        BillToComanyNameG: Text[50];
        VATRegistrationNumG: Code[20];
        TempContact: Record Contact;
}


