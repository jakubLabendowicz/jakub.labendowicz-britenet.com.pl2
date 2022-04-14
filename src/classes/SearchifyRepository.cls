public with sharing class SearchifyRepository {
//    Track
    public static List<Track__c> selectTracksByQuery(String query) {
        return Database.query('SELECT Id, Name, SpotifyId__c, SpotifyUrl__c, Favorite__c, BlackList__c, Type__c, Image__c, DurationMs__c, Popularity__c, ArtistName__c ' +
                'FROM Track__c ' +
                'WHERE Name LIKE \'%' + query + '%\'');
    }

    public static Track__c selectTrackById(String id) {
        List<Track__c> tracks = [SELECT Id, Name, SpotifyId__c, SpotifyUrl__c, Favorite__c, BlackList__c, Type__c, Image__c, DurationMs__c, Popularity__c FROM Track__c WHERE Id = :id LIMIT 1];
        if (!tracks.isEmpty()) {
            return tracks[0];
        } else {
            return new Track__c();
        }
    }

    public static List<Track__c> selectRelatedTracksById(String id) {
        List<AuthorShip__c> authorShips = [SELECT Id, Track__c, Artist__c FROM AuthorShip__c WHERE Artist__c = :id];
        List<String> tracksIds = new List<String>();
        for(AuthorShip__c authorShip: authorShips) {
            tracksIds.add(authorShip.Track__c);
        }
        return [SELECT Id, Name, SpotifyId__c, SpotifyUrl__c, Favorite__c, BlackList__c, Type__c, Image__c, DurationMs__c, Popularity__c FROM Track__c WHERE Id = :tracksIds];
    }

    public static Track__c selectTrackBySpotifyId(String spotifyId) {
        List<Track__c> tracks = [SELECT Id, Name, SpotifyId__c, SpotifyUrl__c, Favorite__c, BlackList__c, Type__c, Image__c, DurationMs__c, Popularity__c FROM Track__c WHERE SpotifyId__c = :spotifyId LIMIT 1];
        if (!tracks.isEmpty()) {
            return tracks[0];
        } else {
            return new Track__c();
        }
    }

    public static Database.SaveResult insertTrack(Track__c track) {
        return Database.insert(track);
    }

    public static Database.DeleteResult deleteTrack(Track__c track) {
        return Database.delete(track);
    }

    public static Database.UpsertResult upsertTrack(Track__c track) {
        return Database.upsert(track);
    }

    public static List<Track__c> selectFavoriteTracks() {
        return [SELECT Id, Name, SpotifyId__c, SpotifyUrl__c, Favorite__c, BlackList__c, Type__c, Image__c, DurationMs__c, Popularity__c, ArtistName__c FROM Track__c WHERE Favorite__c = true ORDER BY LastModifiedDate DESC];
    }

    public static List<Track__c> selectBlackListTracks() {
        return [SELECT Id, Name, SpotifyId__c, SpotifyUrl__c, Favorite__c, BlackList__c, Type__c, Image__c, DurationMs__c, Popularity__c, ArtistName__c FROM Track__c WHERE BlackList__c = true ORDER BY LastModifiedDate DESC];
    }

//    Artist
    public static List<Artist__c> selectArtistsByQuery(String query) {
        return Database.query('SELECT Id, Name, SpotifyId__c, SpotifyUrl__c, Type__c, Image__c, Genres__c ' +
                'FROM Artist__c ' +
                'WHERE Name LIKE \'%' + query + '%\'');
    }

    public static Artist__c selectArtistById(String id) {
        List<Artist__c> artists = [SELECT Id, Name, SpotifyId__c, SpotifyUrl__c, Type__c, Image__c, Genres__c FROM Artist__c WHERE Id = :id LIMIT 1];
        if (!artists.isEmpty()) {
            return artists[0];
        } else {
            return new Artist__c();
        }
    }

    public static List<Artist__c> selectRelatedArtistsById(String id) {
        List<AuthorShip__c> authorShips = [SELECT Id, Track__c, Artist__c FROM AuthorShip__c WHERE Track__c = :id];
        List<String> artistsIds = new List<String>();
        for(AuthorShip__c authorShip: authorShips) {
            artistsIds.add(authorShip.Artist__c);
        }
        return [SELECT Id, Name, SpotifyId__c, SpotifyUrl__c, Type__c, Image__c, Genres__c FROM Artist__c WHERE Id = :artistsIds];
    }

    public static Artist__c selectArtistBySpotifyId(String spotifyId) {
        List<Artist__c> artists = [SELECT Id, Name, SpotifyId__c, SpotifyUrl__c, Type__c, Image__c, Genres__c FROM Artist__c WHERE SpotifyId__c = :spotifyId LIMIT 1];
        if (!artists.isEmpty()) {
            return artists[0];
        } else {
            return new Artist__c();
        }
    }

    public static Database.SaveResult insertArtist(Artist__c artist) {
        return Database.insert(artist);
    }

    public static Database.DeleteResult deleteArtist(Artist__c artist) {
        return Database.delete(artist);
    }

    public static Database.UpsertResult upsertArtist(Artist__c artist) {
        return Database.upsert(artist);
    }

//    Comment
    public static Database.SaveResult insertComment(Comment__c comment) {
        return Database.insert(comment);
    }

    public static Database.UpsertResult upsertComment(Comment__c comment) {
        return Database.upsert(comment);
    }

    public static Database.DeleteResult deleteComment(Comment__c comment) {
        return Database.delete(comment);
    }

    public static Comment__c selectCommentById(String id) {
        return [SELECT Id, Name, OwnerId, Contents__c, SpotifyId__c, Time__c, User__c  FROM Comment__c WHERE Id = :id LIMIT 1];
    }

    public static List<Comment__c> selectCommentsBySpotifyId(String spotifyId) {
        return [SELECT Id, Name, OwnerId, Contents__c, SpotifyId__c, Time__c, User__c, TrackId__c  FROM Comment__c WHERE SpotifyId__c = :spotifyId ORDER BY LastModifiedDate DESC];
    }

    public static List<Comment__c> selectCommentsByTrackId(String trackId) {
        return [SELECT Id, Name, OwnerId, Contents__c, SpotifyId__c, Time__c, User__c, TrackId__c  FROM Comment__c WHERE TrackId__c = :trackId ORDER BY LastModifiedDate DESC];
    }

    //    Rate
    public static Database.SaveResult insertRate(Rate__c rate) {
        return Database.insert(rate);
    }

    public static Database.UpsertResult upsertRate(Rate__c rate) {
        return Database.upsert(rate);
    }

    public static Rate__c selectRateById(String id) {
        return [SELECT Id, Name, SpotifyId__c, Time__c, Stars__c, TrackId__c FROM Rate__c WHERE Id = :id LIMIT 1];
    }

    public static List<Rate__c> selectRateBySpotifyIdAndOwner(String spotifyId, Id ownerId) {
        return [SELECT Id, Name, SpotifyId__c, Time__c, Stars__c, TrackId__c  FROM Rate__c WHERE SpotifyId__c = :spotifyId AND OwnerId = :ownerId ORDER BY LastModifiedDate DESC LIMIT 1];
    }

    public static List<Rate__c> selectRateByTrackIdAndOwner(String trackId, Id ownerId) {
        return [SELECT Id, Name, SpotifyId__c, Time__c, Stars__c, TrackId__c  FROM Rate__c WHERE TrackId__c = :trackId AND OwnerId = :ownerId ORDER BY LastModifiedDate DESC LIMIT 1];
    }

    public static List<Rate__c> selectRatesBySpotifyId(String spotifyId) {
        return [SELECT Id, Name, SpotifyId__c, Time__c, Stars__c, TrackId__c  FROM Rate__c WHERE SpotifyId__c = :spotifyId ORDER BY LastModifiedDate DESC LIMIT 1];
    }

    public static List<Rate__c> selectRatesByTrackId(String trackId) {
        return [SELECT Id, Name, SpotifyId__c, Time__c, Stars__c, TrackId__c  FROM Rate__c WHERE TrackId__c = :trackId ORDER BY LastModifiedDate DESC LIMIT 1];
    }
}