//
//  WHMeteDisasterWarningViewModel.h
//  Weather
//
//  Created by Liang Tang on 2021/3/13.
//

#import <Foundation/Foundation.h>
#import "WHMeteDisasterWarningModel.h"

@interface WHMeteDisasterWarningViewModel : NSObject

@property (nonatomic, strong, readonly) NSArray <WHMeteDisasterWarningModel *> *warnings;
@property (nonatomic, strong, readonly) RACCommand *fetchDisasterWarnings;

@end
