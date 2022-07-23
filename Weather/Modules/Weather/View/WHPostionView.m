//
//  WHPostionView.m
//  Weather
//
//  Created by Liang Tang on 2021/3/10.
//

#import "WHPostionView.h"

@interface WHPostionView ()
@property (nonatomic, strong) NSTimer *timer;
@property (weak, nonatomic) IBOutlet UIButton *button;
@property (weak, nonatomic) IBOutlet UILabel *locLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@end

@implementation WHPostionView

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self startTimer];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self startTimer];
    }
    return self;
}

- (void)setPosition:(WHPositionModel *)position
{
    self.locLabel.hidden = NO;
    self.locLabel.text = position.name;
}

- (void)startTimer
{
    @weakify(self)
    void (^block)(NSTimer *) = ^(NSTimer *timer) {
        @strongify(self)
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.weekdaySymbols = @[@"周日", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六"];
        formatter.dateFormat = @"EEEE MM月dd h: mm a";;
        self.timeLabel.text = [formatter stringFromDate:NSDate.date];
    };
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:block];
    block(self.timer);
}

- (IBAction)search
{
    !self.onSearch ?: self.onSearch();
}

@end
