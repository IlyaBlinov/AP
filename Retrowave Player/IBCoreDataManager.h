//
//  IBCoreDataManager.h
//  Retrowave Player
//
//  Created by eastwood on 06/07/2017.
//  Copyright © 2017 Илья Блинов. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
@interface IBCoreDataManager : NSObject

+ (IBCoreDataManager*) sharedManager;

@property (readonly, strong) NSPersistentContainer            *persistentContainer;
//@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
- (void)saveContext;



@end
