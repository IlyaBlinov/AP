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


- (void)chooseSongs:(IBPlayerItem *) button{
    
    [IBCurrentParametersManager sharedManager].songsViewControllerDataViewMode = playlist;
    
    MPMediaPlaylist *currentPlaylist = [[IBCurrentParametersManager sharedManager] changingPlaylist];
    NSArray *addedSongs              = [NSArray arrayWithArray:[[IBCurrentParametersManager sharedManager] addedSongs]];
    
    IBSongsAddViewController *vc     = [[IBCurrentParametersManager sharedManager] returnSongsViewController];
    __weak IBSongsAddViewController     *weakVC   = vc;
    
    UINavigationController *navAllVC = [self.tabBarController.viewControllers objectAtIndex:0];
    __weak UINavigationController        *weakNavAllVC = navAllVC;
    __weak IBContentViewController       *weakSongsVC = self;
    
    
    
    
    UINavigationController *navPlaylistVC = [self.tabBarController.viewControllers objectAtIndex:3];
    __weak UINavigationController        *weakNavPlaylistVC = navPlaylistVC;
    
    [[IBCurrentParametersManager sharedManager] setIsEditing:NO];
    
    
    [currentPlaylist addMediaItems:addedSongs completionHandler:^(NSError * _Nullable error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakNavPlaylistVC popToViewController:weakVC animated:YES];
            [weakSongsVC.tabBarController setSelectedIndex:3];
            [weakNavAllVC popToRootViewControllerAnimated:YES];
            
            
            if ([weakSongsVC.navigationController.tabBarItem.title isEqualToString:@"Songs"]) {
                [weakSongsVC.navigationItem setLeftBarButtonItem:nil];
                [weakSongsVC.navigationController setNavigationBarHidden:YES];
                [weakSongsVC.navigationItem setHidesBackButton:YES animated:NO];
                [weakSongsVC.tableView reloadData];
            }
            
        });
        
    }];
    
    
}





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
