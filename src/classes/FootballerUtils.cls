public with sharing class FootballerUtils {
    public class ResponseWrapper {
        public String id;
        public String access_token;
        public String instance_url;
    }

    public static List<FootballerRestService.FootballerWrapper> selectFootballerWrappersByIds(List<String> ids) {
        List<Footballer__c> footballers = [SELECT Id, ExternalId__c, Name, FirstName__c, Birthday__c, Country__c, Team__c, Synchronized__c, SynchronizationCounter__c FROM Footballer__c WHERE Id IN :ids];
        List<FootballerRestService.FootballerWrapper> footballerWrappers = new List<FootballerRestService.FootballerWrapper>();
        for (Footballer__c footballer : footballers) {
            FootballerRestService.FootballerWrapper footballerWrapper = new FootballerRestService.FootballerWrapper();
            footballerWrapper.id = footballer.Id;
            footballerWrapper.externalId = footballer.ExternalId__c;
            footballerWrapper.lastName = footballer.Name;
            footballerWrapper.firstName = footballer.FirstName__c;
            footballerWrapper.birthday = footballer.Birthday__c != null ? footballer.Birthday__c.format() : null;
            footballerWrapper.country = footballer.Country__c;
            footballerWrapper.team = footballer.Team__c;
            footballerWrapper.isSynchronized = footballer.Synchronized__c;
            footballerWrapper.synchronizationCounter = footballer.SynchronizationCounter__c;
            footballerWrappers.add(footballerWrapper);
        }
        return footballerWrappers;
    }

    public static void updateFootballers(List<FootballerRestService.Result> results) {
        List<String> ids = new List<String>();
        List<String> externalIds = new List<String>();
        for (FootballerRestService.Result result : results) {
            if (result.success == true) {
                ids.add(result.footballerWrapper.id);
                externalIds.add(result.footballerWrapper.externalId);
            }
        }
        Integer index = 0;
        List<Footballer__c> footballers = [SELECT Id, Synchronized__c FROM Footballer__c WHERE Id IN :ids];
        for (Footballer__c footballer : footballers) {
            footballer.Synchronized__c = true;
            footballer.SynchronizationCounter__c = 0;
            footballer.ExternalId__c = externalIds[index];
            index++;
        }
        TriggerSwitcher__c triggerSwitcher = TriggerSwitcher__c.getValues('FootballersTrigger');
        triggerSwitcher.run__c = false;
        update triggerSwitcher;
        update footballers;
        triggerSwitcher.run__c = true;
        update triggerSwitcher;
    }

    public static Integer getSynchronizationCounter(List<String> ids){
        return  (Integer)[SELECT SynchronizationCounter__c FROM Footballer__c WHERE Id IN :ids LIMIT 1].SynchronizationCounter__c;
    }

    public static void increaseSynchronizationCounter(List<String> ids) {
        List<Footballer__c> footballers = [SELECT Id, SynchronizationCounter__c FROM Footballer__c WHERE Id IN :ids];
        for (Footballer__c footballer : footballers) {
            footballer.SynchronizationCounter__c ++;
        }
        TriggerSwitcher__c triggerSwitcher = TriggerSwitcher__c.getValues('FootballersTrigger');
        triggerSwitcher.run__c = false;
        update triggerSwitcher;
        update footballers;
        triggerSwitcher.run__c = true;
        update triggerSwitcher;
    }
}