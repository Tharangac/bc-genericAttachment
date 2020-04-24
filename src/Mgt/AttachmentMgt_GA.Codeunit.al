codeunit 55300 "Attachment Mgt._GA"
{
    [EventSubscriber(ObjectType::Page, Page::"Document Attachment Factbox", 'OnBeforeDrillDown', '', false, false)]
    local procedure OnBeforeDrillDownAttachmentFactBox(DocumentAttachment: Record "Document Attachment"; var RecRef: RecordRef)
    var
        BankAcc: Record "Bank Account";
    begin
        if DocumentAttachment."Table ID" = Database::"Bank Account" then begin
            RecRef.Open(DATABASE::"Bank Account");
            if BankAcc.Get(DocumentAttachment."No.") then
                RecRef.GetTable(BankAcc);
        end;
    end;

    [EventSubscriber(ObjectType::Page, Page::"Document Attachment Details", 'OnAfterOpenForRecRef', '', false, false)]
    local procedure OnAfterOpenForRecRefDocAttachmentDetails(var DocumentAttachment: Record "Document Attachment"; var RecRef: RecordRef)
    var
        FieldRef: FieldRef;
        RecNo: Code[20];
    begin
        case RecRef.Number() of
            DATABASE::"Bank Account":
                begin
                    FieldRef := RecRef.Field(1);
                    RecNo := FieldRef.Value();
                    DocumentAttachment.SetRange("No.", RecNo);
                end;
        end;
    end;
}