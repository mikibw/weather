//
//  WHSearchCityViewModel.m
//  Weather
//
//  Created by shoujian on 2021/3/13.
//

#import "WHSearchCityViewModel.h"
#import "WHWeatherNetwork.h"

@implementation WHSearchCityViewModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        _searchCityCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(NSString * _Nullable x) {
            
            
            return [[[[WHWeatherNetwork.sharedNetwork searchCitySignal:x limit:0] map:^id _Nullable(id  _Nullable x) {
                NSArray *tmpArr = [x objectForKey:@"results"];
                NSMutableArray *results = [NSMutableArray new];
                for (NSDictionary *dict in tmpArr) {
                    if ([dict[@"country"] isEqualToString:@"CN"]) {
                        [results addObject:dict];
                    }
                }
                return results;
            }] mapObjectArray:WHPositionModel.class] catchTo:[RACSignal return:nil]];
        }];
    }
    return self;
}

@end
