public with sharing class HomeSContentDocumentLinkController {
    public HomeSContentDocumentLinkController() {

    }

    @AuraEnabled
    public static List<ContentDocumentLink> selectContentDocumentLinks(Id productId){
        try {
            return [SELECT ContentDocumentId, Id, IsDeleted, LinkedEntityId, ShareType, SystemModstamp, Visibility FROM ContentDocumentLink WHERE LinkedEntityId = :productId];
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static List<String> selectContentDocumentLinksSrcs(Id productId){
        try {
            List<String> contentDocumentLinksSrcs = new List<String>();
            Product2 product = HomeSProductController.selectProduct(productId);
            List<ContentDocumentLink> contentDocumentLinks = [SELECT ContentDocumentId, Id, IsDeleted, LinkedEntityId, ShareType, SystemModstamp, Visibility FROM ContentDocumentLink WHERE LinkedEntityId = :productId];
            
            contentDocumentLinksSrcs.add(product.Default_image__c);

            for(ContentDocumentLink contentDocumentLink: contentDocumentLinks) {
                if(product.Default_image__c != '/sfc/servlet.shepherd/document/download/' + contentDocumentLink.ContentDocumentId) {
                    contentDocumentLinksSrcs.add('/sfc/servlet.shepherd/document/download/' + contentDocumentLink.ContentDocumentId);
                }
                
            }
            return contentDocumentLinksSrcs;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}