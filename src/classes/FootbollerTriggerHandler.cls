public with sharing class FootbollerTriggerHandler extends TriggerHandler {
    private void switchExecuting() {
        TriggerSwitcher__c triggerSwitcher = TriggerSwitcher__c.getValues('FootballersTrigger');
        isExecuting = triggerSwitcher.run__c;
    }
    public static void switchExecutingOn() {
        TriggerSwitcher__c triggerSwitcher = TriggerSwitcher__c.getValues('FootballersTrigger');
        triggerSwitcher.run__c = true;
        update triggerSwitcher;
    }
    public static void switchExecutingOff() {
        TriggerSwitcher__c triggerSwitcher = TriggerSwitcher__c.getValues('FootballersTrigger');
        triggerSwitcher.run__c = false;
        update triggerSwitcher;
    }

    private void beforeInsert() {
        List<Footballer__c> footballersList = Trigger.new;
        for (Footballer__c footballer: footballersList) {
            footballer.Synchronized__c = false;
        }
    }
    private void beforeUpdate() {
        List<Footballer__c> footballersList = Trigger.new;
        for (Footballer__c footballer: footballersList) {
            footballer.Synchronized__c = false;
        }
    }

    private void afterInsert() {
        List<Footballer__c> footballersList = Trigger.new;
        List<String> ids = new List<String>();
        for (Footballer__c footballer:footballersList) {
            ids.add(footballer.Id);
        }
        System.enqueueJob(new QueueabledFootballerCallouts('POST', ids, new List<FootballerRestService.FootballerWrapper>()));
    }

    private void afterUpdate() {
        List<Footballer__c> footballersList = Trigger.new;
        List<String> ids = new List<String>();
        for (Footballer__c footballer:footballersList) {
            ids.add(footballer.Id);
        }
        System.enqueueJob(new QueueabledFootballerCallouts('PUT', ids, new List<FootballerRestService.FootballerWrapper>()));
    }

    private void afterDelete() {
        List<Footballer__c> footballersList = Trigger.old;
        List<String> ids = new List<String>();
        for (Footballer__c footballer:footballersList) {
            ids.add(footballer.Id);
        }

        List<FootballerRestService.FootballerWrapper> footballerWrappers = new List<FootballerRestService.FootballerWrapper>();
        for (Footballer__c footballer : footballersList) {
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
        System.enqueueJob(new QueueabledFootballerCallouts('DELETE', ids, footballerWrappers));
    }
}