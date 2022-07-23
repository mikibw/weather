//
//  WHMoonPhaseViewController.m
//  Weather
//
//  Created by Liang Tang on 2021/3/11.
//

#import "WHMoonPhaseViewController.h"
#import "WHMoonPhaseViewModel.h"

@interface WHMoonPhaseViewController ()
@property (nonatomic, strong) WHMoonPhaseViewModel *viewModel;
@end

@interface WHMoonPhaseViewController ()
@property (weak, nonatomic) IBOutlet UIView *moonriseView;
@property (weak, nonatomic) IBOutlet UILabel *moonriseLabel;
@property (weak, nonatomic) IBOutlet UIView *moonsetView;
@property (weak, nonatomic) IBOutlet UILabel *moonsetLabel;
@property (weak, nonatomic) IBOutlet UILabel *phaseNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phaseLabel;
@property (weak, nonatomic) IBOutlet UIImageView *phaseImageView;
@end

@implementation WHMoonPhaseViewController

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
    self.moonriseView.layer.cornerRadius
        = self.moonsetView.layer.cornerRadius
        = 7;
    self.moonriseView.layer.borderWidth
        = self.moonsetView.layer.borderWidth
        = 1;
    self.moonriseView.layer.borderColor
        = self.moonsetView.layer.borderColor
        = UIColor.darkBorderColor.CGColor;
    [self.view.heightAnchor constraintEqualToConstant:168].active = YES;
}

- (void)bind
{
    _viewModel = [[WHMoonPhaseViewModel alloc] init];
    
    @weakify(self)
    [self.refresh subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.viewModel.fetchMoonPhase execute:x];
    }];
    
    [self.viewModel.fetchMoonPhase.executionSignals.switchToLatest subscribeNext:^(WHMoonPhaseModel * _Nullable x) {
        @strongify(self)
        if (x) {
            self.view.hidden = NO;
            self.moonriseLabel.text = x.rise;
            self.moonsetLabel.text = x.set;
            self.phaseNameLabel.text = x.phase_name;
            self.phaseLabel.text = [NSString stringWithFormat:@"月相范围 %@", x.phase];
            self.phaseImageView.image = [UIImage moonPhaseWithName:x.phase_name];
        } else {
            self.view.hidden = YES;
        }
        [self.view layoutIfNeeded];
    }];
}

@end
