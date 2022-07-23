//
//  WHViewController.m
//  Weather
//
//  Created by Liang Tang on 2021/3/9.
//

#import "WHViewController.h"

@interface WHViewController ()

@end

@implementation WHViewController

- (BOOL)showsNavigationBar { return YES; }

- (BOOL)isInteractivePopGestureEnabled { return YES; }

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    
    [self.navigationController setNavigationBarHidden:!self.showsNavigationBar animated:animated];
    
    self.navigationController.interactivePopGestureRecognizer.enabled = self.isInteractivePopGestureEnabled;
}

@end
