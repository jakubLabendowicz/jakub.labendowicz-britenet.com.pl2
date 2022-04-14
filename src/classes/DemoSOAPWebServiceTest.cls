@isTest
private class DemoSOAPWebServiceTest {
    private static testMethod void positiveTest() {
        Account acc = new Account(Name = 'Test Account');
        insert acc;
        
        Id contactId = DemoSOAPWebService.makeContact('Test Contact', acc.Id);
        
        System.assert(contactId != null);
    }
}