//
//  IBSongsChooseViewController.m
//  Retrowave Player
//
//  Created by eastwood on 22/05/2017.
//  Copyright © 2017 Илья Блинов. All rights reserved.
//

#import "IBSongsChooseViewController.h"

#import "IBSong.h"
#import "IBSongCellTableViewCell.h"
#import "IBArtistInfoViewController.h"
#import "IBAllMediaViewController.h"
#import "IBPlayerController.h"
#import "IBVisualizerMusic.h"
#import "IBPlayerItem.h"
#import "IBCurrentParametersManager.h"
#import "IBSongsAddViewController.h"




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




@interface IBSongsChooseViewController ()


@property (strong, nonatomic) NSString *backItemTitle;

@end

@implementation IBSongsChooseViewController

- (void)viewWillAppear:(BOOL)animated{
    
     [super viewWillAppear:animated];
    
    
    NSString *title;
    
    IBPlaylist *currentPlaylist = [[IBCurrentParametersManager sharedManager] playlist];
    MPMediaItem   *currentArtist = [[IBCurrentParametersManager sharedManager] artist];
    MPMediaItem   *currentAlbum = [[IBCurrentParametersManager sharedManager] album];
    
    
    
    
    if ([IBCurrentParametersManager sharedManager].songsViewControllerDataViewMode == allSongs) {
        title = @"All Media";
    }else if (([IBCurrentParametersManager sharedManager].songsViewControllerDataViewMode == album)){
        NSString *albumName = [currentAlbum valueForProperty:MPMediaItemPropertyAlbumTitle];
        title = albumName;
    }else if (([IBCurrentParametersManager sharedManager].songsViewControllerDataViewMode == artist)){
        NSString *artistName = [currentArtist valueForProperty:MPMediaItemPropertyArtist];
        title = artistName;
    }else if (([IBCurrentParametersManager sharedManager].songsViewControllerDataViewMode == playlist)){
        title = currentPlaylist.playlistName;
    }
    
  
    
    
    UIBarButtonItem *backItem =   [self setLeftBackBarButtonItem:title];
    [self.navigationItem setLeftBarButtonItem:backItem];
    self.navigationItem.titleView = [IBFontAttributes getCustomTitleForControllerName:@"Songs"];
    
    
    if ([[IBCurrentParametersManager sharedManager] isEditing]) {
        
        [self.navigationController setNavigationBarHidden:NO];
        
        if ([self.navigationController.tabBarItem.title isEqualToString:@"Songs"]) {
            [self.navigationItem setLeftBarButtonItem:nil];        }
    }
    else{
        [self.navigationController setNavigationBarHidden:YES];
        [self.navigationItem setHidesBackButton:YES animated:NO];
    }
    

  
    [self.tableView reloadData];
    
    
}




- (void)viewDidLoad
{
    [super viewDidLoad];
    
        
    
    NSMutableArray *songsArray = [NSMutableArray array];
    
    
        for (int i = 0; i < 12; i++) {
            IBSong *song = [[IBSong alloc] init];
            song.songName = firstNames[arc4random() % 50];
            song.artistName = [NSString stringWithFormat:@"%@ %@", firstNames[arc4random() % 50], lastNames[arc4random() % 50]];
            song.duration = arc4random() % 50;
            
            [songsArray addObject:song];
            
        }
        
        self.songs = songsArray;
    
    
    
    [self.tableView setEditing:YES];
    
    
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
    
    
    return [self.songs count];
}


- (IBSongCellTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static  NSString *identifier = @"cell";
    
    IBSongCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[IBSongCellTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                              reuseIdentifier:identifier];
    }
    
    IBSong *song = [self.songs objectAtIndex:indexPath.row];
    
    
    NSAttributedString *songName = [[NSAttributedString alloc] initWithString:song.songName];
    
    NSAttributedString *artistName = [[NSAttributedString alloc] initWithString:song.artistName];
    
    NSAttributedString *timeDuration = [[NSAttributedString alloc] initWithString:@"5:09"];
    
    NSAttributedString *songCount = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d", indexPath.row + 1]];
    
    cell.songTitle.attributedText    = songName;
    cell.artistTitle.attributedText  = artistName;
    cell.timeDuration.attributedText = timeDuration;
    cell.songCount.attributedText    = songCount;
    
    
    
    if ([[IBCurrentParametersManager sharedManager] isEditing]) {
        
    IBPlayerItem *addToPlaylistButton = [[IBPlayerItem alloc] initWithFrame:CGRectMake(0,0, 20, 20)];
    
    [addToPlaylistButton addTarget:self action:@selector(addToPlaylistAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [addToPlaylistButton setImage: [UIImage imageNamed:@"add 64 x 64.png"]forState:UIControlStateNormal];
    
    cell.editingAccessoryView = addToPlaylistButton;
    
    }else{
        cell.editingAccessoryView = nil;
    }
    return cell;
    
}


#pragma mark - UITableViewDelegate



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    IBSong *song = [self.songs objectAtIndex:indexPath.row];
    
    
    IBPlayerController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"IBPlayerController"];
    
    [vc setSong:song];
    [vc.playPauseButton setSelected: YES];
    
    [self.navigationController pushViewController:vc animated:YES];
    
    
    
    
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    return UITableViewCellEditingStyleNone;
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath{
    return NO;
}


#pragma mark - UITableViewDataSource

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return YES;
    
}


#pragma mark - Actions

- (void) addToPlaylistAction:(IBPlayerItem*) button{
    
    
    CGPoint point = [button convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:point];
    
    IBSong *song = [self.songs objectAtIndex:indexPath.row];
    
    if (button.isSelected == NO) {
        [button setImage: [UIImage imageNamed:@"Added.png"]forState:UIControlStateSelected];
        [button setIsSelected:YES];
        [[IBCurrentParametersManager sharedManager].addedSongs addObject:song];
    }else{
        [button setImage: [UIImage imageNamed:@"add 64 x 64.png"]forState:UIControlStateNormal];
        [button setIsSelected:NO];
        [[IBCurrentParametersManager sharedManager].addedSongs removeObject:song];
    }
    
    
    NSLog(@"added songs = %u",[[[IBCurrentParametersManager sharedManager]addedSongs]count]);
    
    
}

- (IBAction)chooseSongs:(IBPlayerItem *) button{
        
        [IBCurrentParametersManager sharedManager].songsViewControllerDataViewMode = playlist;
    
        IBSongsViewController *vc = [[IBCurrentParametersManager sharedManager] returnSongsViewController];
        [self.navigationController popToViewController:vc animated:YES];
   
}





@end
