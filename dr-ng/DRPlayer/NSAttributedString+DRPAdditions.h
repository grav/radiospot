//
//  NSAttributedString+DRPAdditions.h
//  DR Player
//
//  Created by Richard Nees on 26/03/2013.
//
//

#import <Foundation/Foundation.h>

@interface NSAttributedString (DRPAdditions)

+ (NSDictionary *)darkTextStyleAttributesForFontSize:(CGFloat)fontSize textAlignment:(NSTextAlignment)alignment;
+ (NSDictionary *)standardTextStyleAttributesForFontSize:(CGFloat)fontSize textAlignment:(NSTextAlignment)alignment;
+ (NSDictionary *)standardLightTextStyleAttributesForFontSize:(CGFloat)fontSize textAlignment:(NSTextAlignment)alignment;
+ (NSDictionary *)boldTextStyleAttributesForFontSize:(CGFloat)fontSize textAlignment:(NSTextAlignment)alignment;
+ (NSDictionary *)descriptionTextStyleAttributesForFontSize:(CGFloat)fontSize textAlignment:(NSTextAlignment)alignment;
+ (NSDictionary *)boldDescriptionTextStyleAttributesForFontSize:(CGFloat)fontSize textAlignment:(NSTextAlignment)alignment;

@end
