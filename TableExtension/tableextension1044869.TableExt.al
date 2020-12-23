tableextension 1044869 tableextension1044869 extends "Sales & Receivables Setup"
{
    // +--------------------------------------------------------------+
    // | ?2005 ff. Begusch Software Systeme                          |
    // #3..50
    // +--------------------------------------------------------------+
    // | @ 2017 incadea Taiwan Limited                                |
    // +--------------------------------------------------------------+
    // | PURPOSE: MARS_TWN                                            |
    // +--------------------------------------------------------------+
    // 
    // VERSION       ID            WHO    DATE         DESCRIPTION
    //               RGS_TWN-334   NN     2017-04-19   Merge R3 Customization
    // TWN.01.02     RGS_TWN-567   NN     2017-06-12   Added field: DefaultVehicleChkInfoTmplCode (50003)
    // 
    // +--------------------------------------------------------------+
    // | @ 2019 incadea Taiwan Limited                                |
    // +--------------------------------------------------------------+
    // | PURPOSE: MARS_TWN                                            |
    // |                                                              |
    // | REMARK :                                                     |
    // +--------------------------------------------------------------+
    // 
    // VERSION       ID            WHO    DATE        DESCRIPTION
    // 120527        RGS_TWN-847   GG     2019-09-09  Added new field "Sales Alert Amount"
    // 121697        RGS_TWN-7889  QX     2020-05-25  Added field "No Modify Customer"
    // RGS_TWN-888   122187	       QX	  2020-11-23  "Vehicle Check Info Template" Table Removed

    fields
    {
        field(50000; "Sales Type"; Option)
        {
            Caption = 'Sales Type';
            Description = 'RGS_TWN-334';
            OptionCaption = 'Customer,Customer Price Group,All Customers,Campaign';
            OptionMembers = Customer,"Customer Price Group","All Customers",Campaign;
        }
        field(50001; "Price Includes VAT"; Boolean)
        {
            Caption = 'Price Includes VAT';
            Description = 'RGS_TWN-334';
        }
        //++TWN1.00.122187.QX
        // field(50003; DefaultVehicleChkInfoTmplCode; Code[10])
        field(50003; DefaultVehicleChkInfoTmplCode; Code[20])
        //TWN1.00.122187.QX
        {
            Caption = 'Default Vehicle Check Info Tmpl Code';
            Description = 'TWN.01.02';
            //++TWN1.00.122187.QX
            // TableRelation = "Vehicle Check Info Template".Code;
            //--TWN1.00.122187.QX
        }
        field(50004; "No Modify Customer"; Code[100])
        {
            Caption = 'No Modify Customer';
            Description = '121697';
        }
        field(1018622; "Return Reason"; Code[20])
        {
            Caption = 'Return Reason';
            Description = 'IT_5729';
            TableRelation = "Return Reason";
        }
        field(1044870; "Sales Alert Amount"; Decimal)
        {
            Caption = 'Sales Alert Amount';
            Description = '120527';
            MinValue = 0;
        }
    }
}

