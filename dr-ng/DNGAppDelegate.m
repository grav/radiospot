//
//  DNGAppDelegate.m
//  dr-ng
//
//  Created by Mikkel Gravgaard on 20/01/14.
//  Copyright (c) 2014 Betafunk. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "DNGAppDelegate.h"
#import "CocoaLibSpotify.h"
#import "PlayerViewController.h"
#import <Crashlytics/Crashlytics.h>
#import "RadioPlay.h"

@implementation DNGAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self setupAudio];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    UIViewController *playerViewController = [[PlayerViewController alloc] init];
    playerViewController.title = NSLocalizedString(@"AppWindowTitle", @"Stations");
    playerViewController.view.frame = [[UIScreen mainScreen] applicationFrame];
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:playerViewController];

    [Crashlytics startWithAPIKey:@"37ecf2e16614ae477adcbd790499b5a4b406f88c"];
    return YES;
}

- (void)setupAudio {
    NSError *setCategoryErr = nil;
    NSError *activationErr  = nil;
    [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayback error:&setCategoryErr];
    [[AVAudioSession sharedInstance] setActive:YES error:&activationErr];
    NSCAssert(!setCategoryErr && !activationErr,@"");
}


- (void)updateOnClassInjection
{
    [[RadioPlay currentPlaylists] subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
}

@end