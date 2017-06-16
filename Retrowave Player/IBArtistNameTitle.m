//
//  IBArtistNameTitle.m
//  APlayer
//
//  Created by ilyablinov on 28.03.17.
//  Copyright (c) 2017 IB. All rights reserved.
//

#import "IBArtistNameTitle.h"
#import "IBFontAttributes.h"

@implementation IBArtistNameTitle
@synthesize attributedText = _attributedText;





- (void) setAttributedText:(NSAttributedString *)attributedText{
    
    
    NSDictionary *attributes = [IBFontAttributes attributesOfMainTitle];
    
    NSMutableAttributedString *mainTitle = [[NSMutableAttributedString alloc] initWithAttributedString:attributedText];
    
    [mainTitle setAttributes:attributes range:NSMakeRange(0, [mainTitle length])];
    
    
    [super setAttributedText:mainTitle];
    
    _attributedText = mainTitle;
    
    
    
}


@end
