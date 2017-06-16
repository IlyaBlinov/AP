//
//  IBArtistCount.m
//  APlayer
//
//  Created by ilyablinov on 28.03.17.
//  Copyright (c) 2017 IB. All rights reserved.
//

#import "IBArtistCount.h"
#import "IBFontAttributes.h"

@implementation IBArtistCount
@synthesize attributedText = _attributedText;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void) setAttributedText:(NSAttributedString *)attributedText{
    
    //self.adjustsFontSizeToFitWidth = YES;
    
    NSDictionary *attributes = [IBFontAttributes attributesOfSongCountTitle];
    
    NSMutableAttributedString *timeTitle = [[NSMutableAttributedString alloc] initWithAttributedString:attributedText];
    
    [timeTitle setAttributes:attributes range:NSMakeRange(0, [timeTitle length])];
    
    
    [super setAttributedText:timeTitle];
    
    
    _attributedText = timeTitle;
    
    
    
}

@end
