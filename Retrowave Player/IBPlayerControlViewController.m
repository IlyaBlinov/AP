//
//  IBPlayerControlViewController.m
//  Retrowave Player
//
//  Created by Илья Блинов on 08.01.17.
//  Copyright © 2017 Илья Блинов. All rights reserved.
//

#import "IBPlayerControlViewController.h"
#import <MediaPlayer/MediaPlayer.h>
@interface IBPlayerControlViewController ()
@property (strong, nonatomic) MPMusicPlayerController *musicPlayerController;
@property (strong, nonatomic) MPMediaItem *currentSong;
@property (strong, nonatomic) NSTimer *timerForMusicTimeLineRefresh;
@end

@implementation IBPlayerControlViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    self.timerForMusicTimeLineRefresh = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateMusicTimeLine) userInfo:nil repeats:YES];
    self.musicPlayerController =  [MPMusicPlayerController systemMusicPlayer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions


- (IBAction)playPauseButtonAction:(UIButton*) button{
    
    if ([button isSelected]) {
        [self.musicPlayerController pause];
        [button setSelected:NO];
    }else {
        [self.musicPlayerController play];
        [button setSelected:YES];
    }
    
}


- (IBAction)volumeSliderValueChanged:(UIButton*) button{
    
}


- (IBAction)returnToSongsButtonAction:(UIButton*) button{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (IBAction)fastForwarButtonAction   :(UIButton*) button{
    [self.musicPlayerController skipToNextItem];
}

- (IBAction)fastRemindButtonAction   :(UIButton*) button{
    [self.musicPlayerController skipToPreviousItem];
}



#pragma mark - TimerForUpdateMusicTimeLine


- (void) updateMusicTimeLine{
    
    self.currentSong =  self.musicPlayerController.nowPlayingItem;
    
    self.musicTimeLabelForLine.text = [NSString stringWithFormat:@"%5.2f",self.currentSong.playbackDuration];
    
    
}

@end
