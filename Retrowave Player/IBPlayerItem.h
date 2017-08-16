//
//  IBPlayerItem.h
//  APlayer
//
//  Created by ilyablinov on 24.03.17.
//  Copyright (c) 2017 IB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IBMediaItem.h"

typedef enum{
    choose,
    chooseInPlaylist,
    add,
    del,
    move_next,
    user_defaults
    
    
}ButtonStyle;

@interface IBPlayerItem : UIButton


@property (assign, nonatomic) BOOL isSelected;
@property (assign, nonatomic) ButtonStyle buttonStyle;


- (instancetype)initWithButtonStyle:(ButtonStyle) style;
- (instancetype)initWithItemState:(ItemState) state;

@end
