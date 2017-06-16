//
//  IBVisualizerLayer.h
//  APlayer
//
//  Created by ilyablinov on 23.03.17.
//  Copyright (c) 2017 IB. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface IBVisualizerLayer : CAGradientLayer


@property (strong, nonatomic) NSValue *startValuePosition;
@property (strong, nonatomic) NSValue *startValueBounds;
@property (strong, nonatomic) NSArray *heights;
@property (assign, nonatomic) NSInteger number;



@end
