//
//  IBPlaylistlistViewController.m
//  Retrowave Player
//
//  Created by Илья Блинов on 29.04.17.
//  Copyright © 2017 Илья Блинов. All rights reserved.
//

#import "IBPlaylistlistViewController.h"
#import "IBTransitionViewController.h"
#import "IBTransitionDismissViewController.h"
#import "IBSongsAddViewController.h"
#import "IBAllMediaViewController.h"
#import "IBAddPlaylistViewController.h"
#import "IBPlaylistCell.h"






@interface IBPlaylistlistViewController ()<UIViewControllerTransitioningDelegate>

@property (strong, nonatomic) NSString *backItemTitle;
@property (strong, nonatomic) IBTransitionViewController *animator;
@property (strong, nonatomic) IBTransitionDismissViewController *dismissAnimator;

@end

@implementation IBPlaylistlistViewController




- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
     [ self.tableView setEditing: [[IBCurrentParametersManager sharedManager] isEditing]];
    
    if ([[IBCurrentParametersManager sharedManager] isEditing]) {
        
       self.navigationItem.rightBarButtonItem = [self createChooseSongsItem];
         self.tableView.allowsSelectionDuringEditing = YES;
        
    }else{
        IBPlayerItem *addToPlaylistButton = [[IBPlayerItem alloc] initWithFrame:CGRectMake(0,0, 20, 20)];
        [addToPlaylistButton setImage: [UIImage imageNamed:@"add 64 x 64.png"]forState:UIControlStateNormal];
        [addToPlaylistButton addTarget:self action:@selector(addNewPlaylist) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *addToPlaylistItem = [[UIBarButtonItem alloc] initWithCustomView:addToPlaylistButton];
        self.navigationItem.rightBarButtonItem = addToPlaylistItem;
       
    }
    
    
    

    self.playlists = [[IBFileManager sharedManager] getPlaylists];
    
    
  //  NSLog(@"%@", [[IBFileManager sharedManager] getPersistentIDFromSongs:self.playlists]);
    [self.tableView reloadData];
    
}





- (void)viewDidLoad
{
    [super viewDidLoad];
    


    NSInteger number = [self.navigationController.viewControllers count] - 2;
    
    if (number >= 0) {
        if ([[self.navigationController.viewControllers objectAtIndex:number] isKindOfClass:[IBAllMediaViewController class]]) {
            NSString *title = @"All Media";
            UIBarButtonItem *backItem =   [self setLeftBackBarButtonItem:title];
            [self.navigationItem setLeftBarButtonItem:backItem];
            
        }
        
    }

    
    self.navigationItem.titleView = [IBFontAttributes getCustomTitleForControllerName:@"Playlists"];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    
    return [self.playlists count];
}


- (IBPlaylistCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static  NSString *identifier = @"cell";
    
    IBPlaylistCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[IBPlaylistCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                              reuseIdentifier:identifier];
    }
    
    
    IBMediaItem *playlist = [self.playlists objectAtIndex:indexPath.row];
    
    MPMediaPlaylist *playlistItem = (MPMediaPlaylist*)[playlist mediaEntity];
    
    NSString *playlistName = [playlistItem valueForProperty:MPMediaPlaylistPropertyName];
    
    if ((playlist != nil) && (playlistName != nil) && (![playlistName isEqualToString:@""])){
        
    
    
    NSAttributedString *playlistTitle = [[NSAttributedString alloc] initWithString:playlistName];
    
    NSAttributedString *songCount = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%lu",(unsigned long)[playlistItem.items count]]];
    
        
        cell.playlistTitle.attributedText    = playlistTitle;
        cell.songCount.attributedText        = songCount;
        
        
        IBPlayerItem *accessoryButton = [[IBPlayerItem alloc] initWithButtonStyle:move_next];
        
        if ([[IBCurrentParametersManager sharedManager] isEditing]) {
            
//            IBPlayerItem *addButton = [[IBPlayerItem alloc]initWithButtonStyle:add];
//            [addButton addTarget:self action:@selector(addToPlaylistAction:) forControlEvents:UIControlEventTouchUpInside];
//            
           cell.editingAccessoryView = accessoryButton;
            
        }else{
            cell.accessoryView = accessoryButton;
        }
        
        }
  
    return cell;
    
}


#pragma mark - UITableViewDelegate



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    IBMediaItem *currentPlaylist = [self.playlists objectAtIndex:indexPath.row];
    
    [IBCurrentParametersManager sharedManager].songsViewType = playlist_type;
    
    NSString *identifier = @"IBSongsAddViewController";
    
    IBSongsAddViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:identifier];
    
    [[IBCurrentParametersManager sharedManager] setPlaylist:currentPlaylist];

    [self.navigationController pushViewController:vc animated:YES];
    
 
}


#pragma mark - Actions



//- (void) addToPlaylistAction:(IBPlayerItem*) button{
//    
//    CGPoint point = [button convertPoint:CGPointZero toView:self.tableView];
//    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:point];
//    
//    
//    IBMediaItem   *currentPlaylist = [self.playlists objectAtIndex:indexPath.row];;
//    
//    
//   NSDictionary *parameters = [[IBFileManager sharedManager] getPlaylistParams:currentPlaylist];
//   NSArray *songs = [parameters objectForKey:@"songs"];
//    
//    if (button.isSelected == NO) {
//        [button setImage: [UIImage imageNamed:@"Added.png"]forState:UIControlStateSelected];
//        [button setIsSelected:YES];
//        [[IBCurrentParametersManager sharedManager].addedSongs addObjectsFromArray:songs];
//    }else{
//        [button setImage: [UIImage imageNamed:@"add 64 x 64.png"]forState:UIControlStateNormal];
//        [button setIsSelected:NO];
//        NSUInteger location = [[IBCurrentParametersManager sharedManager].addedSongs count] - [songs count] ;
//        
//        [[IBCurrentParametersManager sharedManager].addedSongs removeObjectsInRange:NSMakeRange(location, [songs count])];
//    }
//    
//    
//    NSLog(@"added songs = %lu",(unsigned long)[[[IBCurrentParametersManager sharedManager]addedSongs]count]);
//
//    
//    
//}
- (void)addNewPlaylist{
 
    IBAddPlaylistViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"IBAddPlaylistViewController"];
    
   
    vc.modalPresentationStyle = UIModalPresentationFormSheet;
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
    
    
   [nav setModalPresentationStyle:UIModalPresentationCustom];
    nav.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
   
    
    nav.transitioningDelegate = self;
    
    [self presentViewController:nav animated:YES
                     completion:^{
                         NSLog(@"modal viewcontroller is created");
                     }];
        
    
    
}


#pragma mark - UIViewControllerTransitioningDelegate

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(IBAddPlaylistViewController *)presenting sourceController:(UIViewController *)source {
    
    self.animator = [[IBTransitionViewController alloc] init];
    
    return self.animator;
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UINavigationController *)dismissed{
    self.dismissAnimator = [[IBTransitionDismissViewController alloc] init];
    
   
    IBAddPlaylistViewController *vc =(IBAddPlaylistViewController*) [dismissed topViewController];
    
    
    if (![vc.playlistName.text isEqualToString: @""]) {
        NSString *newPlaylistName = [[vc playlistName]text];
        
        __weak IBPlaylistlistViewController *weakSelf = self;
        
        NSMutableArray *tempPlaylistArray = [NSMutableArray arrayWithArray:weakSelf.playlists]
        ;
        
      
        
        [[MPMediaLibrary defaultMediaLibrary] getPlaylistWithUUID:[NSUUID UUID]
    creationMetadata:[[MPMediaPlaylistCreationMetadata alloc] initWithName:newPlaylistName ]completionHandler:^(MPMediaPlaylist * _Nullable playlistMediaItem, NSError * _Nullable error) {
        IBMediaItem *newPlaylist = [[IBMediaItem alloc]init];
        newPlaylist.mediaEntity = playlistMediaItem;
        [newPlaylist setType:playlist];
        [tempPlaylistArray addObject:newPlaylist];
        
        weakSelf.playlists = tempPlaylistArray;
       [weakSelf.tableView reloadData];
    
       
    }];
        
    }
 
    return self.dismissAnimator;
}





@end
