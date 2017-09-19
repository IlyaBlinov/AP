//
//  IBArtistsViewController.m
//  APlayer
//
//  Created by ilyablinov on 28.03.17.
//  Copyright (c) 2017 IB. All rights reserved.
//

#import "IBArtistsViewController.h"
#import "IBArtistInfoViewController.h"
#import "IBArtistTableViewCell.h"
#import "IBAllMediaViewController.h"






@interface IBArtistsViewController ()

@property (strong, nonatomic) NSArray *artists;
@end

@implementation IBArtistsViewController

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    if ([[IBCurrentParametersManager sharedManager] isEditing]) {
        
        self.navigationItem.rightBarButtonItem = [self createChooseSongsItem];
        self.tableView.allowsSelectionDuringEditing = YES;
        
        NSArray *artistsArray = [[IBFileManager sharedManager] getArtists];
        self.artists = [[IBFileManager sharedManager]checkArtistsMediaItems:artistsArray];
        
    }else{
        self.artists = [[IBFileManager sharedManager] getArtists] ;
    }
    NSLog(@"added songs count = %d",[[[IBCurrentParametersManager sharedManager]addedSongs]count]);
    [self.tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
   
    [ self.tableView setEditing: [[IBCurrentParametersManager sharedManager] isEditing]];
    
  
    
    [self.navigationItem setHidesBackButton:NO animated:NO];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    
    NSString *title = @"All Media";
    
    UIBarButtonItem *backItem =   [self setLeftBackBarButtonItem:title];
    [self.navigationItem setLeftBarButtonItem:backItem];
    
    
    self.navigationItem.titleView = [IBFontAttributes getCustomTitleForControllerName:@"Artists"];
    
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

    return [self.artists count];
}


- (IBArtistTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static  NSString *identifier = @"cell";
    
    IBArtistTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[IBArtistTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                              reuseIdentifier:identifier];
    }
    
    IBMediaItem *artist = [self.artists objectAtIndex:indexPath.row];
    
    
    NSDictionary       *artistParameters = [[IBFileManager sharedManager] getArtistParams:artist];
    
    NSAttributedString *artistParameterSongs = [[NSAttributedString alloc] initWithString:
                                                [NSString stringWithFormat:@"Songs: %@",
                                                 [artistParameters objectForKey:@"numberOfSongs"]]];
    
    NSAttributedString *artistParameterAlbums = [[NSAttributedString alloc] initWithString:
                                                 [NSString stringWithFormat:@"Albums: %@",
                                                  [artistParameters objectForKey:@"numberOfAlbums"]]];
    
    NSAttributedString *artistName = [artistParameters objectForKey:@"artistName"];
    
    NSAttributedString *artistCount = [[NSAttributedString alloc] initWithString:
                                                [NSString stringWithFormat:@"%d", indexPath.row + 1]];
    
    cell.artistName.attributedText = artistName;
    cell.artistSongParameter.attributedText = artistParameterSongs;
    cell.artistAlbumParameter.attributedText = artistParameterAlbums;
    cell.artistCount.attributedText = artistCount;
    
  
    IBPlayerItem  *addButton = [[IBPlayerItem alloc]initWithItemState:artist.state];
    [addButton addTarget:self action:@selector(addToPlaylistAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell setEditingView:addButton];

    
    
    return cell;
}


#pragma mark - UITableViewDelegate


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    IBArtistInfoViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"IBArtistInfoViewController"];
   
    IBMediaItem *artist = [self.artists objectAtIndex:indexPath.row];
    
    
    
    [[IBCurrentParametersManager sharedManager] setArtist:artist];
    
    
    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark - Actions


- (void) addToPlaylistAction:(IBPlayerItem*) button{
    
    CGPoint point = [button convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:point];
    
   
    IBMediaItem     *artist   = [self.artists objectAtIndex:indexPath.row];
    NSArray *songs = [[IBFileManager sharedManager] getAllSongsOfArtist:artist];
    
    
    
    
    
    if (artist.state == default_state) {
        
        [button setImage: [UIImage imageNamed:@"Added.png"]forState:UIControlStateNormal];
        artist.state = added_state;
        
        [[IBCurrentParametersManager sharedManager].addedSongs addObjectsFromArray:songs];
        
    }else if (artist.state == added_state){
        
        [button setImage: [UIImage imageNamed:@"add 64 x 64.png"]forState:UIControlStateNormal];
        
        NSUInteger location = [[IBCurrentParametersManager sharedManager].addedSongs count] - [songs count] ;
        [[IBCurrentParametersManager sharedManager].addedSongs removeObjectsInRange:NSMakeRange(location, [songs count])];
        artist.state = default_state;
        
    }else if ( (artist.state == inPlaylist_state) && ([[IBCurrentParametersManager sharedManager]coreDataChangingPlaylist])){
        
        [button setImage: [UIImage imageNamed:@"cancel-music(4).png"]forState:UIControlStateNormal];
        [button setIsSelected:NO];
        [[IBCurrentParametersManager sharedManager].removedSongs addObjectsFromArray:songs];
        artist.state = delete_state;
        
        NSLog(@"added songs = %lu",(unsigned long)[[[IBCurrentParametersManager sharedManager]addedSongs]count]);
        
        
    }else if (artist.state == delete_state){
        
        [button setImage: [UIImage imageNamed:@"inPlaylist.png"]forState:UIControlStateNormal];
        NSUInteger location = [[IBCurrentParametersManager sharedManager].removedSongs count] - [songs count] ;
        [[IBCurrentParametersManager sharedManager].removedSongs removeObjectsInRange:NSMakeRange(location, [songs count])];
        artist.state = inPlaylist_state;
    }

    
    
}


@end
