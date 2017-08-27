//
//  IBPlaylistCell.h
//  Retrowave Player
//
//  Created by Илья Блинов on 29.04.17.
//  Copyright © 2017 Илья Блинов. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IBMainTitle.h"
#import "IBTimeDurationTitle.h"
#import "IBParentCell.h"
@interface IBPlaylistCell : IBParentCell



@property (strong, nonatomic) IBOutlet IBMainTitle *playlistTitle;
@property (strong, nonatomic) IBOutlet IBTimeDurationTitle *songCount;




@end
