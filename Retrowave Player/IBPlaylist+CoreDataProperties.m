//
//  IBPlaylist+CoreDataProperties.m
//  Retrowave Player
//
//  Created by eastwood on 20/07/2017.
//  Copyright © 2017 Илья Блинов. All rights reserved.
//

#import "IBPlaylist+CoreDataProperties.h"

@implementation IBPlaylist (CoreDataProperties)

+ (NSFetchRequest<IBPlaylist *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"IBPlaylist"];
}

@dynamic persistentID;
@dynamic playlistName;
@dynamic position;
@dynamic albumItems;
@dynamic artistItems;
@dynamic songItems;

@end
