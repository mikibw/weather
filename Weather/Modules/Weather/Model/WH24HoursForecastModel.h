//
//  WH24HoursForecastModel.h
//  Weather
//
//  Created by Liang Tang on 2021/3/13.
//

#import <Foundation/Foundation.h>

@interface WH24HoursForecastModel : NSObject
@property (nonatomic , copy) NSString              * time;
@property (nonatomic , copy) NSString              * text;
@property (nonatomic , copy) NSString              * code;
@property (nonatomic , copy) NSString              * temperature;
@property (nonatomic , copy) NSString              * humidity;
@property (nonatomic , copy) NSString              * wind_direction;
@property (nonatomic , copy) NSString              * wind_speed;
@end
