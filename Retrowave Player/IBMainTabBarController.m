//
//  IBMainTabBarController.m
//  APlayer
//
//  Created by ilyablinov on 02.03.17.
//  Copyright (c) 2017 IB. All rights reserved.
//

#import "IBMainTabBarController.h"
#import "IBFontAttributes.h"
#import "IBAnimationManager.h"
#import "IBVisualizerMusic.h"
#import "IBSongsViewController.h"
#import "IBCurrentParametersManager.h"
#import "IBSongsChooseViewController.h"

@interface IBMainTabBarController ()<UITabBarDelegate, UITabBarControllerDelegate>

@property (strong, nonatomic) NSDictionary *attributesofSelectedItem;
@property (strong, nonatomic) NSDictionary *attributesofNotSelectedItem;
@property (strong, nonatomic) UITabBarItem *currentItem;
@property (strong, nonatomic) NSMutableArray *sublayersArray;


@end

@implementation IBMainTabBarController



- (void)loadView{
    
    [super loadView];
    
    [IBCurrentParametersManager sharedManager].songsViewControllerDataViewMode = allSongs;
    
    [self.tabBar layoutSubviews];
    
    NSLog(@"subviews count = %u",[[self.tabBar subviews] count]);
    
    UIView *playerItemView = [[self.tabBar subviews] objectAtIndex:3];
    
    UITabBarItem *allMediaItem = [[self.tabBar items] objectAtIndex:0];
    allMediaItem.image = [UIImage imageNamed:@"music-folder.png"];
    allMediaItem.titlePositionAdjustment = UIOffsetMake(0, 4);
    
    UITabBarItem *songsItem = [[self.tabBar items] objectAtIndex:1];
    songsItem.image = [UIImage imageNamed:@"music-playlist30x30.png"];
    songsItem.titlePositionAdjustment = UIOffsetMake(0, 4);
    
    UITabBarItem *playlistsItem = [[self.tabBar items] objectAtIndex:3];
    playlistsItem.image = [UIImage imageNamed:@"songs-list30x30.png"];
    playlistsItem.titlePositionAdjustment = UIOffsetMake(0, 4);
    
    UITabBarItem *audioBooksItem = [[self.tabBar items] objectAtIndex:4];
    audioBooksItem.image = [UIImage imageNamed:@"cassette-tape30x30.png"];
    audioBooksItem.titlePositionAdjustment = UIOffsetMake(0, 4);


    
    
    
    
    self.navigationItem.titleView = [IBFontAttributes getCustomTitleForControllerName:@"Songs"];
    
    
    
//    IBVisualizerMusic *visualizer = [[IBVisualizerMusic alloc] initWithFrame:playerItemView.frame];
    IBVisualizerMusic *visualizer = [[IBVisualizerMusic alloc] initWithFrameKenwoodFRC:playerItemView.frame];

        visualizer.isStarted = NO;
    [self.tabBar.viewForFirstBaselineLayout addSubview:visualizer];
    self.visualizer = visualizer;
    
    
    
    self.delegate = self;
  
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    NSDictionary *attributesOfSelectedItem = [IBFontAttributes attributesOfTabBarTitlesWithState:selected];
    
    NSDictionary *attributesOfNotSelectedItem = [IBFontAttributes attributesOfTabBarTitlesWithState:notSelected];
    
    self.attributesofSelectedItem = attributesOfSelectedItem;
    self.attributesofNotSelectedItem = attributesOfNotSelectedItem;
    
 
   
    
    
    for (UITabBarItem *item in self.tabBar.items) {
        
        [item setTitleTextAttributes:attributesOfNotSelectedItem forState:UIControlStateNormal];
        
        if ([item.title isEqualToString:@""]) {
            
            self.currentItem = item;
        }
  
        
    }
    self.selectedIndex = 0;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) setSelectedIndex:(NSUInteger)selectedIndex{
    
    UITabBarItem *item = [[self.tabBar items] objectAtIndex:selectedIndex];
   
    [self setAttributesForItem:item];
    
    
    
    
 [super setSelectedIndex:selectedIndex];
    
    
    
}

#pragma mark - UITabBarDelegate


- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    
    
    [self setAttributesForItem:item];
    
  }
#pragma mark - UITabBarItemsActions

- (void) setAttributesForItem:(UITabBarItem*)item{
    if (![item.title isEqualToString:@""]) {
        [self.currentItem setTitleTextAttributes:self.attributesofNotSelectedItem forState:UIControlStateNormal];
        
        [item setTitleTextAttributes:self.attributesofSelectedItem forState:UIControlStateSelected];
        self.currentItem = item;
    }
    
    self.currentItem = item;

}

- (void) hidesNavigationBarForTabBarItem:(UITabBarItem*) item{
    
    
    if ([item.title isEqualToString:@"Songs"]) {
        
        UINavigationController *nav = [self.viewControllers objectAtIndex:1];
        
        [ nav setNavigationBarHidden:YES];
        
    }

    
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UINavigationController *)viewController{
    
    if ([viewController.tabBarItem.title isEqualToString:@"Songs"]  | [viewController.tabBarItem.title isEqualToString:@"Books"]) {
       
//        [self.navigationController setNavigationBarHidden:YES];
//        [self.navigationItem setHidesBackButton:YES animated:NO];
        
    }else if([viewController.tabBarItem.title isEqualToString:@"Playlists"]){
        [viewController setNavigationBarHidden:NO];
    }else{
        [self.navigationItem setHidesBackButton:NO animated:NO];
        [self.navigationController setNavigationBarHidden:NO animated:NO];

    }
    
}









@end
