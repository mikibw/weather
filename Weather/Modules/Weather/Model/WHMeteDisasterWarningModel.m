//
//  WHMeteDisasterWarningModel.m
//  Weather
//
//  Created by shoujian on 2021/3/12.
//

#import "WHMeteDisasterWarningModel.h"

@implementation WHMeteDisasterWarningModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"desc": @"description"};
}

@end
