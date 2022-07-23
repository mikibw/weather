//
//  WHWeatherViewModel.h
//  Weather
//
//  Created by Liang Tang on 2021/3/10.
//

#import <Foundation/Foundation.h>

@interface WHWeatherViewModel : NSObject
@property (nonatomic, strong, readonly) RACReplaySubject *positionLocating;
@property (nonatomic, strong, readonly) RACReplaySubject *positionChanged;
@property (nonatomic, strong, readonly) RACCommand *fetchPostion;
@end
