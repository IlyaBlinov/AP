//
//  IBFileManager.m
//  Retrowave Player
//
//  Created by eastwood on 30/06/2017.
//  Copyright © 2017 Илья Блинов. All rights reserved.
//

#import "IBFileManager.h"

@implementation IBFileManager



+ (IBFileManager*) sharedManager{
    
    static IBFileManager *manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[IBFileManager alloc] init];
    });
    
    return manager;
    
}





- (NSDictionary*) getSongsAndTitleFor:(IBSongsViewType) type{
    
    NSString *title;
    NSArray *songs;
    
    
   
    
    
    
    if (type == allSongs ) {
        title = @"All Media";
        
        MPMediaQuery *songsQuery = [MPMediaQuery songsQuery];
        songs = [songsQuery items];
        
        
    }else if (type == album){
        MPMediaItem     *currentAlbum    = [[IBCurrentParametersManager sharedManager] album];
        title = [currentAlbum valueForProperty:MPMediaItemPropertyAlbumTitle];
        
        MPMediaPropertyPredicate *albumNamePredicate =
        [MPMediaPropertyPredicate predicateWithValue: title
                                         forProperty: MPMediaItemPropertyAlbumTitle];
        
        MPMediaQuery *songsOfAlbum = [[MPMediaQuery alloc] init];
        [songsOfAlbum addFilterPredicate:albumNamePredicate];
        
        
        songs = [songsOfAlbum items];
        
        
    }else if (type == artist){
        MPMediaItem     *currentArtist   = [[IBCurrentParametersManager sharedManager] artist];
        NSString *artistName = [currentArtist valueForProperty:MPMediaItemPropertyArtist];
        title = artistName;
        
        MPMediaPropertyPredicate *artistNamePredicate =
        [MPMediaPropertyPredicate predicateWithValue: title
                                         forProperty: MPMediaItemPropertyArtist];
        
        MPMediaQuery *songsOfArtist = [[MPMediaQuery alloc] init];
        [songsOfArtist addFilterPredicate:artistNamePredicate];
        
        
        songs = [songsOfArtist items];
        
        
    }else if (type == playlist){
        MPMediaPlaylist *currentPlaylist = [[IBCurrentParametersManager sharedManager] playlist];
        title =  [currentPlaylist valueForProperty:MPMediaPlaylistPropertyName];
        songs = [currentPlaylist items];
    }
    
    NSDictionary *parameters = [[NSDictionary alloc] initWithObjectsAndKeys:songs, @"songs",title, @"title", nil];
    
    return parameters;
    
    
}



@end
