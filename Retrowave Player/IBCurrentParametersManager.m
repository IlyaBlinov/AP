//
//  IBCurrentParametersManager.m
//  Retrowave Player
//
//  Created by Илья Блинов on 09.05.17.
//  Copyright © 2017 Илья Блинов. All rights reserved.
//

#import "IBCurrentParametersManager.h"

@implementation IBCurrentParametersManager



+ (IBCurrentParametersManager*) sharedManager{
    
    static IBCurrentParametersManager *manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[IBCurrentParametersManager alloc] init];
        manager.addedSongs = [NSMutableArray array];
    });
    
    return manager;
    
}


- (NSDictionary*) getSongsAndTitleForSongViewController{
    
    NSString *title;
    NSArray *songs;
    
    
    MPMediaPlaylist *currentPlaylist = [[IBCurrentParametersManager sharedManager] playlist];
    MPMediaItem     *currentArtist   = [[IBCurrentParametersManager sharedManager] artist];
    MPMediaItem     *currentAlbum    = [[IBCurrentParametersManager sharedManager] album];
    
    
    if ([IBCurrentParametersManager sharedManager].songsViewControllerDataViewMode == allSongs ) {
        title = @"All Media";
        
        MPMediaQuery *songsQuery = [MPMediaQuery songsQuery];
        songs = [songsQuery items];
        
        
    }else if ([IBCurrentParametersManager sharedManager].songsViewControllerDataViewMode == album){
        title = [currentAlbum valueForProperty:MPMediaItemPropertyAlbumTitle];
        
        MPMediaPropertyPredicate *albumNamePredicate =
        [MPMediaPropertyPredicate predicateWithValue: title
                                         forProperty: MPMediaItemPropertyAlbumTitle];
        
        MPMediaQuery *songsOfAlbum = [[MPMediaQuery alloc] init];
        [songsOfAlbum addFilterPredicate:albumNamePredicate];
        
        
        songs = [songsOfAlbum items];
        
        
    }else if ([IBCurrentParametersManager sharedManager].songsViewControllerDataViewMode == artist){
        
        NSString *artistName = [currentArtist valueForProperty:MPMediaItemPropertyArtist];
        title = artistName;
        
        MPMediaPropertyPredicate *artistNamePredicate =
        [MPMediaPropertyPredicate predicateWithValue: title
                                         forProperty: MPMediaItemPropertyArtist];
        
        MPMediaQuery *songsOfArtist = [[MPMediaQuery alloc] init];
        [songsOfArtist addFilterPredicate:artistNamePredicate];
        
        
        songs = [songsOfArtist items];
        
        
    }else if ([IBCurrentParametersManager sharedManager].songsViewControllerDataViewMode == playlist){
        title =  [currentPlaylist valueForProperty:MPMediaPlaylistPropertyName];
        songs = [currentPlaylist items];
    }
    
    NSDictionary *parameters = [[NSDictionary alloc] initWithObjectsAndKeys:songs, @"songs",title, @"title", nil];
    
    return parameters;
    
    
}




@end
