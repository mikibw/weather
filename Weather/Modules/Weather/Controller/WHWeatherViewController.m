//
//  WHWeatherViewController.m
//  Weather
//
//  Created by Liang Tang on 2021/3/10.
//

#import "WHWeatherViewController.h"

#import "WHPostionView.h"

#import "WHRealtimeInfoViewController.h"
#import "WH24HoursForecastViewController.h"
#import "WH5DaysForecastViewController.h"
#import "WHAirQualityViewController.h"
#import "WHMoonPhaseViewController.h"
#import "WHTrafficRestrictionViewController.h"
#import "WHLifeIndexViewController.h"
#import "WHMeteDisasterWarningViewController.h"

#import "WHAdvertisementViewController.h"

#import "WHSubscribeManager.h"


@interface WHWeatherViewController ()
@property (strong, nonatomic) UIButton *settingButton;
@property (strong, nonatomic) WHPostionView *locView;
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@end

@interface WHWeatherViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIStackView *stackView;
@property (nonatomic, strong) WHRealtimeInfoViewController *realtimeInfo;
@property (nonatomic, strong) WHAdvertisementViewController *adfeed1;
@property (nonatomic, strong) WH24HoursForecastViewController *h24Forecast;
@property (nonatomic, strong) WH5DaysForecastViewController *d5Forecast;
@property (nonatomic, strong) WHAdvertisementViewController *adfeed2;
@property (nonatomic, strong) WHAirQualityViewController *airQuality;
@property (nonatomic, strong) WHMoonPhaseViewController *moonPhase;
@property (nonatomic, strong) WHTrafficRestrictionViewController *trafficRestriction;
@property (nonatomic, strong) WHAdvertisementViewController *adfeed3;
@property (nonatomic, strong) WHLifeIndexViewController *lifeIndex;
@property (nonatomic, strong) WHMeteDisasterWarningViewController *meteDisasterWarning;
@property (nonatomic, strong) WHAdvertisementViewController *adbanner;
@end

@interface WHWeatherViewController ()
@property (nonatomic, strong) RACDisposable *disposable;

@end

@implementation WHWeatherViewController

- (void)dealloc
{
    [self.disposable dispose];
    self.disposable = nil;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupUI];
    [self bind];
}

- (void)setupUI
{
    self.locView = WHPostionView.new;
    self.locView.bounds = CGRectMake(0, 0, 240, 44);
    self.navigationItem.titleView = self.locView;
    
    self.settingButton = [[UIButton alloc] init];
    [self.settingButton setImage:[UIImage imageNamed:@"nav_setting"] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.settingButton];
    
    self.realtimeInfo = WHRealtimeInfoViewController.new;
    [self addChildViewController:self.realtimeInfo];
    [self.stackView addArrangedSubview:self.realtimeInfo.view];
    
    self.adfeed1 = WHAdvertisementViewController.new;
    self.adfeed1.adid = @"945913487";
    self.adfeed1.adtype = WHAdvertisementTypeFeed;
    [self addChildViewController:self.adfeed1];
    [self.stackView addArrangedSubview:self.adfeed1.view];
    
    self.h24Forecast = WH24HoursForecastViewController.new;
    [self addChildViewController:self.h24Forecast];
    [self.stackView addArrangedSubview:self.h24Forecast.view];
    
    self.d5Forecast = WH5DaysForecastViewController.new;
    [self addChildViewController:self.d5Forecast];
    [self.stackView addArrangedSubview:self.d5Forecast.view];
    
    self.adfeed2 = WHAdvertisementViewController.new;
    self.adfeed2.adid = @"945929058";
    self.adfeed2.adtype = WHAdvertisementTypeFeed;
    [self addChildViewController:self.adfeed2];
    [self.stackView addArrangedSubview:self.adfeed2.view];
    
    self.airQuality = WHAirQualityViewController.new;
    [self addChildViewController:self.airQuality];
    [self.stackView addArrangedSubview:self.airQuality.view];
    
    self.moonPhase = WHMoonPhaseViewController.new;
    [self addChildViewController:self.moonPhase];
    [self.stackView addArrangedSubview:self.moonPhase.view];
    
    self.trafficRestriction = WHTrafficRestrictionViewController.new;
    [self addChildViewController:self.trafficRestriction];
    [self.stackView addArrangedSubview:self.trafficRestriction.view];
    
    self.adfeed3 = WHAdvertisementViewController.new;
    self.adfeed3.adid = @"945929059";
    self.adfeed3.adtype = WHAdvertisementTypeFeed;
    [self addChildViewController:self.adfeed3];
    [self.stackView addArrangedSubview:self.adfeed3.view];
    
    self.lifeIndex = WHLifeIndexViewController.new;
    [self addChildViewController:self.lifeIndex];
    [self.stackView addArrangedSubview:self.lifeIndex.view];
    
    self.meteDisasterWarning = WHMeteDisasterWarningViewController.new;
    [self addChildViewController:self.meteDisasterWarning];
    [self.stackView addArrangedSubview:self.meteDisasterWarning.view];
    
    self.adbanner = WHAdvertisementViewController.new;
    self.adbanner.adid = @"945913482";
    self.adbanner.adtype = WHAdvertisementTypeBanner;
    [self addChildViewController:self.adbanner];
    [self.view addSubview:self.adbanner.view];
    [self.adbanner.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
        make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
        make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
    }];
}

- (void)bind
{
    @weakify(self)
    
    self.disposable = [WHSubscribeManager.sharedInstance.subscribeChanged subscribeNext:^(NSNumber *isSubscribed) {
        @strongify(self)
        UIEdgeInsets insets = self.scrollView.contentInset;
        insets.bottom = isSubscribed.boolValue ? 0 : 75;
        self.scrollView.contentInset = insets;
    }];
    
    self.locView.onSearch = ^{
        @strongify(self)
        if (WHSubscribeManager.sharedInstance.isSubscribed) {
            [WHRouter.sharedRouter open:routesInit(WHRoutePostionSearch, nil) completion:^(BOOL success, id position) {
                @strongify(self)
                [self.navigationController popToViewController:self animated:YES];
                [self refresh:position];
            }];
        } else {
            [WHRouter.sharedRouter open:routesInit(WHRouteSubscribeGuide, nil)];
        }
    };
    
    [[self.settingButton rac_signalForControlEvents:(UIControlEventTouchUpInside)] subscribeNext:^(id x) {
        [WHRouter.sharedRouter open:routesInit(WHRouteMe, nil)];
    }];
    
    [self.realtimeInfo.dataChanged subscribeNext:^(RACTuple *x) {
        @strongify(self)
        self.bgImageView.image = [UIImage weatherBgWithCode:x.first];
        [self.airQuality.refresh sendNext:x.second];
    }];
    
    [self.viewModel.fetchPostion.executing subscribeNext:^(NSNumber *x) {
        x.boolValue ? [SVProgressHUD show] : [SVProgressHUD dismiss];
    }];
    
    [self.viewModel.fetchPostion.executionSignals.switchToLatest subscribeNext:^(id position) {
        @strongify(self)
        [self refresh:position];
    }];
    
    [self.viewModel.fetchPostion execute:nil];
    
    //开启第一次订阅弹框提醒
    [WHSubscribeManager.sharedInstance stopPopUpTimer];
    [WHSubscribeManager.sharedInstance startPopUpTimer];
}

- (void)refresh:(WHPositionModel *)position
{
    self.locView.position = position;
    [self.realtimeInfo.refresh sendNext:position];
    [self.h24Forecast.refresh sendNext:position];
    [self.d5Forecast.refresh sendNext:position];
    [self.moonPhase.refresh sendNext:position];
    [self.trafficRestriction.refresh sendNext:position];
    [self.lifeIndex.refresh sendNext:position];
    [self.meteDisasterWarning.refresh sendNext:position];
}

@end
