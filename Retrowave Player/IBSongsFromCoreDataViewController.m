//
//  IBSongsFromCoreDataViewController.m
//  Retrowave Player
//
//  Created by eastwood on 17/07/2017.
//  Copyright © 2017 Илья Блинов. All rights reserved.
//

#import "IBSongsFromCoreDataViewController.h"

@interface IBSongsFromCoreDataViewController ()
@property (strong, nonatomic) IBPlaylist *currentPlaylist;
@property (strong, nonatomic) NSArray *songs;
@end

@implementation IBSongsFromCoreDataViewController

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [ self.tableView setEditing: [[IBCurrentParametersManager sharedManager] isEditing]];
    
    if ([[IBCurrentParametersManager sharedManager] isEditing]) {
        
        self.navigationItem.rightBarButtonItem =  [self createChooseSongsItem];
        
    }else{
        
        IBPlayerItem *addToPlaylistButton = [[IBPlayerItem alloc] initWithButtonStyle:add];
        [addToPlaylistButton addTarget:self action:@selector(addNewSongs) forControlEvents:UIControlEventTouchUpInside];
        
        IBBarButtonItem *addToPlaylistItem = [[IBBarButtonItem alloc] initWithButton:addToPlaylistButton];
        
        self.navigationItem.rightBarButtonItem = addToPlaylistItem;
        
    }
    
        
    if ([self isEqual:[[IBCurrentParametersManager sharedManager]returnSongsViewController]]) {
        
        self.currentPlaylist = nil;
        IBPlaylist *currentPlaylist = [[IBCurrentParametersManager sharedManager] coreDataChangingPlaylist];
       
        self.songs = [currentPlaylist.songItems allObjects];
        
        self.currentPlaylist = currentPlaylist;
        
        NSLog(@"songsCount = %lu", (unsigned long)[[self.currentPlaylist songItems]count]);
        
        [[IBCurrentParametersManager sharedManager].addedSongs removeAllObjects];
        [[IBCurrentParametersManager sharedManager] setCoreDataPlaylist:nil];
        [[IBCurrentParametersManager sharedManager] setReturnSongsViewController:nil];
        [self.tableView reloadData];
        
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    IBPlaylist *currentPlaylist = [[IBCurrentParametersManager sharedManager] coreDataPlaylist];
    self.currentPlaylist = currentPlaylist;
    
   
    self.songs      = [currentPlaylist.songItems allObjects];
    NSString *title = currentPlaylist.playlistName;
    
    
    UIBarButtonItem *backItem =   [self setLeftBackBarButtonItem:title];
    [self.navigationItem setLeftBarButtonItem:backItem];
    
    self.navigationItem.titleView = [IBFontAttributes getCustomTitleForControllerName:@"Songs"];
    
    
}


- (void)dealloc
{

    [IBCurrentParametersManager sharedManager].coreDataPlaylist = nil;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark - Actions



- (void)addNewSongs{
    
    [[IBCurrentParametersManager sharedManager] setIsEditing:YES];//playlist was saved to IBCurrentParametersManager in IBPlaylistsController
    
    [[IBCurrentParametersManager sharedManager] setCoreDataPlaylist:self.currentPlaylist];
    [[IBCurrentParametersManager sharedManager] setReturnSongsViewController:self];
    
    UINavigationController *nav = [self.storyboard instantiateViewControllerWithIdentifier:@"IBAllMediaNavigationViewController"];
    
    
    [self.navigationController presentViewController:nav animated:YES completion:nil];
    
}







/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
