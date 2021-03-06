//
//  IBSongsAddViewController.m
//  Retrowave Player
//
//  Created by eastwood on 22/05/2017.
//  Copyright © 2017 Илья Блинов. All rights reserved.
//

#import "IBSongsAddViewController.h"
#import "IBSongCellTableViewCell.h"
#import "IBArtistInfoViewController.h"
#import "IBAllMediaViewController.h"
#import "IBPlayerController.h"
#import "IBVisualizerMusic.h"





@interface IBSongsAddViewController ()

@property (strong, nonatomic) IBMediaItem *currentPlaylist;
@property (strong, nonatomic) NSArray *songs;

@end

@implementation IBSongsAddViewController


- (void) loadView{
    [super loadView];
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeNowPlayingSong:) name:MPMusicPlayerControllerNowPlayingItemDidChangeNotification object:nil];
    
    
    IBMediaItem *currentPlaylist = [[IBCurrentParametersManager sharedManager] playlist];
    self.currentPlaylist = currentPlaylist;
    
    NSDictionary *parameters = [[IBFileManager sharedManager] getPlaylistParams:currentPlaylist];
    self.songs      = [parameters objectForKey:@"songs"];
    NSString *title = [parameters objectForKey:@"title"];
    
    
    UIBarButtonItem *backItem =   [self setLeftBackBarButtonItem:title];
    [self.navigationItem setLeftBarButtonItem:backItem];
    
    self.navigationItem.titleView = [IBFontAttributes getCustomTitleForControllerName:@"Songs"];
    
    
}



- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];

    
    [ self.tableView setEditing: [[IBCurrentParametersManager sharedManager] isEditing]];
    
    if ([[IBCurrentParametersManager sharedManager] isEditing]) {
        
        IBBarButtonItem *chooseBarButton = [self createChooseSongsItem];
        
        NSArray *statesOfSongs = [self.songs valueForKeyPath:@"@distinctUnionOfObjects.state"];
        
        ItemState state = [[statesOfSongs firstObject] unsignedIntegerValue];
        
        ButtonStyle style = add_all;
        if (([statesOfSongs count] == 1) && (state == added_state)) {
            style = remove_all;
        }
        
        IBPlayerItem *addAllSongs = [[IBPlayerItem alloc] initWithButtonStyle:style];
        if (style == add_all) {
            [addAllSongs setIsSelected:YES];
        }else{
            [addAllSongs setIsSelected:NO];
        }
        [addAllSongs addTarget:self action:@selector(addAllSongs:) forControlEvents:UIControlEventTouchUpInside];
        IBBarButtonItem *addAllSongsBarButton = [[IBBarButtonItem alloc] initWithButton:addAllSongs];
        self.navigationItem.rightBarButtonItems = @[chooseBarButton,addAllSongsBarButton];
        
       self.songs = [[IBFileManager sharedManager] checkSongMediaItems:self.songs];
      
       [self.tableView reloadData];
    }else{
        
        IBPlayerItem *addToPlaylistButton = [[IBPlayerItem alloc] initWithButtonStyle:add];
        [addToPlaylistButton addTarget:self action:@selector(addNewSongs) forControlEvents:UIControlEventTouchUpInside];
        
        IBBarButtonItem *addToPlaylistItem = [[IBBarButtonItem alloc] initWithButton:addToPlaylistButton];
        
        self.navigationItem.rightBarButtonItem = addToPlaylistItem;

    }

  
    
    
    if ([self isEqual:[[IBCurrentParametersManager sharedManager]returnSongsViewController]]) {
        
        self.currentPlaylist = nil;
  
        
        [[IBCurrentParametersManager sharedManager].addedSongs removeAllObjects];
        [[IBCurrentParametersManager sharedManager].removedSongs removeAllObjects];
        [[IBCurrentParametersManager sharedManager] setChangingPlaylist:nil];
        [[IBCurrentParametersManager sharedManager] setReturnSongsViewController:nil];


}
    }

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    self.songs = nil;
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
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
    
    IBMediaItem *song = [self.songs objectAtIndex:indexPath.row];
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
    
    BOOL songIsNowPlaying = [self matchCurrentPlayingSongWithSong:song];
    
    [cell.songTitle setAttributedText:songName withNowPlayling:songIsNowPlaying];
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



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    IBMediaItem *song = [self.songs objectAtIndex:indexPath.row];
    
    [[IBCurrentParametersManager sharedManager] setCurrentSong:song];
    [[IBCurrentParametersManager sharedManager] setIsPlayingMusic:YES];
    [IBCurrentParametersManager sharedManager].queueOfPlayingItems = [self.songs valueForKeyPath:@"@unionOfObjects.mediaEntity"];
    [self.tabBarController setSelectedIndex:2];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleNone;
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath{
    return NO;
}


#pragma mark - UITableViewDataSource

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return YES;
    
}


#pragma mark - Actions

- (void) addAllSongs:(IBPlayerItem*) button{
    
    NSArray *allStatesOfSongs = [self.songs valueForKeyPath:@"@distinctUnionOfObjects.state"];
    ItemState state = [[allStatesOfSongs firstObject] unsignedIntegerValue];
    if ( (([allStatesOfSongs count] == 1) && (state == inPlaylist_state )) | ([self.songs count] == 0) ) {
    }else{
        if ([button isSelected]) {
            [button setImage: [UIImage imageNamed:@"cancel_all.png"]forState:UIControlStateNormal];
            [button setIsSelected:NO];
            
            for (IBMediaItem *song in self.songs) {
                if (song.state == default_state) {
                    song.state = added_state;
                    [[IBCurrentParametersManager sharedManager].addedSongs addObject:song];
                }
            }
        }else{
            [button setImage: [UIImage imageNamed:@"add_all.png"]forState:UIControlStateNormal];
            [button setIsSelected:YES];
            
            
            for (IBMediaItem *song in self.songs) {
                if (song.state == added_state) {
                    [[IBCurrentParametersManager sharedManager] removeSongFromArray:song];
                    song.state = default_state;
                }
            }
        }
        
        
    }
    
    [self.tableView reloadData];
    
}





- (void) addToPlaylistAction:(IBPlayerItem*) button{
    
    
    CGPoint point = [button convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:point];
    
    IBMediaItem *song = [self.songs objectAtIndex:indexPath.row];
    
    if (song.state == default_state) {
        
        [button setImage: [UIImage imageNamed:@"Added.png"]forState:UIControlStateNormal];
        song.state = added_state;
        [[IBCurrentParametersManager sharedManager].addedSongs addObject:song];
        
    }else if (song.state == added_state){
        
        [button setImage: [UIImage imageNamed:@"add 64 x 64.png"]forState:UIControlStateNormal];
        [[IBCurrentParametersManager sharedManager].addedSongs removeObject:song];
        song.state = default_state;
        
    }else if ( (song.state == inPlaylist_state) && ([[IBCurrentParametersManager sharedManager] coreDataChangingPlaylist])){
        
        [button setImage: [UIImage imageNamed:@"cancel-music(4).png"]forState:UIControlStateNormal];
        [[IBCurrentParametersManager sharedManager].removedSongs addObject:song];
        song.state = delete_state;
        
        NSLog(@"added songs = %lu",(unsigned long)[[[IBCurrentParametersManager sharedManager]addedSongs]count]);
        
        
    }else if (song.state == delete_state){
        
        [button setImage: [UIImage imageNamed:@"inPlaylist.png"]forState:UIControlStateNormal];
        [[IBCurrentParametersManager sharedManager].removedSongs removeObject:song];
        song.state = inPlaylist_state;
    }
    
}

- (void) reloadSongs{
    
    IBMediaItem *currentPlaylist = [[IBCurrentParametersManager sharedManager] playlist];

   
    NSDictionary *parameters = [[IBFileManager sharedManager] getPlaylistParams:currentPlaylist];
    self.songs      = [parameters objectForKey:@"songs"];
    

     self.currentPlaylist = currentPlaylist;
    [self.tableView reloadData];
    
   
    
}



- (void)addNewSongs{
    
        [[IBCurrentParametersManager sharedManager] setIsEditing:YES];//playlist was saved to IBCurrentParametersManager in IBPlaylistsController
    
    [[IBCurrentParametersManager sharedManager] setChangingPlaylist:self.currentPlaylist];
    [[IBCurrentParametersManager sharedManager] setReturnSongsViewController:self];
    
    UINavigationController *nav = [self.storyboard instantiateViewControllerWithIdentifier:@"IBAllMediaNavigationViewController"];
    
        [self.navigationController presentViewController:nav animated:YES completion:nil];
     
}
#pragma mark - Notifications


- (void) changeNowPlayingSong:(NSNotification*) notification{
    
    NSLog(@"notInfo = %@", notification.userInfo);
    
    NSNumber *persistentIDOfNowPlayingItem = [notification.userInfo valueForKey:@"MPMusicPlayerControllerNowPlayingItemPersistentIDKey"];
    
    if ([persistentIDOfNowPlayingItem longLongValue] != 0) {
        
        [[MPMusicPlayerController systemMusicPlayer]endGeneratingPlaybackNotifications];
        NSDictionary *parameters = [[IBFileManager sharedManager] getPlaylistParams:self.currentPlaylist];
        self.songs      = [parameters objectForKey:@"songs"];
        [self.tableView reloadData];
        
    }
    
}

@end
