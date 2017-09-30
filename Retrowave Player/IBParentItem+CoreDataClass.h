//
//  IBParentItem+CoreDataClass.h
//  Retrowave Player
//
//  Created by eastwood on 28/09/2017.
//  Copyright © 2017 Илья Блинов. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class IBAlbumItem, IBArtistItem, IBPlaylist, IBSongItem;//

NS_ASSUME_NONNULL_BEGIN

@interface IBParentItem : NSManagedObject

@end

NS_ASSUME_NONNULL_END

#import "IBParentItem+CoreDataProperties.h"
