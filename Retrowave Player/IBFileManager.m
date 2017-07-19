//
//  IBFileManager.m
//  Retrowave Player
//
//  Created by eastwood on 30/06/2017.
//  Copyright © 2017 Илья Блинов. All rights reserved.
//

#import "IBFileManager.h"
#import "IBCoreDataManager.h"
#import "IBParentItem+CoreDataClass.h"
#import "IBPlaylist+CoreDataClass.h"

@implementation IBFileManager



+ (IBFileManager*) sharedManager{
    
    static IBFileManager *manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[IBFileManager alloc] init];
    });
    
    return manager;
    
}



#pragma mark - Songs Params

- (NSDictionary*) getSongsAndTitleFor:(IBSongsViewType) type{
    
    NSString *title;
    NSArray *songs;
    
    if (type == allSongs ) {
        title = @"All Media";
        
        MPMediaQuery *songsQuery = [MPMediaQuery songsQuery];
        songs = [songsQuery items];
        
        
    }else if (type == album){
        IBMediaItem     *currentAlbum    = [[IBCurrentParametersManager sharedManager] album];
        title = [currentAlbum valueForProperty:MPMediaItemPropertyAlbumTitle];
        
        MPMediaPropertyPredicate *albumNamePredicate =
        [MPMediaPropertyPredicate predicateWithValue: title
                                         forProperty: MPMediaItemPropertyAlbumTitle];
        
        MPMediaQuery *songsOfAlbum = [[MPMediaQuery alloc] init];
        [songsOfAlbum addFilterPredicate:albumNamePredicate];
        
        
        songs = [songsOfAlbum items];
        
        
    }else if (type == artist){
        IBMediaItem     *currentArtist   = [[IBCurrentParametersManager sharedManager] artist];
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

#pragma mark - Album Params

- (NSDictionary*) getAlbumsAndTitleFor:(IBSongsViewType) type{
    
    
    NSString *title;
    NSArray *albums;
    
    if (type == artist) {
        
        IBMediaItem *artist = [[IBCurrentParametersManager sharedManager] artist];
        NSString *artistName = [artist valueForProperty:MPMediaItemPropertyArtist];
        
        albums = [self getAllAlbumsOfArtist:artist];
        
        title = artistName;
    }else{
        title = @"All Media";
        MPMediaQuery *albumsQuery = [MPMediaQuery albumsQuery];
        albums = [albumsQuery items];
        
    }
    
   
    
   albums = [NSArray arrayWithArray:[self sortingItems:albums ByProperty:MPMediaItemPropertyAlbumTitle]];
    
    NSDictionary *parameters = [[NSDictionary alloc] initWithObjectsAndKeys:albums, @"albums",title, @"title", nil];
    
    return parameters;

    
}




- (NSArray*) getAllAlbumsOfArtist:(IBMediaItem*) artist{
    
    NSString *artistName = [artist valueForProperty:MPMediaItemPropertyArtist];
    
    
    MPMediaPropertyPredicate *artistNamePredicate =
    [MPMediaPropertyPredicate predicateWithValue: artistName
                                     forProperty: MPMediaItemPropertyArtist];
    
    MPMediaQuery *albumsOfArtist = [[MPMediaQuery alloc] init];
    [albumsOfArtist setGroupingType:MPMediaGroupingAlbum];
    
    [albumsOfArtist addFilterPredicate:artistNamePredicate];
    
    NSMutableArray *albumsItemsArray = [NSMutableArray array];
    
    for (MPMediaItemCollection *album in [albumsOfArtist collections]) {
        IBMediaItem *albumItem = (IBMediaItem*)[album representativeItem];
        [albumsItemsArray addObject:albumItem];
        
    }
    NSArray *albums = [[NSArray alloc] initWithArray:albumsItemsArray];
    
    return albums;
  
}


- (NSArray*) getAllSongsOfAlbum:(IBMediaItem*) album{
    
    NSString *title = [album valueForProperty:MPMediaItemPropertyAlbumTitle];
    
    MPMediaPropertyPredicate *albumNamePredicate =
    [MPMediaPropertyPredicate predicateWithValue: title
                                     forProperty: MPMediaItemPropertyAlbumTitle];
    
    MPMediaQuery *songsOfAlbum = [[MPMediaQuery alloc] init];
    [songsOfAlbum addFilterPredicate:albumNamePredicate];
    
    return  [songsOfAlbum items];
    
}



#pragma mark - Playlist Params

- (NSArray*) getPlaylists{
    
    NSArray *playlists;
    
    MPMediaQuery *playlistQuery = [MPMediaQuery playlistsQuery];
    
    NSMutableArray *playliststTempArray = (NSMutableArray*) [playlistQuery collections] ;
;
    
    if ([[IBCurrentParametersManager sharedManager] isEditing]) {
        MPMediaPlaylist *playlist = [[IBCurrentParametersManager sharedManager]changingPlaylist];
        NSInteger indexOfChangingPlaylist = [playliststTempArray indexOfObject:playlist];
        
        NSMutableArray *arrayPlaylistsBehindChangingPlaylist = [NSMutableArray array];
       
        if (indexOfChangingPlaylist != 0) {
            
            for (int i = 0; i < indexOfChangingPlaylist; i++) {
                MPMediaPlaylist *playlist = [playliststTempArray objectAtIndex:i];
                [arrayPlaylistsBehindChangingPlaylist addObject:playlist];
            }
            
        }
        
        NSMutableArray *arrayPlaylistsAfterChangingPlaylist = [NSMutableArray array];
        
        if (indexOfChangingPlaylist != [playliststTempArray count] - 1) {
            
            for (long int i = indexOfChangingPlaylist + 1; i < [playliststTempArray count]; i++) {
                MPMediaPlaylist *playlist = [playliststTempArray objectAtIndex:i];
                [arrayPlaylistsAfterChangingPlaylist addObject:playlist];
            }
            
        }
        
        NSMutableArray *resultArray = [NSMutableArray arrayWithArray:arrayPlaylistsBehindChangingPlaylist];
        
        [resultArray addObjectsFromArray:arrayPlaylistsAfterChangingPlaylist];
        
        playlists = [NSArray arrayWithArray:resultArray];
        
        
    }else{
    
    playlists = [NSArray arrayWithArray:playliststTempArray];
    }
    
    return playlists;

}

- (NSDictionary*) getPlaylistParams:(MPMediaPlaylist*) playlist{
    
    NSArray   *songs = [playlist items];
    NSString  *title = [playlist valueForProperty:MPMediaPlaylistPropertyName];
    
    NSDictionary *parameters = [[NSDictionary alloc] initWithObjectsAndKeys:songs, @"songs",title, @"title", nil];
    
    return parameters;
    
}


#pragma mark - Artist Params

- (NSArray*) getArtists{
    
    MPMediaQuery *artistsQuery = [MPMediaQuery artistsQuery];
    
    NSArray *artistsArray = [artistsQuery items];
    
    return  [self sortingItems:artistsArray ByProperty:MPMediaItemPropertyArtist] ;
    
    
}


- (NSDictionary*) getArtistParams:(IBMediaItem*) artist{
    
    NSString *artistTitle = [artist valueForProperty:MPMediaItemPropertyArtist];
    NSAttributedString *artistName = [[NSAttributedString alloc] initWithString:artistTitle];
    
    MPMediaPropertyPredicate *artistNamePredicate =
    [MPMediaPropertyPredicate predicateWithValue: artistTitle
                                     forProperty: MPMediaItemPropertyArtist];
    
    
    MPMediaQuery *albumsOfArtist = [[MPMediaQuery alloc] init];
    [albumsOfArtist setGroupingType:MPMediaGroupingAlbum];
    [albumsOfArtist addFilterPredicate:artistNamePredicate];
    NSUInteger numberOfAlbums =  [[albumsOfArtist collections] count];
    NSString *artistParameterAlbums = [NSString stringWithFormat:@"%lu",(unsigned long)numberOfAlbums];
    
    
    
    MPMediaQuery *songsOfArtist = [[MPMediaQuery alloc] init];
    [songsOfArtist setGroupingType:MPMediaGroupingTitle];
    [songsOfArtist addFilterPredicate:artistNamePredicate];
    NSUInteger numberOfSongs = [[songsOfArtist collections] count];
    NSString *artistParameterSongs = [NSString stringWithFormat:@"%lu",(unsigned long)numberOfSongs];
    
   
    
    NSDictionary *parametersOfArtist = [[NSDictionary alloc] initWithObjectsAndKeys:artistParameterSongs, @"numberOfSongs",artistParameterAlbums, @"numberOfAlbums",artistName, @"artistName", nil];
   
    return parametersOfArtist;
}



- (NSArray*) getSongsOfArtist:(IBMediaItem*) artist withParameter:(NSString*) parameter{//  Params: Songs, Albums
    
    NSArray *songs;
    if ([parameter isEqualToString:@"Songs"]) {
        songs = [self getAllSongsOfArtist:artist];
    }else{
        songs = [self getSongsFromAllAlbumsOfArtist:artist];
    }
        return songs;
}


- (NSArray*) getAllSongsOfArtist:(IBMediaItem*) artist{
    
    NSString *artistName = [artist valueForProperty:MPMediaItemPropertyArtist];
    
    MPMediaPropertyPredicate *artistNamePredicate =
    [MPMediaPropertyPredicate predicateWithValue: artistName
                                     forProperty: MPMediaItemPropertyArtist];
    
    MPMediaQuery *songsOfArtist = [[MPMediaQuery alloc] init];
    [songsOfArtist addFilterPredicate:artistNamePredicate];
    
    return [songsOfArtist items];
    
}



- (NSArray*) getSongsFromAllAlbumsOfArtist:(IBMediaItem*) artist{
    
    NSString *artistName = [artist valueForProperty:MPMediaItemPropertyArtist];
   
    MPMediaPropertyPredicate *artistNamePredicate =
    [MPMediaPropertyPredicate predicateWithValue: artistName
                                     forProperty: MPMediaItemPropertyArtist];
    
    MPMediaQuery *albumsOfArtist = [[MPMediaQuery alloc] init];
    [albumsOfArtist setGroupingType:MPMediaGroupingAlbum];
    
    [albumsOfArtist addFilterPredicate:artistNamePredicate];
    
    NSMutableArray *tempSongsArray = [NSMutableArray array];
    
    for (MPMediaItemCollection *album in [albumsOfArtist collections]) {
        IBMediaItem *albumItem = (IBMediaItem*)[album representativeItem];
        
        NSString *title = [albumItem valueForProperty:MPMediaItemPropertyAlbumTitle];
        
        MPMediaPropertyPredicate *albumNamePredicate =
        [MPMediaPropertyPredicate predicateWithValue: title
                                         forProperty: MPMediaItemPropertyAlbumTitle];
        
        MPMediaQuery *songsOfAlbum = [[MPMediaQuery alloc] init];
        [songsOfAlbum addFilterPredicate:albumNamePredicate];
        
        [tempSongsArray addObjectsFromArray:[songsOfAlbum items]];
        
        
    }
    
    return  tempSongsArray;

    
}


#pragma mark - Get Persistent ID's


- (NSArray*) getPersistentIDsFromSongs:(NSArray*)songs{
    
    
    NSArray *persistentIDsArray = [songs valueForKeyPath:@"@unionOfObjects.persistentID"];
    
    return persistentIDsArray;
    
    
}

- (NSArray*) getPersistentIDsFromAlbums:(NSArray*)albums{
    
    
    NSArray *persistentIDsArray = [albums valueForKeyPath:@"@unionOfObjects.albumPersistentID"];
    
    return persistentIDsArray;
    
    
}



- (NSArray*) getSongsPersistentIDsByAlbumPersistentID:(NSNumber*) persistentID{
    
    IBMediaItem *album = [self getAlbumByPersistentID:persistentID];
    
    NSArray *itemsArray = [self getAllSongsOfAlbum:album];
    
    NSArray *persistentIDsArray = [self getPersistentIDsFromSongs:itemsArray];
    
    return persistentIDsArray;
    
}





- (NSArray*) getPersistentIDsFromArtists:(NSArray*)artists{
    
    
    NSArray *persistentIDsArray = [artists valueForKeyPath:@"@unionOfObjects.artistPersistentID"];
    
    return persistentIDsArray;
 
}


- (NSArray*) getAlbumsPersistentIDsByArtistPersistentID:(NSNumber*) persistentID{
    
    IBMediaItem *artist = (IBMediaItem*)[self getArtistByPersistentID:persistentID];
    
    NSArray *albumsOfArtist = [self getAllAlbumsOfArtist:artist];
    
    NSArray *persitentIDsArray = [self getPersistentIDsFromAlbums:albumsOfArtist];
    
    return persitentIDsArray;
    
}

- (NSArray*) getSongsPersistentIDsByArtistPersistentID:(NSNumber*) persistentID{
    
     IBMediaItem *artist = (IBMediaItem*)[self getArtistByPersistentID:persistentID];
    
    NSArray *allSongsOfArtist = [self getAllAlbumsOfArtist:artist];
    
    NSArray *persistentIDsArray = [self getPersistentIDsFromSongs:allSongsOfArtist];
   
    return persistentIDsArray;
    
}





#pragma mark - return MPMediaItems By PersistentID

- (IBMediaItem*) getSongByPersistentID:(NSNumber*) persistentID{

    
    MPMediaPropertyPredicate *persisitentIDPredicate =
    [MPMediaPropertyPredicate predicateWithValue: persistentID
                                     forProperty: MPMediaItemPropertyPersistentID];
    
    MPMediaQuery *songsByPersistenID = [[MPMediaQuery alloc] init];
    [songsByPersistenID addFilterPredicate:persisitentIDPredicate];
    
    if ([songsByPersistenID.items count] > 0) {
        return (IBMediaItem*)[songsByPersistenID.items firstObject];
    }else{
        return nil;
    }
    
    
}


- (NSArray*) getSongsByPersistentIDs:(NSArray*) persistentIDs{
    
    NSMutableArray *mediaItemsArray = [NSMutableArray array];
    
    for (NSNumber *persistentID in persistentIDs) {
       
       IBMediaItem *item = [self getSongByPersistentID:persistentID];
        
        [mediaItemsArray addObject:item];
    }
    
    return mediaItemsArray;
}





- (IBMediaItem*) getAlbumByPersistentID:(NSNumber*) persistentID{

    MPMediaPropertyPredicate *persisitentIDPredicate =
    [MPMediaPropertyPredicate predicateWithValue: persistentID
                                     forProperty: MPMediaItemPropertyAlbumPersistentID];
    
    MPMediaQuery *albumPersistentID = [[MPMediaQuery alloc] init];
    [albumPersistentID addFilterPredicate:persisitentIDPredicate];
    
    if ([albumPersistentID.items count] > 0) {
        return (IBMediaItem*)[albumPersistentID.items firstObject];
    }else{
        return nil;
    }

}


- (NSArray*) getAlbumsByPersistentIDs:(NSArray*) persistentIDs{
    
    NSMutableArray *mediaItemsArray = [NSMutableArray array];
    
    for (NSNumber *persistentID in persistentIDs) {
        
        IBMediaItem *item = [self getAlbumByPersistentID:persistentID];
        
        [mediaItemsArray addObject:item];
    }
    
    return mediaItemsArray;
}







- (IBMediaItem*) getArtistByPersistentID:(NSNumber*) persistentID{
    
    MPMediaPropertyPredicate *persisitentIDPredicate =
    [MPMediaPropertyPredicate predicateWithValue: persistentID
                                     forProperty: MPMediaItemPropertyArtistPersistentID];
    
    MPMediaQuery *artistPersistentID = [[MPMediaQuery alloc] init];
    [artistPersistentID addFilterPredicate:persisitentIDPredicate];
    
    if ([artistPersistentID.items count] > 0) {
        return (IBMediaItem*)[artistPersistentID.items firstObject];
    }else{
        return nil;
    }
    
}



- (NSArray*) getArtistsByPersistentIDs:(NSArray*) persistentIDs{
    
    NSMutableArray *mediaItemsArray = [NSMutableArray array];
    
    for (NSNumber *persistentID in persistentIDs) {
        
        IBMediaItem *item = (IBMediaItem*)[self getArtistByPersistentID:persistentID];
        
        [mediaItemsArray addObject:item];
    }
    
    return mediaItemsArray;
}



- (NSArray*) getPersistentIDsFromCoreDataPlaylist:(IBPlaylist*)playlist{
    
    NSArray *allItemsInPlaylist = [[IBCoreDataManager sharedManager]allObjectsFromCoreDataPlaylist:playlist];
    
    NSMutableArray *persistentIDArray = [NSMutableArray array];
    
    if ([allItemsInPlaylist count] > 0) {
     
    for (IBParentItem *item in allItemsInPlaylist) {
        
        if ([item isKindOfClass:[IBPlaylist class]]) {
            IBPlaylist *tempPlaylist = (IBPlaylist*) item;
            [persistentIDArray addObject:[NSNumber numberWithUnsignedLongLong: tempPlaylist.persistentID]];
        }else if ([item isKindOfClass:[IBArtistItem class]]) {
            IBArtistItem *tempArtist = (IBArtistItem*) item;
            [persistentIDArray addObject:[NSNumber numberWithUnsignedLongLong: tempArtist.persistentID]];
        }else if ([item isKindOfClass:[IBAlbumItem class]]) {
            IBAlbumItem *tempAlbum = (IBAlbumItem*) item;
            [persistentIDArray addObject:[NSNumber numberWithUnsignedLongLong: tempAlbum.persistentID]];
        }else if ([item isKindOfClass:[IBSongItem class]]) {
            IBSongItem *tempSong = (IBSongItem*) item;
            [persistentIDArray addObject:[NSNumber numberWithUnsignedLongLong: tempSong.persistentID]];
        }
    }
        
}
    return persistentIDArray;
}


#pragma mark - sortingItems

- (NSArray*) sortingItems:(NSArray*) items ByProperty:(NSString*) property{
    
    NSMutableArray *array = [NSMutableArray arrayWithArray:items];
    
    for (int i = 0; i < [items count] - 1; i++) {
        
        IBMediaItem *item1 = [items objectAtIndex:i];
        IBMediaItem *item2 = [items objectAtIndex:i + 1];
        
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

#pragma mark - comparison added items and items in changing playlist

- (NSArray*) checkMediaItems:(NSArray*) itemsArray{
    
    NSArray *persistentIDsArrayOfChangingPlaylist;
    
    if ([[IBCurrentParametersManager sharedManager]coreDataChangingPlaylist]) {
        IBPlaylist *playlist = [[IBCurrentParametersManager sharedManager]coreDataChangingPlaylist];
        persistentIDsArrayOfChangingPlaylist = [self getPersistentIDsFromCoreDataPlaylist:playlist];
    }else{
        MPMediaPlaylist *playlist = [[IBCurrentParametersManager sharedManager]changingPlaylist];
        NSArray *items = [playlist items];
        persistentIDsArrayOfChangingPlaylist = [self getPersistentIDsFromSongs:items];
    }
    
   
    
    
    NSArray *addedMediItemsArray = [[IBCurrentParametersManager sharedManager]addedSongs];
    NSArray *persistentIDAddedItemsArray = [addedMediItemsArray valueForKeyPath:@"@unionOfObjects.persistentID"];
    
     
    for (IBMediaItem *item in itemsArray) {
       
        NSLog(@"%lld", item.persistentID);
        
       if ([persistentIDsArrayOfChangingPlaylist count] > 0) {
           
           NSNumber *persistentID = [NSNumber numberWithLongLong: item.persistentID];
       if ([persistentIDsArrayOfChangingPlaylist containsObject:persistentID]) {
                item.state = inPlaylist;
       }
       }
        
       if ([addedMediItemsArray count] > 0) {
       if ([persistentIDAddedItemsArray containsObject:[NSNumber numberWithUnsignedLongLong: item.persistentID]]) {
           item.state = added;
       }
   
       }
    }
    
    return  itemsArray;
    
}
    
 
    


@end
