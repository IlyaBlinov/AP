//
//  IBAlbumsViewController.m
//  APlayer
//
//  Created by ilyablinov on 01.04.17.
//  Copyright (c) 2017 IB. All rights reserved.
//

#import "IBAlbumsViewController.h"
#import "IBAlbumViewCell.h"
#import "IBArtistInfoViewController.h"
#import "IBSongsViewController.h"






@interface IBAlbumsViewController ()

@property (strong, nonatomic) NSArray *albums;
@property (strong, nonatomic) NSString *backItemTitle;
@end

@implementation IBAlbumsViewController



- (void)viewDidLoad
{
    
    
    [super viewDidLoad];
    
    
    
   [ self.tableView setEditing: [[IBCurrentParametersManager sharedManager] isEditing]];
    
    
    if ([[IBCurrentParametersManager sharedManager] isEditing]) {
        
       self.navigationItem.rightBarButtonItem =  [self createChooseSongsItem];
        
        self.tableView.allowsSelectionDuringEditing = YES;
        
    }
    
    
    [self.navigationItem setHidesBackButton:NO animated:NO];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    
    IBSongsViewType songsType = [[IBCurrentParametersManager sharedManager] songsViewType];
    NSDictionary *titleAndAlbumsDictionary = [[IBFileManager sharedManager] getAlbumsAndTitleFor:songsType];
    
    NSString *title = [titleAndAlbumsDictionary valueForKey:@"title"];
    NSArray  *albums  = [titleAndAlbumsDictionary valueForKey:@"albums"];
    self.albums = [NSArray arrayWithArray:albums];

    
    UIBarButtonItem *backItem =   [self setLeftBackBarButtonItem:title];
    [self.navigationItem setLeftBarButtonItem:backItem];
    
    self.navigationItem.titleView = [IBFontAttributes getCustomTitleForControllerName:@"Albums"];
    
    
    
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
    
    
    return [self.albums count];
}


- (IBAlbumViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static  NSString *identifier = @"cell";
    
    IBAlbumViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[IBAlbumViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                              reuseIdentifier:identifier];
    }
    
    MPMediaItem *album = [self.albums objectAtIndex:indexPath.row];
    
    NSString *albumTitle =       [album valueForProperty:MPMediaItemPropertyAlbumTitle];
    NSString *albumArtistTitle = [album valueForProperty:MPMediaItemPropertyAlbumArtist];
    MPMediaItemArtwork *albumImageItem = [album valueForProperty:MPMediaItemPropertyArtwork];
    
    CGRect imageRect = cell.albumImage.bounds;
    CGSize sizeOfAlbumImageItem = CGSizeMake(CGRectGetWidth(imageRect), CGRectGetHeight(imageRect));
    UIImage *albumImage = [albumImageItem imageWithSize:sizeOfAlbumImageItem];
    
    if (albumTitle == nil) {
        albumTitle = @"";
    }else if (albumArtistTitle == nil){
        albumArtistTitle = @"";
    }else if (albumImage == nil){
        albumImage = [UIImage imageNamed:@"anonymous-logo(4).png"];
    }
        
    
    
    NSAttributedString *albumName  = [[NSAttributedString alloc] initWithString:albumTitle];
    NSAttributedString *artistName = [[NSAttributedString alloc] initWithString:albumArtistTitle];
    
    

    cell.albumImage.image            = albumImage;
    cell.albumTitle.attributedText   = albumName;
    cell.artistTitle.attributedText  = artistName;
    
    if ([[IBCurrentParametersManager sharedManager] isEditing]) {
        
        IBPlayerItem *addButton = [[IBPlayerItem alloc]initWithButtonStyle:add];
        [addButton addTarget:self action:@selector(addToPlaylistAction:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.editingAccessoryView = addButton;
        
    }else{
        
        cell.editingAccessoryView = nil;
    }
    
    return cell;
    
}




#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MPMediaItem *currentAlbum = [self.albums objectAtIndex:indexPath.row];
    
    [IBCurrentParametersManager sharedManager].songsViewType = album;
    [[IBCurrentParametersManager sharedManager] setAlbum:currentAlbum];
    
    NSString *identifier = @"IBSongsViewController";
    
    
    IBSongsViewController *vcSongs = [self.storyboard instantiateViewControllerWithIdentifier:identifier];
    
        [self.navigationController pushViewController:vcSongs animated:YES];
    
    
    NSLog(@" pushViewController IBSongsViewController from IBAlbumsViewController");
    
        
    }




#pragma mark - Action

- (void) addToPlaylistAction:(IBPlayerItem*) button{
    
    CGPoint point = [button convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:point];
    
    
    MPMediaItem *album = [self.albums objectAtIndex:indexPath.row];
    NSArray *songs = [[IBFileManager sharedManager] getAllSongsOfAlbum:album];
    
    
    if (button.isSelected == NO) {
        [button setImage: [UIImage imageNamed:@"Added.png"]forState:UIControlStateSelected];
        [button setIsSelected:YES];
        [[IBCurrentParametersManager sharedManager].addedSongs addObjectsFromArray:songs];
    }else{
        [button setImage: [UIImage imageNamed:@"add 64 x 64.png"]forState:UIControlStateNormal];
        [button setIsSelected:NO];
        NSUInteger location = [[IBCurrentParametersManager sharedManager].addedSongs count] - [songs count] ;
        
        [[IBCurrentParametersManager sharedManager].addedSongs removeObjectsInRange:NSMakeRange(location, [songs count])];
    }
    
    
    NSLog(@"added songs = %lu",(unsigned long)[[[IBCurrentParametersManager sharedManager]addedSongs]count]);
    
    
}



@end
