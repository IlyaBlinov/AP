//
//  IBContentViewController.m
//  APlayer
//
//  Created by ilyablinov on 01.04.17.
//  Copyright (c) 2017 IB. All rights reserved.
//

#import "IBContentViewController.h"
#import "IBAllMediaViewController.h"
#import "IBCurrentParametersManager.h"

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


- (void)dealloc
{
   

    NSLog(@"%@ is deallocated", [self description]);
}


#pragma mark - UITableViewDelegate

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleNone;
}


- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath{
    return NO;
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
        
        if ([[IBCurrentParametersManager sharedManager] isEditing]) {
        
            [[IBCurrentParametersManager sharedManager] setSongsViewControllerDataViewMode:playlist];
            MPMediaPlaylist *changingPlaylist = [[IBCurrentParametersManager sharedManager] changingPlaylist];
            [[IBCurrentParametersManager sharedManager] setPlaylist:changingPlaylist];
            
        }else{
        
            [[IBCurrentParametersManager sharedManager] setSongsViewControllerDataViewMode:allSongs];
        }
        
    }
    
    IBContentViewController *vc;
    
    if ([allControllers count] > 1) {
        vc = [allControllers objectAtIndex:[allControllers count] - 2];
    }else{
         vc = [allControllers objectAtIndex:[allControllers count] - 1];
    }
    
    
    
    [self.navigationController popToViewController:vc animated:YES];
    NSLog(@"popToViewController %@", [vc description]);
        
    if ([vc isKindOfClass:[IBSongsAddViewController class]]) {
            [[IBCurrentParametersManager sharedManager] setReturnSongsViewController:nil];
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
