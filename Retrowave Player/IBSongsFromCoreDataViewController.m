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

- (void)loadView
{
    [super loadView];
    
    
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
    
    return [[self.fetchedResultsController fetchedObjects]count];
    
    
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
    NSAttributedString *songCount = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d", indexPath.row + 1]];
    
    
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

#pragma mark - Actions



- (void)addNewSongs{
    
    [[IBCurrentParametersManager sharedManager] setIsEditing:YES];//playlist was saved to IBCurrentParametersManager in IBPlaylistsController
    
    [[IBCurrentParametersManager sharedManager] setCoreDataChangingPlaylist:self.currentPlaylist];
    [[IBCurrentParametersManager sharedManager] setReturnSongsViewController:self];
    
    UINavigationController *nav = [self.storyboard instantiateViewControllerWithIdentifier:@"IBAllMediaNavigationViewController"];
    
    
    [self.navigationController presentViewController:nav animated:YES completion:nil];
    
}









@end
