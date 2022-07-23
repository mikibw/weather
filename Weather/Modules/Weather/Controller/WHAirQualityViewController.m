//
//  WHAirQualityViewController.m
//  Weather
//
//  Created by Liang Tang on 2021/3/11.
//

#import "WHAirQualityViewController.h"
#import "WHAirQualityModel.h"

@interface WHAirQualityViewController ()
@property (weak, nonatomic) IBOutlet UIStackView *qualityView;
@property (weak, nonatomic) IBOutlet UIImageView *qualityImageView;
@property (weak, nonatomic) IBOutlet UILabel *qualityLabel;
@property (weak, nonatomic) IBOutlet UILabel *aqiLabel;
@property (weak, nonatomic) IBOutlet UILabel *primaryPollutantLabel;
@property (weak, nonatomic) IBOutlet UILabel *pm25Label;
@property (weak, nonatomic) IBOutlet UIView *unlockView;
@property (weak, nonatomic) IBOutlet UIButton *unlockButton;
@property (nonatomic, strong) NSLayoutConstraint *heightConstraint;
@end

@interface WHAirQualityViewController ()
@property (nonatomic, strong) RACDisposable *disposable;
@end

@implementation WHAirQualityViewController

- (void)dealloc
{
    [self.disposable dispose];
    self.disposable = nil;
}

@synthesize refresh = _refresh;
- (RACReplaySubject *)refresh
{
    if (!_refresh) {
        _refresh = [RACReplaySubject replaySubjectWithCapacity:1];
    }
    return _refresh;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupUI];
    [self bind];
}

- (void)setupUI
{
    self.view.hidden = YES;
    self.heightConstraint = [self.view.heightAnchor constraintEqualToConstant:128];
    self.heightConstraint.active = YES;
}

- (void)bind
{
    @weakify(self)
    
    NSArray *signals = @[
        self.refresh,
        WHSubscribeManager.sharedInstance.subscribeChanged
    ];
    self.disposable = [[RACSignal combineLatest:signals] subscribeNext:^(RACTuple *value) {
        @strongify(self)
        RACTupleUnpack(WHAirQualityModel *x, NSNumber *isSubscribed) = value;
        if (x) {
            self.view.hidden = NO;
            self.qualityLabel.text = [NSString stringWithFormat:@"空气质量-%@", x.quality];
            self.aqiLabel.text = x.aqi;
            self.primaryPollutantLabel.text = x.primary_pollutant.length ? x.primary_pollutant : @"无";
            self.pm25Label.text = x.pm25;
            self.qualityView.hidden = !isSubscribed.boolValue;
            self.unlockView.hidden = isSubscribed.boolValue;
            self.heightConstraint.constant = isSubscribed.boolValue ? 128 : 175;
        } else {
            self.view.hidden = YES;
        }
        [self.view layoutIfNeeded];
    }];
    
    [[self.unlockButton rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(__kindof UIControl * _Nullable x) {
        [WHRouter.sharedRouter open:routesInit(WHRouteSubscribeGuide, nil)];
    }];
}

@end
