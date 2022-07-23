//
//  WH24HoursForecastViewModel.m
//  Weather
//
//  Created by Liang Tang on 2021/3/13.
//

#import "WH24HoursForecastViewModel.h"
#import "WHWeatherNetwork.h"

@implementation WH24HoursForecastViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        @weakify(self)
        _fetch24HoursForecast = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(WHPositionModel * _Nullable x) {
            @strongify(self)
            return [[[[[WHWeatherNetwork.sharedNetwork h24ForecastSignal:x.id] map:^id _Nullable(id  _Nullable x) {
                NSArray *results = [x objectForKey:@"results"];
                return results.firstObject[@"hourly"];
            }] mapObjectArray:WH24HoursForecastModel.class] catchTo:[RACSignal return:nil]] doNext:^(id  _Nullable x) {
                @strongify(self)
                self->_forecasts = x;
            }];
        }];
        
    }
    return self;
}

@end
