//
//  IBSongsFromCoreDataViewController.h
//  Retrowave Player
//
//  Created by eastwood on 17/07/2017.
//  Copyright © 2017 Илья Блинов. All rights reserved.
//

//#import "IBCoreDataViewController.h"

//@interface IBSongsFromCoreDataViewController : IBCoreDataViewController

#import "IBContentViewController.h"

@interface IBSongsFromCoreDataViewController : IBContentViewController



- (UIImage*) imageForTableViewRowActionWithTitle:(NSString*) title textAttributes:(NSDictionary*) attributes backgroundColor:(UIColor*) color cellHeight:(CGFloat) cellHeight;

- (NSString *) whitespaceReplacementString:(NSString*) string WithSystemAttributes:(NSDictionary *)systemAttributes newAttributes:(NSDictionary *)newAttributes;

@end
