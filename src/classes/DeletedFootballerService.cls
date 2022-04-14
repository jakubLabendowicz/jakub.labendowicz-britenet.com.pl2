public with sharing class DeletedFootballerService {

    public static void insertDeletedFootballers(List<FootballerRestService.FootballerWrapper> footballerWrappers) {
        List<String> previousIds = new List<String>();
        for (FootballerRestService.FootballerWrapper footballerWrapper: footballerWrappers) {
            previousIds.add(footballerWrapper.id);
        }

        List<DeletedFootballer__c> deletedFootballers = [SELECT Id, ExternalId__c, PreviousId__c FROM DeletedFootballer__c WHERE PreviousId__c IN :previousIds];

        List<DeletedFootballer__c> footballerToSyncList = new List<DeletedFootballer__c>();
        for (FootballerRestService.FootballerWrapper footballerWrapper : footballerWrappers) {
            Boolean duplicated = false;
            for (DeletedFootballer__c deletedFootballer: deletedFootballers) {
                if (footballerWrapper.id == deletedFootballer.PreviousId__c) {
                    duplicated = true;
                }
            }
            if (duplicated == false) {
                DeletedFootballer__c footballerToSync = new DeletedFootballer__c(
                        PreviousId__c = footballerWrapper.id,
                        ExternalId__c = footballerWrapper.externalId,
                        SynchronizationCounter__c = footballerWrapper.synchronizationCounter,
                        Name = footballerWrapper.lastName,
                        FirstName__c = footballerWrapper.firstName
                );
                footballerToSyncList.add(footballerToSync);
            }
        }
        insert footballerToSyncList;
    }

    public static void deleteDeletedFootballerByResults(List<FootballerRestService.Result> results) {
        List<ID> ids = new List<ID>();
        List<String> externalIds = new List<String>();
        if (results != null) {
            for (FootballerRestService.Result result : results) {
                if (result.success != null && result.success) {
                    ids.add(result.footballerWrapper.id);
                    externalIds.add(result.footballerWrapper.externalId);
                }
            }
        }
        delete [SELECT Id FROM DeletedFootballer__c WHERE ExternalId__c IN :externalIds];
    }

    public static void increaseSynchronizationCounter(List<String> ids) {
        List<DeletedFootballer__c> deletedFootballers = [SELECT Id, SynchronizationCounter__c FROM DeletedFootballer__c WHERE Id IN :ids];
        for (DeletedFootballer__c footballer : deletedFootballers) {
            footballer.SynchronizationCounter__c += 1;
        }
        update deletedFootballers;
    }

    public static Integer getSynchronizationCounter(List<FootballerRestService.FootballerWrapper> footballerWrappers) {
        return (Integer)footballerWrappers.get(0).synchronizationCounter;
    }

    public static List<FootballerRestService.FootballerWrapper> deletedFootballersToWrappers(List<DeletedFootballer__c> deletedFootballers) {
        List<FootballerRestService.FootballerWrapper> footballerWrappers = new List<FootballerRestService.FootballerWrapper>();
        for (DeletedFootballer__c deletedFootballer : deletedFootballers) {
            FootballerRestService.FootballerWrapper footballerWrapper = new FootballerRestService.FootballerWrapper();
            footballerWrapper.id = deletedFootballer.PreviousId__c;
            footballerWrapper.externalId = deletedFootballer.ExternalId__c;
            footballerWrapper.isSynchronized = deletedFootballer.Synchronized__c;
            footballerWrapper.synchronizationCounter = deletedFootballer.SynchronizationCounter__c;
            footballerWrappers.add(footballerWrapper);
        }
        return footballerWrappers;
    }
}