//
//  IBAnimationManager.h
//  APlayer
//
//  Created by ilyablinov on 20.03.17.
//  Copyright (c) 2017 IB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
@class IBVisualizerLayer;
@interface IBAnimationManager : NSObject



+ (IBAnimationManager*) sharedManager;

- (CAAnimationGroup*) animationForMusicVisualizer:(IBVisualizerLayer*) layer;
- (CAAnimationGroup*) stopAnimationForMusicVisualizer:(IBVisualizerLayer*) layer;



- (CAKeyframeAnimation*) animationForKenwoodMusicVisualizer:(CALayer*) layer;
- (CAAnimationGroup*) stopAnimationForKenwoodMusicVisualizer:(IBVisualizerLayer*) layer;




@end
