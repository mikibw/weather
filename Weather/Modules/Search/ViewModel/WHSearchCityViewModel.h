//
//  WHSearchCityViewModel.h
//  Weather
//
//  Created by shoujian on 2021/3/13.
//

#import <Foundation/Foundation.h>
#import "WHPositionModel.h"

@interface WHSearchCityViewModel : NSObject

@property (nonatomic, strong, readonly) RACCommand *searchCityCommand;



@end


