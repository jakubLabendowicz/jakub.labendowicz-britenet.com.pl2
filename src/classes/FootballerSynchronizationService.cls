public with sharing class FootballerSynchronizationService {
    public static void synchronizeFootballers() {
        List<Footballer__c> footballersList = [SELECT Id, ExternalId__c, Name, FirstName__c, Birthday__c, Country__c, Team__c, Synchronized__c FROM Footballer__c WHERE Synchronized__c = false LIMIT 50000];
        List<String> ids = new List<String>();

        for (Footballer__c footballer:footballersList) {
            ids.add(footballer.Id);
        }

        System.enqueueJob(new QueueabledFootballerCallouts('POST', ids, new List<FootballerRestService.FootballerWrapper>()));
    }
}