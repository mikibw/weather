//
//  WHRealtimeRainForecastViewController.m
//  Weather
//
//  Created by Liang Tang on 2021/3/11.
//

#import "WHRealtimeRainForecastViewController.h"
#import "WHRealtimeRainForecastViewModel.h"

@interface WHRealtimeRainForecastViewController ()
@property (nonatomic, strong) WHRealtimeRainForecastViewModel* viewModel;
@end

@interface WHRealtimeRainForecastViewController ()
@property (weak, nonatomic) IBOutlet UILabel *precipitationLabel;
@property (weak, nonatomic) IBOutlet UIButton *textButton;
@end

@implementation WHRealtimeRainForecastViewController

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
    [self.view.heightAnchor constraintEqualToConstant:180].active = YES;
}

- (void)bind
{
    _viewModel = [[WHRealtimeRainForecastViewModel alloc] init];
    
    @weakify(self)
    [self.refresh subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.viewModel.fetchRainForecast execute:x];
    }];
    
    [self.viewModel.fetchRainForecast.executionSignals.switchToLatest subscribeNext:^(WHRealtimeRainForecastModel * _Nullable x) {
        @strongify(self)
        if (x) {
            self.view.hidden = NO;
            self.precipitationLabel.text = [x.precipitation.firstObject stringValue];
            [self.textButton setTitle:x.text forState:UIControlStateNormal];
        } else {
            self.view.hidden = YES;
        }
        [self.view layoutIfNeeded];
    }];
}


@end
