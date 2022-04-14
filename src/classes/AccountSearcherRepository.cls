public with sharing class AccountSearcherRepository {
    public static List<Account> selectAccountsByName(String name) {
        return Database.query(
                'SELECT Id, Name, Phone, Website, BillingCountry, BillingCity, BillingStreet ' +
                        'FROM Account ' +
                        'WHERE Name LIKE \'%' + name + '%\' LIMIT 50000'
        );
    }

    public static List<Account> selectMapMarkersByName(String name) {
        return Database.query(
                'SELECT Name, BillingCountry, BillingCity, BillingStreet ' +
                        'FROM Account ' +
                        'WHERE Name LIKE \'%' + name + '%\' LIMIT 50000'
        );
    }

    public static List<Account> selectMapMarkersById(Id id) {
        return Database.query(
                'SELECT Name, BillingCountry, BillingCity, BillingStreet ' +
                        'FROM Account ' +
                        'WHERE Id = \'' + id + '\' LIMIT 50000'
        );
    }

    public static Account selectAccountById(Id id) {
        return Database.query(
                'SELECT Id, Name, Phone, Website, BillingCountry, BillingCity, BillingStreet ' +
                        'FROM Account ' +
                        'WHERE Id = \'' + id + '\' LIMIT 1'
        );
    }
}