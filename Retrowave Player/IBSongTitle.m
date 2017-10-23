//
//  IBSongTitle.m
//  Retrowave Player
//
//  Created by eastwood on 23/10/2017.
//  Copyright © 2017 Илья Блинов. All rights reserved.
//

#import "IBSongTitle.h"

#import "IBFontAttributes.h"


@implementation IBSongTitle

@synthesize attributedText = _attributedText;





- (void) setAttributedText:(NSAttributedString *)attributedText{
    
    
    NSDictionary *attributes = [IBFontAttributes attributesOfSongTitle];
    
    NSMutableAttributedString *mainTitle = [[NSMutableAttributedString alloc] initWithAttributedString:attributedText];
    
    [mainTitle setAttributes:attributes range:NSMakeRange(0, [mainTitle length])];
    
    
    [super setAttributedText:mainTitle];
    
    _attributedText = mainTitle;
    
    
    
}


- (void) setAttributedText:(NSAttributedString *)attributedText withNowPlayling:(BOOL) nowPlaying{
    
    NSDictionary *attributes;
    
    if (nowPlaying) {
        attributes = [IBFontAttributes attributesOfPlayingSongTitle];
    }else{
       attributes = [IBFontAttributes attributesOfSongTitle];
    }
    
   
    
    NSMutableAttributedString *mainTitle = [[NSMutableAttributedString alloc] initWithAttributedString:attributedText];
    
    [mainTitle setAttributes:attributes range:NSMakeRange(0, [mainTitle length])];
    
    
    [super setAttributedText:mainTitle];
    
    _attributedText = mainTitle;


}



@end
