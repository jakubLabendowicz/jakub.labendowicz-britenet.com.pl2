public class QueueabledFootballerCallouts implements Queueable, Database.AllowsCallouts {
    private String method;
    private List<String> ids;
    private List<FootballerRestService.FootballerWrapper> footballerWrappers;

    public QueueabledFootballerCallouts(String method, List<String> ids, List<FootballerRestService.FootballerWrapper> footballerWrappers) {
        this.method = method;
        this.ids = ids;
        this.footballerWrappers = footballerWrappers;
    }

    public void execute(QueueableContext context) {
        List<Logger__c> loggers = new List <Logger__c>();
        if (this.method == 'POST') {
            FootballerCalloutsService.makeConnectCallout();
            loggers = FootballerCalloutsService.makePostCallout(this.ids);
        } else if (this.method == 'PUT') {
            FootballerCalloutsService.makeConnectCallout();
            loggers = FootballerCalloutsService.makePutCallout(this.ids);
        } else if (this.method == 'DELETE') {
            FootballerCalloutsService.makeConnectCallout();
            loggers = FootballerCalloutsService.makeDeleteCallout(this.footballerWrappers);
        }
        if (LoggerService.isCalloutNeeded(loggers) && this.method != 'DELETE') {
            try{
                ScheduledFootballerCallouts.schedule(FootballerUtils.getSynchronizationCounter(ids), method);
            } catch (Exception e) {
                e.getMessage();
            }
        } else if (LoggerService.isCalloutNeeded(loggers) && method == 'DELETE'){
            DeletedFootballerService.insertDeletedFootballers(footballerWrappers);
            try{
                ScheduledFootballerCallouts.schedule(DeletedFootballerService.getSynchronizationCounter(footballerWrappers), method);
            } catch (Exception e) {
                e.getMessage();
            }
        }
    }
}