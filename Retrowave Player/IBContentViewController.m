//
//  IBContentViewController.m
//  APlayer
//
//  Created by ilyablinov on 01.04.17.
//  Copyright (c) 2017 IB. All rights reserved.
//

#import "IBContentViewController.h"
#import "IBAllMediaViewController.h"
#import "IBFileManager.h"

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
    
    [IBCurrentParametersManager sharedManager].songsViewType = playlist;
    
    MPMediaPlaylist *currentPlaylist = [[IBCurrentParametersManager sharedManager] changingPlaylist];
    NSArray *addedSongs              = [NSArray arrayWithArray:[[IBCurrentParametersManager sharedManager] addedSongs]];
    
  
    __weak IBContentViewController       *weakSongsVC = self;
    
    [[IBCurrentParametersManager sharedManager] setIsEditing:NO];
    
    
    [currentPlaylist addMediaItems:addedSongs completionHandler:^(NSError * _Nullable error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
           
            [weakSongsVC dismissViewControllerAnimated:YES completion:nil];
        
        });
        
    }];
    
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
        
    if ([vc isKindOfClass:[IBSongsAddViewController class]]) {
            [[IBCurrentParametersManager sharedManager] setReturnSongsViewController:nil];
        }
        
        
   }
    


#pragma mark - addSongs


- (void) createChooseSongsItem{
    
    IBPlayerItem *addToPlaylistButton = [[IBPlayerItem alloc] initWithFrame:CGRectMake(0,0, 20, 20)];
    [addToPlaylistButton setImage: [UIImage imageNamed:@"Added.png"]forState:UIControlStateNormal];
    [addToPlaylistButton addTarget:self action:@selector(chooseSongs:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:addToPlaylistButton];
    
    self.navigationItem.rightBarButtonItem = item;

    
}





@end
