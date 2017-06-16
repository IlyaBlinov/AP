//
//  IBAlbumsViewController.m
//  APlayer
//
//  Created by ilyablinov on 01.04.17.
//  Copyright (c) 2017 IB. All rights reserved.
//

#import "IBAlbumsViewController.h"
#import "IBAlbum.h"
#import "IBAlbumViewCell.h"
#import "IBArtistInfoViewController.h"
#import "IBSongsViewController.h"
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




@interface IBAlbumsViewController ()

@property (strong, nonatomic) NSArray *albums;
@property (strong, nonatomic) UIImageView *arrowView;
@property (strong, nonatomic) NSString *backItemTitle;
@end

@implementation IBAlbumsViewController



- (void)viewDidLoad
{
    
    
    [super viewDidLoad];
    
    
    [self.navigationItem setHidesBackButton:NO animated:NO];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    NSString *title;
    NSArray *albums;
    
    if ([IBCurrentParametersManager sharedManager].songsViewControllerDataViewMode == artist) {
        
        MPMediaItem *artist = [[IBCurrentParametersManager sharedManager] artist];
                            
        NSString *artistName = [artist valueForProperty:MPMediaItemPropertyArtist];
        title = artistName;
        
        MPMediaPropertyPredicate *artistNamePredicate =
        [MPMediaPropertyPredicate predicateWithValue: artistName
                                         forProperty: MPMediaItemPropertyArtist];
        
        MPMediaQuery *albumsOfArtist = [[MPMediaQuery alloc] init];
        [albumsOfArtist setGroupingType:MPMediaGroupingAlbum];
        
        [albumsOfArtist addFilterPredicate:artistNamePredicate];
        
        NSMutableArray *albumsItemsArray = [NSMutableArray array];
        
        for (MPMediaItemCollection *album in [albumsOfArtist collections]) {
            MPMediaItem *albumItem = [album representativeItem];
            [albumsItemsArray addObject:albumItem];
        
        }
         albums = [[NSArray alloc] initWithArray:albumsItemsArray];

        
        
       }else{
        title = @"All Media";
        MPMediaQuery *albumsQuery = [MPMediaQuery albumsQuery];
        albums = [albumsQuery items];

    }

    UIBarButtonItem *backItem =   [self setLeftBackBarButtonItem:title];
    [self.navigationItem setLeftBarButtonItem:backItem];
    
    self.navigationItem.titleView = [IBFontAttributes getCustomTitleForControllerName:@"Albums"];
    
    self.albums = [NSArray arrayWithArray:[self sortingItems:albums ByProperty:MPMediaItemPropertyAlbumTitle]];
    
    
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
        
    
    
    NSAttributedString *albumName = [[NSAttributedString alloc] initWithString:albumTitle];
    NSAttributedString *artistName = [[NSAttributedString alloc] initWithString:albumArtistTitle];
    
    

    cell.albumImage.image = albumImage;
    cell.albumTitle.attributedText   = albumName;
    cell.artistTitle.attributedText  = artistName;
    //[cell.albumImage.layer setBackgroundColor:[UIColor magentaColor].CGColor];
    
    
    
    return cell;
    
}




#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MPMediaItem *currentAlbum = [self.albums objectAtIndex:indexPath.row];
    
    [IBCurrentParametersManager sharedManager].songsViewControllerDataViewMode = album;
    [[IBCurrentParametersManager sharedManager] setAlbum:currentAlbum];
    
    NSString *identifier = @"IBSongsViewController";
    
    if ([[IBCurrentParametersManager sharedManager] isEditing]) {
        identifier = @"IBSongsChooseViewController";
    }

    IBSongsViewController *vcSongs = [self.storyboard instantiateViewControllerWithIdentifier:identifier];
    
        [self.navigationController pushViewController:vcSongs animated:YES];
        
    }







@end
