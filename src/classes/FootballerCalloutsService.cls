public class FootballerCalloutsService {
    public static void makeConnectCallout() {
        try {
            RESTCallout__c restCallout = RESTCallout__c.getValues('Connect');
            RESTLoginData__c loginData = RESTLoginData__c.getValues('RestAuth');
            String requestBody = 'grant_type=password&client_id=' + loginData.cKey__c
                    + '&client_secret=' + loginData.cSecret__c
                    + '&username=' + loginData.uName__c
                    + '&password=' + loginData.passwd__c;

            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setBody(requestBody);
            request.setMethod(restCallout.Method__c);
            request.setEndpoint('callout:makeConnectCallout');
            HttpResponse response = http.send(request);

            FootballerUtils.ResponseWrapper responseWrapper = (FootballerUtils.ResponseWrapper) JSON.deserialize(response.getBody(), FootballerUtils.ResponseWrapper.class);
            String token = responseWrapper.access_token;
            Cache.Org.put('local.Main.token', token);
        } catch (Exception e) {
            e.getMessage();
        }
    }

    public static List<Logger__c> makePostCallout(List<String> ids) {
        FootballerRestService.Request footballerRequest = new FootballerRestService.Request();
        List<FootballerRestService.FootballerWrapper> footballerWrappers = FootballerUtils.selectFootballerWrappersByIds(ids);
        footballerRequest.footballerWrappers = footballerWrappers;
        String requestBody = JSON.serialize(footballerRequest);
        RESTCallout__c restCallout = RESTCallout__c.getValues('Post');
        String token = (String) Cache.Org.get('local.Main.token');

        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('callout:makeCallout');
        request.setMethod(restCallout.Method__c);
        request.setHeader('Authorization', 'Bearer ' + token);
        request.setHeader('Content-Type', restCallout.ContentType__c);
        request.setBody(requestBody);

        HttpResponse response;
        String responseBody = '';
        List<FootballerRestService.Result> results;
        try{
            response = http.send(request);
            responseBody = response.getBody();
            results = (List<FootballerRestService.Result>) JSON.deserialize(response.getBody(), List<FootballerRestService.Result>.class);
        } catch (Exception e) {
            results = new List<FootballerRestService.Result>();
            for (FootballerRestService.FootballerWrapper footballerWrapper: footballerWrappers) {
                FootballerRestService.Result result = new FootballerRestService.Result();
                FootballerRestService.FootballerWrapper newFootballerWrapper = new FootballerRestService.FootballerWrapper();
                result.footballerWrapper = newFootballerWrapper;
                result.footballerWrapper.id = footballerWrapper.id;
                result.success = false;
                result.message = e.getMessage();
                results.add(result);
            }
        }

        List<Logger__c> loggers = LoggerService.insertLogger(restCallout.Action__c, requestBody, responseBody, results, footballerWrappers);
        FootballerUtils.updateFootballers(results);
        return loggers;
    }

    public static List<Logger__c> makePutCallout(List<String> ids) {
        FootballerRestService.Request footballerRequest = new FootballerRestService.Request();
        List<FootballerRestService.FootballerWrapper> footballerWrappers = FootballerUtils.selectFootballerWrappersByIds(ids);
        footballerRequest.footballerWrappers = footballerWrappers;
        String requestBody = JSON.serialize(footballerRequest);
        RESTCallout__c restCallout = RESTCallout__c.getValues('Put');
        String token = (String) Cache.Org.get('local.Main.token');

        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('callout:makeCallout');
        request.setMethod(restCallout.Method__c);
        request.setHeader('Authorization', 'Bearer ' + token);
        request.setHeader('Content-Type', restCallout.ContentType__c);
        request.setBody(requestBody);

        HttpResponse response;
        String responseBody = '';
        List<FootballerRestService.Result> results;
        try{
            response = http.send(request);
            responseBody = response.getBody();
            results = (List<FootballerRestService.Result>) JSON.deserialize(response.getBody(), List<FootballerRestService.Result>.class);
        } catch (Exception e) {
            results = new List<FootballerRestService.Result>();
            Integer index = 0;
            for (FootballerRestService.FootballerWrapper footballerWrapper: footballerWrappers) {
                FootballerRestService.Result result = new FootballerRestService.Result();
                FootballerRestService.FootballerWrapper newFootballerWrapper = new FootballerRestService.FootballerWrapper();
                result.footballerWrapper = newFootballerWrapper;
                result.footballerWrapper.id = footballerWrapper.id;
                result.footballerWrapper.externalId = footballerWrappers.get(index).externalId;
                result.success = false;
                result.message = e.getMessage();
                results.add(result);
                index++;
            }
        }

        List<Logger__c> loggers = LoggerService.insertLogger(restCallout.Action__c, requestBody, responseBody, results, footballerWrappers);
        FootballerUtils.updateFootballers(results);
        return loggers;
    }

    public static List<Logger__c> makeDeleteCallout(List<FootballerRestService.FootballerWrapper> footballerWrappers) {
        FootballerRestService.Request footballerRequest = new FootballerRestService.Request();
        footballerRequest.footballerWrappers = footballerWrappers;
        String requestBody = JSON.serialize(footballerRequest);
        RESTCallout__c restCallout = RESTCallout__c.getValues('Delete');
        String token = (String) Cache.Org.get('local.Main.token');
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('callout:makeCallout');
        request.setMethod(restCallout.Method__c);
        request.setHeader('Authorization', 'Bearer ' + token);
        request.setHeader('Content-Type', restCallout.ContentType__c);
        request.setBody(requestBody);

        HttpResponse response;
        String responseBody = '';
        List<FootballerRestService.Result> results;
        try{
            response = http.send(request);
            responseBody = response.getBody();
            results = (List<FootballerRestService.Result>) JSON.deserialize(response.getBody(), List<FootballerRestService.Result>.class);
            DeletedFootballerService.deleteDeletedFootballerByResults(results);
        } catch (Exception e) {
            e.getMessage();
            results = new List<FootballerRestService.Result>();
            Integer index = 0;
            for (FootballerRestService.FootballerWrapper footballerWrapper: footballerWrappers) {
                FootballerRestService.Result result = new FootballerRestService.Result();
                FootballerRestService.FootballerWrapper newFootballerWrapper = new FootballerRestService.FootballerWrapper();
                result.footballerWrapper = newFootballerWrapper;
                result.footballerWrapper.id = footballerWrapper.id;
                result.footballerWrapper.externalId = footballerWrappers.get(index).externalId;
                result.success = false;
                result.message = e.getMessage();
                results.add(result);
                index++;
            }
        }
        List<Logger__c> loggers = LoggerService.insertLogger(restCallout.Action__c, requestBody, responseBody, results, footballerWrappers);
        return loggers;
    }
}