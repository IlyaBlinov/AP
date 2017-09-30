//
//  IBCurrentParametersManager.h
//  Retrowave Player
//
//  Created by Илья Блинов on 09.05.17.
//  Copyright © 2017 Илья Блинов. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "IBPlaylist+CoreDataClass.h"
#import "IBMediaItem.h"

@class IBMediaItem, IBSongsAddViewController,MPMediaPlaylist, IBContentViewController;
typedef enum {
    artist_type,
    album_type,
    playlist_type,
    allSongs_type
}IBSongsViewType;

@interface IBCurrentParametersManager : NSObject

+ (IBCurrentParametersManager*) sharedManager;

@property (strong, nonatomic) IBContentViewController *returnSongsViewController;


@property (strong, nonatomic) IBMediaItem     *artist;
@property (strong, nonatomic) IBMediaItem     *album;
@property (strong, nonatomic) IBMediaItem     *playlist;
@property (strong, nonatomic) IBMediaItem     *currentSong;
@property (strong, nonatomic) IBMediaItem     *changingPlaylist;

@property (assign, nonatomic) IBSongsViewType songsViewType;

@property (assign, nonatomic) BOOL isEditing;
@property (assign, nonatomic) BOOL isPlayingMusic;


@property (strong, nonatomic) NSMutableArray  *addedSongs;
@property (strong, nonatomic) NSMutableArray  *removedSongs;

@property (strong, nonatomic) NSArray *queueOfPlayingItems;

@property (strong, nonatomic) IBPlaylist *coreDataPlaylist;
@property (strong, nonatomic) IBPlaylist *coreDataChangingPlaylist;


- (void) removeSongFromArray:(IBMediaItem*) song;


@end
