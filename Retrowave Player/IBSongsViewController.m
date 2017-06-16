//
//  IBSongsViewController.m
//  APlayer
//
//  Created by ilyablinov on 28.02.17.
//  Copyright (c) 2017 IB. All rights reserved.
//

#import "IBSongsViewController.h"
#import "IBSong.h"
#import "IBSongCellTableViewCell.h"
#import "IBArtistInfoViewController.h"
#import "IBAllMediaViewController.h"
#import "IBPlayerController.h"
#import "IBVisualizerMusic.h"
#import "IBPlayerItem.h"
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




@interface IBSongsViewController ()

@property (strong, nonatomic) NSString *backItemTitle;
@property (strong, nonatomic) NSTimer *timer;
@end

@implementation IBSongsViewController






- (void)viewDidLoad
{
    [super viewDidLoad];
      
    NSInteger status = [MPMediaLibrary authorizationStatus];
    
    if (status != MPMediaLibraryAuthorizationStatusAuthorized ) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(checkStatus) userInfo:nil repeats:YES];
    }
   
    
    
    
    IBPlaylist *currentPlaylist = [[IBCurrentParametersManager sharedManager] playlist];
    MPMediaItem   *currentArtist = [[IBCurrentParametersManager sharedManager] artist];
    MPMediaItem *currentAlbum = [[IBCurrentParametersManager sharedManager] album];
    
    
    
   
    
     NSString *title;
     NSArray *songs;
    
    if ([IBCurrentParametersManager sharedManager].songsViewControllerDataViewMode == allSongs ) {
        title = @"All Media";
        
        MPMediaQuery *songsQuery = [MPMediaQuery songsQuery];
        songs = [songsQuery items];
       

    }else if ([IBCurrentParametersManager sharedManager].songsViewControllerDataViewMode == album){
        title = [currentAlbum valueForProperty:MPMediaItemPropertyAlbumTitle];
        
        MPMediaPropertyPredicate *albumNamePredicate =
        [MPMediaPropertyPredicate predicateWithValue: title
                                         forProperty: MPMediaItemPropertyAlbumTitle];
        
        MPMediaQuery *songsOfAlbum = [[MPMediaQuery alloc] init];
        [songsOfAlbum addFilterPredicate:albumNamePredicate];
        
        
        songs = [songsOfAlbum items];
        
        
    }else if ([IBCurrentParametersManager sharedManager].songsViewControllerDataViewMode == artist){
        
        NSString *artistName = [currentArtist valueForProperty:MPMediaItemPropertyArtist];
        title = artistName;
        
        MPMediaPropertyPredicate *artistNamePredicate =
        [MPMediaPropertyPredicate predicateWithValue: title
                                         forProperty: MPMediaItemPropertyArtist];
        
        MPMediaQuery *songsOfArtist = [[MPMediaQuery alloc] init];
        [songsOfArtist addFilterPredicate:artistNamePredicate];
        
        
        songs = [songsOfArtist items];

        
    }else if ([IBCurrentParametersManager sharedManager].songsViewControllerDataViewMode == playlist){
        title = currentPlaylist.playlistName;
    }
    
    
    
    
    UIBarButtonItem *backItem =   [self setLeftBackBarButtonItem:title];
    [self.navigationItem setLeftBarButtonItem:backItem];

    self.navigationItem.titleView = [IBFontAttributes getCustomTitleForControllerName:@"Songs"];
    
    self.songs = [NSArray arrayWithArray:songs];
    
    
    
    
    if ((currentPlaylist) && ([currentPlaylist.songs count] == 0)) {
        self.songs = nil;
    }

    
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
    
    MPMediaItem *song = [self.songs objectAtIndex:indexPath.row];
    
    NSString *songTitle = [song valueForProperty:MPMediaItemPropertyTitle];
    NSString *artistTitle = [song valueForProperty:MPMediaItemPropertyArtist];
    NSNumber *playBackDuration = [song valueForProperty:MPMediaItemPropertyPlaybackDuration];
    
    double songDuration = [playBackDuration doubleValue] / 60;
    NSString *songDurationTitle = [NSString stringWithFormat:@"%5.2f",songDuration];
    
    if (songTitle == nil) {
        songTitle  = @"";
    }else if (artistTitle == nil){
        artistTitle = @"";
    }else if (songDurationTitle == nil){
        songDurationTitle = @"";
    }
    
    
    NSAttributedString *songName = [[NSAttributedString alloc] initWithString:songTitle];
    NSAttributedString *artistName = [[NSAttributedString alloc] initWithString:artistTitle];
    NSAttributedString *timeDuration = [[NSAttributedString alloc] initWithString:songDurationTitle];
    NSAttributedString *songCount = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d", indexPath.row + 1]];
    
    
    cell.songTitle.attributedText    = songName;
    cell.artistTitle.attributedText  = artistName;
    cell.timeDuration.attributedText = timeDuration;
    cell.songCount.attributedText    = songCount;
    
   
    
    
    
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




- (void) checkStatus{
    __weak IBSongsViewController *weakSelf = self;
    
    
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
