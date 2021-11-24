pageextension 1044878 "Phys. Inventory Journal Ext" extends "Phys. Inventory Journal"
{
    actions
    {
        modify(Print)
        {
            Visible = false;
        }

        addafter(Print)
        {
            action(PrintTWN)
            {
                ApplicationArea = Basic, Suite;
                Caption = '&Print';
                Ellipsis = true;
                Image = Print;
                Promoted = true;
                PromotedCategory = Category4;
                Scope = Repeater;
                //ToolTip = 'Prepare to print the document. A report request window for the document opens where you can specify what to include on the print-out.';

                trigger OnAction()
                begin
                    ItemJournalBatch.SetRange("Journal Template Name", "Journal Template Name");
                    ItemJournalBatch.SetRange(Name, "Journal Batch Name");
                    PhysInventoryList.SetTableView(ItemJournalBatch);
                    PhysInventoryList.SetSorting(MARSSorting);
                    PhysInventoryList.RunModal;
                    Clear(PhysInventoryList);
                end;
            }
        }
    }

    var
        ItemJournalBatch: Record "Item Journal Batch";
        PhysInventoryList: Report "TWN Phys. Inventory List";
        MARSSorting: Option Sorting1,Sorting2,Sorting3,Sorting4;
}
