public with sharing class FootballerSynchronizeInsert {
    @InvocableMethod
    public static void insertFootballers(List<ID> ids) {
//        LoggerService.insertLogger('Insert', '', '', ids, null);
        System.enqueueJob(new QueueabledFootballerCallouts('POST', ids, new List<FootballerRestService.FootballerWrapper>()));
    }
}