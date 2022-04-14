public with sharing class SearchifySearchArtistsCalloutWrapper {
    public Artists artists;

    public class ExternalUrls{
        public String spotify;
    }

    public class Followers{
        public Object href;
        public Integer total;
    }

    public class Image{
        public Integer height;
        public String url;
        public Integer width;
    }

    public class Item{
        public ExternalUrls external_urls;
        public Followers followers;
        public List<String> genres;
        public String href;
        public String id;
        public List<Image> images;
        public String name;
        public Integer popularity;
        public String type;
        public String uri;
    }

    public class Artists{
        public String href;
        public List<Item> items;
//        public Integer limit;
        public String next;
        public Integer offset;
        public String previous;
        public Integer total;
    }

    public List<Artist__c> getArtists() {
        List<Artist__c> artistsList = new List<Artist__c>();
        for (Item item: artists.items) {
            artistsList.add(
                new Artist__c(
                    Name = item.name,
                    SpotifyId__c = item.id,
                    SpotifyUrl__c = item.external_urls.spotify,
                    Type__c = item.type,
                    Image__c = item.images.size() >0? item.images[0].url:'',
                    Genres__c = String.join(item.genres, ', ')
                )
            );
        }
        return artistsList;
    }
}