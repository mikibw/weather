//
//  WH24HoursForecastViewController.m
//  Weather
//
//  Created by Liang Tang on 2021/3/11.
//

#import "WH24HoursForecastViewController.h"
#import "WH24HoursForecastViewModel.h"
#import "WH24HoursForecastCell.h"
#import "WH24HoursForecastUnlockCell.h"

@interface WH24HoursForecastViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) WH24HoursForecastViewModel *viewModel;
@end

@interface WH24HoursForecastViewController ()
@property (weak, nonatomic) IBOutlet UILabel *textLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *forecastView;
@end

@interface WH24HoursForecastViewController ()
@property (nonatomic, strong) RACDisposable *disposable;
@end

@implementation WH24HoursForecastViewController

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
    [self.forecastView registerNib:WH24HoursForecastCell.nib
        forCellWithReuseIdentifier:WH24HoursForecastCell.identifier];
    [self.forecastView registerNib:WH24HoursForecastUnlockCell.nib
        forCellWithReuseIdentifier:WH24HoursForecastUnlockCell.identifier];
    [self.view.heightAnchor constraintEqualToConstant:200].active = YES;
}

- (void)bind
{
    _viewModel = [[WH24HoursForecastViewModel alloc] init];
    
    @weakify(self)
    [self.refresh subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.viewModel.fetch24HoursForecast execute:x];
    }];
    
    NSArray *signals = @[
        self.viewModel.fetch24HoursForecast.executionSignals.switchToLatest,
        WHSubscribeManager.sharedInstance.subscribeChanged
    ];
    self.disposable = [[RACSignal combineLatest:signals] subscribeNext:^(RACTuple *value) {
        @strongify(self)
        RACTupleUnpack(NSArray *x, NSNumber *isSubscribed) = value;
        if (x.count > 0) {
            self.view.hidden = NO;
            if (isSubscribed.boolValue) {
                WH24HoursForecastModel *m = x.firstObject;
                self.textLabel.text = m.text;
            } else {
                self.textLabel.text = nil;
            }
            [self.view layoutIfNeeded];
            [self.forecastView layoutIfNeeded];
            [self.forecastView reloadData];
        } else {
            self.view.hidden = YES;
        }
        [self.view layoutIfNeeded];
    }];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (!WHSubscribeManager.sharedInstance.isSubscribed) {
        return 2;
    } else {
        return self.viewModel.forecasts.count;
    }
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (!WHSubscribeManager.sharedInstance.isSubscribed && indexPath.item == 1) {
        WH24HoursForecastUnlockCell *cell = [self.forecastView dequeueReusableCellWithReuseIdentifier:WH24HoursForecastUnlockCell.identifier forIndexPath:indexPath];
        cell.onUnlock = ^{
            [WHRouter.sharedRouter open:routesInit(WHRouteSubscribeGuide, nil)];
        };
        return cell;
    }
    WH24HoursForecastCell *cell = [self.forecastView dequeueReusableCellWithReuseIdentifier:WH24HoursForecastCell.identifier forIndexPath:indexPath];
    [cell showModel:self.viewModel.forecasts[indexPath.item] forHighlight:indexPath.item == 0];
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (!WHSubscribeManager.sharedInstance.isSubscribed && indexPath.item == 1) {
        return CGSizeMake(self.forecastView.bounds.size.width - 80, self.forecastView.bounds.size.height);
    }
    return CGSizeMake(46, self.forecastView.bounds.size.height);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 14;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 14;
}

@end
