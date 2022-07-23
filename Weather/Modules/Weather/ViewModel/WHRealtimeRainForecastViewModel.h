//
//  WHRealtimeRainForecastViewModel.h
//  Weather
//
//  Created by Liang Tang on 2021/3/13.
//

#import <Foundation/Foundation.h>
#import "WHRealtimeRainForecastModel.h"

@interface WHRealtimeRainForecastViewModel : NSObject

@property (nonatomic, strong, readonly) RACCommand *fetchRainForecast;

@end

