//
//  IBCurrentParametersManager.h
//  Retrowave Player
//
//  Created by Илья Блинов on 09.05.17.
//  Copyright © 2017 Илья Блинов. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IBArtist.h"
#import "IBAlbum.h"
#import "IBSong.h"
#import "IBPlaylist.h"
#import "IBSongsViewController.h"
#import <MediaPlayer/MediaPlayer.h>

typedef enum {
    artist,
    album,
    playlist,
    allSongs
}IBSongsViewControllerTypeDataToView;

@interface IBCurrentParametersManager : NSObject

+ (IBCurrentParametersManager*) sharedManager;

@property (strong, nonatomic) IBSongsViewController *returnSongsViewController;


@property (strong, nonatomic) MPMediaItem *artist;
@property (strong, nonatomic) MPMediaItem *album;
@property (strong, nonatomic) IBPlaylist *playlist;
@property (assign, nonatomic) IBSongsViewControllerTypeDataToView songsViewControllerDataViewMode;


@property (assign, nonatomic) BOOL isEditing;



@property (strong, nonatomic) NSMutableArray *addedSongs;








@end
