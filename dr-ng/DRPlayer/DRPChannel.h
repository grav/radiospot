//
//  DRPChannel.h
//  DR Player
//
//  Created by Richard on 06/01/14.
//
//

#import <Foundation/Foundation.h>
#import "DRPConstants.h"
extern NSString * const DRPChannelsKey;

typedef NS_ENUM(NSInteger, DRPChannelType) {
	DRPChannelTelevisionType                = 1,
	DRPChannelRadioType                     = 2
};

extern NSString * const DRPChannelTypeKey;
extern NSString * const DRPChannelProgramListingsTypeKey;
extern NSString * const DRPChannelTagKey;
extern NSString * const DRPChannelIdentifierKey;
extern NSString * const DRPChannelStreamIdentifierKey;
extern NSString * const DRPChannelNameKey;
extern NSString * const DRPChannelTintColorKey;
extern NSString * const DRPChannelIconRemoteURLKey;
extern NSString * const DRPChannelIconLocalURLKey;

extern NSString * const DRPChannelStreamQualityHighURLKey;
extern NSString * const DRPChannelStreamQualityMediumURLKey;
extern NSString * const DRPChannelStreamQualityLowURLKey;

@interface DRPChannel : NSObject <NSCoding>
@property (nonatomic)         DRPChannelType            type;
@property (nonatomic)         DRPProgramListingsType    listingsType;
@property (nonatomic)         NSInteger                 tag;
@property (nonatomic, strong) NSString                  *identifier;
@property (nonatomic, strong) NSString                  *streamIdentifier;
@property (nonatomic, strong) NSString                  *name;
@property (nonatomic, strong) UIColor                   *tintColor;
@property (nonatomic, strong) NSURL                     *iconRemoteURL;
@property (nonatomic, strong) NSURL                     *iconLocalURL;

@property (nonatomic, strong) NSURL                     *streamQualityHighURL;
@property (nonatomic, strong) NSURL                     *streamQualityMediumURL;
@property (nonatomic, strong) NSURL                     *streamQualityLowURL;

@end
