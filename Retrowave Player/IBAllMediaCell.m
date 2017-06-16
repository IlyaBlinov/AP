//
//  IBAllMediaCell.m
//  Retrowave Player
//
//  Created by Илья Блинов on 27.04.17.
//  Copyright © 2017 Илья Блинов. All rights reserved.
//

#import "IBAllMediaCell.h"

@implementation IBAllMediaCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor darkGrayColor];
        
    }
    return self;
}


@end
