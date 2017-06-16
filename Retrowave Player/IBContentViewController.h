//
//  IBContentViewController.h
//  APlayer
//
//  Created by ilyablinov on 01.04.17.
//  Copyright (c) 2017 IB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IBArtist.h"
#import "IBAlbum.h"
#import "IBFontAttributes.h"
#import "IBPlaylist.h"
#import <MediaPlayer/MediaPlayer.h>
@interface IBContentViewController : UITableViewController




- (NSArray*) sortingItems:(NSArray*) items ByProperty:(NSString*) property;

- (UIBarButtonItem*) setLeftBackBarButtonItem:(NSString *) titleItem;

@end
