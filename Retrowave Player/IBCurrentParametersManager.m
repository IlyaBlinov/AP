//
//  IBCurrentParametersManager.m
//  Retrowave Player
//
//  Created by Илья Блинов on 09.05.17.
//  Copyright © 2017 Илья Блинов. All rights reserved.
//

#import "IBCurrentParametersManager.h"
#import "IBSongsViewController.h"
#import "IBSongsAddViewController.h"
#import "IBContentViewController.h"

@implementation IBCurrentParametersManager



+ (IBCurrentParametersManager*) sharedManager{
    
    static IBCurrentParametersManager *manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[IBCurrentParametersManager alloc] init];
        manager.addedSongs = [NSMutableArray array];
        manager.removedSongs = [NSMutableArray array];
    });
    
    return manager;
    
}




- (void) removeSongFromArray:(IBMediaItem*) song{
    
    if ([self.addedSongs count] > 0) {
        
        NSArray *persistentIDs = [self.addedSongs valueForKeyPath:@"@unionOfObjects.mediaEntity.persistentID"];
        
        NSNumber *persistentIDOfSong = [NSNumber numberWithLongLong:song.mediaEntity.persistentID];
        
        if ([persistentIDs containsObject:persistentIDOfSong]) {
            
            NSInteger index = [persistentIDs indexOfObject:persistentIDOfSong];
            
            [self.addedSongs removeObjectAtIndex:index];
            
            
        }
  
    }
    
    
}

@end
