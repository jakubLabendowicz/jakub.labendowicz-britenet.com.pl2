public with sharing class SearchifyController {
    @AuraEnabled
    public static List<Object> searchTracks(String query, String market, String recordsLimit, String offset, String source) {
        List<Object> objects = new List<Object>();
        objects.addAll(SearchifyService.searchTracks(query, market, recordsLimit, offset, source));
        return objects;
    }

    @AuraEnabled
    public static List<Object> searchArtists(String query, String market, String recordsLimit, String offset, String source) {
        List<Object> objects = new List<Object>();
        objects.addAll(SearchifyService.searchArtists(query, market, recordsLimit, offset, source));
        return objects;
    }

    @AuraEnabled
    public static Track__c getTrack(String spotifyId, String id) {
        return SearchifyService.getTrack(spotifyId, id);
    }

    @AuraEnabled
    public static List<Artist__c> getRelatedArtists(String spotifyId, String id) {
        return SearchifyService.getRelatedArtists(spotifyId, id);
    }

    @AuraEnabled
    public static Artist__c getArtist(String spotifyId, String id) {
        return SearchifyService.getArtist(spotifyId, id);
    }

    @AuraEnabled
    public static List<Track__c> getRelatedTracks(String spotifyId, String id) {
        return SearchifyService.getRelatedTracks(spotifyId, id);
    }

//    SearchifyObject
    @AuraEnabled
    public static Track__c updateTrack(Track__c track) {
        return SearchifyService.updateTrack(track);
    }

    @AuraEnabled
    public static Artist__c updateArtist(Artist__c artist) {
        return SearchifyService.updateArtist(artist);
    }


    @AuraEnabled
    public static Track__c saveTrack(Track__c track) {
        return SearchifyService.saveTrack(track);
    }

    @AuraEnabled
    public static Artist__c saveArtist(Artist__c artist) {
        return SearchifyService.saveArtist(artist);
    }

    @AuraEnabled
    public static Track__c setFavoriteTrack(Track__c track) {
        return SearchifyService.setFavoriteTrack(track);
    }

    @AuraEnabled
    public static Track__c setBlackListTrack(Track__c track) {
        return SearchifyService.setBlackListTrack(track);
    }

//    SearchifyTracksList
    @AuraEnabled
    public static List<Track__c> getFavoriteTracks() {
        return SearchifyService.getFavoriteTracks();
    }

    @AuraEnabled
    public static List<Track__c> getBlackListTracks() {
        return SearchifyService.getBlackListTracks();
    }

//    SearchifyComment
    @AuraEnabled
    public static Comment__c insertComment(Comment__c comment) {
        return SearchifyService.insertComment(comment);
    }

    @AuraEnabled
    public static Comment__c upsertComment(Comment__c comment) {
        return SearchifyService.upsertComment(comment);
    }

    @AuraEnabled
    public static Comment__c deleteComment(Comment__c comment) {
        return SearchifyService.deleteComment(comment);
    }

    @AuraEnabled
    public static List<Comment__c> getComments(String spotifyId, String id) {
        return SearchifyService.getComments(spotifyId, id);
    }

    @AuraEnabled
    public static String getUserId() {
        return UserInfo.getUserId();
    }

    @AuraEnabled
    public static Boolean getShowNewButton(String spotifyId, String id) {
        List<Comment__c> comments = SearchifyService.getComments(spotifyId, id);
        for (Comment__c comment: comments) {
            if (comment.OwnerId == UserInfo.getUserId()) {
                return false;
            }
        }
        return true;
    }

//    SearchifyRate
    @AuraEnabled
    public static Rate__c upsertRate(Rate__c rate) {
        return SearchifyService.upsertRate(rate);
    }

    @AuraEnabled
    public static Rate__c getRate(String spotifyId, String id) {
        return SearchifyService.getRate(spotifyId, id);
    }
}