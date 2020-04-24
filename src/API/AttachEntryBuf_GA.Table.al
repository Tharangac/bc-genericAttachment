table 55300 "Attach. Entry Buf._GA"
{
    Caption = 'Attachment Entity Buffer';
    DataClassification = CustomerContent;

    fields
    {
        field(1; ID; Integer)
        {
            Caption = 'ID';
            DataClassification = CustomerContent;
        }
        field(3; "Table ID"; Integer)
        {
            Caption = 'Table ID';
            DataClassification = CustomerContent;
        }

        field(4; "Document Type"; Enum "Attachment Document Type")
        {
            Caption = 'Document Type';
            DataClassification = CustomerContent;
        }
        field(5; "No."; Code[20])
        {
            Caption = 'No.';
            DataClassification = CustomerContent;
        }
        field(6; "Line No."; Integer)
        {
            Caption = 'Line No.';
            DataClassification = CustomerContent;
        }
        field(7; "File Name"; Text[250])
        {
            Caption = 'File Name';
            DataClassification = CustomerContent;
        }
        field(8; "File Type"; Option)
        {
            Caption = 'File Type';
            DataClassification = CustomerContent;
            OptionCaption = ' ,Image,PDF,Word,Excel,PowerPoint,Email,XML,Other';
            OptionMembers = " ",Image,PDF,Word,Excel,PowerPoint,Email,XML,Other;
        }
        field(9; "File Extension"; Text[30])
        {
            Caption = 'File Extension';
            DataClassification = CustomerContent;
        }
        field(10; Content; Blob)
        {
            Caption = 'Content';
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key(PK; ID)
        {
            Clustered = true;
        }
    }

}
