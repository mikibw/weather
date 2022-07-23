//
//  WHMeViewController.m
//  Weather
//
//  Created by shoujian on 2021/3/9.
//

#import "WHMeViewController.h"

@interface WHMeViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UILabel *vipPeriodLabel;
@property (weak, nonatomic) IBOutlet UIStackView *vipStackView;
@property (weak, nonatomic) IBOutlet UIStackView *userStackView;
@property (weak, nonatomic) IBOutlet UIImageView *periodImageView;

@property (nonatomic,assign) BOOL isVip;
@end

@implementation WHMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHex:0xF5F8FD alpha:1];
    self.title = @"我的";
    [self updateUI];
}

- (void)updateUI
{
    self.isVip = WHSubscribeManager.sharedInstance.isSubscribed;
    _userStackView.hidden = self.isVip;
    _vipStackView.hidden = !self.isVip;
    
    self.periodImageView.hidden = !self.isVip;
    self.vipPeriodLabel.hidden = !self.isVip;
    
    if (self.isVip) {
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:WHSubscribeManager.sharedInstance.expiration_ms.longLongValue/1000.f];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"会员有效期:yyyy.MM.dd HH:mm"];
        NSString *dateString = [formatter stringFromDate:date];
        self.vipPeriodLabel.text = dateString;
    }
}

- (IBAction)freeTryClick:(id)sender {
    NSLog(@"3天免费使用");
    [WHRouter.sharedRouter open:routesInit(WHRouteSubscribeGuide, nil)];
}

- (IBAction)feedbackClick:(id)sender {
    NSLog(@"反馈");
    [WHRouter.sharedRouter open:routesInit(WHRoutePravicy, nil)];
}

- (IBAction)serviceClick:(id)sender {
    NSLog(@"服务");
    [WHRouter.sharedRouter open:routesInit(WHRouteServiceItem, nil)];
}

@end
