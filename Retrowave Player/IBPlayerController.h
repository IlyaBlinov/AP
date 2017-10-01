//
//  IBPlayerController.h
//  APlayer
//
//  Created by ilyablinov on 02.03.17.
//  Copyright (c) 2017 IB. All rights reserved.
//

#import <UIKit/UIKit.h>


@class IBPlayerItem, IBVisualizerMusic, MPMediaItem, IBMediaItem;

@interface IBPlayerController : UIViewController

@property (strong, nonatomic) IBVisualizerMusic *visualizer;

@property (weak, nonatomic) IBOutlet UIButton        *playPauseButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *fastForwardButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *fastRemindButton;
@property (weak, nonatomic) IBOutlet UIImageView     *albumArt;


@property (weak, nonatomic) IBOutlet UILabel  *musicTimePlus;
@property (weak, nonatomic) IBOutlet UILabel  *musicTimeSub;


@property (weak, nonatomic) IBOutlet UISlider *volumeSlider;
@property (weak, nonatomic) IBOutlet UISlider *musicTimeLine;



- (IBAction)playPauseButtonAction    :(UIButton*)        button;
- (IBAction)fastForwarButtonAction   :(UIBarButtonItem*) button;
- (IBAction)fastRemindButtonAction   :(UIBarButtonItem*) button;

- (IBAction)volumeSliderValueChanged   :(UISlider*) slider;
- (IBAction)timeLineSliderValueChanged :(UISlider*) slider;

@end
