//
//  IBFontAttributes.m
//  APlayer
//
//  Created by ilyablinov on 09.03.17.
//  Copyright (c) 2017 IB. All rights reserved.
//

#import "IBFontAttributes.h"


@implementation IBFontAttributes

+ (NSDictionary*) attributesOfMainTitle{
    
        NSShadow *shadowOfSongName = [[NSShadow alloc] init];
       shadowOfSongName.shadowBlurRadius = 8.0f;
        shadowOfSongName.shadowOffset = CGSizeMake(2, 1);
       // shadowOfSongName.shadowColor = [[UIColor alloc]initWithRed:224.0f green:108.0f blue:157.0f alpha:1.0f];//black-white[UIColor colorWithRed:0.95f green:0.42f blue:0.61f alpha:1.0f]
    
    //shadowOfSongName.shadowColor = [UIColor colorWithRed:0.941f green:0.318f blue:0.541f alpha:1.0f];
     shadowOfSongName.shadowColor = [UIColor magentaColor];
    
        UIFont *songFont = [UIFont fontWithName:@"Neoneon" size:17];
    
    
            NSDictionary *attributesOfSongName = [[NSDictionary alloc] initWithObjectsAndKeys:songFont,NSFontAttributeName, [UIColor whiteColor],NSForegroundColorAttributeName,shadowOfSongName ,NSShadowAttributeName,[NSNumber numberWithFloat:4.0f],NSKernAttributeName,nil];
    
    return attributesOfSongName;
    
    
}



+ (NSDictionary*) attributesOfSongTitle{
    
    NSShadow *shadowOfSongName = [[NSShadow alloc] init];
    shadowOfSongName.shadowBlurRadius = 8.0f;
    shadowOfSongName.shadowOffset = CGSizeMake(2, 1);
    shadowOfSongName.shadowColor = [[UIColor alloc]initWithRed:224.0f green:108.0f blue:157.0f alpha:1.0f];//black-white[UIColor colorWithRed:0.95f green:0.42f blue:0.61f alpha:1.0f]
    
    //shadowOfSongName.shadowColor = [UIColor colorWithRed:0.941f green:0.318f blue:0.541f alpha:1.0f];
    //shadowOfSongName.shadowColor = [UIColor magentaColor];
    
    UIFont *songFont = [UIFont fontWithName:@"Neoneon" size:17];
    
    
    NSDictionary *attributesOfSongName = [[NSDictionary alloc] initWithObjectsAndKeys:songFont,NSFontAttributeName, [UIColor whiteColor],NSForegroundColorAttributeName,shadowOfSongName ,NSShadowAttributeName,[NSNumber numberWithFloat:4.0f],NSKernAttributeName,nil];
    
    return attributesOfSongName;
    
    
}


+ (NSDictionary*) attributesOfPlayingSongTitle{
    
    NSShadow *shadowOfSongName = [[NSShadow alloc] init];
    shadowOfSongName.shadowBlurRadius = 8.0f;
    shadowOfSongName.shadowOffset = CGSizeMake(2, 1);
    //shadowOfSongName.shadowColor = [[UIColor alloc]initWithRed:224.0f green:108.0f blue:157.0f alpha:1.0f];//black-white[UIColor colorWithRed:0.95f green:0.42f blue:0.61f alpha:1.0f]
    
    //shadowOfSongName.shadowColor = [UIColor colorWithRed:0.941f green:0.318f blue:0.541f alpha:1.0f];
    shadowOfSongName.shadowColor = [UIColor magentaColor];
    
    UIFont *songFont = [UIFont fontWithName:@"Neoneon" size:17];
    
    
    NSDictionary *attributesOfSongName = [[NSDictionary alloc] initWithObjectsAndKeys:songFont,NSFontAttributeName, [UIColor whiteColor],NSForegroundColorAttributeName,shadowOfSongName ,NSShadowAttributeName,[NSNumber numberWithFloat:4.0f],NSKernAttributeName,nil];
    
    return attributesOfSongName;
    
    
}

+ (NSDictionary*) attributesOfBackButton{
    
    NSShadow *shadowOfSongName = [[NSShadow alloc] init];
    shadowOfSongName.shadowBlurRadius = 2.0f;
    shadowOfSongName.shadowOffset = CGSizeMake(2, 1);
    shadowOfSongName.shadowColor = [UIColor blueColor];
    
    UIFont *songFont = [UIFont fontWithName:@"Newsense" size:15];
    
    
    NSDictionary *attributesOfSongName = [[NSDictionary alloc] initWithObjectsAndKeys:songFont,NSFontAttributeName, [UIColor whiteColor],NSForegroundColorAttributeName,shadowOfSongName ,NSShadowAttributeName,[NSNumber numberWithFloat:3.0f],NSKernAttributeName,nil];
    
    return attributesOfSongName;
    
    
}

+ (NSDictionary*) attributesOfButtons{
    
    
    NSShadow *shadowOfSongName = [[NSShadow alloc] init];
    shadowOfSongName.shadowBlurRadius = 2.0f;
    shadowOfSongName.shadowOffset = CGSizeMake(2, 1);
    shadowOfSongName.shadowColor = [UIColor magentaColor];
    
    UIFont *songFont = [UIFont fontWithName:@"Road Rage" size:13];
    
    
    NSDictionary *attributesOfSongName = [[NSDictionary alloc] initWithObjectsAndKeys:songFont,NSFontAttributeName, [UIColor whiteColor],NSForegroundColorAttributeName,shadowOfSongName ,NSShadowAttributeName,[NSNumber numberWithFloat:7.0f],NSKernAttributeName,nil];
    
    return attributesOfSongName;

    
}

+ (NSDictionary*) attributesOfDetailedTitle{
    
        UIFont *artistFont = [UIFont fontWithName:@"Neoneon" size:9];
    
        NSShadow *shadowOfArtistName = [[NSShadow alloc] init];
        shadowOfArtistName.shadowBlurRadius = 2.0f;
        shadowOfArtistName.shadowOffset = CGSizeMake(2, 1);
        shadowOfArtistName.shadowColor = [UIColor blueColor];
    
    
        NSDictionary *attributes = [[NSDictionary alloc] initWithObjectsAndKeys:artistFont,NSFontAttributeName, [UIColor whiteColor],NSForegroundColorAttributeName,shadowOfArtistName ,NSShadowAttributeName,[NSNumber numberWithFloat:4.0f],NSKernAttributeName,nil];
    
    return attributes;
    
    
}



+ (NSDictionary*) attributesOfTimeDurationTitle{
    
    NSShadow *shadowOfSongName = [[NSShadow alloc] init];
    shadowOfSongName.shadowBlurRadius = 2.0f;
    shadowOfSongName.shadowOffset = CGSizeMake(2, 1);
    shadowOfSongName.shadowColor = [UIColor blueColor];
    
    UIFont *songFont = [UIFont fontWithName:@"Neoneon" size:17];
    
    
    NSDictionary *attributesOfSongName = [[NSDictionary alloc] initWithObjectsAndKeys:songFont,NSFontAttributeName, [UIColor whiteColor],NSForegroundColorAttributeName,shadowOfSongName ,NSShadowAttributeName,[NSNumber numberWithFloat:3.0f],NSKernAttributeName,nil];
    
    return attributesOfSongName;
    
    
}



+ (NSDictionary*) attributesOfSongCountTitle{
    
    NSShadow *shadowOfSongName = [[NSShadow alloc] init];
    shadowOfSongName.shadowBlurRadius = 2.0f;
    shadowOfSongName.shadowOffset = CGSizeMake(2, 1);
    shadowOfSongName.shadowColor = [UIColor magentaColor];
    
    UIFont *songFont = [UIFont fontWithName:@"Neoneon" size:19];
    
    
    NSDictionary *attributesOfSongName = [[NSDictionary alloc] initWithObjectsAndKeys:songFont,NSFontAttributeName, [UIColor whiteColor],NSForegroundColorAttributeName,shadowOfSongName ,NSShadowAttributeName,[NSNumber numberWithFloat:3.0f],NSKernAttributeName,nil];
    
    return attributesOfSongName;
    
    
}



+ (NSDictionary*) attributesOfTabBarTitlesWithState:(State) state{
    
    
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowBlurRadius = 2.0f;
    shadow.shadowOffset = CGSizeMake(2, 1);
    shadow.shadowColor = [UIColor magentaColor];
    
    UIFont *tabBarItemFont = [UIFont fontWithName:@"Road Rage" size:13];
    
    NSShadow *shadowofNotSelectedItem = [[NSShadow alloc] init];
    
    
    NSDictionary *attributesofSelectedItem = [[NSDictionary alloc] initWithObjectsAndKeys:tabBarItemFont,NSFontAttributeName, [UIColor whiteColor],NSForegroundColorAttributeName,shadow ,NSShadowAttributeName,nil];
    
    NSDictionary *attributesofNotSelectedItem = [[NSDictionary alloc] initWithObjectsAndKeys:tabBarItemFont,NSFontAttributeName, [UIColor whiteColor],NSForegroundColorAttributeName,shadowofNotSelectedItem ,NSShadowAttributeName,nil];

    
    switch (state) {
        case selected:
            return  attributesofSelectedItem;
            
        case notSelected:
            return attributesofNotSelectedItem;
            
        default:
            break;
    }
    
}


+ (UILabel*) getCustomTitleForControllerName:(NSString*) controllerName{
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:controllerName];
    
    [attributedText setAttributes:[IBFontAttributes attributesOfMainTitle] range:NSMakeRange(0, [attributedText length])];
    
    [label setAttributedText:attributedText];
    
    [label sizeToFit];
    
    return label;
    
}


@end
