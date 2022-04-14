public with sharing class FootballerRestRepository {
    public static List<FootballerRestService.Result> insertFootballers(List<FootballerRestService.FootballerWrapper> footballerWrappers) {
        List<Footballer__c> footballers = new List<Footballer__c>();
        for (FootballerRestService.FootballerWrapper footballerWrapper: footballerWrappers) {
            footballerWrapper.isSynchronized = true;
            footballers.add(FootballerRestService.wrapperToFootballer(footballerWrapper));
        }
        FootbollerTriggerHandler.switchExecutingOff();
        List<Database.SaveResult> saveResults = Database.insert(footballers, false);
        FootbollerTriggerHandler.switchExecutingOn();

        List<String> messages = FootballerRestService.getMessagesFromSaveResults(saveResults);
        Integer index = 0;
        for (Footballer__c footballer: footballers) {
            footballerWrappers[index].externalId = footballer.Id;
            index++;
        }
        return FootballerRestService.resultsBuilder(messages, footballerWrappers);
    }

    public static List<Database.SaveResult> updateFootballers(List<FootballerRestService.FootballerWrapper> footballerWrappers) {
        List<String> ids = new List<String>();
        for (FootballerRestService.FootballerWrapper footballerWrapper: footballerWrappers) {
            footballerWrapper.isSynchronized = true;
            ids.add(footballerWrapper.externalId);
        }
        List<Footballer__c> footballers = Database.query(
                'SELECT Id FROM footballer__c WHERE Id IN :ids'
        );
        Integer index = 0;
        for (FootballerRestService.FootballerWrapper footballerWrapper: footballerWrappers) {
            footballers[index].Name = footballerWrapper.lastName;
            footballers[index].FirstName__c = footballerWrapper.firstName;
            footballers[index].Birthday__c = footballerWrapper.birthday != null? Date.parse(footballerWrapper.birthday) : null;
            footballers[index].Country__c = footballerWrapper.Country;
            footballers[index].Team__c = footballerWrapper.team;
            footballers[index].Synchronized__c = true;
            index++;
        }
        FootbollerTriggerHandler.switchExecutingOff();
        List<Database.SaveResult> saveResults = Database.update(footballers, false);
        FootbollerTriggerHandler.switchExecutingOn();
        return saveResults;
    }

    public static List<Database.DeleteResult> deleteFootballers(List<FootballerRestService.FootballerWrapper> footballerWrappers) {
        List<String> ids = new List<String>();
        for (FootballerRestService.FootballerWrapper footballerWrapper: footballerWrappers) {
            ids.add(footballerWrapper.externalId);
        }
        List<Footballer__c> footballers = Database.query('SELECT Name FROM Footballer__c WHERE Id = :ids');

        FootbollerTriggerHandler.switchExecutingOff();
        List<Database.DeleteResult> deleteResults = Database.delete(footballers, false);
        FootbollerTriggerHandler.switchExecutingOn();

        return deleteResults;
    }
}