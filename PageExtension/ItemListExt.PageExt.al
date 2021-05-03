pageextension 1044862 "Item List Ext" extends "Item List"
{
    // +--------------------------------------------------------------+
    // | ?2005 ff. Begusch Software Systeme                          |
    // #3..53
    // HF21904   IT_21904 SS    2018-07-26  wrong page was opened when navigate to "Purchase Receipt Lines"
    // 
    // +--------------------------------------------------------------+
    // | ?2016 Incadea.fastfit                                       |
    // #59..64
    // 
    // +----------------------------------------------+
    // | Copyright (c) incadea China                  |
    // +----------------------------------------------+
    // TFS          ID             WHO    DATE        DESCRIPTION
    // 112079       RGS_TWN-647    GG     2018-02-27  Add new fields "Date created","Last Date Modified",Maintenance
    Caption = 'Item List';
    layout
    {
        addafter("Manufacturer Item No.")
        {
            field("Date created"; "Date created")
            {
            }
            field(Maintenance; Maintenance)
            {
            }
        }
    }


    //Unsupported feature: Property Modification (TextConstString) on "Text11500(Variable 1100023007)".

    //var
    //>>>> ORIGINAL VALUE:
    //Text11500 : DEU=Mchten Sie den neuen Artikel bearbeiten?;ENU=Do you want to edit the new item?;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //Text11500 : CHT=您想要編輯新料品?;ENU=Do you want to edit the new item?;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (TextConstString) on ""C_BSS_QUE001"(Variable 1100023005)".

    //var
    //>>>> ORIGINAL VALUE:
    //"C_BSS_QUE001" : DEU=Bitte geben Sie den Matchcode ein:\;ENU=Please enter Matchcode:\;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //"C_BSS_QUE001" : CHT=請輸入配對代碼:\;ENU=Please enter Matchcode:\;
    //Variable type has not been exported.


    //Unsupported feature: Code Modification on "ShowRcptLines(PROCEDURE 1115000017)".

    //procedure ShowRcptLines();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    //++BSS.IT_2160.WL
    PurchRcptLine.SETCURRENTKEY(Type,"No.");
    PurchRcptLine.SETRANGE(Type,PurchRcptLine.Type::Item);
    #4..11
    PurchReceiptLinesL.SETTABLEVIEW(PurchRcptLine);
    PurchReceiptLinesL.RUNMODAL
    //--BSS.IT_21904.SS
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..14
    //++BSS.IT_21634.SS
    //--BSS.IT_2160.WL
    */
    //end;

    //Unsupported feature: Property Modification (Id) on "ShowRcptLines(PROCEDURE 1115000017).PurchReceiptLinesL(Variable 1100023000)".

}

