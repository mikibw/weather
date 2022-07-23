//
//  WH24HoursForecastUnlockCell.m
//  Weather
//
//  Created by Liang Tang on 2021/3/14.
//

#import "WH24HoursForecastUnlockCell.h"

@implementation WH24HoursForecastUnlockCell

- (IBAction)unlock
{
    !self.onUnlock ?: self.onUnlock();
}

@end
