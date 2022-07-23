//
//  WH24HoursForecastUnlockCell.h
//  Weather
//
//  Created by Liang Tang on 2021/3/14.
//

#import <UIKit/UIKit.h>

@interface WH24HoursForecastUnlockCell : UICollectionViewCell
@property (nonatomic, copy) void (^onUnlock)(void);
@end

