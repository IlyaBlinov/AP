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


- (NSDictionary*) getAlbumsAndTitleFor:(IBSongsViewType) type{
    
    
    NSString *title;
    NSArray *albums;
    
    if (type == artist) {
        
        MPMediaItem *artist = [[IBCurrentParametersManager sharedManager] artist];
        
        NSString *artistName = [artist valueForProperty:MPMediaItemPropertyArtist];
        title = artistName;
        
        MPMediaPropertyPredicate *artistNamePredicate =
        [MPMediaPropertyPredicate predicateWithValue: artistName
                                         forProperty: MPMediaItemPropertyArtist];
        
        MPMediaQuery *albumsOfArtist = [[MPMediaQuery alloc] init];
        [albumsOfArtist setGroupingType:MPMediaGroupingAlbum];
        
        [albumsOfArtist addFilterPredicate:artistNamePredicate];
        
        NSMutableArray *albumsItemsArray = [NSMutableArray array];
        
        for (MPMediaItemCollection *album in [albumsOfArtist collections]) {
            MPMediaItem *albumItem = [album representativeItem];
            [albumsItemsArray addObject:albumItem];
            
        }
        albums = [[NSArray alloc] initWithArray:albumsItemsArray];
        
        
        
    }else{
        title = @"All Media";
        MPMediaQuery *albumsQuery = [MPMediaQuery albumsQuery];
        albums = [albumsQuery items];
        
    }
    
   
    
   albums = [NSArray arrayWithArray:[self sortingItems:albums ByProperty:MPMediaItemPropertyAlbumTitle]];
    
    NSDictionary *parameters = [[NSDictionary alloc] initWithObjectsAndKeys:albums, @"albums",title, @"title", nil];
    
    return parameters;

    
}


- (NSArray*) getArtists{
    
    MPMediaQuery *artistsQuery = [MPMediaQuery artistsQuery];
    
    NSArray *artistsArray = [artistsQuery items];
    
    return  [self sortingItems:artistsArray ByProperty:MPMediaItemPropertyArtist] ;
    
    
}

- (NSDictionary*) getArtistParams:(MPMediaItem*) artist{
    
    NSString *artistTitle = [artist valueForProperty:MPMediaItemPropertyArtist];
    NSAttributedString *artistName = [[NSAttributedString alloc] initWithString:artistTitle];
    
    MPMediaPropertyPredicate *artistNamePredicate =
    [MPMediaPropertyPredicate predicateWithValue: artistTitle
                                     forProperty: MPMediaItemPropertyArtist];
    
    
    MPMediaQuery *albumsOfArtist = [[MPMediaQuery alloc] init];
    [albumsOfArtist setGroupingType:MPMediaGroupingAlbum];
    [albumsOfArtist addFilterPredicate:artistNamePredicate];
    NSUInteger numberOfAlbums =  [[albumsOfArtist collections] count];
    NSString *artistParameterAlbums = [NSString stringWithFormat:@"%u",numberOfAlbums];
    
    
    
    MPMediaQuery *songsOfArtist = [[MPMediaQuery alloc] init];
    [songsOfArtist setGroupingType:MPMediaGroupingTitle];
    [songsOfArtist addFilterPredicate:artistNamePredicate];
    NSUInteger numberOfSongs = [[songsOfArtist collections] count];
    NSString *artistParameterSongs = [NSString stringWithFormat:@"%u",numberOfSongs];
    
   
    
    NSDictionary *parametersOfArtist = [[NSDictionary alloc] initWithObjectsAndKeys:artistParameterSongs, @"numberOfSongs",artistParameterAlbums, @"numberOfAlbums",artistName, @"artistName", nil];
   
    return parametersOfArtist;
}



#pragma mark - sortingItems

- (NSArray*) sortingItems:(NSArray*) items ByProperty:(NSString*) property{
    
    NSMutableArray *array = [NSMutableArray arrayWithArray:items];
    
    for (int i = 0; i < [items count] - 1; i++) {
        
        MPMediaItem *item1 = [items objectAtIndex:i];
        MPMediaItem *item2 = [items objectAtIndex:i + 1];
        
        NSString *itemTitle1 = [item1 valueForProperty:property];
        NSString *itemTitle2 = [item2 valueForProperty:property];
        
        
        if ([itemTitle1 isEqualToString:itemTitle2]) {
            [array removeObject:item1];
        }
        
        if ([itemTitle1 isEqualToString:@""] | (itemTitle1 == nil) ){
            [array removeObject:item1];
        }
        
        if ([itemTitle2 isEqualToString:@""] | (itemTitle2 == nil)){
            [array removeObject:item2];
        }
        
    }
    return array;
    
}


@end
