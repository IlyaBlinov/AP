//
//  IBAlbumItem+CoreDataProperties.h
//  Retrowave Player
//
//  Created by eastwood on 20/07/2017.
//  Copyright © 2017 Илья Блинов. All rights reserved.
//

#import "IBAlbumItem+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface IBAlbumItem (CoreDataProperties)

+ (NSFetchRequest<IBAlbumItem *> *)fetchRequest;

@property (nonatomic) NSNumber *persistentID;
@property (nonatomic) NSNumber *position;
@property (nullable, nonatomic, retain) IBArtistItem *artist;
@property (nullable, nonatomic, retain) NSSet<IBPlaylist *> *playlists;
@property (nullable, nonatomic, retain) NSSet<IBSongItem *> *songs;

@end

@interface IBAlbumItem (CoreDataGeneratedAccessors)

- (void)addPlaylistsObject:(IBPlaylist *)value;
- (void)removePlaylistsObject:(IBPlaylist *)value;
- (void)addPlaylists:(NSSet<IBPlaylist *> *)values;
- (void)removePlaylists:(NSSet<IBPlaylist *> *)values;

- (void)addSongsObject:(IBSongItem *)value;
- (void)removeSongsObject:(IBSongItem *)value;
- (void)addSongs:(NSSet<IBSongItem *> *)values;
- (void)removeSongs:(NSSet<IBSongItem *> *)values;

@end

NS_ASSUME_NONNULL_END
