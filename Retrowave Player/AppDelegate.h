//
//  AppDelegate.h
//  Retrowave Player
//
//  Created by Илья Блинов on 03.01.17.
//  Copyright © 2017 Илья Блинов. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

