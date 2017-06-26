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
#import "IBPlayerItem.h"
#import "IBSongsAddViewController.h"








@interface IBSongsViewController ()



@end

@implementation IBSongsViewController



//- (void)viewWillAppear:(BOOL)animated{
//    
//    [super viewWillAppear:animated];
- (void)viewDidLoad
{
    
    
    [super viewDidLoad];
    
    NSDictionary *titleAndSongsDictionary = [[IBCurrentParametersManager sharedManager]
                                                                                    getSongsAndTitleForSongViewController];
    
    NSString *title = [titleAndSongsDictionary valueForKey:@"title"];
    NSArray *songs  = [titleAndSongsDictionary valueForKey:@"songs"];
    self.songs = [NSArray arrayWithArray:songs];

    
    
    UIBarButtonItem *backItem =   [self setLeftBackBarButtonItem:title];
    [self.navigationItem setLeftBarButtonItem:backItem];
    self.navigationItem.titleView = [IBFontAttributes getCustomTitleForControllerName:@"Songs"];
    
    
    
    if ([self.navigationController.tabBarItem.title isEqualToString:@"Songs"]) {
        [self.navigationItem setLeftBarButtonItem:nil];
        [self.navigationController setNavigationBarHidden:YES];
        [self.navigationItem setHidesBackButton:YES animated:NO];
    }
    
    
    if ([[IBCurrentParametersManager sharedManager] isEditing]) {
        
        IBPlayerItem *addToPlaylistButton = [[IBPlayerItem alloc] initWithFrame:CGRectMake(0,0, 20, 20)];
        [addToPlaylistButton setImage: [UIImage imageNamed:@"Added.png"]forState:UIControlStateNormal];
        [addToPlaylistButton addTarget:self action:@selector(chooseSongs:) forControlEvents:UIControlEventTouchUpInside];
        
        
        UIBarButtonItem *addToPlaylistItem = [[UIBarButtonItem alloc] initWithCustomView:addToPlaylistButton];
        self.navigationItem.rightBarButtonItem = addToPlaylistItem;
        
        
        [self.navigationController setNavigationBarHidden:NO];
        [self.tableView setEditing:YES];
        
    }

    
  //  [self.tableView reloadData];
    
    
 
    
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
    
    if ([self.songs count] != 0) {
        
    
    
    MPMediaItem *song = [self.songs objectAtIndex:indexPath.row];
    
    NSString *songTitle        = [song valueForProperty:MPMediaItemPropertyTitle];
    NSString *artistTitle      = [song valueForProperty:MPMediaItemPropertyArtist];
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
    
    
    NSAttributedString *songName     = [[NSAttributedString alloc] initWithString:songTitle];
    NSAttributedString *artistName   = [[NSAttributedString alloc] initWithString:artistTitle];
    NSAttributedString *timeDuration = [[NSAttributedString alloc] initWithString:songDurationTitle];
    NSAttributedString *songCount    = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d", indexPath.row + 1]];
    
    
    cell.songTitle.attributedText    = songName;
    cell.artistTitle.attributedText  = artistName;
    cell.timeDuration.attributedText = timeDuration;
    cell.songCount.attributedText    = songCount;
        
        
    if ([[IBCurrentParametersManager sharedManager] isEditing]) {
            
            IBPlayerItem *addToPlaylistButton = [[IBPlayerItem alloc] initWithFrame:CGRectMake(0,0, 20, 20)];
            [addToPlaylistButton addTarget:self action:@selector(addToPlaylistAction:) forControlEvents:UIControlEventTouchUpInside];
            
            
            [addToPlaylistButton setImage: [UIImage imageNamed:@"add 64 x 64.png"]forState:UIControlStateNormal];
            cell.editingAccessoryView = addToPlaylistButton;
            
    }else{
            
            cell.editingAccessoryView = nil;
        }
    
        
        
    
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

- (void)chooseSongs:(IBPlayerItem *) button{
    
    [IBCurrentParametersManager sharedManager].songsViewControllerDataViewMode = playlist;
    MPMediaPlaylist *currentPlaylist = [[IBCurrentParametersManager sharedManager] changingPlaylist];
    
    NSArray *addedSongs              = [NSArray arrayWithArray:[[IBCurrentParametersManager sharedManager] addedSongs]];
    IBSongsAddViewController *vc     = [[IBCurrentParametersManager sharedManager] returnSongsViewController];
    
    
    __weak IBSongsAddViewController     *weakVC   = vc;
    
    
    
    NSLog(@"tabvccount = %d", [[self.tabBarController viewControllers]count]);
    
    UINavigationController *navAllVC = [self.tabBarController.viewControllers objectAtIndex:0];
    
   
    
    UINavigationController *navPlaylistVC = [self.tabBarController.viewControllers objectAtIndex:3];
    __weak UINavigationController        *weakNavPlaylistVC = navPlaylistVC;
    

    
    
    NSLog(@"VC_COUNT = %d",[[self.navigationController viewControllers] count]);
    NSLog(@"VC:%@",[[self.navigationController viewControllers] firstObject]);
    
    [currentPlaylist addMediaItems:addedSongs completionHandler:^(NSError * _Nullable error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakNavPlaylistVC popToViewController:vc animated:YES];
                   });
        
    }];
    [navAllVC popToRootViewControllerAnimated:YES];

}







@end
