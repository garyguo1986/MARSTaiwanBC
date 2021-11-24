table 1044869 "Sales Invoice Header Buffer"
{
    Caption = 'Sales Invoice Header Buffer';
    fields
    {
        field(2; "Sell-to Customer No."; Code[20])
        {
            Caption = 'Sell-to Customer No.';
            TableRelation = Customer;
        }
        field(3; "No."; Code[20])
        {
            Caption = 'No.';
        }
        field(4; "Bill-to Customer No."; Code[20])
        {
            Caption = 'Bill-to Customer No.';
            TableRelation = Customer;
        }
        field(5; "Bill-to Name"; Text[100])
        {
            Caption = 'Bill-to Name';
        }
        field(6; "Bill-to Name 2"; Text[50])
        {
            Caption = 'Bill-to Name 2';
        }
        field(7; "Bill-to Address"; Text[100])
        {
            Caption = 'Bill-to Address';
        }
        field(8; "Bill-to Address 2"; Text[50])
        {
            Caption = 'Bill-to Address 2';
        }
        field(9; "Bill-to City"; Text[30])
        {
            Caption = 'Bill-to City';
            TableRelation = "Post Code".City;
            ValidateTableRelation = false;
        }
        field(10; "Bill-to Contact"; Text[100])
        {
            Caption = 'Bill-to Contact';
        }
        field(11; "Your Reference"; Text[35])
        {
            Caption = 'Your Reference';
        }
        field(12; "Ship-to Code"; Code[10])
        {
            Caption = 'Ship-to Code';
            TableRelation = "Ship-to Address".Code WHERE("Customer No." = FIELD("Sell-to Customer No."));
        }
        field(13; "Ship-to Name"; Text[100])
        {
            Caption = 'Ship-to Name';
        }
        field(14; "Ship-to Name 2"; Text[50])
        {
            Caption = 'Ship-to Name 2';
        }
        field(15; "Ship-to Address"; Text[100])
        {
            Caption = 'Ship-to Address';
        }
        field(16; "Ship-to Address 2"; Text[50])
        {
            Caption = 'Ship-to Address 2';
        }
        field(17; "Ship-to City"; Text[30])
        {
            Caption = 'Ship-to City';
            TableRelation = "Post Code".City;
            ValidateTableRelation = false;
        }
        field(18; "Ship-to Contact"; Text[100])
        {
            Caption = 'Ship-to Contact';
        }
        field(19; "Order Date"; Date)
        {
            Caption = 'Order Date';
        }
        field(20; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }
        field(21; "Shipment Date"; Date)
        {
            Caption = 'Shipment Date';
        }
        field(22; "Posting Description"; Text[100])
        {
            Caption = 'Posting Description';
        }
        field(23; "Payment Terms Code"; Code[10])
        {
            Caption = 'Payment Terms Code';
            TableRelation = "Payment Terms";
        }
        field(24; "Due Date"; Date)
        {
            Caption = 'Due Date';
        }
        field(25; "Payment Discount %"; Decimal)
        {
            Caption = 'Payment Discount %';
            DecimalPlaces = 0 : 5;
            MaxValue = 100;
            MinValue = 0;
        }
        field(26; "Pmt. Discount Date"; Date)
        {
            Caption = 'Pmt. Discount Date';
        }
        field(27; "Shipment Method Code"; Code[10])
        {
            Caption = 'Shipment Method Code';
            TableRelation = "Shipment Method";
        }
        field(28; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            TableRelation = Location WHERE("Use As In-Transit" = CONST(false));
        }
        field(29; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(30; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(31; "Customer Posting Group"; Code[20])
        {
            Caption = 'Customer Posting Group';
            Editable = false;
            TableRelation = "Customer Posting Group";
        }
        field(32; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            Editable = false;
            TableRelation = Currency;
        }
        field(33; "Currency Factor"; Decimal)
        {
            Caption = 'Currency Factor';
            DecimalPlaces = 0 : 15;
            MinValue = 0;
        }
        field(34; "Customer Price Group"; Code[20])
        {
            Caption = 'Customer Price Group';
            Description = 'IT_20876';
            TableRelation = "Customer Price Group";
        }
        field(35; "Prices Including VAT"; Boolean)
        {
            Caption = 'Prices Including VAT';
        }
        field(37; "Invoice Disc. Code"; Code[20])
        {
            Caption = 'Invoice Disc. Code';
        }
        field(40; "Customer Disc. Group"; Code[20])
        {
            Caption = 'Customer Disc. Group';
            TableRelation = "Customer Discount Group";
        }
        field(41; "Language Code"; Code[10])
        {
            Caption = 'Language Code';
            TableRelation = Language;
        }
        field(43; "Salesperson Code"; Code[20])
        {
            Caption = 'Salesperson Code';
            TableRelation = "Salesperson/Purchaser";
        }
        field(44; "Order No."; Code[20])
        {
            AccessByPermission = TableData "Sales Shipment Header" = R;
            Caption = 'Order No.';
        }
        field(46; Comment; Boolean)
        {
            CalcFormula = Exist("Sales Comment Line" WHERE("Document Type" = CONST("Posted Invoice"),
                                                            "No." = FIELD("No."),
                                                            "Document Line No." = CONST(0)));
            Caption = 'Comment';
            Editable = false;
            FieldClass = FlowField;
        }
        field(47; "No. Printed"; Integer)
        {
            Caption = 'No. Printed';
            Editable = false;
        }
        field(51; "On Hold"; Code[3])
        {
            Caption = 'On Hold';
        }
        field(52; "Applies-to Doc. Type"; Option)
        {
            Caption = 'Applies-to Doc. Type';
            OptionCaption = ' ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund';
            OptionMembers = " ",Payment,Invoice,"Credit Memo","Finance Charge Memo",Reminder,Refund;
        }
        field(53; "Applies-to Doc. No."; Code[20])
        {
            Caption = 'Applies-to Doc. No.';

            trigger OnLookup()
            var
                CustLedgEntry: Record "Cust. Ledger Entry";
            begin
            end;
        }
        field(55; "Bal. Account No."; Code[20])
        {
            Caption = 'Bal. Account No.';
            TableRelation = IF ("Bal. Account Type" = CONST("G/L Account")) "G/L Account"
            ELSE
            IF ("Bal. Account Type" = CONST("Bank Account")) "Bank Account";
        }
        field(60; Amount; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CalcFormula = Sum("Sales Invoice Line Buffer".Amount WHERE("Service Center Key" = field("Service Center Key"), "Document No." = FIELD("No.")));
            Caption = 'Amount';
            Editable = false;
            FieldClass = FlowField;
        }
        field(61; "Amount Including VAT"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CalcFormula = Sum("Sales Invoice Line Buffer"."Amount Including VAT" WHERE("Service Center Key" = field("Service Center Key"), "Document No." = FIELD("No.")));
            Caption = 'Amount Including VAT';
            Editable = false;
            FieldClass = FlowField;
        }
        field(70; "VAT Registration No."; Text[20])
        {
            Caption = 'VAT Registration No.';
        }
        field(73; "Reason Code"; Code[10])
        {
            Caption = 'Reason Code';
            TableRelation = "Reason Code";
        }
        field(74; "Gen. Bus. Posting Group"; Code[20])
        {
            Caption = 'Gen. Bus. Posting Group';
            TableRelation = "Gen. Business Posting Group";
        }
        field(75; "EU 3-Party Trade"; Boolean)
        {
            Caption = 'EU 3-Party Trade';
        }
        field(76; "Transaction Type"; Code[10])
        {
            Caption = 'Transaction Type';
            TableRelation = "Transaction Type";
        }
        field(77; "Transport Method"; Code[10])
        {
            Caption = 'Transport Method';
            TableRelation = "Transport Method";
        }
        field(78; "VAT Country/Region Code"; Code[10])
        {
            Caption = 'VAT Country/Region Code';
            TableRelation = "Country/Region";
        }
        field(79; "Sell-to Customer Name"; Text[100])
        {
            Caption = 'Sell-to Customer Name';
        }
        field(80; "Sell-to Customer Name 2"; Text[50])
        {
            Caption = 'Sell-to Customer Name 2';
        }
        field(81; "Sell-to Address"; Text[100])
        {
            Caption = 'Sell-to Address';
        }
        field(82; "Sell-to Address 2"; Text[50])
        {
            Caption = 'Sell-to Address 2';
        }
        field(83; "Sell-to City"; Text[30])
        {
            Caption = 'Sell-to City';
            TableRelation = "Post Code".City;
            ValidateTableRelation = false;
        }
        field(84; "Sell-to Contact"; Text[100])
        {
            Caption = 'Sell-to Contact';
        }
        field(85; "Bill-to Post Code"; Code[20])
        {
            Caption = 'Bill-to Post Code';
            TableRelation = "Post Code";
            ValidateTableRelation = false;
        }
        field(86; "Bill-to County"; Text[30])
        {
            CaptionClass = '5,1,' + "Bill-to Country/Region Code";
            Caption = 'Bill-to County';
        }
        field(87; "Bill-to Country/Region Code"; Code[10])
        {
            Caption = 'Bill-to Country/Region Code';
            TableRelation = "Country/Region";
        }
        field(88; "Sell-to Post Code"; Code[20])
        {
            Caption = 'Sell-to Post Code';
            TableRelation = "Post Code";
            ValidateTableRelation = false;
        }
        field(89; "Sell-to County"; Text[30])
        {
            CaptionClass = '5,1,' + "Sell-to Country/Region Code";
            Caption = 'Sell-to County';
        }
        field(90; "Sell-to Country/Region Code"; Code[10])
        {
            Caption = 'Sell-to Country/Region Code';
            TableRelation = "Country/Region";
        }
        field(91; "Ship-to Post Code"; Code[20])
        {
            Caption = 'Ship-to Post Code';
            TableRelation = "Post Code";
            ValidateTableRelation = false;
        }
        field(92; "Ship-to County"; Text[30])
        {
            CaptionClass = '5,1,' + "Ship-to Country/Region Code";
            Caption = 'Ship-to County';
        }
        field(93; "Ship-to Country/Region Code"; Code[10])
        {
            Caption = 'Ship-to Country/Region Code';
            TableRelation = "Country/Region";
        }
        field(94; "Bal. Account Type"; Option)
        {
            Caption = 'Bal. Account Type';
            OptionCaption = 'G/L Account,Bank Account';
            OptionMembers = "G/L Account","Bank Account";
        }
        field(97; "Exit Point"; Code[10])
        {
            Caption = 'Exit Point';
            TableRelation = "Entry/Exit Point";
        }
        field(98; Correction; Boolean)
        {
            Caption = 'Correction';
        }
        field(99; "Document Date"; Date)
        {
            Caption = 'Document Date';
        }
        field(100; "External Document No."; Code[35])
        {
            Caption = 'External Document No.';
        }
        field(101; "Area"; Code[10])
        {
            Caption = 'Area';
            TableRelation = Area;
        }
        field(102; "Transaction Specification"; Code[10])
        {
            Caption = 'Transaction Specification';
            TableRelation = "Transaction Specification";
        }
        field(104; "Payment Method Code"; Code[10])
        {
            Caption = 'Payment Method Code';
            TableRelation = "Payment Method";
        }
        field(105; "Shipping Agent Code"; Code[10])
        {
            AccessByPermission = TableData "Shipping Agent Services" = R;
            Caption = 'Shipping Agent Code';
            TableRelation = "Shipping Agent";
        }
        field(106; "Package Tracking No."; Text[30])
        {
            Caption = 'Package Tracking No.';
        }
        field(107; "Pre-Assigned No. Series"; Code[20])
        {
            Caption = 'Pre-Assigned No. Series';
            TableRelation = "No. Series";
        }
        field(108; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(110; "Order No. Series"; Code[20])
        {
            Caption = 'Order No. Series';
            TableRelation = "No. Series";
        }
        field(111; "Pre-Assigned No."; Code[20])
        {
            Caption = 'Pre-Assigned No.';
        }
        field(112; "User ID"; Code[50])
        {
            Caption = 'User ID';
            DataClassification = EndUserIdentifiableInformation;
            TableRelation = User."User Name";
        }
        field(113; "Source Code"; Code[10])
        {
            Caption = 'Source Code';
            TableRelation = "Source Code";
        }
        field(114; "Tax Area Code"; Code[20])
        {
            Caption = 'Tax Area Code';
            TableRelation = "Tax Area";
        }
        field(115; "Tax Liable"; Boolean)
        {
            Caption = 'Tax Liable';
        }
        field(116; "VAT Bus. Posting Group"; Code[20])
        {
            Caption = 'VAT Bus. Posting Group';
            TableRelation = "VAT Business Posting Group";
        }
        field(119; "VAT Base Discount %"; Decimal)
        {
            Caption = 'VAT Base Discount %';
            DecimalPlaces = 0 : 5;
            MaxValue = 100;
            MinValue = 0;
        }
        field(121; "Invoice Discount Calculation"; Option)
        {
            Caption = 'Invoice Discount Calculation';
            OptionCaption = 'None,%,Amount';
            OptionMembers = "None","%",Amount;
        }
        field(122; "Invoice Discount Value"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Invoice Discount Value';
        }
        field(131; "Prepayment No. Series"; Code[20])
        {
            Caption = 'Prepayment No. Series';
            TableRelation = "No. Series";
        }
        field(136; "Prepayment Invoice"; Boolean)
        {
            Caption = 'Prepayment Invoice';
        }
        field(137; "Prepayment Order No."; Code[20])
        {
            Caption = 'Prepayment Order No.';
        }
        field(151; "Quote No."; Code[20])
        {
            Caption = 'Quote No.';
            Editable = false;
        }
        field(166; "Last Email Sent Time"; DateTime)
        {
            CalcFormula = Max("O365 Document Sent History"."Created Date-Time" WHERE("Document Type" = CONST(Invoice),
                                                                                      "Document No." = FIELD("No."),
                                                                                      Posted = CONST(true)));
            Caption = 'Last Email Sent Time';
            FieldClass = FlowField;
        }
        field(167; "Last Email Sent Status"; Option)
        {
            CalcFormula = Lookup("O365 Document Sent History"."Job Last Status" WHERE("Document Type" = CONST(Invoice),
                                                                                       "Document No." = FIELD("No."),
                                                                                       Posted = CONST(true),
                                                                                       "Created Date-Time" = FIELD("Last Email Sent Time")));
            Caption = 'Last Email Sent Status';
            FieldClass = FlowField;
            OptionCaption = 'Not Sent,In Process,Finished,Error';
            OptionMembers = "Not Sent","In Process",Finished,Error;
        }
        field(168; "Sent as Email"; Boolean)
        {
            CalcFormula = Exist("O365 Document Sent History" WHERE("Document Type" = CONST(Invoice),
                                                                    "Document No." = FIELD("No."),
                                                                    Posted = CONST(true),
                                                                    "Job Last Status" = CONST(Finished)));
            Caption = 'Sent as Email';
            FieldClass = FlowField;
        }
        field(169; "Last Email Notif Cleared"; Boolean)
        {
            CalcFormula = Lookup("O365 Document Sent History".NotificationCleared WHERE("Document Type" = CONST(Invoice),
                                                                                         "Document No." = FIELD("No."),
                                                                                         Posted = CONST(true),
                                                                                         "Created Date-Time" = FIELD("Last Email Sent Time")));
            Caption = 'Last Email Notif Cleared';
            FieldClass = FlowField;
        }
        field(171; "Sell-to Phone No."; Text[30])
        {
            Caption = 'Sell-to Phone No.';
            ExtendedDatatype = PhoneNo;
        }
        field(172; "Sell-to E-Mail"; Text[80])
        {
            Caption = 'Email';
            ExtendedDatatype = EMail;
        }
        field(176; "Payment Instructions"; BLOB)
        {
            Caption = 'Payment Instructions';
        }
        field(177; "Payment Instructions Name"; Text[20])
        {
            Caption = 'Payment Instructions Name';
            DataClassification = CustomerContent;
        }
        field(180; "Payment Reference"; Code[50])
        {
            Caption = 'Payment Reference';
        }
        field(200; "Work Description"; BLOB)
        {
            Caption = 'Work Description';
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
        field(600; "Payment Service Set ID"; Integer)
        {
            Caption = 'Payment Service Set ID';
        }
        field(710; "Document Exchange Identifier"; Text[50])
        {
            Caption = 'Document Exchange Identifier';
        }
        field(711; "Document Exchange Status"; Option)
        {
            Caption = 'Document Exchange Status';
            OptionCaption = 'Not Sent,Sent to Document Exchange Service,Delivered to Recipient,Delivery Failed,Pending Connection to Recipient';
            OptionMembers = "Not Sent","Sent to Document Exchange Service","Delivered to Recipient","Delivery Failed","Pending Connection to Recipient";
        }
        field(712; "Doc. Exch. Original Identifier"; Text[50])
        {
            Caption = 'Doc. Exch. Original Identifier';
        }
        field(720; "Coupled to CRM"; Boolean)
        {
            Caption = 'Coupled to Dynamics 365 Sales';
        }
        field(1200; "Direct Debit Mandate ID"; Code[35])
        {
            Caption = 'Direct Debit Mandate ID';
            TableRelation = "SEPA Direct Debit Mandate" WHERE("Customer No." = FIELD("Bill-to Customer No."));
        }
        field(1302; Closed; Boolean)
        {
            CalcFormula = - Exist("Cust. Ledger Entry" WHERE("Entry No." = FIELD("Cust. Ledger Entry No."),
                                                             Open = FILTER(true)));
            Caption = 'Closed';
            Editable = false;
            FieldClass = FlowField;
        }
        field(1303; "Remaining Amount"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CalcFormula = Sum("Detailed Cust. Ledg. Entry".Amount WHERE("Cust. Ledger Entry No." = FIELD("Cust. Ledger Entry No.")));
            Caption = 'Remaining Amount';
            Editable = false;
            FieldClass = FlowField;
        }
        field(1304; "Cust. Ledger Entry No."; Integer)
        {
            Caption = 'Cust. Ledger Entry No.';
            Editable = false;
            TableRelation = "Cust. Ledger Entry"."Entry No.";
        }
        field(1305; "Invoice Discount Amount"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = Sum("Sales Invoice Line Buffer"."Inv. Discount Amount" WHERE("Service Center Key" = field("Service Center Key"), "Document No." = FIELD("No.")));
            Caption = 'Invoice Discount Amount';
            Editable = false;
            FieldClass = FlowField;
        }
        field(1310; Cancelled; Boolean)
        {
            CalcFormula = Exist("Cancelled Document Buffer" WHERE("Source ID" = CONST(112),
                                                            "Service Center Key" = field("Service Center Key"),
                                                            "Cancelled Doc. No." = FIELD("No.")));
            Caption = 'Cancelled';
            Editable = false;
            FieldClass = FlowField;
        }
        field(1311; Corrective; Boolean)
        {
            CalcFormula = Exist("Cancelled Document Buffer" WHERE("Source ID" = CONST(114),
                                                            "Service Center Key" = field("Service Center Key"),
                                                            "Cancelled By Doc. No." = FIELD("No.")));
            Caption = 'Corrective';
            Editable = false;
            FieldClass = FlowField;
        }
        field(1312; Reversed; Boolean)
        {
            Caption = 'Reversed';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Cust. Ledger Entry".Reversed where("Entry No." = field("Cust. Ledger Entry No.")));
        }
        field(5050; "Campaign No."; Code[20])
        {
            Caption = 'Campaign No.';
            TableRelation = Campaign;
        }
        field(5052; "Sell-to Contact No."; Code[20])
        {
            Caption = 'Sell-to Contact No.';
            TableRelation = Contact;
        }
        field(5053; "Bill-to Contact No."; Code[20])
        {
            Caption = 'Bill-to Contact No.';
            TableRelation = Contact;
        }
        field(5055; "Opportunity No."; Code[20])
        {
            Caption = 'Opportunity No.';
            TableRelation = Opportunity;
        }
        field(5700; "Responsibility Center"; Code[10])
        {
            Caption = 'Responsibility Center';
            TableRelation = "Responsibility Center";
        }
        field(7001; "Allow Line Disc."; Boolean)
        {
            Caption = 'Allow Line Disc.';
        }
        field(7200; "Get Shipment Used"; Boolean)
        {
            Caption = 'Get Shipment Used';
        }
        // field(8000; Id; Guid)
        // {
        //     Caption = 'Id';
        //     ObsoleteState = Pending;
        //     ObsoleteReason = 'This functionality will be replaced by the systemID field';
        //     ObsoleteTag = '15.0';
        // }
        field(8001; "Draft Invoice SystemId"; Guid)
        {
            Caption = 'Draft Invoice SystemId';
            DataClassification = SystemMetadata;
        }
        field(1017150; "Process No."; Code[20])
        {
            Caption = 'Process No.';
        }
        field(1017153; "Delete After Sales"; Boolean)
        {
            CalcFormula = Lookup("Ext. Pst. Header Information"."Delete After Sales" WHERE("Sales/Purchase" = CONST(Sales),
                                                                                            "Document Type" = CONST(Invoice),
                                                                                            "Document No." = FIELD("No.")));
            Caption = 'Delete After Sales';
            Description = 'IT_8482';
            Editable = false;
            FieldClass = FlowField;
        }
        field(1017157; "Invoice Print Type"; Option)
        {
            Caption = 'Invoice Print Type';
            Description = 'IT_2599';
            OptionCaption = ' ,Batch Invoice,Combined Invoice';
            OptionMembers = " ","Batch Invoice","Combined Invoice";
        }
        field(1017158; "Salutation Code"; Code[10])
        {
            Caption = 'Salutation Code';
            Description = 'TAFCOR';
            TableRelation = Salutation.Code;
        }
        field(1017161; "Return Handling No."; Code[20])
        {
            Caption = 'Return Handling No.';
            Description = 'Service Light';
        }
        field(1017168; "Internal Order"; Boolean)
        {
            Caption = 'Internal Order';
            Description = 'IT_2817';
        }
        field(1017169; "Call Center"; Boolean)
        {
            Caption = 'Call Center';
            Description = 'IT_2933';
        }
        field(1017170; "Service Planner Res. No."; Code[20])
        {
            CalcFormula = Lookup("Ext. Pst. Header Information"."Service Planner Res. No." WHERE("Sales/Purchase" = CONST(Sales),
                                                                                                  "Document Type" = CONST(Invoice),
                                                                                                  "Document No." = FIELD("No.")));
            Caption = 'Service Planner Reservation No.';
            Description = 'IT_21802';
            Editable = false;
            FieldClass = FlowField;
            TableRelation = "Service Planner Header";
            ValidateTableRelation = false;
        }
        field(1017171; "Print Manuf. Item No. on SD"; Option)
        {
            Caption = 'Print Manuf. Item  No. on Sales Documents';
            DataClassification = ToBeClassified;
            Description = 'TFS_11956';
            OptionCaption = 'Yes,No';
            OptionMembers = Yes,No;
        }
        field(1017173; "Veh. Statistic Entry No."; Integer)
        {
            Caption = 'Veh. Statistic Entry No.';
            Description = 'TFS_11330';
        }
        field(1017174; "Veh. Statistic Transfer Date"; Date)
        {
            Caption = 'Veh. Statistic Transfer Date';
            Description = 'TFS_11330';
        }
        field(1017177; "Pmt. Discount Base incl. VAT"; Decimal)
        {
            CalcFormula = Sum("Sales Invoice Line Buffer"."Pmt. Discount Base incl. VAT" WHERE("Service Center Key" = field("Service Center Key"), "Document No." = FIELD("No.")));
            Caption = 'Pmt. Discount Base incl. VAT';
            Description = 'IT_3053';
            Editable = false;
            FieldClass = FlowField;
        }
        field(1017185; "Order Type"; Code[10])
        {
            Caption = 'Order Type';
            Description = 'IT_6487';
            TableRelation = "Order Type";
        }
        field(1017250; "Allow Fastfit Disc."; Boolean)
        {
            Caption = 'Allow Fastfit Discount';
        }
        field(1017253; "Representative Code"; Code[20])
        {
            Caption = 'Representative Code';
            TableRelation = "Salesperson/Purchaser";
        }
        field(1017255; "Allowed Document Types"; Option)
        {
            Caption = 'Allowed Document Types';
            OptionCaption = ' ,Cash Sales,Delivery Note';
            OptionMembers = " ","Cash Sales","Delivery Note";
        }
        field(1017256; "Invoice Type Code"; Code[10])
        {
            Caption = 'Invoice Type Code';
            TableRelation = "Invoice Type";
        }
        field(1017257; "Combine Shipment Headline"; Code[10])
        {
            CalcFormula = Lookup("Ext. Pst. Header Information"."Combine Shipment Headline" WHERE("Sales/Purchase" = CONST(Sales),
                                                                                                   "Document Type" = CONST(Invoice),
                                                                                                   "Document No." = FIELD("No.")));
            Caption = 'Combine Shipment Headline';
            FieldClass = FlowField;
            TableRelation = "Combine Shipment Headline";
        }
        field(1017258; "Price Print Indicator"; Option)
        {
            Caption = 'Price Print Indicator';
            OptionCaption = ' ,Condition,Net Price,Condition+Net Price,Totals Only';
            OptionMembers = " ",Condition,"Net Price","Condition+Net Price","Totals Only";
        }
        field(1017260; "Billing Information Code"; Code[10])
        {
            Caption = 'Billing Information Code';
            Description = 'IT_408';
            TableRelation = "Billing Information";
        }
        field(1017261; "Entry No."; Integer)
        {
            BlankZero = true;
            Caption = 'Entry No.';
        }
        field(1017262; "Bonus allowed"; Boolean)
        {
            Caption = 'Bonus allowed';
            Description = 'IT_1362';
        }
        field(1017280; "BAH Sale"; Boolean)
        {
            Caption = 'Bill and Hold Sale';
        }
        field(1017287; "Shipment With Weight"; Boolean)
        {
            Caption = 'Show Shipment Weight';
            Description = 'IT_2959';
        }
        field(1017289; "Print Price Return Order Conf."; Option)
        {
            Caption = 'Print Price Return Order Conf.';
            Description = 'IT_3667';
            OptionCaption = ' ,Unit Price,Unit Price/Net Price';
            OptionMembers = " ","Unit Price","Unit Price/Net Price";
        }
        field(1017291; "Our Account No."; Text[20])
        {
            Caption = 'Our Account No.';
            Description = 'IT_4042';
        }
        field(1017292; "First Invoice Doc."; Boolean)
        {
            Caption = 'First Invoice Doc.';
            Description = 'IT_4619';
        }
        field(1017294; "Text 1"; Text[50])
        {
            CalcFormula = Lookup("Ext. Pst. Header Information"."Text 1" WHERE("Sales/Purchase" = CONST(Sales),
                                                                                "Document Type" = CONST(Invoice),
                                                                                "Document No." = FIELD("No.")));
            FieldClass = FlowField;
        }
        field(1017295; "Text 2"; Text[50])
        {
            CalcFormula = Lookup("Ext. Pst. Header Information"."Text 2" WHERE("Sales/Purchase" = CONST(Sales),
                                                                                "Document Type" = CONST(Invoice),
                                                                                "Document No." = FIELD("No.")));
            FieldClass = FlowField;
        }
        field(1017296; "Text 3"; Text[50])
        {
            CalcFormula = Lookup("Ext. Pst. Header Information"."Text 3" WHERE("Sales/Purchase" = CONST(Sales),
                                                                                "Document Type" = CONST(Invoice),
                                                                                "Document No." = FIELD("No.")));
            FieldClass = FlowField;
        }
        field(1017297; "Text 4"; Text[50])
        {
            CalcFormula = Lookup("Ext. Pst. Header Information"."Text 4" WHERE("Sales/Purchase" = CONST(Sales),
                                                                                "Document Type" = CONST(Invoice),
                                                                                "Document No." = FIELD("No.")));
            FieldClass = FlowField;
        }
        field(1017298; "Text 5"; Text[50])
        {
            CalcFormula = Lookup("Ext. Pst. Header Information"."Text 5" WHERE("Sales/Purchase" = CONST(Sales),
                                                                                "Document Type" = CONST(Invoice),
                                                                                "Document No." = FIELD("No.")));
            FieldClass = FlowField;
        }
        field(1017299; "Text 6"; Text[50])
        {
            CalcFormula = Lookup("Ext. Pst. Header Information"."Text 6" WHERE("Sales/Purchase" = CONST(Sales),
                                                                                "Document Type" = CONST(Invoice),
                                                                                "Document No." = FIELD("No.")));
            FieldClass = FlowField;
        }
        field(1017300; "Text 7"; Text[50])
        {
            CalcFormula = Lookup("Ext. Pst. Header Information"."Text 7" WHERE("Sales/Purchase" = CONST(Sales),
                                                                                "Document Type" = CONST(Invoice),
                                                                                "Document No." = FIELD("No.")));
            FieldClass = FlowField;
        }
        field(1017301; "Caption Code"; Code[10])
        {
            CalcFormula = Lookup("Ext. Pst. Header Information"."Caption Code" WHERE("Sales/Purchase" = CONST(Sales),
                                                                                      "Document Type" = CONST(Invoice),
                                                                                      "Document No." = FIELD("No.")));
            Caption = 'Caption Code';
            Description = 'IT_4159';
            FieldClass = FlowField;
            TableRelation = "Dynamic Caption Codes";
        }
        field(1017302; "SC Codes Lines"; Boolean)
        {
            CalcFormula = Exist("SC Codes Line" WHERE("Document No." = FIELD("No."),
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
        field(1017361; "Central Maintenance"; Boolean)
        {
            Caption = 'Central Maintenance';
            Description = 'IT_20506';
        }
        field(1017450; "PDF Send"; Boolean)
        {
            Caption = 'PDF Send';
            Description = 'IT_3436';
        }
        field(1017460; "Tire Hotel No."; Code[20])
        {
            Caption = 'Tire Hotel No.';
            Description = 'IT_2845';
            TableRelation = "Tire Hotel";
        }
        field(1017461; "Tire Hotel Service Center"; Code[10])
        {
            CalcFormula = Lookup("Ext. Pst. Header Information"."Tire Hotel Service Center" WHERE("Sales/Purchase" = CONST(Sales),
                                                                                                   "Document Type" = CONST(Invoice),
                                                                                                   "Document No." = FIELD("No.")));
            Caption = 'Tire Hotel Service Center';
            FieldClass = FlowField;
            TableRelation = "Service Center";
        }
        field(1017462; "Tire Hotel Storage Code"; Code[20])
        {
            CalcFormula = Lookup("Ext. Pst. Header Information"."Tire Hotel Storage Code" WHERE("Sales/Purchase" = CONST(Sales),
                                                                                                 "Document Type" = CONST(Invoice),
                                                                                                 "Document No." = FIELD("No.")));
            Caption = 'Tire Hotel Storage Code';
            FieldClass = FlowField;
        }
        field(1017463; "Tire Hotel Bin No."; Integer)
        {
            CalcFormula = Lookup("Ext. Pst. Header Information"."Tire Hotel Bin No." WHERE("Sales/Purchase" = CONST(Sales),
                                                                                            "Document Type" = CONST(Invoice),
                                                                                            "Document No." = FIELD("No.")));
            Caption = 'Tire Hotel Bin No.';
            FieldClass = FlowField;
        }
        field(1017464; "First Arrangement Date"; Date)
        {
            Caption = 'Creation Date';
        }
        field(1017465; "Season actual"; Option)
        {
            Caption = 'Season';
            Description = 'IT_21227';
            OptionCaption = ' ,Summer,Winter';
            OptionMembers = " ",Summer,Winter;
        }
        field(1017466; "Date of Last Storage"; Date)
        {
            Caption = 'Date of Last Storage';
        }
        field(1017540; "Vehicle No."; Code[20])
        {
            Caption = 'Vehicle No.';
            TableRelation = Vehicle;
            trigger OnLookup()
            begin
            end;

            trigger OnValidate()
            begin
            end;
        }
        field(1017541; "Licence-Plate No."; Code[20])
        {
            Caption = 'Licence-Plate No.';
            Description = 'IT_6115';
        }
        field(1017542; "Vehicle Manufacturer"; Text[30])
        {
            CalcFormula = Lookup("Ext. Pst. Header Information"."Vehicle Manufacturer" WHERE("Sales/Purchase" = CONST(Sales),
                                                                                              "Document Type" = CONST(Invoice),
                                                                                              "Document No." = FIELD("No.")));
            Caption = 'Vehicle Manufacturer';
            FieldClass = FlowField;
            //This property is currently not supported
            //TestTableRelation = false;
        }
        field(1017543; "Vehicle Model"; Text[60])
        {
            CalcFormula = Lookup("Ext. Pst. Header Information"."Vehicle Model" WHERE("Sales/Purchase" = CONST(Sales),
                                                                                       "Document Type" = CONST(Invoice),
                                                                                       "Document No." = FIELD("No.")));
            Caption = 'Vehicle Model';
            FieldClass = FlowField;
            //This property is currently not supported
            //TestTableRelation = false;
        }
        field(1017544; "Vehicle Variant"; Text[60])
        {
            CalcFormula = Lookup("Ext. Pst. Header Information"."Vehicle Variant" WHERE("Sales/Purchase" = CONST(Sales),
                                                                                         "Document Type" = CONST(Invoice),
                                                                                         "Document No." = FIELD("No.")));
            Caption = 'Vehicle Variant';
            FieldClass = FlowField;
            //This property is currently not supported
            //TestTableRelation = false;
        }
        field(1017545; "Vehicle Identification No."; Code[20])
        {
            CalcFormula = Lookup("Ext. Pst. Header Information"."Vehicle Identification No." WHERE("Sales/Purchase" = CONST(Sales),
                                                                                                    "Document Type" = CONST(Invoice),
                                                                                                    "Document No." = FIELD("No.")));
            Caption = 'Vehicle Identification No.';
            FieldClass = FlowField;
        }
        field(1017546; "Licenced from"; Date)
        {
            Caption = 'Licenced from';
        }
        field(1017547; "First Licence Date"; Date)
        {
            Caption = 'First Licence Date';
        }
        field(1017548; "Next General Inspection"; Date)
        {
            Caption = 'Next General Inspection';
        }
        field(1017549; "Next Exhaust Check"; Date)
        {
            Caption = 'Next Exhaust Check';
            Description = 'DE';
        }
        field(1017550; Mileage; Integer)
        {
            Caption = 'Mileage this Visit';
            Description = 'IT_20469';
        }
        field(1017551; "Vehicle Entry Created"; Boolean)
        {
            Caption = 'Vehicle Entry Created';
        }
        field(1017556; "Old Mileage"; Integer)
        {
            Caption = 'Mileage Previous Visit';
            Description = 'IT_3690,IT_20469';
        }
        field(1017557; "Key No. from Vehicle and Model"; Code[6])
        {
            CalcFormula = Lookup("Ext. Pst. Header Information"."Key No. from Vehicle and Model" WHERE("Sales/Purchase" = CONST(Sales),
                                                                                                        "Document Type" = CONST(Invoice),
                                                                                                        "Document No." = FIELD("No.")));
            Caption = 'Key No. from Vehicle and Model';
            Description = 'IT_3909';
            FieldClass = FlowField;
        }
        field(1017558; "Key No. from Vehicle Manuf."; Code[20])
        {
            CalcFormula = Lookup("Ext. Pst. Header Information"."Key No. from Vehicle Manuf." WHERE("Sales/Purchase" = CONST(Sales),
                                                                                                     "Document Type" = CONST(Invoice),
                                                                                                     "Document No." = FIELD("No.")));
            Caption = 'Manufacturer Code';
            Description = 'IT_3909';
            FieldClass = FlowField;
            TableRelation = "Vehicle Specification".Code WHERE(Type = CONST(Manufacturer));
            trigger OnValidate()
            var
                VehicleSpec: Record "Vehicle Specification";
            begin
            end;
        }
        field(1017559; "Key No. from Type and Version"; Code[20])
        {
            CalcFormula = Lookup("Ext. Pst. Header Information"."Key No. from Type and Version" WHERE("Sales/Purchase" = CONST(Sales),
                                                                                                       "Document Type" = CONST(Invoice),
                                                                                                       "Document No." = FIELD("No.")));
            Caption = 'Key No. from Type and Version';
            Description = 'IT_3909';
            FieldClass = FlowField;
        }
        field(1017560; "Licence-Plate No. Short"; Code[20])
        {
            Caption = 'Licence-Plate No. Short';
            Description = 'IT_4044,IT_6115';
        }
        field(1017561; "Vehicle Year"; Text[4])
        {
            CalcFormula = Lookup("Ext. Pst. Header Information"."Vehicle Year" WHERE("Sales/Purchase" = CONST(Sales),
                                                                                      "Document Type" = CONST(Invoice),
                                                                                      "Document No." = FIELD("No.")));
            Caption = 'Vehicle Year';
            Description = 'IT_4310';
            FieldClass = FlowField;
            Numeric = true;
        }
        field(1017570; "Cash Payment"; Boolean)
        {
            Caption = 'Cash Payment';
            Description = 'BSS.CASH001.GT';
        }
        field(1017571; "Cash Payment Document Type"; Option)
        {
            Caption = 'Cash Payment Document Type';
            Description = 'BSS.CASH001.GT';
            Editable = false;
            OptionCaption = ' ,Cash Receipt Slip,Full Cash Receipt,Cash Invoice';
            OptionMembers = " ","Cash Receipt Slip","Full Cash Receipt","Cash Invoice";
        }
        field(1017572; "Diverse Customers"; Boolean)
        {
            Caption = 'Diverse Customers';
            Description = 'BSS.CASH001.GT';
        }
        field(1017573; "Cash Register Receipt"; Code[20])
        {
            Caption = 'Cash Register Receipt';
            Description = 'BSS.CASH001.GT';
        }
        field(1017575; "Cancelled by Cr. Memo"; Boolean)
        {
            CalcFormula = Exist("Cancelled Document Buffer" WHERE("Source ID" = CONST(112),
                                                            "Service Center Key" = field("Service Center Key"),
                                                            "Cancelled Doc. No." = FIELD("No.")));
            Caption = 'Cancelled by Cr. Memo';
            Description = 'IT_20398,IT_21588';
            Editable = false;
            FieldClass = FlowField;
        }
        field(1017650; "Adhoc Reference No."; Text[30])
        {
            Caption = 'Adhoc Reference No.';
            Description = 'IT_6487';
        }
        field(1018333; "Service Center"; Code[10])
        {
            Caption = 'Service Center';
            TableRelation = "Service Center".Code;
        }
        field(1018361; "Salesperson Code 2"; Code[20])
        {
            Caption = 'Salesperson Code 2';
            Description = 'IT_2251';
            TableRelation = "Salesperson/Purchaser";
        }
        field(1018362; "Fitter 1"; Code[20])
        {
            Caption = 'Mechanic 1';
            Description = 'IT_2251';
            TableRelation = "Salesperson/Purchaser";
        }
        field(1018363; "Fitter 2"; Code[20])
        {
            Caption = 'Mechanic 2';
            Description = 'IT_2251';
            TableRelation = "Salesperson/Purchaser";
        }
        field(1018364; "Fitter 3"; Code[20])
        {
            Caption = 'Mechanic 3';
            Description = 'IT_2251';
            TableRelation = "Salesperson/Purchaser";
        }
        field(1018460; "Fax No."; Text[30])
        {
            Caption = 'Fax No.';
            Description = 'IT_2305';
        }
        field(1018461; "E-Mail"; Text[80])
        {
            Caption = 'E-Mail';
            Description = 'IT_3436';
        }
        field(1018462; "Phone No."; Text[50])
        {
            Caption = 'Phone No.';
            Description = 'IT_20470';
        }
        field(1018463; "PDF Invoice created"; Boolean)
        {
            Caption = 'PDF Invoice created';
            Description = 'IT_6481';
        }
        field(1018464; "Mobile Phone No."; Text[30])
        {
            Caption = 'Mobile Phone No.';
            Description = 'IT_20470';
        }
        field(1018552; "TecDoc Vehicle No."; Code[10])
        {
            CalcFormula = Lookup("Ext. Pst. Header Information"."TecDoc Vehicle No." WHERE("Sales/Purchase" = CONST(Sales),
                                                                                            "Document Type" = CONST(Invoice),
                                                                                            "Document No." = FIELD("No.")));
            Caption = 'TecDoc Vehicle No.';
            Description = 'IT_4043,IT_21665';
            FieldClass = FlowField;
        }
        // field(1018625; "No. Of Vehicle Checks"; Integer)
        // {
        //     ObsoleteState = Removed;
        // }
        // field(1018626; "No. Of Incoming VC"; Integer)
        // {
        //     ObsoleteState = Removed;
        // }
        // field(1018627; "No. Of Outgoing VC"; Integer)
        // {
        //     ObsoleteState = Removed;
        // }
        field(1018650; "Path To PDF Invoice File"; Text[150])
        {
            CalcFormula = Lookup("Ext. Pst. Header Information"."Path To PDF Invoice File" WHERE("Sales/Purchase" = CONST(Sales),
                                                                                                  "Document Type" = CONST(Invoice),
                                                                                                  "Document No." = FIELD("No.")));
            Caption = 'Path To PDF Invoice File';
            Description = 'IT_7931';
            Editable = false;
            FieldClass = FlowField;
        }
        field(1018651; "PDF Inv. File Ref.No."; Code[20])
        {
            Caption = 'PDF Inv. File Ref.No.';
            Description = 'IT_7931';
        }
        field(1018657; "Reference No."; Code[20])
        {
            Caption = 'Reference No.';
            Description = 'IT_6964';
        }
        field(1018658; "Last Result"; Text[250])
        {
            CalcFormula = Lookup("Ext. Pst. Header Information"."Last Result" WHERE("Sales/Purchase" = CONST(Sales),
                                                                                     "Document Type" = CONST(Invoice),
                                                                                     "Document No." = FIELD("No.")));
            Caption = 'Last Result';
            Description = 'IT_6964';
            Editable = false;
            FieldClass = FlowField;
        }
        field(1018659; "Error Counter"; Integer)
        {
            Caption = 'Error Counter';
            Description = 'IT_6964';
        }
        field(1018680; "IC Service Center"; Code[10])
        {
            Caption = 'IC Service Center';
            Description = 'IT_5518';
        }
        field(1028061; "EDI Information Code"; Code[20])
        {
            CalcFormula = Lookup("Ext. Pst. Header Information"."EDI Information Code" WHERE("Sales/Purchase" = CONST(Sales),
                                                                                              "Document Type" = CONST(Invoice),
                                                                                              "Document No." = FIELD("No.")));
            Caption = 'EDI Information Code';
            Description = 'IT_6226';
            FieldClass = FlowField;
        }
        field(1028120; "Cust. Res. Disc. Group"; Code[10])
        {
            Caption = 'Cust. Res. Disc. Group';
            Description = 'IT_7593';
            TableRelation = "Cust. Res. Disc. Group".Code;
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
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
        field(1028280; "No G/L Integration"; Boolean)
        {
            Caption = 'No G/L Integration';
            Description = 'IT_6595';
            Editable = false;
        }
        field(1044380; "Appointment Date"; Date)
        {
            Caption = 'Appointment Date';
            Description = 'IT_20389';
        }
        field(1044381; "Appointment Time"; Time)
        {
            Caption = 'Appointment Time';
            Description = 'IT_20389';
        }
        field(1044384; "Notif. Reminder Sent"; Boolean)
        {
            Caption = 'Notif. Reminder Sent';
            Description = 'IT_20434';
        }
        field(1044385; "Online Created"; Boolean)
        {
            Caption = 'Online Created';
            Description = 'IT_20448';
        }
        field(1044400; "Overpayment Amount"; Decimal)
        {
            Caption = 'Overpayment Amount';
            Description = 'IT_20548';
        }
        field(1044401; "Overpayment Amount (LCY)"; Decimal)
        {
            Caption = 'Overpayment Amount (LCY)';
            Description = 'IT_20548';
        }
        field(1044402; "Cust. Ledg. Entry Filter"; Text[250])
        {
            CalcFormula = Lookup("Ext. Pst. Header Information"."Cust. Ledg. Entry Filter" WHERE("Sales/Purchase" = CONST(Sales),
                                                                                                  "Document Type" = CONST(Invoice),
                                                                                                  "Document No." = FIELD("No.")));
            Caption = 'Cust. Ledg. Entry Filter';
            Description = 'IT_20630';
            FieldClass = FlowField;
        }
        field(1044560; "Shopping Basket No."; Code[20])
        {
            Caption = 'Shopping Basket No.';
            Description = 'IT_20766';
        }
        field(1044561; "Perf. Buffer Updated"; Boolean)
        {
            Caption = 'Perf. Buffer Updated';
            Description = 'IT_20766';
        }
        // field(1044572; "Vehicle Check Status"; Option)
        // {
        //     OptionMembers = "Not Done","On-Going",Done,"Not Mandatory";
        //     ObsoleteState = Removed;
        // }
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
        field(1044870; "Buffer Flag"; Boolean)
        {
        }
        field(1044880; "Service Center Key"; Code[10])
        {
        }
        field(1073860; "VC Vehicle Check Status"; Option)
        {
            Caption = 'Vehicle Check Status';
            OptionMembers = "Not Mandatory","Not Done","On-Going",Done;
            DataClassification = CustomerContent;
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Service Center Key", "No.")
        {
            Clustered = true;
        }
        key(Key2; "Order No.")
        {
        }
        key(Key3; "Pre-Assigned No.")
        {
        }
        key(Key4; "Sell-to Customer No.", "External Document No.")
        {
            MaintainSQLIndex = false;
        }
        key(Key5; "Sell-to Customer No.", "Order Date")
        {
            MaintainSQLIndex = false;
        }
        key(Key6; "Sell-to Customer No.")
        {
        }
        key(Key7; "Prepayment Order No.", "Prepayment Invoice")
        {
        }
        key(Key8; "Bill-to Customer No.")
        {
        }
        key(Key9; "Process No.")
        {
        }
        key(Key10; "Vehicle No.", "Vehicle Entry Created")
        {
        }
        key(Key11; "Salesperson Code", "Document Date")
        {
        }
        key(Key12; "Service Center")
        {
        }
        key(Key13; "Bill-to Customer No.", "Bill-to Contact No.")
        {
        }
        key(Key14; "Sell-to Customer No.", "Sell-to Contact No.")
        {
        }
        key(Key15; "Sell-to Customer No.", "Posting Date")
        {
        }
        key(Key16; "Reference No.")
        {
        }
        key(Key17; "Licence-Plate No.")
        {
        }
        key(Key18; "Posting Date")
        {
        }
        key(Key19; "Document Exchange Status")
        {
        }
        key(Key20; "Due Date")
        {
        }
        key(Key21; "Service Center", "Salesperson Code", "Vehicle No.")
        {
        }
        key(Key22; "Veh. Statistic Entry No.", "Posting Date")
        {
        }
        key(Key23; "Salesperson Code")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "No.", "Sell-to Customer No.", "Bill-to Customer No.", "Posting Date", "Posting Description")
        {
        }
        fieldgroup(Brick; "No.", "Sell-to Customer Name", Amount, "Due Date", "Amount Including VAT")
        {
        }
    }


}
