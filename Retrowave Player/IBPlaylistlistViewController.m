//
//  IBPlaylistlistViewController.m
//  Retrowave Player
//
//  Created by Илья Блинов on 29.04.17.
//  Copyright © 2017 Илья Блинов. All rights reserved.
//

#import "IBPlaylistlistViewController.h"
#import "IBPlaylistCell.h"
#import "IBPlaylist.h"
#import "IBSong.h"
#import "IBSongsAddViewController.h"
#import "IBAllMediaViewController.h"
#import "IBAddPlaylistViewController.h"
#import "IBTransitionViewController.h"
#import "IBTransitionDismissViewController.h"
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



@interface IBPlaylistlistViewController ()<UIViewControllerTransitioningDelegate>
@property (strong, nonatomic) NSArray *playlists;
@property (strong, nonatomic) NSString *backItemTitle;
@property (strong, nonatomic) IBTransitionViewController *animator;
@property (strong, nonatomic) IBTransitionDismissViewController *dismissAnimator;

@end

@implementation IBPlaylistlistViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    NSInteger number = [self.navigationController.viewControllers count] - 2;
    
    if (number >= 0) {
        if ([[self.navigationController.viewControllers objectAtIndex:number] isKindOfClass:[IBAllMediaViewController class]]) {
            NSString *title = @"All Media";
            UIBarButtonItem *backItem =   [self setLeftBackBarButtonItem:title];
            [self.navigationItem setLeftBarButtonItem:backItem];
            
        }

    }
    
    
   
    
    self.navigationItem.titleView = [IBFontAttributes getCustomTitleForControllerName:@"Playlists"];
        
    MPMediaQuery *playlistQuery = [MPMediaQuery playlistsQuery];
    NSArray *playlistArray = [playlistQuery collections];
    
   
    
    self.playlists = playlistArray;
    
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
    
    
    return [self.playlists count];
}


- (IBPlaylistCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static  NSString *identifier = @"cell";
    
    IBPlaylistCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[IBPlaylistCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                              reuseIdentifier:identifier];
    }
    
    MPMediaPlaylist *playlist = [self.playlists objectAtIndex:indexPath.row];
    
    NSString *playlistName = [playlist valueForProperty:MPMediaPlaylistPropertyName];
    
    if ((playlist != nil) && (playlistName != nil) && (![playlistName isEqualToString:@""])){
        
    
    
    NSAttributedString *playlistTitle = [[NSAttributedString alloc] initWithString:playlistName];
    
    NSAttributedString *songCount = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d",[playlist.items count]]];
    
    
    IBPlayerItem *accessoryButton = [[IBPlayerItem alloc] initWithFrame:CGRectMake(0,0, 20, 20)];
     [accessoryButton setImage: [UIImage imageNamed:@"skip-track.png"]forState:UIControlStateNormal];
    
    cell.playlistTitle.attributedText    = playlistTitle;
    cell.songCount.attributedText        = songCount;
    cell.accessoryView = accessoryButton;
    }
  
    return cell;
    
}


#pragma mark - UITableViewDelegate



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    MPMediaPlaylist *currentPlaylist = [self.playlists objectAtIndex:indexPath.row];
    
    [IBCurrentParametersManager sharedManager].songsViewControllerDataViewMode = playlist;
    
    NSString *identifier = @"IBSongsAddViewController";
    
    if ([[IBCurrentParametersManager sharedManager] isEditing]) {
        identifier = @"IBSongsChooseViewController";
    }

    
    IBSongsViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:identifier];
    
    
    [[IBCurrentParametersManager sharedManager] setPlaylist:currentPlaylist];
    
    
    
    [self.navigationController pushViewController:vc animated:YES];
    
 
}


#pragma mark - Actions


- (IBAction)addNewPlaylist:(UIButton*) button{
 
    IBAddPlaylistViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"IBAddPlaylistViewController"];
    
   
    vc.modalPresentationStyle = UIModalPresentationFormSheet;
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
    
    
   [nav setModalPresentationStyle:UIModalPresentationCustom];
    nav.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
   
    
    nav.transitioningDelegate = self;
    
    [self presentViewController:nav animated:YES
                     completion:^{
                         NSLog(@"modal viewcontroller is created");
                     }];
        
    
    
}


#pragma mark - UIViewControllerTransitioningDelegate

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(IBAddPlaylistViewController *)presenting sourceController:(UIViewController *)source {
    
    self.animator = [[IBTransitionViewController alloc] init];
    
    return self.animator;
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UINavigationController *)dismissed{
    self.dismissAnimator = [[IBTransitionDismissViewController alloc] init];
    
   
    IBAddPlaylistViewController *vc =(IBAddPlaylistViewController*) [dismissed topViewController];
    
    
    if (![vc.playlistName.text isEqualToString: @""]) {
        NSString *newPlaylistName = [[vc playlistName]text];
        
        IBPlaylist *newPlaylist = [[IBPlaylist alloc] init];
        newPlaylist.playlistName = newPlaylistName;
        newPlaylist.songs = [NSArray array];
        
        
        
        
        NSMutableArray *tempArray = [NSMutableArray arrayWithArray:self.playlists];
        
        [tempArray addObject:newPlaylist];
        
        self.playlists = nil;
        self.playlists = tempArray;
        [self.tableView reloadData]; 
    }
    
    
    
    return self.dismissAnimator;
}





@end
