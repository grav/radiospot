//
// Created by Mikkel Gravgaard on 21/01/14.
// Copyright (c) 2014 Betafunk. All rights reserved.
//

@interface UIEventMock : NSObject
@property int subtype;
@end

@implementation UIEventMock
@end

#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "PlayerViewController.h"
#import "CocoaLibSpotify.h"
#import "ChannelCell.h"
#import "WBSuccessNoticeView.h"
#import "WBErrorNoticeView.h"
#import "BTFSpotify.h"
#include "appkey.c"
#import "PlayerView.h"
#import "PlayerViewModel.h"
#import "MessageView.h"
#import "NSObject+Notifications.h"
#import "RACStream+BTFAdditions.h"
#import "OverlayView.h"
#import "MASConstraintMaker+Self.h"
#import "SpotifyButton.h"
#import "Track.h"
#import "PlaylistHelper.h"
#import "ConnectionThresholdCalculator.h"

#if DEBUG
static NSString *const kPlaylistName = @"RadioSpot-DEBUG";
#else
static NSString *const kPlaylistName = @"RadioSpot";
#endif

#define CREATE_RANDOM_PLAYLIST 0

@interface PlayerViewController () <UITableViewDataSource, UITableViewDelegate>
@property(nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVAudioPlayer *spotifyAddingSuccessPlayer;
@property(nonatomic, strong) BTFSpotify *btfSpotify;
@property (nonatomic, strong) PlayerViewModel *viewModel;
@property(nonatomic, strong) AVAudioPlayer *bgKeepAlivePlayer;
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) PlayerView *playerView;
@property(nonatomic, strong) MessageView *messageView;


@property(nonatomic, strong) RACSubject *retrySubj;
@property(nonatomic, strong) RACSubject *thresSubj;
@property(nonatomic, strong) RACSubject *remoteSubj;
@property(nonatomic, strong) RACSubject *channelFromRemote;
@end

@implementation PlayerViewController {

}
- (instancetype)init{
    self = [super init];
    if(self){
        
        self.remoteSubj = [RACSubject subject];

#ifdef DEBUG
        // Make logNext etc show names to aid debugging
        setenv("RAC_DEBUG_SIGNAL_NAMES","true",1);
#endif
        [self setupRemoteControl];

        [self setupNotifications];

        self.viewModel = [PlayerViewModel new];

        RACSignal *channelSignal = RACObserve(self.viewModel, currentChannel);
        RACMulticastConnection *conn = [channelSignal publish];
        RACSignal *repeatingChannelSignal = [conn.signal flattenMap:^RACStream *(Channel *c) {
            if(!c) return [RACSignal return:nil];
            return [[[[RACSignal interval:10 onScheduler:[RACScheduler mainThreadScheduler]] startWith:[NSDate date]] takeUntil:conn.signal] mapReplace:c];
        }];

        [conn connect];

        RAC(self.viewModel, currentTrack) = [repeatingChannelSignal flattenMap:^RACStream *(Channel *c) {
            if (!c) return [RACSignal return:nil];
            return [[[PlaylistHelper currentTrackForChannel:c] catch:^RACSignal *(NSError *error) {
                NSLog(@"%@",error);
                return [RACSignal return:nil];
            }] deliverOn:[RACScheduler mainThreadScheduler]];
        }];

        self.btfSpotify = [[BTFSpotify alloc] initWithAppKey:g_appkey size:g_appkey_size];
        self.btfSpotify.presentingViewController = self;

    }
    return self;
}

- (void)updateOnClassInjection
{
/*
    [self loadView];
    [self viewDidLoad];
    //    [self showOverlay];
    */
}

- (void)setupNotifications {

    [[self rac_notifyUntilDealloc:AVAudioSessionInterruptionNotification] subscribeNext:^(NSNotification *notification) {
        AVAudioSessionInterruptionType value;
        [notification.userInfo[AVAudioSessionInterruptionTypeKey] getValue:&value];
        switch (value) {
            case AVAudioSessionInterruptionTypeBegan:
                break;
            case AVAudioSessionInterruptionTypeEnded:
                if(!self.viewModel.userPaused){
                    [self.player play];
                }
                break;
        }
    }];

    [[self rac_notifyUntilDealloc:UIApplicationDidBecomeActiveNotification] subscribeNext:^(id x) {
        if(!self.viewModel.userPaused){
            [self.player play];
        }
    }];

}

- (void)setupRemoteControl {
    RACSignal *remoteControlSignal = [[[self rac_signalForSelector:@selector(remoteControlReceivedWithEvent:)] map:^id(RACTuple *tuple) {
        return tuple.first;
    }] merge:self.remoteSubj];

    [[remoteControlSignal filter:^BOOL(UIEvent *event) {
            return event.subtype == UIEventSubtypeRemoteControlPreviousTrack;
        }] subscribeNext:^(id x) {
            self.viewModel.didAddUsingRemove = YES;
            if(self.viewModel.currentTrack){
                [self addTrack:self.viewModel.currentTrack usingRemote:YES];
            }
        }];

    [[remoteControlSignal filter:^BOOL(UIEvent *event) {
            return event.subtype == UIEventSubtypeRemoteControlTogglePlayPause;
        }] subscribeNext:^(id x) {
            if(self.player.rate==0) {
                [self.player play];
            } else {
                [self.player pause];
            }
        }];

    [[remoteControlSignal filter:^BOOL(UIEvent *event) {
            return event.subtype == UIEventSubtypeRemoteControlPlay;
        }] subscribeNext:^(id x) {
            [self.player play];
        }];

    [[remoteControlSignal filter:^BOOL(UIEvent *event) {
            return event.subtype == UIEventSubtypeRemoteControlPause;
        }] subscribeNext:^(id x) {
            if(self.player.rate == 1){
                // TODO - the 'pause' status isn't reflected in the UI
                [self.player pause];
            }
        }];

    [[remoteControlSignal filter:^BOOL(UIEvent *event) {
            return event.subtype == UIEventSubtypeRemoteControlNextTrack;
        }] subscribeNext:^(id x) {
            NSInteger row = (self.tableView.indexPathForSelectedRow.row + 1) % self.viewModel.channels.count;
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row
                                                                        inSection:0];
        [self.tableView selectRowAtIndexPath:indexPath
                                    animated:YES
                              scrollPosition:UITableViewScrollPositionNone];
        Channel *channel = self.viewModel.channels[(NSUInteger) row];
        [self.channelFromRemote sendNext:channel];
    }];
}

- (void)keepAlive{
#ifdef DEBUG
    NSString *sound = @"beep";
#else
    NSString *sound = @"nobeep";
#endif
    NSURL *audioFileLocationURL = [[NSBundle mainBundle] URLForResource:sound withExtension:@"wav"];
    NSError *error;
    self.bgKeepAlivePlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:audioFileLocationURL error:&error];
    NSCAssert(!error, @"Audio loading error: %@", error);
    self.bgKeepAlivePlayer.numberOfLoops = -1;

    [self.bgKeepAlivePlayer play];

}

- (void)stopKeepAlive
{

    [self.bgKeepAlivePlayer stop];

}


- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor colorWithWhite:0.93 alpha:1];

    RACSignal *currentTrackS = RACObserve(self.viewModel, currentTrack);

    self.tableView = [UITableView new];
    [self.tableView registerClass:[ChannelCell class] forCellReuseIdentifier:ReuseId];
    self.tableView.dataSource = self; self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    self.tableView.frame = self.view.bounds;
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.tableView.backgroundColor = [UIColor clearColor];

    PlayerView *playerView = [PlayerView new];
    playerView.frame = CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, 56);
    playerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:playerView];

    RAC(playerView,track) = currentTrackS;

    [currentTrackS subscribeNext:^(Track *track) {
        if(track) {
            [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:@{
                    MPMediaItemPropertyTitle : track.title,
                    MPMediaItemPropertyArtist : track.artist
            }];
        } else {
            [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:nil];
        }
    }];

    RACSignal *talkingToSpotify = RACObserve(self.viewModel, talkingToSpotify);
    RACSignal *hasTrack = [currentTrackS map:^id(id track) {
        return @(track != nil);
    }];

    RAC(playerView.addToSpotBtn,working) = talkingToSpotify;
    RAC(playerView.addToSpotBtn,enabled) = hasTrack;

    [[playerView.addToSpotBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        self.viewModel.didDismissMessage = YES;
        [self addTrack:self.viewModel.currentTrack usingRemote:NO];
    }];

    playerView.stopBtn.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        [self stop];
        return [RACSignal empty];
    }];


    self.messageView = [MessageView new];

    [self.view addSubview:self.messageView];
    [self.messageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.messageView.superview).offset(-playerView.frame.size.height + 12);
        make.right.equalTo(self.messageView.superview).offset(-5);
    }];

    RACSignal *racSignal = [RACObserve(self.viewModel, didDismissMessage) distinctUntilChanged];
    [[[RACSignal combineLatest:@[hasTrack, RACObserve(self, player), racSignal]
                        reduce:^id(NSNumber *hasTrackN, id player, NSNumber *didDismiss) {
                            return @(hasTrackN.boolValue && player && !didDismiss.boolValue);
                        }] throttle:0.1] subscribeNext:^(NSNumber *show) {
        self.messageView.text = NSLocalizedString(@"MessageAddToSpotify", @"Add to Spotify");
        if (show.boolValue) {
            [self.messageView show];
        } else {
            [self.messageView hide];
        }
    }];

    [[self.messageView rac_signalForControlEvents:UIControlEventTouchDown] subscribeNext:^(id x) {
        [self.messageView hide];
        self.viewModel.didDismissMessage = YES;
    }];

    [RACObserve(self, player) subscribeNext:^(id player) {
        CGRect frame = playerView.frame;
        CGFloat playerHeight = frame.size.height;
        CGFloat originY = player ==nil?self.view.bounds.size.height : self.view.bounds.size.height- playerHeight;
        frame.origin.y = originY;

        UIEdgeInsets insets =  self.tableView.contentInset;
        insets.bottom = player ==nil? 0 : playerHeight;
        [UIView animateWithDuration:0.4 animations:^{
            self.tableView.contentInset = insets;
            playerView.frame = frame;
        } completion:^(BOOL finished) {
            [self.tableView scrollToNearestSelectedRowAtScrollPosition:UITableViewScrollPositionNone
                                                              animated:YES];

        }];
    }];

    self.playerView = playerView;
    UIImage *image = [UIImage imageNamed:@"Images/edit"];
    UIButton *b = [UIButton buttonWithType:UIButtonTypeCustom];
    [b setImage:image forState:UIControlStateNormal];
    b.frame = CGRectMake(0, 0, 22, 22);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:b];

    b.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        [self toggleEditing];

        return [RACSignal empty];
    }];



    RACSignal *didSelect = [self rac_signalForSelector:@selector(tableView:didSelectRowAtIndexPath:)];

    RACSignal *noChannel = [[self rac_signalForSelector:@selector(stop)] mapReplace:nil];

    self.channelFromRemote = [RACSubject subject];

    RACSignal *selectedChannel = [[[[didSelect tupleSecond] map:^id(NSIndexPath *indexPath) {
        return self.viewModel.channels[(NSUInteger) indexPath.row];
    }] merge:noChannel] merge:self.channelFromRemote];



    [self setupRetry:selectedChannel];

}

- (void)toggleEditing {
    CGFloat rotation = (CGFloat) (self.tableView.isEditing ? 0 : M_PI_2);
    [UIView animateWithDuration:0.3 animations:^{
        UIView *view = self.navigationItem.rightBarButtonItem.customView;
        view.transform = CGAffineTransformMakeRotation(rotation);

    }];
    [self.tableView setEditing:!self.tableView.isEditing animated:YES];

    if(!self.tableView.isEditing && self.player.rate>0){
        NSIndexPath *indexPath = [self indexPathForCurrentlyPlayingCell];
        [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
}

- (NSIndexPath *)indexPathForCurrentlyPlayingCell {
    NSInteger idx = [self.viewModel.channels indexOfObject:self.viewModel.currentChannel];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:idx inSection:0];
    return indexPath;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    [self.viewModel moveChannelFromIndex:(NSUInteger) sourceIndexPath.row toIndex:(NSUInteger) destinationIndexPath.row];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleNone;
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}


- (void)showOverlay {
    OverlayView *overlay = [OverlayView new];
    UIView *window = [[UIApplication sharedApplication] keyWindow];
    [window addSubview:overlay];
    [overlay mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(make.superview);
    }];
    overlay.alpha = 0;
    [UIView animateWithDuration:0.4 animations:^{
        overlay.alpha = 1;
    }];
}

#pragma mark tblview

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.channels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ChannelCell *cell = [tableView dequeueReusableCellWithIdentifier:ReuseId forIndexPath:indexPath];
    [cell configure:self.viewModel.channels[(NSUInteger) indexPath.row]];
    return cell;
}


- (void)setupRetry:(RACSignal*)selectedChannel {

    // Used both to update viewmodel and triggering player
    RACMulticastConnection *channelConn = [selectedChannel publish];

    RAC(self.viewModel, currentChannel) = channelConn.signal;

    RACSignal *connectionThresholdSignal = [ConnectionThresholdCalculator currentConnectionThresholdSignal];

    // Necessary as a property, to keep it alive for some reason ...
    self.retrySubj = [[RACSubject subject] setNameWithFormat:@"retrysubj"];

    RACSignal *s = [self retryingSignalWithValue:channelConn.signal
                                           retry:self.retrySubj
                                   retryInterval:connectionThresholdSignal];

    [channelConn connect];

    RACSignal *player = [[s map:^id(Channel *c) {
        AVPlayer *p = [AVPlayer playerWithURL:c.playbackURL];

        [[p rac_signalForSelector:@selector(pause)] subscribeNext:^(id x) {
            self.viewModel.userPaused = YES;
        }];

        [[p rac_signalForSelector:@selector(play)] subscribeNext:^(id x) {
            self.viewModel.userPaused = NO;
        }];

#if DEBUG
        [self startLogging];
#endif
        @weakify(p)
        [[[p rac_signalForSelector:@selector(pause)] delay:10] subscribeNext:^(id x) {
            @strongify(p)
            if(p.rate == 0){
                [self stop];
            }
        }];

        [p play];

        return p;
    }] merge:[[self rac_signalForSelector:@selector(stop)] map:^id(id value) {
        return nil;
    }]];

    // We subscribe to this several times, so multicast it!
    RACMulticastConnection *playerConnection = [player publish];

    // Necessary to RAC it, to keep it alive for some reason ...

    RAC(self,player) = playerConnection.signal;
    RACSignal *currentItem = [[playerConnection.signal map:^id(AVPlayer *p) {
        return p.currentItem;
    }] setNameWithFormat:@"currentItem"];

    RACSignal *likelyToKeepUp = [currentItem flattenMap:^RACStream *(AVPlayerItem *item) {
        return [item rac_valuesForKeyPath:@"playbackLikelyToKeepUp" observer:item];
    }];


    RACSignal *playing = [playerConnection.signal map:^id(AVPlayer *p) {
        return @(p != nil && p.rate > 0);
    }];

    [playerConnection connect];

    RACSignal *keepAlive = [[[[RACSignal combineLatest:@[
            playing,
            likelyToKeepUp,

    ]] map:^id(RACTuple *tuple) {
        RACTupleUnpack(NSNumber *playing, NSNumber *keepUp) = tuple;
        return playing.boolValue ? @(!keepUp.boolValue) : @NO;
    }] distinctUntilChanged] setNameWithFormat:@"retry?"];

    [keepAlive subscribeNext:^(NSNumber *b) {
        if(b.boolValue){
            [self keepAlive];
        } else {
            [self stopKeepAlive];
        };

        [self.retrySubj sendNext:b];
    }];

}

- (void)startLogging {

    [[RACSignal interval:4 onScheduler:[RACScheduler currentScheduler]] subscribeNext:^(id x) {
        NSLog(@"%@",(__bridge NSString *)CMTimeCopyDescription(NULL, self.player.currentTime));
    }];

    [@[@"status", @"rate", @"currentItem", @"error", @"currentTime"] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [[self.player rac_valuesForKeyPath:obj observer:self.player] subscribeNext:^(id x) {
            NSLog(@"%@: %@",obj,x);
        }];
    }];

    [@[@"error", @"status", @"playbackBufferEmpty", @"playbackBufferFull", @"playbackLikelyToKeepUp"] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [[self.player.currentItem rac_valuesForKeyPath:obj
                                              observer:self.player.currentItem] subscribeNext:^(id x) {
            NSLog(@"currentItem %@: %@",obj,x);
        }];
    }];


    [[RACObserve(self.player.currentItem, loadedTimeRanges) map:^id(NSArray *timeranges) {
        CMTimeRange range = [timeranges.firstObject CMTimeRangeValue];
        return @(CMTimeGetSeconds(range.duration));
    }] subscribeNext:^(id x) {
        NSLog(@"duration: %@",x);
    }];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // For signaling

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 65.0f;
}


- (void)stop
{
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];

}

#pragma mark spot

// TODO - move out

- (void)addTrack:(Track *)track usingRemote:(BOOL)usingRemote {
    self.viewModel.talkingToSpotify = YES;
    NSString *searchQuery = [NSString stringWithFormat:@"%@ %@",track.artist,track.title];


    NSString *playlistName = kPlaylistName;

    #if DEBUG && CREATE_RANDOM_PLAYLIST

    playlistName = [NSString stringWithFormat:@"RS_%d", arc4random()];

    #endif

    RACSignal *playlist = [[self.btfSpotify playlistWithName:playlistName] catch:^RACSignal *(NSError *error) {
        return [[self.btfSpotify createPlaylist:playlistName] flattenMap:^RACStream *(id value) {
            return [self.btfSpotify playlistWithName:playlistName];
        }];
    }];
    RACSignal *trackAdded = [[self.btfSpotify search:searchQuery] flattenMap:^RACStream *(SPSearch *search) {
        return [playlist flattenMap:^RACStream *(SPPlaylist *playlist1) {
            if(search.tracks.firstObject){
                return [self.btfSpotify addItem:search.tracks.firstObject
                                     toPlaylist:playlist1
                                        atIndex:0];
            } else {
                NSString *string = NSLocalizedString(@"NoResultsMessage", @"No results");
                NSError *error = [NSError errorWithDomain:@"btf.dr-ng" code:kRadioSpotNoResults
                                                 userInfo:@{
                                                         NSLocalizedDescriptionKey: string}];
                return [RACSignal error:error];
            }
        }];
    }];

    BOOL playSound = usingRemote || [[UIApplication sharedApplication] applicationState] == UIApplicationStateBackground;
    [trackAdded subscribeNext:^(id x) {
        NSString *info = [NSString stringWithFormat:NSLocalizedString(@"AddedTrackTitle", @"Added track to playlist '%@'"),
                                                    playlistName];
        [self.messageView showTextBriefly:info];
        [self.playerView.addToSpotBtn showStatus:ButtonStatusSuccess];
        if (playSound) {
            NSURL *url = [[NSBundle mainBundle] URLForResource:@"success" withExtension:@"wav"];
            [self playSound:url];
        }
        self.viewModel.talkingToSpotify = NO;
        self.viewModel.tracksAdded++;
        if (!self.viewModel.didAddUsingRemove && (self.viewModel.tracksAdded == 3 || self.viewModel.tracksAdded % 20 == 0)) {
            [self showOverlay];
        }

    }                   error:^(NSError *error) {
        [self.messageView showTextBriefly:[error localizedDescription]];

        BOOL notFound = error.code == kRadioSpotNoResults;
        if(notFound){
            [self.playerView.addToSpotBtn showStatus:ButtonStatusNotFound];
        } else {
            [self.playerView.addToSpotBtn showStatus:ButtonStatusFail];

        }

        if (playSound) {
            NSURL *url = [[NSBundle mainBundle] URLForResource:@"fail" withExtension:@"wav"];
            [self playSound:url];
        }
        NSLog(@"%@", error);
        self.viewModel.talkingToSpotify = NO;
    }];

}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (void)playSound:(NSURL *)url {
    NSError *error;
    self.spotifyAddingSuccessPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url
                                                                             error:&error];
    [self.spotifyAddingSuccessPlayer play];
}

- (void)remoteControlReceivedWithEvent:(UIEvent *)event
{
    // For signaling
}



// value: a signal with values
// retry: a signal with retry yes/no
// retryInterval: a signal with the retry interval
- (RACSignal*)retryingSignalWithValue:(RACSignal *)value
                                retry:(RACSignal *)retry
                        retryInterval:(RACSignal *)interval
{
    RACSignal *retryThres = [retry combineLatestWith:interval];
    RACMulticastConnection *connection = [retryThres publish];

    RACSignal *s = [[connection.signal map:^id(RACTuple *t) {
        return [t.first boolValue] ? t.second : nil;
    }] ignore:nil];


    RACSignal *retryRepeat = [s flattenMap:^RACStream *(NSNumber *t) {
        return [[RACSignal interval:t.doubleValue onScheduler:[RACScheduler currentScheduler]] takeUntil:connection.signal];
    }];

    [connection connect];

    RACSignal *retryBlock = [retryRepeat map:^id(id _) {
        return ^NSNumber*(NSNumber *x){
            return x;
        };
    }];

    RACSignal *valueBlock = [value map:^id(NSNumber *val) {
        return ^NSNumber *(id _){
            return val;
        };
    }];

    return [[valueBlock merge:retryBlock]
            scanWithStart:@1
                   reduce:^id(NSNumber *running, NSNumber *(^next)(NSNumber *)) {
                       return next(running);
                   }];
}

@end