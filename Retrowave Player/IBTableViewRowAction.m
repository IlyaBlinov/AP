//
//  IBTableViewRowAction.m
//  Retrowave Player
//
//  Created by eastwood on 12/07/2017.
//  Copyright © 2017 Илья Блинов. All rights reserved.
//

#import "IBTableViewRowAction.h"
#import "IBFontAttributes.h"
@implementation IBTableViewRowAction



#pragma mark - Edit Delete Button Of Cell





- (UITableViewRowAction*) rowActionForCell:(UITableViewCell*) cell{
    
    
    NSDictionary *newAttributes = [IBFontAttributes attributesOfMainTitle];
    NSDictionary *systemAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:17]};
    
    NSString *title = @"DELETE";
    NSString *titleWhiteSpace = [self whitespaceReplacementString:title WithSystemAttributes:systemAttributes newAttributes:newAttributes];
    
    UITableViewRowAction *rowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:titleWhiteSpace handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
    }];
    
    UIImage *patternImage = [self imageForTableViewRowActionWithTitle:title textAttributes:newAttributes backgroundColor:[UIColor purpleColor] cellHeight:CGRectGetHeight(cell.bounds)];
    
    rowAction.backgroundColor = [UIColor colorWithPatternImage:patternImage];
    
    
    return rowAction;
    
}





- (UIImage*) imageForTableViewRowActionWithTitle:(NSString*) title textAttributes:(NSDictionary*) attributes backgroundColor:(UIColor*) color cellHeight:(CGFloat) cellHeight{
    
    
    NSString *titleString = title;
    NSDictionary *originalAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:17]};
    CGSize originalSize = [titleString  sizeWithAttributes:originalAttributes];
    
    CGSize newSize = CGSizeMake(originalSize.width * 2.5, originalSize.height * 2);
    
    CGRect drawingRect = CGRectIntegral(CGRectMake(0, 0, newSize.width, newSize.height));
    UIGraphicsBeginImageContextWithOptions(drawingRect.size, YES, [UIScreen mainScreen].nativeScale);
    
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(contextRef, color.CGColor);
    CGContextFillRect(contextRef, drawingRect);
    
    
    UILabel *label = [[UILabel alloc] initWithFrame:drawingRect];
    label.textAlignment = NSTextAlignmentCenter;
    label.attributedText = [[NSAttributedString alloc] initWithString:title attributes:[IBFontAttributes attributesOfMainTitle]];
    
    [label drawTextInRect:drawingRect];
    
    UIImage *returningImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    
    return returningImage;
    
}


- (NSString *) whitespaceReplacementString:(NSString*) string WithSystemAttributes:(NSDictionary *)systemAttributes newAttributes:(NSDictionary *)newAttributes
{
    NSString *stringTitle = string;
    NSMutableString *stringTitleWS = [[NSMutableString alloc] initWithString:@""];
    
    CGFloat diff = 0;
    CGSize  stringTitleSize = [stringTitle sizeWithAttributes:newAttributes];
    CGSize stringTitleWSSize;
    NSDictionary *originalAttributes = systemAttributes;
    do {
        [stringTitleWS appendString:@" "];
        stringTitleWSSize = [stringTitleWS sizeWithAttributes:originalAttributes];
        diff = (stringTitleSize.width - stringTitleWSSize.width);
        if (diff <= 1.5) {
            break;
        }
    }
    while (diff > 0);
    
    return stringTitleWS;
}



@end
