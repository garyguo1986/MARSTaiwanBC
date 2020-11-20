page 1044860 "Taiwan Front Office RC"
{
    // +--------------------------------------------------------------+
    // | @ 2014 ff. Begusch Software Systeme                          |
    // +--------------------------------------------------------------+
    // | PURPOSE: BSS.tire                                            |
    // +--------------------------------------------------------------+
    // 
    // VERSION  ID        WHO    DATE        DESCRIPTION
    // 071000   IT_20087  MH     2013-12-10  INITIAL RELEASE
    // 071000   IT_20083  SG     2013-12-10  added different filters to the cues on the Role Center Page
    // 071101   IT_20129  MH     2014-05-15  Added Shortcut to create a new shopping basket
    // 071102   IT_20157  MH     2014-06-03  Added BSS Sales Statistic Chart Part
    // 071102   IT_20169  SG     2014-06-06  renamed to "BSS Front Office RC"
    // 071102   IT_20175  SG     2014-06-11  added page "BSS My Items"
    // 071102   IT_20177  SG     2014-06-12  added action "Goods Receipt"
    // 071102   IT_20182  AK     2014-07-01  Remove Sales Return Orders
    // 071104   IT_20237  SG     2014-10-06  added factbox "Login Info Factbox" with "Visible" = "FALSE"
    // 080300   IT_20638  MH     2015-07-29  enhance profile configurations
    // 081000   IT_20772  CM     2015-10-20  changed Matchcode Search call from page to codeunit
    // 081000   IT_20797  AK     2015-10-28  Tooltips inserted for ActionContainer HomeItems
    // 081000   IT_20804  AK     2015-11-09  add "Sales Order List" and "Bay Booking Reservation Lines"
    // 081300   IT_20987  CM     2016-05-06  Added action "Sales History" , "Service Due Entries" & "Service Search"
    //                                       Added following reports: "Customer Frequency" , "Daily Sales Register" , "Service - Sales Statistics",
    //                                       "Product & Services Mix" , "Product Mix" , "Tyre Brand Mix" , "Daily Purchase Register" , "Stock Detail",
    //                                       "Services Done By Fitter" , "Day-End Closing Report"
    //                                       Added "My Company Messages" and set "MyNotes" to standard hidden
    // 083000   IT_21125  CM     2016-09-12  Added following lists to the "HomeItems" actions:
    //                                         Shopping Basket List, Sales Quotes, Sales Return Order List
    //                                         Purchase Quotes, Purchase Order List, Purchase Invoices,
    //                                         Purchase Credit Memos, Purchase Return Order List,
    //                                         Goods Receipt List, Vendor List
    // 083000   IT_21195  AK     2017-02-14  call of sales history page with new codeunit because of preselection functionality
    // 083000   IT_21141  CM     2016-02-20  Added action "Service Planer"
    //                                       Removed Bay Booking Reservation Lines from HomeItems
    // 083000   IT_21222 1CF     2017-02-21  Added Retread List action to the "HomeItems"
    //                                       Added "New Retread Documents" actiongroup with "Casing Retread Order" action
    // 083000   IT_21345  SS     2017-04-25  caption correction GER:Erstelle Statistiksdaten to Erstelle Statistikdaten
    // 084000   IT_21349  SS     2017-05-16  added report Report Cash Reg. Statement Short
    // 084000   IT_21355  1CF    2017-06-20  Changed action captions:
    //                                         from "Casing Retread Order" to "Retread Order"
    //                                         from "Casing Retread Orders" to "Retread Orders"
    // 084010   IT_21589  AB     2017-10-05  Changed translation of "Service due entries" action
    // 084010   IT_21604  SS     2017-10-19  New part "My Seesion Info" for the front office role center
    // 090000   IT_21654  RA     2017-12-01  PA044330 Added Order Screen action
    // 090000   IT_21692  SA     2018-04-30  PA045229 added the action "Support Information" to ActionGroup "Support"
    //                                                                             RunPageMode of Support Information action has been changed to Edit
    // 090000   IT_21712  MH     2018-06-07  Page Simplifications
    // 091000   TFS_11330 GS     2018-12-05  Added the Action "Statistics Analysis" to ActionGroup Report
    // 091000   TFS_12632 SU     2019-02-04  PA048219 Filter updated for action "Completely Shipped Not Invoiced"
    // 091000   TFS_21926 SA     2019-02-05  PA048217 Added MyBCS Cockpit action.
    // 091000   TFS_22919 PA    2019-02-06  Fitter renamed as Mechanic
    // UPGBC140 2019-04-24 1CF_APR Upgrade to NAVBC140
    // Removed obsolete Page 9175
    // FEATURE ID  DATE      WHO  ID     DESCRIPTION
    // AP.0025918  29.04.19  JH   25920  Added VICO Portal action.
    // AP.0025918  09.05.19  JP   25920  Changed the Vico Portal Action Name.
    // AP.0037886  22.10.19  GV   38194  Upgrade to NAVBC140 CU05
    // AP.0042035  20.02.20  PW   42092  Moved action : "Service Planner" to WAS extension
    // AP.0041844  01.04.20  SY   43832  Moved Bosch code and actions to extension "Fastfit BOSCH Core".    
    // AP.0044854  23.06.20  SU   45015  Added headlines part page "RC Headlines FF Front Office"
    // AP.0047539  16.07.20  DS   47623  FF Front Office Role Center action groups re-arranging

    Caption = 'Front Office Manager', Comment = '{Dependency=Match,"ProfileDescription_FRONTOFFICEMANAGER"}';
    PageType = RoleCenter;
    RefreshOnActivate = false;

    layout
    {
        area(rolecenter)
        {
            part(Headline; "RC Headlines FF Front Office")
            {
            }
            part(Control1901851508; "BSS Front Office Activit.")
            {
            }
            part(Control1; "BSS Sales Statistic Chart")
            {
            }
            part(Control1000000000; "Login Info Factbox")
            {
            }
            part(Control1000000023; "My Company Messages")
            {
            }
        }
    }

    actions
    {
        area(reporting)
        {
            group(Sales)
            {
                Caption = 'Sales';
                action("Customer - &Order Summary")
                {
                    Caption = 'Customer - &Order Summary';

                    RunObject = Report "Customer - Order Summary";
                }
                action("Customer - &Top 10 List")
                {
                    Caption = 'Customer - &Top 10 List';

                    RunObject = Report "Customer - Top 10 List";
                }
                action("Customer/&Item Sales")
                {
                    Caption = 'Customer/&Item Sales';

                    RunObject = Report "Customer/Item Sales";
                }
                action("Customer Frequency")
                {
                    Caption = 'Customer Frequency';

                    RunObject = Report "Customer Value Analysis - List";
                }
                separator(Action17)
                {
                }
                action("Salesperson - Sales &Statistics")
                {
                    Caption = 'Salesperson - Sales &Statistics';

                    RunObject = Report "Salesperson - Sales Statistics";
                }
                action("Price &List")
                {
                    Caption = 'Price &List';

                    RunObject = Report "Price List";
                }
                separator(Action22)
                {
                }
                action("Inventory - Sales &Back Orders")
                {
                    Caption = 'Inventory - Sales &Back Orders';
                    RunObject = Report "Inventory - Sales Back Orders";
                }
                action("Service - Sales Statistics")
                {
                    Caption = 'Service - Sales Statistics';

                    RunObject = Report "Service - Sales Statistics";
                }
                action("Product & Services Mix")
                {
                    Caption = 'Product & Services Mix';

                    RunObject = Report "Product & Services Mix";
                }
                action("Product Mix")
                {
                    Caption = 'Product Mix';
                    RunObject = Report "Product Mix";
                }
                action("Tyre Brand Mix")
                {
                    Caption = 'Tyre Brand Mix';

                    RunObject = Report "Tyre Brand Mix";
                }
            }
            group(Purchase)
            {
                Caption = 'Purchase';
                action("Vendor - Order Summary")
                {
                    Caption = 'Vendor - Order Summary';

                    RunObject = Report "Vendor - Order Summary";
                }
                action("Vendor - Top 10 List")
                {
                    Caption = 'Vendor - Top 10 List';

                    RunObject = Report "Vendor - Top 10 List";
                }
                action("Vendor/Item Purchases")
                {
                    Caption = 'Vendor/Item Purchases';

                    RunObject = Report "Vendor/Item Purchases";
                }
            }
            group(Item)
            {
                Caption = 'Item';
                action("Inventory - Customer Sales")
                {
                    Caption = 'Inventory - Customer Sales';

                    RunObject = Report "Inventory - Customer Sales";
                }
                action("Inventory - Top 10 List")
                {
                    Caption = 'Inventory - Top 10 List';

                    RunObject = Report "Inventory - Top 10 List";
                }
                action("Inventory - Vendor Purchases")
                {
                    Caption = 'Inventory - Vendor Purchases';

                    RunObject = Report "Inventory - Vendor Purchases";
                }
                action("Stock Detail")
                {
                    Caption = 'Stock Detail';

                    RunObject = Report "Stock Detail Report";
                }
            }
            group("Day End")
            {
                Caption = 'Day End';
                action("Cash Register Statement")
                {
                    Caption = 'Cash Register Statement';
                    Image = ContractPayment;
                    //The property 'PromotedIsBig' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedIsBig = true;
                    RunObject = Page "Cash Reg. Statement";
                    RunPageMode = Create;
                }
                action("Build Statistic Data")
                {
                    Caption = 'Build Statistic Data';
                    Image = EntryStatistics;
                    //The property 'PromotedIsBig' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedIsBig = true;
                    RunObject = Report "Fill Statistics";
                }
                action("Services Done By Mechanic")
                {
                    Caption = 'Services Done By Mechanic';

                    RunObject = Report "Services Done By Fitter";
                }
                action("Day-End Closing Report")
                {
                    Caption = 'Day-End Closing Report';

                    RunObject = Report "Day-End Closing";
                }
                action("Daily Sales Register")
                {
                    Caption = 'Daily Sales Register';

                    RunObject = Report "Daily Sales Register";
                }
                action("Daily Purchase Register")
                {
                    Caption = 'Daily Purchase Register';

                    RunObject = Report "Daily Purchase Register";
                }
                action("<Report Cash Reg. Statement Short>")
                {
                    Caption = 'Cash Reg. Statement short';

                    RunObject = Report "Cash Reg. Statement Short";
                }
            }
            group("Reporting Engine")
            {
                Caption = 'Reporting Engine';
                action("Statistics Analysis")
                {
                    Caption = 'Statistics Analysis';
                    Image = AnalysisView;
                    RunObject = Page "Statistic Analysis Templ. List";
                }
            }
        }
        area(embedding)
        {
            ToolTip = 'The Front Office role is intended to support users which are in direct contact with the customer';
            action("Shopping Baskets")
            {
                Caption = 'Shopping Baskets';
                RunObject = Page "Shopping Basket List";
            }
            action("Sales Quotes")
            {
                Caption = 'Sales Quotes';
                RunObject = Page "Sales Quotes";
            }
            action("Sales Orders")
            {
                Caption = 'Sales Orders';
                RunObject = Page "Sales Order List";
            }
            action("Shipped Not Invoiced")
            {
                Caption = 'Shipped Not Invoiced';
                RunObject = Page "Sales Order List";
                RunPageView = WHERE("Shipped Not Invoiced" = CONST(true));
            }
            action("Completely Shipped Not Invoiced")
            {
                Caption = 'Completely Shipped Not Invoiced';
                RunObject = Page "Sales Order List";
                RunPageView = WHERE("Completely Shipped" = CONST(true),
                                    "Shipped Not Invoiced" = CONST(true));
            }
            action("Blanket Sales Orders")
            {
                Caption = 'Blanket Sales Orders';
                RunObject = Page "Blanket Sales Orders";
            }
            action("Sales Invoices")
            {
                Caption = 'Sales Invoices';
                Image = Invoice;
                RunObject = Page "Sales Invoice List";
            }
            action("Sales Credit Memos")
            {
                Caption = 'Sales Credit Memos';
                RunObject = Page "Sales Credit Memos";
            }
            action("Sales Return Orders")
            {
                Caption = 'Sales Return Orders';
                RunObject = Page "Sales Return Order List";
            }
            action("Purchase Quotes")
            {
                Caption = 'Purchase Quotes';
                RunObject = Page "Purchase Quotes";
            }
            action("Purchase Orders")
            {
                Caption = 'Purchase Orders';
                RunObject = Page "Purchase Order List";
            }
            action("Purchase Invoices")
            {
                Caption = 'Purchase Invoices';
                RunObject = Page "Purchase Invoices";
            }
            action("Purchase Credit Memos")
            {
                Caption = 'Purchase Credit Memos';
                RunObject = Page "Purchase Credit Memos";
            }
            action("Purchase Return Orders")
            {
                Caption = 'Purchase Return Orders';
                RunObject = Page "Purchase Return Order List";
            }
            action("Goods Receipts")
            {
                Caption = 'Goods Receipts';
                RunObject = Page "Goods Receipt List";
            }
            action("Retread Orders")
            {
                Caption = 'Retread List';
                RunObject = Page "Retread List";
            }
            action(Items)
            {
                Caption = 'Items';
                Image = Item;
                RunObject = Page "Item List";
            }
            action(Customers)
            {
                Caption = 'Customers';
                Image = Customer;
                RunObject = Page "Customer List";
            }
            action(Vendors)
            {
                Caption = 'Vendors';
                RunObject = Page "Vendor List";
            }
            action("Order Screen for Stock Order")
            {
                Caption = 'Order Screen for Stock Order';
                RunObject = Page "Order Screen for Stock Order";
            }
        }
        area(sections)
        {
            group("Master Data")
            {
                Caption = 'Master Data';
                Image = Purchasing;
                ToolTip = 'View the most important master data.';
                action(Contacts)
                {
                    Caption = 'Contacts';
                    RunObject = Page "Contact List";
                }
                action(Action1000000060)
                {
                    Caption = 'Customers';
                    RunObject = Page "Customer List";
                }
                action(Vehicles)
                {
                    Caption = 'Vehicles';
                    RunObject = Page "Vehicle List";
                }
                action(Services)
                {
                    Caption = 'Services';
                    RunObject = Page "Fastfit Service List";
                }
                action(Action1000000062)
                {
                    Caption = 'Items';
                    RunObject = Page "Item List";
                }
                action(Action1000000061)
                {
                    Caption = 'Vendors';
                    RunObject = Page "Vendor List";
                }
                action(Manufacturers)
                {
                    Caption = 'Manufacturers';
                    RunObject = Page Manufacturers;
                }
            }
            group("Cash Register")
            {
                Caption = 'Cash Register';
                Image = Receivables;
                ToolTip = 'View posted and unposted cash register documents.';
                action("Cash Register Customers")
                {
                    Caption = 'Cash Register Customers';
                    RunObject = Page "Cash Register Customer List";
                }
                action("Cash Register Vendors")
                {
                    Caption = 'Cash Register Vendors';
                    RunObject = Page "Cash Register Vendor List";
                }
                action("Cash Register Transactions")
                {
                    Caption = 'Cash Register Transactions';
                    RunObject = Page "Cash Reg. Transactions List";
                }
                action("Cash Register Statements")
                {
                    Caption = 'Cash Register Statements';
                    RunObject = Page "Cash Reg. Statement List";
                }
                action("Posted Cash Reg. Customers")
                {
                    Caption = 'Posted Cash Reg. Customers';
                    RunObject = Page "Posted Cash Reg. Customer List";
                }
                action("Posted Cash Reg. Vendors")
                {
                    Caption = 'Posted Cash Reg. Vendors';
                    RunObject = Page "Posted Cash Reg. Vendor List";
                }
                action("Posted Cash Reg. Trans.")
                {
                    Caption = 'Posted Cash Reg. Trans.';
                    RunObject = Page "Post. Cash Reg. Trans. List";
                }
                action("Posted Cash Reg. Statements")
                {
                    Caption = 'Posted Cash Reg. Statements';
                    RunObject = Page "Post. Cash Reg. Statement List";
                }
            }
            group("Posted Documents")
            {
                Caption = 'Posted Documents';
                Image = FiledPosted;
                ToolTip = 'View history for sales, shipments, and inventory.';
                action("Posted Sales Shipments")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Posted Sales Shipments';
                    Image = PostedShipment;
                    RunObject = Page "Posted Sales Shipments";
                    ToolTip = 'Open the list of posted sales shipments.';
                }
                action("Posted Sales Invoices")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Posted Sales Invoices';
                    Image = PostedOrder;
                    RunObject = Page "Posted Sales Invoices";
                    ToolTip = 'Open the list of posted sales invoices.';
                }
                action("Posted Return Receipts")
                {
                    ApplicationArea = Advanced;
                    Caption = 'Posted Return Receipts';
                    Image = PostedReturnReceipt;
                    RunObject = Page "Posted Return Receipts";
                    ToolTip = 'Open the list of posted return receipts.';
                }
                action("Posted Sales Credit Memos")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Posted Sales Credit Memos';
                    Image = PostedOrder;
                    RunObject = Page "Posted Sales Credit Memos";
                    ToolTip = 'Open the list of posted sales credit memos.';
                }
                action("Posted Sales Return Orders")
                {
                    ApplicationArea = SalesReturnOrder;
                    Caption = 'Posted Sales Return Orders';
                    Image = PostedOrder;
                    RunObject = Page "Posted Return Receipts";
                    ToolTip = 'Open the list of posted sales return orders.';
                }
                action("Posted Purchase Receipts")
                {
                    ApplicationArea = Advanced;
                    Caption = 'Posted Purchase Receipts';
                    RunObject = Page "Posted Purchase Receipts";
                    ToolTip = 'Open the list of posted purchase receipts.';
                }
                action("Posted Purchase Invoices")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Posted Purchase Invoices';
                    RunObject = Page "Posted Purchase Invoices";
                    ToolTip = 'Open the list of posted purchase invoices.';
                }
                action("Posted Transfer Shipments")
                {
                    ApplicationArea = Location;
                    Caption = 'Posted Transfer Shipments';
                    RunObject = Page "Posted Transfer Shipments";
                    ToolTip = 'Open the list of posted transfer shipments.';
                }
                action("Posted Transfer Receipts")
                {
                    ApplicationArea = Location;
                    Caption = 'Posted Transfer Receipts';
                    RunObject = Page "Posted Transfer Receipts";
                    ToolTip = 'Open the list of posted transfer receipts.';
                }
            }
            group(Taiwan)
            {
                action("Bank Code")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Bank Code';
                    RunObject = page "Bank Code";
                    ToolTip = 'Bank Code';
                }
                action("Notification List Edit")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Notification List Edit';
                    RunObject = page "Notification List Edit";
                    ToolTip = 'Notification List Edit';
                }
                action("Notification Card")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Notification Card';
                    RunObject = page "Notification Card";
                    ToolTip = 'Notification Card';
                }
            }
        }
        area(processing)
        {
            group("Customer Reception")
            {
                Caption = 'Customer Reception';
                action("Contact Search")
                {
                    Caption = 'Contact Search';
                    Image = ContactFilter;
                    RunObject = Codeunit "Contact Search";
                }
                action("Sales History")
                {
                    Caption = 'Sales History';
                    Image = History;
                    RunObject = Codeunit "Sales History";
                }
                action("Service Due Entries")
                {
                    Caption = 'Service Due Entries';
                    Image = ServiceHours;
                    RunObject = Page "Service Due Entry";
                    RunPageMode = View;
                }
                action("Matchcode Search")
                {
                    Caption = 'Matchcode Search';
                    Image = ShowList;
                    RunObject = Codeunit "Matchcode Functions";
                }
                action("Service Search")
                {
                    Caption = 'Service Search';
                    Image = ServicePriceAdjustment;
                    RunObject = Codeunit "Service Selection Functions";
                }
            }
            group("New Sales Documents")
            {
                Caption = 'New Sales Documents';
                action("Page Shopping Basket")
                {
                    Caption = 'Shopping Basket';
                    Image = "Order";
                    RunObject = Page "Shopping Basket";
                    RunPageMode = Create;
                    ShortCutKey = 'Ctrl+B';
                }
                action("Sales &Quote")
                {
                    Caption = 'Sales &Quote';
                    Image = Quote;
                    Promoted = false;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    RunObject = Page "Sales Quote";
                    RunPageMode = Create;
                }
                action("Sales &Order")
                {
                    Caption = 'Sales &Order';
                    Image = Document;
                    Promoted = false;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    RunObject = Page "Sales Order";
                    RunPageMode = Create;
                }
                action("Sales &Invoice")
                {
                    Caption = 'Sales &Invoice';
                    Image = Invoice;
                    Promoted = false;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    RunObject = Page "Sales Invoice";
                    RunPageMode = Create;
                    Visible = false;
                }
                action("Sales &Credit Memo")
                {
                    Caption = 'Sales &Credit Memo';
                    Image = CreditMemo;
                    Promoted = false;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    RunObject = Page "Sales Credit Memo";
                    RunPageMode = Create;
                    Visible = false;
                }
                action("Sales &Return Order")
                {
                    Caption = 'Sales &Return Order';
                    Image = ReturnOrder;
                    Promoted = false;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    RunObject = Page "Sales Return Order";
                    RunPageMode = Create;
                }
            }
            group("New Retread Documents")
            {
                Caption = 'New Retread Documents';
                Visible = false;
                action("Retread Order")
                {
                    Caption = 'Retread Order';
                    Image = Document;
                    Promoted = false;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    RunObject = Page "Retread Order";
                    RunPageMode = Create;
                }
            }
            group("New Purchase Documents")
            {
                Caption = 'New Purchase Documents';
                action("Purchase Quote")
                {
                    Caption = 'Purchase Quote';
                    Image = Quote;
                    RunObject = Page "Purchase Quote";
                    RunPageMode = Create;
                    Visible = false;
                }
                action("Purchase Order")
                {
                    Caption = 'Purchase Order';
                    Image = Document;
                    RunObject = Page "Purchase Order";
                    RunPageMode = Create;
                }
                action("Purchase Invoice")
                {
                    Caption = 'Purchase Invoice';
                    Image = Invoice;
                    RunObject = Page "Purchase Invoice";
                    RunPageMode = Create;
                }
                action("Purchase Credit Memo")
                {
                    Caption = 'Purchase Credit Memo';
                    Image = CreditMemo;
                    RunObject = Page "Purchase Credit Memo";
                    RunPageMode = Create;
                    Visible = false;
                }
                action("Purchase Return Order")
                {
                    Caption = 'Purchase Return Order';
                    Image = ReturnOrder;
                    RunObject = Page "Purchase Return Order";
                    RunPageMode = Create;
                    Visible = false;
                }
                action("Goods Receipt")
                {
                    Caption = 'Goods Receipt';
                    Image = Receipt;
                    RunObject = Page "Goods Receipt";
                    RunPageMode = Create;
                }
            }
            group("New Master Data")
            {
                Caption = 'New Master Data';
                action(Customer)
                {
                    Caption = 'Customer';
                    Image = Customer;
                    RunObject = Page "Customer Card";
                    RunPageMode = Create;
                }
                action(Vendor)
                {
                    Caption = 'Vendor';
                    Image = Vendor;
                    RunObject = Page "Vendor Card";
                    RunPageMode = Create;
                }
            }
            group(Support)
            {
                Caption = 'Support';
                action("Support Information")
                {
                    Caption = 'Support Information';
                    Description = 'IT_21692';
                    Image = DistributionGroup;
                    RunObject = Page "Fastfit Setup - Support Info";
                    RunPageMode = Edit;
                    Visible = false;
                }
            }
        }
    }
}

