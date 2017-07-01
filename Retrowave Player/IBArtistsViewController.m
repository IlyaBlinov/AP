//
//  IBArtistsViewController.m
//  APlayer
//
//  Created by ilyablinov on 28.03.17.
//  Copyright (c) 2017 IB. All rights reserved.
//

#import "IBArtistsViewController.h"
#import "IBArtistInfoViewController.h"
#import "IBArtist.h"
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
    
  
    return cell;
}


#pragma mark - UITableViewDelegate


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    IBArtistInfoViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"IBArtistInfoViewController"];
   
    MPMediaItem *artist = [self.artists objectAtIndex:indexPath.row];
    
    [[IBCurrentParametersManager sharedManager] setArtist:artist];
    
    
    
    [self.navigationController pushViewController:vc animated:YES];
    
}



@end
