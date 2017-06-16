//
//  IBMainTitle.m
//  APlayer
//
//  Created by ilyablinov on 06.03.17.
//  Copyright (c) 2017 IB. All rights reserved.
//

#import "IBMainTitle.h"
#import "IBFontAttributes.h"


@implementation IBMainTitle

@synthesize attributedText = _attributedText;





- (void) setAttributedText:(NSAttributedString *)attributedText{
    
        
    NSDictionary *attributes = [IBFontAttributes attributesOfMainTitle];
    
    NSMutableAttributedString *mainTitle = [[NSMutableAttributedString alloc] initWithAttributedString:attributedText];
    
    [mainTitle setAttributes:attributes range:NSMakeRange(0, [mainTitle length])];
    
    
    [super setAttributedText:mainTitle];
    
    _attributedText = mainTitle;
    
  
    
}

@end
