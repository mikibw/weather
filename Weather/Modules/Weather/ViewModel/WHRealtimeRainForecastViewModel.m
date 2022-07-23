//
//  WHRealtimeRainForecastViewModel.m
//  Weather
//
//  Created by Liang Tang on 2021/3/13.
//

#import "WHRealtimeRainForecastViewModel.h"
#import "WHWeatherNetwork.h"

@implementation WHRealtimeRainForecastViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _fetchRainForecast = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(WHPositionModel * _Nullable x) {
            return [[[[WHWeatherNetwork.sharedNetwork realtimeRainForecastSignal:x.id] map:^id _Nullable(id  _Nullable x) {
                NSArray *results = [x objectForKey:@"results"];
                return results.firstObject;
            }] mapObject:WHRealtimeRainForecastModel.class] catchTo:[RACSignal return:nil]];
        }];
    }
    return self;
}

@end
