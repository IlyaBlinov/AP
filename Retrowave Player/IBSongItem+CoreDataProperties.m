//
//  IBSongItem+CoreDataProperties.m
//  Retrowave Player
//
//  Created by eastwood on 11/07/2017.
//  Copyright © 2017 Илья Блинов. All rights reserved.
//

#import "IBSongItem+CoreDataProperties.h"

@implementation IBSongItem (CoreDataProperties)

+ (NSFetchRequest<IBSongItem *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"IBSongItem"];
}

@dynamic persistentID;
@dynamic albums;
@dynamic artist;
@dynamic playlists;

@end
