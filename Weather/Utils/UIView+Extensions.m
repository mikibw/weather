//
//  UIView+Extensions.m
//  Weather
//
//  Created by Liang Tang on 2021/3/10.
//

#import "UIView+Extensions.h"

@implementation UIView (Extensions)

+ (UINib *)nib
{
    return [UINib nibWithNibName:NSStringFromClass(self) bundle:nil];
}

+ (NSString *)identifier
{
    return NSStringFromClass(self);
}

+ (instancetype)loadFromNib
{
    return [NSBundle.mainBundle loadNibNamed:NSStringFromClass(self) owner:nil options:nil].lastObject;
}

@end
