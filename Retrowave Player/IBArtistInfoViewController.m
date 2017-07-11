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
    
    [ self.tableView setEditing: [[IBCurrentParametersManager sharedManager] isEditing]];
    
    if ([[IBCurrentParametersManager sharedManager] isEditing]) {
        
        [self createChooseSongsItem];
        
        self.tableView.allowsSelectionDuringEditing = YES;
        
    }
    
    
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
    


#pragma mark - Actions


- (void) addToPlaylistAction:(IBPlayerItem*) button{
    
    CGPoint point = [button convertPoint:CGPointZero toView:self.tableView];
    
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:point];
    
    UITableViewCell *currentCell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    NSString *artistRequestParamater = currentCell.textLabel.text;
    
    MPMediaItem     *currentArtist = [[IBCurrentParametersManager sharedManager] artist];
   
    NSArray *songs = [[IBFileManager sharedManager] getSongsOfArtist:currentArtist withParameter:artistRequestParamater];
    
    
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
