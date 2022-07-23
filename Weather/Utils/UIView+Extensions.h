//
//  UIView+Extensions.h
//  Weather
//
//  Created by Liang Tang on 2021/3/10.
//

#import <UIKit/UIKit.h>

@interface UIView (Extensions)

+ (UINib *)nib;

+ (NSString *)identifier;

+ (instancetype)loadFromNib;

@end

