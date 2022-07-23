//
//  WHNavigationController.m
//  Weather
//
//  Created by Liang Tang on 2021/3/9.
//

#import "WHNavigationController.h"

@interface WHNavigationController ()

@end

@implementation WHNavigationController

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return self.topViewController.preferredStatusBarStyle;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationBar.titleTextAttributes = @{
        NSFontAttributeName: [UIFont systemFontOfSize:17 weight:UIFontWeightMedium],
        NSForegroundColorAttributeName: UIColor.blackColor
    };
    self.navigationBar.tintColor = UIColor.blackColor;
    self.navigationBar.shadowImage = UIImage.new;
    [self.navigationBar setBackgroundImage:UIImage.new forBarMetrics:UIBarMetricsDefault];
}

@end
