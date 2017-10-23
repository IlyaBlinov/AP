//
//  IBPlayerController.m
//  APlayer
//
//  Created by ilyablinov on 02.03.17.
//  Copyright (c) 2017 IB. All rights reserved.
//

#import "IBPlayerController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "IBMainTabBarController.h"
#import "IBPlayerItem.h"
#import "IBVisualizerMusic.h"
#import "IBFileManager.h"

@interface IBPlayerController ()

@property (strong, nonatomic) MPMusicPlayerController *musicPlayerController;
@property (strong, nonatomic) MPMediaItem *currentSong;
@property (strong, nonatomic) NSTimer *timerForMusicTimeLineRefresh;
@property (strong, nonatomic) NSArray *queueOfSongs;


@end

@implementation IBPlayerController


- (void) loadView{
    [super loadView];
    
    MPVolumeView *volumeView = [[MPVolumeView alloc] initWithFrame:CGRectMake(18, 440, 284, 31)];
    [self.view addSubview:volumeView];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    self.musicPlayerController =  [MPMusicPlayerController systemMusicPlayer];
    self.musicPlayerController.shuffleMode = MPMusicShuffleModeOff;
    self.musicPlayerController.repeatMode = MPMusicRepeatModeNone;
    
    IBMainTabBarController *tabBarController = (IBMainTabBarController*)self.tabBarController;
    IBVisualizerMusic *visualizer = [tabBarController visualizer];
    
    self.visualizer = visualizer;
    [self.playPauseButton setSelected:YES];
    
    
    
//    
   [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeNowPlayingSong:) name:MPMusicPlayerControllerNowPlayingItemDidChangeNotification object:nil];
    
  //  [self.musicPlayerController beginGeneratingPlaybackNotifications];
    

}



- (void)viewWillAppear:(BOOL)animated
{  
    if ([[IBCurrentParametersManager sharedManager] isPlayingMusic]) {
    
        MPMediaItem *nowPlaylingSong = [self.musicPlayerController nowPlayingItem];
        NSNumber *persistentIDNowPlayingSong = [nowPlaylingSong valueForProperty:MPMediaItemPropertyPersistentID];
        
        MPMediaItem *currentSong = (MPMediaItem*)[[[IBCurrentParametersManager sharedManager]currentSong] mediaEntity];
        NSNumber *persistentIDCurrentSong = [currentSong valueForProperty:MPMediaItemPropertyPersistentID];
        
       
        NSArray *queuePlaylingItems = [[IBCurrentParametersManager sharedManager] queueOfPlayingItems];
        
        
        
        if ((self.musicPlayerController.playbackState == MPMusicPlaybackStatePlaying) &&
            ([persistentIDNowPlayingSong isEqual:persistentIDCurrentSong])) {
             NSLog(@"nowPlaylingSongTitleNotChanged = %@",[nowPlaylingSong valueForProperty:MPMediaItemPropertyTitle]);
        }else{
            
            [self.musicPlayerController stop];
        
            if ([queuePlaylingItems count] > 0) {
                self.queueOfSongs = queuePlaylingItems;
                [self.musicPlayerController setQueueWithItemCollection:[MPMediaItemCollection collectionWithItems:queuePlaylingItems]];
            }

            
            
    if (currentSong) {
        [self.musicPlayerController beginGeneratingPlaybackNotifications];
        [self.musicPlayerController setNowPlayingItem:currentSong];
        
        
        self.albumArt.image = [self getAlbumArtFromSong:currentSong];
        NSLog(@"index of now item = %d and title = %@",[self.musicPlayerController indexOfNowPlayingItem],[currentSong valueForProperty:MPMediaItemPropertyTitle]);
        
        }
        
        [self.musicPlayerController prepareToPlay];
        [self.musicPlayerController play];
        
            
            [self.timerForMusicTimeLineRefresh invalidate];
        self.timerForMusicTimeLineRefresh = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateMusicTimeLine) userInfo:nil repeats:YES];
        
    [self.playPauseButton setSelected:YES];
    
    [self.visualizer startVisualizerAnimation];
    self.visualizer.isStarted = YES;
        
    }
   
    }else{
        [self.playPauseButton setSelected:NO];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




- (void)dealloc
{
    NSLog(@"IBPlayerController dealloc");
    [self.musicPlayerController endGeneratingPlaybackNotifications];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.musicPlayerController = nil;
}
#pragma mark - Actions


- (IBAction)playPauseButtonAction:(IBPlayerItem *) button{
   
    if ( [self.visualizer isStarted]){
        [self.musicPlayerController pause];
        [self.visualizer stopVisualizerAnimation];
         self.visualizer.isStarted = NO;
        [IBCurrentParametersManager sharedManager].isPlayingMusic = NO;
        [button setSelected:NO];
          }

    else {
        [self.musicPlayerController play];
        [self.visualizer startVisualizerAnimation];
        self.visualizer.isStarted = YES;
         [IBCurrentParametersManager sharedManager].isPlayingMusic = YES;
        [button setSelected:YES];
       
    }
    
}


- (IBAction)volumeSliderValueChanged:(UISlider*) slider{
    
}




- (IBAction)fastForwarButtonAction   :(UIButton*) button{
//    MPMediaItem *nextSong = [self getNextSong];
//    [self playNextOrPreviousSong:nextSong];
    NSLog(@"fastForwarButtonAction");
     [self.musicPlayerController beginGeneratingPlaybackNotifications];
    [self.musicPlayerController skipToNextItem];
  
}

- (IBAction)fastRemindButtonAction   :(UIButton*) button{
//    MPMediaItem *previousSong = [self getPreviousSong];
//    [self playNextOrPreviousSong:previousSong];
     [self.musicPlayerController beginGeneratingPlaybackNotifications];
    [self.musicPlayerController skipToPreviousItem];
 
}


- (IBAction)repeatModeChangedAction     :(UIButton*)        button{
    
    MPMusicRepeatMode repeatMode = [self.musicPlayerController repeatMode];
    
    switch (repeatMode) {
            
        case MPMusicRepeatModeNone:
           [self.musicPlayerController setRepeatMode:MPMusicRepeatModeAll];
            break;
            
        case MPMusicRepeatModeAll:
            [self.musicPlayerController setRepeatMode:MPMusicRepeatModeOne];
            break;
            
        case MPMusicRepeatModeOne:
             [self.musicPlayerController setRepeatMode:MPMusicRepeatModeNone];
            break;
            
            
        default:
            break;
    }
    
}


- (IBAction)shuffleModeChangedAction    :(UIButton*)        button{
    
    MPMusicShuffleMode shuffleMode = [self.musicPlayerController shuffleMode];
    
    switch (shuffleMode) {
        case MPMusicShuffleModeOff:
            [self.musicPlayerController setShuffleMode:MPMusicShuffleModeSongs];
            break;
            
            
        case MPMusicShuffleModeSongs:
             [self.musicPlayerController setShuffleMode:MPMusicShuffleModeOff];
            break;
        default:
            break;
    }
    
    
    
}




#pragma mark  - Notifications


- (void) changeNowPlayingSong:(NSNotification*) notification{
    
    NSLog(@"changeNowPlayingSong in playerController");
    MPMediaItem *nowPlayingSong = [self.musicPlayerController nowPlayingItem];
    [[IBCurrentParametersManager sharedManager].currentSong setMediaEntity:nowPlayingSong];
    self.albumArt.image = [self getAlbumArtFromSong:nowPlayingSong];
        
}



- (IBAction)timeLineSliderValueChanged :(UISlider*) slider{
    
    
   // [self.musicPlayerController setCurrentPlaybackTime:10.0];
    
    
    
}

#pragma mark - TimerForUpdateMusicTimeLine


- (void) updateMusicTimeLine{
    
    
    double currentTime = [self.musicPlayerController currentPlaybackTime];
    
    NSTimeInterval songPlaybackTime = [[ [self.musicPlayerController nowPlayingItem] valueForProperty:MPMediaItemPropertyPlaybackDuration] doubleValue];
    
    NSDateComponentsFormatter *dateFormatter = [[NSDateComponentsFormatter alloc] init];
    dateFormatter.zeroFormattingBehavior = NSDateComponentsFormatterZeroFormattingBehaviorPad;
    dateFormatter.allowedUnits = NSCalendarUnitMinute | NSCalendarUnitSecond;
    dateFormatter.unitsStyle = NSDateComponentsFormatterUnitsStylePositional;
    
    
   
    
    self.musicTimePlus.text = [NSString stringWithFormat:@"%@",[dateFormatter stringFromTimeInterval:currentTime]];
    self.musicTimeSub.text =[NSString stringWithFormat:@"%@",[dateFormatter stringFromTimeInterval:songPlaybackTime - currentTime]];

    
//    NSLog(@"time elapsed = %@", self.musicTimePlus.text);
//    NSLog(@"time  = %f", songPlaybackTime);
    
}


#pragma mark - Get songs

- (MPMediaItem*) getNextSong{
    
    MPMediaItem *currentSong = [self.musicPlayerController nowPlayingItem];
    
    if ([self.queueOfSongs containsObject:currentSong]) {
        
        NSInteger indexOfCurrentSong = [self.queueOfSongs indexOfObject:currentSong];
        
        if (indexOfCurrentSong == [self.queueOfSongs indexOfObject:[self.queueOfSongs lastObject]]) {
            return [self.queueOfSongs firstObject];
        }
        if ([self.queueOfSongs count] == 1) {
            return currentSong;
        }
    
        
        MPMediaItem *nextSong = [self.queueOfSongs objectAtIndex:indexOfCurrentSong + 1];
        NSLog(@"nextSongTitle = %@",[nextSong valueForProperty:MPMediaItemPropertyTitle]);
        return nextSong;
        
    }
    return currentSong;
    
}



- (MPMediaItem*) getPreviousSong{
    
    MPMediaItem *currentSong = [self.musicPlayerController nowPlayingItem];
    
    if ([self.queueOfSongs containsObject:currentSong]) {
        
        NSInteger indexOfCurrentSong = [self.queueOfSongs indexOfObject:currentSong];
        
        if (indexOfCurrentSong == [self.queueOfSongs indexOfObject:[self.queueOfSongs firstObject]]) {
            return [self.queueOfSongs lastObject];
        }
        if ([self.queueOfSongs count] == 1) {
            return currentSong;
        }
        
        
        MPMediaItem *previousSong = [self.queueOfSongs objectAtIndex:indexOfCurrentSong - 1];
        NSLog(@"nextSongTitle = %@",[previousSong valueForProperty:MPMediaItemPropertyTitle]);
        return previousSong;
        
    }
    return currentSong;
    
}




#pragma mark - get parameters for player

- (UIImage*) getAlbumArtFromSong:(MPMediaItem*) song{
    
    MPMediaItemArtwork *albumImageItem = [song valueForProperty:MPMediaItemPropertyArtwork];
    CGRect imageRect = self.albumArt.bounds;
    CGSize sizeOfAlbumImageItem = CGSizeMake(CGRectGetWidth(imageRect), CGRectGetHeight(imageRect));
    UIImage *albumImage;
    if (albumImageItem) {
        albumImage = [albumImageItem imageWithSize:sizeOfAlbumImageItem];
    }else{
        UIImage *defaultArtAlbum = [UIImage imageNamed:@"anonymous-logo(6).png"];
        albumImage = defaultArtAlbum;
    }
    
    return albumImage;
}


- (void) playNextOrPreviousSong:(MPMediaItem*) song{
    [[IBCurrentParametersManager sharedManager].currentSong setMediaEntity:song];

    [self.musicPlayerController stop];
    [self.musicPlayerController setNowPlayingItem:song];
    [self.musicPlayerController prepareToPlay];
    [self.musicPlayerController play];
    [self.playPauseButton setSelected:YES];
     [IBCurrentParametersManager sharedManager].isPlayingMusic = YES;
    
    if ( self.visualizer.isStarted == NO) {
        self.visualizer.isStarted = YES;
        [self.visualizer startVisualizerAnimation];
    }
    
}

@end
