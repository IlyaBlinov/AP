//
//  IBSongsFromCoreDataViewController.m
//  Retrowave Player
//
//  Created by eastwood on 17/07/2017.
//  Copyright © 2017 Илья Блинов. All rights reserved.
//

#import "IBSongsFromCoreDataViewController.h"
#import "IBSongCellTableViewCell.h"
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
        self.songs = nil;
        IBPlaylist *currentPlaylist = [[IBCurrentParametersManager sharedManager] coreDataChangingPlaylist];
       
        NSArray *coreDataSongs     = [currentPlaylist.songItems allObjects];
        NSArray *persistentIDsOfSongsInCoreDataPlaylist = [coreDataSongs valueForKeyPath:@"@unionOfObjects.persistentID"];
        NSArray *songs = [[IBFileManager sharedManager] getSongsByPersistentIDs:persistentIDsOfSongsInCoreDataPlaylist];
        self.songs = [[IBFileManager sharedManager] checkSongMediaItems:songs];
        
        
        self.currentPlaylist = currentPlaylist;
        
        NSLog(@"songsCount = %lu", (unsigned long)[self.songs count]);
        
        
        
        [[IBCurrentParametersManager sharedManager].addedSongs removeAllObjects];
        [[IBCurrentParametersManager sharedManager].removedSongs removeAllObjects];
        [[IBCurrentParametersManager sharedManager] setCoreDataPlaylist:nil];
        [[IBCurrentParametersManager sharedManager] setReturnSongsViewController:nil];
        [self.tableView reloadData];
   
    }
    
   }

- (void)loadView
{
    [super loadView];
    
    
    IBPlaylist *currentPlaylist = [[IBCurrentParametersManager sharedManager] coreDataPlaylist];
    self.currentPlaylist = currentPlaylist;
    
   
    NSArray *coreDataSongs     = [currentPlaylist.songItems allObjects];
    NSArray *persistentIDsOfSongsInCoreDataPlaylist = [coreDataSongs valueForKeyPath:@"@unionOfObjects.persistentID"];
   
    NSArray *songs = [[IBFileManager sharedManager] getSongsByPersistentIDs:persistentIDsOfSongsInCoreDataPlaylist];
    self.songs = [[IBFileManager sharedManager] checkSongMediaItems:songs];
    NSString *title = currentPlaylist.playlistName;
    
    
    IBPlayerItem *removeSongButton = [[IBPlayerItem alloc] initWithButtonStyle:del];
    [removeSongButton addTarget:self action:@selector(removeSong) forControlEvents:UIControlEventTouchUpInside];
    
    IBBarButtonItem *removeSongItem = [[IBBarButtonItem alloc] initWithButton:removeSongButton];

    UIBarButtonItem *backItem =   [self setLeftBackBarButtonItem:title];
    
    NSArray *leftBarButtonItems;
    
    if ([[IBCurrentParametersManager sharedManager]isEditing]) {
        leftBarButtonItems = [NSArray arrayWithObjects:backItem, nil];
    }else{
         leftBarButtonItems = [NSArray arrayWithObjects:backItem,removeSongItem, nil];
    }
    
    [self.navigationItem setLeftBarButtonItems:leftBarButtonItems];
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

#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    
    NSManagedObjectContext *managedObjectContext = self.persistentContainer.viewContext;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"IBSongItem" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"position" ascending:YES];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    
    IBPlaylist *playlist = [[IBCurrentParametersManager sharedManager] coreDataPlaylist];
    NSLog(@"%llu",playlist.persistentID);
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"playlists contains %@", playlist];
    
    [fetchRequest setPredicate:predicate];
    
    
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:managedObjectContext sectionNameKeyPath:nil cacheName:nil];
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
    
    //return [[self.fetchedResultsController fetchedObjects] count];
    
    return [self.songs count];
}


- (IBSongCellTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static  NSString *identifier = @"cell";
    
    IBSongCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[IBSongCellTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                     reuseIdentifier:identifier];
    }
    
    
   IBSongItem *coreDataSong = [self.fetchedResultsController objectAtIndexPath:indexPath];
   
   IBMediaItem *song = [[IBFileManager sharedManager]getSongByPersistentID:[NSNumber numberWithUnsignedLongLong:coreDataSong.persistentID]];
    
    
   // IBMediaItem *song = [self.songs objectAtIndex:indexPath.row];
    
    MPMediaItem *songItem = (MPMediaItem*)song.mediaEntity;
    
    NSString *songTitle = [songItem valueForProperty:MPMediaItemPropertyTitle];
    NSString *artistTitle = [songItem valueForProperty:MPMediaItemPropertyArtist];
    NSNumber *playBackDuration = [songItem valueForProperty:MPMediaItemPropertyPlaybackDuration];
    
    double songDuration = [playBackDuration doubleValue] / 60;
    NSString *songDurationTitle = [NSString stringWithFormat:@"%5.2f",songDuration];
    
    if (songTitle == nil) {
        songTitle  = @"";
    }else if (artistTitle == nil){
        artistTitle = @"";
    }else if (songDurationTitle == nil){
        songDurationTitle = @"";
    }
    
    
    NSAttributedString *songName = [[NSAttributedString alloc] initWithString:songTitle];
    NSAttributedString *artistName = [[NSAttributedString alloc] initWithString:artistTitle];
    NSAttributedString *timeDuration = [[NSAttributedString alloc] initWithString:songDurationTitle];
    NSAttributedString *songCount = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%lld", coreDataSong.position + 1]];
    
    
    cell.songTitle.attributedText    = songName;
    cell.artistTitle.attributedText  = artistName;
    cell.timeDuration.attributedText = timeDuration;
    cell.songCount.attributedText    = songCount;
    
    
      
    
    if ([[IBCurrentParametersManager sharedManager] isEditing]) {
        
        IBPlayerItem *addButton;
        
        if (song.state == added_state) {
            
            addButton = [[IBPlayerItem alloc]initWithButtonStyle:choose];
            [addButton setIsSelected:YES];
            [addButton addTarget:self action:@selector(addToPlaylistAction:) forControlEvents:UIControlEventTouchUpInside];
            
        }else if (song.state == inPlaylist_state){
            
            addButton = [[IBPlayerItem alloc]initWithButtonStyle:chooseInPlaylist];
            
            if ([[IBCurrentParametersManager sharedManager] coreDataChangingPlaylist]) {
                [addButton setIsSelected:YES];
                [addButton addTarget:self action:@selector(addToPlaylistAction:) forControlEvents:UIControlEventTouchUpInside];
            }
            
            
        }else if (song.state == default_state){
            
            addButton = [[IBPlayerItem alloc]initWithButtonStyle:add];
            [addButton addTarget:self action:@selector(addToPlaylistAction:) forControlEvents:UIControlEventTouchUpInside];
            
        }
        
        cell.editingAccessoryView = addButton;
        
    }else{
        
        cell.editingAccessoryView = nil;
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



- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    IBSongCellTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    __weak IBSongsFromCoreDataViewController *weakSelf = self;
    
    NSDictionary *newAttributes = [IBFontAttributes attributesOfMainTitle];
    NSDictionary *systemAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:17]};
    
    NSString *title = @"DELETE";
    NSString *titleWhiteSpace = [self whitespaceReplacementString:title WithSystemAttributes:systemAttributes newAttributes:newAttributes];
    
    UITableViewRowAction *rowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:titleWhiteSpace handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        if (cell.editingStyle == UITableViewCellEditingStyleDelete) {
            
            [weakSelf.tableView beginUpdates];
            
            IBSongItem *removingSong = [weakSelf.fetchedResultsController objectAtIndexPath:indexPath];
            
            IBPlaylist *currentPlaylist = [[IBCurrentParametersManager sharedManager] coreDataPlaylist];
            
            [currentPlaylist removeSongItems:[NSSet setWithObject:removingSong]];
            [[IBCoreDataManager sharedManager]resortPositionsOfSongItemsInPlaylist:currentPlaylist];
            
            [[IBCoreDataManager sharedManager] saveContext];
            [weakSelf.tableView endUpdates];
           // [weakSelf.tableView reloadData];
            
        }
        
        
    }];
    
    
    UIImage *patternImage = [self imageForTableViewRowActionWithTitle:title textAttributes:newAttributes backgroundColor:[UIColor purpleColor] cellHeight:CGRectGetHeight(cell.bounds)];
    
    rowAction.backgroundColor = [UIColor colorWithPatternImage:patternImage];
    
    return [NSArray arrayWithObject:rowAction];
    
}




#pragma mark - Actions



- (void)addNewSongs{
    
    [[IBCurrentParametersManager sharedManager] setIsEditing:YES];//playlist was saved to IBCurrentParametersManager in IBPlaylistsController
    
    [[IBCurrentParametersManager sharedManager] setCoreDataChangingPlaylist:self.currentPlaylist];
    [[IBCurrentParametersManager sharedManager] setReturnSongsViewController:self];
    
    UINavigationController *nav = [self.storyboard instantiateViewControllerWithIdentifier:@"IBAllMediaNavigationViewController"];
    
    
    [self.navigationController presentViewController:nav animated:YES completion:nil];
    
}


- (void) removeSong{
    
    if ([self.tableView isEditing]) {
        [self.tableView setEditing:NO animated:YES];
    }else{
        [self.tableView setEditing:YES animated:YES];
        
    }    
    
}



- (void) addToPlaylistAction:(IBPlayerItem*) button{
    
    CGPoint point = [button convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:point];
    

    IBMediaItem *song = [self.songs objectAtIndex:indexPath.row];
    
    
    if (song.state == default_state) {
        
        [button setImage: [UIImage imageNamed:@"Added.png"]forState:UIControlStateSelected];
        [button setIsSelected:YES];
        song.state = added_state;
        [[IBCurrentParametersManager sharedManager].addedSongs addObject:song];
        
    }else if (song.state == added_state){
        
        [button setImage: [UIImage imageNamed:@"add 64 x 64.png"]forState:UIControlStateNormal];
        [button setIsSelected:NO];
        [[IBCurrentParametersManager sharedManager].addedSongs removeObject:song];
        song.state = default_state;
        
    }else if ( (song.state == inPlaylist_state) && ([[IBCurrentParametersManager sharedManager] coreDataChangingPlaylist])){
        
        [button setImage: [UIImage imageNamed:@"cancel-music(4).png"]forState:UIControlStateNormal];
        [button setIsSelected:NO];
        [[IBCurrentParametersManager sharedManager].removedSongs addObject:song];
        song.state = delete_state;
        
        NSLog(@"added songs = %lu",(unsigned long)[[[IBCurrentParametersManager sharedManager]addedSongs]count]);
        
        
    }else if (song.state == delete_state){
        
        [button setImage: [UIImage imageNamed:@"inPlaylist.png"]forState:UIControlStateNormal];
        [button setIsSelected:NO];
        [[IBCurrentParametersManager sharedManager].removedSongs removeObject:song];
        song.state = inPlaylist_state;
    }
    
}





@end
