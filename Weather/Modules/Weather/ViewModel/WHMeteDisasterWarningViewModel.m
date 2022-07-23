//
//  WHMeteDisasterWarningViewModel.m
//  Weather
//
//  Created by Liang Tang on 2021/3/13.
//

#import "WHMeteDisasterWarningViewModel.h"
#import "WHWeatherNetwork.h"

@implementation WHMeteDisasterWarningViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        @weakify(self)
        _fetchDisasterWarnings = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(WHPositionModel * _Nullable x) {
            @strongify(self)
            return [[[[[WHWeatherNetwork.sharedNetwork disasterWarningSignal:x.id] map:^id _Nullable(id  _Nullable x) {
                NSArray *results = [x objectForKey:@"results"];
                if (results.count == 0) return nil;
                return results.firstObject[@"alarms"];
            }] mapObjectArray:WHMeteDisasterWarningModel.class] catchTo:[RACSignal return:nil]] doNext:^(id  _Nullable x) {
                @strongify(self)
                self->_warnings = x;
            }];
        }];
    }
    return self;
}

@end
