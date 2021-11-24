table 1044891 "Service Center Buffer"
{
    Caption = 'Service Center Buffer';
    DrillDownPageID = "Service Center Buffer List";
    LookupPageID = "Service Center Buffer List";

    fields
    {
        field(1; "Code"; Code[10])
        {
            Caption = 'Code';
            NotBlank = true;
        }
        field(2; Name; Text[100])
        {
            Caption = 'Name';
        }
        field(3; Address; Text[100])
        {
            Caption = 'Address';
        }
        field(4; "Address 2"; Text[50])
        {
            Caption = 'Address 2';
        }
        field(5; City; Text[30])
        {
            Caption = 'City';
        }
        field(6; "Post Code"; Code[20])
        {
            Caption = 'Post Code';
            TableRelation = "Post Code";
        }
        field(7; "Country/Region Code"; Code[10])
        {
            Caption = 'Country/Region Code';
            TableRelation = "Country/Region";
        }
        field(8; "Phone No."; Text[30])
        {
            Caption = 'Phone No.';
            ExtendedDatatype = PhoneNo;
        }
        field(9; "Fax No."; Text[30])
        {
            Caption = 'Fax No.';
        }
        field(10; "Name 2"; Text[50])
        {
            Caption = 'Name 2';
        }
        field(11; Contact; Text[100])
        {
            Caption = 'Contact';
        }
        field(12; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(13; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(14; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            TableRelation = Location WHERE("Use As In-Transit" = CONST(false));
        }
        field(15; County; Text[30])
        {
            Caption = 'County';
        }
        field(102; "E-Mail"; Text[80])
        {
            Caption = 'E-Mail';
            ExtendedDatatype = EMail;
        }
        field(103; "Home Page"; Text[90])
        {
            Caption = 'Home Page';
            ExtendedDatatype = URL;
        }
        field(5900; "Date Filter"; Date)
        {
            Caption = 'Date Filter';
            FieldClass = FlowFilter;
        }
        field(5901; "Contract Gain/Loss Amount"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = Sum("Contract Gain/Loss Entry".Amount WHERE("Service Center" = FIELD(Code),
                                                                       "Change Date" = FIELD("Date Filter")));
            Caption = 'Contract Gain/Loss Amount';
            Editable = false;
            FieldClass = FlowField;
        }
        field(1017150; "Service Center Group"; Code[10])
        {
            Caption = 'Service Center Group';
            TableRelation = "Serv. Center Group";
        }
        field(1017151; Picture; BLOB)
        {
            Caption = 'Picture';
            SubType = Bitmap;
        }
        field(1017152; "SC Pricegroup (Item)"; Code[10])
        {
            Caption = 'SC Pricegroup (Item)';
            TableRelation = "SC Pricegroup (Item)";
        }
        field(1017153; "Advertising Text Sales"; Code[20])
        {
            Caption = 'Advertising Text Sales';
            TableRelation = "Standard Text";
        }
        field(1017154; "Call Center"; Boolean)
        {
            Caption = 'Call Center';
        }
        field(1017155; "Information Text Window Header"; Text[30])
        {
            Caption = 'Information Text Window Header';
        }
        field(1017156; "Suppress Serv. Center Warn."; Boolean)
        {
            Caption = 'Suppress Serv. Center Warning';
        }
        field(1017157; "SC Pricegroup (Service)"; Code[10])
        {
            Caption = 'SC Pricegroup (Service)';
            TableRelation = "SC Pricegroup (Service)";
        }
        field(1017158; "Customer No. Transfer"; Code[20])
        {
            Caption = 'Customer No. Transfer';
            TableRelation = Customer;
        }
        field(1017159; "Franchise No."; Text[30])
        {
            Caption = 'Franchise No.';
        }
        field(1017160; "Login Info Text"; BLOB)
        {
            Caption = 'Login Info Text';
            SubType = Bitmap;
        }
        field(1017161; "Zone Dimension"; Code[20])
        {
            Caption = 'Zone Dimension';
            TableRelation = Dimension;
        }
        field(1017162; "Dealer Dimension"; Code[20])
        {
            Caption = 'Dealer Dimension';
            TableRelation = Dimension;
        }
        field(1017163; "Zone Dimension Value"; Code[20])
        {
            Caption = 'Zone Dimension Value';
            TableRelation = "Dimension Value".Code WHERE("Dimension Code" = FIELD("Zone Dimension"));
        }
        field(1017164; "Dealer Dimension Value"; Code[20])
        {
            Caption = 'Dealer Dimension Value';
            TableRelation = "Dimension Value".Code WHERE("Dimension Code" = FIELD("Dealer Dimension"));
        }
        field(1017250; "Return Order Location Code"; Code[10])
        {
            Caption = 'Return Order Location Code';
            TableRelation = Location WHERE("Service Center" = FIELD(Code));
        }
        field(1017280; "BAH Ship Only allowed"; Boolean)
        {
            Caption = 'BAH Ship Only allowed';
        }
        field(1017281; "BAH Show Rem. Qty"; Boolean)
        {
            Caption = 'Show BAH Rem. Qty ';
        }
        field(1017282; "Standard Customer No."; Code[20])
        {
            Caption = 'Standard Customer No.';
            TableRelation = Customer;
        }
        field(1017283; "Standard Catalog"; Code[10])
        {
            Caption = 'Standard Catalog';
            TableRelation = Catalog;
        }
        field(1017361; "Central Maintenance"; Boolean)
        {
            Caption = 'Central Maintenance';
        }
        field(1017460; "Phone No. 2"; Text[50])
        {
            Caption = 'Phone No. 2';
        }
        field(1017461; "Mobile Phone No."; Text[50])
        {
            Caption = 'Mobile Phone No.';
        }
        field(1017462; "Mobile Phone No. 2"; Text[50])
        {
            Caption = 'Mobile Phone No. 2';
        }
        field(1017463; "Fax No. 2"; Text[50])
        {
            Caption = 'Fax No. 2';
        }
        field(1017464; "E-Mail 2"; Text[50])
        {
            Caption = 'E-Mail 2';
        }
        field(1017570; "Cash Reg. Slip Type"; Option)
        {
            Caption = 'Cash Reg. Slip Type';
            OptionCaption = 'Small Cash Reg. Receipt,Large Cash Reg. Receipt';
            OptionMembers = "Small Cash Reg. Receipt","Large Cash Reg. Receipt";
        }
        field(1017571; "Cash Reg. Slip Type Document"; Option)
        {
            Caption = 'Cash Reg. Slip Type Document';
            OptionCaption = ' ,Cash Receipt Slip,Full Cash Receipt,Cash Invoice';
            OptionMembers = " ","Cash Receipt Slip","Full Cash Receipt","Cash Invoice";
        }
        field(1017572; Headquarter; Boolean)
        {
            Caption = 'Headquarter';
        }
        field(1017573; "Purchase Invoice Allowed"; Boolean)
        {
            Caption = 'Purchase Invoice Allowed';
        }
        field(1017574; "Sales Invoice Allowed"; Boolean)
        {
            Caption = 'Sales Invoice Allowed';
        }
        field(1017575; "Sales Credit Memo Allowed"; Boolean)
        {
            Caption = 'Sales Credit Memo Allowed';
        }
        field(1017576; "Document Header Text"; Text[100])
        {
            Caption = 'Document Header Text';
        }
        field(1017577; "Mandatory Bin Code Check"; Boolean)
        {
            Caption = 'Mandatory Bin Code Check for Sales Posting';
        }
        field(1017730; "Casing Location"; Code[10])
        {
            Caption = 'Casing Location';
            TableRelation = Location;
        }
        field(1017731; "Dealer Cust. No. for RO"; Code[20])
        {
            Caption = 'Dealer Customer No. for Retread Orders';
            TableRelation = Customer;
        }
        field(1018420; "DHL Path Export"; Text[250])
        {
            Caption = 'DHL Path Export';
        }
        field(1018421; "TOF Path Export"; Text[250])
        {
            Caption = 'TOF Path Export';
        }
        field(1018422; "DPD Path Export"; Text[250])
        {
            Caption = 'DPD Path Export';
        }
        field(1018423; "UPS Path Export"; Text[250])
        {
            Caption = 'UPS Path Export';
        }
        field(1018424; "GLS Path Export"; Text[250])
        {
            Caption = 'GLS Path Export';
        }
        field(1018425; "TNT Path Export"; Text[250])
        {
            Caption = 'TNT Path Export';
        }
        field(1018426; "DPD-ABC Path Export"; Text[250])
        {
            Caption = 'DPD-ABC Path Export';
        }
        field(1018626; "Suppr. Service Check Warning"; Boolean)
        {
            Caption = 'Suppr. Service Check Warning';
        }
        field(1028275; "Deleted by HQ"; Boolean)
        {
            Caption = 'Deleted by HQ';
        }
        // field(1028276; "Replication Date"; DateTime)
        // {
        //     Caption = 'Replication Date';
        //     ObsoleteState = Removed;
        //     ObsoleteReason = 'Replaced by another feature (Data Distribution)';
        //     Description = 'IT_8792';
        //     Editable = false;
        // }
        // field(1028277; "Repl. Post Run Finished"; Boolean)
        // {
        //     Caption = 'Repl. Post Run Finished';
        //     ObsoleteState = Removed;
        //     ObsoleteReason = 'Replaced by another feature (Data Distribution)';
        //     Description = 'IT_8792';
        // }
        // field(1028278; "Replication Filter"; Code[2])
        // {
        //     Caption = 'Replication Filter';
        //     ObsoleteState = Removed;
        //     ObsoleteReason = 'Replaced by another feature (Data Distribution)';
        //     Description = 'IT_8792';
        // }
        field(1044380; "Web Price List Item"; Code[20])
        {
            Caption = 'Web Price List Item';
            TableRelation = "Customer Price Group";
        }
        field(1044381; "Web Price List Service"; Code[10])
        {
            Caption = 'Web Price List Service';
            TableRelation = "Cust. Res. Price Group";
        }
        field(1044382; "Allow Web Price Availability"; Option)
        {
            Caption = 'Allow Web Price Availability';
            OptionCaption = 'Never,GetStockAvailability,GetExactStockAvailability,Both';
            OptionMembers = Never,GetStockAvailability,GetExactStockAvailability,Both;
        }
        field(1044390; "Franchise Consultant"; Code[50])
        {
            Caption = 'Franchise Consultant';
            TableRelation = "User Setup";
        }
        field(1044391; "Regional Consultant Manager"; Code[50])
        {
            Caption = 'Regional Consultant Manager';
            TableRelation = "User Setup";
        }
        field(1044392; "National Consultant Manager"; Code[50])
        {
            Caption = 'National Consultant Manager';
            TableRelation = "User Setup";
        }
        field(1044393; "Customer Account Manager"; Code[50])
        {
            Caption = 'Customer Account Manager';
            TableRelation = "User Setup";
        }
        field(1044394; "Regional Sales Manager"; Code[50])
        {
            Caption = 'Regional Sales Manager';
            TableRelation = "User Setup";
        }
        field(1044395; "National Sales Manager"; Code[50])
        {
            Caption = 'National Sales Manager';
            TableRelation = "User Setup";
        }
        field(1044396; "Franchisee Declared Bays"; Decimal)
        {
            Caption = 'Franchisee Declared Bays';
        }
        field(1044397; "Surface Area of POS (m2)"; Decimal)
        {
            Caption = 'Surface Area of POS (m2)';
        }
        field(1044398; "Fastfit Go-Live Date"; Date)
        {
            Caption = 'Fastfit Go-Live Date';
        }
        field(1044399; "Geo-Localization Long."; Decimal)
        {
            Caption = 'Geo-Localization Long.';
            DecimalPlaces = 2 : 6;
        }
        field(1044400; "Geo-Localization Lat."; Decimal)
        {
            Caption = 'Geo-Localization Lat.';
            DecimalPlaces = 2 : 6;
        }
        field(1044401; "Franchise Go-Live Date"; Date)
        {
            Caption = 'Franchise Go-Live Date';
        }
        // field(1059110; "Prevent Synchronization"; Boolean)
        // {
        //     Caption = 'Prevent Synchronization';
        //     ObsoleteState = Removed;
        //     ObsoleteReason = 'Replaced by another feature (Data Distribution)';
        //     Description = 'IT_8792';
        // }
        // field(1059111; "Prevent Replication"; Boolean)
        // {
        //     Caption = 'Prevent Replication';
        //     ObsoleteState = Removed;
        //     ObsoleteReason = 'Replaced by another feature (Data Distribution)';
        //     Description = 'IT_8792';
        // }
    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
    }

}
