public class QueueabledCalloutsService implements Queueable, Database.AllowsCallouts {
    private String method;
    private List<String> ids;
    private List<FootballerRestService.FootballerWrapper> footballerWrappers;

    public QueueabledCalloutsService(String method, List<String> ids, List<FootballerRestService.FootballerWrapper> footballerWrappers) {
        this.method = method;
        this.ids = ids;
        this.footballerWrappers = footballerWrappers;
    }

    public void execute(QueueableContext context) {
        if (this.method == 'POST') {
           FootballerCalloutsService.makePostCallout(this.ids);
        } else if (this.method == 'PUT') {
            FootballerCalloutsService.makePutCallout(this.ids);
        } else if (this.method == 'DELETE') {
            FootballerCalloutsService.makeDeleteCallout(this.footballerWrappers);
        }
    }
}