public with sharing class HomeSOrderController {
    public HomeSOrderController() {

    }

    @AuraEnabled
    public static Order insertOrder(Order newOrder){
        try {
            insert newOrder;
            return newOrder;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static OrderItem insertOrderItem(OrderItem orderItem){
        try {
            insert orderItem;
            return orderItem;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }


    @AuraEnabled
    public static List<Order> selectOrders(){
        try {
            Id userId = UserInfo.getUserId();
            List<Order> orders = [
                SELECT Id, TotalAmount, EffectiveDate, Status, CreatedById, Complaint__c, Coupon__c, Payment_Value__c
                FROM Order
                WHERE CreatedById = :userId
            ];
            return Orders;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static List<OrderItem> selectOrderItems(Id orderId){
        try {
            List<OrderItem> orderItems = [
                SELECT Id, Quantity, ListPrice, OrderId, OrderItemNumber, Product2Id, UnitPrice, Product_Name__c, Complaint__c
                FROM OrderItem
                WHERE OrderId = :orderId
            ];
            return orderItems;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }


    @AuraEnabled
    public static void updateComplaintTrue(Id orderItemId){
        try {
            OrderItem orderItem = [SELECT Id, Complaint__c FROM OrderItem WHERE Id = : orderItemId];
            orderItem.Complaint__c = true;
            update orderItem;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}