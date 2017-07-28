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
    
    
    if (([IBCurrentParametersManager sharedManager].songsViewType == playlist_type) && [[IBCurrentParametersManager sharedManager] isEditing]) {
       
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
    
    NSString *title;
    
    if ([cell.reuseIdentifier isEqualToString:@"songsCell"]) {
        
       // cell = [self configureCell:cell cellTitle:@"Songs"];

       title = @"Songs";
        
    }else if ([cell.reuseIdentifier isEqualToString:@"artistsCell"]) {
        
        //cell = [self configureCell:cell cellTitle:@"Artists"];
        
        title = @"Artists";
        
    }else if ([cell.reuseIdentifier isEqualToString:@"albumsCell"]) {
        
       // cell = [self configureCell:cell cellTitle:@"Albums"];
        
        title = @"Albums";
        
    }else if ([cell.reuseIdentifier isEqualToString:@"audioBooksCell"]) {
        
        //cell = [self configureCell:cell cellTitle:@"Audio Books"];
        
        title = @"Audio Books";
        
    }else if ([cell.reuseIdentifier isEqualToString:@"itunesPlaylistsCell"]) {
        
        //cell = [self configureCell:cell cellTitle:@"ITunes Playlists"];
        
//        if ([vc isKindOfClass:[IBSongsFromCoreDataViewController class]] && editing) {
//            [cell setHidden:YES];
//        }else{
//            [cell setHidden:NO];
//        }
        
        title = @"ITunes Playlists";
        
    }else if ([cell.reuseIdentifier isEqualToString:@"coreDataPlaylistsCell"]) {
        
        //cell = [self configureCell:cell cellTitle:@"Playlists"];
        
//        if ([vc isKindOfClass:[IBSongsFromCoreDataViewController class]] && editing) {
//             [cell setHidden:NO];
//        }else{
//            [cell setHidden:YES];
//        }

        
       title = @"Playlists";
        
    }
    
    
    
    NSDictionary *attributes = [IBFontAttributes attributesOfMainTitle];
    
    NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:title];
    NSMutableAttributedString *mainTitle = [[NSMutableAttributedString alloc] initWithAttributedString:attributedText];
    
    [mainTitle setAttributes:attributes range:NSMakeRange(0, [mainTitle length])];
    
    cell.categoryName.attributedText = mainTitle;

    
    //NSData *cellImageData = [self configureImageCellByTitle:title];
    
    cell.categoryImage.image = [self configureImageCellByTitle:title];
    
    
    
    IBPlayerItem *accessoryButton = [[IBPlayerItem alloc] initWithFrame:CGRectMake(0,0, 20, 20)];
//    NSString *accessoryButtonImageLocation = [[NSBundle mainBundle] pathForResource:@"skip-track" ofType:@"png"];
//    
//    NSData *accessoryButtonImageData = [NSData dataWithContentsOfFile:accessoryButtonImageLocation];
    
    [accessoryButton setImage: [UIImage imageNamed:@"skip-track.png"] forState:UIControlStateNormal];
    
    cell.accessoryView = accessoryButton;

    

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
        
        [IBCurrentParametersManager sharedManager].songsViewType = allSongs_type;
        IBSongsViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"IBSongsViewController"];
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if ([cell.categoryName.text isEqualToString:@"ITunes Playlists"]) {
        [IBCurrentParametersManager sharedManager].songsViewType = playlist_type;
        IBPlaylistlistViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"IBPlaylistlistViewController"];
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([cell.categoryName.text isEqualToString:@"Artists"]) {
        [IBCurrentParametersManager sharedManager].songsViewType = artist_type;
        IBArtistsViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"IBArtistsViewController"];
        [self.navigationController pushViewController:vc animated:YES];

    }else if ([cell.categoryName.text isEqualToString:@"Albums"]) {
        [IBCurrentParametersManager sharedManager].songsViewType = album_type;
        IBAlbumsViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"IBAlbumsViewController"];
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if ([cell.categoryName.text isEqualToString:@"Playlists"]) {
        [IBCurrentParametersManager sharedManager].songsViewType = playlist_type;
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

- (UIImage*) configureImageCellByTitle:(NSString*)title {
    

    
    
    if ([title isEqualToString:@"Songs"]) {
        
        NSString *imageOfCellLocation = [[NSBundle mainBundle] pathForResource:@"music-playlist(4)" ofType:@"png"];
        NSData *imagedata = [NSData dataWithContentsOfFile:imageOfCellLocation];
        
        UIImage *image = [UIImage imageWithData:imagedata];
        
        return  image;
    }else if ([title isEqualToString:@"Artists"]) {
        
         NSString *imageOfCellLocation = [[NSBundle mainBundle] pathForResource:@"artists 64 x 64" ofType:@"png"];
         NSData *imagedata = [NSData dataWithContentsOfFile:imageOfCellLocation];
         UIImage *image = [UIImage imageWithData:imagedata];
        
        return  image;
    }else if ([title isEqualToString:@"Albums"]) {
        
        NSString *imageOfCellLocation = [[NSBundle mainBundle] pathForResource:@"vinyl-music-player" ofType:@"png"];
        NSData *imagedata = [NSData dataWithContentsOfFile:imageOfCellLocation];
        UIImage *image = [UIImage imageWithData:imagedata];
        
        return  image;

    }else if ([title isEqualToString:@"Playlists"] | [title isEqualToString:@"ITunes Playlists"]) {
        
         NSString *imageOfCellLocation = [[NSBundle mainBundle] pathForResource:@"songs-list" ofType:@"png"];
         NSData *imagedata = [NSData dataWithContentsOfFile:imageOfCellLocation];
         UIImage *image = [UIImage imageWithData:imagedata];
              return  image;

    }else if ([title isEqualToString:@"Audio Books"]) {
        
         NSString *imageOfCellLocation = [[NSBundle mainBundle] pathForResource:@"cassette-tape(4)" ofType:@"png"];
         NSData *imagedata = [NSData dataWithContentsOfFile:imageOfCellLocation];
        UIImage *image = [UIImage imageWithData:imagedata];
        
        return  image;
    }else{
        return nil;
    }
    

    
}



@end
