//
//  IBPlaylistsFromCoreDataViewController.m
//  Retrowave Player
//
//  Created by eastwood on 06/07/2017.
//  Copyright © 2017 Илья Блинов. All rights reserved.
//

#import "IBPlaylistsFromCoreDataViewController.h"
#import "IBPlaylist+CoreDataClass.h"
#import "IBTransitionViewController.h"
#import "IBTransitionDismissViewController.h"
#import "IBAddPlaylistViewController.h"
#import "IBPlaylistCell.h"
#import "IBAllMediaViewController.h"

@interface IBPlaylistsFromCoreDataViewController ()<UIViewControllerTransitioningDelegate>
@property (strong, nonatomic) IBTransitionViewController *animator;
@property (strong, nonatomic) IBTransitionDismissViewController *dismissAnimator;
@end

@implementation IBPlaylistsFromCoreDataViewController

@synthesize fetchedResultsController = _fetchedResultsController;



- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    
    
    [ self.tableView setEditing: [[IBCurrentParametersManager sharedManager] isEditing]];
    
    if ([[IBCurrentParametersManager sharedManager] isEditing]) {
        
        self.navigationItem.rightBarButtonItem =  [self createChooseSongsItem];
        
        self.tableView.allowsSelectionDuringEditing = YES;
        
    }else{
        
        IBPlayerItem *addToPlaylistButton = [[IBPlayerItem alloc] initWithButtonStyle:add];
        [addToPlaylistButton addTarget:self action:@selector(addNewPlaylist) forControlEvents:UIControlEventTouchUpInside];
        
        IBBarButtonItem *addToPlaylistItem = [[IBBarButtonItem alloc] initWithButton:addToPlaylistButton];
        
        self.navigationItem.rightBarButtonItem = addToPlaylistItem;
        
        
        IBPlayerItem *removePlaylistButton = [[IBPlayerItem alloc] initWithButtonStyle:del];
        [removePlaylistButton addTarget:self action:@selector(removePlaylist:) forControlEvents:UIControlEventTouchUpInside];
        
        IBBarButtonItem *removePlaylistItem = [[IBBarButtonItem alloc] initWithButton:removePlaylistButton];
        
        self.navigationItem.leftBarButtonItem = removePlaylistItem;

    }
    
    
    
    [self.tableView reloadData];
    
}






- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
    NSInteger number = [self.navigationController.viewControllers count] - 2;
    
    if (number >= 0) {
        if ([[self.navigationController.viewControllers objectAtIndex:number] isKindOfClass:[IBAllMediaViewController class]]) {
            NSString *title = @"All Media";
            UIBarButtonItem *backItem =   [self setLeftBackBarButtonItem:title];
            [self.navigationItem setLeftBarButtonItem:backItem];
            
        }
        
    }
    
    
    self.navigationItem.titleView = [IBFontAttributes getCustomTitleForControllerName:@"Playlists"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    
    NSManagedObjectContext *managedObjectContext = self.persistentContainer.viewContext;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"IBPlaylist" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"playlistName" ascending:NO];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    
    if ([[IBCurrentParametersManager sharedManager]isEditing]) {
        
        IBPlaylist *exceptionPlaylist = [[IBCurrentParametersManager sharedManager] coreDataChangingPlaylist];
        
        NSPredicate* predicate = [NSPredicate predicateWithFormat:@"playlistName != %@", exceptionPlaylist.playlistName];
        
        [fetchRequest setPredicate:predicate];
    }
    
  
    
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:managedObjectContext sectionNameKeyPath:nil cacheName:@"Master"];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
    NSError *error = nil;
    if (![self.fetchedResultsController performFetch:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _fetchedResultsController;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [[self.fetchedResultsController fetchedObjects]count];
    
    
}


- (IBPlaylistCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static  NSString *identifier = @"cell";
    
    IBPlaylistCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[IBPlaylistCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                     reuseIdentifier:identifier];
    }
    
    
    IBPlaylist *playlist = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    NSString *playlistName = playlist.playlistName;
    
    if ((playlist != nil) && (playlistName != nil) && (![playlistName isEqualToString:@""])){
        
        
        
        NSAttributedString *playlistTitle = [[NSAttributedString alloc] initWithString:playlistName];
        
        NSAttributedString *songCount = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%lu",[playlist.songItems count]]];
        
        
        cell.playlistTitle.attributedText    = playlistTitle;
        cell.songCount.attributedText        = songCount;
        
        
        
        
        if ([[IBCurrentParametersManager sharedManager] isEditing]) {
            
            IBPlayerItem *addButton = [[IBPlayerItem alloc]initWithButtonStyle:add];
            [addButton addTarget:self action:@selector(addToPlaylistAction:) forControlEvents:UIControlEventTouchUpInside];
            
            cell.editingAccessoryView = addButton;
            
        }else{
            
            IBPlayerItem *accessoryButton = [[IBPlayerItem alloc] initWithButtonStyle:move_next];
            
            cell.accessoryView = accessoryButton;
        }

        
    }
    
    return cell;
    
}





#pragma mark - UITableViewDelegate

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([[IBCurrentParametersManager sharedManager]isEditing]) {
        return UITableViewCellEditingStyleNone;
    }else{
        return UITableViewCellEditingStyleDelete;
    }
    
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
      
    IBPlaylist *playlist = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    [IBCurrentParametersManager sharedManager].coreDataPlaylist = playlist;
    
}



- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    IBPlaylistCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    __weak IBPlaylistsFromCoreDataViewController *weakSelf = self;
    
    NSDictionary *newAttributes = [IBFontAttributes attributesOfMainTitle];
    NSDictionary *systemAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:17]};
    
    NSString *title = @"DELETE";
    NSString *titleWhiteSpace = [self whitespaceReplacementString:title WithSystemAttributes:systemAttributes newAttributes:newAttributes];
    
    UITableViewRowAction *rowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:titleWhiteSpace handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        if (cell.editingStyle == UITableViewCellEditingStyleDelete) {
            
            [weakSelf.tableView beginUpdates];
            
            IBPlaylist *removingPlaylist = [weakSelf.fetchedResultsController objectAtIndexPath:indexPath];
            
            NSManagedObjectContext *context = [weakSelf.persistentContainer viewContext];
            [context deleteObject:removingPlaylist];
            
            
            NSError *error = nil;
            if ([context hasChanges] && ![context save:&error]) {
                NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                abort();
            }
            
           
                   }

        
    }];
    
   
    UIImage *patternImage = [self imageForTableViewRowActionWithTitle:title textAttributes:newAttributes backgroundColor:[UIColor purpleColor] cellHeight:CGRectGetHeight(cell.bounds)];
    
    rowAction.backgroundColor = [UIColor colorWithPatternImage:patternImage];
    

    
    return [NSArray arrayWithObject:rowAction];
    
}






#pragma mark - UIViewControllerTransitioningDelegate

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(IBAddPlaylistViewController *)presenting sourceController:(UIViewController *)source {
    
    self.animator = [[IBTransitionViewController alloc] init];
    
    return self.animator;
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UINavigationController *)dismissed{
    self.dismissAnimator = [[IBTransitionDismissViewController alloc] init];
    
    
    IBAddPlaylistViewController *vc =(IBAddPlaylistViewController*) [dismissed topViewController];
    
    
    if (![vc.playlistName.text isEqualToString: @""]) {
        NSString *newPlaylistName = [[vc playlistName]text];
        
       NSManagedObjectContext *managedObjectContext = self.persistentContainer.viewContext;
        
        IBPlaylist *newPlaylist = [NSEntityDescription insertNewObjectForEntityForName:@"IBPlaylist" inManagedObjectContext:managedObjectContext];
        newPlaylist.playlistName = newPlaylistName;
    
        [self.tableView reloadData];
    
        [[IBCoreDataManager sharedManager]saveContext];
        
    }
    
    return self.dismissAnimator;
}


#pragma mark - Action

- (void)addNewPlaylist{
    
    IBAddPlaylistViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"IBAddPlaylistViewController"];
    
    
    vc.modalPresentationStyle = UIModalPresentationFormSheet;
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
    
    
    [nav setModalPresentationStyle:UIModalPresentationCustom];
    nav.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
    
    nav.transitioningDelegate = self;
    
    [self presentViewController:nav animated:YES
                     completion:^{
                         NSLog(@"modal viewcontroller is created");
                     }];
    
    
}




- (void) addToPlaylistAction:(IBPlayerItem*) button{
    
    CGPoint point = [button convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:point];
    
    
    IBPlaylist   *currentPlaylist = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    NSArray *songs = [currentPlaylist.songItems allObjects];
    
    if (button.isSelected == NO) {
        [button setImage: [UIImage imageNamed:@"Added.png"]forState:UIControlStateSelected];
        [button setIsSelected:YES];
        [[IBCurrentParametersManager sharedManager].addedSongs addObjectsFromArray:songs];
    }else{
        [button setImage: [UIImage imageNamed:@"add 64 x 64.png"]forState:UIControlStateNormal];
        [button setIsSelected:NO];
        NSUInteger location = [[IBCurrentParametersManager sharedManager].addedSongs count] - [songs count] ;
        
        [[IBCurrentParametersManager sharedManager].addedSongs removeObjectsInRange:NSMakeRange(location, [songs count])];
    }
    
    
    NSLog(@"added songs = %lu",(unsigned long)[[[IBCurrentParametersManager sharedManager]addedSongs]count]);
    
    
}




- (void) removePlaylist:(IBPlayerItem*) button{
    
    
    if ([self.tableView isEditing]) {
        
        [self.tableView setEditing:NO animated:YES];
    }else{
        [self.tableView setEditing:YES animated:YES];

    }
    
}

#pragma mark - Edit Delete Button Of Cell

- (UIImage*) imageForTableViewRowActionWithTitle:(NSString*) title textAttributes:(NSDictionary*) attributes backgroundColor:(UIColor*) color cellHeight:(CGFloat) cellHeight{
    
    
    NSString *titleString = title;
    NSDictionary *originalAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:17]};
    CGSize originalSize = [titleString  sizeWithAttributes:originalAttributes];
    
    CGSize newSize = CGSizeMake(originalSize.width * 2.5, originalSize.height * 2);
    
    CGRect drawingRect = CGRectIntegral(CGRectMake(0, 0, newSize.width, newSize.height));
    UIGraphicsBeginImageContextWithOptions(drawingRect.size, YES, [UIScreen mainScreen].nativeScale);
    
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(contextRef, color.CGColor);
    CGContextFillRect(contextRef, drawingRect);
    
    
    UILabel *label = [[UILabel alloc] initWithFrame:drawingRect];
    label.textAlignment = NSTextAlignmentCenter;
    label.attributedText = [[NSAttributedString alloc] initWithString:title attributes:[IBFontAttributes attributesOfMainTitle]];
    
    [label drawTextInRect:drawingRect];
    
    UIImage *returningImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    
    return returningImage;
    
}


- (NSString *) whitespaceReplacementString:(NSString*) string WithSystemAttributes:(NSDictionary *)systemAttributes newAttributes:(NSDictionary *)newAttributes
{
    NSString *stringTitle = string;
    NSMutableString *stringTitleWS = [[NSMutableString alloc] initWithString:@""];
    
    CGFloat diff = 0;
    CGSize  stringTitleSize = [stringTitle sizeWithAttributes:newAttributes];
    CGSize stringTitleWSSize;
    NSDictionary *originalAttributes = systemAttributes;
    do {
        [stringTitleWS appendString:@" "];
        stringTitleWSSize = [stringTitleWS sizeWithAttributes:originalAttributes];
        diff = (stringTitleSize.width - stringTitleWSSize.width);
        if (diff <= 1.5) {
            break;
        }
    }
    while (diff > 0);
    
    return stringTitleWS;
}


#pragma Mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  
    


}

@end
