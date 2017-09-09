//
//  IBCoreDataViewController.h
//  Retrowave Player
//
//  Created by eastwood on 06/07/2017.
//  Copyright © 2017 Илья Блинов. All rights reserved.
//

#import "IBContentViewController.h"
#import "IBCoreDataManager.h"

@interface IBCoreDataViewController : IBContentViewController<NSFetchedResultsControllerDelegate>



@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSPersistentContainer      *persistentContainer;

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;


- (UIImage*) imageForTableViewRowActionWithTitle:(NSString*) title textAttributes:(NSDictionary*) attributes backgroundColor:(UIColor*) color cellHeight:(CGFloat) cellHeight;

- (NSString *) whitespaceReplacementString:(NSString*) string WithSystemAttributes:(NSDictionary *)systemAttributes newAttributes:(NSDictionary *)newAttributes;

@end
