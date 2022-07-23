//
//  WHRouter.m
//  Weather
//
//  Created by Liang Tang on 2021/3/10.
//

#import "WHRouter.h"

#import "WHGuideViewController.h"
#import "WHGuide2ViewController.h"
#import "WHGuide3ViewController.h"

#import "WHWeatherViewController.h"

#import "WHMeViewController.h"
#import "WHSubscribeGuideViewController.h"
#import "WHSubscribeStayViewController.h"
#import "WHSearchViewController.h"
#import "WHSearchResultController.h"
#import "WHCustomWebViewController.h"

#import "WHPopUpController.h"
#import "WHOptionController.h"

#import "WHLifeIndexPopUpController.h"

@implementation WHRouter

static inline UIViewController *getTopViewController(id root)
{
    UIViewController *current;
    if ([root presentedViewController]) {
        root = [root presentedViewController];
    }
    if ([root isKindOfClass:[UITabBarController class]]) {
        current = getTopViewController([(UITabBarController *)root selectedViewController]);
    } else if ([root isKindOfClass:[UINavigationController class]]){
        current = getTopViewController([(UINavigationController *)root visibleViewController]);
    } else {
        current = root;
    }
    return current;
}

+ (instancetype)sharedRouter
{
    static WHRouter *router;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        router = [[WHRouter alloc] init];
    });
    return router;
}

- (UIViewController *)topViewController
{
    return getTopViewController(UIApplication.sharedApplication.delegate.window.rootViewController);
}

- (UINavigationController *)currentNavigator
{
    return self.topViewController.navigationController;
}

-(void)open:(WHRoutes *)routes
{
    [self open:routes completion:nil];
}

- (void)open:(WHRoutes *)routes completion:(WHRoutesCompletion)completion
{
    if (!routes) return;
    
    switch (routes.route) {
        case WHRouteGuide: {
            WHGuideViewController *vc = [[WHGuideViewController alloc] init];
            vc.routesCompletion = completion;
            id nav = [[WHNavigationController alloc] initWithRootViewController:vc];
            UIApplication.sharedApplication.delegate.window.rootViewController = nav;
            break;
        }
        case WHRouteGuide2: {
            WHGuide2ViewController *vc = [[WHGuide2ViewController alloc] init];
            vc.routesCompletion = completion;
            [self.currentNavigator pushViewController:vc animated:NO];
            break;
        }
        case WHRouteGuide3: {
            WHGuide3ViewController *vc = [[WHGuide3ViewController alloc] init];
            vc.routesCompletion = completion;
            [self.currentNavigator pushViewController:vc animated:NO];
            break;
        }
        case WHRouteWeather: {
            WHWeatherViewController *vc = [[WHWeatherViewController alloc] init];
            vc.viewModel = [[WHWeatherViewModel alloc] init];
            vc.routesCompletion = completion;
            id nav = [[WHNavigationController alloc] initWithRootViewController:vc];
            UIApplication.sharedApplication.delegate.window.rootViewController = nav;
            break;
        }
        case WHRouteMe: {
            WHMeViewController *vc = [[WHMeViewController alloc]init];
            vc.routesCompletion = completion;
            [self.currentNavigator pushViewController:vc animated:YES];
            break;
        }
        case WHRouteSubscribeGuide: {
            if (![self.topViewController isKindOfClass:WHSubscribeGuideViewController.class] && ![self.topViewController isKindOfClass:WHSubscribeStayViewController.class]) {
                WHSubscribeGuideViewController *vc = [[WHSubscribeGuideViewController alloc] init];
                WHNavigationController *navi = [[WHNavigationController alloc]initWithRootViewController:vc];
                vc.routesCompletion = completion;
                navi.modalPresentationStyle = UIModalPresentationOverFullScreen;
                [self.currentNavigator presentViewController:navi animated:YES completion:nil];
            }
            break;
        }
        case WHRouteSubscribeStay: {
            if (![self.topViewController isKindOfClass:WHSubscribeGuideViewController.class] && ![self.topViewController isKindOfClass:WHSubscribeStayViewController.class]) {
                WHSubscribeStayViewController *vc = [[WHSubscribeStayViewController alloc] init];
                vc.routesCompletion = completion;
                vc.modalPresentationStyle = UIModalPresentationOverFullScreen;
                [self.currentNavigator presentViewController:vc animated:YES completion:nil];
            }
            break;
        }
        case WHRoutePostionSearch: {
            WHSearchViewController *vc = WHSearchViewController.new;
            vc.routesCompletion = completion;
            [self.currentNavigator pushViewController:vc animated:YES];
            break;
        }
        case WHRoutePostionSearchResult: {
            WHSearchResultController *vc = WHSearchResultController.new;
            vc.routesCompletion = completion;
            [self.currentNavigator pushViewController:vc animated:NO];
            break;
        }
        case WHRoutePravicy:{
            WHCustomWebViewController *vc = [[WHCustomWebViewController alloc]initWithUrl:@"http://weather.etolled.xyz/policy-privacy.html" title:@"隐私政策"];
            vc.routesCompletion = completion;
            [self.currentNavigator pushViewController:vc animated:YES];
            break;
        }
        case WHRouteServiceItem:{
            WHCustomWebViewController *vc = [[WHCustomWebViewController alloc]initWithUrl:@"http://weather.etolled.xyz/policy-service.html" title:@"服务条款"];
            vc.routesCompletion = completion;
            [self.currentNavigator pushViewController:vc animated:YES];
            break;
        }
        case WHRoutePopUp: {
            WHPopUpController *vc = [[WHPopUpController alloc] init];
            vc.message = routes.parameters;
            vc.routesCompletion = completion;
            vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            vc.modalPresentationStyle = UIModalPresentationOverFullScreen;
            [self.topViewController presentViewController:vc animated:YES completion:nil];
            break;
        }
        case WHRouteOption: {
            WHOptionController *vc = [[WHOptionController alloc] init];
            vc.options = routes.parameters[@"1"];
            vc.defaultSelectedIndex = [routes.parameters[@"2"] intValue];
            vc.routesCompletion = completion;
            vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            vc.modalPresentationStyle = UIModalPresentationOverFullScreen;
            [self.topViewController presentViewController:vc animated:YES completion:nil];
            break;
        }
        case WHRouteLifeIndexPopUp: {
            WHLifeIndexPopUpController *vc = [[WHLifeIndexPopUpController alloc] init];
            vc.item = routes.parameters;
            vc.routesCompletion = completion;
            vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            vc.modalPresentationStyle = UIModalPresentationOverFullScreen;
            [self.topViewController presentViewController:vc animated:YES completion:nil];
        }
    }
}

@end
