//
//  WH24HoursForecastCell.h
//  Weather
//
//  Created by Liang Tang on 2021/3/13.
//

#import <UIKit/UIKit.h>

@class WH24HoursForecastModel;

@interface WH24HoursForecastCell : UICollectionViewCell

- (void)showModel:(WH24HoursForecastModel *)model forHighlight:(BOOL)highlight;

@end

