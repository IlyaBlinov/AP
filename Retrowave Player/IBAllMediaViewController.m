//
//  IBAllMediaViewController.m
//  APlayer
//
//  Created by ilyablinov on 24.03.17.
//  Copyright (c) 2017 IB. All rights reserved.
//

#import "IBAllMediaViewController.h"
#import "IBSongCellTableViewCell.h"
#import "IBMainTabBarController.h"
#import "IBArtistsViewController.h"
#import "IBAlbumsViewController.h"
#import "IBSongsViewController.h"
#import "IBPlaylistlistViewController.h"
#import "IBAllMediaCell.h"
#import "IBSongsAddViewController.h"
#import "IBSongsFromCoreDataViewController.h"





@interface IBAllMediaViewController ()<UITabBarDelegate>
@property (strong, nonatomic) NSTimer *timer;
@end

@implementation IBAllMediaViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSInteger status = [MPMediaLibrary authorizationStatus];
    
    if (status != MPMediaLibraryAuthorizationStatusAuthorized ) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(checkStatus) userInfo:nil repeats:YES];
    }

    
    [self.navigationItem setHidesBackButton:NO animated:NO];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    
    if (([IBCurrentParametersManager sharedManager].songsViewType == playlist) && [[IBCurrentParametersManager sharedManager] isEditing]) {
       
      self.navigationItem.rightBarButtonItem = [self createChooseSongsItem];
        
    }
    
   
 
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource



- (IBAllMediaCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
       IBAllMediaCell *cell = (IBAllMediaCell*)[super tableView:tableView cellForRowAtIndexPath:indexPath];
    
    if ([cell.reuseIdentifier isEqualToString:@"songsCell"]) {
        
        cell = [self configureCell:cell cellTitle:@"Songs"];

    }else if ([cell.reuseIdentifier isEqualToString:@"artistsCell"]) {
        
        cell = [self configureCell:cell cellTitle:@"Artists"];
        
    }else if ([cell.reuseIdentifier isEqualToString:@"albumsCell"]) {
        
        cell = [self configureCell:cell cellTitle:@"Albums"];
        
    }else if ([cell.reuseIdentifier isEqualToString:@"audioBooksCell"]) {
        
        cell = [self configureCell:cell cellTitle:@"Audio Books"];
        
    }else if ([cell.reuseIdentifier isEqualToString:@"itunesPlaylistsCell"]) {
        
        cell = [self configureCell:cell cellTitle:@"ITunes Playlists"];
        
//        if ([vc isKindOfClass:[IBSongsFromCoreDataViewController class]] && editing) {
//            [cell setHidden:YES];
//        }else{
//            [cell setHidden:NO];
//        }
        
        
    }else if ([cell.reuseIdentifier isEqualToString:@"coreDataPlaylistsCell"]) {
        
        cell = [self configureCell:cell cellTitle:@"Playlists"];
        
//        if ([vc isKindOfClass:[IBSongsFromCoreDataViewController class]] && editing) {
//             [cell setHidden:NO];
//        }else{
//            [cell setHidden:YES];
//        }

        
       
        
    }
    

       return cell;
}


#pragma mark - UITableViewDelegate


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    if (indexPath.row == 5) {
        
        
        BOOL editing = [[IBCurrentParametersManager sharedManager]isEditing];
        
        IBContentViewController *vc = [[IBCurrentParametersManager sharedManager] returnSongsViewController];
        
        if ([vc isKindOfClass:[IBSongsFromCoreDataViewController class]] && editing){
             return [super tableView:tableView heightForRowAtIndexPath:indexPath];
        }
        
        IBAllMediaCell *cell = (IBAllMediaCell*)[super tableView:tableView cellForRowAtIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.accessoryView = nil;
        return 0;
    }
    
    if (indexPath.row == 4) {
        
        
        BOOL editing = [[IBCurrentParametersManager sharedManager]isEditing];
        
        IBContentViewController *vc = [[IBCurrentParametersManager sharedManager] returnSongsViewController];
        
        if ([vc isKindOfClass:[IBSongsFromCoreDataViewController class]] && editing){
            IBAllMediaCell *cell = (IBAllMediaCell*)[super tableView:tableView cellForRowAtIndexPath:indexPath];
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.accessoryView = nil;
            return 0;

        }
        return [super tableView:tableView heightForRowAtIndexPath:indexPath];
        
            }

    
    
    
    
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}





- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    IBAllMediaCell *cell = (IBAllMediaCell*)[tableView cellForRowAtIndexPath:indexPath];
    
    if ([cell.categoryName.text isEqualToString:@"Songs"] | [cell.categoryName.text isEqualToString:@"Audio Books"]) {
        
        [IBCurrentParametersManager sharedManager].songsViewType = allSongs;
        IBSongsViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"IBSongsViewController"];
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if ([cell.categoryName.text isEqualToString:@"ITunes Playlists"]) {
        [IBCurrentParametersManager sharedManager].songsViewType = playlist;
        IBPlaylistlistViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"IBPlaylistlistViewController"];
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([cell.categoryName.text isEqualToString:@"Artists"]) {
        [IBCurrentParametersManager sharedManager].songsViewType = artist;
        IBArtistsViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"IBArtistsViewController"];
        [self.navigationController pushViewController:vc animated:YES];

    }else if ([cell.categoryName.text isEqualToString:@"Albums"]) {
        [IBCurrentParametersManager sharedManager].songsViewType = album;
        IBAlbumsViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"IBAlbumsViewController"];
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if ([cell.categoryName.text isEqualToString:@"Playlists"]) {
        [IBCurrentParametersManager sharedManager].songsViewType = playlist;
        IBPlaylistlistViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"IBPlaylistsFromCoreDataViewController"];
        [self.navigationController pushViewController:vc animated:YES];

    }
}




#pragma mark - Actions

- (void) checkStatus{
    __weak IBAllMediaViewController *weakSelf = self;
    
    
    NSInteger status = [MPMediaLibrary authorizationStatus];
    
    switch (status) {
            
        case MPMediaLibraryAuthorizationStatusNotDetermined:
            NSLog(@"MPMediaLibraryAuthorizationStatusNotDetermined");
            break;
            
        case MPMediaLibraryAuthorizationStatusDenied:
            NSLog(@"MPMediaLibraryAuthorizationStatusDenied");
            break;
            
        case MPMediaLibraryAuthorizationStatusRestricted:
            NSLog(@"MPMediaLibraryAuthorizationStatusRestricted");
            break;
            
        case MPMediaLibraryAuthorizationStatusAuthorized:
            [weakSelf.timer invalidate];
            weakSelf.timer = nil;
            [weakSelf.tableView reloadData];
            NSLog(@"MPMediaLibraryAuthorizationStatusAuthorized");
            break;
            
            
            
        default:
            NSLog(@"Default");
            break;
    }
  
    
}

#pragma mark - Configure IBAllMediaCell

- (IBAllMediaCell*) configureCell:(IBAllMediaCell*) cell cellTitle:(NSString*)title {
    
    NSDictionary *attributes = [IBFontAttributes attributesOfMainTitle];
    
    NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:title];
    NSMutableAttributedString *mainTitle = [[NSMutableAttributedString alloc] initWithAttributedString:attributedText];
    
    [mainTitle setAttributes:attributes range:NSMakeRange(0, [mainTitle length])];
    
    cell.categoryName.attributedText = mainTitle;
    
    
    IBPlayerItem *accessoryButton = [[IBPlayerItem alloc] initWithFrame:CGRectMake(0,0, 20, 20)];
    [accessoryButton setImage: [UIImage imageNamed:@"skip-track.png"]forState:UIControlStateNormal];

    cell.accessoryView = accessoryButton;
    
    if ([title isEqualToString:@"Songs"]) {
        
        cell.categoryImage.image = [UIImage imageNamed:@"music-playlist(4).png"];
        
    }else if ([title isEqualToString:@"Artists"]) {
        
        cell.categoryImage.image = [UIImage imageNamed:@"artists 64 x 64.png"];
        
    }else if ([title isEqualToString:@"Albums"]) {
        
        cell.categoryImage.image = [UIImage imageNamed:@"vinyl-music-player.png"];
        
    }else if ([title isEqualToString:@"Playlists"]) {
        
        cell.categoryImage.image = [UIImage imageNamed:@"songs-list.png"];
        
    }else if ([title isEqualToString:@"ITunes Playlists"]) {
        
        cell.categoryImage.image = [UIImage imageNamed:@"songs-list.png"];
        
    }else if ([title isEqualToString:@"Audio Books"]) {
        
        cell.categoryImage.image = [UIImage imageNamed:@"cassette-tape(4).png"];
        
    }

    
    
    return cell;
    
    
}



@end
