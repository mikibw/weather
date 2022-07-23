//
//  UIColor+Extensions.m
//  Weather
//
//  Created by Liang Tang on 2021/3/9.
//

#import "UIColor+Extensions.h"

@implementation UIColor (Extensions)

+ (UIColor *)colorWithHex:(long)hex alpha:(CGFloat)alpha
{
    return [UIColor colorWithRed: ((float)((hex & 0xFF0000) >> 16))/255.0
                           green: ((float)((hex & 0xFF00) >> 8))/255.0
                            blue: ((float)(hex & 0xFF))/255.0
                           alpha: alpha];
}

+ (UIColor *)mainColor
{
    return [UIColor colorWithHex:0x047bff alpha:1.0];
}

+ (UIColor *)lightMainColor
{
    return [UIColor colorWithHex:0xe4eeff alpha:1.0];
}

+ (UIColor *)shadowColor
{
    return [UIColor colorWithHex:0x4e91ff alpha:1.0];
}

+ (UIColor *)mainBorderColor
{
    return [UIColor colorWithHex:0x5c97fc alpha:1.0];
}

+ (UIColor *)lightBorderColor
{
    return [UIColor colorWithHex:0xc4c3c3 alpha:1.0];
}

+ (UIColor *)darkBorderColor
{
    return [UIColor colorWithHex:0x020202 alpha:1.0];
}

+ (UIColor *)lightTextColor
{
    return [UIColor colorWithHex:0x999999 alpha:1.0];
}

+ (UIColor *)darkTextColor
{
    return [UIColor colorWithHex:0x666666 alpha:1.0];
}

- (UIImage *)toImage
{
    return [self toImage:CGSizeMake(1, 1)];
}
- (UIImage *)toImage:(CGSize)size
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [self CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
