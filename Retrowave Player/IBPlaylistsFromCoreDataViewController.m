//
//  IBPlaylistsFromCoreDataViewController.m
//  Retrowave Player
//
//  Created by eastwood on 06/07/2017.
//  Copyright © 2017 Илья Блинов. All rights reserved.
//

#import "IBPlaylistsFromCoreDataViewController.h"
#import "IBPlaylist+CoreDataClass.h"
#import "IBTableViewRowAction.h"

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
        
        [self createChooseSongsItem];
        
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






- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
        
        NSAttributedString *songCount = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d",[playlist.songItems count]]];
        
        
        cell.playlistTitle.attributedText    = playlistTitle;
        cell.songCount.attributedText        = songCount;
        
        
        
        
        if ([[IBCurrentParametersManager sharedManager] isEditing]) {
            
            cell.editingAccessoryView = [self createAddSongsToPlaylistButton];
            
        }else{
            
            IBPlayerItem *accessoryButton = [[IBPlayerItem alloc] initWithFrame:CGRectMake(0,0, 20, 20)];
            [accessoryButton setImage: [UIImage imageNamed:@"skip-track.png"]forState:UIControlStateNormal];
            
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


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
    IBPlaylist *removingPlaylist = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    NSManagedObjectContext *context = [self.persistentContainer viewContext];
    [context deleteObject:removingPlaylist];
    
    [[IBCoreDataManager sharedManager]saveContext];
    }
}


- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    IBPlaylistCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    
    IBTableViewRowAction *rowAction = [[IBTableViewRowAction rowActionForCell:cell];
    
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
    
    
    NSLog(@"added songs = %u",[[[IBCurrentParametersManager sharedManager]addedSongs]count]);
    
    
}




- (void) removePlaylist:(IBPlayerItem*) button{
    
    
    if ([self.tableView isEditing]) {
        [self.tableView setEditing:NO animated:YES];
    }else{
        [self.tableView setEditing:YES animated:YES];
    }
    
}




@end
