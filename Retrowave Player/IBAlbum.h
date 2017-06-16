//
//  IBAlbum.h
//  APlayer
//
//  Created by ilyablinov on 30.03.17.
//  Copyright (c) 2017 IB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IBAlbum : NSObject


@property (strong, nonatomic) NSString *albumName;
@property (strong, nonatomic) NSString *artistName;
@property (strong , nonatomic) NSArray *songs;


@end
