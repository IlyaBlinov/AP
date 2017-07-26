//
//  IBFileManager.h
//  Retrowave Player
//
//  Created by eastwood on 30/06/2017.
//  Copyright © 2017 Илья Блинов. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IBCurrentParametersManager.h"
#import "IBMediaItem.h"



@class IBPlaylist;

@interface IBFileManager : NSObject


+ (IBFileManager*) sharedManager;

- (NSArray*) checkMediaItems:(NSArray*) itemsArray;


- (NSDictionary*) getSongsAndTitleFor: (IBSongsViewType) type;//Songs, Title


- (NSDictionary*) getAlbumsAndTitleFor:(IBSongsViewType) type;//Albums, Title


- (NSDictionary*) getPlaylistParams:(IBMediaItem*) playlist;//Songs, Title
- (NSArray*) getPlaylists;



- (NSDictionary*) getArtistParams:(IBMediaItem*) artist;//artistName, number of Albums, number of Songs
- (NSArray*) getArtists;
- (NSArray*) getSongsOfArtist:(IBMediaItem*) artist withParameter:(NSString*) parameter;//parameter:Songs, Albums
- (NSArray*) getAllSongsOfArtist:(IBMediaItem*) artist;
- (NSArray*) getSongsFromAllAlbumsOfArtist:(IBMediaItem*) artist;
- (NSArray*) getAllAlbumsOfArtist:(IBMediaItem*) artist;


- (NSArray*) getAllSongsOfAlbum:(IBMediaItem*) album;



- (NSArray*) getPersistentIDsFromSongs:(NSArray*)songs;
- (IBMediaItem*) getSongByPersistentID:(NSNumber*) persistentID;
- (NSArray*) getSongsByPersistentIDs:(NSArray*) persistentIDs;


- (NSArray*) getPersistentIDsFromAlbums:(NSArray*)albums;
- (IBMediaItem*) getAlbumByPersistentID:(NSNumber*) persistentID;
- (NSArray*) getAlbumsByPersistentIDs:(NSArray*) persistentIDs;
- (NSArray*) getSongsPersistentIDsByAlbumPersistentID:(NSNumber*) persistentID;





- (NSArray*) getPersistentIDsFromArtists:(NSArray*)artists;
- (IBMediaItem*) getArtistByPersistentID:(NSNumber*) persistentID;
- (NSArray*) getArtistsByPersistentIDs:(NSArray*) persistentIDs;
- (NSArray*) getAlbumsPersistentIDsByArtistPersistentID:(NSNumber*) persistentID;
- (NSArray*) getSongsPersistentIDsByArtistPersistentID:(NSNumber*) persistentID;

- (NSArray*) getPersistentIDsFromCoreDataPlaylist:(IBPlaylist*)playlist;



@end
