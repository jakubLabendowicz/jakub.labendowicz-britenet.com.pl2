public with sharing class SearchifyRelatedTracksCalloutWrapper {
    public List<Track> tracks;

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

    public class Track{
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
    }

    public List<Track__c> getTracks() {
        List<Track__c> tracksList = new List<Track__c>();
        for (Track track: tracks) {
            List<String> artistsNames = new List<String>();
            for(Artist artist: track.artists) {
                artistsNames.add(artist.name);
            }
            String artistName = String.join(artistsNames, ', ');

            tracksList.add(
                new Track__c(
                    Name = track.name,
                    SpotifyId__c = track.id,
                    SpotifyUrl__c = track.external_urls.spotify,
                    Popularity__c = track.popularity,
                    DurationMs__c = track.duration_ms,
                    Type__c = track.type,
                    Image__c = track.album.images[0].url,
                    ArtistName__c = artistName
                )
            );
        }
        return tracksList;
    }
}