//
//  DNGAppDelegate.m
//  dr-ng
//
//  Created by Mikkel Gravgaard on 20/01/14.
//  Copyright (c) 2014 Betafunk. All rights reserved.
//

#import "DNGAppDelegate.h"
#import "ReactiveCocoa.h"
#import "HTMLReader.h"

static NSString *const kURL = @"http://www.dr.dk/playlister/p6beat/2014-1-20";
static NSString *const kTime = @".track time";
static NSString *const kTrackName = @".track .trackInfo a";
static NSString *const kArtist = @".track .name";

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

    NSError *error;
    self.html = [NSString stringWithContentsOfURL:[NSURL URLWithString:kURL] encoding:kCFStringEncodingUTF8 error:&error];
    NSCAssert(!error, @"error: %@",error);

    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 60, self.window.frame.size.width, 50)];
    textField.backgroundColor = [UIColor yellowColor] ;
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    [self.window addSubview:textField];

    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 120,100,50)];
    btn.backgroundColor = [UIColor greenColor];
    [btn setTitle:@"eval" forState:UIControlStateNormal];
    [self.window addSubview:btn];

    btn.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        HTMLDocument *document = [HTMLDocument documentWithString:self.html];
        @try {
            NSArray *array = [document nodesMatchingSelector:textField.text];
            NSLog(@"%@ returned %d nodes:",textField.text, array.count);
            [array enumerateObjectsUsingBlock:^(HTMLElementNode *node, NSUInteger idx, BOOL *stop) {
                NSLog(@"%@",node.innerHTML);
            }];

        } @catch(NSException *e) {
            NSLog(@"error: %@",e);
        }

        return [RACSignal empty];
    }];

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