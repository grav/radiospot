//
//  DRPConstants.h
//  DR Player
//
//  Created by Richard Nees on 06/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

extern NSString * const DRPRemoteResourcesURLString;
extern NSString * const DRPAppcastReleaseURLString;
extern NSString * const DRPAppcastBetaURLString;
extern NSString * const DRPCompanyWebHomeURLString;
extern NSString * const DRPCompanyTwitterURLString;

extern NSString * const DRPTelevisionHighQualityStreamURLFormatString;
extern NSString * const DRPTelevisionMediumQualityStreamURLFormatString;
extern NSString * const DRPTelevisionLowQualityStreamURLFormatString;
extern NSString * const DRPRadioHighQualityStreamURLFormatString;
extern NSString * const DRPRadioMediumQualityStreamURLFormatString;
extern NSString * const DRPRadioLowQualityStreamURLFormatString;

extern NSString * const DRPListingsXMLTypeURLFormatString;
extern NSString * const DRPListingsJSONTypeURLFormatString;

extern NSString * const DRPlayerPlaybackInternalStart;
extern NSString * const DRPlayerPlaybackInternalStop;
extern NSString * const DRPlayerPlaybackStart;
extern NSString * const Radio24SyvPlaybackStart;

extern NSString * const UpdateMenuProgressString;
extern NSString * const ChannelUpdateOperationDidFinish;
extern NSString * const ChannelIconUpdateOperationDidFinish;
extern NSString * const ListingUpdateOperationDidFinish;

extern NSString * const DRPDefaultsSelectionViewRadioAutoHide;
extern NSString * const DRPDefaultsViewerDisplayManually;
extern NSString * const DRPDefaultsHiddenStatusItem;
extern NSString * const DRPDefaultsSelectedChannelTagKey;

extern NSString * const DRPMainWindowMovieQuality;
extern NSString * const DRPMainWindowVolume;
extern NSString * const DRPMainWindowLevel;

extern NSString * const DRPLastDate;

extern NSString * const DRPListings;

//extern NSString * const DRPProgramListingsType;

typedef NS_ENUM(NSInteger, DRPProgramListingsType) {
	DRPProgramListingsTypeNone              = 1,
	DRPProgramListingsTypeXML               = 2,
	DRPProgramListingsTypeJSON              = 3
};

extern NSString * const DRPProgramListingsSourceURLString;
extern NSString * const DRPProgramListingItemsArray;

enum {
	DRPMainWindowSizeActual                 = 1,
	DRPMainWindowSizeDouble                 = 2,
	DRPMainWindowSizeFitToScreen            = 3
};





