//
//  IBPlaylist+CoreDataClass.h
//  Retrowave Player
//
//  Created by eastwood on 20/07/2017.
//  Copyright © 2017 Илья Блинов. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class IBAlbumItem, IBArtistItem, IBSongItem;

NS_ASSUME_NONNULL_BEGIN

@interface IBPlaylist : NSManagedObject

@end

NS_ASSUME_NONNULL_END

#import "IBPlaylist+CoreDataProperties.h"
