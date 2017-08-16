//
//  IBParentCell.m
//  Retrowave Player
//
//  Created by eastwood on 15/08/2017.
//  Copyright © 2017 Илья Блинов. All rights reserved.
//

#import "IBParentCell.h"
#import "IBCurrentParametersManager.h"
@implementation IBParentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}




- (void) setEditingView:(IBPlayerItem*) addButton{
    
    if ([[IBCurrentParametersManager sharedManager] isEditing]) {
                
        self.editingAccessoryView = addButton;
        
    }else{
        
        self.editingAccessoryView = nil;
    }
    
    
}

    
    
    
    
    




@end
