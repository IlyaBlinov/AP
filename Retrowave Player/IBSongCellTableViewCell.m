//
//  IBSongCellTableViewCell.m
//  APlayer
//
//  Created by ilyablinov on 02.03.17.
//  Copyright (c) 2017 IB. All rights reserved.
//

#import "IBSongCellTableViewCell.h"

@implementation IBSongCellTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
       self.backgroundColor = [UIColor darkGrayColor];    
        
        
        UIButton *addToPlaylistButton = [[UIButton alloc] initWithFrame:CGRectMake(0,0, 32, 32)];
        
        [addToPlaylistButton setImage: [UIImage imageNamed:@"add 64 x 64.png"]forState:UIControlStateNormal];
        
        
        [self.editingAccessoryView addSubview:  addToPlaylistButton];
        ;

          }
    return self;
}







@end
