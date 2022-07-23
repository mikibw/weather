//
//  WHGuide2ViewController.m
//  Weather
//
//  Created by Liang Tang on 2021/3/9.
//

#import "WHGuide2ViewController.h"

@interface WHGuide2ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *continueButton;
@end

@implementation WHGuide2ViewController

- (BOOL)showsNavigationBar
{
    return NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[self.continueButton rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(__kindof UIControl * _Nullable x) {
        [WHRouter.sharedRouter open:routesInit(WHRouteGuide3, nil)];
    }];
}

@end
