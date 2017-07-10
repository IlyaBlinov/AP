//
//  IBSong+CoreDataProperties.h
//  Retrowave Player
//
//  Created by eastwood on 07/07/2017.
//  Copyright © 2017 Илья Блинов. All rights reserved.
//

#import "IBSong+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface IBSong (CoreDataProperties)

+ (NSFetchRequest<IBSong *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *persistentID;
@property (nullable, nonatomic, retain) NSSet<IBPlaylist *> *playlists;

@end

@interface IBSong (CoreDataGeneratedAccessors)

- (void)addPlaylistsObject:(IBPlaylist *)value;
- (void)removePlaylistsObject:(IBPlaylist *)value;
- (void)addPlaylists:(NSSet<IBPlaylist *> *)values;
- (void)removePlaylists:(NSSet<IBPlaylist *> *)values;

@end

NS_ASSUME_NONNULL_END
