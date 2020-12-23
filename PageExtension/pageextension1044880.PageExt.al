pageextension 1044880 pageextension1044880 extends "Fast Contact Vehicle Creation"
{
    // 
    // +--------------------------------------------------------------+
    // | ?2015 ff. Begusch Software Systeme                          |
    // #4..32
    // 090000    IT_21635 AK     2018-02-01  fix bug for average mileage calculation if "Registration Date" = TODAY
    // 
    // +--------------------------------------------------------------+
    // | @ 2017 incadea Taiwan Limited                                |
    // +--------------------------------------------------------------+
    // | PURPOSE: MARS_TWN                                            |
    // |                                                              |
    // +--------------------------------------------------------------+
    // 
    // VERSION       ID           WHO    DATE        DESCRIPTION
    // RGS_TWN-426                NN     2017-04-22  Added "Mobile Phone No. 2", "Date of Birth" on Contact tab
    //                                              Added "Vehicle Identification No." on Vehicle tab
    // RGS_TWN-342                AH     2017-05-19  Add Varible BillToComanyNameG and VATRegistrationNumG
    // TWN.01.02     RGS_TWN-567  NN     2017-06-12  Added default value in field "Vehicle Check Info Tmpl Code".
    Caption = 'Fast Contact/Vehicle Creation';
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
                    TempContact.VALIDATE("Mobile Phone No. 2", ContactMobPhone2);
                    SetTempContact(TempContact);
                end;
            }
            // field(ContactDateOfBirth; ContactDateofBirth)
            // {
            //     Caption = 'Date of Birth';

            //     trigger OnValidate()
            //     begin
            //         TempContact.VALIDATE("Date of Birth", ContactDateofBirth);
            //     end;
            // }
        }
        addafter(ContactDateofBirth)
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
        // addafter(SearchName)
        // {
        //     field(VehicleIdenNo; VehicleIdenNo)
        //     {
        //         Caption = 'Vehicle Identification No.';

        //         trigger OnValidate()
        //         begin
        //             GetTempVehicls(TempVehicle);
        //             TempVehicle.VALIDATE("Vehicle Identification No.", VehicleIdenNo);
        //         end;
        //     }
        // }
    }

    var
        ContactMobPhone2: Text[50];
        // VehicleIdenNo: Code[20];
        BillToComanyNameG: Text[50];
        VATRegistrationNumG: Code[20];
        // SaleRecevSetup: Record "Sales & Receivables Setup";
        TempContact: Record Contact;
    // TempVehicle: Record Vehicle;

}

