//
//  IBCoreDataViewController.h
//  Retrowave Player
//
//  Created by eastwood on 06/07/2017.
//  Copyright © 2017 Илья Блинов. All rights reserved.
//

#import "IBPlaylistlistViewController.h"
#import "IBCoreDataManager.h"

@interface IBCoreDataViewController : IBPlaylistlistViewController<NSFetchedResultsControllerDelegate>



@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSPersistentContainer      *persistentContainer;

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;






@end
