//
//  WHAirQualityModel.h
//  Weather
//
//  Created by Liang Tang on 2021/3/12.
//

#import <Foundation/Foundation.h>

@interface WHAirQualityModel : NSObject
@property (nonatomic , copy) NSString              * aqi;
@property (nonatomic , copy) NSString              * pm25;
@property (nonatomic , copy) NSString              * pm10;
@property (nonatomic , copy) NSString              * so2;
@property (nonatomic , copy) NSString              * no2;
@property (nonatomic , copy) NSString              * co;
@property (nonatomic , copy) NSString              * o3;
@property (nonatomic , copy) NSString              * primary_pollutant;
@property (nonatomic , copy) NSString              * quality;
@property (nonatomic , copy) NSString              * last_update;
@end
