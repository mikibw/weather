//
//  WH5DaysForecastItemView.h
//  Weather
//
//  Created by Liang Tang on 2021/3/13.
//

#import "WHNibView.h"

@class WH5DaysForecastModel;

@interface WH5DaysForecastItemView : WHNibView
- (void)setForecast:(WH5DaysForecastModel *)forecast;
@end
