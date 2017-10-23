//
//  IBFontAttributes.h
//  APlayer
//
//  Created by ilyablinov on 09.03.17.
//  Copyright (c) 2017 IB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum{
    selected,
    notSelected
}State;

@interface IBFontAttributes : NSObject

+ (NSDictionary*) attributesOfTabBarTitlesWithState:(State) state;

+ (NSDictionary*) attributesOfDetailedTitle;

+ (NSDictionary*) attributesOfMainTitle;

+ (NSDictionary*) attributesOfTimeDurationTitle;

+ (NSDictionary*) attributesOfSongCountTitle;

+ (NSDictionary*) attributesOfBackButton;

+ (NSDictionary*) attributesOfButtons;


+ (UILabel*) getCustomTitleForControllerName:(NSString*) controllerName;

+ (NSDictionary*) attributesOfSongTitle;
+ (NSDictionary*) attributesOfPlayingSongTitle;


@end
