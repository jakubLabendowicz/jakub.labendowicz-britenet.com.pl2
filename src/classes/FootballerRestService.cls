@RestResource(urlMapping='/Footballer/*')
global class FootballerRestService {

    @HttpPost
    global static List<Result> insertFootballers(List<footballerWrapper> footballerWrappers) {
        return FootballerRestRepository.insertFootballers(footballerWrappers);
    }

    @HttpPut
    global static List<Result> updateFootballers(List<FootballerWrapper> footballerWrappers) {
        List<Database.SaveResult> saveResults = FootballerRestRepository.updateFootballers(footballerWrappers);
        List<String> messages = getMessagesFromSaveResults(saveResults);
        return resultsBuilder(messages, footballerWrappers);
    }

    @HttpDelete
    global static List<Result> deleteFootballers() {
        RestRequest restRequest = RestContext.request;
        Blob requestBlob = restRequest.requestBody;
        String requestBody = requestBlob.toString();
        Request request = (Request) JSON.deserialize(requestBody, Request.class);
        List<FootballerWrapper> footballerWrappers = request.footballerWrappers;
        List<Database.DeleteResult> deleteResults = FootballerRestRepository.deleteFootballers(footballerWrappers);
        List<String> messages = new List<String>();
        for (Database.DeleteResult deleteResult: deleteResults) {
            if (deleteResult.success == true) {
                messages.add(System.Label.Success);
            } else {
                messages.add(deleteResult.errors[0].message);
            }
        }
        return resultsBuilder(messages, footballerWrappers);
    }

    static public List<String> getMessagesFromSaveResults(List<Database.SaveResult> saveResults) {
        List<String> messages = new List<String>();
        for (Database.SaveResult saveResult: saveResults) {
            if (saveResult.success == true) {
                messages.add(System.Label.Success);
            } else {
                messages.add(saveResult.errors[0].message);
            }
        }
        return messages;
    }

    static public List<Result> resultsBuilder(List<String> messages, List<FootballerWrapper> footballerWrappers) {
        List<Result> results = new List<Result>();
        Integer index = 0;
        for (FootballerWrapper footballerWrapper: footballerWrappers) {
            Result result = new Result();
            result.resultDate = Date.today().format();
            result.user = UserInfo.getName();
            result.message = messages[index];
            if (messages[index] == System.Label.Success) {
                result.success = true;
            } else {
                result.success = false;
            }
            result.footballerWrapper = footballerWrappers[index];
            results.add(result);
            index++;
        }
        return results;
    }

    static public footballer__c wrapperToFootballer(FootballerWrapper footballerWrapper) {
        Footballer__c footballer = new Footballer__c();
        footballer.ExternalId__c = footballerWrapper.id;
        footballer.Name = footballerWrapper.lastName;
        footballer.FirstName__c = footballerWrapper.firstName;
        footballer.Birthday__c = footballerWrapper.birthday != null? Date.parse(footballerWrapper.birthday) : null;
        footballer.Country__c = footballerWrapper.country;
        footballer.Team__c = footballerWrapper.team;
        footballer.Synchronized__c = footballerWrapper.isSynchronized;
        footballer.SynchronizationCounter__c = footballerWrapper.synchronizationCounter;
        return footballer;
    }

    static public footballerWrapper footballerToWrapper(Footballer__c footballer) {
        FootballerWrapper footballerWrapper = new FootballerWrapper();
        footballerWrapper.id = footballer.ExternalId__c;
        footballerWrapper.externalId = footballer.Id;
        footballerWrapper.lastName = footballer.Name;
        footballerWrapper.firstName = footballer.FirstName__c;
        footballerWrapper.birthday = footballer.Birthday__c!=null? footballer.Birthday__c.format():null;
        footballerWrapper.country = footballer.Country__c;
        footballerWrapper.team = footballer.Team__c;
        footballerWrapper.isSynchronized = footballer.Synchronized__c;
        footballerWrapper.synchronizationCounter = footballer.SynchronizationCounter__c;
        return footballerWrapper;
    }

    global class FootballerWrapper {
        global String id { get; set; }
        global String externalId { get; set; }
        global String lastName { get; set; }
        global String firstName { get; set; }
        global String birthday { get; set; }
        global String country { get; set; }
        global String team { get; set; }
        global Boolean isSynchronized { get; set; }
        global Decimal synchronizationCounter { get; set; }
    }

    global class Result {
        global FootballerWrapper footballerWrapper;
        global String message;
        global Boolean success;
        global String resultDate;
        global String user;
    }

    global class Request {
        global List<FootballerWrapper> footballerWrappers;
    }
}