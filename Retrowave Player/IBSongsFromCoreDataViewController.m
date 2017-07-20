//
//  IBSongsFromCoreDataViewController.m
//  Retrowave Player
//
//  Created by eastwood on 17/07/2017.
//  Copyright © 2017 Илья Блинов. All rights reserved.
//

#import "IBSongsFromCoreDataViewController.h"

@interface IBSongsFromCoreDataViewController ()
@property (strong, nonatomic) IBPlaylist *currentPlaylist;
@property (strong, nonatomic) NSArray *songs;
@end

@implementation IBSongsFromCoreDataViewController
@synthesize fetchedResultsController = _fetchedResultsController;


- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [ self.tableView setEditing: [[IBCurrentParametersManager sharedManager] isEditing]];
    
    if ([[IBCurrentParametersManager sharedManager] isEditing]) {
        
        self.navigationItem.rightBarButtonItem =  [self createChooseSongsItem];
        
    }else{
        
        IBPlayerItem *addToPlaylistButton = [[IBPlayerItem alloc] initWithButtonStyle:add];
        [addToPlaylistButton addTarget:self action:@selector(addNewSongs) forControlEvents:UIControlEventTouchUpInside];
        
        IBBarButtonItem *addToPlaylistItem = [[IBBarButtonItem alloc] initWithButton:addToPlaylistButton];
        
        self.navigationItem.rightBarButtonItem = addToPlaylistItem;
        
    }
    
        
    if ([self isEqual:[[IBCurrentParametersManager sharedManager]returnSongsViewController]]) {
        
        self.currentPlaylist = nil;
        IBPlaylist *currentPlaylist = [[IBCurrentParametersManager sharedManager] coreDataChangingPlaylist];
       
        self.songs = [currentPlaylist.songItems allObjects];
        
        self.currentPlaylist = currentPlaylist;
        
        NSLog(@"songsCount = %lu", (unsigned long)[[self.currentPlaylist songItems]count]);
        
        [[IBCurrentParametersManager sharedManager].addedSongs removeAllObjects];
        [[IBCurrentParametersManager sharedManager] setCoreDataPlaylist:nil];
        [[IBCurrentParametersManager sharedManager] setReturnSongsViewController:nil];
        [self.tableView reloadData];
        
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    IBPlaylist *currentPlaylist = [[IBCurrentParametersManager sharedManager] coreDataPlaylist];
    self.currentPlaylist = currentPlaylist;
    
   
    self.songs      = [currentPlaylist.songItems allObjects];
    NSString *title = currentPlaylist.playlistName;
    
    
    UIBarButtonItem *backItem =   [self setLeftBackBarButtonItem:title];
    [self.navigationItem setLeftBarButtonItem:backItem];
    
    self.navigationItem.titleView = [IBFontAttributes getCustomTitleForControllerName:@"Songs"];
    
    
}


- (void)dealloc
{

    [IBCurrentParametersManager sharedManager].coreDataPlaylist = nil;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//#pragma mark - Fetched results controller
//
//- (NSFetchedResultsController *)fetchedResultsController
//{
//    if (_fetchedResultsController != nil) {
//        return _fetchedResultsController;
//    }
//    
//    
//    NSManagedObjectContext *managedObjectContext = self.persistentContainer.viewContext;
//    
//    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
//    // Edit the entity name as appropriate.
//    NSEntityDescription *entity = [NSEntityDescription entityForName:@"IBParentItem" inManagedObjectContext:managedObjectContext];
//    [fetchRequest setEntity:entity];
//    
//    // Set the batch size to a suitable number.
//    [fetchRequest setFetchBatchSize:20];
//    
//    // Edit the sort key as appropriate.
//    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"playlistName" ascending:NO];
//    NSArray *sortDescriptors = @[sortDescriptor];
//    
//    [fetchRequest setSortDescriptors:sortDescriptors];
//    
//    
//    if ([[IBCurrentParametersManager sharedManager]isEditing]) {
//        
//        IBPlaylist *playlist = [[IBCurrentParametersManager sharedManager] coreDataPlaylist];
//        
//        
//        NSLog(@"%llu",playlist.persistentID);
//        NSPredicate* predicate = [NSPredicate predicateWithFormat:@"playlist contains %@", playlist];
//        
//        [fetchRequest setPredicate:predicate];
//    }
//    
//    
//    
//    
//    // Edit the section name key path and cache name if appropriate.
//    // nil for section name key path means "no sections".
//    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:managedObjectContext sectionNameKeyPath:nil cacheName:nil];
//    aFetchedResultsController.delegate = self;
//    self.fetchedResultsController = aFetchedResultsController;
//    
//    NSError *error = nil;
//    if (![self.fetchedResultsController performFetch:&error]) {
//        // Replace this implementation with code to handle the error appropriately.
//        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
//        abort();
//    }
//    
//    return _fetchedResultsController;
//}
//
//#pragma mark - UITableViewDataSource
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    
//    return [[self.fetchedResultsController fetchedObjects]count];
//    
//    
//}



#pragma mark - Actions



- (void)addNewSongs{
    
    [[IBCurrentParametersManager sharedManager] setIsEditing:YES];//playlist was saved to IBCurrentParametersManager in IBPlaylistsController
    
    [[IBCurrentParametersManager sharedManager] setCoreDataChangingPlaylist:self.currentPlaylist];
    [[IBCurrentParametersManager sharedManager] setReturnSongsViewController:self];
    
    UINavigationController *nav = [self.storyboard instantiateViewControllerWithIdentifier:@"IBAllMediaNavigationViewController"];
    
    
    [self.navigationController presentViewController:nav animated:YES completion:nil];
    
}







/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
