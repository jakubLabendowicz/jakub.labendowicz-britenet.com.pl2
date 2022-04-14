public with sharing class SearchifyCalloutResponseWrapper {
    public String access_token;
    public String token_type;
    public String expires_in;

//    public Artists artists;
//    public Tracks tracks;
//
//    public class ExternalUrls{
//        public String spotify;
//    }
//
//    public class Followers{
//        public Object href;
//        public Integer total;
//    }
//
//    public class Image{
//        public Integer height;
//        public String url;
//        public Integer width;
//    }
//
//    public class Item{
//        public ExternalUrls external_urls;
//        public Followers followers;
//        public List<String> genres;
//        public String href;
//        public String id;
//        public List<Image> images;
//        public String name;
//        public Integer popularity;
//        public String type;
//        public String uri;
//        public Album album;
//        public List<Artists> artists;
//        public Integer disc_number;
//        public Integer duration_ms;
//        public boolean explicit;
//        public ExternalIds external_ids;
//        public boolean is_local;
//        public boolean is_playable;
//        public String preview_url;
//        public Integer track_number;
//    }
//
//    public class Artists{
//        public String href;
//        public List<Item> items;
////        public Integer limit;
//        public Object next;
//        public Integer offset;
//        public Object previous;
//        public Integer total;
//        public ExternalUrls external_urls;
//        public String id;
//        public String name;
//        public String type;
//        public String uri;
//    }
//
//    public class Album{
//        public String album_type;
//        public List<Artists> artists;
//        public ExternalUrls external_urls;
//        public String href;
//        public String id;
//        public List<Image> images;
//        public String name;
//        public String release_date;
//        public String release_date_precision;
//        public Integer total_tracks;
//        public String type;
//        public String uri;
//    }
//
//    public class ExternalIds{
//        public String isrc;
//    }
//
//    public class Tracks{
//        public String href;
//        public List<Item> items;
////        public Integer limit;
//        public String next;
//        public Integer offset;
//        public Object previous;
//        public Integer total;
//    }
//
//    public List<Track__c> getTracks() {
//        List<Track__c> tracksList = new List<Track__c>();
//        for (Item item: tracks.items) {
//
//            List<String> artistsNames = new List<String>();
//            for(Artists artist: item.artists) {
//                artistsNames.add(artist.name);
//            }
//            String artistName = String.join(artistsNames, ', ');
//
//            tracksList.add(
//                new Track__c(
//                    Name = item.name,
//                    SpotifyId__c = item.id,
//                    SpotifyUrl__c = item.external_urls.spotify,
//                    Popularity__c = item.popularity,
//                    DurationMs__c = item.duration_ms,
//                    Type__c = item.type,
//                    Image__c = item.album.images[0].url,
//                    ArtistName__c = artistName
//                )
//            );
//        }
//        return tracksList;
//    }
//
//    public List<Artist__c> getArtists() {
//        List<Artist__c> artistsList = new List<Artist__c>();
//        for (Item item: artists.items) {
//            artistsList.add(
//                new Artist__c(
//                    Name = item.name,
//                    SpotifyId__c = item.id,
//                    SpotifyUrl__c = item.external_urls.spotify,
//                    Type__c = item.type,
//                    Image__c = item.images[0].url
//                )
//            );
//        }
//        return artistsList;
//    }
//
//    public List<Object> getObjects() {
//        List<Object> objects = new List<Object>();
//        objects.addAll(getArtists());
//        objects.addAll(getTracks());
//        return objects;
//    }
}