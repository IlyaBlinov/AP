//
//  IBAllMediaCell.h
//  Retrowave Player
//
//  Created by Илья Блинов on 27.04.17.
//  Copyright © 2017 Илья Блинов. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IBParentCell.h"
@interface IBAllMediaCell : IBParentCell


@property (strong, nonatomic) IBOutlet UIImageView *categoryImage;
@property (strong, nonatomic) IBOutlet UILabel *categoryName;

@end
