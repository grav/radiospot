//
// Created by Mikkel Gravgaard on 27/12/14.
// Copyright (c) 2014 Betafunk. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSInteger,PlaylistReaderType){
    PlaylistReaderTypeDummy,
    PlaylistReaderTypeDR,
    PlaylistReaderTypeRadioPlay,
};

@interface Channel : NSObject
@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, copy) NSString *broadcaster;
@property (nonatomic, readonly) NSString *channelId;
@property (nonatomic, readonly) PlaylistReaderType  playlistReaderType;
@property (nonatomic, readonly) NSURL *playbackURL;

+ (instancetype)channelWithName:(NSString *)name channelId:(NSString *)channelId readerType:(PlaylistReaderType)readerType urlString:(NSString *)urlString broadcaster:(NSString *)broadcaster;

@end