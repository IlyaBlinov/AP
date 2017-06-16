//
//  IBArtist.h
//  APlayer
//
//  Created by ilyablinov on 28.03.17.
//  Copyright (c) 2017 IB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IBArtist : NSObject


@property (strong, nonatomic) NSString *artistName;
@property (strong, nonatomic) NSArray *songsArray;
@property (strong, nonatomic) NSArray *albumsArray;


@end
