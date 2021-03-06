//
//  AppDelegate.m
//  Retrowave Player
//
//  Created by Илья Блинов on 03.01.17.
//  Copyright © 2017 Илья Блинов. All rights reserved.
//

#import "AppDelegate.h"
#import "IBCoreDataManager.h"
#import "IBCurrentParametersManager.h"
#import "IBVisualizerMusic.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
   
    
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    NSLog(@"applicationWillResignActive");
    
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"applicationWillResignActive" object:nil];
    IBVisualizerMusic *visualizer = [[IBCurrentParametersManager sharedManager] visualizer];
    [visualizer stopVisualizerAnimation];
    
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    NSLog(@"applicationDidEnterBackground");
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    NSLog(@"applicationWillEnterForeground");
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    NSLog(@"applicationDidBecomeActive");
    if ([[IBCurrentParametersManager sharedManager] isPlayingMusic]) {
        IBVisualizerMusic *visualizer = [[IBCurrentParametersManager sharedManager] visualizer];
        [visualizer startVisualizerAnimation];
    }
    

}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
   
    NSLog(@"applicationWillTerminate");
    [[IBCoreDataManager sharedManager]saveContext];
    IBVisualizerMusic *visualizer = [[IBCurrentParametersManager sharedManager] visualizer];
    [visualizer stopVisualizerAnimation];
    
}




@end
