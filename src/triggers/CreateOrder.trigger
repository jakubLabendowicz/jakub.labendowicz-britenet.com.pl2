trigger CreateOrder on Opportunity (after update) {

    try {
        List<Id> oppId = new List<Id>();
        List<Order> createdOrdersList = new List<Order>();
        Order createdOrder = new Order();

        for (Opportunity opp : Trigger.new) {
            if (opp.StageName == 'Closed Won') {
                createdOrder.Status = 'Draft';
                createdOrder.Pricebook2Id = opp.Pricebook2Id;
                if (opp.AccountId != null) {
                    createdOrder.AccountId = opp.AccountId;
                } else {
                    opp.addError('For this Opportunity AccountId not exist.');
                }
                createdOrder.EffectiveDate = Date.today();
                createdOrder.OpportunityId = opp.Id;
                createdOrdersList.add(createdOrder);
                oppId.add(opp.Id);
            }
        }
        insert createdOrdersList;

        List<OpportunityLineItem> opportunityLineItems = [SELECT Id, Product2Id, Quantity, TotalPrice, UnitPrice, PricebookEntryId, OpportunityId FROM OpportunityLineItem WHERE OpportunityId IN:oppId];
        Map<Id, List<OpportunityLineItem>> oppListMap = new Map<Id, List<OpportunityLineItem>>();
        List<OpportunityLineItem> lineItemsToMap;
        for (OpportunityLineItem oppLineItem : opportunityLineItems) {
            lineItemsToMap = new List<OpportunityLineItem>();
            if (oppListMap.containsKey(oppLineItem.OpportunityId)) {
                lineItemsToMap = oppListMap.get(oppLineItem.OpportunityId);
                lineItemsToMap.add(oppLineItem);
                oppListMap.put(oppLineItem.OpportunityId, lineItemsToMap);
            } else {
                lineItemsToMap.add(oppLineItem);
                oppListMap.put(oppLineItem.OpportunityId, lineItemsToMap);
            }
        }

        List<OrderItem> orderItemList = new List<OrderItem>();
        for (Order oneOrder : createdOrdersList) {
            for (OpportunityLineItem oppLineItemOne : oppListMap.get(oneOrder.OpportunityId)) {
                OrderItem newOrderItem = new OrderItem();
                newOrderItem.Product2Id = oppLineItemOne.Product2Id;
                newOrderItem.Quantity = oppLineItemOne.Quantity;
                newOrderItem.OrderId = oneOrder.Id;
                newOrderItem.PricebookEntryId = oppLineItemOne.PricebookEntryId;
                newOrderItem.UnitPrice = oppLineItemOne.UnitPrice;
                orderItemList.add(newOrderItem);
            }
        }
        insert orderItemList;
    } catch (Exception e) {
        system.debug(e);
    }
}