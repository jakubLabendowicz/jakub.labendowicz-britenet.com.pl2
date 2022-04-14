public with sharing class HomeSPriceBookEntryController {
    public HomeSPriceBookEntryController() {

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
    public static Decimal selectPrice(Id id){
        try {
            List<PriceBookEntry> priceBookEntrys = [
                SELECT CreatedById,CreatedDate,Id,IsActive,IsArchived,IsDeleted,LastModifiedById,LastModifiedDate,Name,Pricebook2Id,Product2Id,ProductCode,SystemModstamp,UnitPrice,UseStandardPrice 
                FROM PricebookEntry
                WHERE Product2Id = :id AND IsActive = True
                ];
            return priceBookEntrys[0].UnitPrice;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}