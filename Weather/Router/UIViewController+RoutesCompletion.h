//
//  UIViewController+RoutesCompletion.h
//  Weather
//
//  Created by Liang Tang on 2021/3/10.
//

#import <UIKit/UIKit.h>

typedef void(^WHRoutesCompletion)(BOOL success, id parameters);

@interface UIViewController (RoutesCompletion)
@property (nonatomic, copy) WHRoutesCompletion routesCompletion;
@end
