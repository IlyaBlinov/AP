//
//  IBAlbumViewCell.h
//  APlayer
//
//  Created by ilyablinov on 01.04.17.
//  Copyright (c) 2017 IB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IBMainTitle.h"
#import "IBDetailedTitle.h"
#import "IBTimeDurationTitle.h"
#import "IBSongCount.h"

@interface IBAlbumViewCell : UITableViewCell




@property (strong, nonatomic) IBOutlet IBMainTitle *albumTitle;
@property (strong, nonatomic) IBOutlet IBDetailedTitle *artistTitle;

@property (strong, nonatomic) IBOutlet UIImageView *albumImage;



@end
