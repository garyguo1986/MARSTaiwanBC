table 1044870 "Sales Invoice Line Buffer"
{
    Caption = 'Sales Invoice Line Buffer';
    Permissions = TableData "Item Ledger Entry" = r,
                  TableData "Value Entry" = r;

    fields
    {
        field(2; "Sell-to Customer No."; Code[20])
        {
            Caption = 'Sell-to Customer No.';
            Editable = false;
            TableRelation = Customer;
        }
        field(3; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            TableRelation = "Sales Invoice Header";
        }
        field(4; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(5; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = ' ,G/L Account,Item,Resource,Fixed Asset,Charge (Item)';
            OptionMembers = " ","G/L Account",Item,Resource,"Fixed Asset","Charge (Item)";
        }
        field(6; "No."; Code[20])
        {
            CaptionClass = GetCaptionClass(FieldNo("No."));
            Caption = 'No.';
            TableRelation = IF (Type = CONST("G/L Account")) "G/L Account"
            ELSE
            IF (Type = CONST(Item)) Item
            ELSE
            IF (Type = CONST(Resource)) Resource
            ELSE
            IF (Type = CONST("Fixed Asset")) "Fixed Asset"
            ELSE
            IF (Type = CONST("Charge (Item)")) "Item Charge";
        }
        field(7; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            TableRelation = Location WHERE("Use As In-Transit" = CONST(false));
        }
        field(8; "Posting Group"; Code[20])
        {
            Caption = 'Posting Group';
            Editable = false;
            TableRelation = IF (Type = CONST(Item)) "Inventory Posting Group"
            ELSE
            IF (Type = CONST("Fixed Asset")) "FA Posting Group";
        }
        field(10; "Shipment Date"; Date)
        {
            Caption = 'Shipment Date';
        }
        field(11; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(12; "Description 2"; Text[50])
        {
            Caption = 'Description 2';
        }
        field(13; "Unit of Measure"; Text[50])
        {
            Caption = 'Unit of Measure';
            Description = 'TFS_14782';
            TableRelation = "Unit of Measure".Description;
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(15; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DecimalPlaces = 0 : 5;
        }
        field(22; "Unit Price"; Decimal)
        {
            AutoFormatExpression = GetCurrencyCode;
            AutoFormatType = 2;
            CaptionClass = GetCaptionClass(FieldNo("Unit Price"));
            Caption = 'Unit Price';
        }
        field(23; "Unit Cost (LCY)"; Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Unit Cost (LCY)';
        }
        field(25; "VAT %"; Decimal)
        {
            Caption = 'VAT %';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(27; "Line Discount %"; Decimal)
        {
            Caption = 'Line Discount %';
            DecimalPlaces = 0 : 5;
            MaxValue = 100;
            MinValue = 0;
        }
        field(28; "Line Discount Amount"; Decimal)
        {
            AutoFormatExpression = GetCurrencyCode;
            AutoFormatType = 1;
            Caption = 'Line Discount Amount';
        }
        field(29; Amount; Decimal)
        {
            AutoFormatExpression = GetCurrencyCode;
            AutoFormatType = 1;
            Caption = 'Amount';
        }
        field(30; "Amount Including VAT"; Decimal)
        {
            AutoFormatExpression = GetCurrencyCode;
            AutoFormatType = 1;
            Caption = 'Amount Including VAT';
        }
        field(32; "Allow Invoice Disc."; Boolean)
        {
            Caption = 'Allow Invoice Disc.';
            InitValue = true;
        }
        field(34; "Gross Weight"; Decimal)
        {
            Caption = 'Gross Weight';
            DecimalPlaces = 0 : 5;
        }
        field(35; "Net Weight"; Decimal)
        {
            Caption = 'Net Weight';
            DecimalPlaces = 0 : 5;
        }
        field(36; "Units per Parcel"; Decimal)
        {
            Caption = 'Units per Parcel';
            DecimalPlaces = 0 : 5;
        }
        field(37; "Unit Volume"; Decimal)
        {
            Caption = 'Unit Volume';
            DecimalPlaces = 0 : 5;
        }
        field(38; "Appl.-to Item Entry"; Integer)
        {
            AccessByPermission = TableData Item = R;
            Caption = 'Appl.-to Item Entry';
        }
        field(40; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(41; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(42; "Customer Price Group"; Code[20])
        {
            Caption = 'Customer Price Group';
            Description = 'IT_20876';
            TableRelation = "Customer Price Group";
        }
        field(45; "Job No."; Code[20])
        {
            Caption = 'Job No.';
            TableRelation = Job;
        }
        field(52; "Work Type Code"; Code[10])
        {
            Caption = 'Work Type Code';
            TableRelation = "Work Type";
        }
        field(63; "Shipment No."; Code[20])
        {
            Caption = 'Shipment No.';
            Editable = false;
        }
        field(64; "Shipment Line No."; Integer)
        {
            Caption = 'Shipment Line No.';
            Editable = false;
        }
        field(65; "Order No."; Code[20])
        {
            Caption = 'Order No.';
        }
        field(66; "Order Line No."; Integer)
        {
            Caption = 'Order Line No.';
        }
        field(68; "Bill-to Customer No."; Code[20])
        {
            Caption = 'Bill-to Customer No.';
            Editable = false;
            TableRelation = Customer;
        }
        field(69; "Inv. Discount Amount"; Decimal)
        {
            AutoFormatExpression = GetCurrencyCode;
            AutoFormatType = 1;
            Caption = 'Inv. Discount Amount';
        }
        field(73; "Drop Shipment"; Boolean)
        {
            AccessByPermission = TableData "Drop Shpt. Post. Buffer" = R;
            Caption = 'Drop Shipment';
        }
        field(74; "Gen. Bus. Posting Group"; Code[20])
        {
            Caption = 'Gen. Bus. Posting Group';
            TableRelation = "Gen. Business Posting Group";
        }
        field(75; "Gen. Prod. Posting Group"; Code[20])
        {
            Caption = 'Gen. Prod. Posting Group';
            TableRelation = "Gen. Product Posting Group";
        }
        field(77; "VAT Calculation Type"; Option)
        {
            Caption = 'VAT Calculation Type';
            OptionCaption = 'Normal VAT,Reverse Charge VAT,Full VAT,Sales Tax';
            OptionMembers = "Normal VAT","Reverse Charge VAT","Full VAT","Sales Tax";
        }
        field(78; "Transaction Type"; Code[10])
        {
            Caption = 'Transaction Type';
            TableRelation = "Transaction Type";
        }
        field(79; "Transport Method"; Code[10])
        {
            Caption = 'Transport Method';
            TableRelation = "Transport Method";
        }
        field(80; "Attached to Line No."; Integer)
        {
            Caption = 'Attached to Line No.';
            TableRelation = "Sales Invoice Line"."Line No." WHERE("Document No." = FIELD("Document No."));
        }
        field(81; "Exit Point"; Code[10])
        {
            Caption = 'Exit Point';
            TableRelation = "Entry/Exit Point";
        }
        field(82; "Area"; Code[10])
        {
            Caption = 'Area';
            TableRelation = Area;
        }
        field(83; "Transaction Specification"; Code[10])
        {
            Caption = 'Transaction Specification';
            TableRelation = "Transaction Specification";
        }
        field(84; "Tax Category"; Code[10])
        {
            Caption = 'Tax Category';
        }
        field(85; "Tax Area Code"; Code[20])
        {
            Caption = 'Tax Area Code';
            TableRelation = "Tax Area";
        }
        field(86; "Tax Liable"; Boolean)
        {
            Caption = 'Tax Liable';
        }
        field(87; "Tax Group Code"; Code[20])
        {
            Caption = 'Tax Group Code';
            TableRelation = "Tax Group";
        }
        field(88; "VAT Clause Code"; Code[20])
        {
            Caption = 'VAT Clause Code';
            TableRelation = "VAT Clause";
        }
        field(89; "VAT Bus. Posting Group"; Code[20])
        {
            Caption = 'VAT Bus. Posting Group';
            TableRelation = "VAT Business Posting Group";
        }
        field(90; "VAT Prod. Posting Group"; Code[20])
        {
            Caption = 'VAT Prod. Posting Group';
            TableRelation = "VAT Product Posting Group";
        }
        field(97; "Blanket Order No."; Code[20])
        {
            Caption = 'Blanket Order No.';
            TableRelation = "Sales Header"."No." WHERE("Document Type" = CONST("Blanket Order"));
            //This property is currently not supported
            //TestTableRelation = false;
        }
        field(98; "Blanket Order Line No."; Integer)
        {
            Caption = 'Blanket Order Line No.';
            TableRelation = "Sales Line"."Line No." WHERE("Document Type" = CONST("Blanket Order"),
                                                           "Document No." = FIELD("Blanket Order No."));
            //This property is currently not supported
            //TestTableRelation = false;
        }
        field(99; "VAT Base Amount"; Decimal)
        {
            AutoFormatExpression = GetCurrencyCode;
            AutoFormatType = 1;
            Caption = 'VAT Base Amount';
            Editable = false;
        }
        field(100; "Unit Cost"; Decimal)
        {
            AutoFormatExpression = GetCurrencyCode;
            AutoFormatType = 2;
            Caption = 'Unit Cost';
            Editable = false;
        }
        field(101; "System-Created Entry"; Boolean)
        {
            Caption = 'System-Created Entry';
            Editable = false;
        }
        field(103; "Line Amount"; Decimal)
        {
            AutoFormatExpression = GetCurrencyCode;
            AutoFormatType = 1;
            CaptionClass = GetCaptionClass(FieldNo("Line Amount"));
            Caption = 'Line Amount';
        }
        field(104; "VAT Difference"; Decimal)
        {
            AutoFormatExpression = GetCurrencyCode;
            AutoFormatType = 1;
            Caption = 'VAT Difference';
        }
        field(106; "VAT Identifier"; Code[20])
        {
            Caption = 'VAT Identifier';
            Editable = false;
        }
        field(107; "IC Partner Ref. Type"; Option)
        {
            Caption = 'IC Partner Ref. Type';
            OptionCaption = ' ,G/L Account,Item,,,Charge (Item),Cross reference,Common Item No.';
            OptionMembers = " ","G/L Account",Item,,,"Charge (Item)","Cross reference","Common Item No.";
        }
        field(108; "IC Partner Reference"; Code[30])
        {
            Caption = 'IC Partner Reference';
        }
        field(123; "Prepayment Line"; Boolean)
        {
            Caption = 'Prepayment Line';
            Editable = false;
        }
        field(130; "IC Partner Code"; Code[20])
        {
            Caption = 'IC Partner Code';
            TableRelation = "IC Partner";
        }
        field(131; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }
        field(145; "Pmt. Discount Amount"; Decimal)
        {
            AutoFormatExpression = GetCurrencyCode;
            AutoFormatType = 1;
            Caption = 'Pmt. Discount Amount';
        }
        field(180; "Line Discount Calculation"; Option)
        {
            Caption = 'Line Discount Calculation';
            OptionCaption = 'None,%,Amount';
            OptionMembers = "None","%",Amount;
        }
        field(480; "Dimension Set ID"; Integer)
        {
            Caption = 'Dimension Set ID';
            Editable = false;
            TableRelation = "Dimension Set Entry";

            trigger OnLookup()
            begin
            end;
        }
        field(1001; "Job Task No."; Code[20])
        {
            Caption = 'Job Task No.';
            Editable = false;
            TableRelation = "Job Task"."Job Task No." WHERE("Job No." = FIELD("Job No."));
        }
        field(1002; "Job Contract Entry No."; Integer)
        {
            Caption = 'Job Contract Entry No.';
            Editable = false;
        }
        field(1700; "Deferral Code"; Code[10])
        {
            Caption = 'Deferral Code';
            TableRelation = "Deferral Template"."Deferral Code";
        }
        field(5402; "Variant Code"; Code[10])
        {
            Caption = 'Variant Code';
            TableRelation = IF (Type = CONST(Item)) "Item Variant".Code WHERE("Item No." = FIELD("No."));
        }
        field(5403; "Bin Code"; Code[20])
        {
            Caption = 'Bin Code';
            TableRelation = Bin.Code WHERE("Location Code" = FIELD("Location Code"),
                                            "Item Filter" = FIELD("No."),
                                            "Variant Filter" = FIELD("Variant Code"));
        }
        field(5404; "Qty. per Unit of Measure"; Decimal)
        {
            Caption = 'Qty. per Unit of Measure';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(5407; "Unit of Measure Code"; Code[10])
        {
            Caption = 'Unit of Measure Code';
            TableRelation = IF (Type = CONST(Item)) "Item Unit of Measure".Code WHERE("Item No." = FIELD("No."))
            ELSE
            "Unit of Measure";
        }
        field(5415; "Quantity (Base)"; Decimal)
        {
            Caption = 'Quantity (Base)';
            DecimalPlaces = 0 : 5;
        }
        field(5600; "FA Posting Date"; Date)
        {
            Caption = 'FA Posting Date';
        }
        field(5602; "Depreciation Book Code"; Code[10])
        {
            Caption = 'Depreciation Book Code';
            TableRelation = "Depreciation Book";
        }
        field(5605; "Depr. until FA Posting Date"; Boolean)
        {
            Caption = 'Depr. until FA Posting Date';
        }
        field(5612; "Duplicate in Depreciation Book"; Code[10])
        {
            Caption = 'Duplicate in Depreciation Book';
            TableRelation = "Depreciation Book";
        }
        field(5613; "Use Duplication List"; Boolean)
        {
            Caption = 'Use Duplication List';
        }
        field(5700; "Responsibility Center"; Code[10])
        {
            Caption = 'Responsibility Center';
            TableRelation = "Responsibility Center";
        }
        field(5705; "Cross-Reference No."; Code[30])
        {
            AccessByPermission = TableData "Item Cross Reference" = R;
            Caption = 'Cross-Reference No.';
        }
        field(5706; "Unit of Measure (Cross Ref.)"; Code[10])
        {
            Caption = 'Unit of Measure (Cross Ref.)';
            TableRelation = IF (Type = CONST(Item)) "Item Unit of Measure".Code WHERE("Item No." = FIELD("No."));
        }
        field(5707; "Cross-Reference Type"; Option)
        {
            Caption = 'Cross-Reference Type';
            OptionCaption = ' ,Customer,Vendor,Bar Code';
            OptionMembers = " ",Customer,Vendor,"Bar Code";
        }
        field(5708; "Cross-Reference Type No."; Code[30])
        {
            Caption = 'Cross-Reference Type No.';
        }
        field(5709; "Item Category Code"; Code[20])
        {
            Caption = 'Item Category Code';
            TableRelation = IF (Type = CONST(Item)) "Item Category";
        }
        field(5710; Nonstock; Boolean)
        {
            Caption = 'Catalog';
        }
        field(5711; "Purchasing Code"; Code[10])
        {
            Caption = 'Purchasing Code';
            TableRelation = Purchasing;
        }
        // field(5712; "Product Group Code"; Code[10])
        // {
        //     Caption = 'Product Group Code';
        //     ObsoleteReason = 'Product Groups became first level children of Item Categories.';
        //     ObsoleteState = Removed;
        //     TableRelation = "Product Group".Code WHERE("Item Category Code" = FIELD("Item Category Code"));
        //     ValidateTableRelation = false;
        //     ObsoleteTag = '15.0';
        // }
        field(5811; "Appl.-from Item Entry"; Integer)
        {
            AccessByPermission = TableData Item = R;
            Caption = 'Appl.-from Item Entry';
            MinValue = 0;
        }
        field(6608; "Return Reason Code"; Code[10])
        {
            Caption = 'Return Reason Code';
            TableRelation = "Return Reason";
        }
        field(7001; "Allow Line Disc."; Boolean)
        {
            Caption = 'Allow Line Disc.';
            InitValue = true;
        }
        field(7002; "Customer Disc. Group"; Code[20])
        {
            Caption = 'Customer Disc. Group';
            TableRelation = "Customer Discount Group";
        }
        field(7004; "Price description"; Text[80])
        {
            Caption = 'Price description';
        }
        field(1017160; "Center of Distribution"; Boolean)
        {
            Caption = 'Center of Distribution';
            Description = 'IT_3411';
        }
        field(1017161; "Do not print line"; Boolean)
        {
            Caption = 'Do not print line';
            Description = 'IT_1731';
        }
        field(1017162; "Do not print price"; Boolean)
        {
            Caption = 'Do not print price';
            Description = 'IT_1731';
        }
        field(1017163; "Do not print quantity"; Boolean)
        {
            Caption = 'Do not print quantity';
            Description = 'IT_1731';
        }
        field(1017164; "Read Only"; Boolean)
        {
            Caption = 'Read Only';
            Description = 'IT_2469';
        }
        field(1017165; "Combined Item Header"; Boolean)
        {
            Caption = 'Combined Item Header';
            Description = 'IT_1731';
        }
        field(1017166; "BOM Explosion Type"; Integer)
        {
            Caption = 'BOM Explosion Type';
            Description = 'IT_2469';
        }
        field(1017167; "Dimension Source"; Integer)
        {
            Caption = 'Dimension Source';
            Description = 'IT_2469';
        }
        field(1017168; "Service Package Header"; Boolean)
        {
            Caption = 'Service Package Header';
            Description = 'IT_1725';
        }
        field(1017169; "Qty. per Header"; Decimal)
        {
            Caption = 'Qty. per Header';
            Description = 'IT_1731';
        }
        field(1017171; "Call Center"; Boolean)
        {
            Caption = 'Call Center';
            Description = 'IT_2933';
        }
        field(1017172; "Manual BOM"; Boolean)
        {
            Caption = 'Manual BOM';
            Description = 'IT_3411';
        }
        field(1017175; "Allow Payment Discount"; Boolean)
        {
            Caption = 'Allow Payment Discount';
            Description = 'IT_3053';
        }
        field(1017176; "Pmt. Discount Base"; Decimal)
        {
            Caption = 'Pmt. Discount Base';
            Description = 'IT_3053';
            Editable = false;
        }
        field(1017177; "Pmt. Discount Base incl. VAT"; Decimal)
        {
            Caption = 'Pmt. Discount Base incl. VAT';
            Description = 'IT_3053';
            Editable = false;
        }
        field(1017178; "Manual Not Print Line"; Boolean)
        {
            Caption = 'Manual Not Print Line';
            Description = 'IT_3759';
        }
        field(1017179; "Manual Not Print Price"; Boolean)
        {
            Caption = 'Manual Not Print Price';
            Description = 'IT_3759';
        }
        field(1017180; "Manual Not Print Quantity"; Boolean)
        {
            Caption = 'Manual Not Print Quantity';
            Description = 'IT_3759';
        }
        field(1017181; "Group Number"; Integer)
        {
            Caption = 'Group Number';
            Description = 'IT_21397';
            Editable = false;
            TableRelation = "Sales Invoice Line"."Line No." WHERE("Document No." = FIELD("Document No."));
        }
        field(1017250; "Fastfit Discount"; Boolean)
        {
            Caption = 'Fastfit Discount';
            Description = 'IT_3411';
        }
        field(1017252; "Fixed Price"; Boolean)
        {
            Caption = 'Fixed Price';
            Description = 'IT_3411';
        }
        field(1017253; "Representative Code"; Code[20])
        {
            Caption = 'Representative Code';
            TableRelation = "Salesperson/Purchaser";
        }
        field(1017254; "CB-Price"; Decimal)
        {
            Caption = 'CB-Price';
        }
        field(1017255; Consignment; Boolean)
        {
            Caption = 'Consignment';
            Description = 'IT_3411';
        }
        field(1017256; "Amount (Std.)"; Decimal)
        {
            Caption = 'Amount (Std.)';
        }
        field(1017257; "Price Change From User"; Code[50])
        {
            Caption = 'Price Change From User';
            TableRelation = User;
        }
        field(1017258; "Price Change Date"; Date)
        {
            Caption = 'Date of Price Change';
        }
        field(1017259; "Price Change Time"; Time)
        {
            Caption = 'Time of Price Change';
        }
        field(1017260; "Bonus Allowed"; Boolean)
        {
            Caption = 'Bonus Allowed';
            Description = 'IT_1362';
        }
        field(1017261; "Bonus %"; Decimal)
        {
            Caption = 'Bonus %';
            Description = 'IT_1362';
        }
        field(1017262; "Bonus Code"; Code[10])
        {
            Caption = 'Bonus Code';
            Description = 'IT_1362';
            TableRelation = Bonus;
        }
        field(1017263; "Bonusable Amount"; Decimal)
        {
            Caption = 'Bonusable Amount';
            Description = 'IT_1362';
        }
        field(1017264; "Bonusable Amount (CB)"; Decimal)
        {
            Caption = 'Bonusable Amount (CB)';
            Description = 'IT_1362';
        }
        field(1017265; "Bonus Amount (Expected)"; Decimal)
        {
            Caption = 'Bonus Amount (Expected)';
            Description = 'IT_1362';
        }
        field(1017266; "Null Position"; Option)
        {
            Caption = 'Null Position';
            Description = 'IT_3411';
            InitValue = No;
            OptionCaption = ' ,No,Selection,Free,Warranty,Goodwill,Rebate in Kind,Return,Sample';
            OptionMembers = " ",No,Selection,Free,Warranty,Goodwill,"Rebate in Kind",Return,Sample;
        }
        field(1017267; "Price Locked"; Boolean)
        {
            Caption = 'Price Locked';
            Description = 'IT_3411';
        }
        field(1017269; "Net Price"; Decimal)
        {
            CaptionClass = GetCaptionClass(FieldNo("Net Price"));
            Caption = 'Net Price';
            Description = 'IT_2382';
        }
        field(1017270; "Discount 1 %"; Decimal)
        {
            Caption = 'Discount 1 %';
            Description = 'IT_2382';
        }
        field(1017271; "Text Discount 1"; Text[15])
        {
            Caption = 'Text Discount 1';
            Description = 'IT_2382';
        }
        field(1017272; "Discount 2 %"; Decimal)
        {
            Caption = 'Discount 2 %';
            Description = 'IT_2382';
        }
        field(1017273; "Text Discount 2"; Text[15])
        {
            Caption = 'Text Discount 2';
            Description = 'IT_2382';
        }
        field(1017274; "Discount 3 %"; Decimal)
        {
            Caption = 'Discount 3 %';
            Description = 'IT_2382';
        }
        field(1017275; "Text Discount 3"; Text[15])
        {
            Caption = 'Text Discount 3';
            Description = 'IT_2382';
        }
        field(1017276; "Discount 4 (LCY)"; Decimal)
        {
            Caption = 'Discount 4 (LCY)';
            Description = 'IT_2382';
        }
        field(1017277; "Text Discount 4"; Text[15])
        {
            Caption = 'Text Discount 4';
            Description = 'IT_2382';
        }
        field(1017278; "Discount 5 %"; Decimal)
        {
            Caption = 'Discount 5 %';
            Description = 'IT_2382';
        }
        field(1017279; "Text Discount 5"; Text[15])
        {
            Caption = 'Text Discount 5';
            Description = 'IT_2382';
        }
        field(1017280; "BAH Option"; Option)
        {
            Caption = 'BAHOption';
            OptionCaption = ' ,Pos. Adjmt BAH,Neg. Adjmt. BAH';
            OptionMembers = " ","Pos. Adjmt BAH","Neg. Adjmt. BAH";
        }
        field(1017281; "Text Item No."; Code[20])
        {
            Caption = 'Text Item No.';
            Editable = false;
        }
        field(1017282; "Text Quantity"; Decimal)
        {
            Caption = 'Text Quantity';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(1017283; "Text Unit Price"; Decimal)
        {
            AutoFormatExpression = GetCurrencyCode;
            AutoFormatType = 2;
            Caption = 'Text Unit Price';
            Editable = false;
        }
        field(1017284; "Text Amount"; Decimal)
        {
            AutoFormatExpression = GetCurrencyCode;
            AutoFormatType = 1;
            Caption = 'Text Amount';
            Editable = false;
        }
        field(1017285; "Text CB-Price"; Decimal)
        {
            AutoFormatExpression = GetCurrencyCode;
            AutoFormatType = 2;
            Caption = 'Text CB-Price';
            Editable = false;
        }
        field(1017286; "Text Line Discount %"; Decimal)
        {
            Caption = 'Text Line Discount %';
            DecimalPlaces = 0 : 5;
            Editable = false;
            MaxValue = 100;
            MinValue = 0;
        }
        field(1017287; "Qty. Transferred From BAH"; Decimal)
        {
            Caption = 'Qty. Transferred From BAH';
        }
        field(1017288; "Remaining Qty on BAH"; Decimal)
        {
            Caption = 'Remaining Qty on BAH';
            Description = 'IT_3411';
        }
        field(1017289; "Minimum Price"; Decimal)
        {
            Caption = 'Minimum Price';
            Description = 'IT_3411';
        }
        field(1017290; "Discount 1 Code"; Code[20])
        {
            Caption = 'Discount 1 Code';
            Description = 'IT_3518';
            TableRelation = "Fastfit Discount Cust./-group";
        }
        field(1017291; "Discount 2 Code"; Code[20])
        {
            Caption = 'Discount 2 Code';
            Description = 'IT_3518';
            TableRelation = "Fastfit Discount Cust./-group";
        }
        field(1017292; "Discount 3 Code"; Code[20])
        {
            Caption = 'Discount 3 Code';
            Description = 'IT_3518';
            TableRelation = "Fastfit Discount Cust./-group";
        }
        field(1017293; "Discount 4 Code"; Code[20])
        {
            Caption = 'Discount 4 Code';
            Description = 'IT_3518';
            TableRelation = "Fastfit Discount Cust./-group";
        }
        field(1017294; "Discount 5 Code"; Code[20])
        {
            Caption = 'Discount 5 Code';
            Description = 'IT_3518';
            TableRelation = "Fastfit Discount Cust./-group";
        }
        field(1017295; "Sell-to Contact No."; Code[20])
        {
            Caption = 'Sell-to Contact No.';
            Description = 'IT_4044';
            TableRelation = Contact;
            ValidateTableRelation = false;

            trigger OnLookup()
            var
                Cont: Record Contact;
                ContBusinessRelation: Record "Contact Business Relation";
            begin
            end;

            trigger OnValidate()
            var
                ContBusinessRelation: Record "Contact Business Relation";
                Cont: Record Contact;
                Opportunity: Record Opportunity;
            begin
            end;
        }
        field(1017296; "Bill-to Contact No."; Code[20])
        {
            Caption = 'Bill-to Contact No.';
            Description = 'IT_4044';
            TableRelation = Contact;

            trigger OnLookup()
            var
                Cont: Record Contact;
                ContBusinessRelation: Record "Contact Business Relation";
            begin
            end;

            trigger OnValidate()
            var
                ContBusinessRelation: Record "Contact Business Relation";
                Cont: Record Contact;
            begin
            end;
        }
        field(1017297; "Manufacturer Item No."; Code[30])
        {
            CalcFormula = Lookup(Item."Manufacturer Item No." WHERE("No." = FIELD("No.")));
            Caption = 'Manufacturer Item No.';
            Description = 'IT_20415';
            Editable = false;
            FieldClass = FlowField;
        }
        field(1017302; "SC Codes Lines"; Boolean)
        {
            CalcFormula = Exist("SC Codes Line" WHERE("Document No." = FIELD("Document No."),
                                                       "SC Code" = FIELD("SC Codes Lines Filter")));
            Caption = 'SC Codes Lines';
            Description = 'IT_5036,IT_8829';
            FieldClass = FlowField;
        }
        field(1017303; "SC Codes Lines Filter"; Code[250])
        {
            Caption = 'SC Codes Lines Filter';
            Description = 'IT_8829';
            FieldClass = FlowFilter;
        }
        field(1017304; "Location Name"; Text[100])
        {
            Caption = 'Location Name';
            DataClassification = ToBeClassified;
            Description = 'TFS_14782';
            TableRelation = Location.Name;
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(1017361; "Central Maintenance"; Boolean)
        {
            Caption = 'Central Maintenance';
            Description = 'IT_20506';
        }
        field(1017368; "Price UOM"; Code[10])
        {
            Caption = 'Price UOM';
            Description = 'BSS: GENERAL (IT_4846)';
            TableRelation = "Unit of Measure";
        }
        field(1017369; "Unit Price per Price UOM"; Decimal)
        {
            Caption = 'Unit Price per Price UOM';
            Description = 'BSS: GENERAL (IT_4846)';
            Editable = false;
        }
        field(1017370; "Net Price per Price UOM"; Decimal)
        {
            Caption = 'Net Price per Price UOM';
            Description = 'BSS: GENERAL (IT_4846)';
            Editable = false;
        }
        field(1017416; "Has Additional Items"; Boolean)
        {
            Caption = 'Has Additional Items';
            Description = 'IT_3850';
        }
        field(1017417; "Additional Item Type"; Option)
        {
            Caption = 'Additional Item Type';
            Description = 'IT_3850';
            OptionCaption = ' ,Surcharge,Bond,Exchange Part,Additional Item';
            OptionMembers = " ",Surcharge,Bond,"Exchange Part","Additional Item";
        }
        field(1017418; "Appl.-to Exch. Part Entry No."; Integer)
        {
            Caption = 'Appl.-to Exch. Part Entry No.';
            Description = 'IT_3850';
        }
        field(1017460; "Tire Hotel No."; Code[20])
        {
            Caption = 'Tire Hotel No.';
            Description = 'IT_3612';
            TableRelation = "Tire Hotel";
        }
        field(1017540; "Vehicle No."; Code[20])
        {
            Caption = 'Vehicle No.';
            Description = 'IT_4044';
            TableRelation = Vehicle;
        }
        field(1017541; "Licence-Plate No. Short"; Code[20])
        {
            Caption = 'Licence-Plate No.';
            Description = 'IT_4044,IT_7115';
        }
        field(1017730; "Retread Order No."; Code[20])
        {
            Caption = 'Retread Order No.';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(1017731; "Retread Line No."; Integer)
        {
            Caption = 'Retread Line No.';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(1018330; "Noise Performance"; Code[3])
        {
            Caption = 'external rolling noise measured value (DB)';
            Description = 'IT_6981 Labelling';
        }
        field(1018331; "Noise Class Type"; Code[1])
        {
            Caption = 'external rolling noise class';
            Description = 'IT_6981';
        }
        field(1018332; "Fuel Efficiency"; Code[1])
        {
            Caption = 'fuel efficiency';
            Description = 'IT_6981';
        }
        field(1018333; "Service Center"; Code[10])
        {
            Caption = 'Service Center';
            TableRelation = "Service Center".Code;
        }
        field(1018334; "EC/Vehicle Class"; Code[2])
        {
            Caption = 'EC/Vehicle Class';
            Description = 'IT_6981';
        }
        field(1018337; "EU Directive Number"; Text[20])
        {
            Caption = 'EU Directive Number';
            Description = 'IT_6981';
        }
        field(1018338; "Wet Grip"; Code[1])
        {
            Caption = 'wet grip';
            Description = 'IT_6981';
        }

        field(1018362; "Salesperson Code"; Code[20])
        {
            Caption = 'Salesperson Code';
            Description = 'IT_2251';
            TableRelation = "Salesperson/Purchaser";
        }
        field(1018363; "Salesperson Code 2"; Code[20])
        {
            Caption = 'Salesperson Code 2';
            Description = 'IT_2251';
            TableRelation = "Salesperson/Purchaser";
        }
        field(1018364; "Fitter 1"; Code[20])
        {
            Caption = 'Mechanic 1';
            Description = 'IT_2251';
            TableRelation = "Salesperson/Purchaser";
        }
        field(1018365; "Fitter 2"; Code[20])
        {
            Caption = 'Mechanic 2';
            Description = 'IT_2251';
            TableRelation = "Salesperson/Purchaser";
        }
        field(1018366; "Fitter 3"; Code[20])
        {
            Caption = 'Mechanic 3';
            Description = 'IT_2251';
            TableRelation = "Salesperson/Purchaser";
        }
        field(1018367; "Commission Posted"; Boolean)
        {
            Caption = 'Commission Posted';
            Description = 'IT_2251';
        }
        field(1018604; "Deleteable Additional Item"; Boolean)
        {
            Caption = 'Deleteable Additional Item';
            Description = 'IT_20959';
        }
        field(1018605; "Add. Items - Att. To Line"; Integer)
        {
            Caption = 'Add. Item - Attached to Line No.';
            Description = 'IT_20959';
        }
        field(1018650; "Main Vendor Item No."; Code[50])
        {
            CalcFormula = Lookup(Item."Vendor Item No." WHERE("No." = FIELD("No.")));
            Caption = 'Main Vendor Item No.';
            Description = 'IT_20415';
            Editable = false;
            FieldClass = FlowField;
        }
        field(1018651; "Barcode Type EAN"; Code[10])
        {
            Caption = 'Barcode Type For EAN';
            Description = 'IT_20415';
            Editable = false;
            FieldClass = FlowFilter;
            TableRelation = "Barcode Type";
        }
        field(1018652; "Item EAN No."; Code[30])
        {
            CalcFormula = Lookup("Item Cross Reference"."Cross-Reference No." WHERE("Item No." = FIELD("No."),
                                                                                     "Cross-Reference Type No." = FIELD("Barcode Type EAN"),
                                                                                     "Cross-Reference Type" = CONST("Bar Code")));
            Caption = 'Item EAN No.';
            Description = 'IT_20415';
            Editable = false;
            FieldClass = FlowField;
        }
        // field(1028010; "DatEuropa code"; Text[30])
        // {
        //     Caption = 'DatEuropa code';
        //     Description = 'IT_21654';
        //     ObsoleteState = Removed;
        //     ObsoleteReason = 'Removed as no used in Order Screen process';
        // }
        // field(1028011; "Engine Codes"; Text[30])
        // {
        //     Caption = 'Engine Codes';
        //     Description = 'IT_21654';
        //     ObsoleteState = Removed;
        //     ObsoleteReason = 'Removed as no used in Order Screen process';
        // }
        // field(1028012; "EurotaxNat Code"; Text[30])
        // {
        //     Caption = 'EurotaxNat Code';
        //     Description = 'IT_21654';
        //     ObsoleteState = Removed;
        //     ObsoleteReason = 'Removed as no used in Order Screen process';
        // }
        // field(1028013; "Mileage(KM)"; Integer)
        // {
        //     Caption = 'Mileage(KM)';
        //     Description = 'IT_21654';
        //     ObsoleteState = Removed;
        //     ObsoleteReason = 'Removed as no used in Order Screen process';
        // }
        // field(1028014; "National Code"; Text[30])
        // {
        //     Caption = 'National Code';
        //     Description = 'IT_21654';
        //     ObsoleteState = Removed;
        //     ObsoleteReason = 'Removed as no used in Order Screen process';
        // }
        // field(1028015; "License No."; Text[30])
        // {
        //     Caption = 'License No.';
        //     Description = 'IT_21654';
        //     ObsoleteState = Removed;
        //     ObsoleteReason = 'Removed as no used in Order Screen process';
        // }
        // field(1028016; "TecDoc ID"; Text[30])
        // {
        //     Caption = 'TecDoc ID';
        //     Description = 'IT_21654';
        //     ObsoleteState = Removed;
        //     ObsoleteReason = 'Removed as no used in Order Screen process';
        // }
        // field(1028017; VIN; Text[30])
        // {
        //     Caption = 'VIN';
        //     Description = 'IT_21654';
        //     ObsoleteState = Removed;
        //     ObsoleteReason = 'Removed as no used in Order Screen process';
        // }
        field(1028021; "Interface Description"; Text[250])
        {
            Caption = 'Interface Description';
            Description = 'IT_21654';
        }
        field(1028110; "Promotion Condition No."; Code[10])
        {
            Caption = 'Promotion Condition No.';
            Description = 'IT_20882';
            TableRelation = "Promotion Condition Header";
        }
        field(1028111; "Promotion Bonus Line No."; Integer)
        {
            Caption = 'Promotion Bonus Line No.';
            Description = 'IT_20882';
        }
        field(1028183; "Discount Operation 2"; Option)
        {
            Caption = 'Discount Operation 2';
            Description = 'IT_6999';
            OptionCaption = '*,+';
            OptionMembers = "*","+";
        }
        field(1028184; "Discount Operation 3"; Option)
        {
            Caption = 'Discount Operation 3';
            Description = 'IT_6999';
            OptionCaption = '*,+';
            OptionMembers = "*","+";
        }
        field(1028185; "Discount Operation 5"; Option)
        {
            Caption = 'Discount Operation 5';
            Description = 'IT_6999';
            OptionCaption = '*,+';
            OptionMembers = "*","+";
        }
        field(1028250; "Internal Comment"; Boolean)
        {
            Caption = 'Internal Comment';
            Description = 'IT_21435';

            trigger OnValidate()
            var
                CommentSalesLines: Record "Sales Line";
            begin
            end;
        }
        field(1028275; "Deleted By HQ"; Boolean)
        {
            Caption = 'Deleted by HQ';
            Description = 'IT_20506';
        }
        // field(1028276; "Replication Date"; DateTime)
        // {
        //     Caption = 'Replication Date';
        //     ObsoleteState = Removed;
        //     ObsoleteReason = 'Replaced by another feature (Data Distribution)';
        //     Description = 'IT_20506';
        //     Editable = false;
        // }
        // field(1028277; "Repl. Post Run Finished"; Boolean)
        // {
        //     Caption = 'Repl. Post Run Finished';
        //     ObsoleteState = Removed;
        //     ObsoleteReason = 'Replaced by another feature (Data Distribution)';
        //     Description = 'IT_20506';
        // }
        // field(1028278; "Replication Filter"; Code[2])
        // {
        //     Caption = 'Replication Filter';
        //     ObsoleteState = Removed;
        //     ObsoleteReason = 'Replaced by another feature (Data Distribution)';
        //     Description = 'IT_20506';
        // }
        field(1044380; "Additional Sale"; Boolean)
        {
            Caption = 'Additional Sale';
            Description = 'IT_20396';
            Editable = false;
        }
        field(1044390; "Sell-to Customer Name"; Text[100])
        {
            CalcFormula = Lookup("Sales Invoice Header Buffer"."Sell-to Customer Name" WHERE("Service Center Key" = field("Service Center Key"), "No." = FIELD("Document No.")));
            Caption = 'Sell-to Customer Name';
            Description = 'IT_20761';
            Editable = false;
            FieldClass = FlowField;
        }
        field(1044391; "Sell-to Customer Name 2"; Text[50])
        {
            CalcFormula = Lookup("Sales Invoice Header Buffer"."Sell-to Customer Name 2" WHERE("Service Center Key" = field("Service Center Key"), "No." = FIELD("Document No.")));
            Caption = 'Sell-to Customer Name 2';
            Description = 'IT_20761';
            Editable = false;
            FieldClass = FlowField;
        }
        field(1044392; "Sell-to Contact"; Text[100])
        {
            CalcFormula = Lookup("Sales Invoice Header Buffer"."Sell-to Contact" WHERE("Service Center Key" = field("Service Center Key"), "No." = FIELD("Document No.")));
            Caption = 'Sell-to Contact';
            Description = 'IT_20761';
            Editable = false;
            FieldClass = FlowField;
        }
        // field(1059110; "Prevent Synchronization"; Boolean)
        // {
        //     Caption = 'Prevent Synchronization';
        //     ObsoleteState = Removed;
        //     ObsoleteReason = 'Replaced by another feature (Data Distribution)';
        //     Description = 'IT_20506';
        // }
        // field(1059111; "Prevent Replication"; Boolean)
        // {
        //     Caption = 'Prevent Replication';
        //     ObsoleteState = Removed;
        //     ObsoleteReason = 'Replaced by another feature (Data Distribution)';
        //     Description = 'IT_20506';
        // }
        field(1044880; "Service Center Key"; Code[10])
        {
        }
    }

    keys
    {
        key(Key1; "Service Center Key", "Document No.", "Line No.")
        {
            Clustered = true;
        }
        key(Key2; "Blanket Order No.", "Blanket Order Line No.")
        {
        }
        key(Key3; "Sell-to Customer No.")
        {
        }
        key(Key4; "Sell-to Customer No.", Type, "Document No.")
        {
            Enabled = false;
            MaintainSQLIndex = false;
        }
        key(Key5; "Shipment No.", "Shipment Line No.")
        {
        }
        key(Key6; "Job Contract Entry No.")
        {
        }
        key(Key7; "Bill-to Customer No.")
        {
        }
        key(Key8; "Order No.", "Order Line No.", "Posting Date")
        {
        }
        key(Key9; "Document No.", "Location Code")
        {
            MaintainSQLIndex = false;
            SumIndexFields = Amount, "Amount Including VAT", "Pmt. Discount Base incl. VAT";
        }
        key(Key10; "Salesperson Code")
        {
        }
        key(Key11; Type, "No.", "Sell-to Customer No.")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(Brick; "No.", Description, "Line Amount", "Price description", Quantity, "Unit of Measure Code")
        {
        }
    }
    procedure GetCaptionClass(FieldNumber: Integer): Text[80]
    begin
    end;

    procedure GetCurrencyCode(): Code[10]
    begin
    end;
}
