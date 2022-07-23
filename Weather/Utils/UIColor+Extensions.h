//
//  UIColor+Extensions.h
//  Weather
//
//  Created by Liang Tang on 2021/3/9.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#define UIColorFromRGBWithAlpha(rgbValue, alpha) [UIColor colorWithHex: rgb]
#define UIColorFromRGB(rgbValue) UIColorFromRGBWithAlpha(rgbValue, 1.0)

@interface UIColor (Extensions)

+ (UIColor *)colorWithHex:(long)hex alpha:(CGFloat)alpha;

+ (UIColor *)mainColor;
+ (UIColor *)lightMainColor;
+ (UIColor *)shadowColor;
+ (UIColor *)mainBorderColor;
+ (UIColor *)lightBorderColor;
+ (UIColor *)darkBorderColor;
+ (UIColor *)lightTextColor;
+ (UIColor *)darkTextColor;

- (UIImage *)toImage;
- (UIImage *)toImage:(CGSize)size;

@end

NS_ASSUME_NONNULL_END
