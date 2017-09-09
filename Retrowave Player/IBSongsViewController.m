//
//  IBSongsViewController.m
//  APlayer
//
//  Created by ilyablinov on 28.02.17.
//  Copyright (c) 2017 IB. All rights reserved.
//

#import "IBSongsViewController.h"
#import "IBSongCellTableViewCell.h"
#import "IBArtistInfoViewController.h"
#import "IBAllMediaViewController.h"
#import "IBPlayerController.h"
#import "IBVisualizerMusic.h"
#import "IBSongsAddViewController.h"








@interface IBSongsViewController ()

@end

@implementation IBSongsViewController




- (void)viewDidLoad
{
    
    
    [super viewDidLoad];
    
    IBSongsViewType songsType = [[IBCurrentParametersManager sharedManager] songsViewType];
    NSDictionary *titleAndSongsDictionary = [[IBFileManager sharedManager] getSongsAndTitleFor:songsType];
    
    NSString *title = [titleAndSongsDictionary valueForKey:@"title"];
    NSArray  *songs  = [titleAndSongsDictionary valueForKey:@"songs"];
    

    
    if ([[IBCurrentParametersManager sharedManager] isEditing]) {
        
        self.navigationItem.rightBarButtonItem = [self createChooseSongsItem];
        
        [self.navigationController setNavigationBarHidden:NO];
        [self.tableView setEditing:YES];
        self.songs = [[IBFileManager sharedManager] checkSongMediaItems:songs];
        
      
        
    }else{
        self.songs = [NSArray arrayWithArray:songs];
    }
    
        if ([self.navigationController.tabBarItem.title isEqualToString:@"Songs"]){
        
        [self.navigationItem setLeftBarButtonItem:nil];
        [self.navigationController setNavigationBarHidden:YES];
        [self.navigationItem setHidesBackButton:YES animated:NO];
        
        
        }else{

    UIBarButtonItem *backItem =   [self setLeftBackBarButtonItem:title];
    [self.navigationItem setLeftBarButtonItem:backItem];
    self.navigationItem.titleView = [IBFontAttributes getCustomTitleForControllerName:@"Songs"];
        }
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
    
    if ([self.songs count] != 0) {
        
    
    
    IBMediaItem *song = [self.songs objectAtIndex:indexPath.row];
    MPMediaItem *songItem = (MPMediaItem*)song.mediaEntity;
        
    NSString *songTitle        = [songItem valueForProperty:MPMediaItemPropertyTitle];
    NSString *artistTitle      = [songItem valueForProperty:MPMediaItemPropertyArtist];
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
    
    
    NSAttributedString *songName     = [[NSAttributedString alloc] initWithString:songTitle];
    NSAttributedString *artistName   = [[NSAttributedString alloc] initWithString:artistTitle];
    NSAttributedString *timeDuration = [[NSAttributedString alloc] initWithString:songDurationTitle];
    NSAttributedString *songCount    = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld", indexPath.row + 1]];
    
    
    cell.songTitle.attributedText    = songName;
    cell.artistTitle.attributedText  = artistName;
    cell.timeDuration.attributedText = timeDuration;
    cell.songCount.attributedText    = songCount;
        
      IBPlayerItem  *addButton = [[IBPlayerItem alloc]initWithItemState:song.state];
       [addButton addTarget:self action:@selector(addToPlaylistAction:) forControlEvents:UIControlEventTouchUpInside];

        [cell setEditingView:addButton];
        
    }
    return cell;

}


#pragma mark - UITableViewDelegate



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
       IBMediaItem *song = [self.songs objectAtIndex:indexPath.row];
   
    
//    IBPlayerController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"IBPlayerController"];
//    
//    [vc setSong:song];
//    [vc.playPauseButton setSelected: YES];
//
//    [self.navigationController pushViewController:vc animated:YES];
    
    
    
    
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
        
        [button setImage: [UIImage imageNamed:@"add 64 x 64.png"]forState:UIControlStateNormal];
        [button setIsSelected:NO];
        [[IBCurrentParametersManager sharedManager].removedSongs removeObject:song];
        song.state = default_state;
    }

}





@end
