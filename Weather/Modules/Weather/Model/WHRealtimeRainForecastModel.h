//
//  WHRealtimeRainForecastModel.h
//  Weather
//
//  Created by Liang Tang on 2021/3/13.
//

#import <Foundation/Foundation.h>

@interface WHRealtimeRainForecastModel : NSObject
@property (nonatomic , copy) NSString              * text;
@property (nonatomic , strong) NSArray <NSNumber *>              * precipitation;
@end
