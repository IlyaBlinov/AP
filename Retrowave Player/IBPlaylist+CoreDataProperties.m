//
//  IBPlaylist+CoreDataProperties.m
//  Retrowave Player
//
//  Created by eastwood on 07/07/2017.
//  Copyright © 2017 Илья Блинов. All rights reserved.
//

#import "IBPlaylist+CoreDataProperties.h"

@implementation IBPlaylist (CoreDataProperties)

+ (NSFetchRequest<IBPlaylist *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"IBPlaylist"];
}

@dynamic playlistName;
@dynamic songs;

@end
