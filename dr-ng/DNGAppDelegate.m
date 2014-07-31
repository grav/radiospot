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
@interface DNGAppDelegate ()
@property(nonatomic, copy) NSString *html;
@property(nonatomic, strong) AVAudioPlayer *bgKeepAlivePlayer;
@property(nonatomic, strong) PlayerViewController *playerViewController;
@end

@implementation DNGAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self setupAudio];

    NSURL *audioFileLocationURL = [[NSBundle mainBundle] URLForResource:@"nobeep" withExtension:@"wav"];
    NSError *error;
    self.bgKeepAlivePlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:audioFileLocationURL error:&error];
    NSCAssert(!error, @"Audio loading error: %@", error);
    self.bgKeepAlivePlayer.numberOfLoops = -1;
    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    self.playerViewController = [[PlayerViewController alloc] init];
    self.playerViewController.title = @"Stations";
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:self.playerViewController];
    self.playerViewController.view.frame = [[UIScreen mainScreen] applicationFrame];

    return YES;
}

- (void)setupAudio {
    NSError *setCategoryErr = nil;
    NSError *activationErr  = nil;
    [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayback error:&setCategoryErr];
    [[AVAudioSession sharedInstance] setActive:YES error:&activationErr];
    NSCAssert(!setCategoryErr && !activationErr,@"");
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    if([self.playerViewController isPlaying]){
        [self.bgKeepAlivePlayer play];
    }

}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [self.bgKeepAlivePlayer stop];

}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [self setupAudio];

}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.

}

@end