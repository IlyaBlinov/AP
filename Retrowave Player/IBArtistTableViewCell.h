//
//  IBArtistTableViewCell.h
//  APlayer
//
//  Created by ilyablinov on 28.03.17.
//  Copyright (c) 2017 IB. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "IBArtistNameTitle.h"
#import "IBArtistParameter.h"
#import "IBArtistNumberSongsTitle.h"
#import "IBArtistNumberAlbumsTitle.h"
#import "IBArtistCount.h"
#import "IBParentCell.h"
@interface IBArtistTableViewCell : IBParentCell

@property (strong, nonatomic) IBOutlet IBArtistNameTitle *artistName;
@property (strong, nonatomic) IBOutlet IBArtistParameter *artistSongParameter;
@property (strong, nonatomic) IBOutlet IBArtistParameter *artistAlbumParameter;
@property (strong, nonatomic) IBOutlet IBArtistCount *artistCount;

@end
