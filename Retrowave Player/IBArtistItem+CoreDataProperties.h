//
//  IBArtistItem+CoreDataProperties.h
//  Retrowave Player
//
//  Created by eastwood on 11/07/2017.
//  Copyright © 2017 Илья Блинов. All rights reserved.
//

#import "IBArtistItem+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface IBArtistItem (CoreDataProperties)

+ (NSFetchRequest<IBArtistItem *> *)fetchRequest;

@property (nonatomic) int64_t persistentID;
@property (nullable, nonatomic, retain) NSSet<IBAlbumItem *> *albums;
@property (nullable, nonatomic, retain) NSSet<IBSongItem *> *songs;
@property (nullable, nonatomic, retain) NSSet<IBPlaylist *> *playlists;

@end

@interface IBArtistItem (CoreDataGeneratedAccessors)

- (void)addAlbumsObject:(IBAlbumItem *)value;
- (void)removeAlbumsObject:(IBAlbumItem *)value;
- (void)addAlbums:(NSSet<IBAlbumItem *> *)values;
- (void)removeAlbums:(NSSet<IBAlbumItem *> *)values;

- (void)addSongsObject:(IBSongItem *)value;
- (void)removeSongsObject:(IBSongItem *)value;
- (void)addSongs:(NSSet<IBSongItem *> *)values;
- (void)removeSongs:(NSSet<IBSongItem *> *)values;

- (void)addPlaylistsObject:(IBPlaylist *)value;
- (void)removePlaylistsObject:(IBPlaylist *)value;
- (void)addPlaylists:(NSSet<IBPlaylist *> *)values;
- (void)removePlaylists:(NSSet<IBPlaylist *> *)values;

@end

NS_ASSUME_NONNULL_END
