//
//  WHGuideViewController.m
//  Weather
//
//  Created by Liang Tang on 2021/3/9.
//

#import "WHGuideViewController.h"

@interface WHGuideViewController ()
@property (weak, nonatomic) IBOutlet UIButton *continueButton;
@end

@implementation WHGuideViewController

- (BOOL)showsNavigationBar
{
    return NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[self.continueButton rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(__kindof UIControl * _Nullable x) {
        [WHRouter.sharedRouter open:routesInit(WHRouteGuide2, nil)];
    }];
}


@end
