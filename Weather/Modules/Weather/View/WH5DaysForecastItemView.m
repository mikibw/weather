//
//  WH5DaysForecastItemView.m
//  Weather
//
//  Created by Liang Tang on 2021/3/13.
//

#import "WH5DaysForecastItemView.h"
#import "WH5DaysForecastModel.h"

@interface WH5DaysForecastItemView ()
@property (weak, nonatomic) IBOutlet UILabel *weekLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *dayWeatherImageView;
@property (weak, nonatomic) IBOutlet UILabel *dayWeatherLabel;
@property (weak, nonatomic) IBOutlet UIImageView *nightWeatherImageView;
@property (weak, nonatomic) IBOutlet UILabel *nightWeatherLabel;
@property (weak, nonatomic) IBOutlet UILabel *minTempratureLabel;
@property (weak, nonatomic) IBOutlet UILabel *maxTempratureLabel;
@property (weak, nonatomic) IBOutlet UILabel *rainfallLabel;
@property (weak, nonatomic) IBOutlet UILabel *humidityLabel;
@end

@implementation WH5DaysForecastItemView

- (void)setForecast:(WH5DaysForecastModel *)forecast
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSDate *date = [formatter dateFromString:forecast.date];
    
    formatter.dateFormat = @"EEEE";
    formatter.weekdaySymbols = @[@"周日", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六"];
    self.weekLabel.text = [formatter stringFromDate:date];
    
    formatter.dateFormat = @"M/dd";
    self.dateLabel.text = [formatter stringFromDate:date];
    
    self.dayWeatherImageView.image = [UIImage weatherLineWithCode:forecast.code_day];
    self.dayWeatherLabel.text = forecast.text_day;
    
    self.nightWeatherImageView.image = [UIImage weatherLineWithCode:forecast.code_night];
    self.nightWeatherLabel.text = forecast.text_night;
    
    self.minTempratureLabel.text = [NSString stringWithFormat:@"%@℃", forecast.low];
    self.maxTempratureLabel.text = [NSString stringWithFormat:@"%@℃", forecast.high];
    
    self.rainfallLabel.text = [NSString stringWithFormat:@"%@mm", forecast.rainfall];
    self.humidityLabel.text = [NSString stringWithFormat:@"%@%%", forecast.humidity];
    
}

@end
