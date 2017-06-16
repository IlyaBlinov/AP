//
//  IBAddPlaylistViewController.h
//  Retrowave Player
//
//  Created by Илья Блинов on 02.05.17.
//  Copyright © 2017 Илья Блинов. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IBAddPlaylistViewController : UIViewController


@property (weak, nonatomic) IBOutlet UIButton    *addPlaylist;
@property (weak, nonatomic) IBOutlet UIButton    *cancel;
@property (weak, nonatomic) IBOutlet UITextField *playlistName;



- (IBAction)addPlaylistAction      :(UIButton*) button;
- (IBAction)cancelNewPlaylistAction:(UIButton*) button;


@end
