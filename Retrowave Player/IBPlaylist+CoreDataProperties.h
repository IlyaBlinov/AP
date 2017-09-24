//
//  IBPlaylist+CoreDataProperties.h
//  Retrowave Player
//
//  Created by eastwood on 20/07/2017.
//  Copyright © 2017 Илья Блинов. All rights reserved.
//

#import "IBPlaylist+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface IBPlaylist (CoreDataProperties)

+ (NSFetchRequest<IBPlaylist *> *)fetchRequest;

@property (nonatomic) NSNumber *persistentID;
@property (nullable, nonatomic, copy) NSString *playlistName;
@property (nonatomic) NSNumber *position;
@property (nullable, nonatomic, retain) NSSet<IBAlbumItem *> *albumItems;
@property (nullable, nonatomic, retain) NSSet<IBArtistItem *> *artistItems;
@property (nullable, nonatomic, retain) NSSet<IBSongItem *> *songItems;

@end

@interface IBPlaylist (CoreDataGeneratedAccessors)

- (void)addAlbumItemsObject:(IBAlbumItem *)value;
- (void)removeAlbumItemsObject:(IBAlbumItem *)value;
- (void)addAlbumItems:(NSSet<IBAlbumItem *> *)values;
- (void)removeAlbumItems:(NSSet<IBAlbumItem *> *)values;

- (void)addArtistItemsObject:(IBArtistItem *)value;
- (void)removeArtistItemsObject:(IBArtistItem *)value;
- (void)addArtistItems:(NSSet<IBArtistItem *> *)values;
- (void)removeArtistItems:(NSSet<IBArtistItem *> *)values;

- (void)addSongItemsObject:(IBSongItem *)value;
- (void)removeSongItemsObject:(IBSongItem *)value;
- (void)addSongItems:(NSSet<IBSongItem *> *)values;
- (void)removeSongItems:(NSSet<IBSongItem *> *)values;

@end

NS_ASSUME_NONNULL_END
