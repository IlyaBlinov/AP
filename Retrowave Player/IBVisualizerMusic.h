//
//  IBVisualizerMusic.h
//  APlayer
//
//  Created by ilyablinov on 20.03.17.
//  Copyright (c) 2017 IB. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IBVisualizerMusic : UIImageView

@property (assign, nonatomic) BOOL isStarted;


- (id)initWithFrameKenwoodFRC:(CGRect)frame;
- (void) startKenwoodVisualizerAnimation;



- (void) startVisualizerAnimation;
- (void) stopVisualizerAnimation;
- (void) pauseVisualizerAnimation;
- (void) resumeVisulizerAnimation;


@end
