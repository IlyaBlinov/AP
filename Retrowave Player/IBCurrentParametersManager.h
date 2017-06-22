//
//  IBCurrentParametersManager.h
//  Retrowave Player
//
//  Created by Илья Блинов on 09.05.17.
//  Copyright © 2017 Илья Блинов. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IBSongsViewController.h"
#import "IBSongsAddViewController.h"
#import <MediaPlayer/MediaPlayer.h>

typedef enum {
    artist,
    album,
    playlist,
    allSongs
}IBSongsViewControllerTypeDataToView;

@interface IBCurrentParametersManager : NSObject

+ (IBCurrentParametersManager*) sharedManager;

@property (strong, nonatomic) IBSongsAddViewController *returnSongsViewController;


@property (strong, nonatomic) MPMediaItem     *artist;
@property (strong, nonatomic) MPMediaItem     *album;
@property (strong, nonatomic) MPMediaPlaylist *playlist;
@property (assign, nonatomic) IBSongsViewControllerTypeDataToView songsViewControllerDataViewMode;


@property (assign, nonatomic) BOOL isEditing;


@property (strong, nonatomic) MPMediaPlaylist *changingPlaylist;
@property (strong, nonatomic) NSMutableArray  *addedSongs;

- (NSDictionary*) getSongsAndTitleForSongViewController;






@end
