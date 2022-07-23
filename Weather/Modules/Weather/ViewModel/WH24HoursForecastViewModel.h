//
//  WH24HoursForecastViewModel.h
//  Weather
//
//  Created by Liang Tang on 2021/3/13.
//

#import <Foundation/Foundation.h>
#import "WH24HoursForecastModel.h"

@interface WH24HoursForecastViewModel : NSObject
@property (nonatomic, strong, readonly) NSArray *forecasts;
@property (nonatomic, strong, readonly) RACCommand *fetch24HoursForecast;
@end
