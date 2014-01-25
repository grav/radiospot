//
//  NSColor+DRPAdditions.m
//  DR Player
//
//  Created by Richard on 07/01/14.
//
//

#import "UIColor+DRPAdditions.h"

@implementation UIColor (DRPAdditions)

+ (UIColor *)colorFromHexRGB:(NSString *)inColorString
{
    UIColor *result = nil;
	unsigned int colorCode = 0;
	unsigned char redByte, greenByte, blueByte;
	
	if (nil != inColorString)
	{
		NSScanner *scanner = [NSScanner scannerWithString:inColorString];
        [scanner scanString:@"#" intoString:nil];
		(void) [scanner scanHexInt:&colorCode];	// ignore error
	}
	redByte		= (unsigned char) (colorCode >> 16);
	greenByte	= (unsigned char) (colorCode >> 8);
	blueByte	= (unsigned char) (colorCode);	// masks off high bits
	result = [UIColor colorWithRed:(CGFloat)redByte / 0xff
                             green:(CGFloat)greenByte / 0xff
                              blue:(CGFloat)blueByte / 0xff
                             alpha:1.0f];
	
    return result;
}

- (NSString *)hexRGBRepresentation
{
    CGFloat red, green, blue, alpha;
    
    [self getRed:&red green:&green blue:&blue alpha:&alpha];
    
    return [NSString stringWithFormat:@"#%0.2lX%0.2lX%0.2lX",
            (long)(red * 255),
            (long)(green * 255),
            (long)(blue * 255)];
}
@end
