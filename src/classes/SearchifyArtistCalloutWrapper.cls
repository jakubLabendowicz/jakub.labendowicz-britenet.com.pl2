public with sharing class SearchifyArtistCalloutWrapper {
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

    public Artist__c getArtist() {
        return new Artist__c(
            Name = name,
            SpotifyId__c = id,
            SpotifyUrl__c = external_urls.spotify,
            Type__c = type,
            Image__c = images[0].url,
            Genres__c = String.join(genres, ', ')
        );
    }
}