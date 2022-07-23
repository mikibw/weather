//
//  UIViewController+RoutesCompletion.m
//  Weather
//
//  Created by Liang Tang on 2021/3/10.
//

#import "UIViewController+RoutesCompletion.h"

@implementation UIViewController (RoutesCompletion)

- (WHRoutesCompletion)routesCompletion
{
    return objc_getAssociatedObject(self, @selector(routesCompletion));
}

- (void)setRoutesCompletion:(WHRoutesCompletion)routesCompletion
{
    objc_setAssociatedObject(self,
                             @selector(routesCompletion),
                             routesCompletion,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
