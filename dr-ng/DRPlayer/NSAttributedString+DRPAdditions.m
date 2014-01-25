//
//  NSAttributedString+DRPAdditions.m
//  DR Player
//
//  Created by Richard Nees on 26/03/2013.
//
//

#import "NSAttributedString+DRPAdditions.h"

@implementation NSAttributedString (DRPAdditions)

+ (NSDictionary *)darkTextStyleAttributesForFontSize:(CGFloat)fontSize textAlignment:(NSTextAlignment)alignment
{
    NSMutableParagraphStyle *pStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
	[pStyle setAlignment:alignment];
    
	NSDictionary *styleDictionary = @{NSForegroundColorAttributeName: [UIColor colorWithWhite:0.0f alpha:0.8f],
                                      NSFontAttributeName: [UIFont systemFontOfSize:fontSize],
                                      NSParagraphStyleAttributeName: pStyle};
    
    
    return styleDictionary;
}

+ (NSDictionary *)standardTextStyleAttributesForFontSize:(CGFloat)fontSize textAlignment:(NSTextAlignment)alignment
{
    NSMutableParagraphStyle *pStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
	[pStyle setAlignment:alignment];
    
	NSDictionary *styleDictionary = @{NSForegroundColorAttributeName: [UIColor colorWithWhite:0.0f alpha:0.8f],
                                      NSFontAttributeName: [UIFont systemFontOfSize:fontSize],
                                      NSParagraphStyleAttributeName: pStyle};
    
    
    return styleDictionary;
}

+ (NSDictionary *)standardLightTextStyleAttributesForFontSize:(CGFloat)fontSize textAlignment:(NSTextAlignment)alignment
{
    NSMutableParagraphStyle *pStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
	[pStyle setAlignment:alignment];
    
	NSDictionary *styleDictionary = @{NSForegroundColorAttributeName: [UIColor colorWithWhite:1.0f alpha:0.8f],
                                      NSFontAttributeName: [UIFont systemFontOfSize:fontSize],
                                      NSParagraphStyleAttributeName: pStyle};
    
    
    return styleDictionary;
}

+ (NSDictionary *)boldTextStyleAttributesForFontSize:(CGFloat)fontSize textAlignment:(NSTextAlignment)alignment
{
    NSMutableParagraphStyle *pStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
	[pStyle setAlignment:alignment];
    
	NSDictionary *styleDictionary = @{NSForegroundColorAttributeName: [UIColor colorWithWhite:1.0f alpha:0.8f],
                                      NSFontAttributeName: [UIFont boldSystemFontOfSize:fontSize],
                                      NSParagraphStyleAttributeName: pStyle};
    
    
    return styleDictionary;
}


+ (NSDictionary *)descriptionTextStyleAttributesForFontSize:(CGFloat)fontSize textAlignment:(NSTextAlignment)alignment
{
    NSMutableParagraphStyle *pStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
	[pStyle setAlignment:alignment];
    [pStyle setLineBreakMode:NSLineBreakByWordWrapping];
    
	NSDictionary *styleDictionary = @{NSForegroundColorAttributeName: [UIColor colorWithWhite:1.0f alpha:0.8f],
                                      NSFontAttributeName: [UIFont systemFontOfSize:fontSize],
                                      NSParagraphStyleAttributeName: pStyle};
    
    
    return styleDictionary;
}

+ (NSDictionary *)boldDescriptionTextStyleAttributesForFontSize:(CGFloat)fontSize textAlignment:(NSTextAlignment)alignment
{
    NSMutableParagraphStyle *pStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
	[pStyle setAlignment:alignment];
    [pStyle setLineBreakMode:NSLineBreakByWordWrapping];
    
	NSDictionary *styleDictionary = @{NSForegroundColorAttributeName: [UIColor colorWithWhite:1.0f alpha:0.8f],
                                      NSFontAttributeName: [UIFont boldSystemFontOfSize:fontSize],
                                      NSParagraphStyleAttributeName: pStyle};
    
    
    return styleDictionary;
}

@end
