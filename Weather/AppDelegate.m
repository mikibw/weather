//
//  AppDelegate.m
//  Weather
//
//  Created by Liang Tang on 2021/3/9.
//

#import "AppDelegate.h"
#import <BUAdSDK/BUAdSDK.h>
#import <AppTrackingTransparency/AppTrackingTransparency.h>
#import <AdSupport/AdSupport.h>

@interface AppDelegate () <BUSplashAdDelegate>
@property (nonatomic, strong) BUSplashAdView *splashAdView;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary<UIApplicationLaunchOptionsKey,id> *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    self.window.backgroundColor = UIColor.whiteColor;
    NSString *key = @"trail_has_been_shown";
    NSUserDefaults *defaults = NSUserDefaults.standardUserDefaults;
    if ([defaults boolForKey:key]) {
        [WHRouter.sharedRouter open:routesInit(WHRouteWeather, nil)];
    } else {
        [defaults setBool:YES forKey:key];
        [WHRouter.sharedRouter open:routesInit(WHRouteGuide, nil)];
    }
    [self.window makeKeyAndVisible];
    
    [BUAdSDKManager setAppID:@"5151077"];
    [BUAdSDKManager setCoppa:0];// Coppa 0 adult, 1 child
    
    [WHSubscribeManager.sharedInstance initIAPConfiguration];
    [WHSubscribeManager.sharedInstance verifyReceiptAfterLaunchingApplication];
    
    [WHEventTracker.sharedTracker openApp];
    
    [self addSplashAdIfNeeded];
        
    return YES;
}

- (void)addSplashAdIfNeeded
{
    if (WHSubscribeManager.sharedInstance.isSubscribed) return;
    self.splashAdView = [[BUSplashAdView alloc] initWithSlotID:@"887451349" frame:UIScreen.mainScreen.bounds];
    self.splashAdView.tolerateTimeout = 3;
    self.splashAdView.delegate = self;
    if (@available(iOS 14.0, *)) {
        [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
            [self.splashAdView loadAdData];
        }];
    } else {
        [self.splashAdView loadAdData];
    }
}

- (void)splashAdDidLoad:(BUSplashAdView *)splashAd
{
    [self.window.rootViewController.view addSubview:self.splashAdView];
    self.splashAdView.rootViewController = self.window.rootViewController;
}

- (void)splashAdDidClose:(BUSplashAdView *)splashAd
{
    [self.splashAdView removeFromSuperview];
    self.splashAdView = nil;
}

@end
