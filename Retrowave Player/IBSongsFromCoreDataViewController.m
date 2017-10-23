//
//  IBSongsFromCoreDataViewController.m
//  Retrowave Player
//
//  Created by eastwood on 17/07/2017.
//  Copyright © 2017 Илья Блинов. All rights reserved.
//

#import "IBSongsFromCoreDataViewController.h"
#import "IBSongCellTableViewCell.h"
#import "IBCoreDataManager.h"
@interface IBSongsFromCoreDataViewController ()
@property (strong, nonatomic) IBPlaylist *currentPlaylist;
@property (strong, nonatomic) NSArray *songs;
@end

@implementation IBSongsFromCoreDataViewController
//@synthesize fetchedResultsController = _fetchedResultsController;


- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    NSArray *songs = [[IBFileManager sharedManager] getIBMediaItemsFromCoreDataPlaylist:self.currentPlaylist];
    self.songs = [[IBFileManager sharedManager] checkSongMediaItems:songs];

    
    [ self.tableView setEditing: [[IBCurrentParametersManager sharedManager] isEditing]];
    
    if ([[IBCurrentParametersManager sharedManager] isEditing]) {
        
        IBBarButtonItem *chooseBarButton = [self createChooseSongsItem];
        
        NSArray *statesOfSongs = [self.songs valueForKeyPath:@"@distinctUnionOfObjects.state"];
        
        ItemState state = [[statesOfSongs firstObject] unsignedIntegerValue];
        
        ButtonStyle style = add_all;
        if (([statesOfSongs count] == 1) && (state == added_state)) {
            style = remove_all;
        }
        
        IBPlayerItem *addAllSongs = [[IBPlayerItem alloc] initWithButtonStyle:style];
        if (style == add_all) {
            [addAllSongs setIsSelected:YES];
        }else{
            [addAllSongs setIsSelected:NO];
        }
        [addAllSongs addTarget:self action:@selector(addAllSongs:) forControlEvents:UIControlEventTouchUpInside];
        IBBarButtonItem *addAllSongsBarButton = [[IBBarButtonItem alloc] initWithButton:addAllSongs];
 
        self.navigationItem.rightBarButtonItems = @[chooseBarButton,addAllSongsBarButton];
        
    }else{
        
        
        IBPlayerItem *addToPlaylistButton = [[IBPlayerItem alloc] initWithButtonStyle:add];
        [addToPlaylistButton addTarget:self action:@selector(addNewSongs) forControlEvents:UIControlEventTouchUpInside];
        
        IBBarButtonItem *addToPlaylistItem = [[IBBarButtonItem alloc] initWithButton:addToPlaylistButton];
        
        self.navigationItem.rightBarButtonItem = addToPlaylistItem;
        
    }
    
        
    if ([self isEqual:[[IBCurrentParametersManager sharedManager]returnSongsViewController]]) {
        
        self.currentPlaylist = nil;
        self.songs = nil;
        IBPlaylist *currentPlaylist = [[IBCurrentParametersManager sharedManager] coreDataChangingPlaylist];
       
       
        NSArray *songs = [[IBFileManager sharedManager] getIBMediaItemsFromCoreDataPlaylist:currentPlaylist];
        self.songs = [[IBFileManager sharedManager] checkSongMediaItems:songs];
        
        
        self.currentPlaylist = currentPlaylist;
        NSLog(@"songsCount = %lu", (unsigned long)[self.songs count]);
        
        
        
        [[IBCurrentParametersManager sharedManager].addedSongs removeAllObjects];
        [[IBCurrentParametersManager sharedManager].removedSongs removeAllObjects];
        [[IBCurrentParametersManager sharedManager] setCoreDataPlaylist:nil];
        [[IBCurrentParametersManager sharedManager] setReturnSongsViewController:nil];
        [self.tableView reloadData];
   
    }
   
   }

- (void)loadView
{
    [super loadView];
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeNowPlayingSong:) name:MPMusicPlayerControllerNowPlayingItemDidChangeNotification object:nil];
    
    IBPlaylist *currentPlaylist = [[IBCurrentParametersManager sharedManager] coreDataPlaylist];
    self.currentPlaylist = currentPlaylist;
    
  
    
    
    NSString *title = currentPlaylist.playlistName;
    
    
    IBPlayerItem *removeSongButton = [[IBPlayerItem alloc] initWithButtonStyle:del];
    [removeSongButton addTarget:self action:@selector(removeSong) forControlEvents:UIControlEventTouchUpInside];
    
    IBBarButtonItem *removeSongItem = [[IBBarButtonItem alloc] initWithButton:removeSongButton];

    UIBarButtonItem *backItem =   [self setLeftBackBarButtonItem:title];
    
    NSArray *leftBarButtonItems;
    
    if ([[IBCurrentParametersManager sharedManager]isEditing]) {
        leftBarButtonItems = [NSArray arrayWithObjects:backItem, nil];
    }else{
         leftBarButtonItems = [NSArray arrayWithObjects:backItem,removeSongItem, nil];
    }
    
    [self.navigationItem setLeftBarButtonItems:leftBarButtonItems];
    self.navigationItem.titleView = [IBFontAttributes getCustomTitleForControllerName:@"Songs"];
    
    
}


- (void)dealloc
{

    [IBCurrentParametersManager sharedManager].coreDataPlaylist = nil;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
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
    
    
    IBMediaItem *song = [self.songs objectAtIndex:indexPath.row];
    
    MPMediaItem *songItem = (MPMediaItem*)song.mediaEntity;
    
    NSString *songTitle = [songItem valueForProperty:MPMediaItemPropertyTitle];
    NSString *artistTitle = [songItem valueForProperty:MPMediaItemPropertyArtist];
    NSNumber *playBackDuration = [songItem valueForProperty:MPMediaItemPropertyPlaybackDuration];
    
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
    NSAttributedString *songCount = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%lld", song.position + 1]];
    
    
    BOOL songIsNowPlaying = [self matchCurrentPlayingSongWithSong:song];
    
    [cell.songTitle setAttributedText:songName withNowPlayling:songIsNowPlaying];
    cell.artistTitle.attributedText  = artistName;
    cell.timeDuration.attributedText = timeDuration;
    cell.songCount.attributedText    = songCount;
    
    
      
    
    if ([[IBCurrentParametersManager sharedManager] isEditing]) {
        
        IBPlayerItem *addButton;
        
        if (song.state == added_state) {
            
            addButton = [[IBPlayerItem alloc]initWithButtonStyle:choose];
            [addButton setIsSelected:YES];
            [addButton addTarget:self action:@selector(addToPlaylistAction:) forControlEvents:UIControlEventTouchUpInside];
            
        }else if (song.state == inPlaylist_state){
            
            addButton = [[IBPlayerItem alloc]initWithButtonStyle:chooseInPlaylist];
            
            if ([[IBCurrentParametersManager sharedManager] coreDataChangingPlaylist]) {
                [addButton setIsSelected:YES];
                [addButton addTarget:self action:@selector(addToPlaylistAction:) forControlEvents:UIControlEventTouchUpInside];
            }
            
            
        }else if (song.state == default_state){
            
            addButton = [[IBPlayerItem alloc]initWithButtonStyle:add];
            [addButton addTarget:self action:@selector(addToPlaylistAction:) forControlEvents:UIControlEventTouchUpInside];
            
        }
        
        cell.editingAccessoryView = addButton;
        
    }else{
        
        cell.editingAccessoryView = nil;
    }

    
    return cell;
    
}


#pragma mark - UITableViewDelegate

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([[IBCurrentParametersManager sharedManager]isEditing]) {
        return UITableViewCellEditingStyleNone;
    }else{
        return UITableViewCellEditingStyleDelete;
    }
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    IBMediaItem *song = [self.songs objectAtIndex:indexPath.row];
    
    [[IBCurrentParametersManager sharedManager] setCurrentSong:song];
    [[IBCurrentParametersManager sharedManager] setIsPlayingMusic:YES];
    [IBCurrentParametersManager sharedManager].queueOfPlayingItems = nil;
    [IBCurrentParametersManager sharedManager].queueOfPlayingItems = [NSArray arrayWithArray:
                                                                      [self.songs valueForKeyPath:@"@unionOfObjects.mediaEntity"]];
    
    
    [self.tabBarController setSelectedIndex:2];
    
}

- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    IBSongCellTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    __weak IBSongsFromCoreDataViewController *weakSelf = self;
    
    NSDictionary *newAttributes = [IBFontAttributes attributesOfMainTitle];
    NSDictionary *systemAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:16]};
    
    NSString *title = @"DELETE";
    NSString *titleWhiteSpace = [self whitespaceReplacementString:title WithSystemAttributes:systemAttributes newAttributes:newAttributes];
    
    UITableViewRowAction *rowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:titleWhiteSpace handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        if (cell.editingStyle == UITableViewCellEditingStyleDelete) {
            
            IBMediaItem *removingSong = [self.songs objectAtIndex:indexPath.row];
            
            IBPlaylist *currentPlaylist = [[IBCurrentParametersManager sharedManager] coreDataPlaylist];
            
            [[IBCoreDataManager sharedManager] deleteIBSongItemsByPersistentIDs:@[[NSNumber numberWithLongLong:removingSong.mediaEntity.persistentID]] fromCoreDataPlaylist:currentPlaylist];
           
            [[IBCoreDataManager sharedManager]resortPositionsOfSongItemsInPlaylist:currentPlaylist];
            
            
            self.songs = [[IBFileManager sharedManager] getIBMediaItemsFromCoreDataPlaylist:currentPlaylist];

            [weakSelf.tableView reloadData];
            
        }
        
    }];
    
    
    UIImage *patternImage = [self imageForTableViewRowActionWithTitle:title textAttributes:newAttributes backgroundColor:[UIColor purpleColor] cellHeight:CGRectGetHeight(cell.bounds)];
    
    rowAction.backgroundColor = [UIColor colorWithPatternImage:patternImage];
    
    return [NSArray arrayWithObject:rowAction];
    
}




#pragma mark - Actions

- (void) addAllSongs:(IBPlayerItem*) button{
    
    NSArray *allStatesOfSongs = [self.songs valueForKeyPath:@"@distinctUnionOfObjects.state"];
    ItemState state = [[allStatesOfSongs firstObject] unsignedIntegerValue];
    if ( (([allStatesOfSongs count] == 1) && (state == inPlaylist_state )) | ([self.songs count] == 0) ) {
    }else{
        if ([button isSelected]) {
            [button setImage: [UIImage imageNamed:@"cancel_all.png"]forState:UIControlStateNormal];
            [button setIsSelected:NO];
            
            for (IBMediaItem *song in self.songs) {
                if (song.state == default_state) {
                    song.state = added_state;
                    [[IBCurrentParametersManager sharedManager].addedSongs addObject:song];
                }
            }
        }else{
            [button setImage: [UIImage imageNamed:@"add_all.png"]forState:UIControlStateNormal];
            [button setIsSelected:YES];
            
            
            for (IBMediaItem *song in self.songs) {
                if (song.state == added_state) {
                    [[IBCurrentParametersManager sharedManager] removeSongFromArray:song];
                    song.state = default_state;
                }
            }
        }
        
        
    }
    
    [self.tableView reloadData];
    
}


- (void)addNewSongs{
    
    [[IBCurrentParametersManager sharedManager] setIsEditing:YES];//playlist was saved to IBCurrentParametersManager in IBPlaylistsController
    
    [[IBCurrentParametersManager sharedManager] setCoreDataChangingPlaylist:self.currentPlaylist];
    [[IBCurrentParametersManager sharedManager] setReturnSongsViewController:self];
    
    UINavigationController *nav = [self.storyboard instantiateViewControllerWithIdentifier:@"IBAllMediaNavigationViewController"];
    
    
    [self.navigationController presentViewController:nav animated:YES completion:nil];
    
}


- (void) removeSong{
    
    if ([self.tableView isEditing]) {
        [self.tableView setEditing:NO animated:YES];
        IBPlayerItem *addToPlaylistButton = [[IBPlayerItem alloc] initWithButtonStyle:add];
        [addToPlaylistButton addTarget:self action:@selector(addNewSongs) forControlEvents:UIControlEventTouchUpInside];
        IBBarButtonItem *addToPlaylistItem = [[IBBarButtonItem alloc] initWithButton:addToPlaylistButton];
        self.navigationItem.rightBarButtonItem = addToPlaylistItem;
    }else{
        [self.tableView setEditing:YES animated:YES];
        self.navigationItem.rightBarButtonItem =  nil;
    }
    
}



- (void) addToPlaylistAction:(IBPlayerItem*) button{
    
    CGPoint point = [button convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:point];
    

    IBMediaItem *song = [self.songs objectAtIndex:indexPath.row];
    
    
    if (song.state == default_state) {
        
        [button setImage: [UIImage imageNamed:@"Added.png"]forState:UIControlStateSelected];
        [button setIsSelected:YES];
        song.state = added_state;
        [[IBCurrentParametersManager sharedManager].addedSongs addObject:song];
        
    }else if (song.state == added_state){
        
        [button setImage: [UIImage imageNamed:@"add 64 x 64.png"]forState:UIControlStateNormal];
        [button setIsSelected:NO];
        [[IBCurrentParametersManager sharedManager].addedSongs removeObject:song];
        song.state = default_state;
        
    }else if ( (song.state == inPlaylist_state) && ([[IBCurrentParametersManager sharedManager] coreDataChangingPlaylist])){
        
        [button setImage: [UIImage imageNamed:@"cancel-music(4).png"]forState:UIControlStateNormal];
        [button setIsSelected:NO];
        [[IBCurrentParametersManager sharedManager].removedSongs addObject:song];
        song.state = delete_state;
        
        NSLog(@"added songs = %lu",(unsigned long)[[[IBCurrentParametersManager sharedManager]addedSongs]count]);
        
        
    }else if (song.state == delete_state){
        
        [button setImage: [UIImage imageNamed:@"inPlaylist.png"]forState:UIControlStateNormal];
        [button setIsSelected:NO];
        [[IBCurrentParametersManager sharedManager].removedSongs removeObject:song];
        song.state = inPlaylist_state;
    }
    
}



#pragma mark - Edit Delete Button Of Cell

- (UIImage*) imageForTableViewRowActionWithTitle:(NSString*) title textAttributes:(NSDictionary*) attributes backgroundColor:(UIColor*) color cellHeight:(CGFloat) cellHeight{
    
    
    NSString *titleString = title;
    NSDictionary *originalAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:17]};
    CGSize originalSize = [titleString  sizeWithAttributes:originalAttributes];
    
    CGSize newSize = CGSizeMake(originalSize.width * 2.5, originalSize.height * 2);
    
    CGRect drawingRect = CGRectIntegral(CGRectMake(0, 0, newSize.width, newSize.height));
    UIGraphicsBeginImageContextWithOptions(drawingRect.size, YES, [UIScreen mainScreen].nativeScale);
    
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(contextRef, color.CGColor);
    CGContextFillRect(contextRef, drawingRect);
    
    
    UILabel *label = [[UILabel alloc] initWithFrame:drawingRect];
    label.textAlignment = NSTextAlignmentCenter;
    label.attributedText = [[NSAttributedString alloc] initWithString:title attributes:[IBFontAttributes attributesOfMainTitle]];
    
    [label drawTextInRect:drawingRect];
    
    UIImage *returningImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    
    return returningImage;
    
}


- (NSString *) whitespaceReplacementString:(NSString*) string WithSystemAttributes:(NSDictionary *)systemAttributes newAttributes:(NSDictionary *)newAttributes
{
    NSString *stringTitle = string;
    NSMutableString *stringTitleWS = [[NSMutableString alloc] initWithString:@""];
    
    CGFloat diff = 0;
    CGSize  stringTitleSize = [stringTitle sizeWithAttributes:newAttributes];
    CGSize stringTitleWSSize;
    NSDictionary *originalAttributes = systemAttributes;
    do {
        [stringTitleWS appendString:@" "];
        stringTitleWSSize = [stringTitleWS sizeWithAttributes:originalAttributes];
        diff = (stringTitleSize.width - stringTitleWSSize.width);
        if (diff <= 1.5) {
            break;
        }
    }
    while (diff > 0);
    
    return stringTitleWS;
}


@end
