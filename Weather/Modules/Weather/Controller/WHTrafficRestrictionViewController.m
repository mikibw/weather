//
//  WHTrafficRestrictionViewController.m
//  Weather
//
//  Created by Liang Tang on 2021/3/11.
//

#import "WHTrafficRestrictionViewController.h"
#import "WHTrafficRestrictionViewModel.h"

@interface WHTrafficRestrictionViewController ()
@property (nonatomic, assign) int whichDay;
@property (nonatomic, strong) WHTrafficRestrictionViewModel *viewModel;
@end

@interface WHTrafficRestrictionViewController ()
@property (weak, nonatomic) IBOutlet UIButton *dayButton;
@property (weak, nonatomic) IBOutlet UIView *restrictionView;
@property (weak, nonatomic) IBOutlet UILabel *platesTopLabel;
@property (weak, nonatomic) IBOutlet UILabel *platesLabel;
@property (weak, nonatomic) IBOutlet UILabel *remarksLabel;
@property (weak, nonatomic) IBOutlet UIButton *penaltyButton;
@property (weak, nonatomic) IBOutlet UIView *emptyView;
@end

@implementation WHTrafficRestrictionViewController

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
    self.whichDay = 0;
    [self setupUI];
    [self bind];
}

- (void)setupUI
{
    self.view.hidden = YES;
}

- (void)bind
{
    _viewModel = [[WHTrafficRestrictionViewModel alloc] init];
    
    @weakify(self)
    [self.refresh subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.viewModel.fetchTrafficRestriction execute:x];
    }];
    
    NSArray *dayTexts = @[@"今天", @"明天", @"后天"];
    
    [self.viewModel.fetchTrafficRestriction.executionSignals.switchToLatest subscribeNext:^(WHTrafficRestrictionModel * _Nullable x) {
        @strongify(self)
        if (x) {
            self.dayButton.hidden = NO;
            self.restrictionView.hidden = NO;
            self.remarksLabel.text = x.remarks;
            self.whichDay = 0;
            self.emptyView.hidden = YES;
        } else {
            self.dayButton.hidden = YES;
            self.restrictionView.hidden = YES;
            self.emptyView.hidden = NO;
        }
        self.view.hidden = NO;
        [self.view layoutIfNeeded];
    }];
    
    [RACObserve(self, whichDay) subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        if (!self.viewModel.restriction) return;
        
        [self.dayButton setTitle:[NSString stringWithFormat:@"%@>", dayTexts[self.whichDay]]
                        forState:UIControlStateNormal];
        
        WHTrafficRestrictionLimitModel *limit = self.viewModel.restriction.limits[self.whichDay];
        if (limit.plates.count) {
            self.platesTopLabel.text = @"限行尾号：";
            self.platesLabel.hidden = NO;
            self.platesLabel.text = [limit.plates componentsJoinedByString:@" / "];
        } else {
            self.platesTopLabel.text = limit.memo;
            self.platesLabel.hidden = YES;
        }
    }];
    
    [[self.dayButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        if (WHSubscribeManager.sharedInstance.isSubscribed) {
            [WHRouter.sharedRouter open:routesInit(WHRouteOption, @{@"1": dayTexts, @"2": @(self.whichDay)}) completion:^(BOOL success, id parameters) {
                @strongify(self)
                self.whichDay = [parameters intValue];
            }];
        } else {
            [WHRouter.sharedRouter open:routesInit(WHRouteSubscribeGuide, nil)];
        }
    }];
    
    [[self.penaltyButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        if (WHSubscribeManager.sharedInstance.isSubscribed) {
            [WHRouter.sharedRouter open:routesInit(WHRoutePopUp, self.viewModel.restriction.penalty)];
        } else {
            [WHRouter.sharedRouter open:routesInit(WHRouteSubscribeGuide, nil)];
        }
    }];
}

@end
