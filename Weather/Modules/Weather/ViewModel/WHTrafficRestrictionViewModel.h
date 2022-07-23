//
//  WHTrafficRestrictionViewModel.h
//  Weather
//
//  Created by Liang Tang on 2021/3/12.
//

#import <Foundation/Foundation.h>
#import "WHTrafficRestrictionModel.h"

@interface WHTrafficRestrictionViewModel : NSObject
@property (nonatomic, strong, readonly) WHTrafficRestrictionModel *restriction;
@property (nonatomic, strong, readonly) RACCommand *fetchTrafficRestriction;
@end

