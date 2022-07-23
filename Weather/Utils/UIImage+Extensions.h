//
//  UIImage+Extensions.h
//  Weather
//
//  Created by Liang Tang on 2021/3/9.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extensions)

+ (instancetype)weatherIconWithCode:(NSString *)code;
+ (instancetype)weatherLineWithCode:(NSString *)code;
+ (instancetype)weatherBgWithCode:(NSString *)code;
+ (instancetype)moonPhaseWithName:(NSString *)name;
+ (instancetype)lifeIndexWithName:(NSString *)name;
+ (instancetype)disasterWithType:(NSString *)type level:(NSString *)level;

@end
