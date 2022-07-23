//
//  WH5DaysForecastViewController.m
//  Weather
//
//  Created by Liang Tang on 2021/3/11.
//

#import "WH5DaysForecastViewController.h"
#import "WH5DaysForecastItemView.h"
#import "WH5DaysForecastViewModel.h"
#import "WH5DaysForecastUnlockView.h"

@interface WH5DaysForecastViewController ()
@property (nonatomic, strong) WH5DaysForecastViewModel *viewModel;
@end

@interface WH5DaysForecastViewController ()
@property (strong, nonatomic) IBOutletCollection(WH5DaysForecastItemView) NSArray *forecastViews;
@property (weak, nonatomic) IBOutlet WH5DaysForecastUnlockView *unlockView;
@end

@interface WH5DaysForecastViewController ()
@property (nonatomic, strong) RACDisposable *disposable;
@end

@implementation WH5DaysForecastViewController

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
    [self.view.heightAnchor constraintEqualToConstant:368].active = YES;
}

- (void)bind
{
    _viewModel = [[WH5DaysForecastViewModel alloc] init];
    
    @weakify(self)
    [self.refresh subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.viewModel.fetch5DaysForecast execute:x];
    }];
    
    NSArray *signals = @[
        self.viewModel.fetch5DaysForecast.executionSignals.switchToLatest,
        WHSubscribeManager.sharedInstance.subscribeChanged
    ];
    self.disposable = [[RACSignal combineLatest:signals] subscribeNext:^(RACTuple *value) {
        @strongify(self)
        RACTupleUnpack(NSArray *x, NSNumber *isSubscribed) = value;
        if (x.count > 0) {
            self.view.hidden = NO;
            for (int i = 0; i < self.forecastViews.count; i++) {
                WH5DaysForecastItemView *itemView = self.forecastViews[i];
                if (i < x.count) {
                    itemView.alpha = 1;
                    itemView.forecast = x[i];
                } else {
                    itemView.alpha = 0;
                }
            }
            self.unlockView.hidden = isSubscribed.boolValue;
        } else {
            self.view.hidden = YES;
        }
        [self.view layoutIfNeeded];
    }];
    
    self.unlockView.onUnlock = ^{
        [WHRouter.sharedRouter open:routesInit(WHRouteSubscribeGuide, nil)];
    };
}

@end
