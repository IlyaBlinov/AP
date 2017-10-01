//
//  IBVisualizerMusic.m
//  APlayer
//
//  Created by ilyablinov on 20.03.17.
//  Copyright (c) 2017 IB. All rights reserved.
//

#import "IBVisualizerMusic.h"
#import "IBAnimationManager.h"
#import "IBVisualizerLayer.h"




@implementation IBVisualizerMusic




+ (IBVisualizerMusic*) sharedVisualizer:(CGRect) frame{
    
    static IBVisualizerMusic *visualizer =  nil;
    
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        visualizer = [[IBVisualizerMusic alloc] initWithFrame:frame];
  
    });
   
    return visualizer;
}


- (id)initWithFrameKenwoodFRC:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        NSLog(@"frame = %@", NSStringFromCGRect(frame));
        
        
        
        CGFloat widthEQPlace          = CGRectGetWidth(self.bounds) / 6;
        CGFloat widthEmptyPlace       = CGRectGetWidth(self.bounds) / 12 * 0.5;
        
        NSLog(@"widthEQPlace = %5.2f",       widthEQPlace);
        NSLog(@"widthEmptyPlace = %5.2f", widthEmptyPlace);
        
        CGFloat heightElement         = 0.9 *  widthEmptyPlace;
        CGFloat heightBetweenElements = 1.2 * heightElement;
        CGFloat widthElement          = widthEQPlace * 0.9  ;
        
        NSLog(@"heightElement = %5.2f",       heightElement);
        NSLog(@"heightBetweenElements = %5.2f",heightBetweenElements);
        NSLog(@"widthElement = %5.2f",       widthElement);
        
        
        
        
        CGFloat maxY =  CGRectGetMaxY(self.bounds);
        CGFloat maxX =  CGRectGetMaxX(self.bounds);
        
        
        
        CGFloat startPositionX =  0 ;
        CGFloat startPositionY = (maxY - 2 * heightElement);
        
        NSLog(@"startPositionX = %5.2f",startPositionX);
        NSLog(@"startPositionY = %5.2f",startPositionY);
        
        
        
        
        
        
        CGFloat endPositionX = (startPositionX + (widthEQPlace + widthEmptyPlace) * 5 );
        CGFloat endPositionY = (4 * heightBetweenElements + heightElement);
        
        NSInteger numberOfElementsOneLayer =  (NSInteger)((startPositionY - endPositionY) / (heightElement + heightBetweenElements));
        
        NSLog(@"endPositionX = %5.2f",       endPositionX);
        NSLog(@"endPositionY = %5.2f",endPositionY);
        NSLog(@"numberOfElementsOneLayer = %ld",       numberOfElementsOneLayer);
        
        CGFloat nextPositionX = startPositionX;
        
        
        for (int i = 0; i < 5; i++) {
            
            CGFloat nextPositionY = startPositionY;
            int j = 0;
            
            IBVisualizerLayer *layer = [IBVisualizerLayer layer];
            layer.number = i;
            nextPositionX = startPositionX + (widthEmptyPlace + widthEQPlace) * i;
            
            while (nextPositionY > 2 * heightElement) {
                
                nextPositionY = startPositionY - (heightBetweenElements + heightElement) * j;
                
                CALayer *sublayer = [CALayer layer];
                UIColor *sublayerColor = [[UIColor alloc] initWithRed:148.0f green:0.0f blue:211.0f alpha:0.05];
                sublayer.backgroundColor = sublayerColor.CGColor;
                
                //                sublayer.colors = [NSArray arrayWithObjects:(id)[UIColor cyanColor].CGColor,(id)[UIColor cyanColor].CGColor, nil];
                j++;
                sublayer.frame = CGRectMake(nextPositionX, nextPositionY,(NSInteger) widthElement,(NSInteger) heightElement);
                
                
                [layer addSublayer:sublayer];
            }
            
            
            NSInteger maxCount = [[layer sublayers] count];
            
            NSMutableArray *tempArray = [NSMutableArray array];
            
            for (int i = 0; i < 50; i++) {
                
                NSInteger height = arc4random() % maxCount;
                
                [tempArray addObject:[NSNumber numberWithInteger:height]];
                
                
            }
            
            layer.heights = [NSArray arrayWithArray:tempArray];
            
            [self.layer addSublayer:layer];
            
            
        }
        
    }
    return self;
    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
       
        NSLog(@"frame = %@", NSStringFromCGRect(frame));
        
        NSInteger countEq = 19;
        
        NSInteger widthEq = (NSInteger)CGRectGetWidth(self.bounds) / countEq;
        NSInteger heightEq = (NSInteger)CGRectGetHeight(self.bounds) / 2.5;
        
        
        
        NSInteger maxY = (NSInteger) CGRectGetMaxY(self.bounds);
        NSInteger maxX = (NSInteger) CGRectGetMaxX(self.bounds);
        
        
        
        NSInteger positionX = 0;
        
        int  i = 0;
        
        NSInteger endPositionX = maxX - 3 * widthEq;
        
        while (positionX < endPositionX ) {
            
            IBVisualizerLayer *sublayer = [IBVisualizerLayer layer];
            sublayer.colors = [NSArray arrayWithObjects:(id)[UIColor cyanColor].CGColor,(id)[UIColor whiteColor].CGColor, nil];
            
            
            positionX = (1 + 2 * i) * widthEq;
            
            i++;
            
            sublayer.frame = CGRectMake(positionX, (NSInteger)(maxY - heightEq - widthEq + heightEq / 5), (NSInteger)widthEq, (NSInteger) (heightEq-heightEq /5));
            
            
            [self.layer addSublayer:sublayer];
        
        
        }
    }
    return self;
    
}


#pragma mark - ActionsVisulizerAnimation

- (void) startVisualizerAnimation{
    
    NSLog(@" startVisualizerAnimation");
    
    for (IBVisualizerLayer *sublayer in [self.layer sublayers]) {
    
        
CAAnimationGroup *group = [[IBAnimationManager sharedManager] animationForMusicVisualizer:sublayer];

        sublayer.speed = 1.0;
[sublayer addAnimation:group forKey:@"group"];
    
        
          }
}



- (void) startKenwoodVisualizerAnimation{
    
    NSLog(@" startVisualizerAnimation");
    
    
    
    
    IBVisualizerLayer *mainlayer0 = (IBVisualizerLayer*) [[self.layer sublayers] objectAtIndex:0];
    IBVisualizerLayer *mainlayer1 = (IBVisualizerLayer*) [[self.layer sublayers] objectAtIndex:1];
    IBVisualizerLayer *mainlayer2 = (IBVisualizerLayer*) [[self.layer sublayers] objectAtIndex:2];
    IBVisualizerLayer *mainlayer3 = (IBVisualizerLayer*) [[self.layer sublayers] objectAtIndex:3];
    IBVisualizerLayer *mainlayer4 = (IBVisualizerLayer*) [[self.layer sublayers] objectAtIndex:4];
    
    for (int i = 0; i < [[mainlayer0 sublayers] count];i++) {
        
        CALayer *partLayer0 = [[mainlayer0 sublayers] objectAtIndex:i];
        CALayer *partLayer1 = [[mainlayer1 sublayers] objectAtIndex:i];
        CALayer *partLayer2 = [[mainlayer2 sublayers] objectAtIndex:i];
        CALayer *partLayer3 = [[mainlayer3 sublayers] objectAtIndex:i];
        CALayer *partLayer4 = [[mainlayer4 sublayers] objectAtIndex:i];
        
        
        
        CAKeyframeAnimation *group0 = [[IBAnimationManager sharedManager] animationForKenwoodMusicVisualizer:partLayer0];
        CAKeyframeAnimation *group1 = [[IBAnimationManager sharedManager] animationForKenwoodMusicVisualizer:partLayer1];
        CAKeyframeAnimation *group2 = [[IBAnimationManager sharedManager] animationForKenwoodMusicVisualizer:partLayer2];
        CAKeyframeAnimation *group3 = [[IBAnimationManager sharedManager] animationForKenwoodMusicVisualizer:partLayer3];
        CAKeyframeAnimation *group4 = [[IBAnimationManager sharedManager] animationForKenwoodMusicVisualizer:partLayer4];
        
        // partLayer0.speed = 1.0;
        
        [partLayer0 addAnimation:group0 forKey:@"group"];
        [partLayer1 addAnimation:group1 forKey:@"group"];
        [partLayer2 addAnimation:group2 forKey:@"group"];
        [partLayer3 addAnimation:group3 forKey:@"group"];
        [partLayer4 addAnimation:group4 forKey:@"group"];
        
        
        
        
        
        
        
    }
    
    
    
}





- (void) stopVisualizerAnimation{
   
    NSLog(@"stopVisualizerAnimation");
    
    
    for (IBVisualizerLayer *sublayer in [self.layer sublayers]) {
        
        [self pauseAnimationLayer:sublayer];
        
        CAAnimationGroup *groupAnimation = [[IBAnimationManager sharedManager] stopAnimationForMusicVisualizer:sublayer];

        [sublayer addAnimation:groupAnimation forKey:@"stopAnimation"];
        
        
        [sublayer removeAnimationForKey:@"group"];
    }

    
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        for (IBVisualizerLayer *sublayer in [self.layer sublayers]) {

            [self resumeAnimationLayer:sublayer];
       
        }
    });

}

- (void) pauseVisualizerAnimation{
    
    NSLog(@"pauseVisualizerAnimation");
    
    for (IBVisualizerLayer *sublayer in [self.layer sublayers]) {

        [self pauseAnimationLayer:sublayer];
     
}
}


- (void) resumeVisulizerAnimation{
    
     NSLog(@"resumeVisulizerAnimation");
    
    for (IBVisualizerLayer *sublayer in [self.layer sublayers]) {

        [self resumeAnimationLayer:sublayer];
 
}

}

#pragma mark - Pause/Resume Layer Animation


- (void) pauseAnimationLayer: (IBVisualizerLayer*) sublayer{
 
    CFTimeInterval pausedTime = [sublayer convertTime:CACurrentMediaTime() fromLayer:nil];
    sublayer.speed = 0.0;
    sublayer.timeOffset = pausedTime;

}

- (void) resumeAnimationLayer: (IBVisualizerLayer*) sublayer{
   
    CFTimeInterval pausedTime = [sublayer timeOffset];
    sublayer.speed = 1.0;
    sublayer.timeOffset = 0.0;
    sublayer.beginTime = 0.0;
    
    CFTimeInterval timeSincePause = [sublayer convertTime:CACurrentMediaTime() fromLayer:nil]- pausedTime;
    sublayer.beginTime = timeSincePause;
}


@end
