//
//  DRPChannelUpdateOperation.m
//  DR Player
//
//  Created by Richard Nees on 06/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DRPChannelUpdateOperation.h"
#import "DRPConstants.h"
#import "NSString+DRPAdditions.h"
#import "DRPChannel.h"
#import "UIColor+DRPAdditions.h"

@implementation DRPChannelUpdateOperation

// NSNotification name to tell the Window controller an image file as found

// -------------------------------------------------------------------------------
//	initWithItem:item
// -------------------------------------------------------------------------------
-(id)init
{
	self = [super init];
    return self;
}

// -------------------------------------------------------------------------------
//	dealloc:
// -------------------------------------------------------------------------------
- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] postNotificationName:ChannelUpdateOperationDidFinish object:self.channelArray userInfo:nil];
}

// -------------------------------------------------------------------------------
//	main:
//
// -------------------------------------------------------------------------------
-(void)main
{
    @autoreleasepool
    {
    	if (![self isCancelled])
        {
            NSURL *url = [[NSURL URLWithString:[NSString remoteResourcesURLString]] URLByAppendingPathComponent:@"DRPChannels.plist"];
            NSMutableDictionary *streamDict = [NSMutableDictionary dictionaryWithContentsOfURL:url];
            
            if (streamDict)
            {
                NSArray *sourceArray = streamDict[DRPChannelsKey];
                self.channelArray = [NSMutableArray arrayWithCapacity:sourceArray.count];
                
                for (NSDictionary *channelInfo in sourceArray)
                {
                    DRPChannel *newChannel = [[DRPChannel alloc] init];
                    
                    newChannel.type             = [channelInfo[DRPChannelTypeKey] integerValue];
                    newChannel.listingsType     = [channelInfo[DRPChannelProgramListingsTypeKey] integerValue];
                    newChannel.tag              = [channelInfo[DRPChannelTagKey] integerValue];
                    newChannel.identifier       = channelInfo[DRPChannelIdentifierKey];
                    newChannel.streamIdentifier = channelInfo[DRPChannelStreamIdentifierKey];
                    newChannel.name             = channelInfo[DRPChannelNameKey];
                    newChannel.tintColor        = [UIColor colorFromHexRGB: channelInfo[DRPChannelTintColorKey] ? channelInfo[DRPChannelTintColorKey]:[UIColor clearColor]];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:UpdateMenuProgressString
                                                                        object:nil
                                                                      userInfo:@{@"statusString": [NSString localizedStringWithFormat:@"Henter %@…", newChannel.name]}];
                    
                    switch (newChannel.type) {
                        case DRPChannelTelevisionType:
                            
                            newChannel.streamQualityHighURL = [NSURL URLWithString:[NSString stringWithFormat:DRPTelevisionHighQualityStreamURLFormatString, newChannel.streamIdentifier]];
                            newChannel.streamQualityMediumURL = [NSURL URLWithString:[NSString stringWithFormat:DRPTelevisionMediumQualityStreamURLFormatString, newChannel.streamIdentifier]];
                            newChannel.streamQualityLowURL = [NSURL URLWithString:[NSString stringWithFormat:DRPTelevisionLowQualityStreamURLFormatString, newChannel.streamIdentifier]];
                            
                            break;
                            
                        case DRPChannelRadioType:
                            
                            newChannel.streamQualityHighURL = [NSURL URLWithString:[NSString stringWithFormat:DRPRadioHighQualityStreamURLFormatString, newChannel.streamIdentifier]];
                            newChannel.streamQualityMediumURL = [NSURL URLWithString:[NSString stringWithFormat:DRPRadioMediumQualityStreamURLFormatString, newChannel.streamIdentifier]];
                            newChannel.streamQualityLowURL = [NSURL URLWithString:[NSString stringWithFormat:DRPRadioLowQualityStreamURLFormatString, newChannel.streamIdentifier]];
                            
                            break;
                            
                        default:
                            break;
                    }
                    
                    newChannel.iconRemoteURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@Resources/%@/Logo.tiff", [NSString remoteResourcesURLString], @(newChannel.tag)]];
                    
                    NSString *destinationPath = [[[NSString channelIconDirectoryPath] stringByAppendingPathComponent:[@(newChannel.tag) stringValue]] stringByAppendingPathExtension:@"tiff"];
                    newChannel.iconLocalURL = [NSURL fileURLWithPath:destinationPath];
                    
                    
                    NSURLRequest *request = [NSURLRequest requestWithURL:newChannel.iconRemoteURL];
                    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
                    
                    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
                    
                    NSURLSessionDownloadTask *downloadTask
                    = [session downloadTaskWithRequest:request
                                     completionHandler:
                       ^(NSURL *location, NSURLResponse *response, NSError *error)
                       {
                           if (error)
                           {
                               NSLog(@"error %@", error);
                           }
                           else
                           {
                               [[NSFileManager defaultManager] removeItemAtURL:newChannel.iconLocalURL error:nil];
                               [[NSFileManager defaultManager] moveItemAtURL:location toURL:newChannel.iconLocalURL error:nil];
                               
                               [[NSNotificationCenter defaultCenter] postNotificationName:ChannelIconUpdateOperationDidFinish object:nil userInfo:nil];

                           }
                       }];
                    
                    [downloadTask resume];
                    
                    [self.channelArray addObject:newChannel];
                    NSLog(@"%@",newChannel);
                }
            }
        }
    }
}

@end
