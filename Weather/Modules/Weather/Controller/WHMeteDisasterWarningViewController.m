//
//  WHMeteDisasterWarningViewController.m
//  Weather
//
//  Created by Liang Tang on 2021/3/11.
//

#import "WHMeteDisasterWarningViewController.h"
#import "WHMeteDisasterWarningViewModel.h"

@interface WHMeteDisasterWarningViewController ()
@property (nonatomic, assign) int selectedIndex;
@property (nonatomic, strong) WHMeteDisasterWarningViewModel *viewModel;
@end

@interface WHMeteDisasterWarningViewController ()
@property (weak, nonatomic) IBOutlet UIButton *previousButton;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UIStackView *disasterView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *disasterTypeImageView;
@property (weak, nonatomic) IBOutlet UILabel *disasterTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *disasterLevelLabel;
@property (weak, nonatomic) IBOutlet UILabel *disasterDateLabel;
@property (weak, nonatomic) IBOutlet UIView *descView;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UIView *emptyView;
@property (weak, nonatomic) IBOutlet UIView *unlockView;
@property (weak, nonatomic) IBOutlet UIButton *unlockButton;
@end

@interface WHMeteDisasterWarningViewController ()
@property (nonatomic, strong) RACDisposable *disposable;
@end

@implementation WHMeteDisasterWarningViewController

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
    [self setupUI];
    [self bind];
}

- (void)setupUI
{
    self.view.hidden = YES;
    
    self.descView.layer.borderWidth = 1;
    self.descView.layer.borderColor = UIColor.lightBorderColor.CGColor;
}

- (void)bind
{
    _viewModel = [[WHMeteDisasterWarningViewModel alloc] init];
    
    @weakify(self)
    [self.refresh subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.viewModel.fetchDisasterWarnings execute:x];
    }];
    
    [self.viewModel.fetchDisasterWarnings.executionSignals.switchToLatest subscribeNext:^(NSArray * _Nullable x) {
        @strongify(self)
        self.view.hidden = NO;
        self.selectedIndex = 0;
    }];
    
    NSArray *signals = @[
        RACObserve(self, selectedIndex),
        WHSubscribeManager.sharedInstance.subscribeChanged
    ];
    [[RACSignal combineLatest:signals] subscribeNext:^(RACTuple *value) {
        @strongify(self)
        RACTupleUnpack(NSNumber *x, NSNumber * isSubscribed) = value;
        if (!isSubscribed.boolValue) {
            self.previousButton.hidden = YES;
            self.nextButton.hidden = YES;
            self.disasterView.hidden = YES;
            self.emptyView.hidden = YES;
            self.unlockView.hidden = NO;
        } else {
            if (self.viewModel.warnings.count == 0) {
                self.previousButton.hidden = YES;
                self.nextButton.hidden = YES;
                self.disasterView.hidden = YES;
                self.emptyView.hidden = NO;
            } else {
                self.previousButton.hidden = x.intValue == 0;
                self.nextButton.hidden = x.intValue >= self.viewModel.warnings.count - 1;
                self.disasterView.hidden = NO;
                WHMeteDisasterWarningModel *warning = self.viewModel.warnings[x.intValue];
                self.titleLabel.text = warning.title;
                self.disasterTypeImageView.image = [UIImage disasterWithType:warning.type level:warning.level];
                self.disasterTypeLabel.text = warning.type;
                self.disasterLevelLabel.text = warning.level;
                self.disasterDateLabel.text = [NSString stringWithFormat:@"%@ %@",
                                               [warning.pub_date substringWithRange:NSMakeRange(0, 10)],
                                               [warning.pub_date substringWithRange:NSMakeRange(11, 5)]];
                self.descLabel.text = warning.desc;
                self.emptyView.hidden = YES;
            }
            self.unlockView.hidden = YES;
        }
        [self.view layoutIfNeeded];
    }];
    
    [[self.previousButton rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        self.selectedIndex -= 1;
    }];
    
    [[self.nextButton rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        self.selectedIndex += 1;
    }];
    
    [[self.unlockButton rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(__kindof UIControl * _Nullable x) {
        [WHRouter.sharedRouter open:routesInit(WHRouteSubscribeGuide, nil)];
    }];
}

@end
