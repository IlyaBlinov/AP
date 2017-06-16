//
//  IBSongCount.m
//  APlayer
//
//  Created by ilyablinov on 06.03.17.
//  Copyright (c) 2017 IB. All rights reserved.
//

#import "IBSongCount.h"
#import "IBFontAttributes.h"
@implementation IBSongCount
@synthesize attributedText = _attributedText;


- (void) setAttributedText:(NSAttributedString *)attributedText{
    
    //self.adjustsFontSizeToFitWidth = YES;
    
    NSDictionary *attributes = [IBFontAttributes attributesOfSongCountTitle];
    
    NSMutableAttributedString *timeTitle = [[NSMutableAttributedString alloc] initWithAttributedString:attributedText];
    
    [timeTitle setAttributes:attributes range:NSMakeRange(0, [timeTitle length])];
    
    
    [super setAttributedText:timeTitle];
    
    
    _attributedText = timeTitle;
    
    
    
}









@end
