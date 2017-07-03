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
#import "IBPlayerItem.h"
#import "IBFileManager.h"




@interface IBSongsAddViewController ()<UINavigationControllerDelegate>

@property (strong, nonatomic) MPMediaPlaylist *currentPlaylist;
@property (strong, nonatomic) NSArray *songs;

@end

@implementation IBSongsAddViewController


- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];

    [ self.tableView setEditing: [[IBCurrentParametersManager sharedManager] isEditing]];
    
    if ([[IBCurrentParametersManager sharedManager] isEditing]) {
        
        [self createChooseSongsItem];
        
    }else{
        
        IBPlayerItem *addToPlaylistButton = [[IBPlayerItem alloc] initWithFrame:CGRectMake(0,0, 20, 20)];
        [addToPlaylistButton setImage: [UIImage imageNamed:@"add 64 x 64.png"]forState:UIControlStateNormal];
        [addToPlaylistButton addTarget:self action:@selector(addNewSongs) forControlEvents:UIControlEventTouchUpInside];
        
        
        UIBarButtonItem *addToPlaylistItem = [[UIBarButtonItem alloc] initWithCustomView:addToPlaylistButton];
        self.navigationItem.rightBarButtonItem = addToPlaylistItem;

    }

  
    
    
    if ([self isEqual:[[IBCurrentParametersManager sharedManager]returnSongsViewController]]) {
        
    self.currentPlaylist = nil;
    MPMediaPlaylist *currentPlaylist = [[IBCurrentParametersManager sharedManager] changingPlaylist];
    NSDictionary *parameters = [[IBFileManager sharedManager] getPlaylistParams:currentPlaylist];
    self.songs      = [parameters objectForKey:@"songs"];

    self.currentPlaylist = currentPlaylist;
        
    NSLog(@"songsCount = %d", [[self.currentPlaylist items]count]);
    
    [[IBCurrentParametersManager sharedManager].addedSongs removeAllObjects];
    [[IBCurrentParametersManager sharedManager] setChangingPlaylist:nil];
    [[IBCurrentParametersManager sharedManager] setReturnSongsViewController:nil];
    [self.tableView reloadData];

}
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    MPMediaPlaylist *currentPlaylist = [[IBCurrentParametersManager sharedManager] playlist];
    self.currentPlaylist = currentPlaylist;
    
    NSDictionary *parameters = [[IBFileManager sharedManager] getPlaylistParams:currentPlaylist];
    self.songs      = [parameters objectForKey:@"songs"];
    NSString *title = [parameters objectForKey:@"title"];
    
    
    UIBarButtonItem *backItem =   [self setLeftBackBarButtonItem:title];
    [self.navigationItem setLeftBarButtonItem:backItem];
    
    self.navigationItem.titleView = [IBFontAttributes getCustomTitleForControllerName:@"Songs"];
    self.navigationController.delegate = self;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    MPMediaItem *song = [self.songs objectAtIndex:indexPath.row];
    
    NSString *songTitle = [song valueForProperty:MPMediaItemPropertyTitle];
    NSString *artistTitle = [song valueForProperty:MPMediaItemPropertyArtist];
    NSNumber *playBackDuration = [song valueForProperty:MPMediaItemPropertyPlaybackDuration];
    
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
        
        cell.editingAccessoryView = [self createAddSongsToPlaylistButton];
        
    }else{
        
        cell.editingAccessoryView = nil;
    }
   
    
    return cell;
    
}


#pragma mark - UITableViewDelegate



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MPMediaItem *song = [self.songs objectAtIndex:indexPath.row];
    
    
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
    
    MPMediaItem *song = [self.songs objectAtIndex:indexPath.row];
    
    if (button.isSelected == NO) {
        [button setImage: [UIImage imageNamed:@"Added.png"]forState:UIControlStateSelected];
        [button setIsSelected:YES];
        [[IBCurrentParametersManager sharedManager].addedSongs addObject:song];
    }else{
        [button setImage: [UIImage imageNamed:@"add 64 x 64.png"]forState:UIControlStateNormal];
        [button setIsSelected:NO];
        [[IBCurrentParametersManager sharedManager].addedSongs removeObject:song];
    }
    
    
    NSLog(@"added songs = %u",[[[IBCurrentParametersManager sharedManager]addedSongs]count]);
    
    
}




- (void)addNewSongs{
    
        [[IBCurrentParametersManager sharedManager] setIsEditing:YES];//playlist was saved to IBCurrentParametersManager in IBPlaylistsController
    
    [[IBCurrentParametersManager sharedManager] setChangingPlaylist:self.currentPlaylist];
    [[IBCurrentParametersManager sharedManager] setReturnSongsViewController:self];
    
    UINavigationController *nav = [self.storyboard instantiateViewControllerWithIdentifier:@"IBAllMediaNavigationViewController"];
    
        
        [self.navigationController presentViewController:nav animated:YES completion:nil];
     
}


@end
