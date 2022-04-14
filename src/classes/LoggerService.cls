public with sharing class LoggerService {
    static public List<Logger__c> insertLogger(String action, String request, String response, List<FootballerRestService.Result> results, List<FootballerRestService.FootballerWrapper> footballerWrappers) {
        List<Logger__c> loggers = new List<Logger__c>();
        Integer index = 0;
        for (FootballerRestService.Result result: results) {
            Logger__c logger = new Logger__c();
            logger.Action__c = action;
            logger.Request__c = request;
            logger.Response__c = response;
            logger.Date__c = Datetime.now();
            logger.User__c = result.user != null ? result.user : '';
            logger.Success__c = result.success != null ? result.success : false;
            logger.Message__c = result!=null ? result.message : System.Label.noResultsInfo;
            logger.Footballer__c = action != 'Delete' && result.footballerWrapper != null
                    ? result.footballerWrapper.id
                    : (action != 'Delete' && footballerWrappers!= null)?footballerWrappers.get(index).id:null;
            logger.ExternalId__c = result.footballerWrapper != null ? result.footballerWrapper.externalId : '';
            logger.SynchronizationCounter__c = footballerWrappers[index].synchronizationCounter != null ? footballerWrappers[index].synchronizationCounter: null;
            loggers.add(logger);
            index++;
        }
        insert loggers;
        return loggers;
    }

    public static Boolean isCalloutNeeded(List<Logger__c> loggers) {
        Boolean isCalloutNeeded = false;
        for (Logger__c log : loggers) {
            if (log.Success__c == false) {
                isCalloutNeeded = true;
                break;
            }
        }
        return isCalloutNeeded;
    }
}