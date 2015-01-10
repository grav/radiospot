//
// Created by Mikkel Gravgaard on 10/01/15.
// Copyright (c) 2015 Betafunk. All rights reserved.
//

#import "Reachability.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import "ConnectionThresholdCalculator.h"

static NSInteger Slow = 50;
static NSInteger Semi = 10;
static NSInteger Fast = 5;

@implementation ConnectionThresholdCalculator {

}
+ (NSInteger)currentConnectionThreshold
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus status = reachability.currentReachabilityStatus;
    if(status==NotReachable) return Slow;

    if(status==ReachableViaWiFi) return Fast;


    BOOL iOS6 = floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1;
    if(iOS6){
        // We don't know if it's gprs, edge or 3g
        return Slow;
    } else {

#pragma clang diagnostic push
#pragma ide diagnostic ignored "UnavailableInDeploymentTarget"
        NSString *cellularType = [CTTelephonyNetworkInfo new].currentRadioAccessTechnology;

        NSArray *slowTypes = @[CTRadioAccessTechnologyGPRS,CTRadioAccessTechnologyEdge];
#pragma clang diagnostic pop

        // CoreTelephony stuff
        BOOL slow = [slowTypes containsObject:cellularType];
        return slow ? Slow : Semi;
    }


}
@end