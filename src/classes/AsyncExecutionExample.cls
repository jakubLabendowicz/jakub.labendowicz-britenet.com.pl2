/**
 * Created by Jakub Łabendowicz on 29.12.2021.
 */

public class AsyncExecutionExample implements Queueable {
    public void execute(QueueableContext context) {
        Account a = new Account(Name='Acme',Phone='(415) 555-1212');
        insert a;
    }
}