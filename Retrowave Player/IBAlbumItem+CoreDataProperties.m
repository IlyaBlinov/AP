//
//  IBAlbumItem+CoreDataProperties.m
//  Retrowave Player
//
//  Created by eastwood on 20/07/2017.
//  Copyright © 2017 Илья Блинов. All rights reserved.
//

#import "IBAlbumItem+CoreDataProperties.h"

@implementation IBAlbumItem (CoreDataProperties)

+ (NSFetchRequest<IBAlbumItem *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"IBAlbumItem"];
}

@dynamic persistentID;
@dynamic position;
@dynamic artist;
@dynamic playlists;
@dynamic songs;

@end
