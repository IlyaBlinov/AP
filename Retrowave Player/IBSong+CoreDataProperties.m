//
//  IBSong+CoreDataProperties.m
//  Retrowave Player
//
//  Created by eastwood on 07/07/2017.
//  Copyright © 2017 Илья Блинов. All rights reserved.
//

#import "IBSong+CoreDataProperties.h"

@implementation IBSong (CoreDataProperties)

+ (NSFetchRequest<IBSong *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"IBSong"];
}

@dynamic persistentID;
@dynamic playlists;

@end
