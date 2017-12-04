//
//  IBTimeLineSlider.m
//  Retrowave Player
//
//  Created by eastwood on 04/12/2017.
//  Copyright © 2017 Илья Блинов. All rights reserved.
//

#import "IBTimeLineSlider.h"

@implementation IBTimeLineSlider

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (void) startNewTimeLineBySongDuration:(NSTimeInterval) seconds{
    self.minimumValue = 0.0f;
    self.value = 0.0f;
    self.maximumValue = seconds;
}


@end
