//
//  IBAlbumItem+CoreDataClass.h
//  Retrowave Player
//
//  Created by eastwood on 20/07/2017.
//  Copyright © 2017 Илья Блинов. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IBParentItem+CoreDataClass.h"

@class IBArtistItem, IBPlaylist, IBSongItem;

NS_ASSUME_NONNULL_BEGIN

@interface IBAlbumItem : IBParentItem

@end

NS_ASSUME_NONNULL_END

#import "IBAlbumItem+CoreDataProperties.h"
