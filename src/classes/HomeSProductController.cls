public with sharing class HomeSProductController {
    public HomeSProductController() {

    }

    @AuraEnabled
    public static Product2 insertProduct(Product2 product){
        try {
            insert product;
            return product;
        } catch (Exception e) {
            System.debug(product);
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static Product2 updateProductDefaultImage(Id productId, String defaultImage){
        try {
            Product2 product = selectProduct(productId);
            product.Default_image__c = defaultImage;
            update product;
            return product;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static Product2 selectProduct(Id id){
        try {
            return [
                SELECT Description,Description__c,Family,Id,Name,ProductCode, Manufacturer__c, Color__c,Dimensions__c,Weight__c,
                Supply_voltage__c,Working_temperature__c,Default_image__c
                FROM Product2
                WHERE Id = :id
                ];
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static List<Product2> selectProducts(Product2 product){
        try {
            String shop = 'HomeS';
            String query = 'SELECT Description,Description__c,Family,Id,Name,ProductCode, Manufacturer__c, Color__c,Dimensions__c,Weight__c,Supply_voltage__c,Working_temperature__c, Shop__c'
            + ' FROM Product2'
            + ' WHERE'
            + ' Name LIKE \'%' + product.Name + '%\'';

            if(product.Family != '') {
                query = query + ' AND Family LIKE \'%' + product.Family + '%\'';
            }
            if(product.Manufacturer__c != '') {
                query = query + ' AND Manufacturer__c LIKE \'%' + product.Manufacturer__c + '%\'';
            }
            if(product.Color__c != '') {
                query = query + ' AND Color__c LIKE \'%' + product.Color__c + '%\'';
            }
            if(product.Dimensions__c != '') {
                query = query + ' AND Dimensions__c LIKE \'%' + product.Dimensions__c + '%\'';
            }
            if(product.Weight__c != '') {
                query = query + ' AND Weight__c LIKE \'%' + product.Weight__c + '%\'';
            }
            if(product.Supply_voltage__c != '') {
                query = query + ' AND Supply_voltage__c LIKE \'%' + product.Supply_voltage__c + '%\'';
            }
            if(product.Working_temperature__c != '') {
                query = query + ' AND Working_temperature__c LIKE \'%' + product.Working_temperature__c + '%\'';
            }

            List<Product2> products = Database.query(query);
            List<Product2> shopProducts = new List<Product2>();
            for(Product2 product2: products) {
                if(product2.Shop__c == shop) shopProducts.add(product2);
            }
            return shopProducts;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static List<Product2> selectRandomProducts(Integer resultsLimit){
        try {
            Integer quantityOfProducts = Database.countQuery('SELECT COUNT() FROM Product2 WHERE Shop__c = \'HomeS\'');
            Integer randomOffset = Integer.valueof((Math.random() * (quantityOfProducts - resultsLimit)));
            List<Product2> products = [SELECT Id FROM Product2 WHERE Shop__c = 'HomeS' LIMIT :resultsLimit OFFSET :randomOffset];
            return products;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static List<Product2> selectCommentedProducts(Integer resultsLimit){
        try {
            Id userId = UserInfo.getUserId();
            List<ProductComment__c> productComments = [
                SELECT Id,Content__c,CreatedById,LastModifiedById,OwnerId,Product__c,Name,Rate__c,User__c,User_name__c, IsDeleted
                FROM ProductComment__c
                WHERE User__c = :userId
            ];
            List<Id> productsIds = new List<Id>();
            for(ProductComment__c productComment: productComments) {
                productsIds.add(productComment.Product__c);
            }
            List<Product2> products = [
                SELECT Description,Description__c,Family,Id,Name,ProductCode, Manufacturer__c, Color__c,Dimensions__c,Weight__c,Supply_voltage__c,Working_temperature__c,Default_image__c
                FROM Product2
                WHERE Id IN :productsIds AND Shop__c = 'HomeS'
                LIMIT :resultsLimit
                ];
            return products;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}