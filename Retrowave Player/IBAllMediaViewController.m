//
//  IBAllMediaViewController.m
//  APlayer
//
//  Created by ilyablinov on 24.03.17.
//  Copyright (c) 2017 IB. All rights reserved.
//

#import "IBAllMediaViewController.h"
#import "IBFontAttributes.h"
#import "IBSongCellTableViewCell.h"
#import "IBMainTabBarController.h"
#import "IBArtistsViewController.h"
#import "IBAlbumsViewController.h"
#import "IBSongsViewController.h"
#import "IBPlaylistlistViewController.h"
#import "IBAllMediaCell.h"
#import "IBCurrentParametersManager.h"





@interface IBAllMediaViewController ()<UITabBarDelegate>
@property (strong, nonatomic) NSArray *categories;
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
    
    NSArray* categories = [NSArray arrayWithObjects:
                           @"Songs", @"Artists", @"Albums", @"Audio Books", @"Playlists", nil];
    
    self.categories = [NSArray arrayWithArray:categories];
 
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

     return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

   
    return [self.categories count];
}


- (IBAllMediaCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    
    
    IBAllMediaCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell){
        cell = [[IBAllMediaCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    NSString *category = [self.categories objectAtIndex:indexPath.row];

    
    NSDictionary *attributes = [IBFontAttributes attributesOfMainTitle];
    
    
    NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:category];
    
    NSMutableAttributedString *mainTitle = [[NSMutableAttributedString alloc] initWithAttributedString:attributedText];
    
    [mainTitle setAttributes:attributes range:NSMakeRange(0, [mainTitle length])];
    
    
    cell.categoryName.attributedText = mainTitle;
    
    IBPlayerItem *accessoryButton = [[IBPlayerItem alloc] initWithFrame:CGRectMake(0,0, 20, 20)];
    [accessoryButton setImage: [UIImage imageNamed:@"skip-track.png"]forState:UIControlStateNormal];
    
    cell.accessoryView = accessoryButton;
    
    if ([category isEqualToString:@"Songs"]) {
        
        cell.categoryImage.image = [UIImage imageNamed:@"music-playlist(4).png"];
        
    }else if ([category isEqualToString:@"Artists"]) {
        
        cell.categoryImage.image = [UIImage imageNamed:@"artists 64 x 64.png"];
     
    }else if ([category isEqualToString:@"Albums"]) {
        
        cell.categoryImage.image = [UIImage imageNamed:@"vinyl-music-player.png"];
        
    }else if ([category isEqualToString:@"Playlists"]) {
        
        cell.categoryImage.image = [UIImage imageNamed:@"songs-list.png"];
        
    }else if ([category isEqualToString:@"Audio Books"]) {
        
        cell.categoryImage.image = [UIImage imageNamed:@"cassette-tape(4).png"];
        
    }

   
       return cell;
}


#pragma mark - UITableViewDelegate


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    IBAllMediaCell *cell = (IBAllMediaCell*)[tableView cellForRowAtIndexPath:indexPath];
    
    if ([cell.categoryName.text isEqualToString:@"Songs"] | [cell.categoryName.text isEqualToString:@"Audio Books"]) {
        
        [IBCurrentParametersManager sharedManager].songsViewType = allSongs;
        IBSongsViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"IBSongsViewController"];
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if ([cell.categoryName.text isEqualToString:@"Playlists"]) {
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

@end
