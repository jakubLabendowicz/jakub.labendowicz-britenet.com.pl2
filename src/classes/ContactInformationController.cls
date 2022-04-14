public with sharing class ContactInformationController {
    @AuraEnabled
    public static Contact getContactById(Id id) {
        return ContactInformationRepository.selectContactById(id);
    }

    @AuraEnabled
    public static Attachment getProfilePictureById(Id parentId) {
        return ContactInformationRepository.selectProfilePictureById(parentId);
    }

    @AuraEnabled
    public static Id saveAttachment(Id parentId, String fileName, String base64Data, String contentType) {
        Attachment attachment = new Attachment();
        attachment.parentId = parentId;
        attachment.body = EncodingUtil.base64Decode(base64Data);
        attachment.name = fileName;
        attachment.contentType = contentType;
        return ContactInformationRepository.insertAttachment(attachment);
    }
}