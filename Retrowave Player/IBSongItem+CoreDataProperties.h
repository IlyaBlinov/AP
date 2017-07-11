//
//  IBSongItem+CoreDataProperties.h
//  Retrowave Player
//
//  Created by eastwood on 11/07/2017.
//  Copyright © 2017 Илья Блинов. All rights reserved.
//

#import "IBSongItem+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface IBSongItem (CoreDataProperties)

+ (NSFetchRequest<IBSongItem *> *)fetchRequest;

@property (nonatomic) int64_t persistentID;
@property (nullable, nonatomic, retain) NSSet<IBAlbumItem *> *albums;
@property (nullable, nonatomic, retain) IBArtistItem *artist;
@property (nullable, nonatomic, retain) NSSet<IBPlaylist *> *playlists;

@end

@interface IBSongItem (CoreDataGeneratedAccessors)

- (void)addAlbumsObject:(IBAlbumItem *)value;
- (void)removeAlbumsObject:(IBAlbumItem *)value;
- (void)addAlbums:(NSSet<IBAlbumItem *> *)values;
- (void)removeAlbums:(NSSet<IBAlbumItem *> *)values;

- (void)addPlaylistsObject:(IBPlaylist *)value;
- (void)removePlaylistsObject:(IBPlaylist *)value;
- (void)addPlaylists:(NSSet<IBPlaylist *> *)values;
- (void)removePlaylists:(NSSet<IBPlaylist *> *)values;

@end

NS_ASSUME_NONNULL_END
