//
//  IBMainTabBarController.h
//  APlayer
//
//  Created by ilyablinov on 02.03.17.
//  Copyright (c) 2017 IB. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IBVisualizerMusic;

@interface  IBMainTabBarController : UITabBarController

@property (strong, nonatomic) IBVisualizerMusic *visualizer;


@end
