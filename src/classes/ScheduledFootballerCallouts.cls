global with sharing class ScheduledFootballerCallouts implements Schedulable, Database.AllowsCallouts {
    private static final String jobName = 'Synchronization Job';
    private String method;

    public ScheduledFootballerCallouts(String method) {
        this.method = method;
    }

    global void execute(SchedulableContext ctx) {
        if (method == 'POST') {
            List<Footballer__c> footballers = [
                    SELECT Id
                    FROM Footballer__c
                    WHERE Synchronized__c = false AND ExternalId__c = ''
            ];
            if (!footballers.isEmpty()) {
                List<String> ids = new List<String>();
                for (Footballer__c footballer: footballers) {
                    ids.add(footballer.Id);
                }
                System.enqueueJob(new QueueabledFootballerCallouts(method, ids, new List<FootballerRestService.FootballerWrapper>()));
                FootballerUtils.increaseSynchronizationCounter(ids);
            }
        } else if (method == 'PUT') {
            List<Footballer__c> footballers = [
                    SELECT Id
                    FROM Footballer__c
                    WHERE Synchronized__c = false AND ExternalId__c != ''
            ];
            if (!footballers.isEmpty()) {
                List<String> ids = new List<String>();
                for (Footballer__c footballer: footballers) {
                    ids.add(footballer.Id);
                }
                System.enqueueJob(new QueueabledFootballerCallouts(method, ids, new List<FootballerRestService.FootballerWrapper>()));
                FootballerUtils.increaseSynchronizationCounter(ids);
            }
        } else if (method == 'DELETE') {
            List<DeletedFootballer__c> deletedFootballers = [
                    SELECT Id, ExternalId__c, PreviousId__c, SynchronizationCounter__c, Synchronized__c
                    FROM DeletedFootballer__c
            ];
            if (!deletedFootballers.isEmpty()) {
                List<String> ids = new List<String>();
                for (DeletedFootballer__c footballer: deletedFootballers) {
                    ids.add(footballer.Id);
                }
                System.enqueueJob(new QueueabledFootballerCallouts(method, ids, DeletedFootballerService.deletedFootballersToWrappers(deletedFootballers)));
                DeletedFootballerService.increaseSynchronizationCounter(ids);
            }
        }
        System.abortJob(ctx.getTriggerId());
    }

    public static void schedule(Integer attempt, String method) {
        Boolean isScheduled = [SELECT COUNT() FROM CronTrigger WHERE CronJobDetail.Name = :jobName] > 0;
        if (!isScheduled) {
            String name = jobName + ' ' + method;
            if (attempt == 0) {
                System.schedule(name, Datetime.now().addMinutes(1).format('s m H d M') + ' ? ', new ScheduledFootballerCallouts(method));
            } else if (attempt == 1) {
                System.schedule(name, Datetime.now().addMinutes(10).format('s m H d M') + ' ? ', new ScheduledFootballerCallouts(method));
            } else if (attempt >= 2) {
                System.schedule(name, Datetime.now().addMinutes(30).format('s m H d M') + ' ? ', new ScheduledFootballerCallouts(method));
                sendEmail();
            }
        }
    }

    private static void sendEmail() {
        String subject = System.Label.SynchronizationEmailSubject;
        String body = System.Label.SynchronizationEmailBody;
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        email.setSubject( subject );
        email.setToAddresses( new String[] {UserInfo.getUserEmail()} );
        email.setPlainTextBody( body );
        Messaging.SendEmailResult [] result = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
    }
}