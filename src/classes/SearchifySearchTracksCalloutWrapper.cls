public with sharing class SearchifySearchTracksCalloutWrapper {
    public Tracks tracks;

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

    public class Item{
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

    public class Tracks{
        public String href;
        public List<Item> items;
//        public Integer limit;
        public String next;
        public Integer offset;
        public String previous;
        public Integer total;
    }

    public List<Track__c> getTracks() {
        List<Track__c> tracksList = new List<Track__c>();
        for (Item item: tracks.items) {
            List<String> artistsNames = new List<String>();
            for(Artist artist: item.artists) {
                artistsNames.add(artist.name);
            }
            String artistName = String.join(artistsNames, ', ');

            tracksList.add(
                new Track__c(
                    Name = item.name,
                    SpotifyId__c = item.id,
                    SpotifyUrl__c = item.external_urls.spotify,
                    Popularity__c = item.popularity,
                    DurationMs__c = item.duration_ms,
                    Type__c = item.type,
                    Image__c = item.album.images[0].url,
                    ArtistName__c = artistName
                )
            );
        }
        return tracksList;
    }
}