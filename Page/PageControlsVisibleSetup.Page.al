page 1044883 "Page Controls Visible Setup"
{
    // +----------------------------------------------+
    // | Copyright (c) incadea China                  |
    // +----------------------------------------------+
    // TFS          ID             WHO    DATE        DESCRIPTION
    // 121390     MARS_TWN_7545  GG     2020-02-27  New object to control pages    
    Caption = 'Page Controls Visible Setup';
    PageType = Card;
    SourceTable = "Page Controls Visible Setup";

    layout
    {
        area(content)
        {
            group(General)
            {
                field(P1044443_FieldDescription; Rec.P1044443_FieldDescription)
                {
                    ApplicationArea = All;
                }
                field(P1044443_FieldNo; Rec.P1044443_FieldNo)
                {
                    ApplicationArea = All;
                }
            }
        }
    }
    trigger OnOpenPage()
    begin
        if not Rec.Get() then begin
            Init();
            Insert();
        end;
    end;
}
