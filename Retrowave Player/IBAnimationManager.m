//
//  IBAnimationManager.m
//  APlayer
//
//  Created by ilyablinov on 20.03.17.
//  Copyright (c) 2017 IB. All rights reserved.
//

#import "IBAnimationManager.h"
#import "IBVisualizerLayer.h"
#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>
@implementation IBAnimationManager




+ (IBAnimationManager*) sharedManager{
    
    static IBAnimationManager *manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[IBAnimationManager alloc] init];
    });
    
    return manager;
    
}


- (CAKeyframeAnimation*) animationForKenwoodMusicVisualizer:(CALayer*) layer{
    
    
    
    
    IBVisualizerLayer *mainLayer = (IBVisualizerLayer*)layer.superlayer;
    
    NSInteger heightOfPartLayer = 0;
    
    
    for (CALayer *partlayer in mainLayer.sublayers) {
        
        if ([partlayer isEqual:layer]) {
            heightOfPartLayer = [mainLayer.sublayers indexOfObject:partlayer];
        }
        
    }
    
    NSMutableArray *backgroundColorsArray = [NSMutableArray array];
    
    
    
    
    UIColor *cyanColor    = [UIColor cyanColor];
    UIColor *magentaColor = [UIColor magentaColor];
    
    
    
    for (NSNumber *number in mainLayer.heights) {
        
        NSInteger height = [number integerValue];
        
        if (heightOfPartLayer <= height) {
            [backgroundColorsArray addObject: (id)[cyanColor CGColor]];
        }else{
            [backgroundColorsArray addObject: (id) [magentaColor CGColor]];
        }
        
    }
    
    NSMutableArray *times = [NSMutableArray array];
    
    for (int i = 0;i < 50;  i++) {
        
        [times addObject:[NSNumber numberWithDouble:0.1]];
        
    }
    
    
    
   // NSLog(@"count in mainlayer = %ld", [[mainLayer sublayers] count]);
    
    CAKeyframeAnimation *frameAnimationBackgroundColor = [CAKeyframeAnimation animationWithKeyPath:@"backgroundColor"];
    
    //frameAnimationBackgroundColor.fromValue = [NSArray arrayWithArray:fromBackgroundColorsArray];
    frameAnimationBackgroundColor.values = [NSArray arrayWithArray: backgroundColorsArray];
    //frameAnimationBackgroundColor.keyTimes = [NSArray arrayWithArray: times];
    frameAnimationBackgroundColor.duration =  5.0f ;
    frameAnimationBackgroundColor.calculationMode  = @"discrete";
    [frameAnimationBackgroundColor setFillMode:kCAFillModeBackwards];
    frameAnimationBackgroundColor.autoreverses = NO;
    //  frameAnimationBackgroundColor.beginTime = CACurrentMediaTime() + 10.0f*heightOfPartLayer ;
    // frameAnimationBackgroundColor.timeOffset = 49.99999f;
    frameAnimationBackgroundColor.repeatCount = INFINITY;
    
    
    
    
    
    
    
    return frameAnimationBackgroundColor;
    
    
}




- (CAAnimationGroup*) animationForMusicVisualizer:(IBVisualizerLayer*) layer{
    
    CAKeyframeAnimation *frameAnimationPosition = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    
    
    NSMutableArray *valuesPositionArray = [NSMutableArray array];
    NSMutableArray *valuesBoundsArray = [NSMutableArray array];
    
    
   
    NSValue *startValuePosition = [NSValue valueWithCGPoint:CGPointMake( layer.position.x, layer.position.y)];
    NSValue *startValueBounds   = [NSValue valueWithCGRect:layer.bounds];
    
    layer.startValuePosition = startValuePosition;
    layer.startValueBounds   = startValueBounds;
    
    
    
    NSInteger countPosition = 50;
    
    for (int i = 0; i < countPosition; i++) {
        
        float scale = (float)(arc4random() % 1000) / 3000  ;
        
        NSValue *nextValuePosition = [NSValue valueWithCGPoint:CGPointMake (layer.position.x, layer.position.y -layer.position.y * scale) ];
        
        NSValue *nextValueBounds = [NSValue valueWithCGRect:CGRectMake(layer.bounds.origin.x,  layer.bounds.origin.y  , CGRectGetWidth(layer.bounds), CGRectGetHeight(layer.bounds) + layer.position.y  * scale *2 )];
        
        [valuesPositionArray addObject:startValuePosition];
        [valuesPositionArray addObject:nextValuePosition];
        
        [valuesBoundsArray addObject:
         startValueBounds];
        [valuesBoundsArray addObject:
         nextValueBounds];
        
        
    }
    
    
    
    
    
    frameAnimationPosition.values = [NSArray arrayWithArray:valuesPositionArray];
    frameAnimationPosition.duration = 0.6f * countPosition;
    frameAnimationPosition.autoreverses = NO;
    frameAnimationPosition.beginTime = 0.0f;
    
    
    
    CAKeyframeAnimation *frameAnimationBounds = [CAKeyframeAnimation animationWithKeyPath:@"bounds"];
    
    
    
    frameAnimationBounds.values = [NSArray arrayWithArray: valuesBoundsArray];
    frameAnimationBounds.duration = 0.6f * countPosition;
    frameAnimationBounds.autoreverses = NO;
    frameAnimationBounds.beginTime = 0.0f;
    
    
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.autoreverses = YES;
    group.repeatCount = INFINITY;
    [group setDuration:0.6f * countPosition];
    group.timingFunction = [CAMediaTimingFunction functionWithName:@"linear"];
   // group.delegate = self;
    
    
    [group setAnimations:[NSArray arrayWithObjects:  frameAnimationPosition, frameAnimationBounds, nil]];

    return group;
    
}



- (CAAnimationGroup*) stopAnimationForMusicVisualizer:(IBVisualizerLayer*) layer{
    
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.beginTime = 0.0;
    group.timeOffset = 0.0;
    group.autoreverses = NO;
    group.repeatCount = 0;
   [group setDuration:0.6f];
    group.timingFunction = [CAMediaTimingFunction functionWithName:@"easeInEaseOut"];
    
    NSValue *currentPosition = [layer.presentationLayer valueForKey:@"position"];
    
   
    
    NSValue *currentBounds = [layer.presentationLayer valueForKey:@"bounds"];
    
    
    
    
    
    NSMutableArray *valuesPositionArray = [NSMutableArray arrayWithObjects:currentPosition,layer.startValuePosition, nil];
   
    CAKeyframeAnimation *frameAnimationPosition = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    
    frameAnimationPosition.values = [NSArray arrayWithArray:valuesPositionArray];
    frameAnimationPosition.duration = 0.6f ;
    frameAnimationPosition.autoreverses = NO;
    frameAnimationPosition.beginTime = 0.0f;
    
    
    
    
    
    
    NSMutableArray *valuesBoundsArray = [NSMutableArray arrayWithObjects:currentBounds,layer.startValueBounds, nil];
   
    
    
    CAKeyframeAnimation *frameAnimationBounds = [CAKeyframeAnimation animationWithKeyPath:@"bounds"];
    

    frameAnimationBounds.values = [NSArray arrayWithArray: valuesBoundsArray];
    frameAnimationBounds.duration = 0.6f ;
    frameAnimationBounds.autoreverses = NO;
    frameAnimationBounds.beginTime = 0.0f;
    
    
    
    
    
    
    [group setAnimations:[NSArray arrayWithObjects:  frameAnimationPosition, frameAnimationBounds, nil]];
    
    return group;
    
}


- (CAAnimationGroup*) stopAnimationForKenwoodMusicVisualizer:(IBVisualizerLayer*) layer{
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
   
    
    return group;

    
    
    
}



@end
