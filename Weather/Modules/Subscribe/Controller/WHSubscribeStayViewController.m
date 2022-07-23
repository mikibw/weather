//
//  WHSubscribeStayViewController.m
//  Weather
//
//  Created by shoujian on 2021/3/11.
//

#import "WHSubscribeStayViewController.h"
#import "WHGrandientButton.h"
#import "STRIAPManager.h"

@interface WHSubscribeStayViewController ()
@property (weak, nonatomic) IBOutlet WHGrandientButton *subcribeBtn;
@property (weak, nonatomic) IBOutlet UILabel *recommendLabel;
@end

@implementation WHSubscribeStayViewController

- (BOOL)showsNavigationBar
{
    return NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [WHSubscribeManager.sharedInstance stopPopUpTimer];
    
    @weakify(self)
    
    [WHSubscribeManager.sharedInstance.getVersion subscribeNext:^(WHSubscribeVersionModel *x) {
        @strongify(self)
        id subscribeButtonTitle = x.is_onlie ? x.button_desc_online : x.button_desc;
        [self.subcribeBtn setTitle:subscribeButtonTitle forState:UIControlStateNormal];
    }];
    
    [[_subcribeBtn rac_signalForControlEvents:(UIControlEventTouchUpInside)] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        [WHEventTracker.sharedTracker clickSubscribeButton];
        [SVProgressHUD show];
        [WHSubscribeManager.sharedInstance subscribe:^(WHSubscribeResult result) {
            [SVProgressHUD dismiss];
            switch (result) {
                case WHSubscribeResultSuccess: {
                    [WHEventTracker.sharedTracker subscribeSuccess];
                    [SVProgressHUD showSuccessWithStatus:@"订阅成功"];
                    if (self.routesCompletion) {
                        self.routesCompletion(YES, nil);
                    } else {
                        [self dismissViewControllerAnimated:YES completion:nil];
                    }
                    break;
                }
                case WHSubscribeResultFailure: {
                    [SVProgressHUD showInfoWithStatus:@"订阅失败"];
                    break;
                }
                case WHSubscribeResultCancelled: {
                    [SVProgressHUD showInfoWithStatus:@"订阅取消"];
                    break;
                }
            }
        }];
    }];
    
    [self shakeToShow:self.subcribeBtn];
    
    NSMutableAttributedString *mutableAttStr = [NSMutableAttributedString new];
    NSAttributedString *attGrayBegin = [[NSAttributedString alloc] initWithString:@"已有超过" attributes:@{NSForegroundColorAttributeName: [UIColor colorWithHex:0x666666 alpha:1], NSFontAttributeName: [UIFont systemFontOfSize:13]}];
    [mutableAttStr appendAttributedString:attGrayBegin];
    NSAttributedString *attBlue = [[NSAttributedString alloc] initWithString:@" 346234 " attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHex:0x00A3FF alpha:1], NSFontAttributeName: [UIFont systemFontOfSize:13]}];
    [mutableAttStr appendAttributedString:attBlue];
    NSAttributedString *attGrayEnd = [[NSAttributedString alloc] initWithString:@"人成功解锁" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHex:0x666666 alpha:1], NSFontAttributeName:[UIFont systemFontOfSize:13]}];
    [mutableAttStr appendAttributedString:attGrayEnd];

    self.recommendLabel.attributedText = mutableAttStr;
}

- (IBAction)closeBtnClick:(id)sender
{
    //关闭后开启自动弹框订阅提醒
    [WHSubscribeManager.sharedInstance startPopUpTimer];
    if (self.routesCompletion) {
        self.routesCompletion(NO, nil);
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)shakeToShow:(UIView *)aView
{
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 1.2;
    animation.repeatCount = MAXFLOAT;
    animation.removedOnCompletion = NO;
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.05, 1.05, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1, 1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.05, 1.05, 1.0)]];
    animation.values = values;
    [aView.layer addAnimation:animation forKey:nil];
}

@end
