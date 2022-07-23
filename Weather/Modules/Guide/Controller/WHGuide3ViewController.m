//
//  WHGuide3ViewController.m
//  Weather
//
//  Created by Liang Tang on 2021/3/9.
//

#import "WHGuide3ViewController.h"

@interface WHGuide3ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *continueButton;
@end

@implementation WHGuide3ViewController

- (BOOL)showsNavigationBar
{
    return NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[self.continueButton rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(__kindof UIControl * _Nullable x) {
        if (WHSubscribeManager.sharedInstance.isSubscribed) {
            [WHRouter.sharedRouter open:routesInit(WHRouteWeather, nil)];
        } else {
            [WHRouter.sharedRouter open:routesInit(WHRouteSubscribeGuide, nil)
                             completion:^(BOOL success, id parameters) {
                [WHRouter.sharedRouter open:routesInit(WHRouteWeather, nil)];
            }];
        }
    }];
}

@end
