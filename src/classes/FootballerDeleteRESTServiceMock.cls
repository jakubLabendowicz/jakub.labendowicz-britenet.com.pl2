@isTest
global class FootballerDeleteRESTServiceMock implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest request) {
        FootballerRestService.Request requestBody = (FootballerRestService.Request) JSON.deserialize(request.getBody(), FootballerRestService.Request.class);
        List<FootballerRestService.FootballerWrapper> footballerWrappers = requestBody.footballerWrappers;
        List<String> messages = new List<String>();
        for (FootballerRestService.FootballerWrapper footballerWrapper: footballerWrappers) {
            messages.add('Success');
        }

        List<FootballerRestService.Result> results = FootballerRestService.resultsBuilder(messages, footballerWrappers);
        String responseBody = JSON.serialize(results);

        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody(responseBody);
        response.setStatusCode(200);
        return response;
    }
}