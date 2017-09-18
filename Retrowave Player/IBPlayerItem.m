//
//  IBPlayerItem.m
//  APlayer
//
//  Created by ilyablinov on 24.03.17.
//  Copyright (c) 2017 IB. All rights reserved.
//

#import "IBPlayerItem.h"
#import "IBCurrentParametersManager.h"
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
                
            case chooseInPlaylist:
                imageName = @"inPlaylist.png";
                break;
               
            case del:
                imageName = @"cancel-music(4).png";
                break;
                
            case move_next:
                imageName = @"skip-track.png";
                
            case add_all:
                imageName = @"skip-track.png";
                
            case remove_all:
                imageName = @"skip-track.png";
                
            default:
                break;
        }
        
        
        [self setImage: [UIImage imageNamed:imageName]forState:UIControlStateNormal];

    }
    return self;
}




- (instancetype)initWithItemState:(ItemState) state
{
    self = [super initWithFrame:CGRectMake(0,0, 20, 20)];
    if (self) {
        
        NSString *imageName;
        
        switch (state) {
            case default_state:
                imageName = @"add 64 x 64.png";
                break;
                
                
            case added_state:
                imageName = @"Added.png";
                break;
                
            case inPlaylist_state:
                imageName = @"inPlaylist.png";
                break;
                
            case delete_state:
                imageName = @"cancel-music(4).png";
                break;
                
                
            default:
                imageName = @"skip-track.png";
                break;
        }
        
        
        [self setImage: [UIImage imageNamed:imageName]forState:UIControlStateNormal];
        
    }
    return self;
}










@end
