report 1044862 "Customer Booking Ratio"
{
    // +--------------------------------------------------------------+
    // | @ 2017 incadea Taiwan Limited                                |
    // +--------------------------------------------------------------+
    // | PURPOSE: MARS_TWN                                            |
    // |                                                              |
    // | REMARK :                                                     |
    // +--------------------------------------------------------------+
    // 
    // VERSION       ID            WHO    DATE        DESCRIPTION
    // RGS_TWN-555                 AH     2017-04-22  INITIAL RELEASE
    DefaultLayout = RDLC;
    RDLCLayout = './Report/CustomerBookingRatio.rdlc';

    Caption = 'Customer Booking Ratio';

    dataset
    {
        dataitem("Sales Invoice Header"; "Sales Invoice Header")
        {
            RequestFilterFields = "Posting Date";

            trigger OnAfterGetRecord()
            begin
                CALCFIELDS("Amount Including VAT");
                InvoiceCount := InvoiceCount + 1;
                UpdateTemp;
            end;
        }
        dataitem(Dealer; Integer)
        {
            DataItemTableView = SORTING(Number)
                                ORDER(Ascending);
            column(USERID; USERID)
            {
            }
            column(CurrReport_PAGENO; CurrReport.PAGENO)
            {
            }
            column(FORMAT_TODAY_0___Year4___Month_2___Day_2___; FORMAT(TODAY, 0, '<Year4>/<Month,2>/<Day,2>'))
            {
            }
            column(COMPANYNAME; COMPANYNAME)
            {
            }
            column(DealerTemp__No__; DealerTemp."No.")
            {
            }
            column(DealerTemp__Maximum_Order_Quantity_; DealerTemp."Maximum Order Quantity")
            {
                DecimalPlaces = 0 : 0;
            }
            column(DealerTemp__Minimum_Order_Quantity_; DealerTemp."Minimum Order Quantity")
            {
                DecimalPlaces = 0 : 0;
            }
            column(DealerTemp__Maximum_Order_Quantity__DealerTemp__Minimum_Order_Quantity__100; DealerTemp."Maximum Order Quantity" / DealerTemp."Minimum Order Quantity" * 100)
            {
            }
            column(DealerTemp__Reorder_Quantity_; DealerTemp."Reorder Quantity")
            {
                DecimalPlaces = 0 : 2;
            }
            column(DealerTemp__Maximum_Inventory_; DealerTemp."Maximum Inventory")
            {
                DecimalPlaces = 0 : 2;
            }
            column(ServiceAVG; ServiceAVG)
            {
            }
            column(BayResAVG; BayResAVG)
            {
                DecimalPlaces = 0 : 2;
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Percentage_of_No__of_Reservation_vs__No__of_Posted_Invoice_with_ServiceCaption; Percentage_of_No__of_Reservation_vs__No__of_Posted_Invoice_with_ServiceCaptionLbl)
            {
            }
            column(Customer_Booking_RatioCaption; Customer_Booking_RatioCaptionLbl)
            {
            }
            column(No__of_Posted_Invoice_with_ServiceCaption; No__of_Posted_Invoice_with_ServiceCaptionLbl)
            {
            }
            column(No__of_ReservationsCaption; No__of_ReservationsCaptionLbl)
            {
            }
            column(Dealer_CodeCaption; Dealer_CodeCaptionLbl)
            {
            }
            column(Value_of_all_Posted_Invoice_with_ServicesCaption; Value_of_all_Posted_Invoice_with_ServicesCaptionLbl)
            {
            }
            column(Value_of_Invoice_with_ReservationCaption; Value_of_Invoice_with_ReservationCaptionLbl)
            {
            }
            column(Average_Value_of_InvoiceCaption; Average_Value_of_InvoiceCaptionLbl)
            {
            }
            column(Average_Value_of_Invoice_with_ReservationCaption; Average_Value_of_Invoice_with_ReservationCaptionLbl)
            {
            }
            column(EmptyStringCaption; EmptyStringCaptionLbl)
            {
            }
            column(Dealer_Number; Number)
            {
            }

            trigger OnAfterGetRecord()
            begin
                DealerTemp.NEXT;
                IF (DealerTemp."Minimum Order Quantity" <> 0) THEN BEGIN
                    ServiceAVG := DealerTemp."Reorder Quantity" / DealerTemp."Minimum Order Quantity";
                END ELSE BEGIN
                    CLEAR(ServiceAVG);
                END;
                IF (DealerTemp."Maximum Order Quantity" <> 0) THEN BEGIN
                    BayResAVG := DealerTemp."Maximum Inventory" / DealerTemp."Maximum Order Quantity";
                END ELSE BEGIN
                    CLEAR(BayResAVG);
                END;
            end;

            trigger OnPreDataItem()
            var
                Index: Integer;
            begin
                CLEAR(DealerTemp);
                Index := DealerTemp.COUNT;
                SETFILTER(Number, '%1..%2', 1, Index);
                CLEAR(DealerTemp);
            end;
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

    labels
    {
    }

    var
        DealerTemp: Record Item temporary;
        PostedSalesInvoiceTemp: Record "Sales Invoice Header" temporary;
        InvoiceCount: Decimal;
        ServiceAVG: Decimal;
        BayResAVG: Decimal;
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        Percentage_of_No__of_Reservation_vs__No__of_Posted_Invoice_with_ServiceCaptionLbl: Label 'Percentage of No. of Reservation vs. No. of Posted Invoice with Service';
        Customer_Booking_RatioCaptionLbl: Label 'Customer Booking Ratio';
        No__of_Posted_Invoice_with_ServiceCaptionLbl: Label 'No. of Posted Invoice with Service';
        No__of_ReservationsCaptionLbl: Label 'No. of Reservations';
        Dealer_CodeCaptionLbl: Label 'Dealer Code';
        Value_of_all_Posted_Invoice_with_ServicesCaptionLbl: Label 'Value of all Posted Invoice with Services';
        Value_of_Invoice_with_ReservationCaptionLbl: Label 'Value of Invoice with Reservation';
        Average_Value_of_InvoiceCaptionLbl: Label 'Average Value of Invoice';
        Average_Value_of_Invoice_with_ReservationCaptionLbl: Label 'Average Value of Invoice with Reservation';
        EmptyStringCaptionLbl: Label '%';

    local procedure ClearTemp()
    begin
        CLEAR(InvoiceCount);
        CLEAR(DealerTemp);
        CLEAR(PostedSalesInvoiceTemp);
        DealerTemp.DELETEALL;
        PostedSalesInvoiceTemp.DELETEALL;
    end;

    local procedure UpdateTemp()
    var
        SalesInvLine: Record "Sales Invoice Line";
    begin
        CLEAR(PostedSalesInvoiceTemp);
        PostedSalesInvoiceTemp.COPY("Sales Invoice Header");
        //++TWN_R20_T01
        //++TWN1.00.122187.QX
        // "Bay Reservation No." was removed
        // PostedSalesInvoiceTemp.CALCFIELDS("Bay Reservation No.");
        //--TWN1.00.122187.QX
        //--TWN_R20_T01
        CLEAR(SalesInvLine);
        SalesInvLine.SETFILTER("Document No.", '%1', "Sales Invoice Header"."No.");
        SalesInvLine.SETFILTER(Type, '%1', SalesInvLine.Type::Resource);
        SalesInvLine.SETFILTER(Quantity, '<>%1', 0);
        IF SalesInvLine.FINDFIRST THEN BEGIN
            PostedSalesInvoiceTemp."PDF Send" := TRUE;
        END ELSE BEGIN
            PostedSalesInvoiceTemp."PDF Send" := FALSE;
        END;
        IF PostedSalesInvoiceTemp."PDF Send" THEN BEGIN
            //++TWN1.00.122187.QX
            // "Bay Reservation No." was removed
            // UpdateDealer(PostedSalesInvoiceTemp."Shortcut Dimension 2 Code", PostedSalesInvoiceTemp."PDF Send",
            //              (PostedSalesInvoiceTemp."Bay Reservation No." <> ''), GetAmount(PostedSalesInvoiceTemp."No."));
            UpdateDealer(PostedSalesInvoiceTemp."Shortcut Dimension 2 Code", PostedSalesInvoiceTemp."PDF Send",
                            false, GetAmount(PostedSalesInvoiceTemp."No."));
            //--TWN1.00.122187.QX
        END;
        PostedSalesInvoiceTemp.INSERT;
    end;

    local procedure UpdateDealer(Dealer: Code[10]; IsService: Boolean; IsBayRes: Boolean; Amount: Decimal)
    begin
        CLEAR(DealerTemp);
        IF (Dealer = '') THEN Dealer := '<Blank>';
        IF (NOT DealerTemp.GET(Dealer)) THEN BEGIN
            CLEAR(DealerTemp);
            DealerTemp."No." := Dealer;
            IF IsService THEN BEGIN
                DealerTemp."Minimum Order Quantity" := 1;
                DealerTemp."Reorder Quantity" := Amount;
                IF IsBayRes THEN BEGIN
                    DealerTemp."Maximum Order Quantity" := 1;
                    DealerTemp."Maximum Inventory" := Amount;
                END;
            END;
            DealerTemp.INSERT;
        END ELSE BEGIN
            IF IsService THEN BEGIN
                DealerTemp."Minimum Order Quantity" := DealerTemp."Minimum Order Quantity" + 1;
                DealerTemp."Reorder Quantity" := DealerTemp."Reorder Quantity" + Amount;
                IF IsBayRes THEN BEGIN
                    DealerTemp."Maximum Order Quantity" := DealerTemp."Maximum Order Quantity" + 1;
                    DealerTemp."Maximum Inventory" := DealerTemp."Maximum Inventory" + Amount;
                END;
            END;
            DealerTemp.MODIFY;
        END;
    end;

    [Scope('OnPrem')]
    procedure GetAmount(InvoiceNo: Code[20]): Decimal
    var
        CustLedger: Record "Cust. Ledger Entry";
        TotalAmount: Decimal;
    begin
        CLEAR(CustLedger);
        CLEAR(TotalAmount);
        CustLedger.SETFILTER("Document Type", '%1', CustLedger."Document Type"::Invoice);
        CustLedger.SETFILTER("Document No.", '%1', InvoiceNo);
        IF CustLedger.FINDSET THEN BEGIN
            REPEAT
                CustLedger.CALCFIELDS("Original Amt. (LCY)");
                TotalAmount := TotalAmount + CustLedger."Original Amt. (LCY)";
            UNTIL (CustLedger.NEXT = 0);
        END;
        EXIT(CustLedger."Original Amt. (LCY)");
    end;
}

