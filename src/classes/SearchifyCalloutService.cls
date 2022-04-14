public with sharing class SearchifyCalloutService {
    public static HttpResponse makeConnectCallout() {
        try {
            RESTLoginData__c loginData = RESTLoginData__c.getValues('Spotify');
            String requestBody = 'grant_type=client_credentials'
                    + '&client_id=' + loginData.cKey__c
                    + '&client_secret=' + loginData.cSecret__c;

            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setBody(requestBody);
            request.setMethod('POST');
            request.setEndpoint('https://accounts.spotify.com/api/token');
            HttpResponse response = http.send(request);

            SearchifyCalloutResponseWrapper responseWrapper = (SearchifyCalloutResponseWrapper) JSON.deserialize(response.getBody(), SearchifyCalloutResponseWrapper.class);
            String token = responseWrapper.access_token;
            Cache.Org.put('local.Main.accessToken', token);
            return response;
        } catch (Exception e) {
            e.getMessage();
            return new HttpResponse();
        }
    }

    public static HttpResponse makeSearchCallout(String query) {
        String token = (String) Cache.Org.get('local.Main.accessToken');
        query = query.replace(' ', '%20');

        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setMethod('GET');
        request.setEndpoint('https://api.spotify.com/v1/search?q=' + query + '&type=artist%2ctrack');
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        request.setHeader('Authorization', 'Bearer ' + token);
        return http.send(request);
    }

    public static HttpResponse makeSearchTracksCallout(String query, String market, String recordsLimit, String offset) {
        String token = (String) Cache.Org.get('local.Main.accessToken');
        query = query.replace(' ', '%20');

        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setMethod('GET');
        request.setEndpoint('https://api.spotify.com/v1/search?q=' + query + '&type=track&market=' + market + '&limit=' + recordsLimit + '&offset=' + offset);
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        request.setHeader('Authorization', 'Bearer ' + token);
        return http.send(request);
    }

    public static HttpResponse makeSearchArtistsCallout(String query, String market, String recordsLimit, String offset) {
        String token = (String) Cache.Org.get('local.Main.accessToken');
        query = query.replace(' ', '%20');

        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setMethod('GET');
        request.setEndpoint('https://api.spotify.com/v1/search?q=' + query + '&type=artist&market='  + market + '&limit=' + recordsLimit + '&offset=' + offset);
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        request.setHeader('Authorization', 'Bearer ' + token);
        return http.send(request);
    }

    public static HttpResponse makeTrackCallout(String spotifyId) {
        String token = (String) Cache.Org.get('local.Main.accessToken');

        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setMethod('GET');
        request.setEndpoint('https://api.spotify.com/v1/tracks/' + spotifyId);
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        request.setHeader('Authorization', 'Bearer ' + token);
        return http.send(request);
    }

    public static HttpResponse makeRelatedArtistsCallout(String spotifyId) {
        String token = (String) Cache.Org.get('local.Main.accessToken');

        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setMethod('GET');
        request.setEndpoint('https://api.spotify.com/v1/tracks/' + spotifyId);
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        request.setHeader('Authorization', 'Bearer ' + token);
        return http.send(request);
    }

    public static HttpResponse makeArtistCallout(String spotifyId) {
        String token = (String) Cache.Org.get('local.Main.accessToken');

        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setMethod('GET');
        request.setEndpoint('https://api.spotify.com/v1/artists/' + spotifyId);
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        request.setHeader('Authorization', 'Bearer ' + token);
        return http.send(request);
    }

    public static HttpResponse makeRelatedTracksCallout(String spotifyId) {
        String token = (String) Cache.Org.get('local.Main.accessToken');

        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setMethod('GET');
        request.setEndpoint('https://api.spotify.com/v1/artists/' + spotifyId + '/top-tracks?market=PL');
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        request.setHeader('Authorization', 'Bearer ' + token);
        return http.send(request);
    }
}