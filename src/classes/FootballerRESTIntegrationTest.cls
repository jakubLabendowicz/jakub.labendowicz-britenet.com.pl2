@IsTest
private class FootballerRESTIntegrationTest {
    @testSetup
    private static void setup() {
        insert new TriggerSwitcher__c(
                Name = 'FootballersTrigger',
                run__c = true
        );
        insert new RESTLoginData__c(
                Name = 'RestAuth',
                cKey__c = 'cKey',
                cSecret__c = 'cSecret',
                uName__c = 'uName',
                passwd__c = 'passwd'
        );
        insert new RESTCallout__c(
                Name = 'Connect',
                Endpoint__c = 'https://web.pl',
                Method__c = 'POST'
        );
        insert new RESTCallout__c(
                Name = 'Post',
                Endpoint__c = 'https://web.pl',
                Method__c = 'POST',
                ContentType__c = 'application/json;charset=UTF-8',
                Action__c = 'Insert'
        );
        insert new RESTCallout__c(
                Name = 'Put',
                Endpoint__c = 'https://web.pl',
                Method__c = 'PUT',
                ContentType__c = 'application/json;charset=UTF-8',
                Action__c = 'Update');
        insert new RESTCallout__c(
                Name = 'Delete',
                Endpoint__c = 'https',
                Method__c = 'DELETE',
                ContentType__c = 'application/json;charset=UTF-8',
                Action__c = 'Delete'
        );
        insert new Footballer__c(
                Name = 'Name',
                FirstName__c = 'FirstName',
                Country__c = '',
                Team__c = 'Team',
                SynchronizationCounter__c = 0
        );
    }
    @IsTest
    private static void shouldMakeConnectCallout() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new FootballerConnectMock());
        FootballerCalloutsService.makeConnectCallout();
        Test.stopTest();

        String token = (String) Cache.Org.get('local.Main.token');
        System.assertEquals(token, '00D7Q000000I1H7!AREAQJpuTa.HXw2RflbyJqyWjGsEZjmH.HRs8MiNrYAcHx0dCS7GwdUd.s8JT0qn_J350seNFFoOlDlHC.L_Y30KhPcrk6mb');
    }

    @IsTest
    private static void shouldReturnErrorWhenIsConnectCallout() {
        Test.startTest();
        FootballerCalloutsService.makeConnectCallout();
        Test.stopTest();

        String token = (String) Cache.Org.get('local.Main.token');
        System.assertNotEquals(token, '00D7Q000000I1H7!AREAQJpuTa.HXw2RflbyJqyWjGsEZjmH.HRs8MiNrYAcHx0dCS7GwdUd.s8JT0qn_J350seNFFoOlDlHC.L_Y30KhPcrk6mb');
    }

    @IsTest
    private static void shouldInsertFootballerAndAddSuccessLogger() {
        List<Footballer__c> footballers = [SELECT Id FROM Footballer__c];
        List<String> ids = new List<String>();
        for (Footballer__c footballer : footballers) {
            ids.add(footballer.Id);
        }

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new FootballerConnectMock());
        FootballerCalloutsService.makeConnectCallout();
        Test.setMock(HttpCalloutMock.class, new FootballerRESTServiceMock());
        List<Logger__c> loggers = FootballerCalloutsService.makePostCallout(ids);
        Test.stopTest();

        for (Logger__c logger : loggers) {
            System.assertEquals(logger.Message__c, 'Success');
        }
    }

    @IsTest
    private static void shouldAddNotSuccessLoggerAndRepeatInsertWhenFootballerIsInsertingAndPostCalloutFaild() {
        List<Footballer__c> footballers = [SELECT Id FROM Footballer__c];
        List<String> ids = new List<String>();
        for (Footballer__c footballer : footballers) {
            ids.add(footballer.Id);
        }

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new FootballerConnectMock());
        FootballerCalloutsService.makeConnectCallout();
        Test.setMock(HttpCalloutMock.class, new FootballerUnsuccessRESTServiceMock());
        List<Logger__c> loggers = FootballerCalloutsService.makePostCallout(ids);
        Test.stopTest();

        for (Logger__c logger : loggers) {
            System.assert(logger.Success__c == false);
        }
    }

    @IsTest
    private static void shouldAddTwoNotSuccessLoggerAndRepeatInsertWhenFootballerIsInsertingAndConnectionCalloutFaild() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new FootballerUnsuccessRESTServiceMock());
        insert new Footballer__c(
                Name = 'Name33',
                FirstName__c = 'FirstName',
                Country__c = '',
                Team__c = 'Team',
                SynchronizationCounter__c = 2
        );
        insert new Footballer__c(
                Name = 'Name43',
                FirstName__c = 'FirstName',
                Country__c = '',
                Team__c = 'Team',
                SynchronizationCounter__c = 2
        );
        Test.stopTest();
    }

    @IsTest
    private static void shouldAddNotSuccessLoggerInSecondAttemptAndRepeatInsertWhenFootballerIsInsertingAndPostCalloutFaild() {
        insert new Footballer__c(
                Name = 'Name33',
                FirstName__c = 'FirstName',
                Country__c = '',
                Team__c = 'Team',
                SynchronizationCounter__c = 2
        );

        List<Footballer__c> footballers = [SELECT Id FROM Footballer__c WHERE Name = 'Name33'];
        List<String> ids = new List<String>();
        for (Footballer__c footballer : footballers) {
            ids.add(footballer.Id);
        }

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new FootballerConnectMock());
        FootballerCalloutsService.makeConnectCallout();
        Test.setMock(HttpCalloutMock.class, new FootballerUnsuccessRESTServiceMock());
        List<Logger__c> loggers = FootballerCalloutsService.makePostCallout(ids);
        Test.stopTest();

        for (Logger__c logger : loggers) {
            System.assert(logger.Success__c == false);
        }
    }

    @IsTest
    private static void shouldUpdateFootballerAndAddSuccessLogger() {
        List<Footballer__c> footballers = [SELECT Id FROM Footballer__c];
        List<String> ids = new List<String>();
        for (Footballer__c footballer : footballers) {
            ids.add(footballer.Id);
        }

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new FootballerConnectMock());
        FootballerCalloutsService.makeConnectCallout();
        Test.setMock(HttpCalloutMock.class, new FootballerRESTServiceMock());
        List<Logger__c> loggers = FootballerCalloutsService.makePutCallout(ids);
        Test.stopTest();

        for (Logger__c logger : loggers) {
            System.assert(logger.Success__c == true);
        }
    }

    @IsTest
    private static void shouldAddNotSuccessLoggerAndRepeatUpdateWhenFootballerIsUpdatingAndPutCalloutFaild() {
        List<Footballer__c> footballers = [SELECT Id FROM Footballer__c];
        List<String> ids = new List<String>();
        for (Footballer__c footballer : footballers) {
            ids.add(footballer.Id);
        }

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new FootballerConnectMock());
        FootballerCalloutsService.makeConnectCallout();
        Test.setMock(HttpCalloutMock.class, new FootballerUnsuccessRESTServiceMock());
        List<Logger__c> loggers = FootballerCalloutsService.makePutCallout(ids);
        Test.stopTest();

        for (Logger__c logger : loggers) {
            System.assert(logger.Success__c == false);
        }
    }

    @IsTest
    private static void shouldDeleteFootballerAndAddSuccessLogger() {
        List<Footballer__c> footballers = [SELECT Id, ExternalId__c, Name, FirstName__c, Birthday__c, Country__c, Team__c, Synchronized__c, SynchronizationCounter__c FROM Footballer__c];

        List<FootballerRestService.FootballerWrapper> footballerWrappers = new List<FootballerRestService.FootballerWrapper>();
        for (Footballer__c footballer : footballers) {
            FootballerRestService.FootballerWrapper footballerWrapper = new FootballerRestService.FootballerWrapper();
            footballerWrapper.id = footballer.Id;
            footballerWrapper.lastName = footballer.Name;
            footballerWrapper.firstName = footballer.FirstName__c;
            footballerWrapper.birthday = footballer.Birthday__c != null ? footballer.Birthday__c.format() : null;
            footballerWrapper.country = footballer.Country__c;
            footballerWrapper.team = footballer.Team__c;
            footballerWrapper.isSynchronized = footballer.Synchronized__c;
            footballerWrapper.synchronizationCounter = footballer.SynchronizationCounter__c;
            footballerWrappers.add(footballerWrapper);
        }

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new FootballerConnectMock());
        FootballerCalloutsService.makeConnectCallout();
        Test.setMock(HttpCalloutMock.class, new FootballerDeleteRESTServiceMock());
        List<Logger__c> loggers = FootballerCalloutsService.makeDeleteCallout(footballerWrappers);
        Test.stopTest();

        for (Logger__c logger : loggers) {
            System.assertEquals(logger.Message__c, 'Success');
        }
    }

    @IsTest
    private static void shouldAddNotSuccessLoggerAndRepeatDeleteWhenFootballerIsDeletingAndConnectionCalloutFaild() {
        Test.setMock(HttpCalloutMock.class, new FootballerUnsuccessRESTServiceMock());
        List<Footballer__c> footballers = [SELECT Id, ExternalId__c, Name, FirstName__c, Birthday__c, Country__c, Team__c, Synchronized__c, SynchronizationCounter__c FROM Footballer__c];

        List<FootballerRestService.FootballerWrapper> footballerWrappers = new List<FootballerRestService.FootballerWrapper>();
        for (Footballer__c footballer : footballers) {
            FootballerRestService.FootballerWrapper footballerWrapper = new FootballerRestService.FootballerWrapper();
            footballerWrapper.id = footballer.Id;
            footballerWrapper.lastName = footballer.Name;
            footballerWrapper.firstName = footballer.FirstName__c;
            footballerWrapper.birthday = footballer.Birthday__c != null ? footballer.Birthday__c.format() : null;
            footballerWrapper.country = footballer.Country__c;
            footballerWrapper.team = footballer.Team__c;
            footballerWrapper.isSynchronized = footballer.Synchronized__c;
            footballerWrapper.synchronizationCounter = footballer.SynchronizationCounter__c;
            footballerWrappers.add(footballerWrapper);
        }

        Test.startTest();
        List<Logger__c> loggers = FootballerCalloutsService.makeDeleteCallout(footballerWrappers);
        Test.stopTest();

        for (Logger__c logger : loggers) {
            System.assert(logger.Success__c == false);
        }
    }

    @IsTest
    private static void shouldAddTwoNotSuccessLoggerAndRepeatDeleteWhenFootballerIsDeletingAndConnectionCalloutFaild() {
        List<Footballer__c> footballers = [SELECT Id, ExternalId__c, Name, FirstName__c, Birthday__c, Country__c, Team__c, Synchronized__c, SynchronizationCounter__c FROM Footballer__c];

        insert new Footballer__c(
                Name = 'Name33',
                FirstName__c = 'FirstName',
                Country__c = '',
                Team__c = 'Team',
                SynchronizationCounter__c = 2
        );

        List<Footballer__c> newFootballers = [SELECT Id, ExternalId__c, Name, FirstName__c, Birthday__c, Country__c, Team__c, Synchronized__c, SynchronizationCounter__c FROM Footballer__c WHERE Name = 'Name33'];

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new FootballerUnsuccessRESTServiceMock());
        delete footballers;
        delete newFootballers;
        Test.stopTest();

        List<DeletedFootballer__c> deletedFootballers = [SELECT Synchronized__c FROM DeletedFootballer__c];
        for (DeletedFootballer__c deletedFootballer: deletedFootballers) {
            System.assertEquals(deletedFootballer.Synchronized__c, false);
        }
    }

    @IsTest
    private static void shouldSynchronizeUnsynchronizedFootballers() {
        Footballer__c footballer = new Footballer__c(
                Name = 'Name',
                FirstName__c = 'FirstName',
                Country__c = '',
                Team__c = 'Team'
        );
        insert footballer;
        Test.setMock(HttpCalloutMock.class, new FootballerRESTServiceMock());

        Test.startTest();
        FootballerSynchronizationService.synchronizeFootballers();
        Test.stopTest();

        List<Footballer__c> footballers = [SELECT Synchronized__C FROM Footballer__c];
        for (Footballer__c synchronizedFootballer: footballers) {
            System.assertEquals(synchronizedFootballer.Synchronized__c, true);
        }
    }


    @isTest
    private static void shouldSuccessfulInsertFootballer() {
        List<FootballerRestService.FootballerWrapper> footballerWrappers = new List<FootballerRestService.FootballerWrapper>();
        Footballer__c footballer = new Footballer__c(Name = 'Name123');
        footballerWrappers.add(FootballerRestService.footballerToWrapper(footballer));

        Test.startTest();
        List<FootballerRestService.Result> results = FootballerRestService.insertFootballers(footballerWrappers);
        Test.stopTest();

        Footballer__c insertedFootballer = [SELECT Id, Name FROM Footballer__c WHERE Name = 'Name123'];
        System.assert(insertedFootballer.Name == 'Name123');
        for (FootballerRestService.Result result : results) {
            System.assert(result.success);
            System.assert(result.message == 'Success');
        }
    }

    @isTest
    private static void shouldFailInsertFootballer() {
        List<FootballerRestService.FootballerWrapper> footballerWrappers = new List<FootballerRestService.FootballerWrapper>();
        Footballer__c footballer = new Footballer__c(FirstName__c = 'FirstName22');
        footballerWrappers.add(FootballerRestService.footballerToWrapper(footballer));

        Test.startTest();
        List<FootballerRestService.Result> results = FootballerRestService.insertFootballers(footballerWrappers);
        Test.stopTest();

        List<Footballer__c> insertedFootballers = [SELECT Id, Name FROM Footballer__c WHERE FirstName__c = 'FirstName22'];
        System.assert(insertedFootballers.isEmpty());
        for (FootballerRestService.Result result : results) {
            System.assert(!result.success);
            System.assert(result.message != 'Success');
            System.assert(result.message == 'Last Name required');
        }
    }

    @isTest
    private static void shouldSuccessfulUpdateFootballer() {
        List<FootballerRestService.FootballerWrapper> footballerWrappers = new List<FootballerRestService.FootballerWrapper>();
        Footballer__c footballerToUpdate = [SELECT Id, ExternalId__c, FirstName__c, Name, Birthday__c, Team__c, Country__c, Synchronized__c, SynchronizationCounter__c FROM Footballer__c LIMIT 1];
        footballerToUpdate.Team__c = 'Team22';
        FootballerRestService.FootballerWrapper footballerWrapperToUpdate = FootballerRestService.footballerToWrapper(footballerToUpdate);
        footballerWrappers.add(footballerWrapperToUpdate);

        Test.startTest();
        List<FootballerRestService.Result> results = FootballerRestService.updateFootballers(footballerWrappers);
        Test.stopTest();

        Footballer__c updatedFootballer = [SELECT Id, FirstName__c, Name, Team__c FROM Footballer__c LIMIT 1];
        System.assert(updatedFootballer.Team__c == 'Team22');
        for (FootballerRestService.Result result : results) {
            System.assert(result.success);
            System.assert(result.message == 'Success');
        }
    }

    @isTest
    private static void shouldFailUpdateFootballer() {
        List<FootballerRestService.FootballerWrapper> footballerWrappers = new List<FootballerRestService.FootballerWrapper>();
        Footballer__c footballerToUpdate = [SELECT Id, ExternalId__c, FirstName__c, Name, Birthday__c, Team__c, Country__c, Synchronized__c, SynchronizationCounter__c FROM Footballer__c LIMIT 1];
        footballerToUpdate.Team__c = 'Team23';
        footballerToUpdate.Name = '';
        FootballerRestService.FootballerWrapper footballerWrappertoUpdate = FootballerRestService.footballerToWrapper(footballerToUpdate);
        footballerWrappers.add(footballerWrappertoUpdate);

        Test.startTest();
        List<FootballerRestService.Result> results = FootballerRestService.updateFootballers(footballerWrappers);
        Test.stopTest();

        Footballer__c updatedFootballer = [SELECT Id, FirstName__c, Name, Team__c FROM Footballer__c LIMIT 1];
        System.assert(updatedFootballer.Team__c != 'Team23');
        for (FootballerRestService.Result result : results) {
            System.assert(!result.success);
            System.assert(result.message == 'Last Name required');
        }
    }

    @isTest
    private static void shouldSuccessfulDeleteFootballer() {
        List<FootballerRestService.FootballerWrapper> footballerWrappers = new List<FootballerRestService.FootballerWrapper>();
        Footballer__c footballerToDelete = [
                SELECT Id, ExternalId__c, FirstName__c, Name, Birthday__c, Team__c, Country__c, Synchronized__c, SynchronizationCounter__c
                FROM Footballer__c
                LIMIT 1
        ];
        FootballerRestService.FootballerWrapper footballerWrapperToDelete = FootballerRestService.footballerToWrapper(footballerToDelete);
        footballerWrappers.add(footballerWrapperToDelete);
        RestRequest restRequest = new RestRequest();
        restRequest.httpMethod = 'DELETE';
        restRequest.requestUri = 'https://web.com';
        restRequest.requestBody = Blob.valueOf('{"footballerWrappers":' + JSON.serialize(footballerWrappers) + '}');
        RestContext.request = restRequest;

        Test.startTest();
        List<FootballerRestService.Result> results = FootballerRestService.deleteFootballers();
        Test.stopTest();

        List<Footballer__c> deletedFootballers = [SELECT Id, FirstName__c, Name, Team__c FROM Footballer__c LIMIT 1];
        System.assert(deletedFootballers.isEmpty());
        for (FootballerRestService.Result result : results) {
            System.assert(result.success);
            System.assert(result.message == 'Success');
        }
    }

    @isTest static void shouldFailDeleteFootballer() {
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com',
                EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                LocaleSidKey='en_US', ProfileId = p.Id,
                TimeZoneSidKey='America/Los_Angeles', UserName='standarduser1fyiwgefyuwgeyuifgweaufiafgui@testorg.com');

        List<FootballerRestService.FootballerWrapper> footballerWrappers = new List<FootballerRestService.FootballerWrapper>();
        Footballer__c footballerToDelete = [
                SELECT Id,ExternalId__c,FirstName__c,Name,Birthday__c,Team__c,Country__c,Synchronized__c,SynchronizationCounter__c
                FROM Footballer__c
                LIMIT 1
        ];
        FootballerRestService.FootballerWrapper footballerWrappertoDelete = FootballerRestService.footballerToWrapper(footballerToDelete);
        footballerWrappers.add(footballerWrappertoDelete);
        RestRequest restRequest = new RestRequest();
        restRequest.httpMethod = 'DELETE';
        restRequest.requestUri ='https://britenet-ba-dev-ed.my.salesforce.com/services/apexrest/Footballer';
        restRequest.requestBody =  Blob.valueOf('{"footballerWrappers":' + JSON.serialize(footballerWrappers) + '}');
        RestContext.request = restRequest;

        System.runAs(u) {
            Test.startTest();
            List<FootballerRestService.Result> results = FootballerRestService.deleteFootballers();
            Test.stopTest();

            List<Footballer__c> deletedFootballers = [SELECT Id,FirstName__c,Name,Team__c FROM Footballer__c LIMIT 1];
            System.assert(!deletedFootballers.isEmpty());
            for (FootballerRestService.Result result : results) {
                System.assert(!result.success);
                System.assert(result.message != 'Success');
            }
        }
    }

    @IsTest
    private static void shouldInsertFootballer() {
        Test.startTest();
        Footballer__c footballer = new Footballer__c(
                Name = 'Name1',
                FirstName__c = 'FirstName1',
                Country__c = '',
                Team__c = 'Team1'
        );
        insert footballer;
        Test.stopTest();
        Footballer__c selectedFootballer = [SELECT Id FROM Footballer__c WHERE Name = 'Name1'];
        System.assertNotEquals(selectedFootballer.Id, '');
    }

    @IsTest
    private static void shouldUpdateFootballer() {
        Footballer__c footballer = new Footballer__c(
                Name = 'Name1',
                FirstName__c = 'FirstName1',
                Country__c = '',
                Team__c = 'Team1',
                ExternalId__c = 'q'
        );
        insert footballer;

        Test.startTest();
        Footballer__c updatedFootballer = [SELECT Id, Team__c FROM Footballer__c WHERE Name = 'Name1'];
        updatedFootballer.Team__c = 'New team';
        update updatedFootballer;
        Test.stopTest();
        Footballer__c selectedFootballer = [SELECT Id, Team__c FROM Footballer__c WHERE Name = 'Name1'];
        System.assertEquals(selectedFootballer.Team__c, 'New team');
    }

    @IsTest
    private static void shouldDeleteFootballer() {
        Footballer__c footballer = new Footballer__c(
                Name = 'Name',
                FirstName__c = 'FirstName',
                Country__c = '',
                Team__c = 'Team'
        );
        insert footballer;
        delete footballer;
    }
}