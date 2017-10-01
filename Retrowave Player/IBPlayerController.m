//
//  IBPlayerController.m
//  APlayer
//
//  Created by ilyablinov on 02.03.17.
//  Copyright (c) 2017 IB. All rights reserved.
//

#import "IBPlayerController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "IBMainTabBarController.h"
#import "IBPlayerItem.h"
#import "IBVisualizerMusic.h"
#import "IBFileManager.h"

@interface IBPlayerController ()

@property (strong, nonatomic) MPMusicPlayerController *musicPlayerController;
@property (strong, nonatomic) MPMediaItem *currentSong;
@property (strong, nonatomic) NSTimer *timerForMusicTimeLineRefresh;
@property (strong, nonatomic) NSArray *queueOfSongs;


@end

@implementation IBPlayerController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
     self.musicPlayerController =  [MPMusicPlayerController systemMusicPlayer];
    
    IBMainTabBarController *tabBarController = (IBMainTabBarController*)self.tabBarController;
    IBVisualizerMusic *visualizer = [tabBarController visualizer];
    
    self.visualizer = visualizer;
    [self.playPauseButton setSelected:YES];
    
    MPVolumeView *volumeView = [[MPVolumeView alloc] initWithFrame:CGRectMake(18, 440, 284, 31)];
    [self.view addSubview:volumeView];
    
}



- (void)viewWillAppear:(BOOL)animated
{
    
   
    
    if ([[IBCurrentParametersManager sharedManager] isPlayingMusic]) {
    
        MPMediaItem *nowPlaylingSong = [self.musicPlayerController nowPlayingItem];
        
        NSLog(@"nowPlaylingSongTitle = %@",[nowPlaylingSong valueForProperty:MPMediaItemPropertyTitle]);
        NSArray *queuePlaylingItems = [[IBCurrentParametersManager sharedManager] queueOfPlayingItems];
        
        
        
        
        MPMediaItem *currentSong = (MPMediaItem*)[[[IBCurrentParametersManager sharedManager]currentSong] mediaEntity];
        
        if ((self.musicPlayerController.playbackState == MPMusicPlaybackStatePlaying) && ([self.musicPlayerController.nowPlayingItem isEqual:currentSong])) {
        }else{
            [self.musicPlayerController stop];
        
            if ([queuePlaylingItems count] > 0) {
                self.queueOfSongs = queuePlaylingItems;
                [self.musicPlayerController setQueueWithItemCollection:[MPMediaItemCollection collectionWithItems:queuePlaylingItems]];
            }

            
            
    if (currentSong) {
        //[self.musicPlayerController setNowPlayingItem:nil];
        [self.musicPlayerController setNowPlayingItem:currentSong];
        
        self.albumArt.image = [self getAlbumArtFromSong:currentSong];
        NSLog(@"index of now item = %d and title = %@",[self.musicPlayerController indexOfNowPlayingItem],[currentSong valueForProperty:MPMediaItemPropertyTitle]);
        
        }
        
        [self.musicPlayerController prepareToPlay];
        [self.musicPlayerController play];
        
        
    [self.playPauseButton setSelected:YES];
    
    self.timerForMusicTimeLineRefresh = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateMusicTimeLine) userInfo:nil repeats:YES];
       
    [self.visualizer startVisualizerAnimation];
    self.visualizer.isStarted = YES;
        
    }
   
    }else{
        [self.playPauseButton setSelected:NO];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions


- (IBAction)playPauseButtonAction:(IBPlayerItem *) button{
   
    if ( [self.visualizer isStarted]){
        [self.musicPlayerController pause];
        [self.visualizer stopVisualizerAnimation];
         self.visualizer.isStarted = NO;
        [IBCurrentParametersManager sharedManager].isPlayingMusic = NO;
        [button setSelected:NO];
          }

    else {
        [self.musicPlayerController play];
        [self.visualizer startVisualizerAnimation];
        self.visualizer.isStarted = YES;
         [IBCurrentParametersManager sharedManager].isPlayingMusic = YES;
        [button setSelected:YES];
       
    }
    
}


- (IBAction)volumeSliderValueChanged:(UISlider*) slider{
    
}




- (IBAction)fastForwarButtonAction   :(UIButton*) button{
    MPMediaItem *nextSong = [self getNextSong];
    self.albumArt.image = [self getAlbumArtFromSong:nextSong];
      [self playNextOrPreviousSong:nextSong];
}

- (IBAction)fastRemindButtonAction   :(UIButton*) button{
    MPMediaItem *previousSong = [self getPreviousSong];
    self.albumArt.image = [self getAlbumArtFromSong:previousSong];
    [self playNextOrPreviousSong:previousSong];
}

- (IBAction)timeLineSliderValueChanged :(UISlider*) slider{
    
}

#pragma mark - TimerForUpdateMusicTimeLine


- (void) updateMusicTimeLine{
    
//    self.currentSong =  self.musicPlayerController.nowPlayingItem;
//    
//    self.musicTimeLabelForLine.text = [NSString stringWithFormat:@"%5.2f",self.currentSong.playbackDuration];
    
    
}


#pragma mark - Get songs

- (MPMediaItem*) getNextSong{
    
    MPMediaItem *currentSong = [self.musicPlayerController nowPlayingItem];
    
    if ([self.queueOfSongs containsObject:currentSong]) {
        
        NSInteger indexOfCurrentSong = [self.queueOfSongs indexOfObject:currentSong];
        
        if (indexOfCurrentSong == [self.queueOfSongs indexOfObject:[self.queueOfSongs lastObject]]) {
            return [self.queueOfSongs firstObject];
        }
        if ([self.queueOfSongs count] == 1) {
            return currentSong;
        }
    
        
        MPMediaItem *nextSong = [self.queueOfSongs objectAtIndex:indexOfCurrentSong + 1];
        NSLog(@"nextSongTitle = %@",[nextSong valueForProperty:MPMediaItemPropertyTitle]);
        return nextSong;
        
    }
    return currentSong;
    
}



- (MPMediaItem*) getPreviousSong{
    
    MPMediaItem *currentSong = [self.musicPlayerController nowPlayingItem];
    
    if ([self.queueOfSongs containsObject:currentSong]) {
        
        NSInteger indexOfCurrentSong = [self.queueOfSongs indexOfObject:currentSong];
        
        if (indexOfCurrentSong == [self.queueOfSongs indexOfObject:[self.queueOfSongs firstObject]]) {
            return [self.queueOfSongs lastObject];
        }
        if ([self.queueOfSongs count] == 1) {
            return currentSong;
        }
        
        
        MPMediaItem *previousSong = [self.queueOfSongs objectAtIndex:indexOfCurrentSong - 1];
        NSLog(@"nextSongTitle = %@",[previousSong valueForProperty:MPMediaItemPropertyTitle]);
        return previousSong;
        
    }
    return currentSong;
    
}




#pragma mark - get parameters for player

- (UIImage*) getAlbumArtFromSong:(MPMediaItem*) song{
    
    MPMediaItemArtwork *albumImageItem = [song valueForProperty:MPMediaItemPropertyArtwork];
    CGRect imageRect = self.albumArt.bounds;
    CGSize sizeOfAlbumImageItem = CGSizeMake(CGRectGetWidth(imageRect), CGRectGetHeight(imageRect));
    UIImage *albumImage;
    if (albumImageItem) {
        albumImage = [albumImageItem imageWithSize:sizeOfAlbumImageItem];
    }else{
        UIImage *defaultArtAlbum = [UIImage imageNamed:@"anonymous-logo(6).png"];
        albumImage = defaultArtAlbum;
    }
    
    return albumImage;
}


- (void) playNextOrPreviousSong:(MPMediaItem*) song{
    
    [self.musicPlayerController stop];
    [self.musicPlayerController setNowPlayingItem:nil];
    [self.musicPlayerController setNowPlayingItem:song];
    [self.musicPlayerController prepareToPlay];
    [self.musicPlayerController play];
    [self.playPauseButton setSelected:YES];
     [IBCurrentParametersManager sharedManager].isPlayingMusic = YES;
    
}

@end
