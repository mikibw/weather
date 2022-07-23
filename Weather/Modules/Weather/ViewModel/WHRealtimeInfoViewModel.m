//
//  WHRealtimeInfoViewModel.m
//  Weather
//
//  Created by Liang Tang on 2021/3/11.
//

#import "WHRealtimeInfoViewModel.h"
#import "WHWeatherNetwork.h"

@implementation WHRealtimeInfoViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        _fetchRealtimeInfo = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(WHPositionModel * _Nullable x) {
            NSArray *signals = @[
                [[WHWeatherNetwork.sharedNetwork realtimeInfoSignal:x.id] catchTo:[RACSignal return:nil]],
                [[WHWeatherNetwork.sharedNetwork airQualitySignal:x.id] catchTo:[RACSignal return:nil]],
                [[WHWeatherNetwork.sharedNetwork sunSignal:x.id days:1] catchTo:[RACSignal return:nil]]
            ];
            
            return [[[RACSignal combineLatest:signals] map:^id _Nullable(RACTuple * _Nullable x) {
                RACTupleUnpack(id x1, id x2, id x3) = x;
                
                NSArray *results = [x1 objectForKey:@"results"];
                WHRealtimeInfoModel *m1 = [WHRealtimeInfoModel mj_objectWithKeyValues:results.firstObject[@"now"]];
                
                results = [x2 objectForKey:@"results"];
                id air = results.firstObject[@"air"];
                WHAirQualityModel *m2 = nil;
                if ([air isKindOfClass:NSDictionary.class]) {
                    // 妈的还返回一个字符串给我，什么破玩意接口，这里必须判断一下
                    m2 = [WHAirQualityModel mj_objectWithKeyValues:air[@"city"]];
                }
                
                results = [x3 objectForKey:@"results"];
                WHSunModel *m3 = [WHSunModel mj_objectWithKeyValues:[results.firstObject[@"sun"] firstObject]];
                
                return RACTuplePack(m1, m2, m3);
            }] catchTo:[RACSignal return:nil]];
        }];
        
        
        _fetchWeatherInfos = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(NSArray<WHPositionModel *> *positionArr) {
            NSMutableArray *signals = [NSMutableArray new];
            for (WHPositionModel *position in positionArr) {
                RACSignal *signal = [[[WHWeatherNetwork.sharedNetwork realtimeInfoSignal:position.id] map:^id _Nullable(id  _Nullable value) {
                    NSArray *results = [value objectForKey:@"results"];
                    WHRealtimeInfoModel *model = [WHRealtimeInfoModel mj_objectWithKeyValues:results.firstObject[@"now"]];
                    NSDictionary *dict = results.firstObject[@"location"];
                    NSString *locationId = dict[@"id"];
                    return RACTuplePack(locationId, model);
                }] catchTo:[RACSignal return:nil]];
                
                [signals addObject:signal];
            }
            return [[RACSignal merge:signals] catchTo:[RACSignal return:nil]];
//            return [[RACSignal combineLatest:signals] catchTo:[RACSignal return:nil]];
        }];
    }
    return self;
}

@end
