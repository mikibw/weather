//
//  WHRealtimeInfoViewController.m
//  Weather
//
//  Created by Liang Tang on 2021/3/10.
//

#import "WHRealtimeInfoViewController.h"
#import "WHRealtimeInfoViewModel.h"

@interface WHRealtimeInfoViewController ()
@property (nonatomic, strong) WHRealtimeInfoViewModel *viewModel;
@end

@interface WHRealtimeInfoViewController ()
@property (weak, nonatomic) IBOutlet UILabel *tempratureLabel;
@property (weak, nonatomic) IBOutlet UIImageView *weatherImageView;
@property (weak, nonatomic) IBOutlet UILabel *weatherLabel;
@property (weak, nonatomic) IBOutlet UIButton *feelsLikeButton;
@property (weak, nonatomic) IBOutlet UILabel *sunriseLabel;
@property (weak, nonatomic) IBOutlet UILabel *sunsetLabel;
@property (weak, nonatomic) IBOutlet UILabel *humidityLabel;
@property (weak, nonatomic) IBOutlet UILabel *pressureLabel;
@property (weak, nonatomic) IBOutlet UILabel *visibilityLabel;
@property (weak, nonatomic) IBOutlet UILabel *airQualityLabel;
@property (weak, nonatomic) IBOutlet UILabel *windDirectionLabel;
@property (weak, nonatomic) IBOutlet UILabel *windDirectionDegreeLabel;
@property (weak, nonatomic) IBOutlet UILabel *windSpeedLabel;
@property (weak, nonatomic) IBOutlet UILabel *windScaleLabel;
@end

@implementation WHRealtimeInfoViewController

@synthesize refresh = _refresh;
- (RACReplaySubject *)refresh
{
    if (!_refresh) {
        _refresh = [RACReplaySubject replaySubjectWithCapacity:1];
    }
    return _refresh;
}

@synthesize dataChanged = _dataChanged;
- (RACReplaySubject *)dataChanged
{
    if (!_dataChanged) {
        _dataChanged = [RACReplaySubject replaySubjectWithCapacity:1];
    }
    return _dataChanged;
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
    self.feelsLikeButton.layer.cornerRadius = 12.5;
    self.feelsLikeButton.layer.borderWidth = 1;
    self.feelsLikeButton.layer.borderColor = [UIColor.whiteColor colorWithAlphaComponent:0.2].CGColor;
    
    [self.view.heightAnchor constraintEqualToConstant:540].active = YES;
}

- (void)bind
{
    _viewModel = [[WHRealtimeInfoViewModel alloc] init];
    
    @weakify(self)
    [self.refresh subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.viewModel.fetchRealtimeInfo execute:x];
    }];
    
    [self.viewModel.fetchRealtimeInfo.executionSignals.switchToLatest subscribeNext:^(RACTuple * _Nullable x) {
        @strongify(self)
        if (x) {
            self.view.hidden = NO;
            RACTupleUnpack(WHRealtimeInfoModel *m1, WHAirQualityModel *m2, WHSunModel *m3) = x;
            self.tempratureLabel.text = m1.temperature;
            self.weatherImageView.image = [UIImage weatherIconWithCode:m1.code];
            self.weatherLabel.text = m1.text;
            [self.feelsLikeButton setTitle:[NSString stringWithFormat:@"体感温度: %@℃", m1.feels_like] forState:UIControlStateNormal];
            self.sunriseLabel.text = m3.sunrise;
            self.sunsetLabel.text = m3.sunset;
            self.humidityLabel.text = [NSString stringWithFormat:@"%@%%", m1.humidity];
            self.pressureLabel.text = [NSString stringWithFormat:@"%@mb", m1.pressure];
            self.visibilityLabel.text = [NSString stringWithFormat:@"%@km", m1.visibility];
            self.airQualityLabel.text = m2 ? m2.quality : @"无";
            self.windDirectionLabel.text = m1.wind_direction;
            self.windDirectionDegreeLabel.text = m1.wind_direction_degree;
            self.windSpeedLabel.text = m1.wind_speed;
            self.windScaleLabel.text = m1.wind_scale;
            [self.dataChanged sendNext:RACTuplePack(m1.code, m2)];
        } else {
            self.view.hidden = YES;
        }
        [self.view layoutIfNeeded];
    }];
}

@end
