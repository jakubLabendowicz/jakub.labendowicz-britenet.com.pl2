public with sharing class HomeSCouponController {
    public HomeSCouponController() {

    }

    @AuraEnabled
    public static Coupon__c selectCouponByCode(String code){
        try {
            Datetime nowDateTime = Datetime.now();
            Coupon__c coupon = new Coupon__c();
            coupon = [
                SELECT Id,Name,Code__c,Active__c,Start_Date__c,End_Date__c,Price_reduction_type__c,Price_reduction_value__c
                FROM Coupon__c
                WHERE Code__c = :code AND Active__c = true AND Start_Date__c <= :nowDateTime AND End_Date__c >= :nowDateTime
                LIMIT 1
            ];
            return coupon;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static Coupon__c selectCouponById(Id id){
        try {
             Coupon__c coupon = [
                SELECT Id,Name,Code__c,Active__c,Start_Date__c,End_Date__c,Price_reduction_type__c,Price_reduction_value__c
                FROM Coupon__c
                WHERE Id = :id
            ];
            return coupon;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}