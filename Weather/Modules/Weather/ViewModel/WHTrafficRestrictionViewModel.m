//
//  WHTrafficRestrictionViewModel.m
//  Weather
//
//  Created by Liang Tang on 2021/3/12.
//

#import "WHTrafficRestrictionViewModel.h"
#import "WHWeatherNetwork.h"

@implementation WHTrafficRestrictionViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        @weakify(self)
        _fetchTrafficRestriction = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(WHPositionModel * _Nullable x) {
            @strongify(self)
            return [[[[[WHWeatherNetwork.sharedNetwork trafficRestrictionSignal:x.id] map:^id _Nullable(id  _Nullable x) {
                NSArray *results = [x objectForKey:@"results"];
                if (results.count == 0) return nil;
                NSDictionary *dict = results.firstObject[@"restriction"];
                if (dict.count == 0) return nil;
                return dict;
            }] mapObject:WHTrafficRestrictionModel.class] catchTo:[RACSignal return:nil]] doNext:^(id  _Nullable x) {
                @strongify(self)
                self->_restriction = x;
            }];
        }];
    }
    return self;
}

@end
