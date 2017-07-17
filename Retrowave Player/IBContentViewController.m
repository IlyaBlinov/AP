//
//  IBContentViewController.m
//  APlayer
//
//  Created by ilyablinov on 01.04.17.
//  Copyright (c) 2017 IB. All rights reserved.
//

#import "IBContentViewController.h"
#import "IBAllMediaViewController.h"
#import "IBFontAttributes.h"
#import "IBSongsAddViewController.h"
#import "IBSongsFromCoreDataViewController.h"
#import "IBCoreDataManager.h"

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


- (void)chooseSongs{
    
    [IBCurrentParametersManager sharedManager].songsViewType = playlist;
    
    
    NSArray *addedSongs              = [NSArray arrayWithArray:[[IBCurrentParametersManager sharedManager] addedSongs]];
    
    IBContentViewController *returnedVC = [[IBCurrentParametersManager sharedManager]returnSongsViewController];
    
    [[IBCurrentParametersManager sharedManager] setIsEditing:NO];
    
    if ([returnedVC isKindOfClass:[IBSongsAddViewController class]]) {
 
    MPMediaPlaylist *currentPlaylist = [[IBCurrentParametersManager sharedManager] changingPlaylist];
    
    
    __weak IBContentViewController       *weakSongsVC = self;
    
    [currentPlaylist addMediaItems:addedSongs completionHandler:^(NSError * _Nullable error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
           
            [weakSongsVC dismissViewControllerAnimated:YES completion:nil];
        
        });
        
    }];
    
    }else{
        
        IBSongsFromCoreDataViewController *coreDataSongsVC = (IBSongsFromCoreDataViewController*)returnedVC;
        
        
        
        IBPlaylist *changingPlaylist = [[IBCurrentParametersManager sharedManager] coreDataChangingPlaylist];
        
        
        NSArray *persistentIDArray = [[IBFileManager sharedManager]getPersistentIDFromSongs:addedSongs];
        
        NSSet *setOfSongsItems = [[NSSet alloc] initWithArray:persistentIDArray];
        
        [changingPlaylist addSongItems:setOfSongsItems];
        
        [coreDataSongsVC dismissViewControllerAnimated:YES completion:nil];
        [[IBCoreDataManager sharedManager] saveContext];
        
    }
}





- (void) backItemAction:(UIBarButtonItem*) barButtonItem{
    
    NSArray *allControllers = [self.navigationController viewControllers];
    
    
    if ([self.navigationItem.leftBarButtonItem.title isEqualToString:@"All Media"]) {
        
        if ([[IBCurrentParametersManager sharedManager] isEditing]) {
        
            [[IBCurrentParametersManager sharedManager] setSongsViewType:playlist];
            MPMediaPlaylist *changingPlaylist = [[IBCurrentParametersManager sharedManager] changingPlaylist];
            [[IBCurrentParametersManager sharedManager] setPlaylist:changingPlaylist];
            
        }else{
        
            [[IBCurrentParametersManager sharedManager] setSongsViewType:allSongs];
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
        
    if ([vc isKindOfClass:[IBSongsAddViewController class]] | [vc isKindOfClass:[IBSongsFromCoreDataViewController class]]) {
            [[IBCurrentParametersManager sharedManager] setReturnSongsViewController:nil];
        }

    
   }
    


#pragma mark - addSongs


- (IBBarButtonItem*) createChooseSongsItem{
    
    IBPlayerItem *chooseButton = [[IBPlayerItem alloc] initWithButtonStyle:choose];
    [chooseButton addTarget:self action:@selector(chooseSongs) forControlEvents:UIControlEventTouchUpInside];
    IBBarButtonItem *item = [[IBBarButtonItem alloc] initWithButton:chooseButton];
    
    return item;

    
}



- (void) addToPlaylistAction:(IBPlayerItem*) button{
    
    
    
}



@end
