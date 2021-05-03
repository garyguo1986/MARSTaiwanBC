pageextension 1073887 "Sales Prices Ext" extends "Sales Prices"
{
    // +--------------------------------------------------------------+
    // | @ 2017 incadea Taiwan Limited                                |
    // +--------------------------------------------------------------+
    // | PURPOSE: MARS_TWN                                            |
    // +--------------------------------------------------------------+

    // VERSION       WHO    DATE        DESCRIPTION
    // RGS_TWN-334   NN     2019-04-19  Merge R3 Customization    
    layout
    {
        addafter("Date/Time created")
        {
            field("Base SC Price Group"; "Base SC Price Group")
            {
            }
        }
    }
    trigger OnNewRecord(BelowxRec: Boolean)
    var
        recSaleSetupL: Record "Sales & Receivables Setup";
    begin
        //Start RGS_TWN-344
        CLEAR(recSaleSetupL);
        recSaleSetupL.GET;
        "Sales Type" := recSaleSetupL."Sales Type";
        "Price Includes VAT" := recSaleSetupL."Price Includes VAT";
        "VAT Bus. Posting Gr. (Price)" := recSaleSetupL."VAT Bus. Posting Gr. (Price)";
        //Stop RGS_TWN-344
    end;
}
