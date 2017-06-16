//
//  IBDetailedTitle.m
//  APlayer
//
//  Created by ilyablinov on 06.03.17.
//  Copyright (c) 2017 IB. All rights reserved.
//

#import "IBDetailedTitle.h"
#import "IBFontAttributes.h"
@implementation IBDetailedTitle

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
    
    
    NSDictionary *attributes = [IBFontAttributes attributesOfDetailedTitle];
    
    NSMutableAttributedString *detailedTitle = [[NSMutableAttributedString alloc] initWithAttributedString:attributedText];
    
    [detailedTitle setAttributes:attributes range:NSMakeRange(0, [detailedTitle length])];
    
    
    
    [super setAttributedText:detailedTitle];
   

    
    _attributedText = detailedTitle;
    
    
    
}



@end
