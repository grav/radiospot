//
//  NSString+DRPAdditions.h
//  DR Player
//
//  Created by Richard Nees on 26/03/2013.
//
//

#import <Foundation/Foundation.h>

@interface NSString (DRPAdditions)

+ (NSString *)remoteResourcesURLString;
+ (NSString *)appSupportPath;
+ (NSString *)channelsPlistPath;
+ (NSString *)listingsPlistPath;
+ (NSString *)channelIconDirectoryPath;

- (NSAttributedString *)progressAttributedString;

@end
