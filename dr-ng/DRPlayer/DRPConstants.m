//
//  DRPConstants.m
//  DR Player
//
//  Created by Richard Nees on 06/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DRPConstants.h"

NSString * const DRPRemoteResourcesURLString                        = @"https://dl.dropboxusercontent.com/u/2684971/Software/DRPlayer/Dynamic/";
NSString * const DRPAppcastReleaseURLString                         = @"https://dl.dropboxusercontent.com/u/2684971/Software/DRPlayer/Appcast/DRPlayer.xml";
NSString * const DRPAppcastBetaURLString                            = @"https://dl.dropboxusercontent.com/u/2684971/Software/DRPlayer/Appcast/DRPlayerBeta.xml";
NSString * const DRPCompanyWebHomeURLString                         = @"https://dl.dropboxusercontent.com/u/2684971/Software/DRPlayer/index.html";
NSString * const DRPCompanyTwitterURLString                         = @"http://twitter.com/drplayermac";

NSString * const DRPTelevisionHighQualityStreamURLFormatString      = @"http://lm.gss.dr.dk/V/%@H.stream/Playlist.m3u8";
NSString * const DRPTelevisionMediumQualityStreamURLFormatString    = @"http://lm.gss.dr.dk/V/%@M.stream/Playlist.m3u8";
NSString * const DRPTelevisionLowQualityStreamURLFormatString       = @"http://lm.gss.dr.dk/V/%@L.stream/Playlist.m3u8";
NSString * const DRPRadioHighQualityStreamURLFormatString           = @"http://ahls.gss.dr.dk/A/%@H.stream/Playlist.m3u8";
NSString * const DRPRadioMediumQualityStreamURLFormatString         = @"http://ahls.gss.dr.dk/A/%@H.stream/Playlist.m3u8";
NSString * const DRPRadioLowQualityStreamURLFormatString            = @"http://ahls.gss.dr.dk/A/%@L.stream/Playlist.m3u8";

NSString * const DRPListingsXMLTypeURLFormatString                  = @"http://www.dr.dk/Tjenester/epglive/epg.%@.drxml";
NSString * const DRPListingsJSONTypeURLFormatString                 = @"http://www.dr.dk/tjenester/programoversigt/dbservice.ashx/getschedule?channel_source_url=dr.dk/mas/whatson/channel/%@&broadcastDate=";

NSString * const DRPlayerPlaybackInternalStart                      = @"DRPlayerPlaybackInternalStart";
NSString * const DRPlayerPlaybackInternalStop                       = @"DRPlayerPlaybackInternalStop";
NSString * const DRPlayerPlaybackStart                              = @"DRPlayerPlaybackStart";
NSString * const Radio24SyvPlaybackStart                            = @"Radio24SyvPlaybackStart";

NSString * const UpdateMenuProgressString                           = @"UpdateMenuProgressString";
NSString * const ChannelUpdateOperationDidFinish                    = @"ChannelUpdateOperationDidFinish";
NSString * const ChannelIconUpdateOperationDidFinish                = @"ChannelIconUpdateOperationDidFinish";
NSString * const ListingUpdateOperationDidFinish                    = @"ListingUpdateOperationDidFinish";

NSString * const DRPDefaultsSelectionViewRadioAutoHide              = @"DRPDefaultsSelectionViewRadioAutoHide";
NSString * const DRPDefaultsViewerDisplayManually                   = @"DRPDefaultsViewerDisplayManually";
NSString * const DRPDefaultsHiddenStatusItem                        = @"DRPDefaultsHiddenStatusItem";
NSString * const DRPDefaultsSelectedChannelTagKey                   = @"DRPDefaultsSelectedChannelTagKey";

NSString * const DRPMainWindowMovieQuality                          = @"DRPMainWindowMovieQuality";
NSString * const DRPMainWindowVolume                                = @"DRPMainWindowVolume";
NSString * const DRPMainWindowLevel                                 = @"DRPMainWindowLevel";

NSString * const DRPLastDate                                        = @"DRPLastDate";

NSString * const DRPListings                                        = @"DRPListings";
//NSString * const DRPProgramListingsType                             = @"DRPProgramListingsType";
NSString * const DRPProgramListingsSourceURLString                  = @"DRPProgramListingsSourceURLString";
NSString * const DRPProgramListingItemsArray                        = @"DRPProgramListingItemsArray";
NSString * const DRPPlaylistItemsArray                              = @"DRPPlaylistItemsArray";


