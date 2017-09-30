//
//  IBParentItem+CoreDataProperties.h
//  Retrowave Player
//
//  Created by eastwood on 28/09/2017.
//  Copyright © 2017 Илья Блинов. All rights reserved.
//

#import "IBParentItem+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface IBParentItem (CoreDataProperties)

+ (NSFetchRequest<IBParentItem *> *)fetchRequest;

@property (nullable, nonatomic, retain) IBSongItem *currentSong;
@property (nullable, nonatomic, retain) IBAlbumItem *currentAlbum;
@property (nullable, nonatomic, retain) IBArtistItem *currentArtist;
@property (nullable, nonatomic, retain) IBPlaylist *currentPlaylist;

@end

NS_ASSUME_NONNULL_END
