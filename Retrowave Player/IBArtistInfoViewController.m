//
//  IBArtistViewController.m
//  APlayer
//
//  Created by ilyablinov on 31.03.17.
//  Copyright (c) 2017 IB. All rights reserved.
//

#import "IBArtistInfoViewController.h"
#import "IBLabel.h"
#import "IBMainTabBarController.h"
#import "IBSongsViewController.h"
#import "IBAlbumsViewController.h"
#import "IBCurrentParametersManager.h"
#import "IBFileManager.h"
@interface IBArtistInfoViewController ()

@property (strong, nonatomic) NSDictionary *parameters;

@end

@implementation IBArtistInfoViewController




- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationItem setHidesBackButton:NO animated:NO];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
   
    
    MPMediaItem *artist = [[IBCurrentParametersManager sharedManager] artist];
    
    NSDictionary       *artistParameters = [[IBFileManager sharedManager] getArtistParams:artist];
    NSString *artistParameterSongs = [artistParameters objectForKey:@"numberOfSongs"];
    NSString *artistParameterAlbums = [artistParameters objectForKey:@"numberOfAlbums"];
    NSAttributedString *artistName = [artistParameters objectForKey:@"artistName"];
    
    self.navigationItem.titleView = [IBFontAttributes getCustomTitleForControllerName:[artistName string]];


    UIBarButtonItem *backItem =   [self setLeftBackBarButtonItem:@"Artists"];
    [self.navigationItem setLeftBarButtonItem:backItem];
    
    NSArray *keys    = [[NSArray alloc] initWithObjects:@"Songs", @"Albums", nil];
    NSArray *objects = [[NSArray alloc] initWithObjects:artistParameterSongs, artistParameterAlbums,nil];
    
    
     self.parameters = [[NSDictionary alloc] initWithObjects:objects forKeys:keys];
    
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
    return [self.parameters count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static  NSString *identifier = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                            reuseIdentifier:identifier];
    }
    
    NSString *parameterKey = [[self.parameters allKeys] objectAtIndex:indexPath.row];
    NSString *parameterNumber = [self.parameters valueForKey:parameterKey];
    
    NSMutableAttributedString *attributedParameter = [[NSMutableAttributedString alloc] initWithString:parameterKey];
    
    [attributedParameter setAttributes:[IBFontAttributes attributesOfDetailedTitle] range:NSMakeRange(0, [attributedParameter length])];
    
    [cell.textLabel setAttributedText:attributedParameter];
    
    
    NSMutableAttributedString *attributedNumberOfParameter = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", parameterNumber]];
    
    [attributedNumberOfParameter setAttributes:[IBFontAttributes attributesOfTimeDurationTitle] range:NSMakeRange(0, [attributedNumberOfParameter length])];
    
    [cell.detailTextLabel setAttributedText:attributedNumberOfParameter];
    
    
    return cell;
    
}


#pragma mark - UITableViewDelegate


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
      
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    
    if ([cell.textLabel.text isEqualToString:@"Songs"]) {
        
        [IBCurrentParametersManager sharedManager].songsViewType = artist;
        
        NSString *identifier = @"IBSongsViewController";
        IBSongsViewController *vcSongs = [self.storyboard instantiateViewControllerWithIdentifier:identifier];
        
        
       
         [self.navigationController pushViewController:vcSongs animated:YES];
        
        NSLog(@" pushViewController IBSongsViewController from IBArtistInfoViewController");
       
    }else if ([cell.textLabel.text isEqualToString:@"Albums"]) {
        
       
        IBAlbumsViewController *vcAlbum = [self.storyboard instantiateViewControllerWithIdentifier:@"IBAlbumsViewController"];
        
        
       
        [self.navigationController pushViewController:vcAlbum animated:YES];
        
         NSLog(@" pushViewController IBAlbumsViewController from IBArtistInfoViewController");
        
    }
        
    
        
    }
    






@end
