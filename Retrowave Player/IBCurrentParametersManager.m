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
    });
    
    return manager;
    
}






@end
