//
//  IBSongsAddViewController.h
//  Retrowave Player
//
//  Created by eastwood on 22/05/2017.
//  Copyright © 2017 Илья Блинов. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "IBContentViewController.h"
#import "IBPlayerItem.h"

@interface IBSongsAddViewController : IBContentViewController









@property (strong, nonatomic) NSArray *songs;
- (IBAction) addNewSongs:(IBPlayerItem *) button;






@end
