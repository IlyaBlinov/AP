//
//  IBPlayerController.h
//  APlayer
//
//  Created by ilyablinov on 02.03.17.
//  Copyright (c) 2017 IB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IBCurrentParametersManager.h"

@class IBPlayerItem, IBVisualizerMusic;

@interface IBPlayerController : UIViewController

@property (strong, nonatomic) MPMediaItem *song;
@property (strong, nonatomic) IBVisualizerMusic *visualizer;

@property (weak, nonatomic) IBOutlet IBPlayerItem *playPauseButton;
@property (weak, nonatomic) IBOutlet UIButton        *returnToSongsButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *fastForwardButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *fastRemindButton;


@property (weak, nonatomic) IBOutlet UISlider *musicTimeLine;
@property (weak, nonatomic) IBOutlet UILabel  *musicTimePlus;
@property (weak, nonatomic) IBOutlet UILabel  *musicTimeSub;

@property (weak, nonatomic) IBOutlet UISlider *volumeSlider;


- (IBAction)playPauseButtonAction    :(UIButton*) button;
- (IBAction)returnToSongsButtonAction:(UIButton       *) button;
- (IBAction)fastForwarButtonAction   :(UIBarButtonItem*) button;
- (IBAction)fastRemindButtonAction   :(UIBarButtonItem*) button;

- (IBAction)volumeSliderValueChanged   :(UISlider*) slider;
- (IBAction)timeLineSliderValueChanged :(UISlider*) slider;

@end
