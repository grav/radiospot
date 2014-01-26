//
//  DNGAppDelegate.m
//  dr-ng
//
//  Created by Mikkel Gravgaard on 20/01/14.
//  Copyright (c) 2014 Betafunk. All rights reserved.
//

#import "DNGAppDelegate.h"
#import "CocoaLibSpotify.h"
#import "PlayerViewController.h"
@interface DNGAppDelegate ()
@property(nonatomic, copy) NSString *html;
@end

@implementation DNGAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    UIViewController *vc = [[PlayerViewController alloc] init];
    self.window.rootViewController = vc;
    vc.view.frame = self.window.bounds;

//    NSString *jsonString = @"{\"serverTime\":\"2014-01-26T08:35:56\",\"tracks\":[{\"artist\":\"Claus Waidtløw Quartet\",\"artistId\":\"5024368\",\"displayArtist\":\"Claus Waidtløw Quartet\",\"genre\":\"Jazz\",\"lastFM\":\"\",\"recordedYear\":\"2012\",\"releaseYear\":\"2013\",\"start\":\"2014-01-26T08:32:27\",\"title\":\"Sightseeing\",\"trackId\":\"2372984-1-4\",\"workTitle\":null},{\"artist\":\"John Coltrane\",\"artistId\":\"14957\",\"displayArtist\":\"John Coltrane\",\"genre\":null,\"lastFM\":\"\",\"recordedYear\":\"1962\",\"releaseYear\":\"Ukendt år\",\"start\":\"2014-01-26T08:28:14\",\"title\":\"In A Sentimental Mood\",\"trackId\":\"2236172-1-11\",\"workTitle\":null},{\"artist\":\"DR Big Bandet\",\"artistId\":\"164950\",\"displayArtist\":\"DR Big Bandet & Etta Cameron\",\"genre\":\"Jazz\",\"lastFM\":\"\",\"recordedYear\":\"2003\",\"releaseYear\":\"2003\",\"start\":\"2014-01-26T08:24:42\",\"title\":\"Time's gettin' tougher than tough\",\"trackId\":\"2338173-1-7\",\"workTitle\":null},{\"artist\":\"Kjeld Lauritsen\",\"artistId\":\"149185\",\"displayArtist\":\"Kjeld Lauritsen, Espen Laub von Lillienskjold & Jan Harbeck\",\"genre\":\"Jazz\",\"lastFM\":\"\",\"recordedYear\":\"2013\",\"releaseYear\":\"2013\",\"start\":\"2014-01-26T08:19:08\",\"title\":\"Salvation\",\"trackId\":\"2374562-1-3\",\"workTitle\":null},{\"artist\":\"Jimmy Scott\",\"artistId\":\"50868\",\"displayArtist\":\"Jimmy Scott\",\"genre\":null,\"lastFM\":\"\",\"recordedYear\":\"2000\",\"releaseYear\":\"Ukendt år\",\"start\":\"2014-01-26T08:14:55\",\"title\":\"There Will Never Be Another You\",\"trackId\":\"2315072-1-5\",\"workTitle\":null}]}";
//
//    id obj = [jsonString objectFromJSONString];

//    NSLog(@"%@",obj);
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.

}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.

}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.

}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.

}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.

}

@end