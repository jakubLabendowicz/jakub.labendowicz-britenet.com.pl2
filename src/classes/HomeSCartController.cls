public with sharing class HomeSCartController {
    public String abc = '';
    
    public HomeSCartController() {

    }

    @AuraEnabled
    public static void addProduct(Id productId){
        try {
            Cache.SessionPartition sessionPart = Cache.Session.getPartition('local.Main');
            if((HomeSCartWrapper)sessionPart.get('CartContent') !=null) {
                HomeSCartWrapper cartWrapper = (HomeSCartWrapper)sessionPart.get('CartContent');
                cartWrapper.addCartOrderItem(productId);
                sessionPart.put('CartContent', cartWrapper);
            } else {
                HomeSCartWrapper cartWrapper = new HomeSCartWrapper();
                cartWrapper.addCartOrderItem(productId);
                sessionPart.put('CartContent', cartWrapper);
            }
            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static void removeProduct(Id productId){
        try {
            Cache.SessionPartition sessionPart = Cache.Session.getPartition('local.Main');
            HomeSCartWrapper cartWrapper = (HomeSCartWrapper)sessionPart.get('CartContent');
            cartWrapper.removeCartOrderItem(productId);
            sessionPart.put('CartContent', cartWrapper);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static void addCoupon(Id couponId){
        try {
            Cache.SessionPartition sessionPart = Cache.Session.getPartition('local.Main');
            if((HomeSCartWrapper)sessionPart.get('CartContent') !=null) {
                HomeSCartWrapper cartWrapper = (HomeSCartWrapper)sessionPart.get('CartContent');
                cartWrapper.addCartOrderCoupon(couponId);
                sessionPart.put('CartContent', cartWrapper);
            } else {
                HomeSCartWrapper cartWrapper = new HomeSCartWrapper();
                cartWrapper.addCartOrderCoupon(couponId);
                sessionPart.put('CartContent', cartWrapper);
            }
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static void addShippingAddress(String shippingAddress){
        try {
            Cache.SessionPartition sessionPart = Cache.Session.getPartition('local.Main');
            if((HomeSCartWrapper)sessionPart.get('CartContent') !=null) {
                HomeSCartWrapper cartWrapper = (HomeSCartWrapper)sessionPart.get('CartContent');
                cartWrapper.cartOrder.shippingAddress = (HomeSCartWrapper.ShippingAddress)JSON.deserialize(shippingAddress, HomeSCartWrapper.ShippingAddress.class);
                sessionPart.put('CartContent', cartWrapper);
            } else {
                HomeSCartWrapper cartWrapper = new HomeSCartWrapper();
                cartWrapper.cartOrder.shippingAddress = (HomeSCartWrapper.ShippingAddress)JSON.deserialize(shippingAddress, HomeSCartWrapper.ShippingAddress.class);
                sessionPart.put('CartContent', cartWrapper);
            }
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static void addPaymentMethod(String paymentMethod){
        try {
            Cache.SessionPartition sessionPart = Cache.Session.getPartition('local.Main');
            if((HomeSCartWrapper)sessionPart.get('CartContent') !=null) {
                HomeSCartWrapper cartWrapper = (HomeSCartWrapper)sessionPart.get('CartContent');
                cartWrapper.addCartOrderPaymentMethod(paymentMethod);
                System.debug(cartWrapper);
                sessionPart.put('CartContent', cartWrapper);
            } else {
                HomeSCartWrapper cartWrapper = new HomeSCartWrapper();
                cartWrapper.addCartOrderPaymentMethod(paymentMethod);
                System.debug(cartWrapper);
                sessionPart.put('CartContent', cartWrapper);
            }
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static String getCart(){
        try {
            Cache.SessionPartition sessionPart = Cache.Session.getPartition('local.Main');
            if((HomeSCartWrapper)sessionPart.get('CartContent') !=null) {
                HomeSCartWrapper cartWrapper = (HomeSCartWrapper)sessionPart.get('CartContent');
                System.debug(cartWrapper);
                cartWrapper.cartOrder.orderValue = getOrderValue();
                return JSON.serialize(cartWrapper);
            } else {
                HomeSCartWrapper cartWrapper = new HomeSCartWrapper();
                System.debug(cartWrapper);
                return JSON.serialize(cartWrapper);
            }
            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static Decimal getOrderValue(){
        try {
            Decimal orderValue = 0;

            Cache.SessionPartition sessionPart = Cache.Session.getPartition('local.Main');
            if((HomeSCartWrapper)sessionPart.get('CartContent') !=null) {
                HomeSCartWrapper cartWrapper = (HomeSCartWrapper)sessionPart.get('CartContent');
                for(HomeSCartWrapper.CartOrderItem cartOrderItem: cartWrapper.cartOrderItems) {
                    Decimal price = HomeSPriceBookEntryController.selectPrice(cartOrderItem.product2Id);
                    Decimal listPrice = price * cartOrderItem.quantity;
                    orderValue = orderValue + listPrice;
                }   
            }

            return orderValue;
            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static void makeOrder(){
        try {
            Contract contract = insertContract();
            Order order = insertOrder(contract.Id);
            List<OrderItem> orderItems = insertOrderItems(order.Id);
            clearCart();
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static Contract insertContract(){
        try {
            Cache.SessionPartition sessionPart = Cache.Session.getPartition('local.Main');
            HomeSCartWrapper cartWrapper = (HomeSCartWrapper)sessionPart.get('CartContent');
            Contract contract = cartWrapper.getContract();
            insert contract;
            return contract;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static Order insertOrder(Id id){
        try {
            Cache.SessionPartition sessionPart = Cache.Session.getPartition('local.Main');
            HomeSCartWrapper cartWrapper = (HomeSCartWrapper)sessionPart.get('CartContent');
            Order order = cartWrapper.getOrder();
            order.ContractId = id;

            Decimal orderValue = getOrderValue();
            Decimal couponValue = 0;
            if(order.Coupon__c != null) {
                Coupon__c coupon = HomeSCouponController.selectCouponById(order.Coupon__c);
                if(coupon.Price_reduction_type__c == 'Percent') {
                    couponValue = orderValue*(1/coupon.Price_reduction_value__c);
                } else if(coupon.Price_reduction_type__c == 'Currency') {
                    couponValue = coupon.Price_reduction_value__c;
                }
            }
            order.Payment_Value__c = orderValue - couponValue;
            insert order;
            return order;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static List<OrderItem> insertOrderItems(Id id){
        try {
            Cache.SessionPartition sessionPart = Cache.Session.getPartition('local.Main');
            HomeSCartWrapper cartWrapper = (HomeSCartWrapper)sessionPart.get('CartContent');
            List<OrderItem> orderItems = cartWrapper.getOrderItems();
            for(OrderItem orderItem: orderItems) {
                orderItem.OrderId = id;
            }
            insert orderItems;
            return orderItems;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static void clearCart(){
        try {
            Cache.SessionPartition sessionPart = Cache.Session.getPartition('local.Main');
            HomeSCartWrapper cartWrapper = new HomeSCartWrapper();
            sessionPart.put('CartContent', cartWrapper);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}