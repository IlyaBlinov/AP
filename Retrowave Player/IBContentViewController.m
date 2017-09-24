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
    
    [IBCurrentParametersManager sharedManager].songsViewType = playlist_type;
    
    
    NSArray *addedMediaItems = [NSArray arrayWithArray:[[IBCurrentParametersManager sharedManager] addedSongs]];
    NSArray *addedSongs = [addedMediaItems valueForKeyPath:@"@unionOfObjects.mediaEntity"];
    
    IBContentViewController *returnedVC = [[IBCurrentParametersManager sharedManager]returnSongsViewController];
    
    [[IBCurrentParametersManager sharedManager] setIsEditing:NO];
   
    if ([returnedVC isKindOfClass:[IBSongsAddViewController class]]) {
 
    IBMediaItem *currentPlaylist = [[IBCurrentParametersManager sharedManager] changingPlaylist];
        MPMediaPlaylist *playlistItem = (MPMediaPlaylist*)[currentPlaylist mediaEntity];
    
    __weak IBSongsAddViewController       *weakSongsVC = (IBSongsAddViewController*)returnedVC;
    
        [weakSongsVC dismissViewControllerAnimated:YES completion:nil];
        
    [playlistItem addMediaItems:addedSongs completionHandler:^(NSError * _Nullable error) {
        
        if ([addedSongs count] > 0) {
            [weakSongsVC reloadSongs];
        }
        
    }];
    
    }else{
        
        IBSongsFromCoreDataViewController *coreDataSongsVC = (IBSongsFromCoreDataViewController*)returnedVC;
        
        
        NSArray *removedMediaItems = [NSArray arrayWithArray:[[IBCurrentParametersManager sharedManager] removedSongs]];
        
        NSArray *removedSongsPersistentIDs = [removedMediaItems valueForKeyPath:@"@unionOfObjects.mediaEntity.persistentID"];
        
        IBPlaylist *changingPlaylist = [[IBCurrentParametersManager sharedManager] coreDataChangingPlaylist];
        
        
        if ([removedMediaItems count] > 0) {
            [[IBCoreDataManager sharedManager]deleteIBSongItemsByPersistentIDs:removedSongsPersistentIDs fromCoreDataPlaylist:changingPlaylist];
            [[IBCoreDataManager sharedManager] resortPositionsOfSongItemsInPlaylist:changingPlaylist];

        }
        
        if ([addedSongs count] > 0) {
            
            NSArray *addedSongsPersistentIDArray = [addedSongs valueForKeyPath:@"@unionOfObjects.persistentID"];
            
            [[IBCoreDataManager sharedManager] saveIBSongItemsByPersistentIDs:addedSongsPersistentIDArray];
        }
        
        
        
       [coreDataSongsVC dismissViewControllerAnimated:YES completion:nil];
        
        
    }
}





- (void) backItemAction:(UIBarButtonItem*) barButtonItem{
    
    NSArray *allControllers = [self.navigationController viewControllers];
    
    
    if ([self.navigationItem.leftBarButtonItem.title isEqualToString:@"All Media"]) {
        
        if ([[IBCurrentParametersManager sharedManager] isEditing]) {
        
            [[IBCurrentParametersManager sharedManager] setSongsViewType:playlist_type];
            IBMediaItem *changingPlaylist = [[IBCurrentParametersManager sharedManager] changingPlaylist];
            [[IBCurrentParametersManager sharedManager] setPlaylist:changingPlaylist];
            
        }else{
        
            [[IBCurrentParametersManager sharedManager] setSongsViewType:allSongs_type];
        }
        
    }
    
    IBContentViewController *vc;
    
    
    NSLog(@"All Controllers = %@", allControllers);
    
    if ([allControllers count] > 1) {
        vc = [allControllers objectAtIndex:[allControllers count] - 2];
    }else{
         vc = [allControllers objectAtIndex:[allControllers count] - 1];
    }
    
    NSLog(@"VC description = %@", [vc class]);
    
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
