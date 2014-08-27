//
//  Created by Ole Gammelgaard Poulsen on 23/06/14.
//  Copyright (c) 2014 SHAPE A/S. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Notifications)

- (RACSignal *)rac_notifyUntilDealloc:(NSString *)notificationName;

@end