//
//  IBContentViewController.h
//  APlayer
//
//  Created by ilyablinov on 01.04.17.
//  Copyright (c) 2017 IB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IBFontAttributes.h"
#import <MediaPlayer/MediaPlayer.h>
#import "IBPlayerItem.h"

@interface IBContentViewController : UITableViewController




- (void) createChooseSongsItem;

- (IBPlayerItem*) createAddSongsToPlaylistButton;

- (UIBarButtonItem*) setLeftBackBarButtonItem:(NSString *) titleItem;

- (void)chooseSongs:(IBPlayerItem *) button;

@end
