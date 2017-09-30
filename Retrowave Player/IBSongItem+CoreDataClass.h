//
//  IBSongItem+CoreDataClass.h
//  Retrowave Player
//
//  Created by eastwood on 28/09/2017.
//  Copyright © 2017 Илья Блинов. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IBParentItem+CoreDataClass.h"

@class IBAlbumItem, IBArtistItem, IBPlaylist;

NS_ASSUME_NONNULL_BEGIN

@interface IBSongItem : IBParentItem

@end

NS_ASSUME_NONNULL_END

#import "IBSongItem+CoreDataProperties.h"
