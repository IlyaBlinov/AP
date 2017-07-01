//
//  IBFileManager.h
//  Retrowave Player
//
//  Created by eastwood on 30/06/2017.
//  Copyright © 2017 Илья Блинов. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IBCurrentParametersManager.h"
@interface IBFileManager : NSObject


+ (IBFileManager*) sharedManager;




- (NSDictionary*) getSongsAndTitleFor :(IBSongsViewType) type;
- (NSDictionary*) getAlbumsAndTitleFor:(IBSongsViewType) type;
- (NSDictionary*) getArtistParams:(MPMediaItem*) artist;
- (NSDictionary*) getPlaylistParams:(MPMediaPlaylist*) playlist;



- (NSArray*) getArtists;
- (NSArray*) getPlaylists;




@end
