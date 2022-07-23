//
//  WH5DaysForecastModel.h
//  Weather
//
//  Created by Liang Tang on 2021/3/13.
//

#import <Foundation/Foundation.h>

@interface WH5DaysForecastModel : NSObject
@property (nonatomic , copy) NSString              * date;
@property (nonatomic , copy) NSString              * text_day;
@property (nonatomic , copy) NSString              * code_day;
@property (nonatomic , copy) NSString              * text_night;
@property (nonatomic , copy) NSString              * code_night;
@property (nonatomic , copy) NSString              * high;
@property (nonatomic , copy) NSString              * low;
@property (nonatomic , copy) NSString              * rainfall;
@property (nonatomic , copy) NSString              * precip;
@property (nonatomic , copy) NSString              * wind_direction;
@property (nonatomic , copy) NSString              * wind_direction_degree;
@property (nonatomic , copy) NSString              * wind_speed;
@property (nonatomic , copy) NSString              * wind_scale;
@property (nonatomic , copy) NSString              * humidity;
@end

