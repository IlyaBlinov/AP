//
//  IBParentItem+CoreDataProperties.m
//  Retrowave Player
//
//  Created by eastwood on 28/09/2017.
//  Copyright © 2017 Илья Блинов. All rights reserved.
//

#import "IBParentItem+CoreDataProperties.h"

@implementation IBParentItem (CoreDataProperties)

+ (NSFetchRequest<IBParentItem *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"IBParentItem"];
}

@dynamic currentSong;
@dynamic currentAlbum;
@dynamic currentArtist;
@dynamic currentPlaylist;

@end
