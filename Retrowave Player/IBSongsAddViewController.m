//
//  IBSongsAddViewController.m
//  Retrowave Player
//
//  Created by eastwood on 22/05/2017.
//  Copyright © 2017 Илья Блинов. All rights reserved.
//

#import "IBSongsAddViewController.h"
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




@interface IBSongsAddViewController ()<UINavigationControllerDelegate>


@property (strong, nonatomic) NSString *backItemTitle;

@end

@implementation IBSongsAddViewController






- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    NSString *title;
    
    IBPlaylist *currentPlaylist = [[IBCurrentParametersManager sharedManager] playlist];
   
    title = currentPlaylist.playlistName;
    
    
    UIBarButtonItem *backItem =   [self setLeftBackBarButtonItem:title];
    [self.navigationItem setLeftBarButtonItem:backItem];
    
    self.navigationItem.titleView = [IBFontAttributes getCustomTitleForControllerName:@"Songs"];
    
    
    
    
    
    NSMutableArray *songsArray = [NSMutableArray array];
    
    
    if ((currentPlaylist) && ([currentPlaylist.songs count] == 0)) {
        
    }else{
        
        for (int i = 0; i < 12; i++) {
            IBSong *song = [[IBSong alloc] init];
            song.songName = firstNames[arc4random() % 50];
            song.artistName = [NSString stringWithFormat:@"%@ %@", firstNames[arc4random() % 50], lastNames[arc4random() % 50]];
            song.duration = arc4random() % 50;
            
            [songsArray addObject:song];
            
        }
        
        self.songs = songsArray;
    }
    
     self.navigationController.delegate = self;
    
    
    
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
    
    NSAttributedString *songCount = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld", indexPath.row + 1]];
    
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


- (IBAction)addNewSongs:(IBPlayerItem *) button{
    
        [[IBCurrentParametersManager sharedManager] setIsEditing:YES];//playlist was saved to IBCurrentParametersManager in IBPlaylistsController
    
    [[IBCurrentParametersManager sharedManager] setReturnSongsViewController:self];
    
        IBAllMediaViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"IBAllMediaViewController"];
        
        self.navigationController.delegate = self;
        
        [self.navigationController pushViewController:vc animated:YES];
     
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(IBSongsAddViewController *)viewController animated:(BOOL)animated{
    
    
    
    if ([viewController isKindOfClass:[IBSongsAddViewController class]] && ([[IBCurrentParametersManager sharedManager] isEditing])) {
       
        [[IBCurrentParametersManager sharedManager] setIsEditing:NO];
        
        self.navigationController.delegate = nil;
        
        
        NSMutableArray *tempArray = [NSMutableArray arrayWithArray:[[IBCurrentParametersManager sharedManager] addedSongs]];
        
        [tempArray addObjectsFromArray:self.songs];
        self.songs = nil;
        self.songs = [NSArray arrayWithArray:tempArray];

        [[IBCurrentParametersManager sharedManager].addedSongs removeAllObjects];
        
        
        [self.tableView reloadData];
        
        
    }
    
    
}
@end
