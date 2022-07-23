//
//  WHMoonPhaseViewModel.m
//  Weather
//
//  Created by Liang Tang on 2021/3/13.
//

#import "WHMoonPhaseViewModel.h"
#import "WHWeatherNetwork.h"

@implementation WHMoonPhaseViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _fetchMoonPhase = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(WHPositionModel * _Nullable x) {
            return [[[[WHWeatherNetwork.sharedNetwork moonPhaseSignal:x.id days:1] map:^id _Nullable(id  _Nullable x) {
                NSArray *results = [x objectForKey:@"results"];
                results = results.firstObject[@"moon"];
                return results.firstObject;
            }] mapObject:WHMoonPhaseModel.class] catchTo:[RACSignal return:nil]];
        }];
    }
    return self;
}

@end
