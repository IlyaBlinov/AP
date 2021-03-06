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



- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];

    
   // NSLog(@"controllersbefore = %d",[[self.navigationController viewControllers]count]);
     IBSongsViewType songsType = [[IBCurrentParametersManager sharedManager] songsViewType];
    if ([[self.navigationController viewControllers] count] > 3) {
        songsType = artist_type;
        [IBCurrentParametersManager sharedManager].songsViewType = artist_type;
    }
    
    
   
    NSDictionary *titleAndAlbumsDictionary = [[IBFileManager sharedManager] getAlbumsAndTitleFor:songsType];
    
    NSString *title = [titleAndAlbumsDictionary valueForKey:@"title"];
    NSArray  *albums  = [titleAndAlbumsDictionary valueForKey:@"albums"];
    self.albums = [[IBFileManager sharedManager] checkAlbumMediaItems:albums];
    
    if ([[IBCurrentParametersManager sharedManager] isEditing]) {
        
        IBBarButtonItem *chooseBarButton = [self createChooseSongsItem];
        
        NSArray *statesOfSongs = [self.albums valueForKeyPath:@"@distinctUnionOfObjects.state"];
        
        BOOL containsInPlaylistState = [statesOfSongs containsObject:[NSNumber numberWithUnsignedInteger:inPlaylist_state]];
        BOOL containsAddedState = [statesOfSongs containsObject:[NSNumber numberWithUnsignedInteger:added_state]];
        
        
        
        ButtonStyle style = add_all;
        if (   ( ([statesOfSongs count] == 1) && containsAddedState)
            |( containsInPlaylistState && containsAddedState && ([statesOfSongs count] == 2))  ) {
            style = remove_all;
        }

        
        IBPlayerItem *addAllSongs = [[IBPlayerItem alloc] initWithButtonStyle:style];
        if (style == add_all) {
            [addAllSongs setIsSelected:YES];
        }else{
            [addAllSongs setIsSelected:NO];
        }
        [addAllSongs addTarget:self action:@selector(addAllSongs:) forControlEvents:UIControlEventTouchUpInside];
        IBBarButtonItem *addAllSongsBarButton = [[IBBarButtonItem alloc] initWithButton:addAllSongs];
        
        if (songsType == artist_type) {
            self.navigationItem.rightBarButtonItems = @[chooseBarButton,addAllSongsBarButton];
            
        }else{
            self.navigationItem.rightBarButtonItem = chooseBarButton;
        }

        
        
        
        
        
        
        self.tableView.allowsSelectionDuringEditing = YES;
        
        
    }else{
        self.albums = [NSArray arrayWithArray:albums];
    }

    UIBarButtonItem *backItem =   [self setLeftBackBarButtonItem:title];
    [self.navigationItem setLeftBarButtonItem:backItem];

    [self.tableView reloadData];
    
    
    
}




- (void)viewDidLoad
{
  
    [super viewDidLoad];
    
    
   [ self.tableView setEditing: [[IBCurrentParametersManager sharedManager] isEditing]];
    
    [self.navigationItem setHidesBackButton:NO animated:NO];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    self.navigationItem.titleView = [IBFontAttributes getCustomTitleForControllerName:@"Albums"];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)dealloc
{
    self.albums = nil;
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
    
    IBMediaItem *album = [self.albums objectAtIndex:indexPath.row];
    MPMediaItem *albumItem = (MPMediaItem*)[album mediaEntity];
    
    
    NSString *albumTitle =               [albumItem valueForProperty:MPMediaItemPropertyAlbumTitle];
    NSString *albumArtistTitle =         [albumItem valueForProperty:MPMediaItemPropertyAlbumArtist];
    MPMediaItemArtwork *albumImageItem = [albumItem valueForProperty:MPMediaItemPropertyArtwork];
    
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

    
    IBPlayerItem  *addButton = [[IBPlayerItem alloc]initWithItemState:album.state];
    [addButton addTarget:self action:@selector(addToPlaylistAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell setEditingView:addButton];


    return cell;
    
}




#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    IBMediaItem *currentAlbum = [self.albums objectAtIndex:indexPath.row];
    
    [IBCurrentParametersManager sharedManager].songsViewType = album_type;
    [[IBCurrentParametersManager sharedManager] setAlbum:currentAlbum];
    
    NSString *identifier = @"IBSongsViewController";
    
    
    IBSongsViewController *vcSongs = [self.storyboard instantiateViewControllerWithIdentifier:identifier];
    
        [self.navigationController pushViewController:vcSongs animated:YES];
    
    
    NSLog(@" pushViewController IBSongsViewController from IBAlbumsViewController");
    
        
    }




#pragma mark - Action



- (void) addAllSongs:(IBPlayerItem*) button{
    
    NSArray *allStatesOfAlbums = [self.albums valueForKeyPath:@"@distinctUnionOfObjects.state"];
    ItemState state = [[allStatesOfAlbums firstObject] unsignedIntegerValue];
    if ( ([allStatesOfAlbums count] == 1) && (state == inPlaylist_state ) ) {
        
    }else{
    
    if ([button isSelected]) {
        [button setImage: [UIImage imageNamed:@"cancel_all.png"]forState:UIControlStateNormal];
        [button setIsSelected:NO];
        
        for (IBMediaItem *album in self.albums) {
             NSArray *songsArray = [[IBFileManager sharedManager] getAllSongsOfAlbum:album];
             NSArray *checkedSongsArray = [[IBFileManager sharedManager] checkSongMediaItems:songsArray];
            
            if (album.state == default_state) {
                album.state = added_state;
                
                for (IBMediaItem *song in checkedSongsArray) {
                    if (song.state == default_state) {
                        [[IBCurrentParametersManager sharedManager].addedSongs addObject:song];
                    }
                }
                
                
            }
        }
    }else{
        [button setImage: [UIImage imageNamed:@"add_all.png"]forState:UIControlStateNormal];
        [button setIsSelected:YES];
        
        
        for (IBMediaItem *album in self.albums) {
            NSArray *songsArray = [[IBFileManager sharedManager] getAllSongsOfAlbum:album];
            NSArray *checkedSongsArray = [[IBFileManager sharedManager] checkSongMediaItems:songsArray];
            
            if (album.state == added_state) {
                album.state = default_state;
                
                for (IBMediaItem *song in checkedSongsArray) {
                    if (song.state == added_state) {
                        [[IBCurrentParametersManager sharedManager] removeSongFromArray:song];
                        song.state = default_state;

                    }
                }
                
                
            }
        }
    }
    }
    [self.tableView reloadData];
    
}













- (void) addToPlaylistAction:(IBPlayerItem*) button{
    
    CGPoint point = [button convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:point];
    
    
    IBMediaItem *album = [self.albums objectAtIndex:indexPath.row];
    NSArray *songs = [[IBFileManager sharedManager] getAllSongsOfAlbum:album];
    
    
    
    if (album.state == default_state) {
        
        [button setImage: [UIImage imageNamed:@"Added.png"]forState:UIControlStateNormal];
        album.state = added_state;
        
        [[IBCurrentParametersManager sharedManager].addedSongs addObjectsFromArray:songs];
        
    }else if (album.state == added_state){
        
        [button setImage: [UIImage imageNamed:@"add 64 x 64.png"]forState:UIControlStateNormal];
        
        NSUInteger location = [[IBCurrentParametersManager sharedManager].addedSongs count] - [songs count] ;
        [[IBCurrentParametersManager sharedManager].addedSongs removeObjectsInRange:NSMakeRange(location, [songs count])];
        album.state = default_state;
        
    }else if ( (album.state == inPlaylist_state) && ([[IBCurrentParametersManager sharedManager]coreDataChangingPlaylist])){
        
        [button setImage: [UIImage imageNamed:@"cancel-music(4).png"]forState:UIControlStateNormal];
       [[IBCurrentParametersManager sharedManager].removedSongs addObjectsFromArray:songs];
        album.state = delete_state;
        
        NSLog(@"added songs = %lu",(unsigned long)[[[IBCurrentParametersManager sharedManager]addedSongs]count]);
        
        
    }else if (album.state == delete_state){
        
        [button setImage: [UIImage imageNamed:@"inPlaylist.png"]forState:UIControlStateNormal];
        
        NSUInteger location = [[IBCurrentParametersManager sharedManager].removedSongs count] - [songs count] ;
        [[IBCurrentParametersManager sharedManager].removedSongs removeObjectsInRange:NSMakeRange(location, [songs count])];
        album.state = inPlaylist_state;
    }
    
}



@end
