//
//  IBSongCellTableViewCell.h
//  APlayer
//
//  Created by ilyablinov on 02.03.17.
//  Copyright (c) 2017 IB. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "IBMainTitle.h"
#import "IBDetailedTitle.h"
#import "IBTimeDurationTitle.h"
#import "IBSongCount.h"
@interface IBSongCellTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet IBMainTitle *songTitle;
@property (strong, nonatomic) IBOutlet IBDetailedTitle *artistTitle;
@property (strong, nonatomic) IBOutlet IBTimeDurationTitle *timeDuration;
@property (strong, nonatomic) IBOutlet IBSongCount *songCount;






@end
