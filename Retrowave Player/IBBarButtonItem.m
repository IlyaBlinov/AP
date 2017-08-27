//
//  IBBarButtonItem.m
//  Retrowave Player
//
//  Created by eastwood on 06/07/2017.
//  Copyright © 2017 Илья Блинов. All rights reserved.
//

#import "IBBarButtonItem.h"

@implementation IBBarButtonItem






- (instancetype)initWithButton:(IBPlayerItem*) button
{
    self = [super init];
    if (self) {
        self.customView = button;
    }
    return self;
}





#pragma mark - Actions







@end
