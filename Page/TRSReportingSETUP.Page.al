page 1044866 "TRS Reporting SETUP"
{
    // +--------------------------------------------------------------+
    // | @ 2017 incadea Taiwan Limited                                |
    // +--------------------------------------------------------------+
    // | PURPOSE: MARS_TWN                                            |
    // |                                                              |
    // +--------------------------------------------------------------+
    // 
    // VERSION       ID          WHO    DATE        DESCRIPTION
    // TWN.01.03     RGS_TWN-632 NN     2017-06-06  Upgrade from r3
    // RGS_TWN-888   122187	     QX	    2021-01-05  Added OnOpenPage trigger

    PageType = Card;
    SourceTable = "TRS Reporting SETUP";
    UsageCategory = Administration;


    layout
    {
        area(content)
        {
            group("Brand Mix")
            {
                field("Brand Mix Template"; "Brand Mix Template")
                {
                }
            }
            group("Product Mix")
            {
                field("Product Mix Template"; "Product Mix Template")
                {
                }
            }
            group("Product & Services Mix")
            {
                field("Product and Services Template"; "Product and Services Template")
                {
                }
            }
            group("Performance & Benchmark Report")
            {
                field("Position group of Balancing"; "Position group of Balancing")
                {
                }
                field("Position group of Alignments"; "Position group of Alignments")
                {
                }
                field("Position Group For Tire"; "Position Group For Tire")
                {
                }
                field("Position Group For Tire RelSer"; "Position Group For Tire RelSer")
                {
                }
            }
            group("Top 10 Sizes")
            {
                field("Top 10 Main Group Filter"; "Top 10 Main Group Filter")
                {
                }
            }
            group("Tyre Snapshot")
            {
                field("Main group PC Tyres"; "Main group PC Tyres")
                {
                }
                field("Main group SUV Tyres"; "Main group SUV Tyres")
                {
                }
                field("Main group LT Tyres"; "Main group LT Tyres")
                {
                }
                field("Main group 2-3  Wheeler"; "Main group 2-3  Wheeler")
                {
                }
                field("Main Group Truck Tyres"; "Main Group Truck Tyres")
                {
                }
                field("Main Group MPT Tyres"; "Main Group MPT Tyres")
                {
                }
                field("Main group AGRI Tyres"; "Main group AGRI Tyres")
                {
                }
                field("Main Group EM Tyres"; "Main Group EM Tyres")
                {
                }
                field("Main Group Industry Tyres"; "Main Group Industry Tyres")
                {
                }
                field("Main group Used Tyres"; "Main group Used Tyres")
                {
                }
                field("Main group Rims"; "Main group Rims")
                {
                }
                field("Main group Tubes"; "Main group Tubes")
                {
                }
                field("Main group Batteries"; "Main group Batteries")
                {
                }
                field("Main group Lubes"; "Main group Lubes")
                {
                }
                field("Main group Parts"; "Main group Parts")
                {
                }
                field("Main group Accessories"; "Main group Accessories")
                {
                }
                field("Main group Misc"; "Main group Misc")
                {
                }
                field("Main group Services"; "Main group Services")
                {
                }
                field("Sub Group Tire Related"; "Sub Group Tire Related")
                {
                }
                field("Sub Group Vehicle Related"; "Sub Group Vehicle Related")
                {
                }
                field("Item Category for Tire"; "Item Category for Tire")
                {
                }
                field("ManufacturerCode1 for Michelin"; "ManufacturerCode1 for Michelin")
                {
                }
                field("ManufacturerCode2 for Michelin"; "ManufacturerCode2 for Michelin")
                {
                }
            }
            group("TyrePlus Sell Out Mix")
            {
                field("Position Group T(QRST) Index"; "Position Group T(QRST) Index")
                {
                    Caption = 'Position Group S & T Index';
                }
                field("Position Group H Index"; "Position Group H Index")
                {
                }
                field("Position Group V Index"; "Position Group V Index")
                {
                    Caption = 'Position Group V & Z Index';
                }
                field("Position Group WZY Index"; "Position Group WZY Index")
                {
                }
                field("Product Group for PC Tire"; "Product Group for PC Tire")
                {
                }
                field("Product Group for SUV Tire"; "Product Group for SUV Tire")
                {
                }
                field("Product Group for LT Tire"; "Product Group for LT Tire")
                {
                }
            }
            group("TyrePlus Sales Tracker")
            {
                field("Sales Track Main Group Filter"; "Sales Track Main Group Filter")
                {
                }
                field("Main group LCV Tyres"; "Main group LCV Tyres")
                {
                }
                field("Main group TB Tyres"; "Main group TB Tyres")
                {
                }
                field("Main group Chasis Tyres"; "Main group Chasis Tyres")
                {
                }
                field("Main group Set Item"; "Main group Set Item")
                {
                }
                field("Position Group For Car wash"; "Position Group For Car wash")
                {
                }
                field("Position Group For Balancing"; "Position Group For Balancing")
                {
                }
                field("Position Group For Alignment"; "Position Group For Alignment")
                {
                }
                field("Sub Group Boutique"; "Sub Group Boutique")
                {
                }
                field("Manufacturer Code for Service"; "Manufacturer Code for Service")
                {
                }
            }
            group("TyrePlus SOA")
            {
                field("SOA Product Group Filter"; "SOA Product Group Filter")
                {
                }
            }
        }
    }

    actions
    {
    }

    //++TWN1.00.122187.QX
    trigger OnOpenPage()
    begin
        Reset();
        if not Get() then begin
            Init();
            Insert();
        end;
    end;
    //--TWN1.00.122187.QX

}

