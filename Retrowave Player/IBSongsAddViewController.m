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





@interface IBSongsAddViewController ()<UINavigationControllerDelegate>

@property (strong, nonatomic) MPMediaPlaylist *currentPlaylist;

@end

@implementation IBSongsAddViewController





- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *title;
    
    MPMediaPlaylist *currentPlaylist = [[IBCurrentParametersManager sharedManager] playlist];
    self.currentPlaylist = currentPlaylist;
    NSArray *songsArray = [currentPlaylist items];
    title = [currentPlaylist valueForProperty:MPMediaPlaylistPropertyName];
    
    
    UIBarButtonItem *backItem =   [self setLeftBackBarButtonItem:title];
    [self.navigationItem setLeftBarButtonItem:backItem];
    
    self.navigationItem.titleView = [IBFontAttributes getCustomTitleForControllerName:@"Songs"];
    
    
    
    if ((currentPlaylist) && ([currentPlaylist.items count] == 0)) {
        
    }else{
        
        self.songs = nil;
        
        self.songs = [NSArray arrayWithArray:songsArray];
    }
    
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
    
    
    return [[self.currentPlaylist items] count];
}


- (IBSongCellTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static  NSString *identifier = @"cell";
    
    IBSongCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[IBSongCellTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                              reuseIdentifier:identifier];
    }
    
    MPMediaItem *song = [[self.currentPlaylist items] objectAtIndex:indexPath.row];
    
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


- (IBAction)addNewSongs:(IBPlayerItem *) button{
    
        [[IBCurrentParametersManager sharedManager] setIsEditing:YES];//playlist was saved to IBCurrentParametersManager in IBPlaylistsController
    
    [[IBCurrentParametersManager sharedManager] setChangingPlaylist:self.currentPlaylist];
    [[IBCurrentParametersManager sharedManager] setReturnSongsViewController:self];
    
        IBAllMediaViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"IBAllMediaViewController"];
        
        self.navigationController.delegate = self;
    
        
        [self.navigationController pushViewController:vc animated:YES];
     
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(IBSongsAddViewController *)viewController animated:(BOOL)animated{
    
    
    
    if ([viewController isKindOfClass:[IBSongsAddViewController class]] && ([[IBCurrentParametersManager sharedManager] isEditing])) {
       
        NSLog(@"songsCount = %d", [[self.currentPlaylist items]count]);
        
        [[IBCurrentParametersManager sharedManager] setIsEditing:NO];
        
        self.navigationController.delegate = nil;
        
        
        self.currentPlaylist = [[IBCurrentParametersManager sharedManager] changingPlaylist];
       
NSLog(@"songsCount = %d", [[self.currentPlaylist items]count]);
        
        [[IBCurrentParametersManager sharedManager].addedSongs removeAllObjects];
        [[IBCurrentParametersManager sharedManager] setChangingPlaylist:nil];
        
        [self.tableView reloadData];
        
        
    }
    
    
}
@end
