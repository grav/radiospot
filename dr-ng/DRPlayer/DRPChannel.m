//
//  DRPChannel.m
//  DR Player
//
//  Created by Richard on 06/01/14.
//
//

NSString * const DRPChannelsKey                        = @"channels";
NSString * const DRPChannelTypeKey                     = @"type";
NSString * const DRPChannelProgramListingsTypeKey      = @"listingsType";
NSString * const DRPChannelTagKey                      = @"tag";
NSString * const DRPChannelIdentifierKey               = @"identifier";
NSString * const DRPChannelStreamIdentifierKey         = @"streamIdentifier";
NSString * const DRPChannelNameKey                     = @"name";
NSString * const DRPChannelTintColorKey                = @"tintColor";
NSString * const DRPChannelIconRemoteURLKey            = @"iconRemoteURL";
NSString * const DRPChannelIconLocalURLKey             = @"iconLocalURL";

NSString * const DRPChannelStreamQualityHighURLKey     = @"streamQualityHighURL";
NSString * const DRPChannelStreamQualityMediumURLKey   = @"streamQualityMediumURL";
NSString * const DRPChannelStreamQualityLowURLKey      = @"streamQualityLowURL";

#import "DRPChannel.h"

@implementation DRPChannel

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self)
    {
        self.type                   = [[aDecoder decodeObjectForKey:DRPChannelTypeKey] integerValue];
        self.listingsType           = [[aDecoder decodeObjectForKey:DRPChannelProgramListingsTypeKey] integerValue];
        self.tag                    = [[aDecoder decodeObjectForKey:DRPChannelTagKey] integerValue];
        self.identifier             = [aDecoder decodeObjectForKey:DRPChannelIdentifierKey];
        self.streamIdentifier       = [aDecoder decodeObjectForKey:DRPChannelStreamIdentifierKey];
        self.name                   = [aDecoder decodeObjectForKey:DRPChannelNameKey];
        self.tintColor              = [aDecoder decodeObjectForKey:DRPChannelTintColorKey];
        self.iconRemoteURL          = [aDecoder decodeObjectForKey:DRPChannelIconRemoteURLKey];
        self.iconLocalURL           = [aDecoder decodeObjectForKey:DRPChannelIconLocalURLKey];
        self.streamQualityHighURL   = [aDecoder decodeObjectForKey:DRPChannelStreamQualityHighURLKey];
        self.streamQualityMediumURL = [aDecoder decodeObjectForKey:DRPChannelStreamQualityMediumURLKey];
        self.streamQualityLowURL    = [aDecoder decodeObjectForKey:DRPChannelStreamQualityLowURLKey];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:@(self.type)                   forKey:DRPChannelTypeKey];
    [aCoder encodeObject:@(self.listingsType)           forKey:DRPChannelProgramListingsTypeKey];
    [aCoder encodeObject:@(self.tag)                    forKey:DRPChannelTagKey];
    [aCoder encodeObject:self.identifier                forKey:DRPChannelIdentifierKey];
    [aCoder encodeObject:self.streamIdentifier          forKey:DRPChannelStreamIdentifierKey];
    [aCoder encodeObject:self.name                      forKey:DRPChannelNameKey];
    [aCoder encodeObject:self.tintColor                 forKey:DRPChannelTintColorKey];
    [aCoder encodeObject:self.iconRemoteURL             forKey:DRPChannelIconRemoteURLKey];
    [aCoder encodeObject:self.iconLocalURL              forKey:DRPChannelIconLocalURLKey];
    [aCoder encodeObject:self.streamQualityHighURL      forKey:DRPChannelStreamQualityHighURLKey];
    [aCoder encodeObject:self.streamQualityMediumURL    forKey:DRPChannelStreamQualityMediumURLKey];
    [aCoder encodeObject:self.streamQualityLowURL       forKey:DRPChannelStreamQualityLowURLKey];
}
@end
