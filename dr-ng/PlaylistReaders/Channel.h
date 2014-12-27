//
// Created by Mikkel Gravgaard on 27/12/14.
// Copyright (c) 2014 Betafunk. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSInteger,PlaylistReaderType){
    PlaylistReaderTypeDR,
    PlaylistReaderTypeRadioPlay
};

@interface Channel : NSObject
@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, readonly) id channelId;
@property (nonatomic, readonly) PlaylistReaderType  playlistReaderType;
@property (nonatomic, readonly) NSURL *playbackURL;

Channel *MakeChannel(NSString *name, id channelId, PlaylistReaderType readerType, NSString *urlString);

@end