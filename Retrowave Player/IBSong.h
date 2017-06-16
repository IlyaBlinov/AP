//
//  IBSong.h
//  APlayer
//
//  Created by ilyablinov on 02.03.17.
//  Copyright (c) 2017 IB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IBSong : NSObject



@property (strong, nonatomic) NSString      *songName;
@property (strong, nonatomic) NSString      *artistName;
@property (assign, nonatomic) double duration;


@end
