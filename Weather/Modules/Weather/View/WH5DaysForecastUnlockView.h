//
//  WH5DaysForecastUnlockView.h
//  Weather
//
//  Created by Liang Tang on 2021/3/14.
//

#import "WHNibView.h"

@interface WH5DaysForecastUnlockView : WHNibView
@property (nonatomic, copy) void (^onUnlock)(void);
@end
