public with sharing class HomeSPriceBookController {
    public HomeSPriceBookController() {

    }

    @AuraEnabled
    public static Pricebook2 insertPricebook(Pricebook2 pricebook, List<Id> pricebookEntrysIds, String priceReductionType, Decimal priceReductionValue){
        try {
            insert pricebook;
            insertPricebookEntrysForNewPricebook(pricebook.Id, pricebookEntrysIds, priceReductionType, priceReductionValue);
            return pricebook;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static void insertPricebookEntrysForNewPricebook(Id id, List<Id> pricebookEntrysIds, String priceReductionType, Decimal priceReductionValue){
        try {
            OrderPricebookId__c orderPricebookId = OrderPricebookId__c.getOrgDefaults();

            List<PricebookEntry> pricebookEntrys = [
                SELECT CreatedById,CreatedDate,Id,IsActive,IsArchived,IsDeleted,LastModifiedById,LastModifiedDate,
                Name,Pricebook2Id,Product2Id,ProductCode,SystemModstamp,UnitPrice,UseStandardPrice
                FROM PricebookEntry
                WHERE Pricebook2Id = :orderPricebookId.Id__c AND Id IN :pricebookEntrysIds];

            List<PricebookEntry> newPricebookEntrys = new List<PricebookEntry>();
            for(PricebookEntry pricebookEntry: pricebookEntrys) {
                Decimal newPrice = 0;
                if(priceReductionType == 'Percent') {
                    newPrice = pricebookEntry.UnitPrice - pricebookEntry.UnitPrice * (priceReductionValue/100.0);
                } else if(priceReductionType == 'Currency') {
                    newPrice = pricebookEntry.UnitPrice - priceReductionValue;
                }
                else if(priceReductionType == 'New price') {
                    newPrice = priceReductionValue;
                }
                newPricebookEntrys.add(new PricebookEntry(
                    IsActive = pricebookEntry.IsActive,
                    Pricebook2Id = id,
                    Product2Id = pricebookEntry.Product2Id,
                    UnitPrice = newPrice
                ));
            }
            insert newPricebookEntrys;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static List<Pricebook2> selectPricebooks(){
        try {
            OrderPricebookId__c orderPricebookId = OrderPricebookId__c.getOrgDefaults();
            List<Pricebook2> pricebooks = [SELECT Id, Name, Description, IsActive, Start_time__c, End_time__c FROM Pricebook2 WHERE Id != :orderPricebookId.Id__c];
            return pricebooks;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    @AuraEnabled
    public static PriceBookEntry insertPriceBookEntry(PriceBookEntry priceBookEntry){
        try {
            insert priceBookEntry;
            return priceBookEntry;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static List<PricebookEntry> selectPricebookEntrys(){
        try {
            OrderPricebookId__c orderPricebookId = OrderPricebookId__c.getOrgDefaults();
            List<PricebookEntry> pricebookEntrys = [
                SELECT CreatedById,CreatedDate,Id,IsActive,IsArchived,IsDeleted,LastModifiedById,LastModifiedDate,Name,Pricebook2Id,Product2Id,ProductCode,SystemModstamp,UnitPrice,UseStandardPrice 
                FROM PricebookEntry
                WHERE Pricebook2Id = :orderPricebookId.Id__c
                ];
            return pricebookEntrys;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static Decimal selectPrice(Id id){
        try {
            List<PriceBookEntry> priceBookEntrys = [
                SELECT CreatedById,CreatedDate,Id,IsActive,IsArchived,IsDeleted,LastModifiedById,LastModifiedDate,Name,Pricebook2Id,Product2Id,ProductCode,SystemModstamp,UnitPrice,UseStandardPrice 
                FROM PricebookEntry
                WHERE Product2Id = :id AND IsActive = True
                ORDER BY LastModifiedDate DESC
                ];
            
            for(PriceBookEntry priceBookEntry: priceBookEntrys) {
                Pricebook2 pricebook = [SELECT Id, Name, Description, IsActive, Start_time__c, End_time__c FROM Pricebook2 WHERE Id = :pricebookEntry.Pricebook2Id];
                if(pricebook.IsActive == true && pricebook.Start_time__c <= datetime.now() && pricebook.End_time__c >= datetime.now()) {
                    return priceBookEntry.UnitPrice;
                }
            }
            return selectStandardPrice(id);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static PriceBookEntry selectPricebookEntry(Id id){
        try {
            List<PriceBookEntry> priceBookEntrys = [
                SELECT CreatedById,CreatedDate,Id,IsActive,IsArchived,IsDeleted,LastModifiedById,LastModifiedDate,Name,Pricebook2Id,Product2Id,ProductCode,SystemModstamp,UnitPrice,UseStandardPrice 
                FROM PricebookEntry
                WHERE Product2Id = :id AND IsActive = True
                ORDER BY LastModifiedDate DESC
                ];
            
            for(PriceBookEntry priceBookEntry: priceBookEntrys) {
                Pricebook2 pricebook = [SELECT Id, Name, Description, IsActive, Start_time__c, End_time__c FROM Pricebook2 WHERE Id = :pricebookEntry.Pricebook2Id];
                if(pricebook.IsActive == true && pricebook.Start_time__c <= datetime.now() && pricebook.End_time__c >= datetime.now()) {
                    return priceBookEntry;
                }
            }
            return selectStandardPricebookEntry(id);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static Decimal selectStandardPrice(Id id){
        try {
            OrderPricebookId__c orderPricebookId = OrderPricebookId__c.getOrgDefaults();
            List<PriceBookEntry> priceBookEntrys = [
                SELECT CreatedById,CreatedDate,Id,IsActive,IsArchived,IsDeleted,LastModifiedById,LastModifiedDate,Name,Pricebook2Id,Product2Id,ProductCode,SystemModstamp,UnitPrice,UseStandardPrice 
                FROM PricebookEntry
                WHERE Product2Id = :Id AND Pricebook2Id = :orderPricebookId.Id__c
                ];
            return priceBookEntrys[0].UnitPrice;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static PriceBookEntry selectStandardPricebookEntry(Id id){
        try {
            OrderPricebookId__c orderPricebookId = OrderPricebookId__c.getOrgDefaults();
            List<PriceBookEntry> priceBookEntrys = [
                SELECT CreatedById,CreatedDate,Id,IsActive,IsArchived,IsDeleted,LastModifiedById,LastModifiedDate,Name,Pricebook2Id,Product2Id,ProductCode,SystemModstamp,UnitPrice,UseStandardPrice 
                FROM PricebookEntry
                WHERE Product2Id = :Id AND Pricebook2Id = :orderPricebookId.Id__c
                ];
            return priceBookEntrys[0];
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}