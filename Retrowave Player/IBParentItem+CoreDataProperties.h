//
//  IBParentItem+CoreDataProperties.h
//  Retrowave Player
//
//  Created by eastwood on 11/07/2017.
//  Copyright © 2017 Илья Блинов. All rights reserved.
//

#import "IBParentItem+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface IBParentItem (CoreDataProperties)

+ (NSFetchRequest<IBParentItem *> *)fetchRequest;


@end

NS_ASSUME_NONNULL_END
