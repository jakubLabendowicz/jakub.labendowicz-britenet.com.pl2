public with sharing class HomeSCartWrapper {
    public CartOrder cartOrder = new CartOrder();
    public List<CartOrderItem> cartOrderItems = new List<CartOrderItem>();

    public HomeSCartWrapper() {

    }

    public class CartOrder{
        public Id couponId;
        public Decimal orderValue;
        public ShippingAddress shippingAddress;
        public String paymentMethod;
    }

    public class ShippingAddress{
        public String street = '';
        public String city = '';
        public String state = '';
        public String zipCode = '';
        public String country = '';
    }
    
    public class CartOrderItem{
        public Id product2Id;
        public Integer quantity = 0;
    }

    public void addCartOrderCoupon(Id couponId){
        try {
            this.cartOrder.couponId = couponId;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    public void addCartOrderItem(Id productId){
        try {
            Boolean exist = false;
            for(CartOrderItem cartOrderItem: cartOrderItems) {
                if(cartOrderItem.product2Id == productId) {
                    cartOrderItem.quantity++;
                    exist = true;
                }
            }
            if(exist == false) {
                CartOrderItem cartOrderItem = new CartOrderItem();
                cartOrderItem.product2Id = productId;
                cartOrderItem.quantity = 1;
                cartOrderItems.add(cartOrderItem);
            }
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    public void removeCartOrderItem(Id productId){
        try {
            Integer index = 0;
            Integer indexToDeleted = -1;
            for(CartOrderItem cartOrderItem: this.cartOrderItems) {
                if(cartOrderItem.product2Id == productId) {
                    cartOrderItem.quantity--;
                    if(cartOrderItem.quantity <= 0) {
                        indexToDeleted = index;
                        System.debug(index);
                    }
                }
                index++;
            }
            System.debug(indexToDeleted);
            if(indexToDeleted != -1) {
                this.cartOrderItems.remove(indexToDeleted);
            }
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    public void addCartOrderPaymentMethod(String paymentMethod){
        try {
            this.cartOrder.paymentMethod = paymentMethod;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    public Contract getContract(){
        try {
            OrderAccountId__c orderAccountId = OrderAccountId__c.getOrgDefaults();

            Contract contract = new Contract(
                AccountId = orderAccountId.Id__c,
                Status = 'Draft',
                ContractTerm = 12,
                StartDate = Date.today()
            );
            return contract;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    public Order getOrder(){
        try {
            OrderAccountId__c orderAccountId = OrderAccountId__c.getOrgDefaults();
            OrderPricebookId__c orderPricebookId = OrderPricebookId__c.getOrgDefaults();

            Order order = new Order(
                Status = 'Draft',
                AccountId = orderAccountId.Id__c,
                EffectiveDate = Date.today(),
                Coupon__c = this.cartOrder.couponId,
                Payment_Method__c = this.cartOrder.paymentMethod,
                Pricebook2Id = orderPricebookId.Id__c,
                ShippingStreet = this.cartOrder.shippingAddress.street,
                ShippingCity = this.cartOrder.shippingAddress.city,
                ShippingState = this.cartOrder.shippingAddress.state,
                ShippingPostalCode = this.cartOrder.shippingAddress.zipCode,
                ShippingCountry = this.cartOrder.shippingAddress.country
            );
            return order;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    public List<OrderItem> getOrderItems(){
        try {
            List<OrderItem> orderItems = new List<OrderItem>();
            for(CartOrderItem cartOrderItem: this.cartOrderItems) {
                PriceBookEntry standardPriceBookEntry = HomeSPriceBookController.selectStandardPricebookEntry(cartOrderItem.product2Id);
                PriceBookEntry priceBookEntry = HomeSPriceBookController.selectPricebookEntry(cartOrderItem.product2Id);
                orderItems.add(new OrderItem(
                    Product2Id = cartOrderItem.product2Id,
                    Quantity = cartOrderItem.quantity,
                    PricebookEntryId = standardPriceBookEntry.Id,
                    UnitPrice = priceBookEntry.UnitPrice,
                    ServiceDate = Date.today()
                ));
            }
            return orderItems;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}