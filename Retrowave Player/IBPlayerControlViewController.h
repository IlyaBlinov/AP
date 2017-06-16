//
//  IBPlayerControlViewController.h
//  Retrowave Player
//
//  Created by Илья Блинов on 08.01.17.
//  Copyright © 2017 Илья Блинов. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IBPlayerControlViewController : UIViewController


@property (weak, nonatomic) IBOutlet UIButton *playPauseButton;
@property (weak, nonatomic) IBOutlet UISlider *volumeSlider;
@property (weak, nonatomic) IBOutlet UIButton *returnToSongsButton;
@property (weak, nonatomic) IBOutlet UIButton *fastForwardButton;
@property (weak, nonatomic) IBOutlet UIButton *fastRemindButton;


@property (weak, nonatomic) IBOutlet UIProgressView *musicTimeLine;
@property (weak, nonatomic) IBOutlet UILabel *musicTimeLabelForLine;

- (IBAction)playPauseButtonAction    :(UIButton*) button;
- (IBAction)returnToSongsButtonAction:(UIButton*) button;
- (IBAction)fastForwarButtonAction   :(UIButton*) button;
- (IBAction)fastRemindButtonAction   :(UIButton*) button;

- (IBAction)volumeSliderValueChanged :(UISlider*) slider;


@end
