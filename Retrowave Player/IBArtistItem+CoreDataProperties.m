//
//  IBArtistItem+CoreDataProperties.m
//  Retrowave Player
//
//  Created by eastwood on 20/07/2017.
//  Copyright © 2017 Илья Блинов. All rights reserved.
//

#import "IBArtistItem+CoreDataProperties.h"

@implementation IBArtistItem (CoreDataProperties)

+ (NSFetchRequest<IBArtistItem *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"IBArtistItem"];
}

@dynamic persistentID;
@dynamic position;
@dynamic albums;
@dynamic playlists;
@dynamic songs;

@end
