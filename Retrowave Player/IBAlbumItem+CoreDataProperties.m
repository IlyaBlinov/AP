//
//  IBAlbumItem+CoreDataProperties.m
//  Retrowave Player
//
//  Created by eastwood on 11/07/2017.
//  Copyright © 2017 Илья Блинов. All rights reserved.
//

#import "IBAlbumItem+CoreDataProperties.h"

@implementation IBAlbumItem (CoreDataProperties)

+ (NSFetchRequest<IBAlbumItem *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"IBAlbumItem"];
}

@dynamic persistentID;
@dynamic artist;
@dynamic songs;
@dynamic playlists;

@end
