pageextension 55300 "Bank Acc. Card_GA" extends "Bank Account Card"
{
    layout
    {
        addfirst(factboxes)
        {
            part("Attached Documents_GA"; "Document Attachment Factbox")
            {
                ApplicationArea = All;
                Caption = 'Attachments';
                SubPageLink = "Table ID" = const(270), "No." = field("No.");
            }
        }
    }
}
