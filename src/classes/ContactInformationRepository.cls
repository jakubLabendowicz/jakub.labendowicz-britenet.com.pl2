public with sharing class ContactInformationRepository {
    public static Contact selectContactById(Id id) {
        return Database.query(
                'SELECT Id, Name, Title, Phone, Email, Birthdate, Department ' +
                        'FROM Contact ' +
                        'WHERE Id = \'' + id + '\' LIMIT 1'
        );
    }

    public static Attachment selectProfilePictureById(Id parentId) {
        return [SELECT Id, Name, LastModifiedDate, ContentType FROM Attachment WHERE parentid=:ParentId AND ContentType IN ('image/png', 'image/jpeg', 'image/gif') ORDER BY LastModifiedDate DESC LIMIT 1];
    }

    public static Id insertAttachment(Attachment attachment) {
        insert attachment;
        return attachment.id;
    }
}