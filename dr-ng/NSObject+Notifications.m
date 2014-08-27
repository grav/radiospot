//
//  Created by Ole Gammelgaard Poulsen on 23/06/14.
//  Copyright (c) 2014 SHAPE A/S. All rights reserved.
//

#import "NSObject+Notifications.h"

@implementation NSObject (Notifications)

- (RACSignal *)rac_notifyUntilDealloc:(NSString *)notificationName {
	NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
	return [[notificationCenter rac_addObserverForName:notificationName object:nil] takeUntil:[self rac_willDeallocSignal]];
}

@end