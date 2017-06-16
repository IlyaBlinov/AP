//
//  IBSongsViewController.h
//  APlayer
//
//  Created by ilyablinov on 28.02.17.
//  Copyright (c) 2017 IB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IBArtist.h"
#import "IBContentViewController.h"
#import "IBAlbum.h"
#import "IBPlayerItem.h"




@interface IBSongsViewController : IBContentViewController

@property (strong, nonatomic) NSArray *songs;

@property (strong, nonatomic) NSMutableArray *oldPlaylistSongs;







@end
