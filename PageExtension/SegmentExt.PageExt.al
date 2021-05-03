pageextension 1044892 "Segment Ext" extends Segment
{
    // +--------------------------------------------------------------+
    // | ?2006 ff. Begusch Software Systeme                          |
    // #3..20
    // +----------------------------------------------+
    // | Copyright (c) incadea China                  |
    // +----------------------------------------------+
    // TFS          ID             WHO    DATE        DESCRIPTION
    // 111127                      SY     2018-02-09  Modiffy PageAction Add Contacts and Reduce Contacts
    // 114096       MARS_TWN_6567  GG     2018-05-09  Change button "Add Contacts" and "Remove Contacts"
    // RGS_AGL-3620  121528        GG     2020-04-22  Add field "Central Maintenance" and event publisher OnAfterOpenPageEvent
    //                                    2020-07-28  Add function Reopen and Release
    actions
    {
        modify(AddContacts)
        {
            Visible = false;
        }
        modify(ReduceContacts)
        {
            Visible = false;
        }
        addafter(AddContacts)
        {
            action(AddContactTWN)
            {
                Caption = 'Add Contacts';
                Ellipsis = true;
                Image = AddContacts;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    AddContacts: Report "Add Contacts (TWN)";
                    SegHeader: Record "Segment Header";
                    Cont: Record Contact;
                    ContProfileAnswer: Record "Contact Profile Answer";
                    ContMailingGrp: Record "Contact Mailing Group";
                    InteractLogEntry: Record "Interaction Log Entry";
                    ContJobResp: Record "Contact Job Responsibility";
                    ContIndustGrp: Record "Contact Profile Answer";
                    ContBusRel: Record "Contact Business Relation";
                    ValueEntry: Record "Value Entry";
                    VehiclesL: Record Vehicle;
                    DepotsL: Record "Tire Hotel";
                    SalesInvoiceHeaderL: Record "Sales Invoice Header";
                    SalesInvoiceLineL: Record "Sales Invoice Line";
                begin
                    SegHeader := Rec;
                    SegHeader.SETRECFILTER;
                    AddContacts.SETTABLEVIEW(SegHeader);
                    AddContacts.SETTABLEVIEW(Cont);
                    // Start 114096
                    //AddContacts.SETTABLEVIEW(ContProfileAnswer);
                    //AddContacts.SETTABLEVIEW(ContMailingGrp);
                    //AddContacts.SETTABLEVIEW(InteractLogEntry);
                    //AddContacts.SETTABLEVIEW(ContJobResp);
                    //AddContacts.SETTABLEVIEW(ContIndustGrp);
                    //AddContacts.SETTABLEVIEW(ContBusRel);
                    //AddContacts.SETTABLEVIEW(ValueEntry);
                    // Stop SalesInvoiceLineL
                    //Strat 111127
                    AddContacts.SETTABLEVIEW(SalesInvoiceHeaderL);
                    //Stop 111127
                    //++BSS.IT_5519.MH
                    AddContacts.SETTABLEVIEW(VehiclesL);
                    // Start 114096
                    //AddContacts.SETTABLEVIEW(DepotsL);
                    AddContacts.SETTABLEVIEW(SalesInvoiceLineL);
                    // Stop 114096
                    //--BSS.IT_5519.MH
                    AddContacts.RUNMODAL;
                end;
            }
        }
        addafter(ReduceContacts)
        {
            action(ReduceContactsTWN)
            {
                Caption = 'Reduce Contacts';
                Ellipsis = true;
                Image = RemoveContacts;

                trigger OnAction()
                var
                    ReduceContacts: Report "Remove Contacts - Reduce (TWN)";
                    SegHeader: Record "Segment Header";
                    Cont: Record Contact;
                    ContProfileAnswer: Record "Contact Profile Answer";
                    ContMailingGrp: Record "Contact Mailing Group";
                    InteractLogEntry: Record "Interaction Log Entry";
                    ContJobResp: Record "Contact Job Responsibility";
                    ContIndustGrp: Record "Contact Industry Group";
                    ContBusRel: Record "Contact Business Relation";
                    ValueEntry: Record "Value Entry";
                    VehiclesL: Record Vehicle;
                    DepotsL: Record "Tire Hotel";
                    SalesInvoiceHeaderL: Record "Sales Invoice Header";
                    SalesInvoiceLineL: Record "Sales Invoice Line";
                begin
                    SegHeader := Rec;
                    SegHeader.SETRECFILTER;
                    ReduceContacts.SETTABLEVIEW(SegHeader);
                    ReduceContacts.SETTABLEVIEW(Cont);
                    // Start 114096
                    //ReduceContacts.SETTABLEVIEW(ContProfileAnswer);
                    //ReduceContacts.SETTABLEVIEW(ContMailingGrp);
                    //ReduceContacts.SETTABLEVIEW(InteractLogEntry);
                    //ReduceContacts.SETTABLEVIEW(ContJobResp);
                    //ReduceContacts.SETTABLEVIEW(ContIndustGrp);
                    //ReduceContacts.SETTABLEVIEW(ContBusRel);
                    //ReduceContacts.SETTABLEVIEW(ValueEntry);
                    // Stop 114096
                    //Strat 111127
                    ReduceContacts.SETTABLEVIEW(SalesInvoiceHeaderL);
                    //Stop 111127
                    //++BSS.IT_5519.MH
                    ReduceContacts.SETTABLEVIEW(VehiclesL);
                    // Start 114096
                    //ReduceContacts.SETTABLEVIEW(DepotsL);
                    ReduceContacts.SETTABLEVIEW(SalesInvoiceLineL);
                    // Stop 114096
                    //--BSS.IT_5519.MH
                    ReduceContacts.RUNMODAL;
                end;
            }
        }
    }
}

