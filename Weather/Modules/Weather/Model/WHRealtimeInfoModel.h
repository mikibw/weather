//
//  WHRealtimeInfoModel.h
//  Weather
//
//  Created by Liang Tang on 2021/3/11.
//

#import <Foundation/Foundation.h>

@interface WHRealtimeInfoModel : NSObject
@property (nonatomic , copy) NSString              * text;
@property (nonatomic , copy) NSString              * code;
@property (nonatomic , copy) NSString              * temperature;
@property (nonatomic , copy) NSString              * feels_like;
@property (nonatomic , copy) NSString              * pressure;
@property (nonatomic , copy) NSString              * humidity;
@property (nonatomic , copy) NSString              * visibility;
@property (nonatomic , copy) NSString              * wind_direction;
@property (nonatomic , copy) NSString              * wind_direction_degree;
@property (nonatomic , copy) NSString              * wind_speed;
@property (nonatomic , copy) NSString              * wind_scale;
@property (nonatomic , copy) NSString              * clouds;
@property (nonatomic , copy) NSString              * dew_point;
@end
