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
#import "IBPlaylist.h"
#import "IBSongsChooseViewController.h"
@interface IBAllMediaViewController ()<UITabBarDelegate>
@property (strong, nonatomic) NSArray *categories;
@end

@implementation IBAllMediaViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationItem setHidesBackButton:NO animated:NO];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    
    
    if ([IBCurrentParametersManager sharedManager].songsViewControllerDataViewMode == playlist) {
    
    MPMediaPlaylist *playlist = [[IBCurrentParametersManager sharedManager] playlist];
        
    NSString *title = [NSString stringWithFormat:@"Playlist  %@", [playlist valueForProperty:MPMediaPlaylistPropertyName]];
    
    UIBarButtonItem *backItem =  [self setLeftBackBarButtonItem:title];
    [self.navigationItem setLeftBarButtonItem:backItem];
    
    
    
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
    
    
//    IBMainTabBarController *tabBarController = (IBMainTabBarController*)[self.navigationController tabBarController];
    
    
    
    IBAllMediaCell *cell = (IBAllMediaCell*)[tableView cellForRowAtIndexPath:indexPath];
    
    if ([cell.categoryName.text isEqualToString:@"Songs"] | [cell.categoryName.text isEqualToString:@"Audio Books"]) {
        
        [IBCurrentParametersManager sharedManager].songsViewControllerDataViewMode = allSongs;
        NSString *identifier = @"IBSongsViewController";
        
        if ([[IBCurrentParametersManager sharedManager] isEditing]) {
            identifier = @"IBSongsChooseViewController";
        }
        
        IBSongsViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:identifier];
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if ([cell.categoryName.text isEqualToString:@"Playlists"]) {
        [IBCurrentParametersManager sharedManager].songsViewControllerDataViewMode = playlist;
        IBPlaylistlistViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"IBPlaylistlistViewController"];
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([cell.categoryName.text isEqualToString:@"Artists"]) {
        [IBCurrentParametersManager sharedManager].songsViewControllerDataViewMode = artist;
        IBArtistsViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"IBArtistsViewController"];
        [self.navigationController pushViewController:vc animated:YES];

    }else if ([cell.categoryName.text isEqualToString:@"Albums"]) {
        [IBCurrentParametersManager sharedManager].songsViewControllerDataViewMode = album;
        IBAlbumsViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"IBAlbumsViewController"];
        [self.navigationController pushViewController:vc animated:YES];
        
    }

    
}


@end
