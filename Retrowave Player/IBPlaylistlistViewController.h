//
//  IBPlaylistlistViewController.h
//  Retrowave Player
//
//  Created by Илья Блинов on 29.04.17.
//  Copyright © 2017 Илья Блинов. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IBContentViewController.h"

@interface IBPlaylistlistViewController : IBContentViewController


@property (strong, nonatomic) NSArray *playlists;

- (void)addNewPlaylist;


@end
