//
//  IBMediaItem.h
//  Retrowave Player
//
//  Created by eastwood on 18/07/2017.
//  Copyright © 2017 Илья Блинов. All rights reserved.
//

#import <MediaPlayer/MediaPlayer.h>


typedef enum{
    inPlaylist,
    added,
    default_state
}ItemState;





@interface IBMediaItem : MPMediaItem


@property (assign, nonatomic) ItemState  state;





@end
