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



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
   
    IBMainTabBarController *tabBarController = (IBMainTabBarController*)self.tabBarController;
    IBVisualizerMusic *visualizer = [tabBarController visualizer];
    
    self.visualizer = visualizer;
    
    
    MPVolumeView *volumeView = [[MPVolumeView alloc] initWithFrame:CGRectMake(18, 440, 284, 31)];
    [self.view addSubview:volumeView];
    
    self.musicPlayerController =  [MPMusicPlayerController systemMusicPlayer];
    
    
    NSArray *queuePlaylingItems = [[IBCurrentParametersManager sharedManager] queueOfPlayingItems];
    
    if ([queuePlaylingItems count] > 0) {
        self.queueOfSongs = queuePlaylingItems;
    }
    
    
    
    if ([[IBCurrentParametersManager sharedManager] isPlayingMusic]) {
    
        MPMediaItem *currentSong = (MPMediaItem*)[[[IBCurrentParametersManager sharedManager]currentSong] mediaEntity];
        
        if ((self.musicPlayerController.playbackState == MPMusicPlaybackStatePlaying) && ([self.musicPlayerController.nowPlayingItem isEqual:currentSong])) {
        }else{
            [self.musicPlayerController stop];
        
    if (currentSong) {
        [self.musicPlayerController setNowPlayingItem:nil];
        [self.musicPlayerController setNowPlayingItem:currentSong];
        NSLog(@"index of now item = %d",[self.musicPlayerController indexOfNowPlayingItem]);
        }
        
        [self.musicPlayerController prepareToPlay];
        [self.musicPlayerController play];
        
        
    [self.playPauseButton setSelected:YES];
    
    self.timerForMusicTimeLineRefresh = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateMusicTimeLine) userInfo:nil repeats:YES];
       
    [self.visualizer startKenwoodVisualizerAnimation];
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
        [button setSelected:NO];
          }

    else {
        [self.musicPlayerController play];
        [self.visualizer startKenwoodVisualizerAnimation];
        self.visualizer.isStarted = YES;
        [button setSelected:YES];
       
    }
    
}


- (IBAction)volumeSliderValueChanged:(UISlider*) slider{
    
}




- (IBAction)fastForwarButtonAction   :(UIButton*) button{
    
    
    
}

- (IBAction)fastRemindButtonAction   :(UIButton*) button{
    
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
    
    }
    return currentSong;
    
}




@end
