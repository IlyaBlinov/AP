//
//  IBPlaylistlistViewController.h
//  Retrowave Player
//
//  Created by Илья Блинов on 29.04.17.
//  Copyright © 2017 Илья Блинов. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IBContentViewController.h"
#import "IBTransitionViewController.h"
#import "IBTransitionDismissViewController.h"
#import "IBSongsAddViewController.h"
#import "IBAllMediaViewController.h"
#import "IBAddPlaylistViewController.h"
#import "IBFileManager.h"
#import "IBPlaylistCell.h"

@interface IBPlaylistlistViewController : IBContentViewController


@property (strong, nonatomic) NSArray *playlists;

- (void)addNewPlaylist;


@end
