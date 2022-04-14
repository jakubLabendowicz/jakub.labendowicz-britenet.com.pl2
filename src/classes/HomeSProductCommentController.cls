public with sharing class HomeSProductCommentController {
    public HomeSProductCommentController() {

    }

    @AuraEnabled
    public static Id getUserId(){
        try {
            return UserInfo.getUserId();
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static String getUserName(){
        try {
            return UserInfo.getName();
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static ProductComment__c insertProductComment(ProductComment__c productComment){
        try {
            insert productComment;
            return productComment;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static ProductComment__c upsertProductComment(ProductComment__c productComment){
        try {
            upsert productComment;
            return productComment;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static ProductComment__c deleteProductComment(Id id){
        try {
            ProductComment__c productComment = [SELECT Id,Content__c,CreatedById,LastModifiedById,OwnerId,Product__c,Name,Rate__c,User__c,User_name__c, IsDeleted
            FROM ProductComment__c
            WHERE Id = :id
        ];
        delete productComment;
        return productComment;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static List<ProductComment__c> selectProductComments(Id id){
        try {
            List<ProductComment__c> productComments = [
                SELECT Id,Content__c,CreatedById,LastModifiedById,OwnerId,Product__c,Name,Rate__c,User__c,User_name__c, IsDeleted
                FROM ProductComment__c
                WHERE Product__c = :id
            ];
            return  productComments;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static Decimal selectAverageRate(Id id){
        try {
            List<ProductComment__c> productComments = [
                SELECT Id,Content__c,CreatedById,LastModifiedById,OwnerId,Product__c,Name,Rate__c,User__c,User_name__c, IsDeleted
                FROM ProductComment__c
                WHERE Product__c = :id
            ];
            Decimal sum = 0;
            for(ProductComment__c productComment: productComments) {
                sum = sum + productComment.Rate__c;
            }
            return sum/productComments.size();
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}