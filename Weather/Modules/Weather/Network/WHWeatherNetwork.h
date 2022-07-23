//
//  WHWeatherNetwork.h
//  Weather
//
//  Created by Liang Tang on 2021/3/11.
//

#import <Foundation/Foundation.h>

@interface WHWeatherNetwork : NSObject

+ (instancetype)sharedNetwork;

- (RACSignal *)postionSignal:(NSString *)loc limit:(int)limit;
- (RACSignal *)realtimeInfoSignal:(NSString *)loc;
- (RACSignal *)h24ForecastSignal:(NSString *)loc;
- (RACSignal *)futureDaysForecastSignal:(NSString *)loc days:(int)days;
- (RACSignal *)airQualitySignal:(NSString *)loc;
- (RACSignal *)sunSignal:(NSString *)loc days:(int)days;
- (RACSignal *)realtimeRainForecastSignal:(NSString *)loc;
- (RACSignal *)moonPhaseSignal:(NSString *)loc days:(int)days;
- (RACSignal *)trafficRestrictionSignal:(NSString *)loc;
- (RACSignal *)lifeIndexSignal:(NSString *)loc;
- (RACSignal *)disasterWarningSignal:(NSString *)loc;

- (RACSignal *)searchCitySignal:(NSString *)q limit:(int)limit;//搜索城市
- (RACSignal *)subscribeVersionSignal:(NSString *)vv app:(NSString *)app;//订阅版本信息
@end
