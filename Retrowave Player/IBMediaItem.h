//
//  IBMediaItem.h
//  Retrowave Player
//
//  Created by eastwood on 24/07/2017.
//  Copyright © 2017 Илья Блинов. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MediaPlayer/MediaPlayer.h>



typedef enum{
    inPlaylist_state,
    added_state,
    default_state,
    delete_state
}ItemState;


typedef enum{
    song,
    album,
    artist,
    playlist
}ItemType;



@interface IBMediaItem : NSObject


@property (assign, nonatomic) ItemState state;
@property (strong, nonatomic) MPMediaEntity *mediaEntity;
@property (assign, nonatomic) ItemType type;
@property (assign, nonatomic) int64_t position;


@end
