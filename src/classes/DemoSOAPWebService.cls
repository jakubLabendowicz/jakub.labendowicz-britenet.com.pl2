global with sharing class DemoSOAPWebService {
    webservice static Id makeContact(String contactLastName, String accountId) {
        Contact c = new Contact(lastName = contactLastName, AccountId = accountId);
        insert c;
        return c.id;
    }
}