public with sharing class SearchifyService {
    public static List<Object> searchTracks(String query, String market, String recordsLimit, String offset, String source) {
        if(source == 'Spotify') {
            HttpResponse connectResponse = SearchifyCalloutService.makeConnectCallout();
            HttpResponse response = SearchifyCalloutService.makeSearchTracksCallout(query, market, recordsLimit, offset);

            SearchifySearchTracksCalloutWrapper responseWrapper = (SearchifySearchTracksCalloutWrapper) JSON.deserialize(response.getBody(), SearchifySearchTracksCalloutWrapper.class);
            List<Object> objects = responseWrapper.getTracks();
            return objects;
        } else {
            return SearchifyRepository.selectTracksByQuery(query);
        }
    }

    public static List<Object> searchArtists(String query, String market, String recordsLimit, String offset, String source) {
        if(source == 'Spotify') {
            HttpResponse connectResponse = SearchifyCalloutService.makeConnectCallout();
            HttpResponse response = SearchifyCalloutService.makeSearchArtistsCallout(query, market, recordsLimit, offset);

            SearchifySearchArtistsCalloutWrapper responseWrapper = (SearchifySearchArtistsCalloutWrapper) JSON.deserialize(response.getBody(), SearchifySearchArtistsCalloutWrapper.class);
            List<Object> objects = responseWrapper.getArtists();
            return objects;
        } else {
            return SearchifyRepository.selectArtistsByQuery(query);
        }
    }


    public static Track__c getTrack(String spotifyId, String id) {
        if(spotifyId !='' && spotifyId !=null) {
            HttpResponse connectResponse = SearchifyCalloutService.makeConnectCallout();
            HttpResponse response = SearchifyCalloutService.makeTrackCallout(spotifyId);

            SearchifyTrackCalloutWrapper responseWrapper = (SearchifyTrackCalloutWrapper) JSON.deserialize(response.getBody(), SearchifyTrackCalloutWrapper.class);
            Track__c track = responseWrapper.getTrack();
            return track;
        } else {
            return SearchifyRepository.selectTrackById(id);
        }
    }

    public static List<Artist__c> getRelatedArtists(String spotifyId, String id) {
        if(spotifyId !='' && spotifyId !=null) {
            HttpResponse connectResponse = SearchifyCalloutService.makeConnectCallout();
            HttpResponse response = SearchifyCalloutService.makeRelatedArtistsCallout(spotifyId);

            SearchifyTrackCalloutWrapper responseWrapper = (SearchifyTrackCalloutWrapper) JSON.deserialize(response.getBody(), SearchifyTrackCalloutWrapper.class);
            List<Artist__c> artists = responseWrapper.getArtists();
            return artists;
        } else {
            return SearchifyRepository.selectRelatedArtistsById(id);
        }
    }

    public static Artist__c getArtist(String spotifyId, String id) {
        if(spotifyId !='' && spotifyId !=null) {
            HttpResponse connectResponse = SearchifyCalloutService.makeConnectCallout();
            HttpResponse response = SearchifyCalloutService.makeArtistCallout(spotifyId);

            SearchifyArtistCalloutWrapper responseWrapper = (SearchifyArtistCalloutWrapper) JSON.deserialize(response.getBody(), SearchifyArtistCalloutWrapper.class);
            Artist__c artist = responseWrapper.getArtist();
            return artist;
        } else {
            return SearchifyRepository.selectArtistById(id);
        }
    }

    public static List<Track__c> getRelatedTracks(String spotifyId, String id) {
        if(spotifyId !='' && spotifyId !=null) {
            HttpResponse connectResponse = SearchifyCalloutService.makeConnectCallout();
            HttpResponse response = SearchifyCalloutService.makeRelatedTracksCallout(spotifyId);

            SearchifyRelatedTracksCalloutWrapper responseWrapper = (SearchifyRelatedTracksCalloutWrapper) JSON.deserialize(response.getBody(), SearchifyRelatedTracksCalloutWrapper.class);
            List<Track__c> tracks = responseWrapper.getTracks();
            return tracks;
        } else {
            return SearchifyRepository.selectRelatedTracksById(id);
        }
    }





    public static Track__c saveTrack(Track__c track) {
        if(track.SpotifyId__c !='' && track.SpotifyId__c !=null) {
            Track__c localTrack = SearchifyRepository.selectTrackBySpotifyId(track.SpotifyId__c);
            if (localTrack.Id == null) {
                track.Id = null;
                Database.SaveResult saveResult = SearchifyRepository.insertTrack(track);
                track.Id = saveResult.id;
            } else {
                Database.DeleteResult deleteResult = SearchifyRepository.deleteTrack(localTrack);
                track.Id = null;
                track.Favorite__c = false;
                track.BlackList__c = false;
            }
        } else {
            Database.DeleteResult deleteResult = SearchifyRepository.deleteTrack(track);
            track.Id = null;
            track.Favorite__c = false;
            track.BlackList__c = false;
        }
        return track;
    }

    public static Artist__c saveArtist(Artist__c artist) {
        if(artist.SpotifyId__c !='' && artist.SpotifyId__c !=null) {
            Artist__c localArtist = SearchifyRepository.selectArtistBySpotifyId(artist.SpotifyId__c);
            if (localArtist.Id == null) {
                artist.Id = null;
                Database.SaveResult saveResult = SearchifyRepository.insertArtist(artist);
                artist.Id = saveResult.id;
            } else {
                Database.DeleteResult deleteResult = SearchifyRepository.deleteArtist(localArtist);
                artist.Id = null;
            }
        } else {
            Database.DeleteResult deleteResult = SearchifyRepository.deleteArtist(artist);
            artist.Id = null;
        }
        return artist;
    }





    public static Track__c updateTrack(Track__c track) {
        if(track.SpotifyId__c !='' && track.SpotifyId__c !=null) {
            Track__c localTrack = SearchifyRepository.selectTrackBySpotifyId(track.SpotifyId__c);
            if (localTrack.Id != null) {
                track.Id = localTrack.Id;
                track.Favorite__c = localTrack.Favorite__c;
                track.BlackList__c = localTrack.BlackList__c;
            }

            List<Rate__c> rates = SearchifyRepository.selectRatesBySpotifyId(track.SpotifyId__c);
            if (!rates.isEmpty()) {
                Double stars = 0;
                Double rateSum = 0;
                for (Rate__c rate : rates) {
                    rateSum = rateSum + rate.Stars__c;
                }
                stars = rateSum/Double.valueOf(rates.size());
                track.Rate__c = stars;
            }
        } else {
            Track__c localTrack = SearchifyRepository.selectTrackById(track.Id);
            if (localTrack.Id != null) {
                track.Id = localTrack.Id;
                track.Favorite__c = localTrack.Favorite__c;
                track.BlackList__c = localTrack.BlackList__c;
            }

            List<Rate__c> rates = SearchifyRepository.selectRatesByTrackId(track.Id);
            if (!rates.isEmpty()) {
                Double stars = 0;
                Double rateSum = 0;
                for (Rate__c rate : rates) {
                    rateSum = rateSum + rate.Stars__c;
                }
                stars = rateSum/Double.valueOf(rates.size());
                track.Rate__c = stars;
            }
        }
        return track;
    }

    public static Artist__c updateArtist(Artist__c artist) {
        if(artist.SpotifyId__c !='' && artist.SpotifyId__c !=null) {
            Artist__c localArtist = SearchifyRepository.selectArtistBySpotifyId(artist.SpotifyId__c);
            if (localArtist.Id != null) {
                artist.Id = localArtist.Id;
            }
        } else {
            Artist__c localArtist = SearchifyRepository.selectArtistById(artist.Id);
            if (localArtist.Id != null) {
                artist.Id = localArtist.Id;
            }
        }
        return artist;
    }

    public static Track__c setFavoriteTrack(Track__c track) {
        if(track.SpotifyId__c !='' && track.SpotifyId__c !=null) {
            Track__c localTrack = SearchifyRepository.selectTrackBySpotifyId(track.SpotifyId__c);
            if (localTrack.Id == null) {
                track.Favorite__c = true;
                track.Id = null;
                Database.SaveResult saveResult = SearchifyRepository.insertTrack(track);
                track.Id = saveResult.id;
            } else if (localTrack.Favorite__c == false) {
                localTrack.Favorite__c = true;
                track.Favorite__c = true;
                Database.UpsertResult upsertResult = SearchifyRepository.upsertTrack(localTrack);
            } else if (localTrack.Favorite__c == true) {
                localTrack.Favorite__c = false;
                track.Favorite__c = false;
                Database.UpsertResult upsertResult = SearchifyRepository.upsertTrack(localTrack);
            }
        } else if (track.Favorite__c == false) {
            track.Favorite__c = true;
            Database.UpsertResult upsertResult = SearchifyRepository.upsertTrack(track);
        } else if (track.Favorite__c == true) {
            track.Favorite__c = false;
            Database.UpsertResult upsertResult = SearchifyRepository.upsertTrack(track);
        }
        return track;
    }

    public static Track__c setBlackListTrack(Track__c track) {
        if(track.SpotifyId__c !='' && track.SpotifyId__c !=null) {
            Track__c localTrack = SearchifyRepository.selectTrackBySpotifyId(track.SpotifyId__c);
            if (localTrack.Id == null) {
                track.BlackList__c = true;
                track.Id = null;
                Database.SaveResult saveResult = SearchifyRepository.insertTrack(track);
                track.Id = saveResult.id;
            } else if (localTrack.BlackList__c == false) {
                localTrack.BlackList__c = true;
                track.BlackList__c = true;
                Database.UpsertResult upsertResult = SearchifyRepository.upsertTrack(localTrack);
            } else if (localTrack.BlackList__c == true) {
                localTrack.BlackList__c = false;
                track.BlackList__c = false;
                Database.UpsertResult upsertResult = SearchifyRepository.upsertTrack(localTrack);
            }
        } else if (track.BlackList__c == false) {
            track.BlackList__c = true;
            Database.UpsertResult upsertResult = SearchifyRepository.upsertTrack(track);
        } else if (track.BlackList__c == true) {
            track.BlackList__c = false;
            Database.UpsertResult upsertResult = SearchifyRepository.upsertTrack(track);
        }
        return track;
    }

    public static List<Track__c> getFavoriteTracks() {
        return SearchifyRepository.selectFavoriteTracks();
    }

    public static List<Track__c> getBlackListTracks() {
        return SearchifyRepository.selectBlackListTracks();
    }




//    Comments
    public static Comment__c insertComment(Comment__c comment) {
        comment.User__c = UserInfo.getName();
        comment.Time__c = Datetime.now();
        Database.SaveResult saveResult = SearchifyRepository.insertComment(comment);
        comment.Id = saveResult.id;
        return comment;
    }

    public static Comment__c upsertComment(Comment__c comment) {
        Database.UpsertResult upsertResult = SearchifyRepository.upsertComment(comment);
        return comment;
    }

    public static Comment__c deleteComment(Comment__c comment) {
        Database.DeleteResult deleteResult = SearchifyRepository.deleteComment(comment);
        comment.Id = null;
        return comment;
    }

    public static List<Comment__c> getComments(String spotifyId, String id) {
        if(spotifyId !='' && spotifyId !=null) {
            return SearchifyRepository.selectCommentsBySpotifyId(spotifyId);
        } else {
            return SearchifyRepository.selectCommentsByTrackId(id);
        }
    }

//    Rate
    public static Rate__c upsertRate(Rate__c rate) {
        Database.UpsertResult upsertResult = SearchifyRepository.upsertRate(rate);
        rate.Id = upsertResult.id;
        return rate;
    }

    public static Rate__c getRate(String spotifyId, String id) {
        if(spotifyId !='' && spotifyId !=null) {
            List<Rate__c> rates = SearchifyRepository.selectRateBySpotifyIdAndOwner(spotifyId, UserInfo.getUserId());
            if(!rates.isEmpty()) {
                Rate__c rate = rates[0];
                rate.SpotifyId__c = spotifyId;
                return rate;
            } else {
                return  new Rate__c();
            }
        } else {
            List<Rate__c> rates = SearchifyRepository.selectRateByTrackIdAndOwner(id, UserInfo.getUserId());
            if(!rates.isEmpty()) {
                Rate__c rate = rates[0];
                rate.SpotifyId__c = spotifyId;
                return rate;
            } else {
                return  new Rate__c();
            }
        }
    }
}