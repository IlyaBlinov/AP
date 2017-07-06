//
//  IBPlayerItem.m
//  APlayer
//
//  Created by ilyablinov on 24.03.17.
//  Copyright (c) 2017 IB. All rights reserved.
//

#import "IBPlayerItem.h"

@implementation IBPlayerItem




- (instancetype)initWithButtonStyle:(ButtonStyle) style
{
    self = [super initWithFrame:CGRectMake(0,0, 20, 20)];
    if (self) {
        
        NSString *imageName;
        
        switch (style) {
            case add:
                imageName = @"add 64 x 64.png";
                break;
                
                
            case choose:
                imageName = @"Added.png";
                break;
                
            default:
                break;
        }
        
        
        [self setImage: [UIImage imageNamed:imageName]forState:UIControlStateNormal];

    }
    return self;
}




@end
