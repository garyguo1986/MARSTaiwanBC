tableextension 1044876 tableextension1044876 extends Customer
{
    // +--------------------------------------------------------------+
    // | ?2005 ff. Begusch Software Systeme                          |
    // #3..79
    //                                       1017641 "Limited Res. Selection"?
    // #81..172
    // 
    // +--------------------------------------------------------------+
    // | @ 2017 incadea Taiwan Limited                                |
    // +--------------------------------------------------------------+
    // | PURPOSE: MARS_TWN                                            |
    // |                                                              |
    // | REMARK :                                                     |
    // +--------------------------------------------------------------+
    // 
    // VERSION       ID          WHO    DATE        DESCRIPTION
    // RGS_TWN-342               AH     2017-05-19  Add field Bill-to Company Name (1044863)
    // RGS_TWN-342               AH     2017-05-19  Clear "Bill-to Company Name" field when "Central Maintenance" is true
    // TWN.01.07     RGS_TWN-708 AH     2017-09-06  changed calcformulas of fields
    //                                              No. of Quotes,No. of Blanket Orders,No. of Orders,No. of Invoices,No. of Return Orders,
    //                                              No. of Credit Memos,No. of Pstd. Shipments,No. of Pstd. Invoices,No. of Pstd. Return Receipts,
    //                                              No. of Pstd. Credit Memos,Bill-To No. of Quotes,Bill-To No. of Blanket Orders,Bill-To No. of Orders,
    //                                              Bill-To No. of Invoices,Bill-To No. of Return Orders,Bill-To No. of Credit Memos,Bill-To No. of Pstd. Shipments,
    //                                              Bill-To No. of Pstd. Invoices,Bill-To No. of Pstd. Return R. (HF21331)
    fields
    {
        field(1044863; "Bill-to Company Name"; Text[50])
        {
            Caption = 'Bill-to Company Name';
            Description = 'RGS_TWN-342';
        }
    }
}

