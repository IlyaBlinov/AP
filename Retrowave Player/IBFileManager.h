//
//  IBFileManager.h
//  Retrowave Player
//
//  Created by eastwood on 30/06/2017.
//  Copyright © 2017 Илья Блинов. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IBCurrentParametersManager.h"

@interface IBFileManager : NSObject


+ (IBFileManager*) sharedManager;




- (NSDictionary*) getSongsAndTitleFor: (IBSongsViewType) type;//Songs, Title


- (NSDictionary*) getAlbumsAndTitleFor:(IBSongsViewType) type;//Albums, Title


- (NSDictionary*) getPlaylistParams:(MPMediaPlaylist*) playlist;//Songs, Title
- (NSArray*) getPlaylists;



- (NSDictionary*) getArtistParams:(MPMediaItem*) artist;//artistName, number of Albums, number of Songs
- (NSArray*) getArtists;
- (NSArray*) getSongsOfArtist:(MPMediaItem*) artist withParameter:(NSString*) parameter;//parameter:Songs, Albums
- (NSArray*) getAllSongsOfArtist:(MPMediaItem*) artist;
- (NSArray*) getSongsFromAllAlbumsOfArtist:(MPMediaItem*) artist;
- (NSArray*) getAllAlbumsOfArtist:(MPMediaItem*) artist;


- (NSArray*) getAllSongsOfAlbum:(MPMediaItem*) album;



- (NSArray*) getPersistentIDsFromSongs:(NSArray*)songs;
- (MPMediaItem*) getSongByPersistentID:(NSNumber*) persistentID;
- (NSArray*) getSongsByPersistentIDs:(NSArray*) persistentIDs;


- (NSArray*) getPersistentIDsFromAlbums:(NSArray*)albums;
- (MPMediaItem*) getAlbumByPersistentID:(NSNumber*) persistentID;
- (NSArray*) getAlbumsByPersistentIDs:(NSArray*) persistentIDs;
- (NSArray*) getSongsPersistentIDsByAlbumPersistentID:(NSNumber*) persistentID;





- (NSArray*) getPersistentIDsFromArtists:(NSArray*)artists;
- (MPMediaItem*) getArtistByPersistentID:(NSNumber*) persistentID;
- (NSArray*) getArtistsByPersistentIDs:(NSArray*) persistentIDs;
- (NSArray*) getAlbumsPersistentIDsByArtistPersistentID:(NSNumber*) persistentID;
- (NSArray*) getSongsPersistentIDsByArtistPersistentID:(NSNumber*) persistentID;





@end
