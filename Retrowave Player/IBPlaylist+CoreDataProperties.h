//
//  IBPlaylist+CoreDataProperties.h
//  Retrowave Player
//
//  Created by eastwood on 07/07/2017.
//  Copyright © 2017 Илья Блинов. All rights reserved.
//

#import "IBPlaylist+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface IBPlaylist (CoreDataProperties)

+ (NSFetchRequest<IBPlaylist *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *playlistName;
@property (nullable, nonatomic, retain) NSSet<IBSong *> *songs;

@end

@interface IBPlaylist (CoreDataGeneratedAccessors)

- (void)addSongsObject:(IBSong *)value;
- (void)removeSongsObject:(IBSong *)value;
- (void)addSongs:(NSSet<IBSong *> *)values;
- (void)removeSongs:(NSSet<IBSong *> *)values;

@end

NS_ASSUME_NONNULL_END
