page 55300 "Doc. Attachment Entity_GA"
{
    PageType = API;
    SourceTable = "Attach. Entry Buf._GA";
    APIPublisher = 'tharangaC';
    APIGroup = 'docmgt';
    APIVersion = 'beta';
    EntityName = 'documentAttachment';
    EntitySetName = 'documentAttachments';
    DelayedInsert = true;
    Caption = 'Document Attachment Entity';
    ODataKeyFields = ID;
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(id; ID)
                {
                    Caption = 'id';
                    ApplicationArea = All;
                }
                field(tableID; "Table ID")
                {
                    Caption = 'tableID';
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin

                    end;
                }
                field(documentType; "Document Type")
                {
                    Caption = 'documentType';
                    ApplicationArea = All;
                }
                field(lineNo; "Line No.")
                {
                    Caption = 'lineNo';
                    ApplicationArea = All;
                }
                field(no; "No.")
                {
                    Caption = 'no';
                    ApplicationArea = All;
                }
                field(fileName; "File Name")
                {
                    Caption = 'fileName';
                    ApplicationArea = All;
                }
                field(fileType; "File Type")
                {
                    Caption = 'fileType';
                    ApplicationArea = All;
                }
                field(fileExtension; "File Extension")
                {
                    Caption = 'fileExtension';
                    ApplicationArea = All;
                }
                field(fileContent; Content)
                {
                    Caption = 'fileContent';
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        if AttachmentsLoaded then
                            AddAttachment();
                    end;
                }
            }
        }
    }

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    var
        DocAttachment: Record "Document Attachment";
        TempBlob: Codeunit "Temp Blob";
        InStream: InStream;
        OStream: OutStream;
    begin
        DocAttachment.Init();
        DocAttachment.ID := 0;
        DocAttachment."Document Type" := "Document Type";
        DocAttachment."Table ID" := "Table ID";
        DocAttachment."Line No." := "Line No.";
        DocAttachment."No." := "No.";
        DocAttachment."File Type" := "File Type";
        DocAttachment."File Name" := "File Name";
        DocAttachment."File Extension" := "File Extension";

        //if not Content.HasValue() then
        //    error('nothing');
        TempBlob.CreateOutStream(OStream);
        OStream.WRITETEXT('Content needs to update with a separate PATCH request : Contact your partner');
        TempBlob.CREATEINSTREAM(InStream);
        DocAttachment."Document Reference ID".IMPORTSTREAM(InStream, '', "File Name");
        DocAttachment.Insert(true);
        Rec.ID := DocAttachment.ID;
    end;


    trigger OnModifyRecord(): Boolean
    begin
        if xRec.Id <> Id then
            Error(StrSubstNo(CannotModifyKeyFieldErr, 'id'));

        exit(false);
    end;

    procedure AddAttachment()
    var
        DocumentAttach: Record "Document Attachment";
        OutStream: OutStream;
        InStream: InStream;
    begin
        DocumentAttach.SetFilter("No.", DocumentNoFilter);
        DocumentAttach.SetFilter("Document Type", DocumentTypeFilter);
        DocumentAttach.SetFilter("Line No.", LineNoFilter);
        DocumentAttach.SetFilter(ID, idFilter);
        DocumentAttach.SetFilter("Table ID", TableIDFilter);
        if DocumentAttach.FindFirst() then begin
            Rec.Content.CreateOutStream(OutStream);
            Content.CreateInStream(InStream);  // Read from Blob
            DocumentAttach."Document Reference ID".IMPORTSTREAM(InStream, '', DocumentAttach."File Name");
            DocumentAttach.Modify();
        end;
    end;

    trigger OnFindRecord(Which: Text): Boolean
    var
        FilterView: Text;
    begin
        if not AttachmentsLoaded then begin
            FilterView := GetView();
            idFilter := GetFilter(ID);
            DocumentNoFilter := GetFilter("No.");
            TableIDFilter := GetFilter("Table ID");
            LineNoFilter := GetFilter("Line No.");
            AttachmentIdFilter := GetFilter(ID);
            DocumentTypeFilter := GetFilter("Document Type");

            LoadAttachments();
            SetView(FilterView);

            AttachmentsFound := FindFirst();
            if not AttachmentsFound then
                exit(false);
            AttachmentsLoaded := true;
        end;

        exit(AttachmentsFound);
    end;

    procedure LoadAttachments()
    var
        DocumentAttach: Record "Document Attachment";
        OutStream: OutStream;
    begin
        DocumentAttach.SetFilter("No.", DocumentNoFilter);
        DocumentAttach.SetFilter("Document Type", DocumentTypeFilter);
        DocumentAttach.SetFilter("Line No.", LineNoFilter);

        if idFilter <> '0' then
            DocumentAttach.SetFilter(ID, idFilter);

        DocumentAttach.SetFilter("Table ID", TableIDFilter);
        if DocumentAttach.FindFirst() then
            repeat
                if DocumentAttach."Document Reference ID".HasValue() then begin
                    Rec.Init();
                    Rec.ID := DocumentAttach.ID;
                    Rec."Table ID" := DocumentAttach."Table ID";
                    Rec."Document Type" := DocumentAttach."Document Type";
                    Rec."Line No." := DocumentAttach."Line No.";
                    Rec."No." := DocumentAttach."No.";
                    Rec."File Name" := DocumentAttach."File Name";
                    Rec."File Type" := DocumentAttach."File Type";
                    Rec."File Extension" := DocumentAttach."File Extension";
                    Rec.Content.CreateOutStream(OutStream);
                    DocumentAttach."Document Reference ID".ExportStream(OutStream);
                    Rec.Insert();
                    AttachmentsFound := true;
                end;
            until DocumentAttach.Next() = 0;
    end;

    local procedure GetNextAttachmentEntryNo(): Integer
    var
        DocumentAttach: Record "Document Attachment";
    begin
        DocumentAttach.Reset();
        DocumentAttach.SetCurrentKey("No.");
        DocumentAttach.Ascending(true);
        if DocumentAttach.FindLast() then
            exit(DocumentAttach.ID + 1);

        exit(1);
    end;

    var
        MissingParentIdErr: Label 'You must specify a parentId in the request body.';
        CannotModifyKeyFieldErr: Label 'You cannot change the value of the key field %1.';
        AttachmentsLoaded: Boolean;
        AttachmentsFound: Boolean;
        DocumentNoFilter: Text;
        DocumentTypeFilter: Text;
        AttachmentIdFilter: Text;
        TableIDFilter: Text;
        LineNoFilter: Text;
        idFilter: Text;
}