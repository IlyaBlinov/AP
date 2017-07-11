//
//  IBParentItem+CoreDataProperties.m
//  Retrowave Player
//
//  Created by eastwood on 11/07/2017.
//  Copyright © 2017 Илья Блинов. All rights reserved.
//

#import "IBParentItem+CoreDataProperties.h"

@implementation IBParentItem (CoreDataProperties)

+ (NSFetchRequest<IBParentItem *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"IBParentItem"];
}


@end
