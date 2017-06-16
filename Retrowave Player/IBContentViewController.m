//
//  IBContentViewController.m
//  APlayer
//
//  Created by ilyablinov on 01.04.17.
//  Copyright (c) 2017 IB. All rights reserved.
//

#import "IBContentViewController.h"
#import "IBAllMediaViewController.h"
@interface IBContentViewController ()

@end

@implementation IBContentViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
  
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma set left bar button item

- (UIBarButtonItem*) setLeftBackBarButtonItem:(NSString *) titleItem{
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:  titleItem style:UIBarButtonItemStylePlain target:self action:@selector(backItemAction:)];
    
    
    [backItem setTitleTextAttributes:[IBFontAttributes attributesOfBackButton]forState:UIControlStateNormal];
    
    
    
    return backItem;
    
}

#pragma mark - Actions

- (void) backItemAction:(UIBarButtonItem*) barButtonItem{
    
    NSArray *allControllers = [self.navigationController viewControllers];
    
    if ([self.navigationItem.leftBarButtonItem.title isEqualToString:@"All Media"]) {
        
        for (IBContentViewController *vc in [self.navigationController viewControllers]) {
            
            if ([vc isKindOfClass:[IBAllMediaViewController class]]) {
                 [self.navigationController popToViewController:vc animated:YES];
            }
        }
        
       
    }else{
        
        IBContentViewController *vc = [allControllers objectAtIndex:[allControllers count] - 2];
        
        [self.navigationController popToViewController:vc animated:YES];
    }
}

#pragma mark - sortingItems

- (NSArray*) sortingItems:(NSArray*) items ByProperty:(NSString*) property{
    
    NSMutableArray *array = [NSMutableArray arrayWithArray:items];
    
    for (int i = 0; i < [items count] - 1; i++) {
        
        MPMediaItem *item1 = [items objectAtIndex:i];
        MPMediaItem *item2 = [items objectAtIndex:i + 1];
        
        NSString *itemTitle1 = [item1 valueForProperty:property];
        NSString *itemTitle2 = [item2 valueForProperty:property];
        
        
        if ([itemTitle1 isEqualToString:itemTitle2]) {
            [array removeObject:item1];
        }
        
        if ([itemTitle1 isEqualToString:@""] | (itemTitle1 == nil) ){
            [array removeObject:item1];
        }
        
        if ([itemTitle2 isEqualToString:@""] | (itemTitle2 == nil)){
            [array removeObject:item2];
        }
        
    }
    return array;
    
}


@end
