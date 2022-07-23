//
//  WHRealtimeInfoViewModel.h
//  Weather
//
//  Created by Liang Tang on 2021/3/11.
//

#import <Foundation/Foundation.h>
#import "WHRealtimeInfoModel.h"
#import "WHAirQualityModel.h"
#import "WHSunModel.h"

@interface WHRealtimeInfoViewModel : NSObject
@property (nonatomic, strong, readonly) RACCommand *fetchRealtimeInfo;
@property (nonatomic, strong, readonly) RACCommand *fetchWeatherInfos;
@end
