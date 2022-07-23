//
//  WH5DaysForecastViewModel.h
//  Weather
//
//  Created by Liang Tang on 2021/3/13.
//

#import <Foundation/Foundation.h>
#import "WH5DaysForecastModel.h"

@interface WH5DaysForecastViewModel : NSObject
@property (nonatomic, strong, readonly) RACCommand *fetch5DaysForecast;
@end
