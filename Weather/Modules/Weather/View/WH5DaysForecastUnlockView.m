//
//  WH5DaysForecastUnlockView.m
//  Weather
//
//  Created by Liang Tang on 2021/3/14.
//

#import "WH5DaysForecastUnlockView.h"

@interface WH5DaysForecastUnlockView ()
@end

@implementation WH5DaysForecastUnlockView

- (IBAction)unlock
{
    !self.onUnlock ?: self.onUnlock();
}

@end
