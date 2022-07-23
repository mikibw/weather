//
//  WH24HoursForecastCell.m
//  Weather
//
//  Created by Liang Tang on 2021/3/13.
//

#import "WH24HoursForecastCell.h"
#import "WH24HoursForecastModel.h"

@interface WH24HoursForecastCell ()
@property (weak, nonatomic) IBOutlet UIView *wrappedView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *weatherImageView;
@property (weak, nonatomic) IBOutlet UILabel *tempratureLabel;
@property (weak, nonatomic) IBOutlet UILabel *windSpeedLabel;
@property (nonatomic, weak) CAGradientLayer *grandientLayer;
@end

@implementation WH24HoursForecastCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    CAGradientLayer *grandientLayer = [CAGradientLayer layer];
    grandientLayer.cornerRadius = 14;
    grandientLayer.colors = @[
        (__bridge id)[UIColor colorWithHex:0x7daeff alpha:1.0].CGColor,
        (__bridge id)[UIColor colorWithHex:0x5995fc alpha:1.0].CGColor
    ];
    grandientLayer.locations = @[@(0), @(1.0f)];
    grandientLayer.startPoint = CGPointMake(0.5, 0.11);
    grandientLayer.endPoint = CGPointMake(0.79, 1);
    [self.wrappedView.layer insertSublayer:grandientLayer atIndex:0];
    
    self.grandientLayer = grandientLayer;
    
    self.wrappedView.layer.borderColor = UIColor.lightBorderColor.CGColor;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.grandientLayer.frame = self.wrappedView.bounds;
}

- (void)showModel:(WH24HoursForecastModel *)model forHighlight:(BOOL)highlight
{
    if (highlight) {
        self.grandientLayer.hidden = NO;
        self.wrappedView.layer.borderWidth = 0;
        self.timeLabel.textColor = UIColor.whiteColor;
        self.tempratureLabel.textColor = UIColor.whiteColor;
        self.windSpeedLabel.textColor = UIColor.whiteColor;
    } else {
        self.grandientLayer.hidden = YES;
        self.wrappedView.layer.borderWidth = 1;
        self.timeLabel.textColor = UIColor.blackColor;
        self.tempratureLabel.textColor = UIColor.lightTextColor;
        self.windSpeedLabel.textColor = UIColor.lightTextColor;
    }
    if (highlight) {
        self.timeLabel.text = @"现在";
        self.weatherImageView.image = [UIImage weatherIconWithCode:model.code];
    } else {
        self.timeLabel.text = [model.time substringWithRange:NSMakeRange(11, 5)];
        self.weatherImageView.image = [UIImage weatherLineWithCode:model.code];
    }
    self.tempratureLabel.text = [NSString stringWithFormat:@"%@℃", model.temperature];
    self.windSpeedLabel.text = model.wind_speed;
}


@end
