//
//  WHRouter.h
//  Weather
//
//  Created by Liang Tang on 2021/3/10.
//

#import <Foundation/Foundation.h>
#import "WHRoutes.h"
#import "UIViewController+RoutesCompletion.h"

@interface WHRouter : NSObject

+ (instancetype)sharedRouter;

- (UIViewController *)topViewController;
- (UINavigationController *)currentNavigator;

- (void)open:(WHRoutes *)routes;
- (void)open:(WHRoutes *)routes completion:(WHRoutesCompletion)completion;

@end
