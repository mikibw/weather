//
//  WHMoonPhaseViewModel.h
//  Weather
//
//  Created by Liang Tang on 2021/3/13.
//

#import <Foundation/Foundation.h>
#import "WHMoonPhaseModel.h"

@interface WHMoonPhaseViewModel : NSObject
@property (nonatomic, strong, readonly) RACCommand *fetchMoonPhase;
@end
