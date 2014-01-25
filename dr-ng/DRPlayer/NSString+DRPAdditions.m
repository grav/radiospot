//
//  NSString+DRPAdditions.m
//  DR Player
//
//  Created by Richard Nees on 26/03/2013.
//
//

#import "NSString+DRPAdditions.h"
#import "DRPConstants.h"
#import "NSAttributedString+DRPAdditions.h"

@implementation NSString (DRPAdditions)

+ (NSString *)remoteResourcesURLString
{
    return [NSString stringWithFormat:@"%@%@/", DRPRemoteResourcesURLString, [[NSBundle mainBundle] infoDictionary][@"DRPChannelResourcesVersion"]];
}

+ (NSString *)appSupportPath
{
    NSFileManager *manager = [NSFileManager defaultManager];
    
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:[[[NSBundle mainBundle] executablePath] lastPathComponent]];
    
    NSString *versionPath = [path stringByAppendingPathComponent:[[NSBundle mainBundle] infoDictionary][@"DRPChannelResourcesVersion"]];
    
    if (![manager fileExistsAtPath:versionPath])
        [manager createDirectoryAtPath:versionPath withIntermediateDirectories:YES attributes:nil error:nil];
    
    
    return versionPath;
}

+ (NSString *)channelsPlistPath
{
    return [[NSString appSupportPath] stringByAppendingPathComponent:@"ChannelsStore.plist"];
}

+ (NSString *)listingsPlistPath
{
    return [[NSString appSupportPath] stringByAppendingPathComponent:@"ListingsStore.plist"];
}

+ (NSString *)channelIconDirectoryPath
{
    NSFileManager *manager = [NSFileManager defaultManager];
    
    NSString *path = [[NSString appSupportPath] stringByAppendingPathComponent:@"ChannelIcons"];
    
    if (![manager fileExistsAtPath:path])
        [manager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    
    
    return path;
}

- (NSAttributedString *)progressAttributedString
{
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:self
                                                                           attributes:[NSAttributedString darkTextStyleAttributesForFontSize:9.0f textAlignment:NSTextAlignmentLeft]
                                            ];
    return attributedString;
}

@end
