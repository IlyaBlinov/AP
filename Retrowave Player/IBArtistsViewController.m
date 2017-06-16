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


static NSString* firstNames[] = {
    @"Tran", @"Lenore", @"Bud", @"Fredda", @"Katrice",
    @"Clyde", @"Hildegard", @"Vernell", @"Nellie", @"Rupert",
    @"Billie", @"Tamica", @"Crystle", @"Kandi", @"Caridad",
    @"Vanetta", @"Taylor", @"Pinkie", @"Ben", @"Rosanna",
    @"Eufemia", @"Britteny", @"Ramon", @"Jacque", @"Telma",
    @"Colton", @"Monte", @"Pam", @"Tracy", @"Tresa",
    @"Willard", @"Mireille", @"Roma", @"Elise", @"Trang",
    @"Ty", @"Pierre", @"Floyd", @"Savanna", @"Arvilla",
    @"Whitney", @"Denver", @"Norbert", @"Meghan", @"Tandra",
    @"Jenise", @"Brent", @"Elenor", @"Sha", @"Jessie"
};

static NSString* lastNames[] = {
    
    @"Farrah", @"Laviolette", @"Heal", @"Sechrest", @"Roots",
    @"Homan", @"Starns", @"Oldham", @"Yocum", @"Mancia",
    @"Prill", @"Lush", @"Piedra", @"Castenada", @"Warnock",
    @"Vanderlinden", @"Simms", @"Gilroy", @"Brann", @"Bodden",
    @"Lenz", @"Gildersleeve", @"Wimbish", @"Bello", @"Beachy",
    @"Jurado", @"William", @"Beaupre", @"Dyal", @"Doiron",
    @"Plourde", @"Bator", @"Krause", @"Odriscoll", @"Corby",
    @"Waltman", @"Michaud", @"Kobayashi", @"Sherrick", @"Woolfolk",
    @"Holladay", @"Hornback", @"Moler", @"Bowles", @"Libbey",
    @"Spano", @"Folson", @"Arguelles", @"Burke", @"Rook"
};




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
    
    
    MPMediaQuery *artistsQuery = [MPMediaQuery artistsQuery];
    
    NSArray *artistsArray = [artistsQuery items];
    
    self.artists = [self sortingItems:artistsArray ByProperty:MPMediaItemPropertyArtist] ;

    
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
    
    NSString *artistTitle = [artist valueForProperty:MPMediaItemPropertyArtist];
    
    
    MPMediaPropertyPredicate *artistNamePredicate =
    [MPMediaPropertyPredicate predicateWithValue: artistTitle
                                     forProperty: MPMediaItemPropertyArtist];
    
    
    MPMediaQuery *albumsOfArtist = [[MPMediaQuery alloc] init];
    
    [albumsOfArtist setGroupingType:MPMediaGroupingAlbum];
    [albumsOfArtist addFilterPredicate:artistNamePredicate];
    
    NSUInteger numberOfAlbums =  [[albumsOfArtist collections] count];

    
    MPMediaQuery *songsOfArtist = [[MPMediaQuery alloc] init];
    
    [songsOfArtist setGroupingType:MPMediaGroupingTitle];
    [songsOfArtist addFilterPredicate:artistNamePredicate];
    
    NSUInteger numberOfSongs = [[songsOfArtist collections] count];
    
    
    NSAttributedString *artistName = [[NSAttributedString alloc] initWithString:artistTitle];
    
    
    
    
    NSAttributedString *artistParameterSongs = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"Songs: %u",numberOfSongs]];
    
     NSAttributedString *artistParameterAlbums = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"Albums: %u",numberOfAlbums]];
    
    
    
    NSAttributedString *artistCount = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d", indexPath.row + 1]];
    
    cell.artistName.attributedText = artistName;
    cell.artistSongParameter.attributedText = artistParameterSongs;
    cell.artistAlbumParameter.attributedText = artistParameterAlbums;
    cell.artistCount.attributedText = artistCount;
    
    
    
    
    return cell;
    
}


#pragma mark - UITableViewDelegate


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    IBArtistInfoViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"IBArtistInfoViewController"];
   
    IBArtist *artist = [self.artists objectAtIndex:indexPath.row];
    
    [[IBCurrentParametersManager sharedManager] setArtist:artist];
    
    
    
    [self.navigationController pushViewController:vc animated:YES];
    
}



@end
