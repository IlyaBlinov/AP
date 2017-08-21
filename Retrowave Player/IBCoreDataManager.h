//
//  IBCoreDataManager.h
//  Retrowave Player
//
//  Created by eastwood on 06/07/2017.
//  Copyright © 2017 Илья Блинов. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "IBPlaylist+CoreDataClass.h"
#import "IBArtistItem+CoreDataClass.h"
#import "IBAlbumItem+CoreDataClass.h"
#import "IBSongItem+CoreDataClass.h"

@interface IBCoreDataManager : NSObject

+ (IBCoreDataManager*) sharedManager;

@property (readonly, strong) NSPersistentContainer            *persistentContainer;
//@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
- (void)saveContext;



- (void) saveIBSongItemsByPersistentIDs:  (NSArray*)persistentIDsArray;
- (void) deleteIBSongItemsByPersistentIDs:(NSArray*) persistentIDsArray;
- (void) resortPositionsOfSongItemsInPlaylist:(IBPlaylist*) playlist;



- (NSArray*) allObjectsFromCoreDataPlaylist:(IBPlaylist*) playlist;
- (NSArray*) playlists;


@end
