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
        
       self.navigationItem.rightBarButtonItem =  [self createChooseSongsItem];
       self.songs = [[IBFileManager sharedManager] checkMediaItems:self.songs];
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
    
    
    cell.songTitle.attributedText    = songName;
    cell.artistTitle.attributedText  = artistName;
    cell.timeDuration.attributedText = timeDuration;
    cell.songCount.attributedText    = songCount;

    
    if ([[IBCurrentParametersManager sharedManager] isEditing]) {
        
        IBPlayerItem *addButton;
        
        if (song.state == added) {
            
            addButton = [[IBPlayerItem alloc]initWithButtonStyle:choose];
            [addButton setIsSelected:YES];
            [addButton addTarget:self action:@selector(addToPlaylistAction:) forControlEvents:UIControlEventTouchUpInside];
            
        }else if (song.state == inPlaylist){
            
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
    
    
    IBPlayerController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"IBPlayerController"];
    
    [vc setSong:song];
    [vc.playPauseButton setSelected: YES];
    
    [self.navigationController pushViewController:vc animated:YES];
    
    
    
    
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


- (void) addToPlaylistAction:(IBPlayerItem*) button{
    
    
    CGPoint point = [button convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:point];
    
    IBMediaItem *song = [self.songs objectAtIndex:indexPath.row];
    
    if (song.state == default_state) {
        
        [button setImage: [UIImage imageNamed:@"Added.png"]forState:UIControlStateSelected];
        [button setIsSelected:YES];
        song.state = added;
        [[IBCurrentParametersManager sharedManager].addedSongs addObject:song];
        
    }else if (song.state == added){
        
        [button setImage: [UIImage imageNamed:@"add 64 x 64.png"]forState:UIControlStateNormal];
        [button setIsSelected:NO];
        [[IBCurrentParametersManager sharedManager].addedSongs removeObject:song];
        song.state = default_state;
        
    }else if (song.state == inPlaylist){
        
        [button setImage: [UIImage imageNamed:@"add 64 x 64.png"]forState:UIControlStateNormal];
        [button setIsSelected:NO];
        [[IBCurrentParametersManager sharedManager].removedSongs addObject:song];
        song.state = default_state;
        
        NSLog(@"added songs = %lu",(unsigned long)[[[IBCurrentParametersManager sharedManager]addedSongs]count]);
        
        
    }
    
}

- (void) reloadSongs{
    
    IBMediaItem *currentPlaylist = [[IBCurrentParametersManager sharedManager] playlist];

   
    NSDictionary *parameters = [[IBFileManager sharedManager] getPlaylistParams:currentPlaylist];
    self.songs      = [parameters objectForKey:@"songs"];
    
    [self.tableView beginUpdates];
    
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.songs count] - 1 inSection:0];
    
    self.currentPlaylist = currentPlaylist;
    [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath ] withRowAnimation:UITableViewRowAnimationBottom];
    [self.tableView endUpdates];
    
}



- (void)addNewSongs{
    
        [[IBCurrentParametersManager sharedManager] setIsEditing:YES];//playlist was saved to IBCurrentParametersManager in IBPlaylistsController
    
    [[IBCurrentParametersManager sharedManager] setChangingPlaylist:self.currentPlaylist];
    [[IBCurrentParametersManager sharedManager] setReturnSongsViewController:self];
    
    UINavigationController *nav = [self.storyboard instantiateViewControllerWithIdentifier:@"IBAllMediaNavigationViewController"];
    
        
        [self.navigationController presentViewController:nav animated:YES completion:nil];
     
}


@end
