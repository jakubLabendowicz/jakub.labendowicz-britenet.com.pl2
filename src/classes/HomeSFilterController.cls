public with sharing class HomeSFilterController {
    public HomeSFilterController() {

    }

    @AuraEnabled
    public static List<String> selectManufacturerOptions(){
        try {
            List<Product2> products = [SELECT Manufacturer__c FROM Product2];
            List<String> optionsList = new List<String>();
            for(Product2 product: products) {
                optionsList.add(product.Manufacturer__c);
            }
            Set<String> optionsSet = new Set<String>(optionsList);
            return new List<String>(optionsSet);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static List<String> selectColorOptions(){
        try {
            List<Product2> products = [SELECT Color__c FROM Product2];
            List<String> optionsList = new List<String>();
            for(Product2 product: products) {
                optionsList.add(product.Color__c);
            }
            Set<String> optionsSet = new Set<String>(optionsList);
            return new List<String>(optionsSet);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static List<String> selectDimensionsOptions(){
        try {
            List<Product2> products = [SELECT Dimensions__c FROM Product2];
            List<String> optionsList = new List<String>();
            for(Product2 product: products) {
                optionsList.add(product.Dimensions__c);
            }
            Set<String> optionsSet = new Set<String>(optionsList);
            return new List<String>(optionsSet);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static List<String> selectWeightOptions(){
        try {
            List<Product2> products = [SELECT Weight__c FROM Product2];
            List<String> optionsList = new List<String>();
            for(Product2 product: products) {
                optionsList.add(product.Weight__c);
            }
            Set<String> optionsSet = new Set<String>(optionsList);
            return new List<String>(optionsSet);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static List<String> selectSupplyVoltageOptions(){
        try {
            List<Product2> products = [SELECT Supply_Voltage__c FROM Product2];
            List<String> optionsList = new List<String>();
            for(Product2 product: products) {
                optionsList.add(product.Supply_Voltage__c);
            }
            Set<String> optionsSet = new Set<String>(optionsList);
            return new List<String>(optionsSet);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static List<String> selectWorkingTemperatureOptions(){
        try {
            List<Product2> products = [SELECT Working_Temperature__c FROM Product2];
            List<String> optionsList = new List<String>();
            for(Product2 product: products) {
                optionsList.add(product.Working_Temperature__c);
            }
            Set<String> optionsSet = new Set<String>(optionsList);
            return new List<String>(optionsSet);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}