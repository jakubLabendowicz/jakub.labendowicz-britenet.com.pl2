@isTest
global class FootballerConnectMock implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest request) {
        String responseBody = '{"access_token": "00D7Q000000I1H7!AREAQJpuTa.HXw2RflbyJqyWjGsEZjmH.HRs8MiNrYAcHx0dCS7GwdUd.s8JT0qn_J350seNFFoOlDlHC.L_Y30KhPcrk6mb","instance_url": "https://britenetspkazoo-dev-ed.my.salesforce.com","id": "https://login.salesforce.com/id/00D7Q000000I1H7UAK/0057Q000000EA0JQAW","token_type": "Bearer","issued_at": "1643466353654","signature": "DPNBOP4mifEDRk77jT9qDTDGshBpg47IuPd1VKW9SGo="}';
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody(responseBody);
        response.setStatusCode(200);
        return response;
    }
}