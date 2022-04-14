public with sharing class AccountSearcherController {
    @AuraEnabled
    public static List<Account> getAccountsByName(String name) {
        return AccountSearcherRepository.selectAccountsByName(name);
    }

    @AuraEnabled
    public static List<Account> getMapMarkersByName(String name) {
        return AccountSearcherRepository.selectMapMarkersByName(name);
    }

    @AuraEnabled
    public static List<Account> getMapMarkersById(Id id) {
        return AccountSearcherRepository.selectMapMarkersById(id);
    }

    @AuraEnabled
    public static Account getAccountById(Id id) {
        return AccountSearcherRepository.selectAccountById(id);
    }
}