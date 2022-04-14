public with sharing class SearchifyTrackCalloutWrapper {
    public Album album;
    public List<Artist> artists;
    public Integer disc_number;
    public Integer duration_ms;
    public boolean explicit;
    public ExternalIds external_ids;
    public ExternalUrls external_urls;
    public String href;
    public String id;
    public boolean is_local;
    public boolean is_playable;
    public String name;
    public Integer popularity;
    public String preview_url;
    public Integer track_number;
    public String type;
    public String uri;

    public class ExternalUrls{
        public String spotify;
    }

    public class Artist{
        public ExternalUrls external_urls;
        public String href;
        public String id;
        public String name;
        public String type;
        public String uri;
    }

    public class Image{
        public Integer height;
        public String url;
        public Integer width;
    }

    public class Album{
        public String album_type;
        public List<Artist> artists;
        public ExternalUrls external_urls;
        public String href;
        public String id;
        public List<Image> images;
        public String name;
        public String release_date;
        public String release_date_precision;
        public Integer total_tracks;
        public String type;
        public String uri;
    }

    public class ExternalIds{
        public String isrc;
    }

    public Track__c getTrack() {
        List<String> artistsNames = new List<String>();
        for(Artist artist: artists) {
            artistsNames.add(artist.name);
        }
        String artistName = String.join(artistsNames, ', ');
        return new Track__c(
            Name = name,
            SpotifyId__c = id,
            SpotifyUrl__c = external_urls.spotify,
            Popularity__c = popularity,
            DurationMs__c = duration_ms,
            Type__c = type,
            Image__c = album.images[0].url,
            ArtistName__c = artistName
        );
    }

    public List<Artist__c> getArtists() {
        List<Artist__c> artistsList = new List<Artist__c>();
        for (Artist artist: artists) {
            artistsList.add(
                new Artist__c(
                    Name = artist.name,
                    SpotifyId__c = artist.id,
                    SpotifyUrl__c = artist.external_urls.spotify,
                    Type__c = artist.type
                )
            );
        }
        return artistsList;
    }
}