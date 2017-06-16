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

@interface IBPlayerController ()

@property (strong, nonatomic) MPMusicPlayerController *musicPlayerController;
@property (strong, nonatomic) MPMediaItem *currentSong;
@property (strong, nonatomic) NSTimer *timerForMusicTimeLineRefresh;



@end

@implementation IBPlayerController



- (void)viewDidLoad
{
    [super viewDidLoad];
  
    self.navigationItem.hidesBackButton = YES;
    self.navigationController.navigationBarHidden = YES;

    
   IBMainTabBarController *tabBarController = (IBMainTabBarController*)[self.navigationController tabBarController];
    
    IBVisualizerMusic *visualizer = [tabBarController visualizer];
    
    self.visualizer = visualizer;
    
   
    [self.playPauseButton setSelected:NO];
    
    self.timerForMusicTimeLineRefresh = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateMusicTimeLine) userInfo:nil repeats:YES];
    
    self.musicPlayerController =  [MPMusicPlayerController applicationMusicPlayer];
   
       if (self.song) {
        [self.visualizer startKenwoodVisualizerAnimation];
        self.visualizer.isStarted = YES;
        
       }
    
    if (self.visualizer.isStarted) {
        [self.playPauseButton setIsSelected:YES];
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
  
        [self.visualizer stopVisualizerAnimation];
         self.visualizer.isStarted = NO;
        [button setIsSelected:NO];
          }

    else {
        
        [self.visualizer startKenwoodVisualizerAnimation];
        self.visualizer.isStarted = YES;
        [button setIsSelected:YES];
       
    }
    
}


- (IBAction)volumeSliderValueChanged:(UISlider*) slider{
    
}


- (IBAction)returnToSongsButtonAction:(UIButton*) button{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (IBAction)fastForwarButtonAction   :(UIButton*) button{
    //[self.musicPlayerController skipToNextItem];
}

- (IBAction)fastRemindButtonAction   :(UIButton*) button{
   // [self.musicPlayerController skipToPreviousItem];
}

- (IBAction)timeLineSliderValueChanged :(UISlider*) slider{
    
}

#pragma mark - TimerForUpdateMusicTimeLine


- (void) updateMusicTimeLine{
    
//    self.currentSong =  self.musicPlayerController.nowPlayingItem;
//    
//    self.musicTimeLabelForLine.text = [NSString stringWithFormat:@"%5.2f",self.currentSong.playbackDuration];
    
    
}



@end
