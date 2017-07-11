//
//  IBPlaylist+CoreDataProperties.h
//  Retrowave Player
//
//  Created by eastwood on 11/07/2017.
//  Copyright © 2017 Илья Блинов. All rights reserved.
//

#import "IBPlaylist+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface IBPlaylist (CoreDataProperties)

+ (NSFetchRequest<IBPlaylist *> *)fetchRequest;

@property (nonatomic) int64_t persistentID;
@property (nullable, nonatomic, copy) NSString *playlistName;
@property (nullable, nonatomic, retain) NSSet<IBSongItem *> *songItems;
@property (nullable, nonatomic, retain) NSSet<IBArtistItem *> *artistItems;
@property (nullable, nonatomic, retain) NSSet<IBAlbumItem *> *albumItems;

@end

@interface IBPlaylist (CoreDataGeneratedAccessors)

- (void)addSongItemsObject:(IBSongItem *)value;
- (void)removeSongItemsObject:(IBSongItem *)value;
- (void)addSongItems:(NSSet<IBSongItem *> *)values;
- (void)removeSongItems:(NSSet<IBSongItem *> *)values;

- (void)addArtistItemsObject:(IBArtistItem *)value;
- (void)removeArtistItemsObject:(IBArtistItem *)value;
- (void)addArtistItems:(NSSet<IBArtistItem *> *)values;
- (void)removeArtistItems:(NSSet<IBArtistItem *> *)values;

- (void)addAlbumItemsObject:(IBAlbumItem *)value;
- (void)removeAlbumItemsObject:(IBAlbumItem *)value;
- (void)addAlbumItems:(NSSet<IBAlbumItem *> *)values;
- (void)removeAlbumItems:(NSSet<IBAlbumItem *> *)values;

@end

NS_ASSUME_NONNULL_END
