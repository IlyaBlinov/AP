//
//  IBContentViewController.h
//  APlayer
//
//  Created by ilyablinov on 01.04.17.
//  Copyright (c) 2017 IB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IBFileManager.h"
#import "IBBarButtonItem.h"
#import "IBFontAttributes.h"



@class IBBarButtonItem, IBPlayerItem;

@interface IBContentViewController : UITableViewController




- (IBBarButtonItem*) createChooseSongsItem;

//- (IBPlayerItem*) createAddSongsToPlaylistButton;

- (UIBarButtonItem*) setLeftBackBarButtonItem:(NSString *) titleItem;

- (void)chooseSongs;


- (BOOL) matchCurrentPlayingSongWithSong:(IBMediaItem*) song;

- (void) changeNowPlayingSong:(NSNotification*) notification;

@end
