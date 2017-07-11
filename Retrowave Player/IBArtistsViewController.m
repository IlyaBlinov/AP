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
#import "IBCurrentParametersManager.h"
#import "IBFileManager.h"





@interface IBArtistsViewController ()

@property (strong, nonatomic) NSArray *artists;
@end

@implementation IBArtistsViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
   
    [ self.tableView setEditing: [[IBCurrentParametersManager sharedManager] isEditing]];
    
    if ([[IBCurrentParametersManager sharedManager] isEditing]) {
        
        [self createChooseSongsItem];
        
        self.tableView.allowsSelectionDuringEditing = YES;
        
    }
    
    
    [self.navigationItem setHidesBackButton:NO animated:NO];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    
    NSString *title = @"All Media";
    
    UIBarButtonItem *backItem =   [self setLeftBackBarButtonItem:title];
    [self.navigationItem setLeftBarButtonItem:backItem];
    
    
    self.navigationItem.titleView = [IBFontAttributes getCustomTitleForControllerName:@"Artists"];
    
    
    self.artists = [[IBFileManager sharedManager] getArtists] ;

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
    
    MPMediaItem *artist = [self.artists objectAtIndex:indexPath.row];
    
    
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
    
    IBArtistInfoViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"IBArtistInfoViewController"];
   
    MPMediaItem *artist = [self.artists objectAtIndex:indexPath.row];
    
    [[IBCurrentParametersManager sharedManager] setArtist:artist];
    
    
    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark - Actions


- (void) addToPlaylistAction:(IBPlayerItem*) button{
    
    CGPoint point = [button convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:point];
    
   
    MPMediaItem     *currentArtist   = [self.artists objectAtIndex:indexPath.row];
    NSArray *songs = [[IBFileManager sharedManager] getAllSongsOfArtist:currentArtist];
    
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
    
    
    NSLog(@"added songs = %u",[[[IBCurrentParametersManager sharedManager]addedSongs]count]);
    
    
}


@end
