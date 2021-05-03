xmlport 1045238 "OCT PO"
{
    // +--------------------------------------------------------------
    // |  2019 Incadea China Software System                          |
    // +--------------------------------------------------------------+
    // | PURPOSE: Local Customization                                 |
    // |                                                              |
    // | REMARK :                                                     |
    // +--------------------------------------------------------------+
    // 
    // VERSION       ID          WHO    DATE        DESCRIPTION
    // RGS_TWN-874   122010      GG     2020-08-23  Object copy from mars cn

    Direction = Import;
    Encoding = UTF8;

    schema
    {
        tableelement("Purchase Header"; "Purchase Header")
        {
            XmlName = 'root';
            UseTemporary = true;
            fieldelement(referenceNo; "Purchase Header"."OCT Order No.")
            {

                trigger OnAfterAssignField()
                begin
                    CASE POStatus("Purchase Header"."OCT Order No.") OF
                        1:
                            ERROR(C_MIL_ERR001, "Purchase Header"."OCT Order No.");
                        2:
                            ERROR(C_MIL_ERR002, "Purchase Header"."OCT Order No.");
                    END;
                end;
            }
            fieldelement(serviceCenterCode; "Purchase Header"."Service Center")
            {
            }
            textelement(orderDate)
            {
                MaxOccurs = Once;

                trigger OnAfterAssignVariable()
                begin
                    TempDateG := 0D;
                    IF TypeHelperG.Evaluate(TempDateG, orderDate, DateFormat, '') THEN
                        "Purchase Header"."Order Date" := TempDateG;
                end;
            }
            textelement(locationCode)
            {
                MinOccurs = Zero;
            }
            textelement(shipDate)
            {
                MaxOccurs = Once;

                trigger OnAfterAssignVariable()
                begin
                    TempDateG := 0D;
                    IF TypeHelperG.Evaluate(TempDateG, shipDate, DateFormat, '') THEN
                        "Purchase Header"."Posting Date" := TempDateG;
                end;
            }
            textelement(lines)
            {
                MaxOccurs = Once;
                tableelement("Purchase Line"; "Purchase Line")
                {
                    XmlName = 'item';
                    UseTemporary = true;
                    textelement(discount)
                    {
                    }
                    fieldelement(lineNo; "Purchase Line"."OCT Line No.")
                    {
                    }
                    textelement(mfgrCode)
                    {
                    }
                    textelement(description)
                    {

                        trigger OnAfterAssignVariable()
                        var
                            L: Integer;
                        begin
                            IF description <> '' THEN BEGIN
                                L := STRLEN(description);
                                IF L <= DescLengthG THEN
                                    "Purchase Line".Description := description
                                ELSE
                                    IF L <= DescLengthG * 2 - 3 THEN BEGIN
                                        "Purchase Line".Description := COPYSTR(description, 1, DescLengthG);
                                        "Purchase Line"."Description 2" := COPYSTR(description, DescLengthG + 1);
                                    END ELSE BEGIN
                                        "Purchase Line".Description := COPYSTR(description, 1, DescLengthG);
                                        "Purchase Line"."Description 2" := COPYSTR(description, DescLengthG + 1, DescLengthG - 3) + '...';
                                    END;
                            END;
                        end;
                    }
                    fieldelement(quantity; "Purchase Line".Quantity)
                    {
                    }
                    fieldelement(lineTotal; "Purchase Line"."Line Amount")
                    {
                    }
                    fieldelement(itemType; "Purchase Line".Type)
                    {

                        trigger OnAfterAssignField()
                        var
                            ItemL: Record Item;
                            ResourceL: Record Resource;
                        begin
                            IF "Purchase Line".Type = "Purchase Line".Type::Item THEN BEGIN
                                //ItemL.SETCURRENTKEY("Mfgr Code");
                                //ItemL.SETRANGE("Mfgr Code",mfgrCode);
                                ItemL.SETCURRENTKEY("Manufacturer Item No.");
                                ItemL.SETRANGE("Manufacturer Item No.", mfgrCode);
                                ItemL.FINDFIRST;

                                "Purchase Line"."No." := ItemL."No.";
                            END ELSE BEGIN
                                ERROR(C_MIL_ERR004);
                                //ResourceL.SETCURRENTKEY("Mfgr Code");
                                //ResourceL.SETRANGE("Mfgr Code",mfgrCode);
                                //ResourceL.FINDFIRST;

                                //"Purchase Line"."No." := ResourceL."No.";
                            END;
                        end;
                    }

                    trigger OnAfterInitRecord()
                    begin
                        LineNoG += 10000;
                        "Purchase Line"."Line No." := LineNoG;
                    end;
                }
            }
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    trigger OnInitXmlPort()
    begin
        DescLengthG := 50;
    end;

    trigger OnPostXmlPort()
    var
        BinCodeL: Code[20];
    begin
        IF NOT ("Purchase Header".FINDFIRST AND "Purchase Line".FINDFIRST) THEN
            EXIT;

        VendorG.SETRANGE("Deleted by HQ", FALSE);
        VendorG.SETRANGE(Michelin, TRUE);
        IF NOT VendorG.FINDFIRST THEN
            ERROR(C_MIL_ERR003);

        InterfaceSessionG.INIT;
        //InterfaceSessionG."Service Center Code" := "Purchase Header"."Shortcut Dimension 1 Code";
        InterfaceSessionG."Service Center Code" := "Purchase Header"."Service Center";
        InterfaceSessionG."Interface Type" := InterfaceSessionG."Interface Type"::OCT;
        InterfaceSessionG.INSERT(TRUE);

        IF PONoG <> '' THEN BEGIN
            PurchHeaderG.RESET;
            PurchHeaderG.GET(PurchHeaderG."Document Type"::Order, PONoG);
            PurchLineG.RESET;
            PurchLineG.SETRANGE("Document Type", PurchHeaderG."Document Type");
            PurchLineG.SETRANGE("Document No.", PurchHeaderG."No.");
            PurchLineG.DELETEALL(TRUE);
            PurchLineG.RESET;
        END ELSE BEGIN
            PurchHeaderG.INIT;
            PurchHeaderG."Document Type" := PurchHeaderG."Document Type"::Order;
            PurchHeaderG.INSERT(TRUE);
            PONoG := PurchHeaderG."No.";
        END;

        PurchHeaderG.VALIDATE("Buy-from Vendor No.", VendorG."No.");
        IF "Purchase Header"."Order Date" = 0D THEN
            PurchHeaderG.VALIDATE("Order Date", WORKDATE)
        ELSE
            PurchHeaderG.VALIDATE("Order Date", "Purchase Header"."Order Date");
        IF "Purchase Header"."Posting Date" = 0D THEN
            PurchHeaderG.VALIDATE("Posting Date", WORKDATE)
        ELSE
            PurchHeaderG.VALIDATE("Posting Date", "Purchase Header"."Posting Date");
        PurchHeaderG.VALIDATE("Document Date", WORKDATE);
        PurchHeaderG."OCT Order No." := "Purchase Header"."OCT Order No.";
        //PurchHeaderG.VALIDATE("Shortcut Dimension 1 Code","Purchase Header"."Shortcut Dimension 1 Code");
        //PurchHeaderG.VALIDATE("Service Center", "Purchase Header"."Shortcut Dimension 1 Code");
        PurchHeaderG.VALIDATE("Service Center", "Purchase Header"."Service Center");
        PurchHeaderG.VALIDATE("Responsibility Center", "Purchase Header"."Service Center");
        PurchHeaderG.MODIFY(TRUE);

        REPEAT
            PurchLineG.INIT;
            PurchLineG."Document Type" := PurchHeaderG."Document Type";
            PurchLineG."Document No." := PurchHeaderG."No.";
            PurchLineG."Line No." := "Purchase Line"."Line No.";
            PurchLineG.INSERT(TRUE);

            PurchLineG.Type := "Purchase Line".Type;
            PurchLineG.VALIDATE("No.", "Purchase Line"."No.");
            PurchLineG.VALIDATE(Quantity, "Purchase Line".Quantity);
            PurchLineG.VALIDATE("Direct Unit Cost", "Purchase Line"."Line Amount" / "Purchase Line".Quantity);
            IF PurchLineG.Type = PurchLineG.Type::Item THEN BEGIN
                //BinCodeL := ShopBasketG.GetItemDefaultBinCode(PurchLineG."Location Code",PurchLineG."No.");
                IF BinCodeL <> '' THEN
                    PurchLineG.VALIDATE("Bin Code", BinCodeL);
            END;
            PurchLineG."OCT Line No." := "Purchase Line"."OCT Line No.";
            IF "Purchase Line".Description <> '' THEN BEGIN
                PurchLineG.Description := "Purchase Line".Description;
                PurchLineG."Description 2" := "Purchase Line"."Description 2";
            END;
            PurchLineG.MODIFY(TRUE);
        UNTIL "Purchase Line".NEXT = 0;

        InterfaceSessionG.DELETE;
    end;

    var
        PONoG: Code[20];
        LineNoG: Integer;
        PurchHeaderG: Record "Purchase Header";
        C_MIL_ERR001: Label 'The OCT Order No. %1 is not open,cannot import it again.';
        C_MIL_ERR002: Label 'The OCT Order No. %1 has been posted already.';
        PurchLineG: Record "Purchase Line";
        VendorG: Record Vendor;
        C_MIL_ERR003: Label 'Vendor Michelin does not exist.';
        ShopBasketG: Codeunit "Shop. Basket Functions";
        TypeHelperG: Codeunit "Type Helper";
        TempDateG: Variant;
        DateFormat: Label 'yyyy/M/d';
        InterfaceSessionG: Record "CFT Session Event";
        DescLengthG: Integer;
        C_MIL_ERR004: Label 'The OCT Order can not receive resource now.';

    [Scope('OnPrem')]
    procedure GetPONo(): Code[20]
    begin
        EXIT(PONoG);
    end;

    local procedure POStatus(OCTOrderNoP: Text[30]): Integer
    var
        PurchInvHeaderL: Record "Purch. Inv. Header";
    begin
        PONoG := '';

        PurchInvHeaderL.SETCURRENTKEY("OCT Order No.");
        PurchInvHeaderL.SETRANGE("OCT Order No.", OCTOrderNoP);
        IF PurchInvHeaderL.FINDFIRST THEN
            EXIT(2);    //Posted

        PurchHeaderG.RESET;
        PurchHeaderG.SETCURRENTKEY("OCT Order No.");
        PurchHeaderG.SETRANGE("Document Type", PurchHeaderG."Document Type"::Order);
        PurchHeaderG.SETRANGE("OCT Order No.", OCTOrderNoP);
        IF PurchHeaderG.FINDFIRST THEN BEGIN
            PONoG := PurchHeaderG."No.";
            IF PurchHeaderG.Status <> PurchHeaderG.Status::Open THEN
                EXIT(1);  //Not Open
        END;

        EXIT(0);      //Not Found
    end;
}

