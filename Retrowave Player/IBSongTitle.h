//
//  IBSongTitle.h
//  Retrowave Player
//
//  Created by eastwood on 23/10/2017.
//  Copyright © 2017 Илья Блинов. All rights reserved.
//

#import "IBLabel.h"

@interface IBSongTitle : IBLabel



- (void) setAttributedText:(NSAttributedString *)attributedText withNowPlayling:(BOOL) nowPlaying;



@end
