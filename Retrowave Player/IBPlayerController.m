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
#import "IBTimeLineSlider.h"
#import "IBSongTitle.h"
#import "IBDetailedTitle.h"
@interface IBPlayerController ()

@property (strong, nonatomic) MPMusicPlayerController *musicPlayerController;
@property (strong, nonatomic) MPMediaItem *currentSong;
@property (strong, nonatomic) NSTimer *timerForMusicTimeLineRefresh;
@property (strong, nonatomic) NSArray *queueOfSongs;


@end

@implementation IBPlayerController
@synthesize musicPlayerController;

- (void) loadView{
    [super loadView];
  
    MPVolumeView *volumeView = [[MPVolumeView alloc] initWithFrame:CGRectMake(18, 440, 284, 31)];
    [self.view addSubview:volumeView];

    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    self.musicPlayerController =  [MPMusicPlayerController applicationMusicPlayer];
    self.musicPlayerController.shuffleMode = MPMusicShuffleModeOff;
    self.musicPlayerController.repeatMode = MPMusicRepeatModeAll;
    
//    IBMainTabBarController *tabBarController = (IBMainTabBarController*)self.tabBarController;
//    IBVisualizerMusic *visualizer = [tabBarController visualizer];
    
    IBVisualizerMusic *visualizer = [[IBCurrentParametersManager sharedManager]visualizer];
    self.visualizer = visualizer;
    [self.playPauseButton setSelected:YES];
    
    self.musicTimeLine.continuous = YES;

    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(nowPlayingSongChanged:) name:MPMusicPlayerControllerNowPlayingItemDidChangeNotification object:self.musicPlayerController];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive) name:@"applicationWillResignActive" object:nil];
    
    [self.musicPlayerController beginGeneratingPlaybackNotifications];
    
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
        
        [self.musicPlayerController setNowPlayingItem:currentSong];
       
        [self updatePlayerParametersBySong:currentSong];
        
        
        
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
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.musicPlayerController endGeneratingPlaybackNotifications];
   
    
}



#pragma mark - Actions


- (IBAction)timeLineSliderValueChanged :(UISlider*) slider{
   
    if ([self.timerForMusicTimeLineRefresh isValid]) {
        [self.timerForMusicTimeLineRefresh invalidate];
    }
    
     NSTimeInterval songPlaybackTime = [[ [self.musicPlayerController nowPlayingItem] valueForProperty:MPMediaItemPropertyPlaybackDuration] doubleValue];
    
    NSDateComponentsFormatter *dateFormatter = [[NSDateComponentsFormatter alloc] init];
    dateFormatter.zeroFormattingBehavior = NSDateComponentsFormatterZeroFormattingBehaviorPad;
    dateFormatter.allowedUnits = NSCalendarUnitMinute | NSCalendarUnitSecond;
    dateFormatter.unitsStyle = NSDateComponentsFormatterUnitsStylePositional;
    
    
    
    self.musicTimePlus.text = [NSString stringWithFormat:@"%@",[dateFormatter stringFromTimeInterval:self.musicTimeLine.value]];
    
    self.musicTimeSub.text =  [NSString stringWithFormat:@"%@",[dateFormatter stringFromTimeInterval:songPlaybackTime  - self.musicTimeLine.value]];
    
    
    [self.musicPlayerController setCurrentPlaybackTime:self.musicTimeLine.value];
    
    self.timerForMusicTimeLineRefresh = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateMusicTimeLine) userInfo:nil repeats:YES];
    
   
}



- (IBAction)playPauseButtonAction:(IBPlayerItem *) button{
   
    if ( [self.visualizer isStarted]){
        [self.timerForMusicTimeLineRefresh invalidate];
        [self.musicPlayerController pause];
        [self.visualizer stopVisualizerAnimation];
         self.visualizer.isStarted = NO;
        [IBCurrentParametersManager sharedManager].isPlayingMusic = NO;
        [button setSelected:NO];
}else {
        self.timerForMusicTimeLineRefresh = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateMusicTimeLine) userInfo:nil repeats:YES];
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
    NSLog(@"fastForwarButtonAction");
    [self.musicPlayerController skipToNextItem];
  
}

- (IBAction)fastRemindButtonAction   :(UIButton*) button{
    [self.musicPlayerController skipToPreviousItem];
    NSLog(@"fastRemindButtonAction");

}


- (IBAction)repeatModeChangedAction     :(UIButton*)        button{
    
    MPMusicRepeatMode repeatMode = [self.musicPlayerController repeatMode];
    
    switch (repeatMode) {
            
        case MPMusicRepeatModeNone:
           [self.musicPlayerController setRepeatMode:MPMusicRepeatModeAll];
            NSLog(@"Now repeat mode is Mode all");
            break;
            
        case MPMusicRepeatModeAll:
            [self.musicPlayerController setRepeatMode:MPMusicRepeatModeOne];
            NSLog(@"Now repeat mode is Mode one");
            break;
            
        case MPMusicRepeatModeOne:
             [self.musicPlayerController setRepeatMode:MPMusicRepeatModeAll];
            NSLog(@"Now repeat mode is Mode all");
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
            NSLog(@"Now shuffleMode is Mode songs");
            break;
            
            
        case MPMusicShuffleModeSongs:
             [self.musicPlayerController setShuffleMode:MPMusicShuffleModeOff];
            NSLog(@"Now shuffleMode is Mode OFF");
            break;
        default:
            break;
    }
    
    
    
}




#pragma mark  - Notifications

- (void) nowPlayingSongChanged:(NSNotification*) notification{
    
    NSLog(@"change NowPlayingSong in playerController");
   
    
    MPMediaItem *nowPlayingSong = [self.musicPlayerController nowPlayingItem];
    [[IBCurrentParametersManager sharedManager].currentSong setMediaEntity:nowPlayingSong];
   
    [self updatePlayerParametersBySong:nowPlayingSong];
}





#pragma mark - TimerForUpdateMusicTimeLine

- (void) updateMusicTimeLine{
    
    
    double currentTime = [self.musicPlayerController currentPlaybackTime];
    
    NSTimeInterval songPlaybackTime = [[ [self.musicPlayerController nowPlayingItem] valueForProperty:MPMediaItemPropertyPlaybackDuration] doubleValue];
    
    NSDateComponentsFormatter *dateFormatter = [[NSDateComponentsFormatter alloc] init];
    dateFormatter.zeroFormattingBehavior = NSDateComponentsFormatterZeroFormattingBehaviorPad;
    dateFormatter.allowedUnits = NSCalendarUnitMinute | NSCalendarUnitSecond;
    dateFormatter.unitsStyle = NSDateComponentsFormatterUnitsStylePositional;
    
    self.musicTimeLine.value = currentTime;
    
    //NSLog(@"time = %f",self.musicTimeLine.value);
   
    
    self.musicTimePlus.text = [NSString stringWithFormat:@"%@",[dateFormatter stringFromTimeInterval:currentTime]];
    self.musicTimeSub.text =  [NSString stringWithFormat:@"%@",[dateFormatter stringFromTimeInterval:songPlaybackTime - currentTime]];

    
//    NSLog(@"time elapsed = %@", self.musicTimePlus.text);
//    NSLog(@"time  = %f", songPlaybackTime);
    
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


#pragma mark - Update Player Parameters

- (void) updatePlayerParametersBySong:(MPMediaItem*) currentSong{
   
    [self.musicTimeLine startNewTimeLineBySongDuration:[[currentSong valueForProperty:MPMediaItemPropertyPlaybackDuration] floatValue]];
    self.albumArt.image = [self getAlbumArtFromSong:currentSong];
    
    NSString *songTitle        = [currentSong valueForProperty:MPMediaItemPropertyTitle];
    NSString *artistTitle      = [currentSong valueForProperty:MPMediaItemPropertyArtist];
    
    if (!songTitle) {
        songTitle = @"";
    }
    if (!artistTitle) {
        artistTitle = @"";
    }
    
    
    NSAttributedString *songName     = [[NSAttributedString alloc] initWithString:songTitle];
    NSAttributedString *artistName   = [[NSAttributedString alloc] initWithString:artistTitle];
    
    [self.songTitle setAttributedText:songName withNowPlayling:YES];
    self.artistTitle.attributedText = artistName;
}



#pragma mark - Notifications

- (void) applicationWillResignActive{
    NSLog(@"applicationWillResignActive IBPlayerController");
}


@end
