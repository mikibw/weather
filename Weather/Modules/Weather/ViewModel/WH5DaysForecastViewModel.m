//
//  WH5DaysForecastViewModel.m
//  Weather
//
//  Created by Liang Tang on 2021/3/13.
//

#import "WH5DaysForecastViewModel.h"
#import "WHWeatherNetwork.h"

@implementation WH5DaysForecastViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        _fetch5DaysForecast = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(WHPositionModel * _Nullable x) {
            return [[[[WHWeatherNetwork.sharedNetwork futureDaysForecastSignal:x.id days:5] map:^id _Nullable(id  _Nullable x) {
                NSArray *results = [x objectForKey:@"results"];
                return results.firstObject[@"daily"];
            }] mapObjectArray:WH5DaysForecastModel.class] catchTo:[RACSignal return:nil]];
        }];
    }
    return self;
}

@end
