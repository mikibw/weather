//
//  WHTrafficRestrictionModel.m
//  Weather
//
//  Created by Liang Tang on 2021/3/12.
//

#import "WHTrafficRestrictionModel.h"

@implementation WHTrafficRestrictionLimitModel

@end

@implementation WHTrafficRestrictionModel

+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"limits": WHTrafficRestrictionLimitModel.class};
}

@end
