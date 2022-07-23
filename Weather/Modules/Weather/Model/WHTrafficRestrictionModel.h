//
//  WHTrafficRestrictionModel.h
//  Weather
//
//  Created by Liang Tang on 2021/3/12.
//

#import <Foundation/Foundation.h>

@interface WHTrafficRestrictionLimitModel : NSObject
@property (nonatomic , copy) NSString              * date;
@property (nonatomic , strong) NSArray <NSString *>              * plates;
@property (nonatomic , copy) NSString              * memo;
@end

@interface WHTrafficRestrictionModel : NSObject
@property (nonatomic , copy) NSString              * penalty;
@property (nonatomic , copy) NSString              * region;
@property (nonatomic , copy) NSString              * time;
@property (nonatomic , copy) NSString              * remarks;
@property (nonatomic , strong) NSArray <WHTrafficRestrictionLimitModel *>              * limits;
@end

