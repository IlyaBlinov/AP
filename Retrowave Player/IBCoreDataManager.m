//
//  IBCoreDataManager.m
//  Retrowave Player
//
//  Created by eastwood on 06/07/2017.
//  Copyright © 2017 Илья Блинов. All rights reserved.
//

#import "IBCoreDataManager.h"
#import "IBCurrentParametersManager.h"

@implementation IBCoreDataManager

@synthesize persistentContainer = _persistentContainer;


#pragma mark - Singleton
+ (IBCoreDataManager*) sharedManager{
    
    static IBCoreDataManager *sharedManager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[IBCoreDataManager alloc] init];
    });
    
    return  sharedManager;
}


#pragma mark - Core Data stack


- (NSPersistentContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"Retrowave_Player"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                     */
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}


#pragma mark - Core Data Actions


- (NSArray*) allObjectsFromCoreDataPlaylist:(IBPlaylist*) playlist {
    
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    
    NSFetchRequest* songRequest = [[NSFetchRequest alloc] init];
    NSFetchRequest* albumRequest = [[NSFetchRequest alloc] init];
    NSFetchRequest* artistRequest = [[NSFetchRequest alloc] init];
    
    
    NSEntityDescription* songDescription =
    [NSEntityDescription entityForName:@"IBSongItem"
                inManagedObjectContext:context];
    
    
    NSEntityDescription* albumDescription =
    [NSEntityDescription entityForName:@"IBAlbumItem"
                inManagedObjectContext:context];
    
    
    NSEntityDescription* artistDescription =
    [NSEntityDescription entityForName:@"IBArtistItem"
                inManagedObjectContext:context];
    
    
    
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"playlists contains %@", playlist];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"position" ascending:NO];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    
    [songRequest   setPredicate:predicate];
    [albumRequest  setPredicate:predicate];
    [artistRequest setPredicate:predicate];
    
    [songRequest   setEntity:songDescription];
    [albumRequest  setEntity:albumDescription];
    [artistRequest setEntity:artistDescription];

    
    [songRequest   setSortDescriptors:sortDescriptors];
    [albumRequest  setSortDescriptors:sortDescriptors];
    [artistRequest setSortDescriptors:sortDescriptors];
    
    NSError* songRequestError = nil;
    NSArray* songsResultArray = [context executeFetchRequest:songRequest error:&songRequestError];
    if (songRequestError) {
        NSLog(@"%@", [songRequestError localizedDescription]);
    }
    
    NSError* albumRequestError = nil;
    NSArray* albumsResultArray = [context executeFetchRequest:songRequest error:&albumRequestError];
    if (albumRequestError) {
        NSLog(@"%@", [albumRequestError localizedDescription]);
    }

    NSError* artistRequestError = nil;
    NSArray* artistResultArray = [context executeFetchRequest:songRequest error:&artistRequestError];
    if (artistRequestError) {
        NSLog(@"%@", [artistRequestError localizedDescription]);
    }

    
    NSMutableArray *tempResultArray = [NSMutableArray arrayWithArray:songsResultArray];
    [tempResultArray addObjectsFromArray:albumsResultArray];
    [tempResultArray addObjectsFromArray:artistResultArray];
    
    [tempResultArray sortUsingDescriptors:sortDescriptors];
    
    NSArray *resultArray = [NSArray arrayWithArray:tempResultArray];
    
    
    
    
    return resultArray;
}


- (NSArray*) playlists {
    
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    
    NSEntityDescription* description =
    [NSEntityDescription entityForName:@"IBPlaylist"
                inManagedObjectContext:context];
    
    [request setEntity:description];
    
    NSError* requestError = nil;
    NSArray* resultArray = [context executeFetchRequest:request error:&requestError];
    if (requestError) {
        NSLog(@"%@", [requestError localizedDescription]);
    }
    
    return resultArray;
}




//
//- (void) printArray:(NSArray*) array {
//    
//    for (id object in array) {
//        
//        
//    }
//    
//    NSLog(@"COUNT = %d", [array count]);
//}
//
//- (void) printAllObjects {
//    
//    NSArray* allObjects = [self allObjects];
//    
//    [self printArray:allObjects];
//}
//
//- (void) deleteAllObjects {
//    
//    NSArray* allObjects = [self allObjects];
//    NSManagedObjectContext *context = self.persistentContainer.viewContext;
//    
//    
//    for (id object in allObjects) {
//        [context deleteObject:object];
//    }
//    [context save:nil];
//}







@end
