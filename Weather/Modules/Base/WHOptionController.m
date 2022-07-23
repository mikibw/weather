//
//  WHOptionController.m
//  Weather
//
//  Created by Liang Tang on 2021/3/12.
//

#import "WHOptionController.h"

@interface WHOptionController ()
{
    NSUInteger _selectedIndex;
}
@property (weak, nonatomic) IBOutlet UIStackView *stackView;
@end

@implementation WHOptionController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSArray *subviews = self.stackView.arrangedSubviews;
    for (UIView *subview in subviews) {
        [self.stackView removeArrangedSubview:subview];
    }
    for (NSString *option in self.options) {
        UIButton *button = [[UIButton alloc] init];
        button.layer.cornerRadius = 9;
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        [button setTitle:option forState:UIControlStateNormal];
        [button setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
        [button addTarget:self action:@selector(selectButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.stackView addArrangedSubview:button];
    }
    [self selectButton:self.stackView.arrangedSubviews[self.defaultSelectedIndex]];
}

- (void)selectButton:(UIButton *)button
{
    NSArray *subviews = self.stackView.arrangedSubviews;
    for (UIButton *button in subviews) {
        button.backgroundColor = UIColor.whiteColor;
    }
    button.backgroundColor = UIColor.lightMainColor;
    _selectedIndex = [subviews indexOfObject:button];
}

- (IBAction)close
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)confirm
{
    [self dismissViewControllerAnimated:YES completion:nil];
    if (self.routesCompletion) {
        self.routesCompletion(YES, @(self->_selectedIndex));
    }
}

@end
