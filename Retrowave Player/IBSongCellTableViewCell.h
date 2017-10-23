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
#import "IBParentCell.h"
#import "IBSongTitle.h"
@interface IBSongCellTableViewCell : IBParentCell

@property (strong, nonatomic) IBOutlet IBSongTitle *songTitle;
@property (strong, nonatomic) IBOutlet IBDetailedTitle *artistTitle;
@property (strong, nonatomic) IBOutlet IBTimeDurationTitle *timeDuration;
@property (strong, nonatomic) IBOutlet IBSongCount *songCount;






@end
